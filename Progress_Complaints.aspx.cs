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
    public partial class Progress_Complaints : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProgress();
            }
        }
        private void BindProgress()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Step 1: Update expired notices
                // Step 2: Fetch notices
                //string selectQuery = @"SELECT Notice_id, Title, Description, Expiry_date, File_path, Importance, Status 
                //               FROM tblNotices 
                //               WHERE Expiry_date IS NULL OR Expiry_date >= GETDATE() 
                //               ORDER BY Posted_date DESC";

                string selectQuery = "SELECT u.User_name,c.Complaint_type,c.Complaint_id,c.Priority,c.Status from tblComplaint c join tblUser u on c.User_id=u.User_id \r\nJOIN tblOwner o ON u.Owner_id = o.Owner_id\r\nJOIN tblBlock b ON o.Block_id = b.Block_id\r\nJOIN tblSociety s ON s.Society_id = b.Society_id\r\nWHERE s.admin_id = @id\r\n and c.Status='In Progress'";
                SqlCommand cmd = new SqlCommand(selectQuery, conn);
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);
                // Add this to debug
                if (ds.Tables[0].Rows.Count == 0)
                {
                    Label1.Text = "No Progress Complaints.";
                    Panel1.Visible = true;
                }
                gvDisplay.DataSource = ds;
                gvDisplay.DataBind();
                conn.Close();
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