<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Accounting.aspx.cs" Inherits="Society_management.Accounting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <%-- ===== CSS ===== --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <%-- ===== JS: jQuery FIRST, then Bootstrap ONCE, then others ===== --%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style type="text/css">
    /* =========================================================
       BASE & PC OPTIMIZATION
    ========================================================= */
    body {
        background-color: #f0f2f5;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        /* Increased base font size for PC readability */
        font-size: 16px; 
        color: #333;
    }

    /* =========================================================
       SUMMARY CARDS
    ========================================================= */
    .card {
        border: none;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        margin-bottom: 16px;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .card:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0,0,0,0.12);
    }

    .card-header {
        border-radius: 12px 12px 0 0 !important;
        font-weight: 600;
        font-size: 1.1rem;
        padding: 12px 16px;
    }

    .income-amount  { color: #16a34a; font-weight: 700; }
    .expense-amount { color: #dc2626; font-weight: 700; }

    /* =========================================================
       TABS & CONTENT AREA
    ========================================================= */
    #accountingTabs {
        display: flex;
        flex-wrap: nowrap;
        overflow-x: auto;
        overflow-y: hidden;
        -webkit-overflow-scrolling: touch;
        border-bottom: 2px solid #dee2e6;
        gap: 2px;
        padding-bottom: 0;
    }

    #accountingTabs::-webkit-scrollbar { display: none; }

    #accountingTabs .nav-item {
        flex: 0 0 auto;
    }

    #accountingTabs .nav-link {
        white-space: nowrap;
        border-radius: 8px 8px 0 0;
        padding: 12px 20px;
        font-size: 15px;
        font-weight: 500;
        color: #555;
        border: 1px solid transparent;
        transition: background 0.2s, color 0.2s;
    }

    #accountingTabs .nav-link:hover {
        background: #e9ecef;
        color: #0d6efd;
    }

    #accountingTabs .nav-link.active {
        background: #fff;
        color: #0d6efd;
        border-color: #dee2e6 #dee2e6 #fff;
        font-weight: 700;
    }

    .tab-content {
        background: #fff;
        border-radius: 0 0 12px 12px;
        border: 1px solid #dee2e6;
        border-top: none;
        padding: 24px; /* Spacious for PC */
    }

    /* =========================================================
       REPEATER / TABLE (PC Size)
    ========================================================= */
    .table-responsive {
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    .table {
        width: 100%;
        min-width: 600px;
        font-size: 15px; /* Comfortable reading size */
    }

    .table th {
        background-color: #f8f9fa;
        font-weight: 600;
        white-space: nowrap;
        padding: 14px 10px;
    }

    .table td {
        padding: 14px 10px;
        vertical-align: middle;
    }

    /* =========================================================
       DATE FILTER BAR
    ========================================================= */
    .page-title-bar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 15px;
        margin-bottom: 20px;
    }

    .date-filter-container {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 12px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        /* Fixes the "too long" issue on PC */
        max-width: fit-content; 
        border: 1px solid #dee2e6;
    }

    .date-filter-container .form-control {
        min-width: unset;
        width: 150px; /* Specific width so it doesn't stretch */
    }

    /* =========================================================
        MISC & BUTTON ALIGNMENT
    ========================================================= */
    .mb-0 { color: black; }

    /* Grouping buttons and dropdown to the right */
    .page-title-bar .ms-auto {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    #ddlProfitLossPeriod { 
        width: 180px; /* Fixed width for the period selector */
    }

    .alert-toast {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 260px;
        max-width: 90vw;
    }

    /* =========================================================
       MODALS
    ========================================================= */
    @media (max-width: 576px) {
        .modal-dialog {
            margin: 8px;
            max-width: calc(100vw - 16px);
        }
    }

/* =========================================================
           MOBILE RESPONSIVE (5px EDGE-TO-EDGE)
        ========================================================= */
        @media (max-width: 768px) {
            /* 1. Force the outer container to almost zero padding */
            .container-fluid.px-0 {
                padding-left: 5px !important;
                padding-right: 5px !important;
            }

            /* 2. Remove padding from the tab content area and expand width */
            .tab-content {
                padding: 12px 5px !important; 
                margin-left: -5px !important;
                margin-right: -5px !important;
                width: calc(100% + 10px) !important;
                border-left: none !important;
                border-right: none !important;
                border-radius: 0 !important;
            }

            /* 3. Increase Repeater/Table internal room while keeping 5px edge */
            .table-responsive {
                width: 100% !important;
                margin: 0 !important;
                padding: 0 !important;
                /* Only show scrollbar if content is wider than screen */
                overflow-x: auto !important; 
            }

            .table {
                /* Remove the forced 900px min-width */
                min-width: 100% !important; 
                width: auto !important;
                /* Allows columns to expand based on the longest text */
                table-layout: auto !important; 
                font-size: 14px !important;
            }

            .table td, .table th {
                /* Prevent text from wrapping so the column expands instead */
                white-space: nowrap !important; 
                padding: 12px 10px !important;
            }

            /* Specifically for P&L or simple two-column tables */
            #profitloss .table, 
            .balance-sheet .table {
                min-width: 100% !important;
                width: 100% !important;
            }

            /* 4. Align summary cards to the 5px margin */
            .summary-card-row {
                margin-left: -5px !important;
                margin-right: -5px !important;
            }

            .summary-card-row > div {
                padding-left: 5px !important;
                padding-right: 5px !important;
                margin-bottom: 10px;
            }

            /* Income Summary Cards */
            .summary-cat-card {
                flex: 0 0 100% !important;
                max-width: 100% !important;
                padding: 0 5px 10px 5px !important;
            }
            
            .summary-cat-card .card-body {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
            }
        }    /* =========================================================
       MISC
    ========================================================= */
    .mb-0 { color: black; }
    #ddlProfitLossPeriod { min-width: 140px; }

    .alert-toast {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 260px;
        max-width: 90vw;
    }
