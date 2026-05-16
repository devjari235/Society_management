using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class User_Poll : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["U_id"] == null)
                {
                    Response.Redirect("Login.aspx");
                }

                CloseAllPolls();
                LoadPolls();
            }
        }
        public class PollDisplay
        {
            public int PollId { get; set; }
            public string Question { get; set; }
            public bool HasVoted { get; set; }
            public DataTable Options { get; set; }
        }
        private void LoadPolls()
        {
            DataTable polls = GetActivePoll();

            // FIX 1: Changed control variable reference from pnlNoPoll to pnlEmpty
            if (polls == null || polls.Rows.Count == 0)
            {
                pnlEmpty.Visible = true;       // Shows your new animated empty state card
                phDataContent.Visible = false; // Hides the swiper wrapper completely
                return;
            }

            pnlEmpty.Visible = false;
            phDataContent.Visible = true;

            List<PollDisplay> pollDisplays = new List<PollDisplay>();

            foreach (DataRow row in polls.Rows)
            {
                int pollId = Convert.ToInt32(row["PollId"]);
                bool hasVoted = HasUserVoted(pollId);

                pollDisplays.Add(new PollDisplay
                {
                    PollId = pollId,
                    Question = row["Question"].ToString(),
                    HasVoted = hasVoted,
                    // FIX 2: Always retrieve options (never return null) so the RadioButtonList 
                    // inside your HTML layout doesn't crash with a NullReferenceException
                    Options = GetPollOptions(pollId)
                });
            }

            rptPolls.DataSource = pollDisplays;
            rptPolls.DataBind();
        }

        private void CloseAllPolls()
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE tblPolls SET IsActive = 0 WHERE Expried_date < GETDATE()", conn);
                cmd.ExecuteNonQuery();
            }
        }

        private DataTable GetActivePoll()
        {
            DataTable dt = new DataTable();
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM tblPolls WHERE IsActive = 1 ORDER BY PollId DESC", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }

        private DataTable GetPollOptions(int pollId)
        {
            DataTable dt = new DataTable();
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM tblPollOptions WHERE PollId = @PollId", conn);
                cmd.Parameters.AddWithValue("@PollId", pollId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }

        private bool HasUserVoted(int pollId)
        {
            string userId = Session["U_id"].ToString();
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM tblVotes WHERE PollId = @PollId AND User_id = @UserId", conn);
                cmd.Parameters.AddWithValue("@PollId", pollId);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private void RecordVote(int pollId, int optionId, string userId)
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO tblVotes (PollId, OptionId, VoteDate, User_id) " +
                    "VALUES (@PollId, @OptionId, @VoteDate, @UserId)", conn);

                cmd.Parameters.AddWithValue("@PollId", pollId);
                cmd.Parameters.AddWithValue("@OptionId", optionId);
                cmd.Parameters.AddWithValue("@VoteDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@UserId", userId);

                cmd.ExecuteNonQuery();
            }
        }

        protected void rptPolls_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Vote")
            {
                if (Session["U_id"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                string userId = Session["U_id"].ToString();
                int pollId = Convert.ToInt32(e.CommandArgument);

                // Find the RadioButtonList control
                RadioButtonList rbl = (RadioButtonList)e.Item.FindControl("rblOptions");

                if (rbl != null && rbl.SelectedIndex != -1)
                {
                    int optionId = Convert.ToInt32(rbl.SelectedValue);

                    // Check if user hasn't already voted
                    if (!HasUserVoted(pollId))
                    {
                        RecordVote(pollId, optionId, userId);
                        string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Your vote has been recorded successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'User_Poll.aspx';
            });";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                        // Show success message (optional)

                    }
                    else
                    {
                        // User already voted
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert",
                            "alert('You have already voted in this poll.');", true);
                       
                    }
                }
                else
                {
                    string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            text:  'Please select an option before voting.',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                    ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);
                    // No option selected
                }

                // Refresh the page to show updated results
                LoadPolls();
            }
        }
        
    }
}
