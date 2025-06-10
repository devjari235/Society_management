using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class AdminPaymentReceipt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (Request.QueryString["paymentid"] != null)
                {
                    int paymentId = Convert.ToInt32(Request.QueryString["paymentid"]);
                    LoadPaymentDetails(paymentId);
                }
                else
                {
                    Response.Redirect("~/AdminMaintenanceList.aspx");
                }
            }
        }

        private void LoadPaymentDetails(int paymentId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT mp.*, u.User_name, f.Flate_no, b.Block_name 
                               FROM MaintenancePayments mp
                               INNER JOIN tblUser u ON mp.User_id = u.User_id
                               INNER JOIN tblFlat f ON mp.Flate_id = f.Flate_id
                               INNER JOIN tblBlock b ON f.Block_id = b.Block_id
                               WHERE mp.PaymentID = @PaymentID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@PaymentID", paymentId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        litReceiptNo.Text = paymentId.ToString("00000");
                        litTransactionId.Text = reader["TransactionID"].ToString();
                        litPaymentDate.Text = Convert.ToDateTime(reader["PaymentDate"]).ToString("dd MMM yyyy hh:mm tt");
                        litResidentName.Text = reader["User_name"].ToString();
                        litFlatDetails.Text = $"{reader["Block_name"]}-{reader["Flate_no"]}";
                        litMonthYear.Text = $"{GetMonthName(Convert.ToInt32(reader["Month"]))} {reader["Year"]}";
                        litPaymentMethod.Text = reader["PaymentMethod"].ToString().ToUpper();
                        litStatus.Text = reader["Status"].ToString();
                        litAmount.Text = Convert.ToDecimal(reader["Amount"]).ToString("N2");
                    }
                    else
                    {
                        Response.Redirect("~/AdminMaintenanceList.aspx");
                    }
                }
            }
        }

        private string GetMonthName(int month)
        {
            return new DateTime(2020, month, 1).ToString("MMMM");
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminMaintenanceList.aspx");
        }
    }
}