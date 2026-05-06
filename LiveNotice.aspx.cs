using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class LiveNotice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindNotices();
            }
        }

        // ─────────────────────────────────────────────
        //  BIND NOTICES
        // ─────────────────────────────────────────────
        private void BindNotices()
        {
            // Guard: redirect to login if session expired
            if (Session["A_id"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            int adminId = Convert.ToInt32(Session["A_id"]);
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Step 1: Auto-expire old notices
                string updateQuery = @"
                    UPDATE tblNotices
                    SET    Status = 'Expired'
                    WHERE  Expiry_date < GETDATE()
                    AND    Status     != 'Expired'";

                new SqlCommand(updateQuery, conn).ExecuteNonQuery();

                // Step 2: Fetch live notices for this admin
                string selectQuery = @"
                    SELECT
                        n.Notice_id,
                        n.Title,
                        n.Description,
                        n.Expiry_date,
                        n.File_path,
                        n.Importance,
                        n.Status,
                        n.Posted_date,
                        a.name
                    FROM   tblNotices n
                    INNER JOIN tblAdmin a ON n.admin_id = a.admin_id
                    WHERE  a.admin_id = @id
                    AND    (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE())
                    ORDER  BY n.Posted_date DESC";

                SqlCommand cmd = new SqlCommand(selectQuery, conn);
                cmd.Parameters.AddWithValue("@id", adminId);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();

                // ── Show empty state if no live notices ───────────────────────
                bool hasRows = dt.Rows.Count > 0;
                gvDisplay.Visible = hasRows;
                pnlEmpty.Visible = !hasRows;
            }
        }

        // ─────────────────────────────────────────────
        //  ROW DATA BOUND — make rows clickable
        // ─────────────────────────────────────────────
        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] =
                    Page.ClientScript.GetPostBackClientHyperlink(
                        gvDisplay, "Select$" + e.Row.RowIndex);
                e.Row.ToolTip = "Click to view notice details.";
                e.Row.Style["cursor"] = "pointer";
            }
        }

        // ─────────────────────────────────────────────
        //  ROW SELECTED — redirect to details
        // ─────────────────────────────────────────────
        protected void gvDisplay_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedIndex = gvDisplay.SelectedIndex;
            if (selectedIndex >= 0)
            {
                string noticeId = gvDisplay.DataKeys[selectedIndex].Value.ToString();
                Response.Redirect("Admin_noticeDetails.aspx?id=" + noticeId);
            }
        }

        // ─────────────────────────────────────────────
        //  HELPERS — CSS class by status / importance
        // ─────────────────────────────────────────────
        public string GetStatusClass(string status)
        {
            return status.ToLower() == "live"
                ? "status-badge status-live"
                : "status-badge status-expired";
        }

        public string GetImportanceClass(string importance)
        {
            switch (importance.ToLower())
            {
                case "urgent": return "importance-high";
                case "important": return "importance-medium";
                default: return "importance-low";
            }
        }
    }
}