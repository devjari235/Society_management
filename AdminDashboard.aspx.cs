using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
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
            if (!IsPostBack)
            {
                LoadRecentActivities();
                SocietyID();
                lblTotalResidents.Text = GetTotalResident().ToString();
                lblTotalFlats.Text = GetTotalFlats().ToString();
                lblActiveComplaints.Text=GetTotalActiveComplaint().ToString();
            }

        }
        [WebMethod]
        public static object GetFlatWiseMaintenanceData()
        {
            List<string> flatNumbers = new List<string>();
            decimal[] totalMaintenance = new decimal[0];
            decimal[] paidAmounts = new decimal[0];
            decimal[] pendingAmounts = new decimal[0];

            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
        SELECT 
            f.Flate_no AS FlatNumber,
            f.Mentanance AS TotalMaintenance,
            ISNULL(SUM(CASE WHEN mp.[Status] = 'Completed' THEN mp.Amount ELSE 0 END), 0) AS PaidAmount,
            f.Mentanance - ISNULL(SUM(CASE WHEN mp.[Status] = 'Completed' THEN mp.Amount ELSE 0 END), 0) AS PendingAmount
        FROM tblFlat f
        LEFT JOIN MaintenancePayments mp ON f.Block_id = (
            SELECT Block_id FROM tblOwner WHERE Owner_id = (
                SELECT Owner_id FROM tblUser WHERE User_id = mp.User_id
            )
        )
        AND mp.[Year] = YEAR(GETDATE())
        GROUP BY f.Flate_no, f.Mentanance
        ORDER BY f.Flate_no";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    List<decimal> tempTotal = new List<decimal>();
                    List<decimal> tempPaid = new List<decimal>();
                    List<decimal> tempPending = new List<decimal>();

                    while (reader.Read())
                    {
                        flatNumbers.Add(reader["FlatNumber"].ToString());
                        tempTotal.Add(Convert.ToDecimal(reader["TotalMaintenance"]));
                        tempPaid.Add(Convert.ToDecimal(reader["PaidAmount"]));
                        tempPending.Add(Convert.ToDecimal(reader["PendingAmount"]));
                    }

                    totalMaintenance = tempTotal.ToArray();
                    paidAmounts = tempPaid.ToArray();
                    pendingAmounts = tempPending.ToArray();
                }
            }

            return new
            {
                flats = flatNumbers,
                total = totalMaintenance,
                paid = paidAmounts,
                pending = pendingAmounts
            };
        }


        [WebMethod]
        public static object GetCurrentYearMaintenanceData()
        {
            List<string> months = new List<string> { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
            decimal[] paid = new decimal[12];
            decimal[] pending = new decimal[12];
            decimal[] totalMaintenance = new decimal[12];

            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Get month-wise expected total maintenance
                string totalQuery = @"
        SELECT 
            m.number AS [Month],
            SUM(f.Mentanance) AS MonthlyMaintenance
        FROM (
            SELECT DISTINCT Flate_id, Mentanance
            FROM tblFlat
        ) f
        CROSS JOIN (
            SELECT number
            FROM master..spt_values
            WHERE type = 'P' AND number BETWEEN 1 AND 12
        ) m
        GROUP BY m.number
        ORDER BY m.number";

                using (SqlCommand cmd = new SqlCommand(totalQuery, con))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        int monthIndex = Convert.ToInt32(reader["Month"]) - 1;
                        totalMaintenance[monthIndex] = Convert.ToDecimal(reader["MonthlyMaintenance"]);
                    }
                    reader.Close();
                }

                // Get month-wise paid amount
                string paidQuery = @"
        SELECT 
            [Month],
            SUM([Amount]) AS PaidAmount
        FROM MaintenancePayments
        WHERE [Status] = 'Completed' AND [Year] = YEAR(GETDATE())
        GROUP BY [Month]
        ORDER BY [Month]";

                using (SqlCommand cmd = new SqlCommand(paidQuery, con))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        int monthIndex = Convert.ToInt32(reader["Month"]) - 1;
                        paid[monthIndex] = Convert.ToDecimal(reader["PaidAmount"]);
                        pending[monthIndex] = Math.Max(0, totalMaintenance[monthIndex] - paid[monthIndex]);
                    }
                }
            }

            return new { months, total = totalMaintenance, paid, pending };
        }

        private void LoadRecentActivities()
        {
            // Sample data (replace with actual data from your database)
            var activities = new List<Activity>
    {
        new Activity { ActivityText = "User logged in", ActivityTime = DateTime.Now.AddMinutes(-30) },
        new Activity { ActivityText = "Profile updated", ActivityTime = DateTime.Now.AddMinutes(-15) }
    };

            rptRecentActivity.DataSource = activities;
            rptRecentActivity.DataBind();

            lblNoActivity.Visible = activities.Count == 0;
        }

        public class Activity
        {
            public string ActivityText { get; set; }
            public DateTime ActivityTime { get; set; }
        }




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
            // string query = "SELECT COUNT(*) \r\nFROM tblBlock b \r\nJOIN tblFlat f ON b.Block_id = f.Block_id \r\nJOIN tblOwner o ON f.Flate_id = o.Flate_id AND b.Block_id = o.Block_id \r\nJOIN tblSociety s ON s.Society_id = b.Society_id \r\nWHERE s.admin_id = @id";
            string query = "SELECT COUNT(*)\r\nFROM tblBlock b\r\nJOIN tblFlat f ON b.Block_id = f.Block_id\r\nJOIN tblOwner o ON f.Flate_id = o.Flate_id AND b.Block_id = o.Block_id\r\nJOIN tblSociety s ON s.Society_id = b.Society_id\r\nJOIN tblUser u ON o.Owner_id = u.Owner_id WHERE s.admin_id = @id;\r\n";
            SqlCommand cmd=new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());

        }
        public int GetTotalFlats()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "select COUNT(*) from tblBlock b join tblFlat f on b.Block_id=f.Block_id join tblSociety s on s.Society_id=b.Society_id where admin_id=@id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());

        }
        public int GetTotalActiveComplaint()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "SELECT COUNT(*) \r\nFROM tblComplaint c\r\nJOIN tblUser u ON c.User_id = u.User_id\r\nJOIN tblOwner o ON u.Owner_id = o.Owner_id\r\nJOIN tblBlock b ON o.Block_id = b.Block_id\r\nJOIN tblSociety s ON s.Society_id = b.Society_id\r\nWHERE s.admin_id = @id\r\n";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());

        }
    }
}