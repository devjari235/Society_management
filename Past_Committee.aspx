<%@ Page Title="Past Committee Members" Language="C#" MasterPageFile="~/Adashboard.Master"
    AutoEventWireup="true" CodeBehind="Past_Committee.aspx.cs"
    Inherits="Society_management.Past_Committee"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

 <!-- DataTables CSS ONLY -->
    <link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet" />

    <!-- DataTables JS ONLY -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var $table = $('.table');

            // Ensure THEAD exists
            if ($table.find('thead').length === 0) {
                var $thead = $('<thead></thead>').append($table.find('tr:first'));
                $table.prepend($thead);
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
                    processing: false
                });
            }

            // Row click handler
            $table.find('tbody').on('click', 'tr.clickable-row', function () {
                var Committee_id = $(this).attr('data-Committee-id');
                if (Committee_id) {
                    window.location.href = 'Committee_Details.aspx?id=' + Committee_id;
                }
            });
        });
    </script>

    <style>
        /* Hide breadcrumb */
        .breadcrumb {
            display: none !important;
        }

        /* Table Responsive */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border: none !important;
            width: 100%;
        }

        /* GridView Style */
        .grid-view-custom {
            border-collapse: separate;
            border-spacing: 0 8px;
            margin-bottom: 0;
            width: 100%;
        }

        /* Table Rows */
        .grid-view-custom tbody tr {
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        /* Hover Effect */
        .grid-view-custom tbody tr:hover {
            background-color: #f8f9fa !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            cursor: pointer;
        }

        /* Active Row */
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

        /* Rounded Corners */
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

        /* DataTables Controls */
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            margin-top: 10px;
            margin-bottom: 10px;
        }

        /* Search Box */
        .dataTables_wrapper .dataTables_filter input {
            margin-left: 0.5em;
            border: 1px solid #ced4da;
            border-radius: 6px;
            padding: 4px 8px;
        }

        /* Entries Dropdown */
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #ced4da;
            border-radius: 6px;
            padding: 4px 8px;
            margin: 0 5px;
        }

        /* Page Title Buttons */
        .page-title-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        /* =========================================
           UPDATED BUTTONS (GRADIENT STYLE)
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

        .dashboard-btn i {
            margin-right: 8px;
            font-size: 1rem;
        }

        /* Purple/Blue Gradient */
        .btn-create {
            background: #4e73df;
            margin-left: auto;
        }

        /* Gray/Dark Slate Gradient */
        .btn-Dashboard {
            background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        }

        .dashboard-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        /* Empty State */
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

        /* Responsive */
        @media (max-width: 768px) {
            .page-title-buttons {
                flex-direction: column;
                gap: 8px;
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
        <a href="View_CommiteeMember.aspx" class="dashboard-btn btn-Dashboard">
            <i class="fas fa-arrow-left"></i> Back to Current
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
                    <i class="bi bi-clock-history"></i>
                </div>
                <h3 class="empty-state-title">No Past Records</h3>
                <p class="empty-state-text">
                    There are no past committee terms recorded. 
                    Historical data appears here automatically once active terms conclude.
                </p>
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
                                        <asp:TemplateField HeaderText="Past Committee Member">
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