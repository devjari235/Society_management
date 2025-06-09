using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

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

                    int month = DateTime.Now.Month;
                    int year = DateTime.Now.Year;
                    if (Request.QueryString["month"] != null)
                        int.TryParse(Request.QueryString["month"], out month);
                    if (Request.QueryString["year"] != null)
                        int.TryParse(Request.QueryString["year"], out year);

                    hdnMonth.Value = month.ToString();
                    hdnYear.Value = year.ToString();

                    int flatId = GetFlatId(userId);
                    hdnFlatID.Value = flatId.ToString();

                    if (PaymentExists(flatId, month, year))
                    {
                        LoadUserDetails(userId, month, year);
                        string transactionId = GetTransactionId(flatId, month, year);
                        ShowReceipt(transactionId);
                    }
                    else
                    {
                        LoadUserDetails(userId, month, year);
                    }
                }
                else
                {
                    Response.Redirect("~/MaintenanceList.aspx");
                }
            }
        }

        private int GetFlatId(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT f.Flate_id FROM tblUser u INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id INNER JOIN tblFlat f ON o.Flate_id = f.Flate_id WHERE u.User_id = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private string GetTransactionId(int flatId, int month, int year)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT TOP 1 TransactionID FROM MaintenancePayments WHERE Flate_id = @FlateID AND Month = @Month AND Year = @Year";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FlateID", flatId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : string.Empty;
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
            if (!decimal.TryParse(lblAmount.Text, out decimal amount) ||
                !int.TryParse(hdnUserID.Value, out int userId) ||
                !int.TryParse(hdnFlatID.Value, out int flatId) ||
                !int.TryParse(hdnMonth.Value, out int month) ||
                !int.TryParse(hdnYear.Value, out int year) ||
                string.IsNullOrEmpty(hdnPaymentMethod.Value))
            {
                ShowError("Invalid payment details");
                return;
            }

            string paymentMethod = hdnPaymentMethod.Value;
            string transactionId = $"TXN{DateTime.Now:yyyyMMddHHmmssfff}";

            try
            {
                if (PaymentExists(flatId, month, year))
                {
                    ShowError("Payment already made for this month");
                    return;
                }

                RecordPayment(userId, flatId, amount, paymentMethod, transactionId, month, year);
                ShowReceipt(transactionId);
            }
            catch (Exception ex)
            {
                ShowError($"Payment failed: {ex.Message}");
            }
        }

        private bool PaymentExists(int flatId, int month, int year)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM MaintenancePayments WHERE Flate_id = @FlateID AND Month = @Month AND Year = @Year";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FlateID", flatId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private void RecordPayment(int userId, int flatId, decimal amount, string paymentMethod, string transactionId, int month, int year)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO MaintenancePayments 
                               (User_id, Flate_id, Amount, PaymentDate, PaymentMethod, TransactionID, Month, Year, Status)
                               VALUES 
                               (@UserID, @FlateID, @Amount, @PaymentDate, @PaymentMethod, @TransactionID, @Month, @Year, 'Completed')";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@FlateID", flatId);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@PaymentDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                    cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);
                    con.Open();
                    if (cmd.ExecuteNonQuery() == 0)
                        throw new Exception("Failed to record payment");
                }
            }
        }

        private void ShowReceipt(string transactionId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT p.PaymentDate, p.PaymentMethod, u.User_name FROM MaintenancePayments p join tblUser u On p.User_id=u.User_id WHERE TransactionID = @TransactionID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblReceiptName.Text = reader["User_name"].ToString();
                            lblPaymentDate.Text = Convert.ToDateTime(reader["PaymentDate"]).ToString("dd MMM yyyy hh:mm tt");
                            lblTransactionId.Text = transactionId;
                            lblPaymentMethod.Text = $"Paid via {reader["PaymentMethod"].ToString().ToUpper()}";

                            pnlMaintenanceDetails.Visible = false;
                            pnlPaymentMethods.Visible = false;
                            pnlPaymentButtons.Visible = false;
                            pnlReceipt.Visible = true;
                        }
                    }
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e) => Response.Redirect("~/MaintenanceList.aspx");
        protected void btnNewPayment_Click(object sender, EventArgs e) => Response.Redirect("~/MaintenanceList.aspx");

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError", $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }
}
