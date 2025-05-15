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
    public partial class UserDashboard : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Convert.ToInt32(Session["U_id"]);
                IsCommitteeMember(userId);
                bindOwnerID();
                IsOwner();
                IsUser();
                BindNotices();
                rptNotices.ItemCommand += rptNotices_ItemCommand;
            }
            //LoadDashboardData();
        }
        //private void LoadDashboardData()
        //{


        //    // Load user stats
        //    lblMaintenanceDue.Text = "₹2,500";
        //    lblDueDate.Text = DateTime.Now.AddDays(10).ToString("dd MMM yyyy");
        //    lblPendingPayments.Text = "2";
        //    lblOpenComplaints.Text = "3";
        //    lblNewNotices.Text = "5";

        //    // Load recent activity
        //    var recentActivity = new List<dynamic>
        //{
        //    new {
        //        Title = "Complaint Registered",
        //        Description = "Water leakage in bathroom has been registered",
        //        Date = DateTime.Now.AddHours(-2).ToString("dd MMM hh:mm tt"),
        //        Link = "MyComplaints.aspx",
        //        ActivityClass = "complaint"
        //    },
        //    new {
        //        Title = "Payment Received",
        //        Description = "Maintenance payment for October received",
        //        Date = DateTime.Now.AddDays(-1).ToString("dd MMM hh:mm tt"),
        //        Link = "MyPayments.aspx",
        //        ActivityClass = "payment"
        //    },
        //    new {
        //        Title = "New Notice",
        //        Description = "Society meeting on 25th October",
        //        Date = DateTime.Now.AddDays(-2).ToString("dd MMM hh:mm tt"),
        //        Link = "NoticeBoard.aspx",
        //        ActivityClass = "notice"
        //    }
        //};

        //    if (recentActivity.Count > 0)
        //    {
        //        rptRecentActivity.DataSource = recentActivity;
        //        rptRecentActivity.DataBind();
        //        pnlNoActivity.Visible = false;
        //    }
        //    else
        //    {
        //        pnlNoActivity.Visible = true;
        //    }

        //    // Load important notices
        //    var importantNotices = new List<dynamic>
        //{
        //    new {
        //        Title = "Annual Maintenance Hike",
        //        Summary = "Maintenance charges will increase by 10% from next month",
        //        Date = "15 Oct 2023",
        //        Link = "NoticeDetails.aspx?id=1"
        //    },
        //    new {
        //        Title = "Diwali Celebration",
        //        Summary = "Society Diwali celebration on 12th November at club house",
        //        Date = "10 Oct 2023",
        //        Link = "NoticeDetails.aspx?id=2"
        //    }
        //};

        //    if (importantNotices.Count > 0)
        //    {
        //        rptImportantNotices.DataSource = importantNotices;
        //        rptImportantNotices.DataBind();
        //        pnlNoNotices.Visible = false;
        //    }
        //    else
        //    {
        //        pnlNoNotices.Visible = true;
        //    }
        //}
        public bool IsCommitteeMember(int userId)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT COUNT(*) FROM tblCommitteeMember WHERE User_id = @UserId AND Status = 'Current'";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
        int id;
        public void bindOwnerID()
        {
            int userId = Convert.ToInt32(Session["U_id"]);
            SqlConnection con = new SqlConnection(strcon);
            con.Open();

            string Query = @"SELECT o.Owner_id 
                     FROM tblOwner o 
                     JOIN tblUser u ON o.Owner_id = u.Owner_id 
                     WHERE o.Email_id = (SELECT Email FROM tblUser WHERE User_id = @UserId)";

            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@UserId", userId);

            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                id = Convert.ToInt32(reader["Owner_id"]);
            }
            else
            {
                id = 0; 
            }

            reader.Close();
            con.Close();
        }

        public bool IsOwner()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT COUNT(*) FROM tblOwner WHERE Owner_id = @OwnerId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@OwnerId", id);
                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
        public bool IsUser()
        {
            int userId = Convert.ToInt32(Session["U_id"]);
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT COUNT(*) FROM tblUser WHERE User_id=@UserId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
        private void BindNotices()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                int userId = Convert.ToInt32(Session["U_id"]);
                conn.Open();
                string updateQuery = @"UPDATE tblNotices 
                               SET Status = 'Expired' 
                               WHERE Expiry_date < GETDATE() AND Status != 'Expired'";
                SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                updateCmd.ExecuteNonQuery();
                DataTable allnotice = new DataTable();
                if (IsCommitteeMember(userId) == true)
                {
                    // Step 1: Update expired notices
   
                    string selectQuery = "SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE (n.Send_via='On App' or n.Send_via='Email,On App') and n.Broadcast_By='Committee Member' and (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE()) ORDER BY  n.Posted_date DESC";
                    SqlCommand cmd = new SqlCommand(selectQuery, conn);
                    //  cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    allnotice.Merge(dt);
                }
                if (IsOwner() == true)
                {
                    string selectQuery = "SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE (n.Send_via='On App' or n.Send_via='Email,On App')and n.Broadcast_By='Owners' and (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE()) ORDER BY  n.Posted_date DESC";
                    SqlCommand cmd = new SqlCommand(selectQuery, conn);
                    //  cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    allnotice.Merge(dt);
                }
                if (IsUser() == true) 
                {
                    string selectQuery = "SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE (n.Send_via='On App' or n.Send_via='Email,On App')and n.Broadcast_By='All Members' and (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE()) ORDER BY  n.Posted_date DESC";
                    SqlCommand cmd = new SqlCommand(selectQuery, conn);
                    //  cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    allnotice.Merge(dt);


                }
                rptNotices.DataSource = allnotice;
                rptNotices.DataBind();

            }
        }


        public string GetImportanceClass(string importance)
        {
            switch (importance.ToLower())
            {
                case "important": return "badge-important";
                case "urgent": return "badge-urgent";
                default: return "badge-normal";
            }
        }

        protected void rptNotices_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string noticeId = e.CommandArgument.ToString();
                Response.Redirect("NoticeDetails.aspx?id=" + noticeId);
            }
        }
    }
}