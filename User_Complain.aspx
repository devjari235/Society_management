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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
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
    <br />
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="table-responsive">
 <asp:GridView ID="gvDisplay" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="Complaint_id"
    CssClass="table table-striped table-bordered grid-view-custom"
    OnRowDataBound="gvDisplay_RowDataBound" 
    OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged">
    <Columns>
    <asp:TemplateField HeaderText="Complaint type">
        <ItemTemplate>
            <asp:Label Text='<%# Eval("Complaint_type") %>' runat="server" />
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
</div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
