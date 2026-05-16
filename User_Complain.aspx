<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_Complain.aspx.cs" Inherits="Society_management.User_Complain" EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap 5 dropdown toggle) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap Bundle (includes Popper.js for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Add DataTables CSS & JS in your HeadContent -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
            <!-- jQuery (must come first) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Popper.js (required for Bootstrap dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        var $table = $('.table');

        // Ensure thead exists
        if ($table.find('thead').length === 0) {
            var $thead = $('<thead></thead>').append($table.find('tr:first'));
            $table.prepend($thead);
        }

        // Initialize only if not already done
        if (!$.fn.DataTable.isDataTable($table)) {
            $table.DataTable({
                "paging": true,
                "lengthChange": true,
                "searching": true,
                "ordering": true,
                "info": true,
                "autoWidth": false,
                "responsive": true,
                "serverSide": false,
                "processing": false
            });
        }


        // Row click handler
        $table.find('tbody').on('click', 'tr.clickable-row', function () {
            var ComplainId = $(this).attr('data-Complain-Id');
            if (noticeId) {
                window.location.href = 'User_Complaint_Details.aspx?id=' + ComplainId;
            }
        });
    });
</script>
        <style>
/* GridView Button-Row Style */
.grid-view-custom {
    border-collapse: separate;
    border-spacing: 0 8px; /* Adds spacing between rows */
}

.grid-view-custom tbody tr {
    background-color: #ffffff;
    border: 1px solid #dee2e6;
    border-radius: 8px; /* Rounded corners */
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

/* Button-like hover effect */
.grid-view-custom tbody tr:hover {
    background-color: #f8f9fa !important;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    cursor: pointer;
}

/* Active/Selected row */
.grid-view-custom tbody tr:active,
.grid-view-custom tbody tr.highlight {
    background-color: #e9ecef !important;
    transform: translateY(0);
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

/* Cell styling for button effect */
.grid-view-custom tbody td {
    padding: 12px 15px;
    border-top: none !important;
    border-bottom: none !important;
}

/* First and last cell rounded corners */
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

/* Status Badge with Black Background */
.status-badge {
    border-radius: 50px;
    text-transform: uppercase;
}

/* Header Styling */
.grid-view-custom thead th {
    background-color: transparent;
    color: #495057;
    font-weight: 600;
    border-bottom: 2px solid #dee2e6;
    padding: 12px 15px;
}

    </style>
    <style>
        .status-Pending {
    color: #ff9800;
    font-weight: bold;
}

.status-Active {
    color: #4caf50;
    font-weight: bold;
}

.status-InProgress {
    color: #2196f3;
    font-weight: bold;
}

.status-Resolved {
    color: #9e9e9e;
    font-weight: bold;
}
        /* Priority Colors */
.priority-Low {
    color: #28a745; /* Green */
    font-weight: bold;
}

.priority-Medium {
    color: #ffc107; /* Yellow */
    font-weight: bold;
}

.priority-High {
    color: #fd7e14; /* Orange */
    font-weight: bold;
}

.priority-Emergency {
    color: #dc3545; /* Red */
    font-weight: bold;
    animation: blink 1s infinite;
}

@keyframes blink {
    0% { opacity: 1; }
    50% { opacity: 0.5; }
    100% { opacity: 1; }
}
    </style>
       <style>
           .btn-create-notice {
            background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            text-decoration:none;
        }
        
        .btn-create-notice:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            color: #FFD700;
            background: linear-gradient(135deg, #9d3df1 0%, #5b1ae6 100%);
            text-decoration:none;
        }
        
        .btn-create-notice i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        .create-notice-container{
    display: flex; 
    justify-content: flex-end;
}
        /* =========================================
   EMPTY STATE COMPONENT 
========================================= */
.empty-state-container {
    padding: 60px 20px;
    text-align: center;
    background-color: #ffffff;
    border-radius: 1rem;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 6rem rgba(0,0,0,0.05);
    margin-top: 15px;
}

.empty-state-icon {
    font-size: 4rem;
    color: #8E2DE2;
    opacity: 0.2;
    margin-bottom: 1.5rem;
    display: inline-block;
    animation: float 3s ease-in-out infinite;
}

@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
    100% { transform: translateY(0px); }
}

.empty-state-title {
    color: #1e293b;
    font-weight: 700;
    margin-bottom: 10px;
}
       </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
        <div class="create-notice-container">
            <a href="Complaint.aspx" class="btn-create-notice">
                <i class="fas fa-plus-circle"></i> New Complain
            </a>
        </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-sm-12 col-md-12">
                <asp:Panel CssClass="alert alert-success" role="alert" ID="Panel1" runat="server" Visible="false">
                    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
                </asp:Panel>
            </div>
        </div>

        <%-- ── Empty State Panel ── --%>
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container">
                <div class="empty-state-icon">
                    <i class="fas fa-inbox"></i>
                </div>
                <h3 class="empty-state-title">No Complaints Filed</h3>
                <p class="text-muted mb-0">
                    Have an issue with society maintenance or services? Click <b>'New Complaint'</b> above to report it directly to the admin team for a quick resolution.
                </p>
            </div>
        </asp:Panel>

        <%-- ── Data Content Placeholder Wrapper ── --%>
        <asp:PlaceHolder ID="phDataContent" runat="server">
            <br />
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="table-responsive">
                        <asp:GridView ID="gvDisplay" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="Complaint_id"
                            CssClass="table table-striped table-bordered grid-view-custom w-100"
                            OnRowDataBound="gvDisplay_RowDataBound" 
                            OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged">
                            <Columns>
                                <asp:TemplateField HeaderText="Complaint type">
                                    <ItemTemplate>
                                        <b><asp:Label Text='<%# Eval("Complaint_type") %>' runat="server" /></b>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Priority">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPriority" Text='<%# Eval("Priority") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatus" Text='<%# Eval("Status") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Submit on">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Create_date", "{0:dd MMM yyyy}") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>    
                                <asp:TemplateField HeaderText="Resolved on">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Resolve_date", "{0:dd MMM yyyy}") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
