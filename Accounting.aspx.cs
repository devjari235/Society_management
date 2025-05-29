using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Newtonsoft.Json;

namespace Society_management
{
    public partial class Accounting : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        private DateTime? fromDate = null;
        private DateTime? toDate = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default date range to current month
                fromDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                toDate = DateTime.Now;
                BindIncomeGrid();
                BindExpenseGrid();
                LoadIncomeSummary();
                LoadExpenseSummary();
                LoadBalanceSheet();
                LoadProfitLossStatement();
                BindcurrentBallence();
                BindIncome();
                BindExpense();
                
            }
        }

        private void BindIncomeGrid()
        {
            DataTable dtIncome = GetTransactions("Income");
            gvIncome.DataSource = dtIncome;
            gvIncome.DataBind();
        }

        private void BindExpenseGrid()
        {
            DataTable dtExpense = GetTransactions("Expense");
            gvExpense.DataSource = dtExpense;
            gvExpense.DataBind();
        }

        private DataTable GetTransactions(string transactionType)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT t.TransactionID, t.Date, c.CategoryName, t.Amount, t.Description, 
                               t.ReceivedFrom, t.PaidTo, t.PaymentMethod 
                               FROM Transactions t
                               INNER JOIN Categories c ON t.CategoryID = c.CategoryID
                               WHERE t.TransactionType = @TransactionType and admin_id=@id";

                // Add date filter if specified
                if (fromDate.HasValue && toDate.HasValue)
                {
                    query += " AND t.Date BETWEEN @FromDate AND @ToDate";
                }

                query += " ORDER BY t.Date DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TransactionType", transactionType);
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);


                if (fromDate.HasValue && toDate.HasValue)
                {
                    cmd.Parameters.AddWithValue("@FromDate", fromDate.Value);
                    cmd.Parameters.AddWithValue("@ToDate", toDate.Value);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return dt;
        }
        decimal totalIncome;
        decimal totalExpenses;
        private void LoadIncomeSummary()
        {
            DataTable dtIncomeSummary = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT c.CategoryName, SUM(t.Amount) AS TotalAmount
                               FROM Transactions t
                               INNER JOIN Categories c ON t.CategoryID = c.CategoryID
                               WHERE t.TransactionType = 'Income'  and admin_id=@id";

                if (fromDate.HasValue && toDate.HasValue)
                {
                    query += " AND t.Date BETWEEN @FromDate AND @ToDate";
                }

                query += " GROUP BY c.CategoryName";

                SqlCommand cmd = new SqlCommand(query, con);

                if (fromDate.HasValue && toDate.HasValue)
                {
                    cmd.Parameters.AddWithValue("@FromDate", fromDate.Value);
                    cmd.Parameters.AddWithValue("@ToDate", toDate.Value);
                }
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtIncomeSummary);
            }

            rptIncomeSummary.DataSource = dtIncomeSummary;
            rptIncomeSummary.DataBind();

            // Calculate total income
            totalIncome = dtIncomeSummary.AsEnumerable().Sum(row => row.Field<decimal>("TotalAmount"));
            litTotalIncome.Text = string.Format("₹{0:N2}", totalIncome);
            litPLTotalIncome.Text = string.Format("₹{0:N2}", totalIncome);
        }

        private void LoadExpenseSummary()
        {
            DataTable dtExpenseSummary = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT c.CategoryName, SUM(t.Amount) AS TotalAmount
                               FROM Transactions t
                               INNER JOIN Categories c ON t.CategoryID = c.CategoryID
                               WHERE t.TransactionType = 'Expense'  and admin_id=@id";

                if (fromDate.HasValue && toDate.HasValue)
                {
                    query += " AND t.Date BETWEEN @FromDate AND @ToDate";
                }

                query += " GROUP BY c.CategoryName";

                SqlCommand cmd = new SqlCommand(query, con);

                if (fromDate.HasValue && toDate.HasValue)
                {
                    cmd.Parameters.AddWithValue("@FromDate", fromDate.Value);
                    cmd.Parameters.AddWithValue("@ToDate", toDate.Value);

                }
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);


                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtExpenseSummary);
            }

            rptExpenseSummary.DataSource = dtExpenseSummary;
            rptExpenseSummary.DataBind();

            // Calculate total expenses
            totalExpenses = dtExpenseSummary.AsEnumerable().Sum(row => row.Field<decimal>("TotalAmount"));
            litTotalExpense.Text = string.Format("₹{0:N2}", totalExpenses);
            litPLTotalExpenses.Text = string.Format("₹{0:N2}", totalExpenses);
        }
        public void BindcurrentBallence()
        {
            decimal currentBalance = (Convert.ToDecimal(totalIncome) - Convert.ToDecimal(totalExpenses));
            litCurrentBalance.Text = string.Format("₹{0:N2}", currentBalance);
        }
        protected void btnAdd_Click1(object sender, EventArgs e)
        {
            string category = txtCategory.Text.Trim();
            string entryType = ddlEntryType.SelectedValue;
            decimal amount;

            if (decimal.TryParse(txtAmount.Text.Trim(), out amount) && !string.IsNullOrEmpty(category))
            {
                try
                {
                    string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = "INSERT INTO BalanceEntry (EntryType, Category, Amount, admin_id) VALUES (@EntryType, @Category, @Amount, @id)";
                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            //cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = 1; // Or dynamic user id
                            cmd.Parameters.Add("@EntryType", SqlDbType.NVarChar, 50).Value = entryType;
                            cmd.Parameters.Add("@Category", SqlDbType.NVarChar, 100).Value = category;
                            cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = amount;
                            cmd.Parameters.AddWithValue("@id", Session["A_id"]);

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    lblStatus.Text = "Entry added successfully.";
                    lblStatus.CssClass = "text-success";

                    // Clear inputs
                    txtCategory.Text = "";
                    txtAmount.Text = "";

                    // Refresh data
                    LoadBalanceSheet();
                }
                catch (Exception ex)
                {
                    lblStatus.Text = "Error: " + ex.Message;
                    lblStatus.CssClass = "text-danger";
                }
            }
            else
            {
                lblStatus.Text = "Please enter valid data.";
                lblStatus.CssClass = "text-danger";
            }
        }
        private void LoadBalanceSheet()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // Load Assets
                SqlCommand cmdAssets = new SqlCommand(
                    "SELECT EntryID, Category, Amount FROM BalanceEntry WHERE EntryType='Asset' AND admin_id=@id",
                    con);
                cmdAssets.Parameters.AddWithValue("@id", Session["A_id"]);
                SqlDataAdapter daAssets = new SqlDataAdapter(cmdAssets);
                DataTable dtAssets = new DataTable();
                daAssets.Fill(dtAssets);

                rptAssets.DataSource = dtAssets;
                rptAssets.DataBind();
                pnlNoAssets.Visible = dtAssets.Rows.Count == 0;

                // Load Liabilities - Make sure this matches your actual database schema
                SqlCommand cmdLiabilities = new SqlCommand(
                    "SELECT EntryID, Category, Amount FROM BalanceEntry WHERE EntryType='Liability' AND admin_id=@id",
                    con);
                cmdLiabilities.Parameters.AddWithValue("@id", Session["A_id"]);
                SqlDataAdapter daLiabilities = new SqlDataAdapter(cmdLiabilities);
                DataTable dtLiabilities = new DataTable();
                daLiabilities.Fill(dtLiabilities);

                rptLiabilities.DataSource = dtLiabilities;
                rptLiabilities.DataBind();
                pnlNoLiabilities.Visible = dtLiabilities.Rows.Count == 0;

                // Calculate totals
                decimal totalAssets = dtAssets.AsEnumerable().Sum(row => row.Field<decimal>("Amount"));
                decimal totalLiabilities = dtLiabilities.AsEnumerable().Sum(row => row.Field<decimal>("Amount"));

                // Update display
                litTotalAssets.Text = string.Format("₹{0:N2}", totalAssets);
                litTotalLiabilities.Text = string.Format("₹{0:N2}", totalLiabilities);
                litTotalAssetsSummary.Text = string.Format("₹{0:N2}", totalAssets);
                litTotalLiabilitiesSummary.Text = string.Format("₹{0:N2}", totalLiabilities);
                litNetWorth.Text = string.Format("₹{0:N2}", totalAssets - totalLiabilities);
            }
        }


        private void DeleteEntry(int entryId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM BalanceEntry WHERE EntryID = @EntryID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@EntryID", entryId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadBalanceSheet();
        }

        private decimal GetAccountBalance(string accountType)
        {
            decimal balance = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ISNULL(Balance, 0) FROM Accounts WHERE AccountType = @AccountType";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@AccountType", accountType);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != DBNull.Value)
                {
                    balance = Convert.ToDecimal(result);
                }
                con.Close();
            }
            return balance;
        }

        private decimal GetOpeningCapital()
        {
            decimal openingCapital = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ISNULL(OpeningCapital, 0) FROM SocietyInfo WHERE SocietyID = 1";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != DBNull.Value)
                {
                    openingCapital = Convert.ToDecimal(result);
                }
                con.Close();
            }
            return openingCapital;
        }

        private decimal CalculateCurrentYearProfitLoss()
        {
            decimal profitLoss = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT 
                                (SELECT ISNULL(SUM(Amount), 0) FROM Transactions 
                                 WHERE TransactionType = 'Income' 
                                 AND YEAR(Date) = YEAR(GETDATE()))
                                -
                                (SELECT ISNULL(SUM(Amount), 0) FROM Transactions 
                                 WHERE TransactionType = 'Expense' 
                                 AND YEAR(Date) = YEAR(GETDATE())) AS NetProfitLoss";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != DBNull.Value)
                {
                    profitLoss = Convert.ToDecimal(result);
                }
                con.Close();
            }
            return profitLoss;
        }

        private void LoadProfitLossStatement()
        {
            try
            {
                // Load income categories with amounts
                DataTable dtIncomeCategories = new DataTable();
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT c.CategoryName, SUM(t.Amount) AS TotalAmount
                           FROM Transactions t
                           INNER JOIN Categories c ON t.CategoryID = c.CategoryID
                           WHERE t.TransactionType = 'Income'";

                    if (fromDate.HasValue && toDate.HasValue)
                    {
                        query += " AND t.Date BETWEEN @FromDate AND @ToDate";
                    }

                    query += " GROUP BY c.CategoryName ORDER BY TotalAmount DESC";

                    SqlCommand cmd = new SqlCommand(query, con);

                    if (fromDate.HasValue && toDate.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@FromDate", fromDate.Value);
                        cmd.Parameters.AddWithValue("@ToDate", toDate.Value);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dtIncomeCategories);
                }

                rptIncomeCategories.DataSource = dtIncomeCategories;
                rptIncomeCategories.DataBind();

                // Calculate total income
                decimal totalIncome = dtIncomeCategories.AsEnumerable()
                                     .Sum(row => row.Field<decimal>("TotalAmount"));
                litPLTotalIncome.Text = string.Format("₹{0:N2}", totalIncome);

                // Load expense categories with amounts
                DataTable dtExpenseCategories = new DataTable();
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT c.CategoryName, SUM(t.Amount) AS TotalAmount
                           FROM Transactions t
                           INNER JOIN Categories c ON t.CategoryID = c.CategoryID
                           WHERE t.TransactionType = 'Expense'";

                    if (fromDate.HasValue && toDate.HasValue)
                    {
                        query += " AND t.Date BETWEEN @FromDate AND @ToDate";
                    }

                    query += " GROUP BY c.CategoryName ORDER BY TotalAmount DESC";

                    SqlCommand cmd = new SqlCommand(query, con);

                    if (fromDate.HasValue && toDate.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@FromDate", fromDate.Value);
                        cmd.Parameters.AddWithValue("@ToDate", toDate.Value);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dtExpenseCategories);
                }

                rptExpenseCategories.DataSource = dtExpenseCategories;
                rptExpenseCategories.DataBind();

                // Calculate total expenses
                decimal totalExpenses = dtExpenseCategories.AsEnumerable()
                                       .Sum(row => row.Field<decimal>("TotalAmount"));
                litPLTotalExpenses.Text = string.Format("₹{0:N2}", totalExpenses);

                // Calculate net profit/loss
                decimal netProfitLoss = totalIncome - totalExpenses;
                litNetProfitLoss.Text = string.Format("₹{0:N2}", netProfitLoss);

                // Register chart data
                RegisterChartData(dtIncomeCategories, dtExpenseCategories);

                // Set current balance
                decimal currentBalance = totalIncome - totalExpenses;
                litCurrentBalance.Text = string.Format("₹{0:N2}", currentBalance);
            }
            catch (Exception ex)
            {
                // Log error and show message
                ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                    $"showAlert('error', 'Error loading profit/loss statement: {ex.Message}');", true);
            }
        }
        private void RegisterChartData(DataTable incomeData, DataTable expenseData)
        {
            // Convert data to JSON for JavaScript charts
            string incomeJson = JsonConvert.SerializeObject(incomeData);
            string expenseJson = JsonConvert.SerializeObject(expenseData);

            // Register with page
            ScriptManager.RegisterStartupScript(this, GetType(), "ChartData",
                $"var incomeData = {incomeJson}; var expenseData = {expenseJson};", true);
        }

        protected void ddlBalanceSheetPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetDateRange(ddlBalanceSheetPeriod.SelectedValue);
            LoadBalanceSheet();
        }

        protected void ddlProfitLossPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetDateRange(ddlProfitLossPeriod.SelectedValue);
            LoadIncomeSummary();
            LoadExpenseSummary();
            LoadProfitLossStatement();
        }

        private void SetDateRange(string period)
        {
            switch (period)
            {
                case "1": // Current Month
                    fromDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                    toDate = DateTime.Now;
                    break;
                case "2": // Last Month
                    fromDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(-1);
                    toDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(-1);
                    break;
                case "3": // Current Year
                    fromDate = new DateTime(DateTime.Now.Year, 1, 1);
                    toDate = DateTime.Now;
                    break;
                case "4": // Custom Period (will be handled by modal)
                    // Show modal to select dates
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "showCustomPeriodModal",
                        "$('#customPeriodModal').modal('show');", true);
                    break;
            }
        }

        protected void btnApplyCustomPeriod_Click(object sender, EventArgs e)
        {
            if (DateTime.TryParse(txtFromDate.Text, out DateTime fromDt) &&
                DateTime.TryParse(txtToDate.Text, out DateTime toDt))
            {
                fromDate = fromDt;
                toDate = toDt;

                // Refresh all data
                BindIncomeGrid();
                BindExpenseGrid();
                LoadIncomeSummary();
                LoadExpenseSummary();
                LoadBalanceSheet();
                LoadProfitLossStatement();

                // Close modal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "hideCustomPeriodModal",
                    "$('#customPeriodModal').modal('hide');", true);
            }
        }

        protected void btnAddIncome_Click(object sender, EventArgs e)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO Transactions (TransactionType, CategoryID, Amount, Date, 
                                   Description, ReceivedFrom, PaymentMethod, admin_id, CreatedOn)
                                   VALUES ('Income', @CategoryID, @Amount, @Date, @Description, 
                                   @ReceivedFrom, @PaymentMethod, @CreatedBy, GETDATE())";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CategoryID", ddlIncomeCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Amount", decimal.Parse(txtIncomeAmount.Text));
                cmd.Parameters.AddWithValue("@Date", DateTime.Parse(txtIncomeDate.Text));
                cmd.Parameters.AddWithValue("@Description", txtIncomeDescription.Text);
                cmd.Parameters.AddWithValue("@ReceivedFrom", txtReceivedFrom.Text);
                cmd.Parameters.AddWithValue("@PaymentMethod", ddlIncomePaymentMethod.SelectedValue);
                cmd.Parameters.AddWithValue("@CreatedBy", Session["A_id"]);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            // Clear form fields
            txtIncomeAmount.Text = "";
            txtIncomeDescription.Text = "";
            txtReceivedFrom.Text = "";

            // Refresh data
            BindIncomeGrid();
            LoadIncomeSummary();
            LoadBalanceSheet();

            // Show success message
            // lblSuccessMessage.Text = "Income record added successfully!";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "closeModal",
