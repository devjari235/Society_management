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
    public partial class Payment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["userid"] != null && int.TryParse(Request.QueryString["userid"], out int userId))
                {
                    hdnUserID.Value = userId.ToString();

                    // Get current month and year for payment
                    int month = DateTime.Now.Month;
                    int year = DateTime.Now.Year;
                    hdnMonth.Value = month.ToString();
                    hdnYear.Value = year.ToString();

                    LoadUserDetails(userId, month, year);
                }
                else
                {
                    Response.Redirect("~/MaintenanceList.aspx");
                }
            }
        }

        private void LoadUserDetails(int userId, int month, int year)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT u.User_name, f.Flate_no, b.Block_name, f.Mentanance 
                               FROM tblUser u
                               INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id
                               INNER JOIN tblFlat f ON o.Flate_id = f.Flate_id
                               INNER JOIN tblBlock b ON f.Block_id = b.Block_id
                               WHERE u.User_id = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblResidentName.Text = reader["User_name"].ToString();
                            lblFlatNumber.Text = $"{reader["Block_name"]}-{reader["Flate_no"]}";
                            lblMonthYear.Text = $"{GetMonthName(month)} {year}";
                            lblAmount.Text = reader["Mentanance"].ToString();

                            // Set receipt labels as well
                            lblReceiptName.Text = lblResidentName.Text;
                            lblReceiptFlat.Text = lblFlatNumber.Text;
                            lblReceiptAmount.Text = lblAmount.Text;
                        }
                        else
                        {
                            ShowError("User details not found");
                        }
                    }
                }
            }
        }

        private string GetMonthName(int month)
        {
            return new DateTime(2020, month, 1).ToString("MMMM");
        }

        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hdnPaymentMethod.Value))
            {
                ShowError("Please select a payment method");
                return;
            }

            if (!decimal.TryParse(lblAmount.Text, out decimal amount))
            {
                ShowError("Invalid amount");
                return;
            }

            if (!int.TryParse(hdnUserID.Value, out int userId))
            {
                ShowError("Invalid user");
                return;
            }

            if (!int.TryParse(hdnMonth.Value, out int month))
            {
                ShowError("Invalid month");
                return;
            }

            if (!int.TryParse(hdnYear.Value, out int year))
            {
                ShowError("Invalid year");
                return;
            }

            string paymentMethod = hdnPaymentMethod.Value;
            string transactionId = $"TXN{DateTime.Now:yyyyMMddHHmmssfff}";

            try
            {
                // Check if payment already exists for this month/year
                if (PaymentExists(userId, month, year))
                {
                    ShowError("Payment already made for this month");
                    return;
                }

                // Record the payment
                RecordPayment(userId, amount, paymentMethod, transactionId, month, year);

                // Show receipt
                ShowReceipt(transactionId);
            }
            catch (Exception ex)
            {
                ShowError($"Payment failed: {ex.Message}");
            }
        }

        private bool PaymentExists(int userId, int month, int year)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM MaintenancePayments WHERE User_id = @UserID AND Month = @Month AND Year = @Year";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);

                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private void RecordPayment(int userId, decimal amount, string paymentMethod, string transactionId, int month, int year)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO MaintenancePayments 
                               (User_id, Amount, PaymentDate, PaymentMethod, TransactionID, Month, Year, Status)
                               VALUES 
                               (@UserID, @Amount, @PaymentDate, @PaymentMethod, @TransactionID, @Month, @Year, 'Completed')";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@PaymentDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                    cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);

                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected == 0)
                    {
                        throw new Exception("Failed to record payment");
                    }
                }
            }
        }

        private void ShowReceipt(string transactionId)
        {
            pnlMaintenanceDetails.Visible = false;
            pnlPaymentMethods.Visible = false;
            pnlPaymentButtons.Visible = false;
            pnlReceipt.Visible = true;

            lblPaymentDate.Text = DateTime.Now.ToString("dd MMM yyyy hh:mm tt");
            lblTransactionId.Text = transactionId;
            lblPaymentMethod.Text = $"Paid via {hdnPaymentMethod.Value.ToUpper()}";
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/MaintenanceList.aspx");
        }

        protected void btnNewPayment_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/MaintenanceList.aspx");
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }
}