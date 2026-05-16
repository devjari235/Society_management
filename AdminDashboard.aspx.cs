using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔒 Prevent browser caching after logout
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));

            // 🔐 Check session
            if (Session["A_id"] == null)
            {
                // 🧠 Try to restore from cookie
                if (Request.Cookies["AdminInfo"] != null)
                {
                    string uid = Request.Cookies["AdminInfo"]["A_id"];
                    if (!string.IsNullOrEmpty(uid))
                    {
                        Session["A_id"] = uid;

                        // Optional: reload to ensure page loads fully under session
                        Response.Redirect(Request.RawUrl);
                        return;
                    }
                }

                // ❌ Session and cookie both missing — redirect to login
                Response.Redirect("Login.aspx?error=sessionexpired");
                return;
            }
            if (!IsPostBack)
            {

                // Load all data
                BindRecentActivities();
                SocietyID();
                lblTotalResidents.Text = GetTotalResident().ToString();
                lblTotalFlats.Text = GetTotalFlats().ToString();
                lblActiveComplaints.Text = GetTotalActiveComplaint().ToString();
                GetTotalPendingMaintainance();
            }
        }

        [WebMethod(EnableSession = true)]
        public static void TrackPageNavigation(string pageTitle)
        {
            HttpContext context = HttpContext.Current;

            // Get or create activity list
            List<Activity> activities = context.Session["RecentActivities"] as List<Activity> ?? new List<Activity>();

            // Check if same as last activity and within 5 minutes
            bool shouldAdd = true;
            if (activities.Count > 0)
            {
                var lastActivity = activities.First();
                if (lastActivity.Module.Equals(pageTitle, StringComparison.OrdinalIgnoreCase) &&
                    (DateTime.Now - lastActivity.Time).TotalMinutes < 5)
                {
                    shouldAdd = false;
                }
            }

            if (shouldAdd)
            {
                activities.Insert(0, new Activity
                {
                    Text = pageTitle,
                    Time = DateTime.Now,
                    Module = pageTitle,
                    Icon = GetModuleIconStatic(pageTitle)
                });

                while (activities.Count > 5)
                    activities.RemoveAt(activities.Count - 1);

                context.Session["RecentActivities"] = activities;
            }

            context.Session["LastPageTitle"] = pageTitle;
        }

        // Because static method can't access non-static method
        private static string GetModuleIconStatic(string moduleName)
        {
            if (string.IsNullOrEmpty(moduleName)) return "fas fa-circle";

            moduleName = moduleName.ToLower();

            if (moduleName.Contains("flat")) return "bi bi-house-fill";
            if (moduleName.Contains("owner") || moduleName.Contains("resident")) return "fas fa-users";
            if (moduleName.Contains("committee")) return "fas fa-users-cog";
            if (moduleName.Contains("visitor")) return "bi bi-person-vcard-fill";
            if (moduleName.Contains("notice")) return "bi bi-envelope-fill";
            if (moduleName.Contains("poll")) return "bi bi-bar-chart-fill";
            if (moduleName.Contains("document")) return "fas fa-file-alt";
            if (moduleName.Contains("gallery")) return "bi bi-images";
            if (moduleName.Contains("complaint")) return "fas fa-exclamation-circle";
            if (moduleName.Contains("event")) return "fas fa-calendar-alt";
            if (moduleName.Contains("finance")) return "fas fa-money-bill-wave";

            return "fas fa-circle";
        }


        private void BindRecentActivities()
        {

            List<Activity> activities = Session["RecentActivities"] as List<Activity>;

            if (activities != null && activities.Count > 0)
            {
                rptRecentActivity.DataSource = activities;
                rptRecentActivity.DataBind();
                lblNoActivity.Visible = false;
            }
            else
            {
                lblNoActivity.Visible = true;
            }
        }

        protected string GetModuleUrl(string moduleName)
        {
            if (string.IsNullOrEmpty(moduleName)) return "#";

            moduleName = moduleName.ToLower();

            //if (moduleName.Contains("dashboard")) return "AdminDashboard.aspx";
            if (moduleName.Contains("flat")) return "View_flat.aspx";
            if (moduleName.Contains("owner") || moduleName.Contains("resident")) return "View_Owner.aspx";
            if (moduleName.Contains("committee")) return "View_commiteeMember.aspx";
            if (moduleName.Contains("visitor")) return "VisitorApproval.aspx";
            if (moduleName.Contains("notice")) return "NoticeDashboard.aspx";
            if (moduleName.Contains("poll")) return "Poll_Result.aspx";
            if (moduleName.Contains("document")) return "View_Document.aspx";
            if (moduleName.Contains("gallery")) return "PhotoGallery.aspx";
            if (moduleName.Contains("complaint")) return "View_Complaints.aspx";
            if (moduleName.Contains("event")) return "ViewEvents.aspx";
            if (moduleName.Contains("finance")) return "Accounting.aspx";

            return "#";
        }

        // Add this new method to get pending payments count
        public void GetTotalPendingMaintainance()
        {
            // Check if session exists to avoid errors
            if (Session["A_id"] == null) return;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                // Added JOINS to tblBlock and tblSociety to filter by the logged-in Admin's ID
                string pendingQuery = @"SELECT ISNULL(SUM(f.Mentanance), 0) 
                                FROM tblFlat f
                                JOIN tblBlock b ON f.Block_id = b.Block_id
                                JOIN tblSociety s ON b.Society_id = s.Society_id
                                WHERE s.admin_id = @admin_id
                                AND NOT EXISTS (
                                    SELECT 1 FROM MaintenancePayments mp 
                                    WHERE mp.Flate_id = f.Flate_id 
                                    AND mp.Month = @Month 
                                    AND mp.Year = YEAR(GETDATE())
                                    AND mp.Status = 'Completed'
                                )";

                con.Open();
                using (SqlCommand cmd = new SqlCommand(pendingQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Month", DateTime.Now.Month);
                    cmd.Parameters.AddWithValue("@admin_id", Session["A_id"].ToString());

                    decimal totalPending = Convert.ToDecimal(cmd.ExecuteScalar());
                    lblPendingPayments.Text = totalPending.ToString("N2");
                }
            }
        }

        // Your existing methods
        string name;
        public void SocietyID()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select Society_name from tblSociety where admin_id=@a_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@a_id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                name = reader["Society_name"].ToString();
            }
            lblAdminName.Text = name;
        }

        public int GetTotalResident()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = @"SELECT COUNT(*)
                            FROM tblBlock b
                            JOIN tblFlat f ON b.Block_id = f.Block_id
                            JOIN tblOwner o ON f.Flate_id = o.Flate_id AND b.Block_id = o.Block_id
                            JOIN tblSociety s ON s.Society_id = b.Society_id
                            JOIN tblUser u ON o.Owner_id = u.Owner_id 
                            WHERE s.admin_id = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        public int GetTotalFlats()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = @"SELECT COUNT(*) 
                            FROM tblBlock b 
                            JOIN tblFlat f ON b.Block_id = f.Block_id 
                            JOIN tblSociety s ON s.Society_id = b.Society_id 
                            WHERE admin_id = @id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        public int GetTotalActiveComplaint()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                // Filter by Status: Only count 'Pending', 'Active', or 'In Progress'
                // If you strictly want 'Active', use: c.Status = 'Active'
                string query = @"SELECT COUNT(*) 
                        FROM tblComplaint c
                        JOIN tblUser u ON c.User_id = u.User_id
                        JOIN tblOwner o ON u.Owner_id = o.Owner_id
                        JOIN tblBlock b ON o.Block_id = b.Block_id
                        JOIN tblSociety s ON s.Society_id = b.Society_id
                        WHERE s.admin_id = @id 
                        AND c.Status IN ('Pending', 'Active', 'In Progress')";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        [WebMethod(EnableSession = true)]
        public static object GetCurrentYearMaintenanceData()
        {
            // 1. Check Session for Admin ID
            if (HttpContext.Current.Session["A_id"] == null) return null;
            string adminId = HttpContext.Current.Session["A_id"].ToString();

            List<string> months = new List<string> { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
            decimal[] paid = new decimal[12];
            decimal[] pending = new decimal[12];
            decimal[] totalMaintenance = new decimal[12];

            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // 2. Updated Total Query: Filtered by Admin's Society
                string totalQuery = @"
            SELECT 
                m.number AS [Month],
                ISNULL(SUM(f.Mentanance), 0) AS MonthlyMaintenance
            FROM (
                SELECT f.Flate_id, f.Mentanance
                FROM tblFlat f
                JOIN tblBlock b ON f.Block_id = b.Block_id
                JOIN tblSociety s ON b.Society_id = s.Society_id
                WHERE s.admin_id = @adminId
            ) f
            CROSS JOIN (
                SELECT number FROM master..spt_values
                WHERE type = 'P' AND number BETWEEN 1 AND 12
            ) m
            GROUP BY m.number
            ORDER BY m.number";

                using (SqlCommand cmd = new SqlCommand(totalQuery, con))
                {
                    cmd.Parameters.AddWithValue("@adminId", adminId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int monthIndex = Convert.ToInt32(reader["Month"]) - 1;
                            totalMaintenance[monthIndex] = Convert.ToDecimal(reader["MonthlyMaintenance"]);
                            // Initialize pending with total, will subtract paid later
                            pending[monthIndex] = totalMaintenance[monthIndex];
                        }
                    }
                }

                // 3. Updated Paid Query: Only for users belonging to the Admin's society
                string paidQuery = @"
            SELECT 
                mp.[Month],
                ISNULL(SUM(mp.[Amount]), 0) AS PaidAmount
            FROM MaintenancePayments mp
            JOIN tblFlat f ON mp.Flate_id = f.Flate_id
            JOIN tblBlock b ON f.Block_id = b.Block_id
            JOIN tblSociety s ON b.Society_id = s.Society_id
            WHERE mp.[Status] = 'Completed' 
            AND mp.[Year] = YEAR(GETDATE())
            AND s.admin_id = @adminId
            GROUP BY mp.[Month]";

                using (SqlCommand cmd = new SqlCommand(paidQuery, con))
                {
                    cmd.Parameters.AddWithValue("@adminId", adminId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int monthIndex = Convert.ToInt32(reader["Month"]) - 1;
                            paid[monthIndex] = Convert.ToDecimal(reader["PaidAmount"]);
                            // Recalculate pending for that specific month
                            pending[monthIndex] = Math.Max(0, totalMaintenance[monthIndex] - paid[monthIndex]);
                        }
                    }
                }
            }

            return new { months, total = totalMaintenance, paid, pending };
        }

        public class Activity
        {
            public string Text { get; set; }
            public DateTime Time { get; set; }
            public string Module { get; set; }
            public string Icon { get; set; }
        }
    }
}