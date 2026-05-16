using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Login : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Auto-login using cookie
                if (Session["A_id"] == null && Request.Cookies["AdminInfo"] != null)
                {
                    string uid = Request.Cookies["AdminInfo"]["A_id"];
                    if (!string.IsNullOrEmpty(uid))
                    {
                        Session["A_id"] = uid;
                        Response.Redirect("AdminDashboard.aspx");
                    }
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string identifier = txtEmail.Text.Trim();
            string enteredPassword = txtPassword.Text.Trim();

            // Generate the MD5 hash version of the entered password
            string hashedInputPassword = GetMD5Hash(enteredPassword);

            bool loginSuccess = false;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                // Select user data by email or phone first, checking password matching logic inside C#
                string query = "SELECT admin_id, name, email, password, phone_no FROM tblAdmin WHERE email = @id OR phone_no = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", identifier);
                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string dbPassword = dr["password"]?.ToString();

                            // DUAL VERIFICATION LOGIC:
                            // Check 1: Match directly if password in DB is plain text
                            // Check 2: Match using the MD5 hash if password in DB is encrypted
                            if (enteredPassword == dbPassword || hashedInputPassword == dbPassword)
                            {
                                loginSuccess = true;

                                // Set admin session values
                                Session["A_id"] = dr["admin_id"].ToString();
                                Session["A_name"] = dr["name"].ToString();
                                Session["A_email"] = dr["email"].ToString();
                                Session["A_pass"] = dbPassword;
                                Session["A_phone"] = dr["phone_no"].ToString();

                                // Create a cookie for Auto-Login
                                HttpCookie adminCookie = new HttpCookie("AdminInfo");
                                adminCookie["A_id"] = dr["admin_id"].ToString();
                                adminCookie.Expires = DateTime.Now.AddDays(1);
                                Response.Cookies.Add(adminCookie);
                            }
                        }
                    }
                }
            }

            if (loginSuccess)
            {
                Response.Redirect("AdminDashboard.aspx");
            }
            else
            {
                // Display SweetAlert error if login fails
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'Invalid User or Password',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);
            }
        }

        // MD5 Hashing utility method matching ForgotPassword implementation
        private string GetMD5Hash(string input)
        {
            using (System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create())
            {
                byte[] inputBytes = Encoding.UTF8.GetBytes(input);
                byte[] hashBytes = md5.ComputeHash(inputBytes);
                StringBuilder sb = new StringBuilder();
                foreach (byte b in hashBytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }
    }
}