</style>

    <%-- ===== SCRIPTS ===== --%>
    <script type="text/javascript">

        /* ----------------------------------------------------------
           MODAL HELPER  – Bootstrap 5 API (no jQuery .modal())
        ---------------------------------------------------------- */
        function closeModal(modalId) {
            var el = document.getElementById(modalId);
            if (!el) return;
            var instance = bootstrap.Modal.getInstance(el);
            if (instance) instance.hide();
        }

        /* ----------------------------------------------------------
           ALERT TOAST
        ---------------------------------------------------------- */
        function showAlert(type, message) {
            $('.alert-toast').remove();
            var html = '<div class="alert alert-toast alert-' + type +
                ' alert-dismissible fade show shadow" role="alert">' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                '</div>';
            $('body').append(html);
            setTimeout(function () { $('.alert-toast').alert('close'); }, 5000);
        }

        /* ----------------------------------------------------------
           CHARTS  – safe init with destroy-before-recreate
        ---------------------------------------------------------- */
        function initializeCharts() {
            var lineCanvas = document.getElementById('incomeExpenseChart');
            var pieCanvas = document.getElementById('expensePieChart');

            if (!lineCanvas || !pieCanvas) {
                console.warn('Chart canvas elements not found. Skipping.');
                return;
            }

            // Destroy old instances if they exist
            var existingLine = Chart.getChart(lineCanvas);
            if (existingLine) existingLine.destroy();

            var existingPie = Chart.getChart(pieCanvas);
            if (existingPie) existingPie.destroy();

            // Line chart
            new Chart(lineCanvas.getContext('2d'), {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Income',
                        data: [120000, 135000, 140000, 150000, 137000, 145000],
                        borderColor: '#16a34a',
                        backgroundColor: 'rgba(22,163,74,0.08)',
                        tension: 0.3,
                        pointRadius: 4
                    }, {
                        label: 'Expenses',
                        data: [25000, 22000, 28000, 24000, 25500, 26000],
                        borderColor: '#dc2626',
                        backgroundColor: 'rgba(220,38,38,0.08)',
                        tension: 0.3,
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (ctx) {
                                    return ctx.dataset.label + ': ₹' + ctx.raw.toLocaleString('en-IN');
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (v) { return '₹' + v.toLocaleString('en-IN'); }
                            }
                        }
                    }
                }
            });

            // Pie chart
            new Chart(pieCanvas.getContext('2d'), {
                type: 'pie',
                data: {
                    labels: ['Maintenance', 'Repairs', 'Utilities', 'Salaries', 'Security', 'Others'],
                    datasets: [{
                        data: [8000, 5000, 4000, 6000, 2000, 500],
                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (ctx) {
                                    return ctx.label + ': ₹' + ctx.raw.toLocaleString('en-IN');
                                }
                            }
                        }
                    }
                }
            });
        }

        /* ----------------------------------------------------------
           DOCUMENT READY
        ---------------------------------------------------------- */
        $(document).ready(function () {

            // Default dates
            var today = new Date().toISOString().split('T')[0];
            $('#<%= txtIncomeDate.ClientID %>').val(today);
            $('#<%= txtExpenseDate.ClientID %>').val(today);

            // Init charts when their tab is shown
            var incomeTabBtn = document.querySelector('#accountingTabs button[data-bs-target="#income"]');
            if (incomeTabBtn) {
                incomeTabBtn.addEventListener('shown.bs.tab', function () {
                    initializeCharts();
                });
            }

            // If income tab is active on load, init immediately
            if (incomeTabBtn && incomeTabBtn.classList.contains('active')) {
                initializeCharts();
            }

            // Persist active tab on postback
            document.querySelectorAll('#accountingTabs .nav-link').forEach(function (tab) {
                tab.addEventListener('shown.bs.tab', function (e) {
                    document.getElementById('<%= hdnActiveTab.ClientID %>').value = e.target.id;
                });
            });

            // Restore active tab after postback
            var savedTab = document.getElementById('<%= hdnActiveTab.ClientID %>').value;
            if (savedTab) {
                var el = document.getElementById(savedTab);
                if (el) new bootstrap.Tab(el).show();
            }

            // UpdatePanel support (only if ScriptManager exists)
            if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                    initializeCharts();
                });
            }
        });

    </script>

    <%-- ===== DELETE CONFIRMATION (consolidated – ONE handler each) ===== --%>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {

            /* --- Generic delete (.delete-btn) --- */
            document.querySelectorAll(".delete-btn").forEach(function (btn) {
                btn.addEventListener("click", function (e) {
                    e.preventDefault();
                    var uniqueId = this.getAttribute("data-uniqueid");
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You won't be able to revert this!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Yes, delete it!',
                        cancelButtonText: 'Cancel',
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        customClass: {
                            confirmButton: 'btn btn-danger me-2',
                            cancelButton: 'btn btn-secondary'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.isConfirmed && uniqueId) {
                            __doPostBack(uniqueId, '');
                        }
                    });
                });
            });

            /* --- Liability delete (.delete-liability-btn) --- */
            document.querySelectorAll(".delete-liability-btn").forEach(function (btn) {
                btn.addEventListener("click", function (e) {
                    e.preventDefault();
                    var uniqueId = this.getAttribute("data-uniqueid");
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "This liability will be deleted permanently.",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Yes, delete it!',
                        cancelButtonText: 'Cancel',
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        customClass: {
                            confirmButton: 'btn btn-danger me-2',
                            cancelButton: 'btn btn-secondary'
                        },
                        buttonsStyling: false
                    }).then(function (result) {
                        if (result.isConfirmed && uniqueId) {
                            __doPostBack(uniqueId, '');
                        }
                    });
                });
            });

        });
    </script>

