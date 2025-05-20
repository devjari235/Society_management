using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
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
                LoadPoll();
                CheckAdmin();
            }
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
            // In a real application, you would check the user's role
            // For this example, we'll use a query string parameter
            pnlAdmin.Visible = IsAdmin();
            btnClosePoll.Visible = HasActivePoll();
        }

        private bool IsAdmin()
        {
            // This is a simple check - in a real app, use proper authentication
            return Request.QueryString["admin"] == "true";
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
            // In a real application, you would track users properly
            // For this example, we'll use a cookie
            if (Request.Cookies["Voted_" + pollId] != null)
            {
                return true;
            }

            return false;
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

        protected void btnVote_Click(object sender, EventArgs e)
        {
            if (rblOptions.SelectedIndex == -1)
            {
                lblVoteError.Text = "Please select an option to vote.";
                lblVoteError.Visible = true;
                return;
            }

            int optionId = Convert.ToInt32(rblOptions.SelectedValue);
            int pollId = GetActivePoll().Rows[0].Field<int>("PollId");

            // Record vote
            RecordVote(pollId, optionId);

            // Set cookie to prevent multiple votes
            HttpCookie cookie = new HttpCookie("Voted_" + pollId, "true");
            cookie.Expires = DateTime.Now.AddYears(1);
            Response.Cookies.Add(cookie);

            // Reload page to show results
            Response.Redirect(Request.RawUrl);
        }

        private void RecordVote(int pollId, int optionId)
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("INSERT INTO tblVotes (PollId, OptionId, VoteDate, User_id) VALUES (@PollId, @OptionId, @VoteDate, @id)", conn);
                cmd.Parameters.AddWithValue("@PollId", pollId);
                cmd.Parameters.AddWithValue("@OptionId", optionId);
                cmd.Parameters.AddWithValue("@VoteDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                cmd.ExecuteNonQuery();
            }
        }

        
    }
}