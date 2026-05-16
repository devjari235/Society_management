<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master"
    AutoEventWireup="true" CodeBehind="View_flat.aspx.cs"
    Inherits="Society_management.View_flat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="fontawesome/css/all.css" rel="stylesheet" />

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- DataTables CSS & JS -->
    <link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var $table = $('#<%= gvDisplay.ClientID %>');

            if ($table.length > 0 && $table.find('tbody tr').length > 0) {

                // Create THEAD if not present
                if ($table.find('thead').length === 0) {
                    var $headerRow = $table.find('tr:first');
                    $table.prepend($('<thead></thead>').append($headerRow));
                }

                // Initialize DataTable
                if (!$.fn.DataTable.isDataTable($table)) {
                    $table.DataTable({
                        paging: true,
                        searching: true,
                        ordering: true,
                        info: true,
                        responsive: true,
                        autoWidth: false,
                        pageLength: 10
                    });
                }
            }
        });
    </script>

    <style>
        /* Table Container */
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
        }

        /* Make table header normal (not blue styled) */
        .grid-view-custom thead th {
            background: #ffffff !important;   /* White background */
            color: #212529 !important;        /* Normal dark text */
            border: 1px solid #dee2e6 !important;
            font-weight: 600;
            padding: 12px;
            white-space: nowrap;
        }

        /* Optional: light hover effect on header */
        .grid-view-custom thead th:hover {
            background: #f8f9fa !important;
        }

        .grid-view-custom tbody tr {
            background: #ffffff;
            transition: all 0.3s ease;
        }

        .grid-view-custom tbody tr:hover {
            background: #f8f9fa !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.10);
            cursor: pointer;
        }

        .grid-view-custom td {
            vertical-align: middle;
            padding: 12px;
            border-top: 1px solid #dee2e6 !important;
            border-bottom: 1px solid #dee2e6 !important;
        }

        /* Empty State */
        .empty-state-container {
            padding: 50px 15px;
            text-align: center;
            background: #ffffff;
            border: 1px solid #e3e6f0;
            border-radius: 0.75rem;
            margin: 15px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .empty-state-icon {
            font-size: clamp(3.5rem, 10vw, 5rem);
            color: #eaecf4;
            margin-bottom: 1rem;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        .empty-state-title {
            font-size: clamp(1.25rem, 5vw, 1.75rem);
            font-weight: 700;
            color: #4e73df;
            margin-bottom: 0.75rem;
        }

        .empty-state-text {
            font-size: clamp(0.9rem, 3vw, 1.1rem);
            color: #858796;
            margin-bottom: 2rem;
            max-width: 100%;
            line-height: 1.6;
            padding: 0 10px;
        }

        .btn-create {
            background: #4e73df;
            color: white !important;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none !important;
            transition: all 0.3s ease;
            display: inline-block;
            box-shadow: 0 4px 6px rgba(78,115,223,0.2);
        }

        .btn-create:hover {
            background: #2e59d9;
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(78,115,223,0.3);
        }

        @media (max-width: 576px) {
            .btn-create {
                width: 100%;
                max-width: 280px;
            }

            .empty-state-container {
                border: none;
                padding: 30px 10px;
            }
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
    <div style="text-align:left; margin-bottom:15px;">
        <a href="Flat.aspx" style="text-decoration:none;">
            <asp:Label ID="lblFlat" runat="server"
                CssClass="btn btn-primary shadow-sm">
                <b><i class="bi bi-house-add-fill"></i> Add Flat</b>
            </asp:Label>
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
            <div class="empty-state-container shadow-sm">
                <div class="empty-state-icon">
                    <i class="bi bi-building-dash"></i>
                </div>
                <h3 class="empty-state-title">No Flats Available</h3>
                <p class="empty-state-text">
                    Your society management dashboard is ready. Start by adding a flat.
                </p>
                <a href="Flat.aspx" class="btn-create">
                    <i class="bi bi-plus-lg-circle me-2"></i> Add Your First Flat
                </a>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="row">
                <div class="col-12">
                    <div class="table-responsive shadow-sm rounded bg-white p-2 card border-0">
                        <div class="card-body">
                            <asp:GridView ID="gvDisplay" runat="server"
                                AutoGenerateColumns="False"
                                CssClass="table table-striped table-bordered grid-view-custom"
                                Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="Flat No">
                                        <ItemTemplate><%# Eval("Flate_no") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Owner Name">
                                        <ItemTemplate><%# Eval("Owner_name") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Floor">
                                        <ItemTemplate><%# Eval("Floor") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Flat Type">
                                        <ItemTemplate><%# Eval("Flat_type") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Sqft">
                                        <ItemTemplate><%# Eval("sqft") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Occupancy Status">
                                        <ItemTemplate><%# Eval("Occupancy_status") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Maintenance">
                                        <ItemTemplate><%# Eval("Mentanance") %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Block">
                                        <ItemTemplate><%# Eval("Block_name") %></ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <%-- Remove EmptyDataTemplate from here as we are using pnlEmpty above --%>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>