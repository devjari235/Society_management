using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;
using System.Configuration;

namespace Society_management
{
    public partial class U_EmailSend : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindEmail();
            }
        }
        string email;
        public void BindEmail()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = "SELECT Email FROM tblUser WHERE User_id = @id";
                using (SqlCommand cmd = new SqlCommand(Query, con))
                {
                    cmd.Parameters.AddWithValue("@id", Session["U_id"]?.ToString());
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            email = reader["Email"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnSendOtp_Click(object sender, EventArgs e)
        {
            BindEmail();
            string toEmail = txtEmail.Text.Trim();
            string otp = new Random().Next(100000, 999999).ToString();

            try
            {
                if (!string.IsNullOrEmpty(email) && email.Equals(toEmail, StringComparison.OrdinalIgnoreCase))
                {
                    SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587)
                    {
                        EnableSsl = true,
                        Credentials = new NetworkCredential("harshgilitwala22@gmail.com", "owsnmljtqalqapyt")
                    };

                    MailMessage mail = new MailMessage("harshgilitwala22@gmail.com", toEmail, "Your SocietyConnect OTP",
                        "Dear resident, your SocietyConnect verification code is: " + otp + ". Do not share this code with anyone.");
                    smtp.Send(mail);

                    Session["OTP"] = otp;
                    Session["OTPGeneratedTime"] = DateTime.Now;
                    Session["EmailToVerify"] = toEmail;

                    Response.Redirect("VerifyOtpUser.aspx");
                }
                else
                {
                    string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'Invalid Email Id',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";
                    ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);
                }
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Error: " + ex.Message;
            }
        }
    }
}