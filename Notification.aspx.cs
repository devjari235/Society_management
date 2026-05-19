using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Notification : Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["U_id"] == null)
            {
                Response.Redirect("~/u_login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["U_id"]);
            hdnUserId.Value = userId.ToString();

            if (!IsPostBack)
            {
                LoadAllNotifications(userId);
            }
        }

        private void LoadAllNotifications(int userId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
                SELECT 
                    r.RemarkText AS Message,
                    r.RemarkDate AS CreatedDate,
                    a.name AS Title,
                    'Remark' AS Type,
                    c.Complaint_id AS RefId,
                    r.IsSeenByUser AS IsRead
                FROM tblRemarks r
                INNER JOIN tblComplaint c ON r.Complaint_id = c.Complaint_id
                INNER JOIN tblAdmin a ON r.admin_id = a.admin_id
                WHERE c.User_id = @UserId

                UNION ALL

                SELECT 
                    n.Message,
                    n.CreatedDate,
                    n.Title,
                    n.Type,
                    n.ReferenceID AS RefId,
                    n.IsRead
                FROM Notifications n
                WHERE n.User_id = @UserId

                ORDER BY CreatedDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                DataTable dtToday = dt.Clone();
                DataTable dtYesterday = dt.Clone();
                DataTable dtEarlier = dt.Clone();

                foreach (DataRow row in dt.Rows)
                {
                    DateTime date = Convert.ToDateTime(row["CreatedDate"]);

                    if (date.Date == DateTime.Today)
                        dtToday.ImportRow(row);
                    else if (date.Date == DateTime.Today.AddDays(-1))
                        dtYesterday.ImportRow(row);
                    else
                        dtEarlier.ImportRow(row);
                }

                rptToday.DataSource = dtToday;
                rptToday.DataBind();

                rptYesterday.DataSource = dtYesterday;
                rptYesterday.DataBind();

                rptEarlier.DataSource = dtEarlier;
                rptEarlier.DataBind();

                // ✅ PANEL VISIBILITY FIX
                pnlToday.Visible = dtToday.Rows.Count > 0;
                pnlYesterday.Visible = dtYesterday.Rows.Count > 0;
                pnlEarlier.Visible = dtEarlier.Rows.Count > 0;

                // ✅ EMPTY STATE
                pnlEmpty.Visible =
                    dtToday.Rows.Count == 0 &&
                    dtYesterday.Rows.Count == 0 &&
                    dtEarlier.Rows.Count == 0;
            }
        }

        public string GetTimeAgo(DateTime date)
        {
            return date.ToString("dd MMM yyyy hh:mm tt");
        }

        protected void rptRemarks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string type = e.CommandName;
            string refId = e.CommandArgument.ToString();

            // 1. Mark as Read logic (Ensure your SQL update is called here)
            MarkNotificationAsRead(refId);

            // 2. Redirection Logic
            switch (type)
            {
                case "Remark":
                    Response.Redirect("User_Complaint_Details.aspx?id=" + refId); // Or wherever you show complaint remarks
                    break;
                case "Poll":
                    Response.Redirect("User_Poll.aspx?id=" + refId);
                    break;
                case "Notice":
                    // Redirect to the page where users view notices
                    Response.Redirect("UserDashboard.aspx#latest-announcements");
                    break;
                case "Event":
                    Response.Redirect("User_Event_Details.aspx?EventId=" + refId);
                    break;
            }
        }
        private void MarkRemarksAsSeen(int id)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("UPDATE tblRemarks SET IsSeenByUser=1 WHERE Complaint_id=@Id", con);
                cmd.Parameters.AddWithValue("@Id", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void MarkNotificationAsRead(string refId)
        {
            string strcon = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(strcon))
            {
                // It's better to use the NotificationID if available, 
                // but if using refId, ensure you filter by User_id too.
                string query = "UPDATE Notifications SET IsRead = 1 WHERE ReferenceID = @RefId AND User_id = @Uid";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@RefId", refId);
                cmd.Parameters.AddWithValue("@Uid", Session["U_id"]);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        [WebMethod]
        public static string GetNotifications(int userId)
        {
            return "ok";
        }
    }
}