<%@ Page Title="All Notices" Language="C#" MasterPageFile="~/Adashboard.Master"
    AutoEventWireup="true"
    CodeBehind="View_Allnotice.aspx.cs"
    Inherits="Society_management.View_Allnotice"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Font Awesome -->
    <link href="fontawesome/css/all.css" rel="stylesheet" />

    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet" />

    <!-- DataTables JS ONLY -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var $table = $('#<%= gvDisplay.ClientID %>');

            // Stop if table does not exist
            if ($table.length === 0) return;

            // Stop if no data rows
            if ($table.find('tbody tr').length === 0) return;

            // Create THEAD if ASP.NET did not render one
            if ($table.find('thead').length === 0) {
                var $firstRow = $table.find('tr:first');

                if ($firstRow.find('th').length > 0) {
                    $table.prepend(
                        $('<thead></thead>').append($firstRow)
                    );
                }
            }

            // Verify column counts
            var headerCount = $table.find('thead th').length;
            var bodyCount = $table.find('tbody tr:first td').length;

            if (headerCount === 0 || bodyCount === 0 || headerCount !== bodyCount) {
                return;
            }

            // Initialize DataTable
            if (!$.fn.DataTable.isDataTable($table)) {
                $table.DataTable({
                    paging: true,
                    lengthChange: true,
                    searching: true,
                    ordering: true,
                    info: true,
                    autoWidth: false,
                    responsive: true,
                    serverSide: false,
                    processing: false,
                    pageLength: 10,
                    language: {
                        search: "Search Notices:",
                        emptyTable: "No notices available"
                    }
                });
            }

            // Row click navigation
            $table.find('tbody').on('click', 'tr.clickable-row', function () {
                var noticeId = $(this).attr('data-notice-id');
                if (noticeId) {
                    window.location.href = 'Admin_noticeDetails.aspx?id=' + noticeId;
                }
            });
        });
    </script>

    <style>
        /* Hide breadcrumb */
        .breadcrumb {
            display: none !important;
        }

        /* =========================================
           TABLE RESPONSIVE
        ========================================= */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border: none !important;
            width: 100%;
        }

        /* =========================================
           GRIDVIEW STYLE
        ========================================= */
        .grid-view-custom {
            border-collapse: separate;
            border-spacing: 0 8px;
            margin-bottom: 0;
            width: 100%;
        }

        /* Header Styling */
        .grid-view-custom thead th,
        table.dataTable thead th,
        table.dataTable thead td {
            background-color: transparent !important;
            color: #495057 !important;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6 !important;
            padding: 12px 15px;
            white-space: nowrap;
            padding-right: 30px !important;
            vertical-align: middle;
        }

        /* Rows */
        .grid-view-custom tbody tr {
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        /* Hover */
        .grid-view-custom tbody tr:hover {
            background-color: #f8f9fa !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            cursor: pointer;
        }

        /* Active */
        .grid-view-custom tbody tr:active,
        .grid-view-custom tbody tr.highlight {
            background-color: #e9ecef !important;
            transform: translateY(0);
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
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
            border-left: none;
        }

        .grid-view-custom tbody td:last-child {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
            border-right: none;
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
           PAGE TITLE BUTTONS
        ========================================= */
        .page-title-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .button-group-left {
            display: flex;
            gap: 10px;
        }

        /* Base Button Style */
        .dashboard-btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            text-decoration: none !important;
            color: white !important;
            border: none;
        }

        .dashboard-btn i {
            margin-right: 8px;
            font-size: 1rem;
        }

        .dashboard-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            color: #FFD700 !important;
            text-decoration: none;
        }

        /* Button Colors */
        .btn-create {
            background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
            margin-left: auto;
        }

        .btn-Dashboard {
            background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        }

        .btn-Live {
            background: linear-gradient(135deg, #0f9b0f 0%, #043927 100%);
        }

        .btn-Expire {
            background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
        }

        /* =========================================
           EMPTY STATE
        ========================================= */
        .empty-state-container {
            padding: 40px 15px;
            text-align: center;
            background-color: #ffffff;
            border-radius: 1rem;
            width: 100%;
        }

        .empty-state-icon {
            font-size: 3.5rem;
            color: #eaecf4;
            margin-bottom: 10px;
            animation: float 3s ease-in-out infinite;
        }

        .empty-state-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #4e73df;
            margin-bottom: 10px;
        }

        .empty-state-text {
            font-size: 1rem;
            color: #858796;
            line-height: 1.6;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        /* =========================================
           RESPONSIVE
        ========================================= */
        @media (max-width: 768px) {
            .page-title-buttons {
                flex-direction: column;
                gap: 8px;
            }

            .button-group-left {
                width: 100%;
                justify-content: space-between;
                flex-direction: column;
            }

            .btn-create {
                width: 100%;
                margin-left: 0;
                order: -1;
            }

            .dashboard-btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="page-title-buttons">

        <div class="button-group-left">
            <a href="NoticeDashboard.aspx" class="dashboard-btn btn-Dashboard">
                <i class="fas fa-arrow-left"></i> Notice Dashboard
            </a>

            <a href="LiveNotice.aspx" class="dashboard-btn btn-Live">
                <i class="fas fa-broadcast-tower"></i> Live Notice
            </a>

            <a href="ExpireNotice.aspx" class="dashboard-btn btn-Expire">
                <i class="far fa-calendar-times"></i> Expire Notice
            </a>
        </div>

        <a href="CreateNotice.aspx" class="dashboard-btn btn-create">
            <i class="fas fa-plus-circle"></i> Create Notice
        </a>

    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">

        <div class="row">
            <div class="col-12">
                <asp:Panel ID="Panel1" runat="server" CssClass="alert alert-success" Visible="false">
                    <asp:Label ID="Label1" runat="server"></asp:Label>
                </asp:Panel>
            </div>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border rounded bg-white">
                <div class="empty-state-icon">
                    <i class="bi bi-bell-slash floating-icon"></i>
                </div>
                <h3 class="empty-state-title">No Notices Available</h3>
                <p class="empty-state-text">
                    There are currently no notices available. 
                    Keep residents informed by creating a new notice.
                </p>
                <a href="CreateNotice.aspx" class="dashboard-btn btn-create">
                    <i class="fas fa-plus-circle"></i> Create Notice
                </a>
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
                                    DataKeyNames="Notice_id"
                                    CssClass="table table-striped table-bordered grid-view-custom w-100"
                                    OnRowDataBound="gvDisplay_RowDataBound"
                                    OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged"
                                    GridLines="None">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Title">
                                            <ItemTemplate>
                                                <asp:Label Text='<%# Eval("Title") %>' runat="server" CssClass="fw-bold text-dark"/>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Posted Date">
                                            <ItemTemplate>
                                                <%# Eval("Posted_date", "{0:dd MMM yyyy}") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Expiry Date">
                                            <ItemTemplate>
                                                <%# Eval("Expiry_date", "{0:dd MMM yyyy}") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Importance">
                                            <ItemTemplate>
                                                <asp:Label Text='<%# Eval("Importance") %>' runat="server"
                                                    CssClass='<%# GetImportanceClass(Eval("Importance").ToString()) %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                                                    <%# Eval("Status") %>
                                                </span>
                                            </ItemTemplate>
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