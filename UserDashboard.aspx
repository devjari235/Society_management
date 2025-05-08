<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="Society_management.UserDashboard" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .quick-action-card {
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
        }
        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stat-card {
            border-left: 4px solid #0d6efd;
        }
        .stat-card.payments {
            border-left-color: #28a745;
        }
        .stat-card.complaints {
            border-left-color: #dc3545;
        }
        .stat-card.notices {
            border-left-color: #ffc107;
        }
        .recent-activity-item {
            border-left: 3px solid #0d6efd;
            padding-left: 15px;
            margin-bottom: 15px;
        }
        .recent-activity-item.complaint {
            border-left-color: #dc3545;
        }
        .recent-activity-item.payment {
            border-left-color: #28a745;
        }
        .recent-activity-item.notice {
            border-left-color: #ffc107;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
   
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
       <h1 class="h2">Dashboard</h1>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
       <button class="btn btn-sm btn-outline-secondary" onclick="window.print()">
        <i class="fas fa-print"></i> Print
    </button>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <%--!-- Stats Cards Row -->--%>
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card stat-card">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <h6 class="stat-label">Maintenance Due</h6>
                            <h3 class="stat-value text-primary">
                                <asp:Label ID="lblMaintenanceDue" runat="server" Text="₹2,500" />
                            </h3>
                            <small class="text-muted">Due on: <asp:Label ID="lblDueDate" runat="server" Text="15 Oct 2023" /></small>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-rupee-sign fa-2x text-primary"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card stat-card payments">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <h6 class="stat-label">Pending Payments</h6>
                            <h3 class="stat-value text-success">
                                <asp:Label ID="lblPendingPayments" runat="server" Text="2" />
                            </h3>
                            <small class="text-muted">
                                <asp:HyperLink ID="lnkPayNow" runat="server" NavigateUrl="~/MyPayments.aspx" CssClass="text-success">Pay Now</asp:HyperLink>
                            </small>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-credit-card fa-2x text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card stat-card complaints">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <h6 class="stat-label">Open Complaints</h6>
                            <h3 class="stat-value text-danger">
                                <asp:Label ID="lblOpenComplaints" runat="server" Text="3" />
                            </h3>
                            <small class="text-muted">
                                <asp:HyperLink ID="lnkViewComplaints" runat="server" NavigateUrl="~/MyComplaints.aspx" CssClass="text-danger">View All</asp:HyperLink>
                            </small>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-circle fa-2x text-danger"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card stat-card notices">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <h6 class="stat-label">New Notices</h6>
                            <h3 class="stat-value text-warning">
                                <asp:Label ID="lblNewNotices" runat="server" Text="5" />
                            </h3>
                            <small class="text-muted">
                                <asp:HyperLink ID="lnkViewNotices" runat="server" NavigateUrl="~/NoticeBoard.aspx" CssClass="text-warning">View All</asp:HyperLink>
                            </small>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-bullhorn fa-2x text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Quick Actions Row -->
    <div class="row mb-4">
        <div class="col-12 mb-3">
            <h5 class="mb-3">Quick Actions</h5>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card quick-action-card text-center" onclick="location.href='NewComplaint.aspx';">
                <div class="card-body">
                    <i class="fas fa-plus-circle fa-3x text-primary mb-3"></i>
                    <h5>New Complaint</h5>
                    <p class="text-muted small">Register a new complaint or request</p>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card quick-action-card text-center" onclick="location.href='MakePayment.aspx';">
                <div class="card-body">
                    <i class="fas fa-rupee-sign fa-3x text-success mb-3"></i>
                    <h5>Make Payment</h5>
                    <p class="text-muted small">Pay maintenance or other bills</p>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card quick-action-card text-center" onclick="location.href='AddVisitor.aspx';">
                <div class="card-body">
                    <i class="fas fa-user-plus fa-3x text-info mb-3"></i>
                    <h5>Add Visitor</h5>
                    <p class="text-muted small">Register a visitor entry</p>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card quick-action-card text-center" onclick="location.href='AddVehicle.aspx';">
                <div class="card-body">
                    <i class="fas fa-car fa-3x text-secondary mb-3"></i>
                    <h5>Add Vehicle</h5>
                    <p class="text-muted small">Register your vehicle</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Recent Activity and Notices Row -->
    <div class="row">
        <!-- Recent Activity Column -->
        <div class="col-md-8 mb-4">
            <div class="card">
                <div class="card-header">
                    <h6 class="mb-0">Recent Activity</h6>
                </div>
                <div class="card-body">
                    <asp:Repeater ID="rptRecentActivity" runat="server">
                        <ItemTemplate>
                            <div class="recent-activity-item <%# Eval("ActivityClass") %>">
                                <div class="d-flex justify-content-between">
                                    <strong><%# Eval("Title") %></strong>
                                    <small class="text-muted"><%# Eval("Date") %></small>
                                </div>
                                <p class="mb-1"><%# Eval("Description") %></p>
                                <small><a href="<%# Eval("Link") %>" class="text-muted">View details</a></small>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoActivity" runat="server" Visible="false" CssClass="text-center py-3">
                        <i class="fas fa-info-circle fa-2x text-muted mb-2"></i>
                        <p class="text-muted">No recent activity found</p>
                    </asp:Panel>
                    
                    <div class="text-end mt-3">
                        <asp:HyperLink ID="lnkViewAllActivity" runat="server" NavigateUrl="~/ActivityLog.aspx" CssClass="btn btn-sm btn-outline-primary">
                            View All Activity
                        </asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Important Notices Column -->
        <div class="col-md-4 mb-4">
            <div class="card">
                <div class="card-header bg-warning text-white">
                    <h6 class="mb-0">Important Notices</h6>
                </div>
                <div class="card-body">
                    <asp:Repeater ID="rptImportantNotices" runat="server">
                        <ItemTemplate>
                            <div class="mb-3 pb-2 border-bottom">
                                <h6><%# Eval("Title") %></h6>
                                <p class="small"><%# Eval("Summary") %></p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted"><%# Eval("Date") %></small>
                                    <asp:HyperLink ID="lnkReadMore" runat="server" NavigateUrl='<%# Eval("Link") %>' CssClass="btn btn-sm btn-outline-warning">
                                        Read More
                                    </asp:HyperLink>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoNotices" runat="server" Visible="false" CssClass="text-center py-3">
                        <i class="fas fa-info-circle fa-2x text-muted mb-2"></i>
                        <p class="text-muted">No important notices</p>
                    </asp:Panel>
                    
                    <div class="text-end mt-3">
                        <asp:HyperLink ID="lnkViewAllNotices" runat="server" NavigateUrl="~/NoticeBoard.aspx" CssClass="btn btn-sm btn-outline-warning">
                            View All Notices
                        </asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Toast Container for Notifications -->
    <div id="toastContainer" style="position: fixed; top: 20px; right: 20px; z-index: 9999"></div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
     <script>
        $(document).ready(function () {
            // Initialize any dashboard-specific JavaScript here
            
            // Example: Make quick action cards clickable
            $('.quick-action-card').click(function() {
                window.location = $(this).attr('onclick').match(/location\.href='([^']+)'/)[1];
            }).css('cursor', 'pointer');
            
            // Load any dashboard data via AJAX if needed
            loadDashboardData();
        });
        
        function loadDashboardData() {
            // You can implement AJAX calls here to refresh dashboard data
            // Example:
            /*
            $.ajax({
                url: 'DashboardService.asmx/GetDashboardStats',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    // Update dashboard elements with new data
                },
                error: function(xhr, status, error) {
                    showToast('danger', 'Error loading dashboard data');
                }
            });
            */
        }
     </script>
</asp:Content>