</asp:Content>

<%-- ===================================================
     BREADCRUMB
===================================================== --%>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<%-- ===================================================
     PAGE TITLE / TOOLBAR
===================================================== --%>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="container-fluid px-0">
        <div class="page-title-bar">

            <%-- Date Filter (hidden until Custom Period selected) --%>
            <div id="dateFilterContainer" runat="server" class="date-filter-container" style="display:none;">
                <span class="date-filter-label">From</span>
                <asp:TextBox ID="txtFromDateFilter" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                <span class="date-filter-label">To</span>
                <asp:TextBox ID="txtToDateFilter" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                <asp:Button ID="btnApplyFilter" runat="server" Text="Apply" CssClass="btn btn-sm btn-primary" OnClick="btnApplyFilter_Click" />
            </div>

            <%-- Action Buttons + Period Selector --%>
            <div class="d-flex flex-wrap gap-2 ms-auto">
                <div class="btn-group">
                    <button type="button" class="btn btn-sm btn-outline-secondary"
                            data-bs-toggle="modal" data-bs-target="#addIncomeModal">
                        <i class="fas fa-plus-circle me-1"></i>Income
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-secondary"
                            data-bs-toggle="modal" data-bs-target="#addExpenseModal">
                        <i class="fas fa-minus-circle me-1"></i>Expense
                    </button>
                </div>

                <asp:DropDownList ID="ddlProfitLossPeriod" runat="server"
                    CssClass="form-select form-select-sm"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlProfitLossPeriod_SelectedIndexChanged">
                    <asp:ListItem Text="Current Month"  Value="1" Selected="True" />
                    <asp:ListItem Text="Last Month"     Value="2" />
                    <asp:ListItem Text="Current Year"   Value="3" />
                    <asp:ListItem Text="Last Year"      Value="4" />
                    <asp:ListItem Text="Custom Period"  Value="5" />
                </asp:DropDownList>
            </div>

        </div>
    </div>
</asp:Content>

<%-- ===================================================
     MAIN CONTENT
