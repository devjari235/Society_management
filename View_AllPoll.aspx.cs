using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class View_AllPoll : System.Web.UI.Page
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                List<PollViewModel> polls = GetPollsFromDatabase();
                rptPolls.DataSource = polls;
                rptPolls.DataBind();
            }
        }


        private List<PollViewModel> GetPollsFromDatabase()
        {
            var polls = new List<PollViewModel>();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Step 1: Get all polls
                string pollQuery = "SELECT PollId, Question, IsActive FROM tblPolls ORDER BY PollId DESC";
                using (SqlCommand cmd = new SqlCommand(pollQuery, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            polls.Add(new PollViewModel
                            {
                                PollId = Convert.ToInt32(reader["PollId"]),
                                Title = reader["Question"].ToString(),
                                Description = "", // You can map this if you have a Description column
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                Options = new List<PollOption>()
                            });
                        }
                    }
                }

                // Step 2: For each poll, get options and vote counts
                foreach (var poll in polls)
                {
                    int totalVotes = 0;

                    // Get total vote count for this poll
                    using (SqlCommand totalCmd = new SqlCommand("SELECT COUNT(*) FROM tblVotes WHERE PollId = @PollId", conn))
                    {
                        totalCmd.Parameters.AddWithValue("@PollId", poll.PollId);
                        totalVotes = (int)totalCmd.ExecuteScalar();
                    }

                    // Get option-wise vote counts
                    using (SqlCommand optionCmd = new SqlCommand(@"
                SELECT o.OptionText, COUNT(v.VoteId) AS VoteCount
                FROM tblPollOptions o
                LEFT JOIN tblVotes v ON o.OptionId = v.OptionId
                WHERE o.PollId = @PollId
                GROUP BY o.OptionText, o.OptionId
                ORDER BY o.OptionId", conn))
                    {
                        optionCmd.Parameters.AddWithValue("@PollId", poll.PollId);
                        using (SqlDataReader optionReader = optionCmd.ExecuteReader())
                        {
                            while (optionReader.Read())
                            {
                                int voteCount = Convert.ToInt32(optionReader["VoteCount"]);
                                int percentage = totalVotes > 0 ? (int)((voteCount * 100.0) / totalVotes) : 0;

                                poll.Options.Add(new PollOption
                                {
                                    OptionText = optionReader["OptionText"].ToString(),
                                    VoteCount = voteCount,
                                    Percentage = percentage
                                });
                            }
                        }
                    }
                }
            }

            return polls;
        }


        public class PollViewModel
        {
            public int PollId { get; set; }
            public string Title { get; set; }         // maps to tblPolls.Question
            public string Description { get; set; }   // if you have a Description field
            public bool IsActive { get; set; }
            public List<PollOption> Options { get; set; }
        }

        public class PollOption
        {
            public string OptionText { get; set; }
            public int VoteCount { get; set; }
            public int Percentage { get; set; }
        }

    }
}