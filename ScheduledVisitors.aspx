<%@ Page Title="Scheduled Visitors" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="ScheduledVisitors.aspx.cs" Inherits="Society_management.ScheduledVisitors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- DataTables -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <style>
        /* --- HIDE THE PERSISTENT HOME LINK (BREADCRUMB) --- */
        .breadcrumb, .breadcrumb-item, #breadcrumb {
            display: none !important;
        }

        /* --- PROFESSIONAL SLATE LAYOUT --- */
        :root {
            --slate-200: #e2e8f0;
            --slate-700: #334155;
            --slate-800: #1e293b;
        }

        /* --- BUTTONS --- */
        .btn-Dashboard { background: linear-gradient(135deg, #0575E6 0%, #021B79 100%); }
        .btn-create { background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%); }

        .dashboard-btn, .dashboard-btn-card {
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none !important;
            color: white !important;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            white-space: nowrap;
            border: none;
        }

        .dashboard-btn:hover {
            transform: scale(1.05) translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
            color: #FFD700 !important;
        }

        /* --- TABLE STYLING WITH VISIBLE VERTICAL LINES --- */
        .table-responsive {
            width: 100% !important;
            display: block !important; 
            overflow-x: auto !important; 
            background: white;
            padding: 15px;
        }

        .grid-view-custom {
            width: 100% !important;
            min-width: 900px; 
            border-collapse: collapse !important; /* Forces lines to connect */
            margin-bottom: 0 !important;
            border: 1px solid #dee2e6 !important;
        }

        /* Header Color & Visible Borders */
        .grid-view-custom thead th {
            background-color: #f1f5f9 !important; 
            color: #475569 !important; 
            border: 1px solid #dee2e6 !important; /* Visible vertical lines */
            padding: 12px;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
            text-align: center;
        }

        /* Body Visible Vertical Lines */
        .grid-view-custom tbody td {
            border: 1px solid #dee2e6 !important; /* Ensures vertical lines appear */
            padding: 12px;
            vertical-align: middle;
            background-color: #ffffff;
        }

        .grid-view-custom tbody tr:hover {
            background-color: #f8f9fa !important;
        }

        .page-title-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 1.5rem;
            padding: 0 15px;
        }

        .desktop-heading {
            color: var(--slate-800);
            font-weight: 700;
            margin: 0;
        }

        @media (max-width: 576px) {
            .dashboard-btn { padding: 8px 12px; font-size: 0.75rem; }
        }
        /* --- ICON UP-DOWN ANIMATION --- */
.floating-icon {
    animation: float-up-down 3s ease-in-out infinite;
}

@keyframes float-up-down {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-15px); }
    100% { transform: translateY(0px); }
}

/* Ensure empty state is properly centered and white */
.empty-state-container {
    padding: 80px 20px;
    margin-top: 20px;
    background: #ffffff;
    border-radius: 12px;
}

/* Fix GridView double border inside card */
.grid-view-custom {
    border: none !important;
    border-collapse: collapse !important;
}
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            var $table = $('#<%= gvScheduledVisitors.ClientID %>');
            if ($table.length > 0 && $table.find('tbody tr').length > 0) {
                if ($table.find('thead').length === 0) {
                    var $headerRow = $table.find('tr:first');
                    $table.prepend($('<thead></thead>').append($headerRow));
                }
                if (!$.fn.DataTable.isDataTable($table)) {
                    $table.DataTable({
                        "paging": true,
                        "searching": true,
                        "ordering": true,
                        "autoWidth": false
                    });
                }
            }
        });

        function showToast(message, type) {
            var toastEl = document.getElementById("customToast");
            document.getElementById("toastMessage").innerText = message;
            toastEl.className = "toast align-items-center text-white border-0 bg-" + type;
            bootstrap.Toast.getOrCreateInstance(toastEl).show();
        }
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="page-title-buttons">
        <a href="VisitorApproval.aspx" class="dashboard-btn btn-Dashboard">
            <i class="fas fa-arrow-left me-2"></i>Back
        </a>
        
        <h2 class="h4 desktop-heading d-none d-sm-block">Scheduled Visitors</h2>
        
        <a href="VisitorEntry.aspx" class="dashboard-btn btn-create">
            <i class="fas fa-plus-circle me-2"></i>New Entry
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border rounded bg-white">
                <div class="empty-state-icon text-center">
                    <i class="bi bi-calendar-x floating-icon" style="font-size: 4rem; color: #cbd5e1; display: inline-block;"></i>
                </div>
                <h3 class="fw-bold text-center" style="color: #475569;">No Scheduled Visitors</h3>
                <p class="text-muted text-center mb-4">No upcoming pre-authorized visits recorded.</p>
                <div class="text-center">
                    <a href="VisitorEntry.aspx" class="dashboard-btn btn-create">
                        <i class="fas fa-plus-circle me-2"></i>New Entry
                    </a>
                </div>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="card shadow-sm border-0 bg-white">
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <asp:GridView ID="gvScheduledVisitors" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-hover grid-view-custom mb-0 w-100"
                            OnRowCommand="gvScheduledVisitors_RowCommand"
                            OnRowDataBound="gvScheduledVisitors_RowDataBound"
                            DataKeyNames="ScheduleID,IsCompleted" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="VisitorName" HeaderText="Visitor Name" />
                                <asp:BoundField DataField="ContactNumber" HeaderText="Contact" />
                                <asp:BoundField DataField="ScheduledDateTime" HeaderText="Scheduled Time" DataFormatString="{0:g}" />
                                <asp:BoundField DataField="Purpose" HeaderText="Purpose" />
                                <asp:BoundField DataField="User_name" HeaderText="Meeting With" />
                                <asp:TemplateField HeaderText="Actions" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <div class="d-flex gap-2 justify-content-center">
                                            <asp:Button ID="btnCheckIn" runat="server" Text="In" CommandName="CheckIn"
                                                CommandArgument='<%# Eval("ScheduleID") %>' CssClass="btn btn-success btn-sm px-3" />
                                            <asp:Button ID="btnCheckOut" runat="server" Text="Out" CommandName="CheckOut"
                                                CommandArgument='<%# Eval("ScheduleID") %>' CssClass="btn btn-warning btn-sm px-3" />
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </asp:PlaceHolder>
    </div>

    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100">
        <div id="customToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body" id="toastMessage"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>