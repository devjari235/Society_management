using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class VerifyOtp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EmailToVerify"] == null)
            {
                Response.Redirect("Register.aspx");
            }
        }

            protected void btnVerifyOtp_Click(object sender, EventArgs e)
            {
                // Get the OTP from the hidden field instead of textbox
                string userOtp = txtOtp.Value.Trim(); // Changed from txtOtp.Text to txtOtp.Value
                string storedOtp = Session["OTP"]?.ToString();
                DateTime? otpTime = Session["OTPGeneratedTime"] as DateTime?;
                int expiryMinutes = int.Parse(ConfigurationManager.AppSettings["OtpExpiryMinutes"]);

                if (string.IsNullOrEmpty(storedOtp) || !otpTime.HasValue)
                {
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'OTP expired or invalid. Please request a new one.',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "otpError", script);
                    return;
                }

                if (DateTime.Now > otpTime.Value.AddMinutes(expiryMinutes))
                {
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'OTP has expired. Please request a new one.',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "otpError", script);
                    return;
                }

                if (userOtp.Length != 6)
                {
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'Please enter a complete 6-digit OTP code.',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "otpError", script);
                    return;
                }

                if (userOtp == storedOtp)
                {
                    Session["EmailVerified"] = true;
                string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Email verified successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'ChangePassOtp.aspx';
            });";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                    

                    // Optional: Redirect after delay
                    // Response.AddHeader("REFRESH", "3;URL=Success.aspx");
                }
                else
                {
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'Invalid OTP. Please try again.',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "otpError", script);
                }
            }
        }
    }
