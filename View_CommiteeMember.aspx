<%@ Page Title="View Committee Members" Language="C#" MasterPageFile="~/Adashboard.Master"
    AutoEventWireup="true" CodeBehind="View_CommiteeMember.aspx.cs"
    Inherits="Society_management.View_CommiteeMember"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

   <!-- DataTables CSS -->
    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />

    <!-- IMPORTANT:
         Do NOT include jQuery or Bootstrap JS here.
         They are already loaded in your Master Page.
         Loading them again breaks Bootstrap dropdowns.
    -->

    <!-- DataTables JS only -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript">
        function initDataTable() {
            var $table = $('#<%= gvDisplay.ClientID %>');

            if ($table.length > 0 && $table.find('tbody tr').length > 0) {

                // Create thead if missing
                if ($table.find('thead').length === 0) {
                    var $headerRow = $table.find('tr:first');
                    var $thead = $('<thead></thead>').append($headerRow);
                    $table.prepend($thead);
                }

                // Destroy existing DataTable before reinitializing
                if ($.fn.DataTable.isDataTable($table)) {
                    $table.DataTable().destroy();
                }

                // Initialize DataTable
                $table.DataTable({
                    paging: true,
                    searching: true,
                    ordering: true,
                    responsive: true,
                    pageLength: 10,
                    autoWidth: false
                });
            }
        }

        // Initial page load
        $(document).ready(function () {
            initDataTable();
        });

        // For UpdatePanel partial postbacks
        if (typeof Sys !== 'undefined' &&
            Sys.WebForms &&
            Sys.WebForms.PageRequestManager) {

            Sys.WebForms.PageRequestManager.getInstance()
                .add_endRequest(function () {
                    initDataTable();
                });
        }

        // Clickable row navigation
        $(document).on('click', '.clickable-row', function () {
            var committeeId = $(this).attr('data-Committee-id');
            if (committeeId) {
                window.location.href =
                    'Committee_Details.aspx?id=' + committeeId;
            }
        });
    </script>

    <style>
        /* =========================================
           TABLE RESPONSIVE
        ========================================= */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border: none !important;
        }

        /* =========================================
           GRIDVIEW CUSTOM TABLE
        ========================================= */
        .grid-view-custom {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
            margin-bottom: 0 !important;
        }

        /* Header */
        .grid-view-custom thead th {
            background-color: transparent;
            color: #495057;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
            padding: 12px 15px;
            white-space: nowrap;
        }

        /* Keep DataTables sort arrows visible */
        table.dataTable thead th.sorting,
        table.dataTable thead th.sorting_asc,
        table.dataTable thead th.sorting_desc {
            background-color: transparent !important;
            color: #495057 !important;
            padding-right: 30px !important;
        }

        /* Rows */
        .grid-view-custom tbody tr {
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .grid-view-custom tbody tr:hover {
            background-color: #f8f9fa !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            cursor: pointer;
        }

        /* Cells */
        .grid-view-custom tbody td {
            padding: 12px 15px;
            border-top: none !important;
            border-bottom: none !important;
            vertical-align: middle;
        }

        /* Rounded corners */
        .grid-view-custom tbody td:first-child {
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }

        .grid-view-custom tbody td:last-child {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

        /* =========================================
           DATATABLE CONTROLS
        ========================================= */
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .dataTables_wrapper .dataTables_filter input {
            margin-left: 0.5em;
            border: 1px solid #ced4da;
            border-radius: 6px;
            padding: 4px 8px;
        }

        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #ced4da;
            border-radius: 6px;
            padding: 4px 8px;
            margin: 0 5px;
        }

        /* =========================================
           BUTTONS
        ========================================= */
        .dashboard-btn {
            padding: 10px 24px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            text-decoration: none !important;
            color: white !important;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .btn-create {
            background: #4e73df;
        }

        .btn-past {
            background: #5a5c69;
        }

        .dashboard-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        /* =========================================
           EMPTY STATE
        ========================================= */
        .empty-state-container {
            padding: 60px 20px;
            text-align: center;
            background-color: #ffffff;
            border-radius: 1rem;
        }

        .empty-state-icon {
            font-size: 4rem;
            color: #eaecf4;
            margin-bottom: 1rem;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        /* Hide Breadcrumb */
        .breadcrumb {
            display: none !important;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
        <a href="Past_Committee.aspx" class="dashboard-btn btn-past">
            <i class="bi bi-clock-history me-2"></i> View Past Committee
        </a>

        <a href="CommiteeMember.aspx" class="dashboard-btn btn-create">
            <i class="bi bi-plus-circle me-2"></i> Create Committee
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">

        <div class="row">
            <div class="col-12">
                <asp:Panel ID="Panel1" runat="server" CssClass="alert alert-success shadow-sm" Visible="false">
                    <asp:Label ID="Label1" runat="server"></asp:Label>
                </asp:Panel>
            </div>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border bg-white">
                <div class="empty-state-icon">
                    <i class="bi bi-people"></i>
                </div>
                <h3 class="fw-bold" style="color:#4e73df;">No Committee Members</h3>
                <p class="text-muted mb-4">
                    There are currently no active members registered. Establish your society leadership by clicking the button below.
                </p>
                <div class="d-flex gap-3 justify-content-center flex-wrap">
                    <a href="Past_Committee.aspx" class="dashboard-btn btn-past">
                        <i class="bi bi-clock-history me-2"></i> View Past
                    </a>
                    <a href="CommiteeMember.aspx" class="dashboard-btn btn-create">
                        <i class="bi bi-plus-circle me-2"></i> Create Now
                    </a>
                </div>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-sm border-0 rounded bg-white">
                        <div class="card-body p-4">
                            <div class="table-responsive">
                                <asp:GridView ID="gvDisplay" runat="server"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="Committee_id"
                                    CssClass="table table-striped table-bordered grid-view-custom w-100"
                                    OnRowDataBound="gvDisplay_RowDataBound"
                                    OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged"
                                    GridLines="None">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Committee Member">
                                            <ItemTemplate><b><%# Eval("User_name") %></b></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Designation">
                                            <ItemTemplate><%# Eval("Designation") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Phone Number">
                                            <ItemTemplate><%# Eval("Phone_no") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Role">
                                            <ItemTemplate><%# Eval("Role") %></ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>