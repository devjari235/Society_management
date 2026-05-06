using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class PollCreate : System.Web.UI.Page
    {
        private string ConnString =>
            System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        private int AdminId =>
            Session["A_id"] != null ? Convert.ToInt32(Session["A_id"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlAdmin.Visible = true;
                DataBind();
            }
        }

        // ─────────────────────────────────────────────
        //  CUSTOM VALIDATOR
        // ─────────────────────────────────────────────
        protected void cvOptions_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string optionsString = hdnOptions.Value;
            if (!string.IsNullOrEmpty(optionsString))
            {
                string[] options = optionsString.Split(
                    new string[] { "|||" }, StringSplitOptions.RemoveEmptyEntries);
                if (options.Length >= 2) { args.IsValid = true; return; }
            }
            args.IsValid = false;
        }

        // ─────────────────────────────────────────────
        //  CREATE POLL BUTTON
        // ─────────────────────────────────────────────
        protected void btnCreatePoll_Click(object sender, EventArgs e)
        {
            lblAdminMessage.Visible = false;
            lblAdminSuccess.Visible = false;

            // Validate question
            if (string.IsNullOrWhiteSpace(txtNewQuestion.Text))
            {
                ShowSwalError("Please enter a question for the poll.");
                return;
            }

            // Validate options
            string[] options = hdnOptions.Value.Split(
                new[] { "|||" }, StringSplitOptions.RemoveEmptyEntries);

            if (options.Length < 2)
            {
                ShowSwalError("Please enter at least two options for the poll.");
                return;
            }

            try
            {
                // 1. Create poll
                int newPollId = CreateNewPoll(txtNewQuestion.Text);

                // 2. Add options
                foreach (string option in options)
                    if (!string.IsNullOrWhiteSpace(option))
                        AddPollOption(newPollId, option.Trim());

                // 3. Send notification to all society users
                SendPollNotificationToAllUsers(newPollId, txtNewQuestion.Text);

                // 4. Success popup → redirect
                string script = @"
                    Swal.fire({
                        title: 'Poll Created!',
                        text: 'New poll created and users have been notified.',
                        icon: 'success',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#3085d6'
                    }).then(function() {
                        window.location = 'PollCreate.aspx';
                    });";

                ScriptManager.RegisterStartupScript(
                    this, this.GetType(), "SuccessMessage", script, true);
            }
            catch (Exception ex)
            {
                ShowSwalError("An error occurred: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────
        //  CREATE POLL IN DB
        // ─────────────────────────────────────────────
        private int CreateNewPoll(string question)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO tblPolls
                        (Question, IsActive, CreatedDate, Expried_date, admin_id)
                    OUTPUT INSERTED.PollId
                    VALUES
                        (@Question, 1, @CreatedDate, @Expire, @AdminId)", conn);

                cmd.Parameters.AddWithValue("@Question", question);
                cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@Expire", txtExpireDate.Text);
                cmd.Parameters.AddWithValue("@AdminId", AdminId);

                return (int)cmd.ExecuteScalar();
            }
        }

        // ─────────────────────────────────────────────
        //  ADD POLL OPTION
        // ─────────────────────────────────────────────
        private void AddPollOption(int pollId, string optionText)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO tblPollOptions (PollId, OptionText)
                    VALUES (@PollId, @OptionText)", conn);

                cmd.Parameters.AddWithValue("@PollId", pollId);
                cmd.Parameters.AddWithValue("@OptionText", optionText);
                cmd.ExecuteNonQuery();
            }
        }

        // ─────────────────────────────────────────────
        //  SEND POLL NOTIFICATION TO ALL SOCIETY USERS
        //  Inserts one row in Notifications per user
        //  belonging to this admin's society.
        // ─────────────────────────────────────────────
        private void SendPollNotificationToAllUsers(int pollId, string question)
        {
            // Get all User_id values that belong to this admin's society
            string getUsersSql = @"
                SELECT DISTINCT u.User_id
                FROM   tblUser    u
                INNER JOIN tblOwner   o ON u.Owner_id   = o.Owner_id
                INNER JOIN tblFlat    f ON o.Flate_id   = f.Flate_id
                INNER JOIN tblBlock   b ON f.Block_id   = b.Block_id
                INNER JOIN tblSociety s ON b.Society_id = s.Society_id
                WHERE  s.admin_id = @AdminId";

            List<int> userIds = new List<int>();

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(getUsersSql, conn))
                {
                    cmd.Parameters.AddWithValue("@AdminId", AdminId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                        while (reader.Read())
                            userIds.Add(Convert.ToInt32(reader["User_id"]));
                }
            }

            if (userIds.Count == 0) return;

            // Insert one notification row per user
            string insertSql = @"
                INSERT INTO Notifications
                    (User_id, Title, Message, Type, ReferenceID, CreatedDate, IsRead)
                VALUES
                    (@UserId, @Title, @Message, 'Poll', @ReferenceID, @CreatedDate, 0)";

            string title = "New Poll Available";
            string message = $"A new poll has been posted: \"{question}\". Cast your vote now!";

            using (SqlConnection conn = new SqlConnection(ConnString))
            {
                conn.Open();
                foreach (int userId in userIds)
                {
                    using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Message", message);
                        cmd.Parameters.AddWithValue("@ReferenceID", pollId);
                        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        // ─────────────────────────────────────────────
        //  SWAL ERROR HELPER
        // ─────────────────────────────────────────────
        private void ShowSwalError(string message)
        {
            // Escape single quotes to avoid breaking the JS string
            string safe = message.Replace("'", "\\'");
            string script = $@"
                Swal.fire({{
                    icon: 'error',
                    title: 'Oops...',
                    text: '{safe}',
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'Try Again'
                }});";

            ScriptManager.RegisterStartupScript(
                this, this.GetType(), "SwalError", script, true);
        }
    }
}