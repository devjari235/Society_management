using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class VisitorApproval : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadVisitorApprovals();
            }
        }

        private void LoadVisitorApprovals()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                string query = @"SELECT v.VisitorID, v.Name, v.ContactNumber, v.VisitPurpose, 
                               v.VisitDateTime, v.IsApproved, u.User_name AS MemberName,
                               v.CheckInTime, 
                               v.CheckOutTime
                                FROM Visitors v
                                LEFT JOIN tblUser u ON v.User_id = u.User_id
                                WHERE v.IsScheduled = 0
                                ORDER BY v.VisitDateTime DESC
                                ";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(query, connection);
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvVisitorApprovals.DataSource = dt;
                    gvVisitorApprovals.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading data: {ex.Message}", "danger");
            }
        }

        protected void gvVisitorApprovals_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null) return;

            int visitorId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "Schedule")
            {
                Response.Redirect($"MemberSchedule.aspx?VisitorID={visitorId}");
            }
            else if (e.CommandName == "CheckIn")
            {
                UpdateVisitTime(visitorId, isCheckIn: true);
                LoadVisitorApprovals(); // refresh data
            }
            else if (e.CommandName == "CheckOut")
            {
                UpdateVisitTime(visitorId, isCheckIn: false);
                LoadVisitorApprovals(); // refresh data
            }
        }

        private void UpdateVisitTime(int visitorId, bool isCheckIn)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string columnToUpdate = isCheckIn ? "CheckInTime" : "CheckOutTime";
                    string query = $"UPDATE Visitors SET {columnToUpdate} = @Time WHERE VisitorID = @VisitorID";

                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@Time", DateTime.Now);
                    command.Parameters.AddWithValue("@VisitorID", visitorId);
                    command.ExecuteNonQuery();

                    // Check if both times are filled, then mark IsCompleted = 1
                    SqlCommand checkCommand = new SqlCommand(
                        @"UPDATE Visitors
                          SET IsCompleted = 
                              CASE 
                                  WHEN CheckInTime IS NOT NULL AND CheckOutTime IS NOT NULL THEN 1
                                  ELSE 0
                              END
                          WHERE VisitorID = @VisitorID", connection);

                    checkCommand.Parameters.AddWithValue("@VisitorID", visitorId);
                    checkCommand.ExecuteNonQuery();
                }

                string action = isCheckIn ? "Check-In" : "Check-Out";
                ShowMessage($"{action} successful for Visitor ID {visitorId}.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating time: " + ex.Message, "danger");
            }
        }

        // Helper methods for binding
        public string GetStatusText(object isApproved)
        {
            if (isApproved == DBNull.Value || isApproved == null) return "Pending";
            bool approved = Convert.ToBoolean(isApproved);
            return approved ? "Approved" : "Rejected";
        }

        public string GetStatusCssClass(object isApproved)
        {
            if (isApproved == DBNull.Value || isApproved == null) return "status-pending";
            bool approved = Convert.ToBoolean(isApproved);
            return approved ? "status-approved" : "status-rejected";
        }

        public bool IsApproved(object isApproved)
        {
            if (isApproved == DBNull.Value || isApproved == null) return false;
            return Convert.ToBoolean(isApproved);
        }

        private void ShowMessage(string message, string alertType)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"alert alert-{alertType} alert-dismissible fade show";
            lblMessage.Visible = true;
        }

        protected void gvVisitorApprovals_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView rowView = (DataRowView)e.Row.DataItem;

                bool isCheckedIn = rowView["CheckInTime"] != DBNull.Value;
                bool isCheckedOut = rowView["CheckOutTime"] != DBNull.Value;
                Button btnCheckIn = (Button)e.Row.FindControl("btnCheckIn");
                Button btnCheckOut = (Button)e.Row.FindControl("btnCheckOut");

                // Enable/Disable buttons
                if (btnCheckIn != null)
                {
                    btnCheckIn.Enabled = !isCheckedIn;
                    if (!btnCheckIn.Enabled) btnCheckIn.CssClass += " disabled";
                }

                if (btnCheckOut != null)
                {
                    btnCheckOut.Enabled = !isCheckedOut;
                    if (!btnCheckOut.Enabled) btnCheckOut.CssClass += " disabled";
                }
            }
        }
    }
}
