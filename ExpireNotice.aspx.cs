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
    public partial class ExpireNotice : System.Web.UI.Page
    {
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
                BindExpiredNotices();
            }

        }

        private void BindExpiredNotices()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Update expired statuses
                SqlCommand updateCmd = new SqlCommand("UPDATE tblNotices SET Status='Expired' WHERE Expiry_date < GETDATE() AND Status != 'Expired'", conn);
                updateCmd.ExecuteNonQuery();

                // 2. Fetch Expired data
                SqlCommand cmd = new SqlCommand(@"SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, 
                                          n.Importance, n.Status, n.Posted_date, a.name 
                                          FROM tblNotices n 
                                          INNER JOIN tblAdmin a ON n.admin_id = a.admin_id 
                                          WHERE a.admin_id=@id AND Status='Expired' 
                                          ORDER BY Expiry_date DESC", conn);

                cmd.Parameters.AddWithValue("id", Session["A_id"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();

                // ── TOGGLE VISIBILITY LOGIC ──
                if (dt.Rows.Count > 0)
                {
                    phDataContent.Visible = true; // Show the White Card/Table
                    pnlEmpty.Visible = false;     // Hide Empty State
                }
                else
                {
                    phDataContent.Visible = false; // HIDE Entire Card Container
                    pnlEmpty.Visible = true;       // Show Professional Centered State
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

        public string GetStatusClass(string status)
        {
            return status.ToLower() == "live" ? "status-badge status-live" : "status-badge status-expired";
        }

        public string GetImportanceClass(string importance)
        {
            switch (importance.ToLower())
            {
                case "urgent":
                    return "importance-high";
                case "important":
                    return "importance-medium";
                default:
                    return "importance-low";
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
                Response.Redirect("Admin_noticeDetails.aspx?id=" + noticeId);
            }
        }
    }
}