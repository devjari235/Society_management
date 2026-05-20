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
  AND (
      n.Type NOT IN ('Notice', 'Event') 
      OR n.ReferenceID IN (
          SELECT Notice_id FROM tblNotices WHERE admin_id = (
              SELECT TOP 1 s.admin_id 
              FROM tblUser u
              INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id
              INNER JOIN tblBlock b ON o.Block_id = b.Block_id
              INNER JOIN tblSociety s ON b.Society_id = s.Society_id
              WHERE u.User_id = @UserId
          )
      )
      OR n.ReferenceID IN (
          SELECT EventId FROM tblEvents WHERE admin_id = (
              SELECT TOP 1 s.admin_id 
              FROM tblUser u
              INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id
              INNER JOIN tblBlock b ON o.Block_id = b.Block_id
              INNER JOIN tblSociety s ON b.Society_id = s.Society_id
              WHERE u.User_id = @UserId
          )
      )
  )
ORDER BY CreatedDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                DataTable dtToday = dt.Clone();
                DataTable dtYesterday = dt.Clone();
                DataTable dtEarlier = dt.Clone();

                // 🧠 FORCE INDIAN STANDARD TIME (IST) TIME ZONE CONTEXT
                TimeZoneInfo indiaTimeZone = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
                DateTime indiaCurrentTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, indiaTimeZone);
                DateTime indiaToday = indiaCurrentTime.Date;
                DateTime indiaYesterday = indiaToday.AddDays(-1);

                foreach (DataRow row in dt.Rows)
                {
                    DateTime databaseDate = Convert.ToDateTime(row["CreatedDate"]);

                    // If your database stores dates in UTC, convert it to IST first. 
                    // If your DB already stores absolute Indian time, use: DateTime checkDate = databaseDate.Date;
                    DateTime checkDate = TimeZoneInfo.ConvertTime(databaseDate, indiaTimeZone).Date;

                    if (checkDate == indiaToday)
                        dtToday.ImportRow(row);
                    else if (checkDate == indiaYesterday)
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

                // PANEL VISIBILITY FIX
                pnlToday.Visible = dtToday.Rows.Count > 0;
                pnlYesterday.Visible = dtYesterday.Rows.Count > 0;
                pnlEarlier.Visible = dtEarlier.Rows.Count > 0;

                // EMPTY STATE
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

            // 1. Mark as Read logic based on types 
            if (type == "Remark")
            {
                // Parse the reference ID into an integer to match your tblRemarks schema field parameters
                if (int.TryParse(refId, out int complaintId))
                {
                    MarkRemarksAsSeen(complaintId);
                }
            }
            else
            {
                MarkNotificationAsRead(refId);
            }

            // 2. Redirection Logic execution paths
            switch (type)
            {
                case "Remark":
                    Response.Redirect("User_Complaint_Details.aspx?id=" + refId);
                    break;
                case "Poll":
                    Response.Redirect("User_Poll.aspx?id=" + refId);
                    break;
                case "Notice":
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