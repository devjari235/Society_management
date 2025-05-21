using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

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
                    Response.Redirect("Login.aspx"); // Not logged in
                }

                CloseAllPolls();
                LoadPoll();
            }
        }

        private void LoadPoll()
        {
            DataTable dtPoll = GetActivePoll();
            if (dtPoll.Rows.Count > 0)
            {
                pnlActivePoll.Visible = true;
                pnlNoActivePoll.Visible = false;

                int pollId = Convert.ToInt32(dtPoll.Rows[0]["PollId"]);
                litQuestion.Text = dtPoll.Rows[0]["Question"].ToString();

                if (HasUserVoted(pollId))
                {
                    pnlVote.Visible = false;
                    pnlAlreadyVoted.Visible = true;
                }
                else
                {
                    pnlVote.Visible = true;
                    pnlAlreadyVoted.Visible = false;

                    rblOptions.DataSource = GetPollOptions(pollId);
                    rblOptions.DataTextField = "OptionText";
                    rblOptions.DataValueField = "OptionId";
                    rblOptions.DataBind();
                }
            }
            else
            {
                pnlActivePoll.Visible = false;
                pnlNoActivePoll.Visible = true;
            }
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
                SqlCommand cmd = new SqlCommand("SELECT * FROM tblPolls WHERE IsActive = 1", conn);
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
            catch (Exception)
            {
                lblVoteError.Text = "An error occurred while recording your vote. Please try again.";
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
