using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;

namespace Society_management
{
    public partial class U_login : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 🧠 Auto-login using cookie
                if (Session["U_id"] == null && Request.Cookies["UserInfo"] != null)
                {
                    string uid = Request.Cookies["UserInfo"]["U_id"];
                    if (!string.IsNullOrEmpty(uid))
                    {
                        Session["U_id"] = uid;
                        Response.Redirect("UserDashboard.aspx");
                    }
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string emailOrPhone = txtEmail.Text.Trim();
            string rawPassword = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(emailOrPhone) || string.IsNullOrEmpty(rawPassword))
            {
                ShowErrorAlert("Fields cannot be empty");
                return;
            }

            // Generate MD5 hash variant of input password to match encrypted DB fields
            string encryptedPassword = GetMd5Hash(rawPassword);

            using (SqlConnection con = new SqlConnection(strcon))
            {
                // Checks matching patterns for either raw text input or encrypted string formats
                string query = @"
                    SELECT User_id FROM tblUser 
                    WHERE (Email = @identifier OR Phone_no = @identifier)
                    AND (Password COLLATE SQL_Latin1_General_CP1_CS_AS = @rawPass 
                         OR Password = @encryptedPass)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@identifier", emailOrPhone);
                    cmd.Parameters.AddWithValue("@rawPass", rawPassword);
                    cmd.Parameters.AddWithValue("@encryptedPass", encryptedPassword);

                    try
                    {
                        con.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                // Account validation matching found! Fetch User ID
                                string userId = dr["User_id"].ToString();
                                Session["U_id"] = userId;

                                // Establish persistent authentication token footprints via cookies
                                HttpCookie userCookie = new HttpCookie("UserInfo");
                                userCookie["U_id"] = userId;
                                userCookie.Expires = DateTime.Now.AddDays(15); // Keeps the cookie active for 15 days
                                Response.Cookies.Add(userCookie);

                                Response.Redirect("UserDashboard.aspx", false);
                                Context.ApplicationInstance.CompleteRequest();
                            }
                            else
                            {
                                ShowErrorAlert("Invalid User or Password");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowErrorAlert("Database Connection Error. Try again later.");
                        System.Diagnostics.Debug.WriteLine($"Login Execution Failure: {ex.Message}");
                    }
                }
            }
        }

        // Helper cryptographic component mapping MD5 outputs matching your ForgotPassword module
        private string GetMd5Hash(string input)
        {
            using (MD5 md5 = MD5.Create())
            {
                byte[] inputBytes = Encoding.UTF8.GetBytes(input);
                byte[] hashBytes = md5.ComputeHash(inputBytes);
                StringBuilder sb = new StringBuilder();
                foreach (byte b in hashBytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private void ShowErrorAlert(string message)
        {
            string script = $@"
                <script>
                    Swal.fire({{
                        icon: 'error',
                        title: 'Oops...',
                        text: '{message}',
                        confirmButtonColor: '#d33',
                        confirmButtonText: 'Try Again'
                    }});
                </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);
        }
    }
}