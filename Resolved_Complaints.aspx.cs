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
    public partial class Resolved_Complaints : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindResolved();
            }
        }
        private void BindResolved()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string selectQuery = @"SELECT u.User_name, c.Complaint_type, c.Complaint_id, c.Priority, c.Status 
                               FROM tblComplaint c 
                               JOIN tblUser u ON c.User_id = u.User_id 
                               JOIN tblOwner o ON u.Owner_id = o.Owner_id
                               JOIN tblBlock b ON o.Block_id = b.Block_id
                               JOIN tblSociety s ON s.Society_id = b.Society_id
                               WHERE s.admin_id = @id AND c.Status='Resolved'";

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
                    phDataContent.Visible = true;  // Show the data card
                    pnlEmpty.Visible = false;      // Hide the empty state
                    Panel1.Visible = false;
                }
                else
                {
                    phDataContent.Visible = false; // Completely hide the white box card
                    pnlEmpty.Visible = true;       // Show the professional empty state
                }
            }
        }


        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvDisplay, "Select$" + e.Row.RowIndex);
                e.Row.ToolTip = "Click to select this row.";
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
                Response.Redirect("Complaint_Details.aspx?id=" + noticeId);
            }
        }
    }
}