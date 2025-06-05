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
        int? year = null;
        decimal totalIncome;
        decimal totalExpenses;

        private DataTable dtAssets
        {
            get { return ViewState["AssetsTable"] as DataTable; }
            set { ViewState["AssetsTable"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {

                // Set default date range to current month
                fromDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                toDate = DateTime.Now;

                // Initialize filter dates but keep hidden by default
                txtFromDateFilter.Text = fromDate.Value.ToString("yyyy-MM-dd");
                txtToDateFilter.Text = toDate.Value.ToString("yyyy-MM-dd");

                LoadIncome();
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

        //private void BindIncomeGrid()
        //{
        //    DataTable dtIncome = GetTransactions("Income");
        //    //gvIncome.DataSource = dtIncome;
        //    //gvIncome.DataBind();
        //}

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
                               t.ReceivedFrom, t.PaidTo, t.PaymentMethod, CAST(0 AS BIT) AS IsEditing 
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
            litIncomeTotal.Text = string.Format("₹{0:N2}", totalIncome);
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
            litExpenseTotal.Text = string.Format("₹{0:N2}", totalExpenses);
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

                    //lblStatus.Text = "Entry added successfully.";
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
                if (!dtAssets.Columns.Contains("IsEditing"))
                    dtAssets.Columns.Add("IsEditing", typeof(bool));

                foreach (DataRow row in dtAssets.Rows)
                    row["IsEditing"] = false;

                ViewState["AssetsTable"] = dtAssets;
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

                if (!dtLiabilities.Columns.Contains("IsEditing"))
                    dtLiabilities.Columns.Add("IsEditing", typeof(bool));

                foreach (DataRow row in dtLiabilities.Rows)
                    row["IsEditing"] = false;

                ViewState["LiabilitiesTable"] = dtLiabilities;
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
        private void LoadIncome()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString))
            {
                //string query = @"
                //                SELECT 
                //                    T.TransactionID,
                //                    T.Date,
                //                    T.Amount,
                //                    T.ReceivedFrom,
                //                    T.PaymentMethod,
                //                    T.Description,
                //                    C.CategoryName,
                //                    CAST(0 AS BIT) AS IsEditing
                //                FROM Transactions T
                //                INNER JOIN Categories C ON T.CategoryID = C.CategoryID
                //                WHERE T.TransactionType = 'Income'
                //                ORDER BY T.Date DESC";

                //SqlDataAdapter da = new SqlDataAdapter(query, con);
               
                DataTable dt = GetTransactions("Income");
                if (dt.Rows.Count > 0)
                {
                    //DataTable dt = new DataTable("Income");
                    //da.Fill(dt);

                    // Reset all IsEditing flags to false
                    foreach (DataRow row in dt.Rows)
                    {
                        row["IsEditing"] = false;
                    }

                    ViewState["IncomeData"] = dt;
                    rptIncome.DataSource = dt;
                    rptIncome.DataBind();
                    pnlNoIncome.Visible = false; // Hide "no data" message
                }
                else
                {
                    rptIncome.DataSource = null;
                    rptIncome.DataBind();
                    pnlNoIncome.Visible = true; // Show "no data" message
                }
            }
        }
        protected void rptIncome_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton btnDelete = (LinkButton)e.Item.FindControl("btnDelete");
                if (btnDelete != null)
                {
                    btnDelete.Attributes["data-uniqueid"] = btnDelete.UniqueID;
                }
            }
        }


        protected void rptIncome_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable dtIncome = ViewState["IncomeData"] as DataTable; // ✅ fixed here
            if (dtIncome == null) return;

            int transactionId = Convert.ToInt32(e.CommandArgument);
            hdnActiveTab.Value = "income-tab"; // moved up for common use

            if (e.CommandName == "Edit")
            {
                foreach (DataRow row in dtIncome.Rows)
                    row["IsEditing"] = (Convert.ToInt32(row["TransactionID"]) == transactionId);

                ViewState["IncomeData"] = dtIncome; // ✅ fixed here
                rptIncome.DataSource = dtIncome;
                rptIncome.DataBind();
            }
            else if (e.CommandName == "Cancel")
            {
                foreach (DataRow row in dtIncome.Rows)
                    row["IsEditing"] = false;

                ViewState["IncomeData"] = dtIncome; // ✅ fixed here
                rptIncome.DataSource = dtIncome;
                rptIncome.DataBind();
            }
            else if (e.CommandName == "Update")
            {
                TextBox txtAmount = (TextBox)e.Item.FindControl("txtAmount");
                TextBox txtDescription = (TextBox)e.Item.FindControl("txtDesc");

                decimal amount = 0;
                decimal.TryParse(txtAmount.Text, out amount);
                string description = txtDescription.Text.Trim();

                string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = "UPDATE Transactions SET Amount = @Amount, Description = @Description WHERE TransactionID = @TransactionID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // ✅ Use the already-declared dtIncome (don’t declare it again)
                dtIncome = ViewState["IncomeData"] as DataTable;
                if (dtIncome != null)
                {
                    foreach (DataRow row in dtIncome.Rows)
                    {
                        row["IsEditing"] = false;
                    }

                    ViewState["IncomeData"] = dtIncome;
                    rptIncome.DataSource = dtIncome;
                    rptIncome.DataBind();
                }

                // ✅ SweetAlert
                ScriptManager.RegisterStartupScript(this, this.GetType(), "updateSuccess", @"
        Swal.fire({
            icon: 'success',
            title: 'Updated',
            text: 'Record updated successfully',
            confirmButtonColor: '#3085d6'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'Accounting.aspx';
            }
        });", true);
            }


            else if (e.CommandName == "Delete")
            {
                string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = "DELETE FROM Transactions WHERE TransactionID = @TransactionID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadIncome(); // refresh after delete
            }
        }


        protected void rptAssets_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable dtAssets = ViewState["AssetsTable"] as DataTable;
            if (dtAssets == null) return;

            int entryId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Edit")
            {
                hdnActiveTab.Value = "balance-tab";
                foreach (DataRow row in dtAssets.Rows)
                    row["IsEditing"] = (Convert.ToInt32(row["EntryID"]) == entryId);

                ViewState["AssetsTable"] = dtAssets;
                rptAssets.DataSource = dtAssets;
                rptAssets.DataBind();
            }
            else if (e.CommandName == "Cancel")
            {
                hdnActiveTab.Value = "balance-tab";
                foreach (DataRow row in dtAssets.Rows)
                    row["IsEditing"] = false;

                ViewState["AssetsTable"] = dtAssets;
                rptAssets.DataSource = dtAssets;
                rptAssets.DataBind();
            }
            else if (e.CommandName == "Update")
            {
                hdnActiveTab.Value = "balance-tab";
                TextBox txtCategory = (TextBox)e.Item.FindControl("txtCategory");
                TextBox txtAmount = (TextBox)e.Item.FindControl("txtAmount");

                string category = txtCategory.Text.Trim();
                decimal amount = 0;
                decimal.TryParse(txtAmount.Text, out amount);

                string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = "UPDATE BalanceEntry SET Category=@Category, Amount=@Amount WHERE EntryID=@EntryID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@EntryID", entryId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBalanceSheet();
            }
            else if (e.CommandName == "Delete")
            {
                hdnActiveTab.Value = "balance-tab";
                string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM BalanceEntry WHERE EntryID=@EntryID", con);
                    cmd.Parameters.AddWithValue("@EntryID", entryId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBalanceSheet();
            }
        }


        protected void rptLiabilities_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable dtLiabilities = ViewState["LiabilitiesTable"] as DataTable;
            if (dtLiabilities == null) return;

            int entryId = Convert.ToInt32(e.CommandArgument);
            hdnActiveTab.Value = "balance-tab"; // keep liabilities tab active

            if (e.CommandName == "Edit")
            {
                foreach (DataRow row in dtLiabilities.Rows)
                    row["IsEditing"] = (Convert.ToInt32(row["EntryID"]) == entryId);

                ViewState["LiabilitiesTable"] = dtLiabilities;
                rptLiabilities.DataSource = dtLiabilities;
                rptLiabilities.DataBind();
            }
            else if (e.CommandName == "Cancel")
            {
                foreach (DataRow row in dtLiabilities.Rows)
                    row["IsEditing"] = false;

                ViewState["LiabilitiesTable"] = dtLiabilities;
                rptLiabilities.DataSource = dtLiabilities;
                rptLiabilities.DataBind();
            }
            else if (e.CommandName == "Update")
            {
                TextBox txtCategory = (TextBox)e.Item.FindControl("txtCategory");
                TextBox txtAmount = (TextBox)e.Item.FindControl("txtAmount");

                string category = txtCategory.Text.Trim();
                decimal amount = 0;
                decimal.TryParse(txtAmount.Text, out amount);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "UPDATE BalanceEntry SET Category=@Category, Amount=@Amount WHERE EntryID=@EntryID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@EntryID", entryId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBalanceSheet(); // Reload data from DB
            }
            else if (e.CommandName == "DeleteLiability")
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM BalanceEntry WHERE EntryID = @EntryID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@EntryID", entryId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBalanceSheet(); // Refresh table after delete
            }
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
                           WHERE t.TransactionType = 'Income' and t.admin_id=@id";

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
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
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
                           WHERE t.TransactionType = 'Expense'and t.admin_id=@id";

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
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

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
            // SetDateRange(ddlBalanceSheetPeriod.SelectedValue);
            LoadBalanceSheet();
        }

        protected void ddlProfitLossPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedPeriod = ddlProfitLossPeriod.SelectedValue;

            // Show/hide date filter controls based on selection
            if (selectedPeriod == "5") // Custom Period
            {
                dateFilterContainer.Style["display"] = "flex";

                // Initialize dates to current month if not already set
                if (!fromDate.HasValue || !toDate.HasValue)
                {
                    fromDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                    toDate = DateTime.Now;
                    txtFromDateFilter.Text = fromDate.Value.ToString("yyyy-MM-dd");
                    txtToDateFilter.Text = toDate.Value.ToString("yyyy-MM-dd");
                }
            }
            else
            {
                dateFilterContainer.Style["display"] = "none";
                SetDateRange(selectedPeriod);

                // Refresh all data
                LoadIncome();
                BindExpenseGrid();
                LoadIncomeSummary();
                LoadExpenseSummary();
                LoadBalanceSheet();
                LoadProfitLossStatement();
            }
        }

        protected void btnApplyFilter_Click(object sender, EventArgs e)
        {
            if (DateTime.TryParse(txtFromDateFilter.Text, out DateTime fromDt) &&
                DateTime.TryParse(txtToDateFilter.Text, out DateTime toDt))
            {
                fromDate = fromDt;
                toDate = toDt;

                // Refresh all data
                LoadIncome();
                BindExpenseGrid();
                LoadIncomeSummary();
                LoadExpenseSummary();
                LoadBalanceSheet();
                LoadProfitLossStatement();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                    "showAlert('error', 'Please enter valid dates');", true);
            }
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
                case "4": // Last Year
                    fromDate = new DateTime(DateTime.Now.Year - 1, 1, 1);
                    toDate = new DateTime(DateTime.Now.Year - 1, 12, 31);
                    break;
                case "5": // Custom Period
                          // Dates will be set by the filter controls
                    break;
            }

            // Update the filter controls to match the selected period
            if (fromDate.HasValue && toDate.HasValue && period != "5")
            {
                txtFromDateFilter.Text = fromDate.Value.ToString("yyyy-MM-dd");
                txtToDateFilter.Text = toDate.Value.ToString("yyyy-MM-dd");
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
                LoadIncome();
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
            LoadIncome();
            LoadIncomeSummary();
            LoadBalanceSheet();
            SetDateRange(ddlProfitLossPeriod.SelectedValue);
            LoadProfitLossStatement();
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
                    SetDateRange(ddlProfitLossPeriod.SelectedValue);
                    LoadProfitLossStatement();
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

        //protected void gvIncome_RowDeleting(object sender, GridViewDeleteEventArgs e)
        //{
        //    try
        //    {
        //        int transactionID = Convert.ToInt32(gvIncome.DataKeys[e.RowIndex].Value);

        //        using (SqlConnection con = new SqlConnection(connectionString))
        //        {
        //            // First get transaction details before deleting (for account adjustment)
        //            DataTable dtTransaction = GetTransactionDetails(transactionID);

        //            // Delete the transaction
        //            string query = "DELETE FROM Transactions WHERE TransactionID = @TransactionID";
        //            SqlCommand cmd = new SqlCommand(query, con);
        //            cmd.Parameters.AddWithValue("@TransactionID", transactionID);

        //            con.Open();
        //            cmd.ExecuteNonQuery();

        //            // Update affected account balances
        //            if (dtTransaction.Rows.Count > 0)
        //            {
        //                string paymentMethod = dtTransaction.Rows[0]["PaymentMethod"].ToString();
        //                decimal amount = Convert.ToDecimal(dtTransaction.Rows[0]["Amount"]);

        //                // Reverse the transaction effect on accounts
        //                if (paymentMethod == "Cash")
        //                {
        //                    UpdateAccountBalance("CashInHand", -amount);
        //                }
        //                else // Bank transfer, cheque, etc.
        //                {
        //                    UpdateAccountBalance("BankAccounts", -amount);
        //                }
        //            }

        //            con.Close();
        //        }

        //        // Refresh all financial data
        //        BindIncomeGrid();
        //        LoadIncomeSummary();
        //        LoadExpenseSummary();
        //        LoadBalanceSheet();
        //        LoadProfitLossStatement();

        //        // Show success message
        //        ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
        //            "showAlert('success', 'Income record deleted successfully!');", true);
        //    }
        //    catch (Exception ex)
        //    {
        //        // Show error message
        //        ScriptManager.RegisterStartupScript(this, GetType(), "showError",
        //            $"showAlert('error', 'Error deleting income record: {ex.Message}');", true);
        //    }
        //}

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

       


        private void DeleteIncome(int transactionID)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Transactions WHERE TransactionID = @TransactionID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@TransactionID", transactionID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
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

