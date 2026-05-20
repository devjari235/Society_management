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

            string hashedInputPassword = GetMD5Hash(enteredPassword);

            bool loginSuccess = false;
            bool notAssigned = false;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT a.admin_id, a.name, a.email, a.password, a.phone_no,
                                s.Society_id
                         FROM tblAdmin a
                         LEFT JOIN tblSociety s ON s.admin_id = a.admin_id
                         WHERE a.email = @id OR a.phone_no = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", identifier);
                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string dbPassword = dr["password"]?.ToString();

                            if (enteredPassword == dbPassword || hashedInputPassword == dbPassword)
                            {
                                // ✅ Check if society is assigned via tblSociety.admin_id
                                string societyId = dr["Society_id"]?.ToString();

                                if (string.IsNullOrEmpty(societyId))
                                {
                                    notAssigned = true; // Credentials correct but no society assigned
                                }
                                else
                                {
                                    loginSuccess = true;

                                    Session["A_id"] = dr["admin_id"].ToString();
                                    Session["A_name"] = dr["name"].ToString();
                                    Session["A_email"] = dr["email"].ToString();
                                    Session["A_pass"] = dbPassword;
                                    Session["A_phone"] = dr["phone_no"].ToString();
                                    Session["A_societyId"] = societyId; // ✅ Store for later use

                                    HttpCookie adminCookie = new HttpCookie("AdminInfo");
                                    adminCookie["A_id"] = dr["admin_id"].ToString();
                                    adminCookie.Expires = DateTime.Now.AddDays(1);
                                    Response.Cookies.Add(adminCookie);
                                }
                            }
                        }
                    }
                }
            }

            if (loginSuccess)
            {
                Response.Redirect("AdminDashboard.aspx");
            }
            else if (notAssigned)
            {
                // 🚫 No society assigned alert
                string script = @"
            <script>
                Swal.fire({
                    icon: 'warning',
                    title: 'Access Restricted',
                    text: 'No society has been assigned to your account. Please contact the developer.',
                    confirmButtonColor: '#f0ad4e',
                    confirmButtonText: 'OK'
                });
            </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "NotAssigned", script);
            }
            else
            {
                // ❌ Wrong credentials alert
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