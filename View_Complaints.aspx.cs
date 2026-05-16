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
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        string Status;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["A_id"] == null && Request.Cookies["AdminInfo"] != null)
            {
                string uid = Request.Cookies["AdminInfo"]["A_id"];
                if (!string.IsNullOrEmpty(uid))
                {
                    Session["A_id"] = uid;
                    Response.Redirect("AdminDashboard.aspx");
                }
            }

            if (!IsPostBack) 
            {
                BindComplain();
                //if (Status == "Resolved")
                //{
                //    ErrorStatus();
                //}
                MarkNoticesSeen();
            }
            
        }
        private void MarkNoticesSeen()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString))
            {
                string query = "UPDATE tblComplaint SET IsSeen = 1 WHERE IsSeen = 0";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        private void BindComplain()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string selectQuery = @"SELECT u.User_name, c.Complaint_type, c.Complaint_id, c.Priority, c.Status, c.Create_date 
                               FROM tblComplaint c 
                               JOIN tblUser u ON c.User_id = u.User_id 
                               JOIN tblOwner o ON u.Owner_id = o.Owner_id
                               JOIN tblBlock b ON o.Block_id = b.Block_id
                               JOIN tblSociety s ON s.Society_id = b.Society_id
                               WHERE s.admin_id = @id";

                SqlCommand cmd = new SqlCommand(selectQuery, conn);
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();

                // ── TOGGLE VISIBILITY LOGIC ──
                if (dt.Rows.Count > 0)
                {
                    phDataContent.Visible = true;  // Show White Card
                    pnlEmpty.Visible = false;      // Hide Empty State
                }
                else
                {
                    phDataContent.Visible = false; // Hide White Card entirely
                    pnlEmpty.Visible = true;       // Show Centered Empty State
                }
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
                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    if (i < 3) 
                    {
                        // Add click event to cell
                        e.Row.Cells[i].Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvDisplay, "Select$" + e.Row.RowIndex);
                        e.Row.Cells[i].ToolTip = "Click to select this row";
                        e.Row.Cells[i].Style["cursor"] = "pointer"; // Show pointer cursor
                    }
                    else
                    {
                        // Remove any click events from other cells
                        e.Row.Cells[i].Attributes.Remove("onclick");
                        e.Row.Cells[i].ToolTip = "";
                        e.Row.Cells[i].Style["cursor"] = "default"; // Show default cursor
                    }
                }
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
                if (currentStatus == "Resolved")
                {
                    ErrorStatus(); // Show error message
                    return; // Exit without updating
                }
                // Determine next status
                string newStatus = GetNextStatus(currentStatus);

                // Update in database (implement this method)
                if (UpdateComplaintStatus(complaintId, newStatus))
                {
                    // Update the UI
                    lnkStatus.Text = newStatus;
                    
                    // Update the CSS class
                    lnkStatus.CssClass = "status-link status-" + newStatus.Replace(" ", "");

                        string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Status updated successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'View_Complaints.aspx';
            });";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                    
                    //// Show success message
                    //Panel1.Visible = true;
                    //Label1.Text = "Status updated successfully!";
                    //Panel1.CssClass = "alert alert-success";
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
                case "Resolved":return "Resolved";
                default: return "Pending";
            }
        }
 
        public void ErrorStatus()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select c.Status from tblComplaint c join tblUser u on c.User_id=u.User_id \r\nJOIN tblOwner o ON u.Owner_id = o.Owner_id\r\nJOIN tblBlock b ON o.Block_id = b.Block_id\r\nJOIN tblSociety s ON s.Society_id = b.Society_id\r\nWHERE s.admin_id = @id\r\n";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Status = reader["Status"].ToString();
                if(Status == "Resolved")
                {
                    string script = @"
        <script>
            Swal.fire({
                icon: 'error',
                text: 'Cannot change status from Resolved',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
        </script>";
                    ClientScript.RegisterStartupScript(this.GetType(), "StatusChangeError", script);
                }
            }

        }
        private bool UpdateComplaintStatus(int complaintId, string newStatus)
        {
            // Implement your database update logic here
            // Example:
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                //con.Open();
                //string updateQuery = @"UPDATE tblComplaint 
                //                    SET Resolve_date=GETDATE() 
                //                    WHERE Status='Resolved'";
                //SqlCommand updateCmd = new SqlCommand(updateQuery, con);
                //updateCmd.ExecuteNonQuery();
                //con.Close();
                //string query = "UPDATE tblComplaint SET Status = @Status WHERE Complaint_id = @ComplaintId";
                using (SqlCommand cmd = new SqlCommand(@"UPDATE tblComplaint 
          SET Status = @Status,
              Resolve_date = CASE WHEN @Status = 'Resolved' THEN GETDATE() ELSE Resolve_date END
          WHERE Complaint_id = @ComplaintId", con))
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