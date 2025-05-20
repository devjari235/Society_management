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
                string query = @"SELECT Complaint_id,Complaint_type, Priority, Status, Create_date, Resolve_date 
                           FROM tblComplaint 
                           WHERE User_id = @UserId
                           ORDER BY Create_date DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvDisplay.DataSource = dt;
                        gvDisplay.DataBind();
                       
                    }
                    else
                    {
                        gvDisplay.DataSource = null;
                        gvDisplay.DataBind();
                        
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