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
    public partial class MaintenanceList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Populate year dropdown
                for (int year = DateTime.Now.Year - 2; year <= DateTime.Now.Year + 1; year++)
                {
                    ddlYear.Items.Add(new ListItem(year.ToString(), year.ToString()));
                }
                ddlYear.SelectedValue = DateTime.Now.Year.ToString();

                // Load maintenance charges for current user (in real app, use logged-in user ID)
                int userId = Convert.ToInt32(Session["U_id"]); // Example user ID - replace with actual logged-in user
                LoadMaintenanceCharges(userId, DateTime.Now.Year);
            }
        }

        private void LoadMaintenanceCharges(int userId, int year)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"WITH Months AS (
                                SELECT 1 AS MonthNumber, 'January' AS MonthName UNION ALL
                                SELECT 2, 'February' UNION ALL SELECT 3, 'March' UNION ALL
                                SELECT 4, 'April' UNION ALL SELECT 5, 'May' UNION ALL
                                SELECT 6, 'June' UNION ALL SELECT 7, 'July' UNION ALL
                                SELECT 8, 'August' UNION ALL SELECT 9, 'September' UNION ALL
                                SELECT 10, 'October' UNION ALL SELECT 11, 'November' UNION ALL
                                SELECT 12, 'December'
                            )
                            SELECT 
                                m.MonthNumber AS Month,
                                @Year AS Year,
                                m.MonthName,
                                f.Mentanance AS Amount,
                                CASE WHEN p.PaymentID IS NOT NULL THEN 'Paid' ELSE 'Pending' END AS Status,
                                @UserID AS UserID
                            FROM Months m
                            CROSS JOIN tblUser u
                            INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id
                            INNER JOIN tblFlat f ON o.Flate_id = f.Flate_id
                            LEFT JOIN MaintenancePayments p ON u.User_id = p.User_id AND m.MonthNumber = p.Month AND @Year = p.Year
                            WHERE u.User_id = @UserID
                            ORDER BY m.MonthNumber";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@Year", year);

                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    gvMaintenance.DataSource = dt;
                    gvMaintenance.DataBind();
                }
            }
        }

        protected void gvMaintenance_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Pay")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length == 3)
                {
                    Response.Redirect($"~/Payment.aspx?userid={args[0]}&month={args[1]}&year={args[2]}");
                }
            }
        }

        protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ddlYear.SelectedValue, out int year))
            {
                int userId = Convert.ToInt32(Session["U_id"]); // Example user ID - replace with actual logged-in user
                LoadMaintenanceCharges(userId, year);
            }
        }
    }
}