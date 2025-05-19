<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Resolved_Complaints.aspx.cs" Inherits="Society_management.Resolved_Complaints" EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
                        <!-- Bootstrap & Swiper CSS -->
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
                window.location.href = 'Complaint_Details.aspx?id=' + ComplainId;
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
.btn-Dashboard {
     background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}
.btn-create {
    background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
}
.btn-Live {
    background: linear-gradient(135deg, #0f9b0f 0%, #043927 100%);
}
.btn-Dashboard {
    background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}
.btn-Expire{
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
}
.page-title-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    flex-wrap: wrap;
    
}

/* Left-aligned button group */
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
    text-decoration: none;
    color: white;
    border: none;
}

.dashboard-btn i {
    margin-right: 8px;
    font-size: 1rem;
}
.dashboard-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    color: #FFD700;
    text-decoration:none;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .page-title-buttons {
        flex-direction: column;
        gap: 8px;
    }
    
    .button-group-left {
        width: 100%;
        justify-content: space-between;
    }
    
    .btn-create {
        width: 100%;
        margin-left: 0;
        order: -1; /* Moves Create button to top on mobile */
    }
    
    .dashboard-btn {
        width: 100%;
        text-align: center;
        justify-content: center;
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
          <div class="button-group-left">
      <a href="View_Complaints.aspx" class="dashboard-btn btn-Dashboard">
          <i class="fas fa-arrow-left"></i> Back to Details
      </a>
          <a href="Pending_Complaints.aspx" class="dashboard-btn btn-Live">
              <i class="bi-hourglass-split "></i>Pending Complaints
          </a>
      <a href="Progress_Complaints.aspx" class="dashboard-btn btn-Expire">
          <i class="bi-gear-fill"></i> In Progress Complaints
      </a>
          <a href="Active_Complaints.aspx" class="dashboard-btn btn-create">
       <i class="bi-check-circle"></i> Active Complaints
  </a>
</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
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
    <asp:TemplateField HeaderText="User Name">
        <ItemTemplate>
            <asp:Label Text='<%# Eval("User_name") %>' runat="server" />
        </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Complaint type">
        <ItemTemplate>
            <asp:Label Text='<%# Eval("Complaint_type") %>' runat="server" />
        </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Priority">
        <ItemTemplate>
            <asp:Label Text='<%# Eval("Priority") %>' runat="server" />
        </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Status">
        <ItemTemplate>
             <asp:Label Text='<%# Eval("Status") %>' runat="server" />
        </ItemTemplate>
    </asp:TemplateField>
</Columns>
</asp:GridView>
            </div>

        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
