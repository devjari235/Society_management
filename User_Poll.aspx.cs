using System;
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
                    Response.Redirect("Login.aspx"); // Redirect to login if not authenticated
                }
                LoadPoll();
                CheckAdmin();
               
            }
            CloseAllPolls();
        }

        private void LoadPoll()
        {
            DataTable dtPoll = GetActivePoll();
            if (dtPoll.Rows.Count > 0)
            {
                pnlActivePoll.Visible = true;
                pnlNoActivePoll.Visible = false;

                litQuestion.Text = dtPoll.Rows[0]["Question"].ToString();
                int pollId = Convert.ToInt32(dtPoll.Rows[0]["PollId"]);

                // Check if user has already voted
                bool hasVoted = HasUserVoted(pollId);

                if (hasVoted)
                {
                    pnlVote.Visible = false;
                    pnlAlreadyVoted.Visible = true;
                    pnlResults.Visible = true;
                    DisplayResults(pollId);
                }
                else
                {
                    pnlVote.Visible = true;
                    pnlAlreadyVoted.Visible = false;
                    pnlResults.Visible = false;

                    // Load options
                    DataTable dtOptions = GetPollOptions(pollId);
                    rblOptions.DataSource = dtOptions;
                    rblOptions.DataTextField = "OptionText";
                    rblOptions.DataValueField = "OptionId";
                    rblOptions.DataBind();
                }

                // If admin, show results
                if (IsAdmin())
                {
                    pnlResults.Visible = true;
                    DisplayResults(pollId);
                    pnlCurrentPollResults.Visible = true;
                    DisplayAdminResults(pollId);
                }
            }
            else
            {
                pnlActivePoll.Visible = false;
                pnlNoActivePoll.Visible = true;
            }
        }

        private void CheckAdmin()
        {
            pnlAdmin.Visible = IsAdmin();
            btnClosePoll.Visible = HasActivePoll();
        }

        private bool IsAdmin()
        {
            // In a real app, use proper role-based authentication
            return Convert.ToBoolean(Session["A_id"] ?? false);
        }

        private bool HasActivePoll()
        {
            DataTable dt = GetActivePoll();
            return dt.Rows.Count > 0;
        }

        private DataTable GetActivePoll()
        {
            DataTable dt = new DataTable();
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM tblPolls WHERE IsActive=1", conn);
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
            if (Session["U_id"] == null) return false;

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

        private void DisplayResults(int pollId)
        {
            DataTable dtResults = GetPollResults(pollId);
            rptResults.DataSource = dtResults;
            rptResults.DataBind();

            int totalVotes = 0;
            foreach (DataRow row in dtResults.Rows)
            {
                totalVotes += Convert.ToInt32(row["VoteCount"]);
            }
            litTotalVotes.Text = totalVotes.ToString();
        }

        private void DisplayAdminResults(int pollId)
        {
            DataTable dtResults = GetPollResults(pollId);
            rptAdminResults.DataSource = dtResults;
            rptAdminResults.DataBind();

            int totalVotes = 0;
            foreach (DataRow row in dtResults.Rows)
            {
                totalVotes += Convert.ToInt32(row["VoteCount"]);
            }
            litAdminTotalVotes.Text = totalVotes.ToString();
        }

        private DataTable GetPollResults(int pollId)
        {
            DataTable dt = new DataTable();
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                SELECT po.OptionId, po.OptionText, COUNT(v.VoteId) AS VoteCount,
                       CAST(COUNT(v.VoteId) * 100.0 / NULLIF((SELECT COUNT(*) FROM tblVotes WHERE PollId = @PollId), 0) AS DECIMAL(5,2)) AS Percentage
                FROM tblPollOptions po
                LEFT JOIN tblVotes v ON po.OptionId = v.OptionId AND v.PollId = @PollId
                WHERE po.PollId = @PollId
                GROUP BY po.OptionId, po.OptionText
                ORDER BY po.OptionId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PollId", pollId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
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
        protected void btnVote_Click(object sender, EventArgs e)
        {
            if (Session["U_id"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (rblOptions.SelectedIndex == -1)
            {
                lblVoteError.Text = "Please select an option to vote.";
                lblVoteError.Visible = true;
                return;
            }

            int optionId = Convert.ToInt32(rblOptions.SelectedValue);
            int pollId = GetActivePoll().Rows[0].Field<int>("PollId");
            string userId = Session["U_id"].ToString();

            if (HasUserVoted(pollId))
            {
                lblVoteError.Text = "You have already voted in this poll.";
                lblVoteError.Visible = true;
                return;
            }

            try
            {
                RecordVote(pollId, optionId, userId);
                Response.Redirect(Request.RawUrl);
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2601 || ex.Number == 2627) // Unique constraint violation
                {
                    lblVoteError.Text = "You have already voted in this poll.";
                }
                else
                {
                    lblVoteError.Text = "An error occurred while recording your vote. Please try again.";
                }
                lblVoteError.Visible = true;
            }
            catch (Exception)
            {
                lblVoteError.Text = "An unexpected error occurred. Please try again.";
                lblVoteError.Visible = true;
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
    }
}