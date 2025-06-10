using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
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
                
                bindOwnerID();
                IsOwner();
                IsUser();

                    LoadDashboardData();
                    LoadNotices();
                    LoadUpcomingEvents();
                
            }
        }

        private void LoadDashboardData()
        {
            int userId = Convert.ToInt32(Session["U_id"]);

            // Get maintenance due information
            LoadMaintenanceData(userId);

            // Get visitor information
            LoadVisitorData(userId);

            // Get upcoming event information
            LoadEventData();
            IsCommitteeMember(userId);
        }

        private void LoadMaintenanceData(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // Get owner_id from tblUser
                string ownerQuery = "SELECT Owner_id FROM tblUser WHERE User_id = @UserId";
                SqlCommand ownerCmd = new SqlCommand(ownerQuery, con);
                ownerCmd.Parameters.AddWithValue("@UserId", userId);
                int ownerId = Convert.ToInt32(ownerCmd.ExecuteScalar());

                // Get flat and maintenance info
                string query = @"SELECT f.Mentanance, o.Allotment_Date 
                   FROM tblOwner o 
                   JOIN tblFlat f ON o.Flate_id = f.Flate_id 
                   WHERE o.Owner_id = @OwnerId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@OwnerId", ownerId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        decimal maintenanceAmount = Convert.ToDecimal(reader["Mentanance"]);
                        DateTime allotmentDate = Convert.ToDateTime(reader["Allotment_Date"]);

                        // Calculate due date
                        DateTime dueDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 25);
                        if (DateTime.Now.Day > 25)
                        {
                            dueDate = dueDate.AddMonths(1);
                        }

                        int daysLeft = (dueDate - DateTime.Now).Days;

                        // Update UI
                        lblMaintenanceAmount.Text = maintenanceAmount.ToString("N0");
                        lblDueDate.Text = dueDate.ToString("dd MMMM yyyy");
                        lblDaysLeft.Text = daysLeft == 1 ? "1 day left" : $"{daysLeft} days left";
                    }
                }

                // Now check if current month's payment is done
                int currentMonth = DateTime.Now.Month;
                int currentYear = DateTime.Now.Year;

                string paymentStatusQuery = @"SELECT Status FROM MaintenancePayments 
                                WHERE User_id = @UserId AND Month = @Month AND Year = @Year";

                SqlCommand paymentCmd = new SqlCommand(paymentStatusQuery, con);
                paymentCmd.Parameters.AddWithValue("@UserId", userId);
                paymentCmd.Parameters.AddWithValue("@Month", currentMonth);
                paymentCmd.Parameters.AddWithValue("@Year", currentYear);

                object statusObj = paymentCmd.ExecuteScalar();
                string status = statusObj != null ? statusObj.ToString().Trim().ToLower() : "pending";

                // Update UI based on payment status
                if (status == "completed")
                {
                    pnlDueMessage.Visible = false;
                    spanDaysLeft.Visible = false;
                    litBadgeText.Text = "Paid";
                    string badgeText = litBadgeText.Text; // or set it here if you want

                    if (badgeText.Contains("Paid")) // check if text contains "pay" (case-insensitive)
                    {
                        // Change color of the div containing the literal text
                        cardBadgeDiv.Style["background-color"] = "Green";
                        cardBadgeDiv.Style["color"] = "White"; // Or any color you want
                    }
                    else
                    {
                        // Default color (or remove style)
                        cardBadgeDiv.Style["color"] = ""; // clears inline style, falls back to CSS var(--white)
                    }
                    lblPaymentStatus.Text = "Maintenance Paid for this Month";
                    lblPaymentStatus.ForeColor = System.Drawing.Color.Green;

                    btnPayNow.Visible = false;
                    btnViewReceipt.Visible = true;
                }
                else
                {
                    pnlDueMessage.Visible = true;
                    spanDaysLeft.Visible = true;
                    litBadgeText.Text = "1 Pending";
                    lblPaymentStatus.Text = "Maintenance Pending";
                    lblPaymentStatus.ForeColor = System.Drawing.Color.Red;

                    btnPayNow.Visible = true;
                    btnViewReceipt.Visible = false;
                }

                // Store hidden values for redirect
                hdnUserId.Value = userId.ToString();
                hdnMonth.Value = currentMonth.ToString();
                hdnYear.Value = currentYear.ToString();
            }
        }
        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            Response.Redirect($"~/Payment.aspx?userid={hdnUserId.Value}&month={hdnMonth.Value}&year={hdnYear.Value}");
        }

        protected void btnViewReceipt_Click(object sender, EventArgs e)
        {
            Response.Redirect($"~/Payment.aspx?userid={hdnUserId.Value}&month={hdnMonth.Value}&year={hdnYear.Value}");
        }


        private void LoadVisitorData(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Get today's visitors count
                string countQuery = @"SELECT COUNT(*) FROM Visitors 
                                    WHERE User_id = @UserId 
                                    AND CONVERT(date, VisitDateTime) = CONVERT(date, GETDATE())";

                SqlCommand countCmd = new SqlCommand(countQuery, con);
                countCmd.Parameters.AddWithValue("@UserId", userId);

                con.Open();
                int visitorCount = Convert.ToInt32(countCmd.ExecuteScalar());
                lblVisitorCount.Text = $"{visitorCount} Today";
                lblTotalVisitors.Text = visitorCount.ToString();

                // Get last visitor time
                string lastVisitorQuery = @"SELECT TOP 1 VisitDateTime FROM Visitors 
                                          WHERE User_id = @UserId 
                                          ORDER BY VisitDateTime DESC";

                SqlCommand lastVisitorCmd = new SqlCommand(lastVisitorQuery, con);
                lastVisitorCmd.Parameters.AddWithValue("@UserId", userId);

                object lastVisitorTime = lastVisitorCmd.ExecuteScalar();
                if (lastVisitorTime != null)
                {
                    lblLastVisitorTime.Text = Convert.ToDateTime(lastVisitorTime).ToString("dd-MM-yyyy h:mm tt");

                }

                // Get next scheduled visitor
                string nextVisitorQuery = @"SELECT TOP 1 ScheduledDateTime FROM ScheduledVisits 
                                           WHERE User_id = @UserId 
                                           AND ScheduledDateTime > GETDATE() 
                                           AND IsCompleted = 0 
                                           ORDER BY ScheduledDateTime ASC";

                SqlCommand nextVisitorCmd = new SqlCommand(nextVisitorQuery, con);
                nextVisitorCmd.Parameters.AddWithValue("@UserId", userId);

                object nextVisitorTime = nextVisitorCmd.ExecuteScalar();
                if (nextVisitorTime != null)
                {
                    lblNextVisitorTime.Text = Convert.ToDateTime(nextVisitorTime).ToString("dd-MM-yyyy h:mm tt");
                    pnlNextVisitor.Visible = true;
                }
                else
                {
                    pnlNextVisitor.Visible = false;
                }
            }
        }

        private void LoadEventData()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT TOP 1 EventName, EventDate AS EventDay, 
                                EventDate AS StartTime, DATEADD(HOUR, 2, EventDate) AS EndTime
                                FROM tblEvents 
                                WHERE EventDate > GETDATE() 
                                ORDER BY EventDate ASC";

                SqlCommand cmd = new SqlCommand(query, con);

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblEventTitle.Text = reader["EventName"].ToString();
                        lblEventDate.Text = Convert.ToDateTime(reader["EventDay"]).ToString("dd MMMM");

                        DateTime eventDate = Convert.ToDateTime(reader["EventDay"]);
                        int daysToEvent = (eventDate - DateTime.Now).Days;
                        lblDaysToEvent.Text = $"{daysToEvent} days to go";

                        //pnlRegistration.Visible = true;
                    }
                    else
                    {
                        // No upcoming events
                        lblEventTitle.Text = "No upcoming events";
                        lblEventDate.Text = "";
                        lblDaysToEvent.Text = "";
                        //pnlRegistration.Visible = false;
                    }
                }
            }
        }

        private void LoadNotices()
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
                DataSet allnotice = new DataSet();
                if (IsCommitteeMember(userId) == true)
                {
                    // Step 1: Update expired notices

                    string selectQuery = "SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE (n.Send_via='On App' or n.Send_via='Email,On App') and n.Broadcast_By='Committee Member' and (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE()) ORDER BY  n.Posted_date DESC";
                    SqlCommand cmd = new SqlCommand(selectQuery, conn);
                    //  cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    allnotice.Merge(ds);
                }
                if (IsOwner() == true)
                {
                    string selectQuery = "SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE (n.Send_via='On App' or n.Send_via='Email,On App')and n.Broadcast_By='Owners' and (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE()) ORDER BY  n.Posted_date DESC";
                    SqlCommand cmd = new SqlCommand(selectQuery, conn);
                    //  cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    allnotice.Merge(ds);
                }
                if (IsUser() == true)
                {
                    string selectQuery = "SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE (n.Send_via='On App' or n.Send_via='Email,On App')and n.Broadcast_By='All Members' and (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE()) ORDER BY  n.Posted_date DESC";
                    SqlCommand cmd = new SqlCommand(selectQuery, conn);
                    //  cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);
                    allnotice.Merge(ds);


                }

                if (allnotice.Tables.Count > 0 && allnotice.Tables[0].Rows.Count > 0)
                {
                    rptNotices.DataSource = allnotice;
                    rptNotices.DataBind();
                    pnlNoNotice.Visible = false;
                }
                else
                {
                    rptNotices.DataSource = null;
                    rptNotices.DataBind();
                    pnlNoNotice.Visible = true;
                }
            }
        }

        private void LoadUpcomingEvents()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT EventName, EventDate AS EventDay, 
                               EventDate AS StartTime, DATEADD(HOUR, 2, EventDate) AS EndTime
                               FROM tblEvents 
                               WHERE EventDate > GETDATE() 
                               ORDER BY EventDate ASC";

                SqlCommand cmd = new SqlCommand(query, con);

                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptEvents.DataSource = dt;
                    rptEvents.DataBind();
                    pnlNoEvents.Visible = false;
                }
                else
                {
                    pnlNoEvents.Visible = true;
                }
            }
        }

        protected void rptNotices_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string noticeId = e.CommandArgument.ToString();
                Response.Redirect($"NoticeDetails.aspx?id={noticeId}");
            }
        }

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
    }
}