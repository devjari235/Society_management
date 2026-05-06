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

        private int AdminId => Session["A_id"] != null ? Convert.ToInt32(Session["A_id"]) : 0;

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
                // Show Initial Loading Script
                string loaderScript = @"
                Swal.fire({
                    title: 'Processing...',
                    text: 'Please wait while we post the notice and notify users.',
                    allowOutsideClick: false,
                    showConfirmButton: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "loader", loaderScript, true);

                // Validate expiry date
                if (!DateTime.TryParse(txtExpiry.Text, out DateTime expiryDate))
                {
                    ShowError("Invalid expiry date format. Please use yyyy-MM-dd.");
                    return;
                }

                // 1. Save notice to database
                int noticeId = SaveNoticeToDatabase();

                // 2. Check selected notification methods
                bool sendEmail = cblemail.Items.Cast<ListItem>().Any(item => item.Value == "Email" && item.Selected);
                bool sendInApp = cblemail.Items.Cast<ListItem>().Any(item => item.Value == "On App" && item.Selected);

                // 3. Handle Email Sending
                if (sendEmail)
                {
                    SendEmailsToSelectedGroups();
                }

                // 4. Handle In-App Notification (Logic added here)
                if (sendInApp)
                {
                    SendInAppNotification(noticeId, txtTitle.Text.Trim());
                }

                // 5. Final Success Message
                string successDetail = "Notice posted successfully!";
                if (sendEmail && sendInApp) successDetail += " Emails and In-App notifications sent.";
                else if (sendEmail) successDetail += " Emails have been sent.";
                else if (sendInApp) successDetail += " In-App notifications sent.";

                ScriptManager.RegisterStartupScript(this, GetType(), "finalSuccess",
                    $"Swal.fire('Success!', '{successDetail}', 'success').then(() => window.location = 'CreateNotice.aspx');",
                    true);
            }
            catch (Exception ex)
            {
                ShowError("An error occurred: " + ex.Message);
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
                fuNoticeFile.SaveAs(absolutePath);
                filePath = relativePath;
            }

            string broadcast = string.Join(",",
                cblBroadcast.Items.Cast<ListItem>()
                                  .Where(li => li.Selected)
                                  .Select(li => li.Text));

            string send = string.Join(",",
                cblemail.Items.Cast<ListItem>()
                              .Where(li => li.Selected)
                              .Select(li => li.Text));

            using (SqlConnection conn = new SqlConnection(strcon))
            {
                string query = @"
                    INSERT INTO tblNotices 
                    (Title, Description, Posted_date, Expiry_date, File_path, Notice_type, Importance, Status, Admin_id, Broadcast_By, Send_via)
                    VALUES
                    (@Title, @Description, GETDATE(), @ExpiryDate, @FilePath, @NoticeType, @Importance, @Status, @AdminId, @broad, @send);
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
                    cmd.Parameters.AddWithValue("@AdminId", AdminId);
                    cmd.Parameters.AddWithValue("@broad", broadcast);
                    cmd.Parameters.AddWithValue("@send", send);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        private void SendInAppNotification(int noticeId, string titleText)
        {
            var selectedGroups = cblBroadcast.Items.Cast<ListItem>().Where(li => li.Selected).Select(li => li.Value).ToList();
            if (selectedGroups.Count == 0) return;

            HashSet<int> userIds = new HashSet<int>();

            using (SqlConnection conn = new SqlConnection(strcon))
            {
                conn.Open();
                foreach (var group in selectedGroups)
                {
                    string userQuery = GetGroupUserQuery(group);
                    if (string.IsNullOrEmpty(userQuery)) continue;

                    using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                userIds.Add(Convert.ToInt32(reader[0]));
                            }
                        }
                    }
                }

                if (userIds.Count > 0)
                {
                    string insertNotif = @"INSERT INTO Notifications 
                                         (User_id, Title, Message, Type, ReferenceID, CreatedDate, IsRead)
                                         VALUES (@Uid, @Title, @Msg, 'Notice', @RefID, GETDATE(), 0)";

                    foreach (int uid in userIds)
                    {
                        using (SqlCommand cmd = new SqlCommand(insertNotif, conn))
                        {
                            cmd.Parameters.AddWithValue("@Uid", uid);
                            cmd.Parameters.AddWithValue("@Title", "New Society Notice");
                            cmd.Parameters.AddWithValue("@Msg", "A new notice has been posted: " + titleText);
                            cmd.Parameters.AddWithValue("@RefID", noticeId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        private string GetGroupUserQuery(string group)
        {
            switch (group)
            {
                case "Committee Member": return "SELECT User_id FROM tblCommitteeMember WHERE Status='Current'";
                case "Owners": return "SELECT u.User_id FROM tblUser u INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id";
                case "All Members": return "SELECT User_id FROM tblUser";
                default: return "";
            }
        }

        private void SendEmailsToSelectedGroups()
        {
            var selectedGroups = cblBroadcast.Items.Cast<ListItem>().Where(li => li.Selected).Select(li => li.Value).ToList();
            if (selectedGroups.Count == 0) return;

            var emails = GetGroupEmails(selectedGroups);
            if (emails.Count > 0)
            {
                SendEmailBatch(emails);
            }
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
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string email = reader[0]?.ToString();
                            if (!string.IsNullOrWhiteSpace(email) && IsValidEmail(email))
                                emails.Add(email.Trim());
                        }
                    }
                }
            }
            return emails.ToList();
        }

        private string GetGroupQuery(string group)
        {
            switch (group)
            {
                case "Committee Member": return "SELECT Email FROM tblCommitteeMember WHERE Email IS NOT NULL And Status='Current'";
                case "Owners": return "SELECT Email_id FROM tblOwner WHERE Email_id IS NOT NULL";
                case "All Members": return "SELECT Email FROM tblUser WHERE Email IS NOT NULL";
                default: return "";
            }
        }

        private void SendEmailBatch(List<string> emails)
        {
            const int batchSize = 50;
            for (int i = 0; i < emails.Count; i += batchSize)
            {
                var batch = emails.Skip(i).Take(batchSize).ToList();
                SendSingleEmail(batch);
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
                    mail.Attachments.Add(new Attachment(fuNoticeFile.PostedFile.InputStream, Path.GetFileName(fuNoticeFile.FileName)));
                }

                foreach (string email in recipients) mail.Bcc.Add(email);

                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.EnableSsl = true;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential("infolivesta@gmail.com", "zbzjqlopqiuwtxry");
                    smtp.Send(mail);
                }
            }
        }

        private string CreateEmailBody()
        {
            return $@"
            <div style='font-family: Arial; max-width: 600px; border: 1px solid #eee; padding: 20px;'>
                <h2 style='color: #4e73df;'>{Server.HtmlEncode(txtTitle.Text)}</h2>
                <p><strong>Notice Type:</strong> {ddlNoticeType.SelectedValue}</p>
                <hr/>
                <p>{Server.HtmlEncode(txtDescription.Text).Replace("\n", "<br />")}</p>
                <hr/>
                <p style='font-size: 0.8em; color: #777;'>This is an automated notification from your Society Management System.</p>
            </div>";
        }

        private string GetStatus(DateTime expiryDate) => expiryDate >= DateTime.Now ? "Live" : "Expired";

        private bool IsValidEmail(string email)
        {
            try { return new MailAddress(email).Address == email; }
            catch { return false; }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorMessage",
                $"Swal.fire('Error!', '{message.Replace("'", "\\'")}', 'error');", true);
        }
    }
}