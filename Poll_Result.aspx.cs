using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Poll_Result : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Session verification check for Admin
            // NOTE: Replace "A_id" with whatever Session variable name you use for logged-in admins (e.g., "Admin_id")
            if (Session["A_id"] == null)
            {
                Response.Redirect("~/Login.aspx"); // Redirect to admin login page
                return;
            }

            int adminId = Convert.ToInt32(Session["A_id"]);

            if (!IsPostBack)
            {
                CloseAllPolls(adminId); // Auto-close outdated polls for this admin's society
                LoadAllPollResults(adminId); // Load poll results for this admin's society only
            }
        }

        private void CloseAllPolls(int adminId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                // Handled spelling matching layout fix for 'Expired_date' if your database column uses that naming layout
                SqlCommand cmd = new SqlCommand("UPDATE tblPolls SET IsActive = 0 WHERE Expried_date < GETDATE() AND IsActive = 1 AND admin_id = @AdminId", conn);
                cmd.Parameters.AddWithValue("@AdminId", adminId);
                cmd.ExecuteNonQuery();
            }
        }

        private void LoadAllPollResults(int adminId)
        {
            DataTable pollsTable = new DataTable();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // 🔥 ADMIN SEPARATION FILTER ADDED: Selects polls belonging ONLY to this specific logged-in admin's society
                SqlCommand cmd = new SqlCommand("SELECT PollId, Question FROM tblPolls WHERE IsActive = 1 AND admin_id = @AdminId ORDER BY PollId DESC", conn);
                cmd.Parameters.AddWithValue("@AdminId", adminId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(pollsTable);
            }

            if (pollsTable.Rows.Count > 0)
            {
                // Add options and total votes columns to each poll row data matrix dynamically
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

                        // Fetch total votes matching this poll
                        SqlCommand totalCmd = new SqlCommand("SELECT COUNT(*) FROM tblVotes WHERE PollId = @PollId", conn);
                        totalCmd.Parameters.AddWithValue("@PollId", pollId);
                        totalVotes = (int)totalCmd.ExecuteScalar();

                        // Get option-wise vote counts safely
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

                        // Calculate percentage value injection matrix columns
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

                // Bind cleanly to UI items control template tree elements
                rptPolls.DataSource = pollsTable;
                rptPolls.DataBind();
                pnlNoPoll.Visible = false;
            }
            else
            {
                // Absolute structural layout clear to stop memory leak state loops between switches
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

                if (rptOptions != null && options != null)
                {
                    rptOptions.DataSource = options;
                    rptOptions.DataBind();
                }
            }
        }
    }
}