<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="ExpireNotice.aspx.cs" Inherits="Society_management.ExpireNotice" EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <!-- Bootstrap & Swiper CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap 5 dropdown toggle) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <!-- jQuery (must come first) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Popper.js (required for Bootstrap dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Bootstrap Bundle (includes Popper.js for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        // Use the exact GridView ID instead of '.table'
        var $table = $('#<%= gvDisplay.ClientID %>');

        // Stop if GridView is not found
        if ($table.length === 0) {
            console.log("GridView not found.");
            return;
        }

        // Ensure <thead> exists (required by DataTables)
        if ($table.find('thead').length === 0) {
            var $firstRow = $table.find('tr:first');

            if ($firstRow.length > 0) {
                var $thead = $('<thead></thead>');
                $thead.append($firstRow);
                $table.prepend($thead);
            }
        }

        // Check if actual data rows exist
        var hasData =
            $table.find('tbody tr').length > 0 &&
            $table.find('tbody td').length > 1;

        if (!hasData) {
            console.log("No data rows found. DataTable not initialized.");
            return;
        }

        // Destroy existing instance if already initialized
        if ($.fn.DataTable.isDataTable($table)) {
            $table.DataTable().destroy();
        }

        // Initialize DataTables
        $table.DataTable({
            paging: true,
            lengthChange: true,
            searching: true,
            ordering: true,
            info: true,
            autoWidth: false,
            responsive: true,
            pageLength: 10,
            serverSide: false,
            processing: false,
            dom: 'lfrtip',   // l=length dropdown, f=search box, r=processing, t=table, i=info, p=paging
            language: {
                search: "Search Notices:",
                lengthMenu: "Show _MENU_ entries",
                info: "Showing _START_ to _END_ of _TOTAL_ entries",
                paginate: {
                    previous: "Previous",
                    next: "Next"
                }
            }
        });

        // Clickable row support
        $table.find('tbody').on('click', 'tr.clickable-row', function () {
            var noticeId = $(this).attr('data-notice-id');
            if (noticeId) {
                window.location.href = 'Admin_noticeDetails.aspx?id=' + noticeId;
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
    <%-- <style>
    .card {
        background: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 10px;
        
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        color: #212529;
    }

    .card h5 {
        font-size: 1.3rem;
        font-weight: 600;
        margin-bottom: 10px;
    }

    .card p {
        font-size: 0.95rem;
        line-height: 1.5;
    }

    .card small {
        display: inline-block;
        margin-top: 10px;
        font-size: 0.8rem;
        color: #6c757d;
    }

    .badge {
        font-size: 0.75rem;
        padding: 5px 10px;
        border-radius: 5px;
        font-weight: 500;
    }

    .badge-live {
        background-color: #198754;
        color: white;
    }

    .badge-expired {
        background-color: #dc3545;
        color: white;
    }

    .mb-3 {
        margin-bottom: 1.5rem !important;
    }

    .border-danger {
        border-left: 5px solid #dc3545;
    }

</style>--%>

        <style>
 /* Page Title Buttons Container */
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

/* Individual Button Colors */
.btn-create {
    background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
    margin-left: auto; /* Pushes Create button to the right */
}

.btn-Dashboard {
     background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}

.btn-Live {
    background: linear-gradient(135deg, #0f9b0f 0%, #043927 100%);
}
.btn-All {
    background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
}

/* Hover Effects */
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
.notice-scroller-container {
        max-height: 600px; /* Adjust height as needed */
        overflow-y: auto;
        padding-right: 10px; /* Prevents content from touching scrollbar */
    }

    /* Custom scrollbar styling */
    .notice-scroller-container::-webkit-scrollbar {
        width: 8px;
    }

    .notice-scroller-container::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    .notice-scroller-container::-webkit-scrollbar-thumb {
        background: #888;
        border-radius: 10px;
    }

    .notice-scroller-container::-webkit-scrollbar-thumb:hover {
        background: #555;
    }

    /* Adjust card spacing for scroller */
    .swiper-slide {
        margin-bottom: 20px;
    }

    /* Remove any fixed heights from cards if they exist */
    .notice-card {
        height: auto !important;
    }
    /* Clean up the card and table look */
.card {
    border-radius: 12px;
    background-color: #fff;
}

/* Remove default DataTables border that clashes with card */
#<%= gvDisplay.ClientID %> {
    border: none !important;
}

/* Ensure header looks clean */
.grid-view-custom thead th {
    background-color: #f8f9fa;
    border-top: none;
    border-bottom: 1px solid #eee;
    color: #6c757d;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

/* Pagination and Search alignment */
.dataTables_wrapper .dataTables_filter {
    margin-bottom: 20px;
}

.dataTables_wrapper .dataTables_info, 
.dataTables_wrapper .dataTables_paginate {
    margin-top: 20px;
}
.floating-icon {
    animation: float-up-down 3s ease-in-out infinite;
}

@keyframes float-up-down {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
    100% { transform: translateY(0px); }
}

.empty-state-container {
    padding: 60px 20px;
    margin-top: 20px;
    background: #ffffff;
    border-radius: 12px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
}
/* --- MOBILE RESPONSIVE (768px) --- */
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
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
     <div class="page-title-buttons">
     <div class="button-group-left">
         <a href="NoticeDashboard.aspx" class="dashboard-btn btn-Dashboard">
             <i class="fas fa-arrow-left"></i>Notice Dashboard
         </a>
         <a href="View_Allnotice.aspx" class="dashboard-btn btn-All">
            <i class="fas fa-clipboard-list"></i> All Notice
        </a>
         <a href="LiveNotice.aspx" class="dashboard-btn btn-Live">
             <i class="fas fa-broadcast-tower"></i> Live Notice
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
                <asp:Panel CssClass="alert alert-success shadow-sm" role="alert" ID="Panel1" runat="server" Visible="false">
                    <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                </asp:Panel>
            </div>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border rounded bg-white">
                <div class="empty-state-icon text-center">
                    <i class="far fa-calendar-times floating-icon" style="font-size: 3.5rem; color: #cbd5e1; display: inline-block;"></i>
                </div>
                <h4 style="color: #495057; font-weight: 700; margin-bottom: 8px;">No Expired Notices</h4>
                <p style="color: #adb5bd; font-size: 0.95rem; max-width: 380px; margin-bottom: 24px; margin-left: auto; margin-right: auto;">
                    There are currently no expired notices in your records. All notices are either active or haven't been created yet.
                </p>
                <div class="text-center">
                    <a href="LiveNotice.aspx" class="dashboard-btn btn-Live">
                        <i class="fas fa-broadcast-tower"></i> Live Notice
                    </a>
                </div>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="card shadow-sm border-0 mb-4 mt-3">
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <asp:GridView ID="gvDisplay" runat="server"
                            AutoGenerateColumns="False"
                            DataKeyNames="Notice_id"
                            CssClass="table table-hover grid-view-custom w-100" 
                            OnRowDataBound="gvDisplay_RowDataBound" 
                            OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged"
                            GridLines="None">
                            <Columns>
                                <asp:TemplateField HeaderText="Title">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Title") %>' runat="server" CssClass="fw-bold text-dark" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Posted Date">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Posted_date", "{0:dd MMM yyyy}") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Expiry Date">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Expiry_date", "{0:dd MMM yyyy}") %>' runat="server" />
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
        </asp:PlaceHolder>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>