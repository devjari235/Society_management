using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web.UI;

namespace Society_management
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hdnCurrentStep.Value = "1";
                hdnIdentifier.Value = "";
                hdnMethod.Value = "Email";
                hdnOTP.Value = "";

                rbEmail.Enabled = true;
                rbSMS.Enabled = true;

                // Initialize tracking parameters
                Session["ResetUserRole"] = null;
                Session["FinalRedirectTarget"] = null;
                Session["MaskedEmail"] = null;
                Session["MaskedSMS"] = null;
            }
        }

        protected void btnCheckIdentifier_Click(object sender, EventArgs e)
        {
            try
            {
                string identifier = txtIdentifier.Text.Trim();
                if (string.IsNullOrEmpty(identifier))
                {
                    lblIdentifierError.Text = "Please enter email or mobile number";
                    return;
                }

                string email = null;
                bool found = false;

                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();

                    // 1. Check tblAdmin (Always search by both parameters)
                    string query = "SELECT email FROM tblAdmin WHERE email = @id OR phone_no = @id";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                found = true;
                                email = dr["email"]?.ToString();
                                Session["ResetUserRole"] = "Admin";
                            }
                        }
                    }

                    // 2. If not an Admin, check tblUser
                    if (!found)
                    {
                        query = "SELECT Email FROM tblUser WHERE Email = @id OR Phone_no = @id";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@id", identifier);
                            using (SqlDataReader dr = cmd.ExecuteReader())
                            {
                                if (dr.Read())
                                {
                                    found = true;
                                    email = dr["Email"]?.ToString();
                                    Session["ResetUserRole"] = "User";
                                }
                            }
                        }
                    }
                }

                // If the identifier didn't match any record in either table
                if (!found || string.IsNullOrEmpty(email))
                {
                    lblIdentifierError.Text = "No account found with this email or mobile number";
                    hdnCurrentStep.Value = "1";
                    return;
                }

                lblIdentifierError.Text = "";
                hdnIdentifier.Value = identifier;
                hdnMethod.Value = "Email"; // Force email delivery channel automatically

                // Secure string masking logic (e.g., dim***55@gmail.com)
                var parts = email.Split('@');
                string maskedEmail = "";
                if (parts[0].Length > 3)
                {
                    maskedEmail = parts[0].Substring(0, 3) + "***" + parts[0].Substring(parts[0].Length - 2) + "@" + parts[1];
                }
                else
                {
                    maskedEmail = parts[0].Substring(0, 1) + "***@" + parts[1];
                }

                Session["MaskedEmail"] = maskedEmail;

                // Generate the 6-Digit OTP immediately
                string otp = GenerateOTP();

                // Save the generated OTP token line to database
                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();
                    string invalidate = "UPDATE tblPasswordReset SET IsUsed = 1 WHERE Identifier = @id AND IsUsed = 0";
                    using (SqlCommand cmd = new SqlCommand(invalidate, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        cmd.ExecuteNonQuery();
                    }

                    string insert = @"INSERT INTO tblPasswordReset (Identifier, OTP, DeliveryMethod, ExpiryTime, IsUsed, CreatedDate)  
                              VALUES (@id, @otp, 'Email', DATEADD(MINUTE, 10, GETDATE()), 0, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(insert, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        cmd.Parameters.AddWithValue("@otp", otp);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Dispatch the secure email via your free Google SMTP channel
                bool sent = SendEmail(email, otp);

                if (sent)
                {
                    // Bypasses Step 2 entirely and takes the user straight to Step 3 (Verify OTP screen)
                    string script = $"Swal.fire({{ icon: 'success', title: 'OTP Sent', text: 'Verification code sent safely to {maskedEmail}!', confirmButtonColor: '#4e73df' }}).then(function() {{ document.getElementById('otpMessage').innerText = 'Enter the verification code sent to {maskedEmail}'; showStep(3); startTimer(); }});";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowOTP", script, true);
                    hdnCurrentStep.Value = "3";
                }
                else
                {
                    ShowAlert("Failed to send OTP email. Please try again or check your server configuration.", "error");
                    hdnCurrentStep.Value = "1";
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"System Error: {ex.Message}", "error");
            }
        }

        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            try
            {
                string identifier = hdnIdentifier.Value.Trim();
                string method = hdnMethod.Value;

                if (string.IsNullOrEmpty(identifier))
                {
                    ShowAlert("Session context lost. Please restart.", "error");
                    hdnCurrentStep.Value = "1";
                    return;
                }

                string email = null;
                string mobile = null;
                string userRole = Session["ResetUserRole"] as string;

                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();
                    string query = userRole == "Admin" ?
                        "SELECT email, phone_no FROM tblAdmin WHERE email = @id OR phone_no = @id" :
                        "SELECT Email, Phone_no FROM tblUser WHERE Email = @id OR Phone_no = @id";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                email = userRole == "Admin" ? dr["email"]?.ToString() : dr["Email"]?.ToString();
                                mobile = userRole == "Admin" ? dr["phone_no"]?.ToString() : dr["Phone_no"]?.ToString();
                            }
                        }
                    }
                }

                string otp = GenerateOTP();

                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();
                    string invalidate = "UPDATE tblPasswordReset SET IsUsed = 1 WHERE Identifier = @id AND IsUsed = 0";
                    using (SqlCommand cmd = new SqlCommand(invalidate, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        cmd.ExecuteNonQuery();
                    }

                    string insert = @"INSERT INTO tblPasswordReset (Identifier, OTP, DeliveryMethod, ExpiryTime, IsUsed, CreatedDate)  
                                      VALUES (@id, @otp, @method, DATEADD(MINUTE, 10, GETDATE()), 0, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(insert, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        cmd.Parameters.AddWithValue("@otp", otp);
                        cmd.Parameters.AddWithValue("@method", method);
                        cmd.ExecuteNonQuery();
                    }
                }

                bool sent = false;
                if (method == "Email" && !string.IsNullOrEmpty(email))
                {
                    sent = SendEmail(email, otp);
                }
                else if (method == "SMS" && !string.IsNullOrEmpty(mobile))
                {
                    sent = SendSMS(mobile, otp);
                }

                if (sent)
                {
                    string targetMaskedHint = method == "Email" ? Session["MaskedEmail"]?.ToString() : Session["MaskedSMS"]?.ToString();

                    string script = $"Swal.fire({{ icon: 'success', title: 'OTP Sent', text: 'Verification code sent successfully to {targetMaskedHint}!', confirmButtonColor: '#4e73df' }}).then(function() {{ document.getElementById('otpMessage').innerText = 'Enter the verification code sent to {targetMaskedHint}'; showStep(3); startTimer(); }});";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowOTP", script, true);
                    hdnCurrentStep.Value = "3";
                }
                else
                {
                    ShowAlert($"Failed to send OTP via {method}. Please try again.", "error");
                    hdnCurrentStep.Value = "2";
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"Error: {ex.Message}", "error");
            }
        }

        protected void btnVerifyOTP_Click(object sender, EventArgs e)
        {
            try
            {
                string identifier = hdnIdentifier.Value.Trim();
                string otp = hdnOTP.Value.Trim();

                if (string.IsNullOrEmpty(identifier))
                {
                    ShowAlert("Session expired. Please start over.", "error");
                    hdnCurrentStep.Value = "1";
                    return;
                }

                if (string.IsNullOrEmpty(otp) || otp.Length < 6)
                {
                    ShowAlert("Please enter complete 6-digit OTP", "error");
                    hdnCurrentStep.Value = "3";
                    return;
                }

                bool isValid = false;

                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();

                    string query = @"SELECT TOP 1 IsUsed, 
                                     CASE WHEN ExpiryTime >= GETDATE() THEN 1 ELSE 0 END AS IsValidTime
                                     FROM tblPasswordReset 
                                     WHERE Identifier = @id 
                                     AND OTP = @otp 
                                     AND IsUsed = 0 
                                     ORDER BY CreatedDate DESC, Id DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        cmd.Parameters.AddWithValue("@otp", otp);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                bool isUsed = Convert.ToBoolean(dr["IsUsed"]);
                                if (!isUsed)
                                {
                                    bool isValidTime = Convert.ToBoolean(dr["IsValidTime"]);
                                    if (isValidTime)
                                    {
                                        isValid = true;
                                    }
                                    else
                                    {
                                        ShowAlert("OTP has expired. Please request a new one.", "error");
                                        hdnCurrentStep.Value = "3";
                                    }
                                }
                                else
                                {
                                    ShowAlert("OTP has already been used.", "error");
                                    hdnCurrentStep.Value = "3";
                                }
                            }
                            else
                            {
                                ShowAlert("Invalid OTP. Please try again.", "error");
                                hdnCurrentStep.Value = "3";
                            }
                        }
                    }
                }

                if (isValid)
                {
                    using (SqlConnection conn = new SqlConnection(strcon))
                    {
                        conn.Open();
                        string markUsed = "UPDATE tblPasswordReset SET IsUsed = 1 WHERE Identifier = @id AND OTP = @otp";
                        using (SqlCommand cmd = new SqlCommand(markUsed, conn))
                        {
                            cmd.Parameters.AddWithValue("@id", identifier);
                            cmd.Parameters.AddWithValue("@otp", otp);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    string script = "showStep(4);";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowReset", script, true);
                    hdnCurrentStep.Value = "4";
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"Error: {ex.Message}", "error");
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            try
            {
                string identifier = hdnIdentifier.Value.Trim();
                string newPassword = txtNewPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();

                if (newPassword.Length < 8)
                {
                    ShowAlert("Password must be at least 8 characters", "error");
                    hdnCurrentStep.Value = "4";
                    return;
                }

                if (newPassword != confirmPassword)
                {
                    ShowAlert("Passwords do not match", "error");
                    hdnCurrentStep.Value = "4";
                    return;
                }

                string hashedPassword = HashPassword(newPassword);
                bool updated = false;

                string userRole = Session["ResetUserRole"] as string;

                if (string.IsNullOrEmpty(userRole))
                {
                    ShowAlert("Security validation context lost. Please try from Step 1.", "error");
                    hdnCurrentStep.Value = "1";
                    return;
                }

                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();

                    if (userRole == "Admin")
                    {
                        string query = "UPDATE tblAdmin SET password = @pw WHERE email = @id OR phone_no = @id";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@pw", hashedPassword);
                            cmd.Parameters.AddWithValue("@id", identifier);
                            int rows = cmd.ExecuteNonQuery();
                            if (rows > 0)
                            {
                                updated = true;
                                Session["FinalRedirectTarget"] = "~/Login.aspx";
                            }
                        }
                    }
                    else if (userRole == "User")
                    {
                        string query = "UPDATE tblUser SET Password = @pw WHERE Email = @id OR Phone_no = @id";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@pw", hashedPassword);
                            cmd.Parameters.AddWithValue("@id", identifier);
                            int rows = cmd.ExecuteNonQuery();
                            if (rows > 0)
                            {
                                updated = true;
                                Session["FinalRedirectTarget"] = "~/u_login.aspx";
                            }
                        }
                    }
                }

                if (updated)
                {
                    Session["ResetUserRole"] = null;

                    string script = "showStep(5);";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess", script, true);
                    hdnCurrentStep.Value = "5";
                }
                else
                {
                    ShowAlert("Failed to update password. Profile records may have changed.", "error");
                    hdnCurrentStep.Value = "4";
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"Error: {ex.Message}", "error");
            }
        }

        protected void lnkGoToLogin_Click(object sender, EventArgs e)
        {
            string targetUrl = Session["FinalRedirectTarget"] as string;

            if (string.IsNullOrEmpty(targetUrl))
            {
                Response.Redirect("~/u_login.aspx");
                return;
            }

            Session["FinalRedirectTarget"] = null;
            Response.Redirect(targetUrl);
        }

        private string GenerateOTP()
        {
            Random rnd = new Random();
            return rnd.Next(100000, 999999).ToString();
        }

        private string HashPassword(string password)
        {
            using (System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create())
            {
                byte[] inputBytes = Encoding.UTF8.GetBytes(password);
                byte[] hashBytes = md5.ComputeHash(inputBytes);
                StringBuilder sb = new StringBuilder();
                foreach (byte b in hashBytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private bool SendEmail(string toEmail, string otp)
        {
            try
            {
                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress("infolivesta@gmail.com", "LIVE$TA Society");
                    mail.To.Add(toEmail);
                    mail.Subject = "Password Reset OTP";
                    mail.Body = $"Your OTP for password reset is: {otp}\nThis OTP is valid for 10 minutes.";
                    mail.IsBodyHtml = false;

                    using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                    {
                        smtp.EnableSsl = true;
                        smtp.UseDefaultCredentials = false;
                        smtp.Credentials = new NetworkCredential("infolivesta@gmail.com", "zbzjqlopqiuwtxry");
                        smtp.Send(mail);
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Email Error: {ex.Message}");
                return false;
            }
        }

        private bool SendSMS(string toMobile, string otp)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"SMS would be sent to {toMobile} with OTP: {otp}");
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"SMS Error: {ex.Message}");
                return false;
            }
        }

        private void ShowAlert(string message, string type)
        {
            string script = $"Swal.fire({{ icon: '{type}', title: '{(type == "error" ? "Error" : "Success")}', text: '{message}', confirmButtonColor: '#4e73df' }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "Alert", script, true);
        }
    }
}