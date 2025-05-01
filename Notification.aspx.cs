using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Society_management.NoticeBoard;
using System.Drawing;

namespace Society_management
{
    public partial class Notification : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MarkNoticesSeen();
                LoadActiveNotices();
                ExpireOldNotices();
            }
        }
        //private void LoadNotifications()
        //{
        //    // Show latest 5 notices as notifications
        //    var latestNotices = Notices.OrderByDescending(n => n.DatePosted).Take(5);
        //    rptNotifications.DataSource = latestNotices;
        //    rptNotifications.DataBind();
        //}
        //private void LoadNotices()
        //{
        //    rptNotices.DataSource = Notices;
        //    rptNotices.DataBind();

        //    LoadNotifications(); // <-- ADD THIS
        //}

        //private void LoadNotices()
        //{
        //    rptNotices.DataSource = Notices;
        //    rptNotices.DataBind();
        //}

        //public class Notice
        //{
        //    public string Title { get; set; }
        //    public string Description { get; set; }
        //    public DateTime DatePosted { get; set; }
        //}
        private void LoadActiveNotices()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString))
            {
                string query = "SELECT Title, Description,Date FROM tblNoticeBoard WHERE Status = 'Active' AND admin_id=@id ORDER BY Date DESC ";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptNotices.DataSource = dt;
                rptNotices.DataBind();
            }
        }

        private void ExpireOldNotices()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString))
            {
                string query = "UPDATE tblNoticeBoard SET Status = 'Expired' WHERE Status = 'Active' AND DATEDIFF(DAY, Date, GETDATE()) > 1";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void MarkNoticesSeen()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString))
            {
                string query = "UPDATE tblNoticeBoard SET IsSeen = 1 WHERE IsSeen = 0";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

    }
}