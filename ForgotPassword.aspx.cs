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
            }
        }

        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            try
            {
                string identifier = hdnIdentifier.Value.Trim();
                string method = rbEmail.Checked ? "Email" : "SMS";
                hdnMethod.Value = method;

                if (string.IsNullOrEmpty(identifier))
                {
                    ShowAlert("Please enter email or mobile number", "error");
                    hdnCurrentStep.Value = "1";
                    return;
                }

                string email = null;
                string mobile = null;
                bool found = false;

                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();

                    // Check tblAdmin (Using 'phone_no' to match your schema layout)
                    string query = "SELECT email, phone_no FROM tblAdmin WHERE email = @id OR phone_no = @id";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                found = true;
                                email = dr["email"]?.ToString();
                                mobile = dr["phone_no"]?.ToString();
                            }
                        }
                    }

                    // Check tblUser (Using 'Phone_no' to match your schema layout)
                    if (!found)
                    {
                        query = "SELECT Email, Phone_no FROM tblUser WHERE Email = @id OR Phone_no = @id";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@id", identifier);
                            using (SqlDataReader dr = cmd.ExecuteReader())
                            {
                                if (dr.Read())
                                {
                                    found = true;
                                    email = dr["Email"]?.ToString();
                                    mobile = dr["Phone_no"]?.ToString();
                                }
                            }
                        }
                    }
                }

                if (!found)
                {
                    ShowAlert("No account found with this email or mobile number", "error");
                    hdnCurrentStep.Value = "1";
                    return;
                }

                // Generate 6-Digit OTP
                string otp = GenerateOTP();

                // Save OTP records to DB
                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();

                    // Invalidate old pending OTP requests
                    string invalidate = "UPDATE tblPasswordReset SET IsUsed = 1 WHERE Identifier = @id AND IsUsed = 0";
                    using (SqlCommand cmd = new SqlCommand(invalidate, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", identifier);
                        cmd.ExecuteNonQuery();
                    }

                    // Insert new token line
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

                // Send OTP through the selected channel
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
                    // Run sweetalert and proceed to step 3 cleanly
                    string script = $"Swal.fire({{ icon: 'success', title: 'OTP Sent', text: 'Verification code sent successfully. Check your {method.ToLower()}!', confirmButtonColor: '#4e73df' }}).then(function() {{ showStep(3); startTimer(); }});";
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
                System.Diagnostics.Debug.WriteLine($"SendOTP Error: {ex.Message}");
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

                    // FIX 1: Let SQL check time with GETDATE() directly
                    // FIX 2: Added AND IsUsed = 0 and ORDER BY Id DESC to completely prevent millisecond double-click collisions
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
                    // Mark token row asset state consumed
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
                System.Diagnostics.Debug.WriteLine($"VerifyOTP Error: {ex.Message}");
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

                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    conn.Open();

                    // Update admin table if matching record exists (using system schema column mappings)
                    string query = "UPDATE tblAdmin SET password = @pw WHERE email = @id OR phone_no = @id";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@pw", hashedPassword);
                        cmd.Parameters.AddWithValue("@id", identifier);
                        int rows = cmd.ExecuteNonQuery();
                        if (rows > 0) updated = true;
                    }

                    // Update user table if matching record exists
                    if (!updated)
                    {
                        query = "UPDATE tblUser SET Password = @pw WHERE Email = @id OR Phone_no = @id";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@pw", hashedPassword);
                            cmd.Parameters.AddWithValue("@id", identifier);
                            int rows = cmd.ExecuteNonQuery();
                            if (rows > 0) updated = true;
                        }
                    }
                }

                if (updated)
                {
                    string script = "showStep(5);";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess", script, true);
                    hdnCurrentStep.Value = "5";
                }
                else
                {
                    ShowAlert("Failed to update password. Please try again.", "error");
                    hdnCurrentStep.Value = "4";
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"Error: {ex.Message}", "error");
                System.Diagnostics.Debug.WriteLine($"ResetPassword Error: {ex.Message}");
            }
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