<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="LiveNotice.aspx.cs" Inherits="Society_management.LiveNotice"  EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Bootstrap & Swiper CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap 5 dropdown toggle) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap Bundle (includes Popper.js for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            var noticeId = $(this).attr('data-notice-id');
            if (noticeId) {
                window.location.href = 'Admin_noticeDetails.aspx?id=' + noticeId;
            }
        });
    });
</script>

    <style>
        /* Card and Wrapper styling */
.card {
    border-radius: 12px;
    background-color: #ffffff;
}

/* DataTables Control Styling (Search/Entries) */
.dataTables_wrapper .dataTables_filter, 
.dataTables_wrapper .dataTables_length {
    margin-bottom: 15px;
    font-weight: 500;
}

/* Ensure the table header looks modern */
.grid-view-custom thead th {
    background-color: #f8f9fa !important;
    border-bottom: 1px solid #dee2e6 !important;
    text-transform: none;
    color: #495057;
    padding: 15px !important;
}

/* Table border removal inside card */
.grid-view-custom {
    border: none !important;
}
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

  <%--  <style>
        body {
            background-color: #f4f4f4;
            font-family: 'Segoe UI', sans-serif;
        }

        .container-title {
            text-align: center;
            margin-top: 40px;
            margin-bottom: 20px;
        }

        /* Outer wrapper prevents overflow of slides */
        .swiper-container-wrapper {
            width: 100%;
            display: flex;
            justify-content: center;
            position: relative;
            padding: 0 60px; /* spacing for arrows */
        }

        .swiper {
            width: 100%;
            max-width: 900px;
            overflow: hidden; /* Hide next/prev cards */
        }

        .swiper-slide {
            background: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            color: #212529;
            height: auto;
        }

        .notice-title {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .badge {
            font-size: 0.8rem;
        }

        .text-muted {
            font-size: 0.85rem;
        }

        .swiper-pagination {
            text-align: center;
            margin-top: 20px;
        }

        .swiper-pagination-bullet {
            background: #adb5bd;
            opacity: 1;
            margin: 0 4px;
            padding: 5px 10px;
            border-radius: 6px;
        }

        .swiper-pagination-bullet-active {
            background: #0d6efd;
            color: #fff;
        }

        .swiper-button-next,
        .swiper-button-prev {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            color: #0d6efd;
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .swiper-button-next {
            right: 8.5%;
        }

        .swiper-button-prev {
            left: 8.5%;
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

.btn-All {
    background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
}
.btn-Expire{
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
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
/* --- UNIVERSAL BUTTON SIZING --- */
.dashboard-btn, 
.dashboard-btn-pill, 
.btn-create, 
.btn-Dashboard, 
.btn-Live, 
.btn-Expire, 
.btn-All {
    /* Exact Sizing */
    display: inline-flex !important;
    align-items: center;
    justify-content: center;
    height: 48px;            /* Fixed height for all buttons */
    min-width: 160px;        /* Consistent minimum width */
    padding: 0 20px !important;
    font-size: 0.9rem !important;
    border-radius: 8px !important; /* Uniform corners */
    box-sizing: border-box;
}

/* --- MOBILE RESPONSIVE (768px) --- */
@media (max-width: 768px) {
  /* --- UNIVERSAL BUTTON SIZING (Desktop & General) --- */
.dashboard-btn, 
.btn-create, 
.btn-Dashboard, 
.btn-All, 
.btn-Expire {
    display: inline-flex !important;
    align-items: center;
    justify-content: center;
    height: 48px;             /* Fixed uniform height */
    min-width: 180px;         /* Consistent minimum width for desktop */
    padding: 0 20px !important;
    font-size: 0.95rem !important;
    border-radius: 8px !important; 
    box-sizing: border-box;
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
}
/* --- ICON UP-DOWN ANIMATION --- */
.floating-icon {
    display: inline-block;
    animation: float-up-down 3s ease-in-out infinite;
}

@keyframes float-up-down {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-15px); }
    100% { transform: translateY(0px); }
}
/* --- BALANCED EMPTY STATE --- */
.empty-state-container {
    padding: 60px 20px; /* Reduced from 100px to 60px for a natural look */
    margin: 20px 0;
    background: #ffffff;
    border-radius: 12px;
    border: 1px solid #dee2e6; /* Standard Bootstrap border color */
    box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /* Match Bootstrap shadow-sm */
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    /* Removed min-height so it wraps the content naturally */
}

.empty-state-icon {
    font-size: 3.5rem; /* Standard dashboard icon size */
    color: #eaecf4;
    margin-bottom: 15px;
}

.empty-state-title {
    font-size: 1.5rem; /* Balanced heading size */
    font-weight: 700;
    color: #4e73df;
    margin-bottom: 8px;
}

.empty-state-text {
    font-size: 0.95rem;
    color: #858796;
    max-width: 400px;
    line-height: 1.5;
    margin-bottom: 20px;
}

/* Floating Animation */
.floating-icon {
    display: inline-block;
    animation: float-up-down 3s ease-in-out infinite;
}

@keyframes float-up-down {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); } /* Subtle 10px movement */
    100% { transform: translateY(0px); }
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
                <asp:Panel CssClass="alert alert-success shadow-sm" role="alert" ID="Panel1" runat="server" Visible="false">
                    <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                </asp:Panel>
            </div>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border rounded bg-white">
                <div class="empty-state-icon text-center">
                    <i class="fas fa-clipboard-list floating-icon" style="font-size: 3rem; color: #adb5bd; display: inline-block;"></i>
                </div>
                <h4 style="color: #495057; font-weight: 700; margin-bottom: 8px;">No Notices Available</h4>
                <p style="color: #adb5bd; font-size: 0.95rem; max-width: 320px; margin-bottom: 24px; margin-left: auto; margin-right: auto;">
                    There are currently no active notices to display. Keep residents informed by creating a new notice.
                </p>
                <div class="text-center">
                    <a href="CreateNotice.aspx" style="padding: 10px 28px; background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%); color: #fff; border-radius: 8px; font-weight: 600; font-size: 0.9rem; text-decoration: none; box-shadow: 0 4px 12px rgba(142,45,226,0.3); display: inline-flex; align-items: center; gap: 8px;">
                        <i class="fas fa-plus-circle"></i> Create Notice
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

</asp:Content>