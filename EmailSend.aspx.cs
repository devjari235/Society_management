using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class EmailSend : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

            protected void btnSendOtp_Click(object sender, EventArgs e)
            {
                string toEmail = txtEmail.Text;
                string otp = new Random().Next(100000, 999999).ToString();

                try
                {
                    SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587)
                    {
                        EnableSsl = true,
                        Credentials = new NetworkCredential("harshgilitwala22@gmail.com", "owsnmljtqalqapyt")
                    };

                    MailMessage mail = new MailMessage("harshgilitwala22@gmail.com", toEmail, "Your SocietyConnect OTP",
                        "Dear resident, your SocietyConnect verification code is: " + otp + ". Do not share this code with anyone.");
                    smtp.Send(mail);

                    // Store OTP and metadata in session
                    Session["OTP"] = otp;
                    Session["OTPGeneratedTime"] = DateTime.Now;
                    Session["EmailToVerify"] = toEmail;

                    // Redirect to OTP verification page
                    Response.Redirect("VerifyOtp.aspx");
                }
                catch (Exception ex)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
        }
    }