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
    public partial class Poll_Result : System.Web.UI.Page
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPollResults();
            }
        }

        private void LoadPollResults()
        {
            int pollId = 0;
            string question = "";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Get active and non-expired poll, latest one
                SqlCommand cmd = new SqlCommand(@"
            SELECT *
            FROM tblPolls 
            WHERE IsActive = 1 AND (Expried_date IS NULL OR Expried_date > GETDATE())
            ORDER BY PollId DESC", conn);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        pollId = Convert.ToInt32(reader["PollId"]);
                        question = reader["Question"].ToString();
                    }
                }
            }

            if (pollId > 0)
            {
                litQuestion.Text = $"<h2>{question}</h2>";

                DataTable dt = new DataTable();
                dt.Columns.Add("OptionText", typeof(string));
                dt.Columns.Add("VoteCount", typeof(int));
                dt.Columns.Add("Percentage", typeof(int));

                int totalVotes = 0;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    // Get total votes for the poll
                    SqlCommand totalCmd = new SqlCommand("SELECT COUNT(*) FROM tblVotes WHERE PollId = @PollId", conn);
                    totalCmd.Parameters.AddWithValue("@PollId", pollId);
                    totalVotes = (int)totalCmd.ExecuteScalar();

                    // Get option-wise vote counts
                    SqlCommand resultCmd = new SqlCommand(@"
                SELECT o.OptionText,
                       COUNT(v.VoteId) AS VoteCount
                FROM tblPollOptions o
                LEFT JOIN tblVotes v ON o.OptionId = v.OptionId
                WHERE o.PollId = @PollId
                GROUP BY o.OptionText, o.OptionId
                ORDER BY o.OptionId", conn);
                    resultCmd.Parameters.AddWithValue("@PollId", pollId);

                    using (SqlDataReader reader = resultCmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string optionText = reader["OptionText"].ToString();
                            int voteCount = Convert.ToInt32(reader["VoteCount"]);
                            int percentage = totalVotes > 0 ? (int)((voteCount * 100.0) / totalVotes) : 0;

                            dt.Rows.Add(optionText, voteCount, percentage);
                        }
                    }
                }

                rptResults.DataSource = dt;
                rptResults.DataBind();

                litTotalVotes.Text = totalVotes.ToString();
            }
            else
            {
                litQuestion.Text = "<h2>No active poll available.</h2>";
                litTotalVotes.Text = "0";
                rptResults.DataSource = null;
                rptResults.DataBind();
            }
        }

    }
}