using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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
                LoadAllPollResults();
                CloseAllPolls();
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
        private void LoadAllPollResults()
        {
            DataTable pollsTable = new DataTable();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Get all polls
                SqlCommand cmd = new SqlCommand("SELECT PollId, Question FROM tblPolls ORDER BY PollId DESC", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(pollsTable);
            }

            if (pollsTable.Rows.Count > 0)
            {
                // Add options and total votes to each poll
                pollsTable.Columns.Add("Options", typeof(DataTable));
                pollsTable.Columns.Add("TotalVotes", typeof(int));

                foreach (DataRow pollRow in pollsTable.Rows)
                {
                    int pollId = Convert.ToInt32(pollRow["PollId"]);

                    DataTable optionsTable = new DataTable();
                    int totalVotes = 0;

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        conn.Open();

                        // Total votes for this poll
                        SqlCommand totalCmd = new SqlCommand("SELECT COUNT(*) FROM tblVotes WHERE PollId = @PollId", conn);
                        totalCmd.Parameters.AddWithValue("@PollId", pollId);
                        totalVotes = (int)totalCmd.ExecuteScalar();

                        // Get option-wise vote counts
                        SqlCommand optionCmd = new SqlCommand(@"
                            SELECT o.OptionText,
                                   COUNT(v.VoteId) AS VoteCount
                            FROM tblPollOptions o
                            LEFT JOIN tblVotes v ON o.OptionId = v.OptionId
                            WHERE o.PollId = @PollId
                            GROUP BY o.OptionText, o.OptionId
                            ORDER BY o.OptionId", conn);

                        optionCmd.Parameters.AddWithValue("@PollId", pollId);
                        SqlDataAdapter da = new SqlDataAdapter(optionCmd);
                        da.Fill(optionsTable);

                        // Add percentage column
                        optionsTable.Columns.Add("Percentage", typeof(int));

                        foreach (DataRow optionRow in optionsTable.Rows)
                        {
                            int count = Convert.ToInt32(optionRow["VoteCount"]);
                            int percent = totalVotes > 0 ? (int)((count * 100.0) / totalVotes) : 0;
                            optionRow["Percentage"] = percent;
                        }
                    }

                    pollRow["Options"] = optionsTable;
                    pollRow["TotalVotes"] = totalVotes;
                }

                // Bind to outer repeater (one poll per slide)
                rptPolls.DataSource = pollsTable;
                rptPolls.DataBind();
                pnlNoPoll.Visible = false;
            }
            else
            {
                rptPolls.DataSource = null;
                rptPolls.DataBind();
                pnlNoPoll.Visible = true;
            }
        }

        protected void rptPolls_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptOptions = (Repeater)e.Item.FindControl("rptOptions");
                DataRowView drv = (DataRowView)e.Item.DataItem;
                DataTable options = drv["Options"] as DataTable;
                rptOptions.DataSource = options;
                rptOptions.DataBind();
            }
        }
    }
}
