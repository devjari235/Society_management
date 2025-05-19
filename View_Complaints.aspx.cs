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
    public partial class View_Complaints : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            {
                BindComplain();
            }
        }
        private void BindComplain()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Step 1: Update expired notices
                //string updateQuery = @"UPDATE tblComplaint 
                //               SET Status = 'Resolved',Resolve_date=GETDATE() 
                //               WHERE Status != 'Resolved'";
                //SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                //updateCmd.ExecuteNonQuery();

                // Step 2: Fetch notices
                //string selectQuery = @"SELECT Notice_id, Title, Description, Expiry_date, File_path, Importance, Status 
                //               FROM tblNotices 
                //               WHERE Expiry_date IS NULL OR Expiry_date >= GETDATE() 
                //               ORDER BY Posted_date DESC";

                string selectQuery = "SELECT u.User_name,c.Complaint_type,c.Complaint_id,c.Priority,c.Status from tblComplaint c join tblUser u on c.User_id=u.User_id \r\nJOIN tblOwner o ON u.Owner_id = o.Owner_id\r\nJOIN tblBlock b ON o.Block_id = b.Block_id\r\nJOIN tblSociety s ON s.Society_id = b.Society_id\r\nWHERE s.admin_id = @id\r\n";
                SqlCommand cmd = new SqlCommand(selectQuery, conn);
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();
            }
        }
        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lnkStatus = (LinkButton)e.Row.FindControl("lnkStatus");

                // Apply CSS class based on status
                if (lnkStatus != null)
                {
                    string status = lnkStatus.Text;
                    lnkStatus.CssClass = "status-link status-" + status.Replace(" ", "");
                }
                //e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvDisplay, "Select$" + e.Row.RowIndex);
                //e.Row.ToolTip = "Click to select this row.";
            }
        }
        protected void gvDisplay_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedIndex = gvDisplay.SelectedIndex;
            if (selectedIndex >= 0)
            {
                // Get the Notice_id from DataKeys
                string ComplainId = gvDisplay.DataKeys[selectedIndex].Value.ToString();

                // Redirect to details page with the id
                Response.Redirect("Complaint_Details.aspx?id=" + ComplainId);
            }
        }
        protected void gvDisplay_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvDisplay.Rows[rowIndex];

                // Get the complaint ID from DataKeys
                int complaintId = Convert.ToInt32(gvDisplay.DataKeys[rowIndex].Value);

                // Get current status
                LinkButton lnkStatus = (LinkButton)row.FindControl("lnkStatus");
                string currentStatus = lnkStatus.Text;

                // Determine next status
                string newStatus = GetNextStatus(currentStatus);

                // Update in database (implement this method)
                if (UpdateComplaintStatus(complaintId, newStatus))
                {
                    // Update the UI
                    lnkStatus.Text = newStatus;

                    // Update the CSS class
                    lnkStatus.CssClass = "status-link status-" + newStatus.Replace(" ", "");

                    // Show success message
                    Panel1.Visible = true;
                    Label1.Text = "Status updated successfully!";
                    Panel1.CssClass = "alert alert-success";
                }
                else
                {
                    // Show error message
                    Panel1.Visible = true;
                    Label1.Text = "Error updating status. Please try again.";
                    Panel1.CssClass = "alert alert-danger";
                }
            }
        }

        private string GetNextStatus(string currentStatus)
        {
            // Define your status workflow
            switch (currentStatus)
            {
                case "Pending": return "Active";
                case "Active": return "In Progress";
                case "In Progress": return "Resolved";
                case "Resolved": return "Pending"; // or whatever makes sense for your workflow
                default: return "Pending";
            }
        }

        private bool UpdateComplaintStatus(int complaintId, string newStatus)
        {
            // Implement your database update logic here
            // Example:
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE tblComplaint SET Status = @Status WHERE Complaint_id = @ComplaintId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@ComplaintId", complaintId);

                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    return result > 0;
                }
            }
        }
    }
}