"$('#addIncomeModal').modal('hide');", true);



        }

        protected void btnAddExpense_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = @"INSERT INTO Transactions (TransactionType, CategoryID, Amount, Date, 
                                   Description, PaidTo, PaymentMethod, admin_id, CreatedOn)
                                   VALUES ('Expense', @CategoryID, @Amount, @Date, @Description, 
                                   @PaidTo, @PaymentMethod, @CreatedBy, GETDATE())";

                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@CategoryID", ddlExpenseCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@Amount", decimal.Parse(txtExpenseAmount.Text));
                        cmd.Parameters.AddWithValue("@Date", DateTime.Parse(txtExpenseDate.Text));
                        cmd.Parameters.AddWithValue("@Description", txtExpenseDescription.Text);
                        cmd.Parameters.AddWithValue("@PaidTo", txtPaidTo.Text);
                        cmd.Parameters.AddWithValue("@PaymentMethod", ddlExpensePaymentMethod.SelectedValue);
                        cmd.Parameters.AddWithValue("@CreatedBy", Session["A_id"]);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }

                    // Clear form fields
                    txtExpenseAmount.Text = "";
                    txtExpenseDescription.Text = "";
                    txtPaidTo.Text = "";

                    // Refresh data
                    BindExpenseGrid();
                    LoadExpenseSummary();
                    LoadBalanceSheet();

                    // Show success message
                    //lblSuccessMessage.Text = "Expense record added successfully!";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "closeModal",
    "$('#addIncomeModal').modal('hide');", true);

                }
                catch (Exception ex)
                {
                    // lblErrorMessage.Text = "Error adding expense record: " + ex.Message;
                }
            }
        }

        protected void gvIncome_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int transactionID = Convert.ToInt32(gvIncome.DataKeys[e.RowIndex].Value);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // First get transaction details before deleting (for account adjustment)
                    DataTable dtTransaction = GetTransactionDetails(transactionID);

                    // Delete the transaction
                    string query = "DELETE FROM Transactions WHERE TransactionID = @TransactionID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@TransactionID", transactionID);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Update affected account balances
                    if (dtTransaction.Rows.Count > 0)
                    {
                        string paymentMethod = dtTransaction.Rows[0]["PaymentMethod"].ToString();
                        decimal amount = Convert.ToDecimal(dtTransaction.Rows[0]["Amount"]);

                        // Reverse the transaction effect on accounts
                        if (paymentMethod == "Cash")
                        {
                            UpdateAccountBalance("CashInHand", -amount);
                        }
                        else // Bank transfer, cheque, etc.
                        {
                            UpdateAccountBalance("BankAccounts", -amount);
                        }
                    }

                    con.Close();
                }

                // Refresh all financial data
                BindIncomeGrid();
                LoadIncomeSummary();
                LoadExpenseSummary();
                LoadBalanceSheet();
                LoadProfitLossStatement();

                // Show success message
                ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                    "showAlert('success', 'Income record deleted successfully!');", true);
            }
            catch (Exception ex)
            {
                // Show error message
                ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                    $"showAlert('error', 'Error deleting income record: {ex.Message}');", true);
            }
        }

        protected void gvExpense_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int transactionID = Convert.ToInt32(gvExpense.DataKeys[e.RowIndex].Value);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // First get transaction details before deleting (for account adjustment)
                    DataTable dtTransaction = GetTransactionDetails(transactionID);

                    // Delete the transaction
                    string query = "DELETE FROM Transactions WHERE TransactionID = @TransactionID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@TransactionID", transactionID);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Update affected account balances
                    if (dtTransaction.Rows.Count > 0)
                    {
                        string paymentMethod = dtTransaction.Rows[0]["PaymentMethod"].ToString();
                        decimal amount = Convert.ToDecimal(dtTransaction.Rows[0]["Amount"]);

                        // Reverse the transaction effect on accounts
                        if (paymentMethod == "Cash")
                        {
                            UpdateAccountBalance("CashInHand", amount); // Add back to cash
                        }
                        else // Bank transfer, cheque, etc.
                        {
                            UpdateAccountBalance("BankAccounts", amount); // Add back to bank
                        }
                    }

                    con.Close();
                }

                // Refresh all financial data
                BindExpenseGrid();
                LoadIncomeSummary();
                LoadExpenseSummary();
                LoadBalanceSheet();
                LoadProfitLossStatement();

                // Show success message
                ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                    "showAlert('success', 'Expense record deleted successfully!');", true);
            }
            catch (Exception ex)
            {
                // Show error message
                ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                    $"showAlert('error', 'Error deleting expense record: {ex.Message}');", true);
            }
        }

        // Helper method to get transaction details
        private DataTable GetTransactionDetails(int transactionID)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT Amount, PaymentMethod FROM Transactions WHERE TransactionID = @TransactionID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TransactionID", transactionID);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return dt;
        }

        // Helper method to update account balances
        private void UpdateAccountBalance(string accountType, decimal amount)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Accounts SET Balance = Balance + @Amount WHERE AccountType = @AccountType";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Amount", amount);
                cmd.Parameters.AddWithValue("@AccountType", accountType);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }

        public void BindIncome()
        {
            SqlConnection con = new SqlConnection(connectionString);
            string query = "select * from categories where CategoryType='Income'";
            con.Open();
            SqlDataAdapter ad = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            ad.Fill(dt);
            ddlIncomeCategory.DataSource = dt;
            ddlIncomeCategory.DataBind();
            ddlIncomeCategory.DataTextField = "CategoryName";
            ddlIncomeCategory.DataValueField = "CategoryID";
            ddlIncomeCategory.DataBind();
            ddlIncomeCategory.Items.Insert(0, new ListItem("---select Income---"));
            con.Close();
        }
        public void BindExpense()
        {
            SqlConnection con = new SqlConnection(connectionString);
            string query = "select * from categories where CategoryType='Expense'";
            con.Open();
            SqlDataAdapter ad = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            ad.Fill(dt);
            ddlExpenseCategory.DataSource = dt;
            ddlExpenseCategory.DataBind();
            ddlExpenseCategory.DataTextField = "CategoryName";
            ddlExpenseCategory.DataValueField = "CategoryID";
            ddlExpenseCategory.DataBind();
            ddlExpenseCategory.Items.Insert(0, new ListItem("---select Expense---"));
            con.Close();
        }

        // These labels are used for showing success/error messages via JavaScript
        //protected Label lblSuccessMessage
        //{
        //    get { return new Label { ID = "lblSuccessMessage", Visible = false }; }
        //}

        //protected Label lblErrorMessage
        //{
        //    get { return new Label { ID = "lblErrorMessage", Visible = false }; }
        //}
    }
}