===================================================== --%>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid px-0">

        <%-- ── Summary Cards ───────────────────────────────────── --%>
        <div class="row summary-card-row mb-3 g-3">
            <div class="col-12 col-sm-4">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-1">
                            <i class="fas fa-arrow-up-circle text-success me-2 fs-5"></i>
                            <h6 class="card-title mb-0 text-muted">Total Income</h6>
                        </div>
                        <h3 class="income-amount mb-0">
                            <asp:Literal ID="litTotalIncome" runat="server" Text="₹0.00" />
                        </h3>
                        <small class="text-muted">This financial year</small>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-4">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-1">
                            <i class="fas fa-arrow-down-circle text-danger me-2 fs-5"></i>
                            <h6 class="card-title mb-0 text-muted">Total Expenses</h6>
                        </div>
                        <h3 class="expense-amount mb-0">
                            <asp:Literal ID="litTotalExpense" runat="server" Text="₹0.00" />
                        </h3>
                        <small class="text-muted">This financial year</small>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-4">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-1">
                            <i class="fas fa-wallet text-primary me-2 fs-5"></i>
                            <h6 class="card-title mb-0 text-muted">Current Balance</h6>
                        </div>
                        <h3 class="mb-0">
                            <asp:Literal ID="litCurrentBalance" runat="server" Text="₹0.00" />
                        </h3>
                        <small class="text-muted">As of today</small>
                    </div>
                </div>
            </div>
        </div>

        <%-- Hidden field for active tab --%>
        <asp:HiddenField ID="hdnActiveTab" runat="server" />

        <%-- ── Tabs ─────────────────────────────────────────────── --%>
        <ul class="nav nav-tabs" id="accountingTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="income-tab"
                        data-bs-toggle="tab" data-bs-target="#income"
                        type="button" role="tab">
                    <i class="fas fa-arrow-up me-1 d-none d-sm-inline"></i>Income
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="expense-tab"
                        data-bs-toggle="tab" data-bs-target="#expense"
                        type="button" role="tab">
                    <i class="fas fa-arrow-down me-1 d-none d-sm-inline"></i>Expenses
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="balance-tab"
                        data-bs-toggle="tab" data-bs-target="#balance"
                        type="button" role="tab">
                    <i class="fas fa-balance-scale me-1 d-none d-sm-inline"></i>Balance Sheet
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="profitloss-tab"
                        data-bs-toggle="tab" data-bs-target="#profitloss"
                        type="button" role="tab">
                    <i class="fas fa-chart-line me-1 d-none d-sm-inline"></i>P&amp;L
                </button>
            </li>
        </ul>

        <div class="tab-content" id="accountingTabsContent">

            <%-- ══════════════════════════════════════════════════
                 INCOME TAB
            ══════════════════════════════════════════════════ --%>
            <div class="tab-pane fade show active" id="income" role="tabpanel">

                <h6 class="mb-3 fw-semibold">Income Transactions</h6>

                <div class="table-responsive">
                    <asp:Repeater ID="rptIncome" runat="server"
                                  OnItemCommand="rptIncome_ItemCommand"
                                  OnItemDataBound="rptIncome_ItemDataBound">
                        <HeaderTemplate>
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Category</th>
                                        <th class="text-end">Amount</th>
                                        <th>Received From</th>
                                        <th>Payment</th>
                                        <th>Description</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>

                        <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Label ID="lblDate" runat="server"
                                        Text='<%# Eval("Date", "{0:dd-MMM-yyyy}") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtDate" runat="server"
                                        Text='<%# Eval("Date", "{0:yyyy-MM-dd}") %>'
                                        CssClass="form-control form-control-sm" TextMode="Date"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblCategory" runat="server"
                                        Text='<%# Eval("CategoryName") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtCategory" runat="server"
                                        Text='<%# Eval("CategoryName") %>'
                                        CssClass="form-control form-control-sm" Enabled="false"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td class="text-end">
                                    <asp:Label ID="lblAmount" runat="server"
                                        Text='<%# Eval("Amount", "{0:C}") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtAmount" runat="server"
                                        Text='<%# Eval("Amount") %>'
                                        CssClass="form-control form-control-sm text-end"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblFrom" runat="server"
                                        Text='<%# Eval("ReceivedFrom") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtFrom" runat="server"
                                        Text='<%# Eval("ReceivedFrom") %>'
                                        CssClass="form-control form-control-sm"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblPayment" runat="server"
                                        Text='<%# Eval("PaymentMethod") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtPayment" runat="server"
                                        Text='<%# Eval("PaymentMethod") %>'
                                        CssClass="form-control form-control-sm"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblDesc" runat="server"
                                        Text='<%# Eval("Description") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtDesc" runat="server"
                                        Text='<%# Eval("Description") %>'
                                        CssClass="form-control form-control-sm"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td class="text-end text-nowrap">
                                    <%-- View Mode --%>
                                    <asp:LinkButton ID="btnEdit" runat="server"
                                        CssClass="btn btn-sm btn-outline-success me-1"
                                        CommandName="Edit"
                                        CommandArgument='<%# Eval("TransactionID") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'>
                                        <i class="fas fa-pencil-alt"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDelete" runat="server"
                                        CssClass="btn btn-sm btn-outline-danger delete-btn"
                                        CommandName="Delete"
                                        CommandArgument='<%# Eval("TransactionID") %>'
                                        data-uniqueid='<%# ((System.Web.UI.WebControls.LinkButton)Container.FindControl("btnDelete")).UniqueID %>'
                                        OnClientClick="return false;"
                                        Visible='<%# !(bool)Eval("IsEditing") %>'>
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>

                                    <%-- Edit Mode --%>
                                    <div class="d-inline-flex gap-1" runat="server" visible='<%# (bool)Eval("IsEditing") %>'>
                                        <asp:LinkButton ID="btnUpdate" runat="server"
                                            CssClass="btn btn-sm btn-primary"
                                            CommandName="Update"
                                            CommandArgument='<%# Eval("TransactionID") %>'>
                                            <i class="fas fa-check"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server"
                                            CssClass="btn btn-sm btn-secondary"
                                            CommandName="Cancel"
                                            CommandArgument='<%# Eval("TransactionID") %>'>
                                            <i class="fas fa-times"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>

                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoIncome" runat="server" Visible="false">
                        <div class="border rounded p-4 text-center text-muted bg-light">
                            <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                            No income records found.
                        </div>
                    </asp:Panel>
                </div>

                <%-- Income Summary --%>
                <div class="card mt-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Income Summary</h6>
                    </div>
                    <div class="card-body">
                        <div class="row g-2">
                            <asp:Repeater ID="rptIncomeSummary" runat="server">
                                <ItemTemplate>
                                    <div class="col-6 col-sm-4 col-md-3 summary-cat-card">
                                        <div class="card border-success">
                                            <div class="card-body">
                                                <h6 class="card-title text-muted small"><%# Eval("CategoryName") %></h6>
                                                <p class="card-text text-end fw-bold text-success mb-0">
                                                    <%# string.Format("₹{0:N2}", Eval("TotalAmount")) %>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="col-6 col-sm-4 col-md-3 summary-cat-card">
                                <div class="card bg-primary text-white">
                                    <div class="card-body">
                                        <h6 class="card-title small">Total Income</h6>
                                        <p class="card-text text-end fw-bold mb-0">
                                            <asp:Literal ID="litIncomeTotal" runat="server" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><%-- /income tab --%>

            <%-- ══════════════════════════════════════════════════
                 EXPENSE TAB
            ══════════════════════════════════════════════════ --%>
            <div class="tab-pane fade" id="expense" role="tabpanel">

                <h6 class="mb-3 fw-semibold">Expense Transactions</h6>

                <div class="table-responsive">
                    <asp:Repeater ID="rptExpense" runat="server" OnItemCommand="rptExpense_ItemCommand">
                        <HeaderTemplate>
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Category</th>
                                        <th class="text-end">Amount</th>
                                        <th>Paid To</th>
                                        <th>Payment</th>
                                        <th>Description</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>

                        <ItemTemplate>
                            <tr>
                                <td>
                                    <asp:Label ID="lblDate" runat="server"
                                        Text='<%# Eval("Date", "{0:dd-MMM-yyyy}") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtDate" runat="server"
                                        Text='<%# Eval("Date", "{0:yyyy-MM-dd}") %>'
                                        TextMode="Date" CssClass="form-control form-control-sm"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblCategory" runat="server"
                                        Text='<%# Eval("CategoryName") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtCategory" runat="server"
                                        Text='<%# Eval("CategoryName") %>'
                                        CssClass="form-control form-control-sm" Enabled="false"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td class="text-end">
                                    <asp:Label ID="lblAmount" runat="server"
                                        Text='<%# Eval("Amount", "{0:C}") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtAmount" runat="server"
                                        Text='<%# Eval("Amount") %>'
                                        CssClass="form-control form-control-sm text-end"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblPaidTo" runat="server"
                                        Text='<%# Eval("PaidTo") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtPaidTo" runat="server"
                                        Text='<%# Eval("PaidTo") %>'
                                        CssClass="form-control form-control-sm"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblPaymentMethod" runat="server"
                                        Text='<%# Eval("PaymentMethod") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtPaymentMethod" runat="server"
                                        Text='<%# Eval("PaymentMethod") %>'
                                        CssClass="form-control form-control-sm"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblDesc" runat="server"
                                        Text='<%# Eval("Description") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                    <asp:TextBox ID="txtDesc" runat="server"
                                        Text='<%# Eval("Description") %>'
                                        CssClass="form-control form-control-sm"
                                        Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                </td>
                                <td class="text-end text-nowrap">
                                    <%-- View Mode --%>
                                    <asp:LinkButton ID="btnEdit" runat="server"
                                        CssClass="btn btn-sm btn-outline-success me-1"
                                        CommandName="Edit"
                                        CommandArgument='<%# Eval("TransactionID") %>'
                                        Visible='<%# !(bool)Eval("IsEditing") %>'>
                                        <i class="fas fa-pencil-alt"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDelete" runat="server"
                                        CssClass="btn btn-sm btn-outline-danger delete-btn"
                                        CommandName="Delete"
                                        CommandArgument='<%# Eval("TransactionID") %>'
                                        data-uniqueid='<%# ((System.Web.UI.WebControls.LinkButton)Container.FindControl("btnDelete")).UniqueID %>'
                                        OnClientClick="return false;"
                                        Visible='<%# !(bool)Eval("IsEditing") %>'>
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>

                                    <%-- Edit Mode --%>
                                    <div class="d-inline-flex gap-1" runat="server" visible='<%# (bool)Eval("IsEditing") %>'>
                                        <asp:LinkButton ID="btnUpdate" runat="server"
                                            CssClass="btn btn-sm btn-primary"
                                            CommandName="Update"
                                            CommandArgument='<%# Eval("TransactionID") %>'>
                                            <i class="fas fa-check"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server"
                                            CssClass="btn btn-sm btn-secondary"
                                            CommandName="Cancel"
                                            CommandArgument='<%# Eval("TransactionID") %>'>
                                            <i class="fas fa-times"></i>
                                        </asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>

                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoExpense" runat="server" Visible="false">
                        <div class="border rounded p-4 text-center text-muted bg-light">
                            <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                            No expense records found.
                        </div>
                    </asp:Panel>
                </div>

                <%-- Expense Summary --%>
                <div class="card mt-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Expense Summary</h6>
                    </div>
                    <div class="card-body">
                        <div class="row g-2">
                            <asp:Repeater ID="rptExpenseSummary" runat="server">
                                <ItemTemplate>
                                    <div class="col-6 col-sm-4 col-md-3 summary-cat-card">
                                        <div class="card border-danger">
                                            <div class="card-body">
                                                <h6 class="card-title text-muted small"><%# Eval("CategoryName") %></h6>
                                                <p class="card-text text-end fw-bold text-danger mb-0">
                                                    <%# string.Format("₹{0:N2}", Eval("TotalAmount")) %>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="col-6 col-sm-4 col-md-3 summary-cat-card">
                                <div class="card bg-danger text-white">
                                    <div class="card-body">
                                        <h6 class="card-title small">Total Expenses</h6>
                                        <p class="card-text text-end fw-bold mb-0">
                                            <asp:Literal ID="litExpenseTotal" runat="server" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><%-- /expense tab --%>

            <%-- ══════════════════════════════════════════════════
                 BALANCE SHEET TAB
            ══════════════════════════════════════════════════ --%>
            <div class="tab-pane fade" id="balance" role="tabpanel">
                <div class="balance-sheet">

                    <%-- Add Entry Form --%>
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h6 class="mb-0">Add New Entry</h6>
                        </div>
                        <div class="card-body">
                            <div class="row g-3 align-items-end">
                                <div class="col-12 col-sm-6 col-md-4">
                                    <label class="form-label">Category</label>
                                    <asp:TextBox ID="txtCategory" runat="server"
                                        CssClass="form-control" Placeholder="Enter category name" />
                                </div>
                                <div class="col-6 col-sm-3 col-md-3">
                                    <label class="form-label">Type</label>
                                    <asp:DropDownList ID="ddlEntryType" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Asset"     Value="Asset" />
                                        <asp:ListItem Text="Liability" Value="Liability" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-6 col-sm-3 col-md-3">
                                    <label class="form-label">Amount (₹)</label>
                                    <asp:TextBox ID="txtAmount" runat="server"
                                        CssClass="form-control" Placeholder="0.00"
                                        TextMode="Number" step="0.01" />
                                </div>
                                <div class="col-12 col-md-2">
                                    <asp:Button ID="btnAdd" runat="server" Text="Add Entry"
                                        CssClass="btn btn-primary w-100"
                                        OnClick="btnAdd_Click1"
                                        ValidationGroup="BalanceSheet" />
                                </div>
                            </div>
                            <asp:Label ID="lblStatus" runat="server" CssClass="mt-2 d-block" />
                        </div>
                    </div>

                    <%-- Assets & Liabilities --%>
                    <div class="row g-3">

                        <%-- Assets --%>
                        <div class="col-12 col-md-6">
                            <div class="card mb-3">
                                <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0">Assets</h6>
                                    <span class="badge bg-light text-dark">
                                        Total: <asp:Literal ID="litTotalAssets" runat="server" Text="₹0.00" />
                                    </span>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <asp:Repeater ID="rptAssets" runat="server" OnItemCommand="rptAssets_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table table-sm table-striped mb-0" style="min-width:300px">
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
                                                    <td>
                                                        <asp:Label ID="lblCategory" runat="server"
                                                            Text='<%# Eval("Category") %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                                        <asp:TextBox ID="txtCategory" runat="server"
                                                            Text='<%# Eval("Category") %>'
                                                            CssClass="form-control form-control-sm"
                                                            Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                                    </td>
                                                    <td class="text-end">
                                                        <asp:Label ID="lblAmount" runat="server"
                                                            Text='<%# string.Format("₹{0:N2}", Eval("Amount")) %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                                        <asp:TextBox ID="txtAmount" runat="server"
                                                            Text='<%# Eval("Amount") %>'
                                                            CssClass="form-control form-control-sm text-end"
                                                            Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                                    </td>
                                                    <td class="text-end text-nowrap">
                                                        <asp:LinkButton ID="btnEdit" runat="server"
                                                            CssClass="btn btn-sm btn-outline-success"
                                                            CommandName="Edit"
                                                            CommandArgument='<%# Eval("EntryID") %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'>
                                                            <i class="fas fa-pencil-alt"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnDelete" runat="server"
                                                            CssClass="btn btn-sm btn-outline-danger delete-btn"
                                                            CommandName="Delete"
                                                            CommandArgument='<%# Eval("EntryID") %>'
                                                            OnClientClick="return false;"
                                                            data-uniqueid='<%# ((System.Web.UI.WebControls.LinkButton)Container.FindControl("btnDelete")).UniqueID %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'>
                                                            <i class="fas fa-trash"></i>
                                                        </asp:LinkButton>
                                                        <div class="d-inline-flex gap-1" runat="server" visible='<%# (bool)Eval("IsEditing") %>'>
                                                            <asp:LinkButton ID="btnUpdate" runat="server"
                                                                CssClass="btn btn-sm btn-primary"
                                                                CommandName="Update"
                                                                CommandArgument='<%# Eval("EntryID") %>'>
                                                                <i class="fas fa-check"></i>
                                                            </asp:LinkButton>
                                                            <asp:LinkButton ID="btnCancel" runat="server"
                                                                CssClass="btn btn-sm btn-secondary"
                                                                CommandName="Cancel"
                                                                CommandArgument='<%# Eval("EntryID") %>'>
                                                                <i class="fas fa-times"></i>
                                                            </asp:LinkButton>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                    </tbody>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                        <asp:Panel ID="pnlNoAssets" runat="server" CssClass="text-center py-3" Visible="false">
                                            <i class="fas fa-wallet fa-2x text-muted mb-2 d-block"></i>
                                            <p class="text-muted mb-0">No assets recorded yet</p>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Liabilities --%>
                        <div class="col-12 col-md-6">
                            <div class="card mb-3">
                                <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0">Liabilities</h6>
                                    <span class="badge bg-light text-dark">
                                        Total: <asp:Literal ID="litTotalLiabilities" runat="server" Text="₹0.00" />
                                    </span>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <asp:Repeater ID="rptLiabilities" runat="server" OnItemCommand="rptLiabilities_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table table-sm table-striped mb-0" style="min-width:300px">
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
                                                    <td>
                                                        <asp:Label ID="lblCategory" runat="server"
                                                            Text='<%# Eval("Category") %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                                        <asp:TextBox ID="txtCategory" runat="server"
                                                            Text='<%# Eval("Category") %>'
                                                            CssClass="form-control form-control-sm"
                                                            Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                                    </td>
                                                    <td class="text-end">
                                                        <asp:Label ID="lblAmount" runat="server"
                                                            Text='<%# string.Format("₹{0:N2}", Eval("Amount")) %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'></asp:Label>
                                                        <asp:TextBox ID="txtAmount" runat="server"
                                                            Text='<%# Eval("Amount") %>'
                                                            CssClass="form-control form-control-sm text-end"
                                                            Visible='<%# (bool)Eval("IsEditing") %>'></asp:TextBox>
                                                    </td>
                                                    <td class="text-end text-nowrap">
                                                        <asp:LinkButton ID="btnEdit" runat="server"
                                                            CssClass="btn btn-sm btn-outline-success"
                                                            CommandName="Edit"
                                                            CommandArgument='<%# Eval("EntryID") %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'>
                                                            <i class="fas fa-pencil-alt"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnDeleteLiability" runat="server"
                                                            CssClass="btn btn-sm btn-outline-danger delete-liability-btn"
                                                            CommandName="DeleteLiability"
                                                            CommandArgument='<%# Eval("EntryID") %>'
                                                            OnClientClick="return false;"
                                                            data-uniqueid='<%# ((System.Web.UI.WebControls.LinkButton)Container.FindControl("btnDeleteLiability")).UniqueID %>'
                                                            Visible='<%# !(bool)Eval("IsEditing") %>'>
                                                            <i class="fas fa-trash"></i>
                                                        </asp:LinkButton>
                                                        <div class="d-inline-flex gap-1" runat="server" visible='<%# (bool)Eval("IsEditing") %>'>
                                                            <asp:LinkButton ID="btnUpdate" runat="server"
                                                                CssClass="btn btn-sm btn-primary"
                                                                CommandName="Update"
                                                                CommandArgument='<%# Eval("EntryID") %>'>
                                                                <i class="fas fa-check"></i>
                                                            </asp:LinkButton>
                                                            <asp:LinkButton ID="btnCancel" runat="server"
                                                                CssClass="btn btn-sm btn-secondary"
                                                                CommandName="Cancel"
                                                                CommandArgument='<%# Eval("EntryID") %>'>
                                                                <i class="fas fa-times"></i>
                                                            </asp:LinkButton>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                    </tbody>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                        <asp:Panel ID="pnlNoLiabilities" runat="server" CssClass="text-center py-3" Visible="false">
                                            <i class="fas fa-file-invoice-dollar fa-2x text-muted mb-2 d-block"></i>
                                            <p class="text-muted mb-0">No liabilities recorded yet</p>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Net Worth Summary --%>
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <h6 class="mb-0">Net Worth Summary</h6>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-12 col-sm-6">
                                    <div class="d-flex justify-content-between mb-2 border-bottom pb-2">
                                        <span>Total Assets:</span>
                                        <strong class="text-success">
                                            <asp:Literal ID="litTotalAssetsSummary" runat="server" Text="₹0.00" />
                                        </strong>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span>Total Liabilities:</span>
                                        <strong class="text-danger">
                                            <asp:Literal ID="litTotalLiabilitiesSummary" runat="server" Text="₹0.00" />
                                        </strong>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6">
                                    <div class="bg-light p-3 rounded text-center h-100 d-flex flex-column justify-content-center">
                                        <small class="text-muted">Net Worth</small>
                                        <h4 class="mb-0 fw-bold">
                                            <asp:Literal ID="litNetWorth" runat="server" Text="₹0.00" />
                                        </h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div><%-- /balance tab --%>

            <%-- ══════════════════════════════════════════════════
                 PROFIT & LOSS TAB
            ══════════════════════════════════════════════════ --%>
            <div class="tab-pane fade" id="profitloss" role="tabpanel">

                <h5 class="mb-3 fw-semibold">Profit &amp; Loss Statement</h5>

                <%-- Income section --%>
                <div class="card mb-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0 text-success"><i class="fas fa-arrow-up me-1"></i>Income</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
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
                                    <tr class="table-light fw-bold">
                                        <td>Total Income</td>
                                        <td class="text-end text-success">
                                            <asp:Literal ID="litPLTotalIncome" runat="server" Text="₹0.00" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <%-- Expense section --%>
                <div class="card mb-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0 text-danger"><i class="fas fa-arrow-down me-1"></i>Expenses</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
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
                                    <tr class="table-light fw-bold">
                                        <td>Total Expenses</td>
                                        <td class="text-end text-danger">
                                            <asp:Literal ID="litPLTotalExpenses" runat="server" Text="₹0.00" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <%-- Net result --%>
                <div class="card bg-success text-white">
                    <div class="card-body py-3">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <h6 class="mb-0">Net Profit / Loss (Income − Expenses)</h6>
                            <h4 class="mb-0 fw-bold">
                                <asp:Literal ID="litNetProfitLoss" runat="server" Text="₹0.00" />
                            </h4>
                        </div>
                    </div>
                </div>

            </div><%-- /profitloss tab --%>

        </div><%-- /tab-content --%>

        <%-- ══════════════════════════════════════════════════
             MODALS
        ══════════════════════════════════════════════════ --%>

        <%-- Add Income Modal --%>
        <div class="modal fade" id="addIncomeModal" tabindex="-1"
             aria-labelledby="addIncomeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addIncomeModalLabel">
                            <i class="fas fa-plus-circle text-success me-2"></i>Add Income
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <asp:DropDownList ID="ddlIncomeCategory" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Amount</label>
                            <asp:TextBox ID="txtIncomeAmount" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                            <asp:CompareValidator ID="cvIncomeAmount" runat="server"
                                ControlToValidate="txtIncomeAmount"
                                ErrorMessage="Amount must be greater than 0"
                                Display="Dynamic" CssClass="text-danger small"
                                Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date</label>
                            <asp:TextBox ID="txtIncomeDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Received From</label>
                            <asp:TextBox ID="txtReceivedFrom" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <asp:DropDownList ID="ddlIncomePaymentMethod" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Cash"           Value="Cash" />
                                <asp:ListItem Text="Cheque"         Value="Cheque" />
                                <asp:ListItem Text="Bank Transfer"  Value="Bank Transfer" />
                                <asp:ListItem Text="Online Payment" Value="Online Payment" />
                            </asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <asp:TextBox ID="txtIncomeDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <asp:Button ID="btnAddIncome" runat="server" Text="Add Income"
                            CssClass="btn btn-success" OnClick="btnAddIncome_Click" />
                    </div>
                </div>
            </div>
        </div>

        <%-- Add Expense Modal --%>
        <div class="modal fade" id="addExpenseModal" tabindex="-1"
             aria-labelledby="addExpenseModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addExpenseModalLabel">
                            <i class="fas fa-minus-circle text-danger me-2"></i>Add Expense
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <asp:DropDownList ID="ddlExpenseCategory" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Amount</label>
                            <asp:TextBox ID="txtExpenseAmount" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                            <asp:CompareValidator ID="cvExpenseAmount" runat="server"
                                ControlToValidate="txtExpenseAmount"
                                ErrorMessage="Amount must be greater than 0"
                                Display="Dynamic" CssClass="text-danger small"
                                Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date</label>
                            <asp:TextBox ID="txtExpenseDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Paid To</label>
                            <asp:TextBox ID="txtPaidTo" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <asp:DropDownList ID="ddlExpensePaymentMethod" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Cash"           Value="Cash" />
                                <asp:ListItem Text="Cheque"         Value="Cheque" />
                                <asp:ListItem Text="Bank Transfer"  Value="Bank Transfer" />
                                <asp:ListItem Text="Online Payment" Value="Online Payment" />
                            </asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <asp:TextBox ID="txtExpenseDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <asp:Button ID="btnAddExpense" runat="server" Text="Add Expense"
                            CssClass="btn btn-danger" OnClick="btnAddExpense_Click" />
                    </div>
                </div>
            </div>
        </div>

        <%-- Custom Period Modal --%>
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
                                ErrorMessage="To Date must be after From Date"
                                Display="Dynamic" CssClass="text-danger small"
                                Type="Date" Operator="GreaterThanEqual"></asp:CompareValidator>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnApplyCustomPeriod" runat="server" Text="Apply"
                            CssClass="btn btn-primary" OnClick="btnApplyCustomPeriod_Click" />
                    </div>
                </div>
            </div>
        </div>

    </div><%-- /container-fluid --%>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
