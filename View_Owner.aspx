<%@ Page Title="View Owners" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Owner.aspx.cs" Inherits="Society_management.View_Owner" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Bootstrap & Styles -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <!-- jQuery and DataTables -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Required CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Required JavaScript (ONLY THESE TWO FILES ARE NEEDED) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            // FIX: Target by ID and check if the table actually contains data rows
            var $table = $('#<%= gvDisplay.ClientID %>');

            // DataTables requires at least one <tr> in <tbody> and a proper <thead>
            // We check if the table exists and if it has more than one row (header + at least one data row)
            if ($table.length > 0 && $table.find('tr').length > 1) {

                // Ensure thead exists: Move the first row to a new thead element if necessary
                if ($table.find('thead').length === 0) {
                    var $headerRow = $table.find('tr:first');
                    var $thead = $('<thead></thead>').append($headerRow);
                    $table.prepend($thead);
                }

                // Initialize DataTables
                if (!$.fn.DataTable.isDataTable($table)) {
                    $table.DataTable({
                        "paging": true,
                        "searching": true,
                        "ordering": true,
                        "responsive": true,
                        "autoWidth": false,
                        "language": {
                            "emptyTable": "No data available in table"
                        }
                    });
                }
            }
        });
    </script>

    <style>
        /* --- Mobile Responsive & Layout Fixes --- */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .grid-view-custom {
            border-collapse: separate;
            border-spacing: 0 8px;
        }

        .grid-view-custom tbody tr {
            background-color: #ffffff;
            transition: all 0.3s ease;
        }

        .grid-view-custom tbody tr:hover {
            background-color: #f8f9fa !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            cursor: pointer;
        }

        /* --- Professional Empty State (Hidden when Table has data) --- */
        .empty-state-container {
            padding: 50px 20px;
            text-align: center;
            background-color: #ffffff;
            border: 1px solid #e3e6f0;
            border-radius: 0.75rem;
            margin: 20px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-sizing: border-box;
            width: 100% !important;
        }

        .empty-state-icon {
            font-size: 4.5rem;
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
            font-size: 1.5rem;
            font-weight: 700;
            color: #4e73df;
            margin-bottom: 0.5rem;
        }

        .empty-state-text {
            font-size: 1rem;
            color: #858796;
            margin-bottom: 2rem;
            max-width: 100%;
            line-height: 1.6;
            overflow-wrap: break-word;
        }

        .btn-create-empty {
            background-color: #4e73df;
            color: white !important;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none !important;
        }

        /* Hide Home/Breadcrumbs if required */
        .breadcrumb { display: none !important; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div style="text-align: left; margin-bottom: 15px;">
        <a href="Owner.aspx" class="btn btn-primary">
            <b><i class="bi bi-person-plus-fill"></i> Add Owner</b>
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                <asp:Panel CssClass="alert alert-success shadow-sm" role="alert" ID="Panel1" runat="server" Visible="false">
                    <asp:Label ID="Label1" runat="server"></asp:Label>
                </asp:Panel>
            </div>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border">
                <div class="empty-state-icon">
                    <i class="bi bi-person-exclamation"></i>
                </div>
                <h3 class="empty-state-title">No Owners Registered</h3>
                <p class="empty-state-text">
                    It looks like there are no owners assigned to flats yet. 
                    Register a new owner to start managing society members.
                </p>
                <a href="Owner.aspx" class="btn-create-empty">
                    <i class="bi bi-person-plus-fill me-2"></i> Add New Owner Now
                </a>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-sm border-0 bg-white">
                        <div class="card-body p-4">
                            <div class="table-responsive">
                                <asp:GridView ID="gvDisplay" runat="server"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="Owner_id"
                                    CssClass="table table-striped table-bordered grid-view-custom w-100"
                                    OnRowDataBound="gvDisplay_RowDataBound"
                                    OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged"
                                    GridLines="None">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Block Name">
                                            <ItemTemplate><%#Eval("Block_name") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Flat Number">
                                            <ItemTemplate><%#Eval("Flate_no") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Owner Name">
                                            <ItemTemplate><b><%#Eval("Owner_name") %></b></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Email">
                                            <ItemTemplate><%#Eval("Email_id") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Contact Number">
                                            <ItemTemplate><%#Eval("Contact_no") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Emergency No">
                                            <ItemTemplate><%#Eval("Emergency_Number") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Members">
                                            <ItemTemplate><%#Eval("Total_member") %></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Allotment Date">
                                            <ItemTemplate><%#Eval("Allotment_Date") %></ItemTemplate>
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