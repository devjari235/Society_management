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
/* Left-aligned button group */
.button-group-left {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
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
    white-space: nowrap;
}

.dashboard-btn i {
    margin-right: 8px;
    font-size: 1rem;
}

.dashboard-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    color: #FFD700;
    text-decoration: none;
}

/* Individual Button Colors */
.btn-Dashboard {
    background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}
.btn-create {
    background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
}
.btn-Live {
    background: linear-gradient(135deg, #0f9b0f 0%, #043927 100%);
}
.btn-Expire {
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .button-group-left {
        flex-direction: column;
        width: 100%;
        gap: 12px;
    }

    .dashboard-btn {
        width: 100%;
        justify-content: center;
        text-align: center;
    }
}
/* --- ICON ANIMATION --- */
    .floating-icon {
        display: inline-block;
        animation: float-up-down 3s ease-in-out infinite;
        font-size: 3.5rem;
    }
    @keyframes float-up-down {
        0% { transform: translateY(0px); }
        50% { transform: translateY(-10px); }
        100% { transform: translateY(0px); }
    }

    /* --- BALANCED EMPTY STATE --- */
    .empty-state-container {
        padding: 60px 20px;
        margin-top: 20px;
        background: #ffffff;
        border-radius: 12px;
        text-align: center;
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
    <div class="container-fluid">
        <asp:Panel ID="Panel1" runat="server" CssClass="alert alert-success shadow-sm" Visible="false">
            <asp:Label ID="Label1" runat="server"></asp:Label>
        </asp:Panel>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border rounded bg-white">
                <div class="empty-state-icon text-center">
                    <i class="bi bi-check-circle-fill floating-icon" style="color: #28a745;"></i>
                </div>
                <h4 style="color: #495057; font-weight: 700; margin-bottom: 8px;">No Resolved Complaints</h4>
                <p style="color: #adb5bd; font-size: 0.95rem; max-width: 380px; margin-bottom: 24px; margin-left: auto; margin-right: auto;">
                    There are no complaints currently marked as 'Resolved'. Check other categories to track active issues.
                </p>
                <div class="text-center">
                    <a href="View_Complaints.aspx" class="dashboard-btn btn-Dashboard">
                        <i class="fas fa-arrow-left me-2"></i> View All Complaints
                    </a>
                </div>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="card shadow-sm border-0 mb-4 mt-3">
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <asp:GridView ID="gvDisplay" runat="server" AutoGenerateColumns="False"
                            DataKeyNames="Complaint_id"
                            CssClass="table table-hover grid-view-custom w-100"
                            OnRowDataBound="gvDisplay_RowDataBound" 
                            OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged"
                            GridLines="None">
                            <Columns>
                                <asp:TemplateField HeaderText="User Name">
                                    <ItemTemplate><b><%# Eval("User_name") %></b></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Complaint type">
                                    <ItemTemplate><%# Eval("Complaint_type") %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Priority">
                                    <ItemTemplate>
                                        <span class="badge bg-light text-dark border"><%# Eval("Priority") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class="status-badge px-3 py-1 text-white" style="background:#6c757d; border-radius:50px; font-size:0.8rem;">
                                            <%# Eval("Status") %>
                                        </span>
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
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
