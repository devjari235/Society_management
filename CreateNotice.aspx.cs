using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class CreateNotice : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize controls if needed
            }
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate expiry date
                if (!DateTime.TryParse(txtExpiry.Text, out DateTime expiryDate))
                {
                    ShowError("Invalid expiry date format. Please use yyyy-MM-dd.");
                    return;
                }

                // Save notice to database
                int noticeId = SaveNoticeToDatabase();

                // Check if email sending is requested
                bool sendEmail = cblemail.Items.Cast<ListItem>().Any(item => item.Value == "Email" && item.Selected);
                bool sendInApp = cblemail.Items.Cast<ListItem>().Any(item => item.Value == "On App" && item.Selected);

                if (sendEmail)
                {
                    // Send emails to selected groups
                    SendEmailsToSelectedGroups();
                }

                if (sendInApp)
                {
                    // Add code here for in-app notifications if needed
                    System.Diagnostics.Trace.WriteLine("In-app notification would be sent here");
                }

                ShowSuccess("Notice posted successfully!" + (sendEmail ? " Emails are being sent." : ""));
            }
            catch (Exception ex)
            {
                ShowError($"Error: {ex.Message}");
            }
        }

        private int SaveNoticeToDatabase()
        {
            string filePath = null;

            if (fuNoticeFile.HasFile)
            {
                string fileName = Path.GetFileName(fuNoticeFile.FileName);
                string relativePath = "~/Notice/" + fileName;
                string absolutePath = Server.MapPath(relativePath);

                // Save file (assumes the ~/Notice/ folder already exists)
                fuNoticeFile.SaveAs(absolutePath);

                filePath = relativePath;
            }

            using (SqlConnection conn = new SqlConnection(strcon))
            {
                string query = @"
        INSERT INTO tblNotices 
        (Title, Description, Posted_date, Expiry_date, File_path, Notice_type, Importance, Status, Admin_id)
        VALUES
        (@Title, @Description, GETDATE(), @ExpiryDate, @FilePath, @NoticeType, @Importance, @Status, @AdminId);
        SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@ExpiryDate", DateTime.Parse(txtExpiry.Text));
                    cmd.Parameters.AddWithValue("@FilePath", (object)filePath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@NoticeType", ddlNoticeType.SelectedValue);
                    cmd.Parameters.AddWithValue("@Importance", ddlImportance.SelectedValue);
                    cmd.Parameters.AddWithValue("@Status", GetStatus(DateTime.Parse(txtExpiry.Text)));
                    cmd.Parameters.AddWithValue("@AdminId", Session["A_id"] ?? DBNull.Value);

                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }



        private string GetStatus(DateTime expiryDate)
        {
            return expiryDate >= DateTime.Now ? "Live" : "Expired";
        }

        private void SendEmailsToSelectedGroups()
        {
            var selectedGroups = new List<string>();
            foreach (ListItem item in cblBroadcast.Items)
            {
                if (item.Selected)
                {
                    selectedGroups.Add(item.Value);
                }
            }

            if (selectedGroups.Count == 0)
            {
                System.Diagnostics.Trace.WriteLine("No groups selected for email broadcast");
                return;
            }

            var emails = GetGroupEmails(selectedGroups);
            if (emails.Count == 0)
            {
                System.Diagnostics.Trace.WriteLine("No valid email addresses found for selected groups");
                return;
            }

            SendEmailBatch(emails);
        }

        private List<string> GetGroupEmails(List<string> groups)
        {
            var emails = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            using (SqlConnection conn = new SqlConnection(strcon))
            {
                conn.Open();

                foreach (var group in groups)
                {
                    string query = GetGroupQuery(group);
                    if (string.IsNullOrEmpty(query)) continue;

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string email = reader[0]?.ToString();
                                if (!string.IsNullOrWhiteSpace(email) && IsValidEmail(email))
                                {
                                    emails.Add(email.Trim());
                                }
                            }
                        }
                    }
                }
            }
            return new List<string>(emails);
        }

        private string GetGroupQuery(string group)
        {
            switch (group)
            {
                case "Committee Member":
                    return "SELECT Email FROM tblCommitteeMember WHERE Email IS NOT NULL";
                case "Owners":
                    return "SELECT Email_id FROM tblOwner WHERE Email_id IS NOT NULL";
                case "All Members":
                    return "SELECT Email FROM tblUser WHERE Email IS NOT NULL";
                default:
                    return "";
            }
        }

        private void SendEmailBatch(List<string> emails)
        {
            const int batchSize = 50;
            int batchCount = (int)Math.Ceiling((double)emails.Count / batchSize);

            for (int i = 0; i < batchCount; i++)
            {
                var batch = emails.Skip(i * batchSize).Take(batchSize).ToList();
                try
                {
                    SendSingleEmail(batch);
                    System.Diagnostics.Trace.WriteLine($"Successfully sent batch {i + 1} of {batchCount} with {batch.Count} recipients");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine($"Failed to send batch {i + 1}: {ex.Message}");
                }
            }
        }

        private void SendSingleEmail(List<string> recipients)
        {
            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress("infolivesta@gmail.com");
                mail.Subject = $"New Notice: {txtTitle.Text.Trim()}";
                mail.Body = CreateEmailBody();
                mail.IsBodyHtml = true;

                if (fuNoticeFile.HasFile && fuNoticeFile.PostedFile.ContentLength > 0)
                {
                    string fileName = Path.GetFileName(fuNoticeFile.FileName);
                    mail.Attachments.Add(new Attachment(fuNoticeFile.PostedFile.InputStream, fileName));
                }

                foreach (string email in recipients)
                {
                    mail.Bcc.Add(email);
                }

                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.EnableSsl = true;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential(
                        "infolivesta@gmail.com",
                        "npimgmeajgyouqvm"
                    );
                    smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                    smtp.Timeout = 30000;

                    smtp.Send(mail);
                }
            }
        }

        private string CreateEmailBody()
        {
            string attachmentInfo = fuNoticeFile.HasFile ?
                $"<p><strong>Attachment:</strong> {Server.HtmlEncode(fuNoticeFile.FileName)}</p>" :
                string.Empty;

            return $@"
            <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; padding: 20px;'>
                <h2 style='color: #4e73df;'>{Server.HtmlEncode(txtTitle.Text)}</h2>
                <p><strong>Notice Type:</strong> {Server.HtmlEncode(ddlNoticeType.SelectedValue)}</p>
                <p><strong>Importance:</strong> {Server.HtmlEncode(ddlImportance.SelectedValue)}</p>
                <p><strong>Expiry Date:</strong> {DateTime.Parse(txtExpiry.Text):dd MMM yyyy}</p>
                {attachmentInfo}
                <hr style='border-top: 1px solid #e0e0e0; margin: 15px 0;'>
                <div style='background-color: #f8f9fa; padding: 15px; border-radius: 5px;'>
                    {Server.HtmlEncode(txtDescription.Text).Replace("\n", "<br />")}
                </div>
                <hr style='border-top: 1px solid #e0e0e0; margin: 15px 0;'>
                <p>Please log in to the society portal for more details.</p>
                <p style='color: #6c757d; font-size: 0.9em;'>
                    This is an automated message. Please do not reply directly to this email.
                </p>
            </div>";
        }

        private bool IsValidEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "SuccessMessage",
                $"Swal.fire('Success!', '{message.Replace("'", "\\'")}', 'success').then(() => window.location = 'CreateNotice.aspx');",
                true);
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorMessage",
                $"Swal.fire('Error!', '{message.Replace("'", "\\'")}', 'error');",
                true);
        }
    }
}