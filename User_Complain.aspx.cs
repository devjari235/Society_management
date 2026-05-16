using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace Society_management
{
    public partial class User_Complain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            { 
                  int userId = Convert.ToInt32(Session["U_id"]);
                  BindComplaints(userId);
            }
        }

        private void BindComplaints(int userId)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                c.Complaint_id,
                c.Complaint_type,
                c.Priority,
                c.Status,
                c.Create_date,
                c.Resolve_date,
                ISNULL(UnreadCount.UnreadRemarks, 0) AS UnreadRemarks
            FROM tblComplaint c
            LEFT JOIN (
                SELECT Complaint_id, COUNT(*) AS UnreadRemarks
                FROM tblRemarks
                WHERE IsSeenByUser = 0
                GROUP BY Complaint_id
            ) AS UnreadCount
            ON c.Complaint_id = UnreadCount.Complaint_id
            WHERE c.User_id = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        // Toggle presentation components cleanly based on result count
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            gvDisplay.DataSource = dt;
                            gvDisplay.DataBind();

                            pnlEmpty.Visible = false;
                            phDataContent.Visible = true;
                        }
                        else
                        {
                            gvDisplay.DataSource = null;
                            gvDisplay.DataBind();

                            pnlEmpty.Visible = true;
                            phDataContent.Visible = false;
                        }
                    }
                }
            }
        }
        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvDisplay, "Select$" + e.Row.RowIndex);
                e.Row.ToolTip = "Click to select this row.";
                string status = DataBinder.Eval(e.Row.DataItem, "Status").ToString().Replace(" ", "");
                Label lblStatus = (Label)e.Row.FindControl("lblStatus");

                if (lblStatus != null)
                {
                    lblStatus.CssClass = "status-" + status;
                }
                string priority = DataBinder.Eval(e.Row.DataItem, "Priority").ToString();
                Label lblPriority = (Label)e.Row.FindControl("lblPriority");
                if (lblPriority != null)
                {
                    lblPriority.CssClass = "priority-" + priority;
                }
            }
        }



        protected void gvDisplay_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedIndex = gvDisplay.SelectedIndex;
            if (selectedIndex >= 0)
            {
                // Get the Notice_id from DataKeys
                string noticeId = gvDisplay.DataKeys[selectedIndex].Value.ToString();

                // Redirect to details page with the id
                Response.Redirect("User_Complaint_Details.aspx?id=" + noticeId);
            }
        }


    }
}