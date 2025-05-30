<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Accounting.aspx.cs" Inherits="Society_management.Accounting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script type="text/javascript">
        function closeModal(modalId) {
            $('#' + modalId).modal('hide');
        }

        function showAlert(type, message) {
            // Remove any existing alerts
            $('.alert-container').remove();

            // Create new alert
            var alertHtml = '<div class="alert-container alert-' + type +
                ' alert-dismissible fade show" role="alert" style="position: fixed; top: 20px; right: 20px; z-index: 9999;">' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                '</div>';

            $('body').append(alertHtml);

            // Auto-close after 5 seconds
            setTimeout(function () {
                $('.alert-container').alert('close');
            }, 5000);
        }

        $(document).ready(function () {
            // Set today's date as default for date fields
            var today = new Date().toISOString().split('T')[0];
            $('#<%= txtIncomeDate.ClientID %>').val(today);
            $('#<%= txtExpenseDate.ClientID %>').val(today);
        });
    </script>
    <%--<script type="text/javascript">
        $(document).ready(function () {
            // Set today's date as default for date fields
            var today = new Date().toISOString().split('T')[0];
            $('#<%= txtIncomeDate.ClientID %>').val(today);
            $('#<%= txtExpenseDate.ClientID %>').val(today);

            // Show success/error messages
            var successMessage = $('#<%= lblSuccessMessage.ClientID %>').text();
            var errorMessage = $('#<%= lblErrorMessage.ClientID %>').text();

            if (successMessage) {
                showAlert('success', successMessage);
            }
            if (errorMessage) {
                showAlert('danger', errorMessage);
            }
        });

        function showAlert(type, message) {
            var alertHtml = '<div class="alert-' + type + ' alert-dismissible fade show" role="alert">' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                '</div>';

            $('.main-content').prepend(alertHtml);

            // Auto-close alert after 5 seconds
            setTimeout(function () {
                $('.alert').alert('close');
            }, 5000);
        }
    </script>--%>
    <script type="text/javascript">
        function initializeCharts() {
            // Income vs Expenses Trend (Line Chart)
            var ctxLine = document.getElementById('incomeExpenseChart').getContext('2d');
            var incomeExpenseChart = new Chart(ctxLine, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Income',
                        data: [120000, 135000, 140000, 150000, 137000, 145000],
                        borderColor: '#28a745',
                        backgroundColor: 'rgba(40, 167, 69, 0.1)',
                        tension: 0.1
                    }, {
                        label: 'Expenses',
                        data: [25000, 22000, 28000, 24000, 25500, 26000],
                        borderColor: '#dc3545',
                        backgroundColor: 'rgba(220, 53, 69, 0.1)',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return context.dataset.label + ': ₹' + context.raw.toLocaleString('en-IN');
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return '₹' + value.toLocaleString('en-IN');
                                }
                            }
                        }
                    }
                }
            });

            // Expense Breakdown (Pie Chart)
            var ctxPie = document.getElementById('expensePieChart').getContext('2d');
            var expensePieChart = new Chart(ctxPie, {
                type: 'pie',
                data: {
                    labels: ['Maintenance', 'Repairs', 'Utilities', 'Salaries', 'Security', 'Others'],
                    datasets: [{
                        data: [8000, 5000, 4000, 6000, 2000, 500],
                        backgroundColor: [
                            '#FF6384',
                            '#36A2EB',
                            '#FFCE56',
                            '#4BC0C0',
                            '#9966FF',
                            '#FF9F40'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return context.label + ': ₹' + context.raw.toLocaleString('en-IN') +
                                        ' (' + context.formattedValue + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }

        // Initialize charts when page loads
        $(document).ready(function () {
            initializeCharts();
        });

        // Reinitialize charts after postback if using UpdatePanel
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            initializeCharts();
        });
    </script>

    <style type="text/css">
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background-color: #343a40;
            color: white;
            height: 100vh;
            position: fixed;
            padding-top: 20px;
        }

            .sidebar a {
                color: rgba(255, 255, 255, 0.8);
                padding: 10px 15px;
                text-decoration: none;
                display: block;
            }

                .sidebar a:hover {
                    color: white;
                    background-color: #495057;
                }

                .sidebar a.active {
                    color: white;
                    background-color: #007bff;
                }

        .main-content {
            margin-left: 20px;
            padding: 20px;
            width: 100%;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .card-header {
            background-color: #007bff;
            color: white;
            border-radius: 10px 0 0 !important;
        }

        .table th {
            background-color: #f8f9fa;
        }

        .balance-sheet {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }

        .total-row {
            font-weight: bold;
            background-color: #e9ecef;
        }

        .income-amount {
            color: #28a745;
        }

        .expense-amount {
            color: #dc3545;
        }

        .mb-0 {
            color: black;
        }

        .balance-sheet h4 {
            margin-top: 20px;
            margin-bottom: 10px;
        }

      #ddlProfitLossPeriod{
          width:20%;
      }

      .w-auto{
          width:150px !important;
      }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
  <div class="">
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
        <h1 class="h2">Accounting Management</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <div class="btn-group me-2">
                <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addIncomeModal">
                    <i class="fas fa-plus-circle me-1"></i>Add Income
                </button>
                <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
                    <i class="fas fa-minus-circle me-1"></i>Add Expense
                </button>
            </div>

            <!-- Place the dropdown OUTSIDE the btn-group -->
            <div class="ms-2">
                <asp:DropDownList ID="ddlProfitLossPeriod" runat="server" 
                    CssClass="form-select form-select-sm w-auto" 
                    AutoPostBack="true" 
                    OnSelectedIndexChanged="ddlProfitLossPeriod_SelectedIndexChanged">
                    <asp:ListItem Text="Current Month" Value="1"  Selected="True" />
                    <asp:ListItem Text="Last Month" Value="2" />
                    <asp:ListItem Text="Current Year" Value="3"/>
                    <asp:ListItem Text="Last Year" Value="4"/>
                    <asp:ListItem Text="Custom Period" Value="5" />
                </asp:DropDownList>
            </div>
        </div>
    </div>
</div>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <%-- <!-- Sidebar -->
                <div class="col-md-3 col-lg-2 d-md-block sidebar">
                    <div class="text-center mb-4">
                        <h4>Society Management</h4>
                    </div>
                    <asp:Label ID="lblSuccessMessage" runat="server" CssClass="d-none"></asp:Label>
                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="d-none"></asp:Label>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a href="Dashboard.aspx" class="nav-link"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a href="Accounting.aspx" class="nav-link active"><i class="fas fa-calculator me-2"></i>Accounting</a>
                        </li>
                        <li class="nav-item">
                            <a href="Members.aspx" class="nav-link"><i class="fas fa-users me-2"></i>Members</a>
                        </li>
                        <li class="nav-item">
                            <a href="Meetings.aspx" class="nav-link"><i class="fas fa-calendar-alt me-2"></i>Meetings</a>
                        </li>
                        <li class="nav-item">
                            <a href="Complaints.aspx" class="nav-link"><i class="fas fa-exclamation-circle me-2"></i>Complaints</a>
                        </li>
                    </ul>
                </div>--%>

            <!-- Main Content -->


            <!-- Summary Cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Total Income</h5>
                            <h2 class="card-text income-amount">
                                <asp:Literal ID="litTotalIncome" runat="server" Text="₹0.00" /></h2>
                            <p class="card-text text-muted">This financial year</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Total Expenses</h5>
                            <h2 class="card-text expense-amount">
                                <asp:Literal ID="litTotalExpense" runat="server" Text="₹0.00" /></h2>
                            <p class="card-text text-muted">This financial year</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Current Balance</h5>
                            <h2 class="card-text">
                                <asp:Literal ID="litCurrentBalance" runat="server" Text="₹0.00" /></h2>
                            <p class="card-text text-muted">As of today</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Transaction Tabs -->
            <ul class="nav nav-tabs" id="accountingTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="income-tab" data-bs-toggle="tab" data-bs-target="#income" type="button" role="tab">Income</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="expense-tab" data-bs-toggle="tab" data-bs-target="#expense" type="button" role="tab">Expenses</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="balance-tab" data-bs-toggle="tab" data-bs-target="#balance" type="button" role="tab">Balance Sheet</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="profitloss-tab" data-bs-toggle="tab" data-bs-target="#profitloss" type="button" role="tab">Profit & Loss</button>
                </li>
            </ul>

            <div class="tab-content p-3 border border-top-0 rounded-bottom" id="accountingTabsContent">
                <!-- Income Tab -->
                <div class="tab-pane fade show active" id="income" role="tabpanel">
                    <div class="d-flex justify-content-between mb-3">
                        <h5>Income Transactions</h5>
                        <%--<button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addIncomeModal">
                                    <i class="fas fa-plus"></i>Add Income
                                </button>--%>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvIncome" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover"
                            DataKeyNames="TransactionID" OnRowDeleting="gvIncome_RowDeleting" EmptyDataText="No income records found.">
                            <Columns>
                                <asp:BoundField DataField="TransactionID" HeaderText="ID" Visible="false" />
                                <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Width="100px" />
                                <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                                <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="ReceivedFrom" HeaderText="Received From" />
                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                <asp:CommandField ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-danger btn-sm" ItemStyle-Width="80px" />
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="card mt-3">
                        <div class="card-header bg-light">
                            <h6 class="mb-0">Income Summary</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <asp:Repeater ID="rptIncomeSummary" runat="server">
                                    <ItemTemplate>
                                        <div class="col-md-3 mb-2">
                                            <div class="card">
                                                <div class="card-body p-2">
                                                    <h6 class="card-title"><%# Eval("CategoryName") %></h6>
                                                    <p class="card-text text-end"><strong><%# string.Format("₹{0:N2}", Eval("TotalAmount")) %></strong></p>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <div class="col-md-3 mb-2">
                                    <div class="card bg-primary text-white">
                                        <div class="card-body p-2">
                                            <h6 class="card-title">Total Income</h6>
                                            <p class="card-text text-end">
                                                <strong>
                                                    <asp:Literal ID="litIncomeTotal" runat="server" /></strong>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Expense Tab -->
                <div class="tab-pane fade" id="expense" role="tabpanel">
                    <div class="d-flex justify-content-between mb-3">
                        <h5>Expense Transactions</h5>
                        <%--<button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
                                    <i class="fas fa-plus"></i>Add Expense
                                </button>--%>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvExpense" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-hover"
                            DataKeyNames="TransactionID" OnRowDeleting="gvExpense_RowDeleting" EmptyDataText="No expense records found.">
                            <Columns>
                                <asp:BoundField DataField="TransactionID" HeaderText="ID" Visible="false" />
                                <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-Width="100px" />
                                <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                                <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="PaidTo" HeaderText="Paid To" />
                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                <asp:CommandField ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-danger btn-sm" ItemStyle-Width="80px" />
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="card mt-3">
                        <div class="card-header bg-light">
                            <h6 class="mb-0">Expense Summary</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <asp:Repeater ID="rptExpenseSummary" runat="server">
                                    <ItemTemplate>
                                        <div class="col-md-3 mb-2">
                                            <div class="card">
                                                <div class="card-body p-2">
                                                    <h6 class="card-title"><%# Eval("CategoryName") %></h6>
                                                    <p class="card-text text-end"><strong><%# string.Format("₹{0:N2}", Eval("TotalAmount")) %></strong></p>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <div class="col-md-3 mb-2">
                                    <div class="card bg-danger text-white">
                                        <div class="card-body p-2">
                                            <h6 class="card-title">Total Expenses</h6>
                                            <p class="card-text text-end">
                                                <strong>
                                                    <asp:Literal ID="litExpenseTotal" runat="server" /></strong>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="balance" role="tabpanel">
                    <div class="balance-sheet container mt-3">
                        <div class="card mb-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Add New Entry</h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-4">
                                        <label for="txtCategory" class="form-label">Category</label>
                                        <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" Placeholder="Enter category name" />
                                    </div>
                                    <div class="col-md-3">
                                        <label for="ddlEntryType" class="form-label">Type</label>
                                        <asp:DropDownList ID="ddlEntryType" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Asset" Value="Asset" />
                                            <asp:ListItem Text="Liability" Value="Liability" />
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="txtAmount" class="form-label">Amount (₹)</label>
                                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control"
                                            Placeholder="0.00" TextMode="Number" step="0.01" />
                                    </div>
                                    <div class="col-md-2">
                                        <asp:Button ID="btnAdd" runat="server" Text="Add Entry"
                                            CssClass="btn btn-primary w-100" OnClick="btnAdd_Click1"
                                            ValidationGroup="BalanceSheet" />
                                    </div>
                                </div>
                                <asp:Label ID="lblStatus" runat="server" CssClass="mt-2 d-block" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header bg-success text-white">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">Assets</h5>
                                            <span class="badge bg-light text-dark fs-6">Total:
                                                        <asp:Literal ID="litTotalAssets" runat="server" Text="₹0.00" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="card-body p-0">
                                        <asp:Repeater ID="rptAssets" runat="server">
                                            <HeaderTemplate>
                                                <table class="table table-striped table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Category</th>
                                                            <th class="text-end">Amount (₹)</th>
                                                            <th class="text-end">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("Category") %></td>
                                                    <td class="text-end"><%# string.Format("₹{0:N2}", Eval("Amount")) %></td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </tbody>
        </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                        <asp:Panel ID="pnlNoAssets" runat="server" CssClass="text-center py-3" Visible="false">
                                            <i class="fas fa-wallet fa-2x text-muted mb-2"></i>
                                            <p class="text-muted">No assets recorded yet</p>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header bg-danger text-white">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">Liabilities</h5>
                                            <span class="badge bg-light text-dark fs-6">Total:
                                                        <asp:Literal ID="litTotalLiabilities" runat="server" Text="₹0.00" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="card-body p-0">
                                        <asp:Repeater ID="rptLiabilities" runat="server">
                                            <HeaderTemplate>
                                                <table class="table table-striped table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Category</th>
                                                            <th class="text-end">Amount (₹)</th>
                                                            <th class="text-end">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("Category") %></td>
                                                    <td class="text-end"><%# string.Format("₹{0:N2}", Eval("Amount")) %></td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </tbody>
        </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                        <asp:Panel ID="Panel1" runat="server" CssClass="text-center py-3" Visible="false">
                                            <i class="fas fa-file-invoice-dollar fa-2x text-muted mb-2"></i>
                                            <p class="text-muted">No liabilities recorded yet</p>
                                        </asp:Panel>
                                        <asp:Panel ID="pnlNoLiabilities" runat="server" CssClass="text-center py-3" Visible="false">
                                            <i class="fas fa-file-invoice-dollar fa-2x text-muted mb-2"></i>
                                            <p class="text-muted">No liabilities recorded yet</p>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0">Net Worth Summary</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Total Assets:</span>
                                            <strong class="text-success">
                                                <asp:Literal ID="litTotalAssetsSummary" runat="server" Text="₹0.00" />
                                            </strong>
                                        </div>
                                        <div class="d-flex justify-content-between mb-3">
                                            <span>Total Liabilities:</span>
                                            <strong class="text-danger">
                                                <asp:Literal ID="litTotalLiabilitiesSummary" runat="server" Text="₹0.00" />
                                            </strong>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="bg-light p-3 rounded text-center">
                                            <h6>Net Worth</h6>
                                            <h4 class="mb-0">
                                                <asp:Literal ID="litNetWorth" runat="server" Text="₹0.00" />
                                            </h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Profit & Loss Tab -->
                <div class="tab-pane fade" id="profitloss" role="tabpanel">
                    <div class="d-flex justify-content-between mb-3">
                        <h4>Profit & Loss Statement</h4>

                    </div>

                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">Income</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-sm mb-0">
                                <tbody>
                                    <asp:Repeater ID="rptIncomeCategories" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("CategoryName") %></td>
                                                <td class="text-end"><%# string.Format("₹{0:N2}", Eval("TotalAmount")) %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <tr class="table-light">
                                        <td><strong>Total Income</strong></td>
                                        <td class="text-end"><strong>
                                            <asp:Literal ID="litPLTotalIncome" runat="server" Text="₹0.00" /></strong></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">Expenses</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-sm mb-0">
                                <tbody>
                                    <asp:Repeater ID="rptExpenseCategories" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("CategoryName") %></td>
                                                <td class="text-end"><%# string.Format("₹{0:N2}", Eval("TotalAmount")) %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <tr class="table-light">
                                        <td><strong>Total Expenses</strong></td>
                                        <td class="text-end"><strong>
                                            <asp:Literal ID="litPLTotalExpenses" runat="server" Text="₹0.00" /></strong></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card bg-success text-white">
                        <div class="card-body p-2">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Net Profit/Loss (Income - Expenses)</h5>
                                <h4 class="mb-0">
                                    <asp:Literal ID="litNetProfitLoss" runat="server" Text="₹0.00" /></h4>
                            </div>
                        </div>
                    </div>

      <%--              <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">Income</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-sm mb-0">
                                <tbody>
                                    <asp:Repeater ID="Repeater1" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("CategoryName") %></td>
                                                <td class="text-end"><%# string.Format("₹{0:N2}", Eval("TotalAmount")) %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <tr class="table-light">
                                        <td><strong>Total Income</strong></td>
                                        <td class="text-end"><strong>
                                            <asp:Literal ID="Literal1" runat="server" Text="₹0.00" /></strong></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>--%>
                </div>
            </div>

            <!-- Add Income Modal -->
            <div class="modal fade" id="addIncomeModal" tabindex="-1" aria-labelledby="addIncomeModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addIncomeModalLabel">Add Income</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="ddlIncomeCategory" class="form-label">Category</label>
                                <asp:DropDownList ID="ddlIncomeCategory" runat="server" CssClass="form-select">
                                </asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <label for="txtIncomeAmount" class="form-label">Amount</label>
                                <asp:TextBox ID="txtIncomeAmount" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                                <asp:CompareValidator ID="cvIncomeAmount" runat="server" ControlToValidate="txtIncomeAmount"
                                    ErrorMessage="Amount must be greater than 0" Display="Dynamic" CssClass="text-danger"
                                    Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                            </div>
                            <div class="mb-3">
                                <label for="txtIncomeDate" class="form-label">Date</label>
                                <asp:TextBox ID="txtIncomeDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="txtReceivedFrom" class="form-label">Received From</label>
                                <asp:TextBox ID="txtReceivedFrom" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="ddlIncomePaymentMethod" class="form-label">Payment Method</label>
                                <asp:DropDownList ID="ddlIncomePaymentMethod" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Cash" Value="Cash" />
                                    <asp:ListItem Text="Cheque" Value="Cheque" />
                                    <asp:ListItem Text="Bank Transfer" Value="Bank Transfer" />
                                    <asp:ListItem Text="Online Payment" Value="Online Payment" />
                                </asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <label for="txtIncomeDescription" class="form-label">Description</label>
                                <asp:TextBox ID="txtIncomeDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddIncome" runat="server" Text="Add Income" CssClass="btn btn-primary" OnClick="btnAddIncome_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add Expense Modal -->
            <div class="modal fade" id="addExpenseModal" tabindex="-1" aria-labelledby="addExpenseModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addExpenseModalLabel">Add Expense</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="ddlExpenseCategory" class="form-label">Category</label>
                                <asp:DropDownList ID="ddlExpenseCategory" runat="server" CssClass="form-select">
                                </asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <label for="txtExpenseAmount" class="form-label">Amount</label>
                                <asp:TextBox ID="txtExpenseAmount" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                                <asp:CompareValidator ID="cvExpenseAmount" runat="server" ControlToValidate="txtExpenseAmount"
                                    ErrorMessage="Amount must be greater than 0" Display="Dynamic" CssClass="text-danger"
                                    Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                            </div>
                            <div class="mb-3">
                                <label for="txtExpenseDate" class="form-label">Date</label>
                                <asp:TextBox ID="txtExpenseDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="txtPaidTo" class="form-label">Paid To</label>
                                <asp:TextBox ID="txtPaidTo" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="ddlExpensePaymentMethod" class="form-label">Payment Method</label>
                                <asp:DropDownList ID="ddlExpensePaymentMethod" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Cash" Value="Cash" />
                                    <asp:ListItem Text="Cheque" Value="Cheque" />
                                    <asp:ListItem Text="Bank Transfer" Value="Bank Transfer" />
                                    <asp:ListItem Text="Online Payment" Value="Online Payment" />
                                </asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <label for="txtExpenseDescription" class="form-label">Description</label>
                                <asp:TextBox ID="txtExpenseDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <asp:Button ID="btnAddExpense" runat="server" Text="Add Expense" CssClass="btn btn-primary" OnClick="btnAddExpense_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Custom Period Modal -->
            <div class="modal fade" id="customPeriodModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Select Custom Period</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">From Date</label>
                                <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">To Date</label>
                                <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                <asp:CompareValidator ID="cvDateRange" runat="server"
                                    ControlToValidate="txtToDate" ControlToCompare="txtFromDate"
                                    ErrorMessage="To Date must be greater than From Date" Display="Dynamic"
                                    CssClass="text-danger" Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnApplyCustomPeriod" runat="server" Text="Apply" CssClass="btn btn-primary" OnClick="btnApplyCustomPeriod_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
