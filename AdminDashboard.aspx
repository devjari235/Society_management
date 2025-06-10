<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="Society_management.AdminDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style type="text/css">
        .dashboard-card {
            transition: all 0.3s ease;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            border: none;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: #fff;
            opacity: 0.8;
        }
        .card-title {
            color: #fff;
            font-size: 1.1rem;
            margin-bottom: 5px;
            font-weight: 500;
        }
        .card-value {
            color: #fff;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .card-footer-link {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-size: 0.9rem;
            display: block;
            padding: 8px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }
        .card-footer-link:hover {
            color: #fff;
            text-decoration: none;
            background-color: rgba(255, 255, 255, 0.1);
        }
.card-1 { background: linear-gradient(135deg, #5c4bdf 0%, #8a2be2 100%); }
.card-2 { background: linear-gradient(135deg, #ff6b6b 0%, #ffa3a3 100%); }
.card-3 { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
.card-4 { background: linear-gradient(135deg, #ffb347 0%, #ffcc33 100%); }
.card-5 { background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%); }
.card-6 { background: linear-gradient(135deg, #9b59b6 0%, #e74c3c 100%); }        
        .recent-activity {
            max-height: 400px;
            overflow-y: auto;
        }
        .activity-item {
            padding: 10px 15px;
            border-left: 3px solid #667eea;
            margin-bottom: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .activity-time {
            font-size: 0.8rem;
            color: #6c757d;
        }
    </style>






</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
   <p class="lead"> <b>Welcome , <asp:Label ID="lblAdminName" runat="server" Text="Administrator" />!</b></p>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <!-- Summary Cards Row -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="dashboard-card card-1 h-100 py-2">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="card-title">TOTAL MEMBERS</div>
                        <div class="card-value"><asp:Label ID="lblTotalResidents" runat="server" Text="0" /></div>
                        <a href="View_Owner.aspx" class="card-footer-link">View Details <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="dashboard-card card-2 h-100 py-2">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-home"></i>
                        </div>
                        <div class="card-title">TOTAL FLATS</div>
                        <div class="card-value"><asp:Label ID="lblTotalFlats" runat="server" Text="0" /></div>
                        <a href="View_Flat.aspx" class="card-footer-link">View Details <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="dashboard-card card-3 h-100 py-2">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-file-invoice-dollar"></i>
                        </div>
                        <div class="card-title">PENDING PAYMENTS</div>
                        <div class="card-value"><asp:Label ID="lblPendingPayments" runat="server" Text="0" /></div>
                        <a href="AdminMaintenanceList.aspx" class="card-footer-link">View Details <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="dashboard-card card-4 h-100 py-2">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-tools"></i>
                        </div>
                        <div class="card-title">ACTIVE COMPLAINTS</div>
                        <div class="card-value"><asp:Label ID="lblActiveComplaints" runat="server" Text="0" /></div>
                        <a href="View_Complaints.aspx" class="card-footer-link">View Details <i class="fas fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Charts and Activity Row -->
                   <div class="row">
            <!-- Payment Status Chart -->
            <div class="col-xl-8 col-lg-7">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">Payment Status Overview</h6>
                    </div>
                    <div class="card-body">
                        <div class="chart-area">
                            <canvas id="paymentChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-4 col-lg-5">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">Recent Activity</h6>
                    </div>
                    <div class="card-body recent-activity">
                        <asp:Repeater ID="rptRecentActivity" runat="server">
                            <ItemTemplate>
                                <div class="activity-item">
                                    <div class="activity-text"><%# Eval("ActivityText") %></div>
                                    <div class="activity-time"><i class="far fa-clock"></i> <%# Eval("ActivityTime") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoActivity" runat="server" Text="No recent activity found." Visible="false" CssClass="text-muted" />
                    </div>
                </div>
            </div>
        </div>
        

        <!--Quick Actions-->
                   <div class="row mt-4">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Quick Actions</h6>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <a href="AddResident.aspx" class="btn btn-primary btn-circle btn-lg">
                                    <i class="fas fa-user-plus"></i>
                                </a>
                                <p class="mt-2">Add Resident</p>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <a href="GenerateBill.aspx" class="btn btn-success btn-circle btn-lg">
                                    <i class="fas fa-file-invoice"></i>
                                </a>
                                <p class="mt-2">Generate Bill</p>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <a href="Announcements.aspx" class="btn btn-info btn-circle btn-lg">
                                    <i class="fas fa-bullhorn"></i>
                                </a>
                                <p class="mt-2">Post Notice</p>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <a href="Complaints.aspx" class="btn btn-warning btn-circle btn-lg">
                                    <i class="fas fa-tools"></i>
                                </a>
                                <p class="mt-2">Manage Complaints</p>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <a href="Meetings.aspx" class="btn btn-secondary btn-circle btn-lg">
                                    <i class="fas fa-calendar-alt"></i>
                                </a>
                                <p class="mt-2">Schedule Meeting</p>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <a href="Reports.aspx" class="btn btn-dark btn-circle btn-lg">
                                    <i class="fas fa-chart-bar"></i>
                                </a>
                                <p class="mt-2">View Reports</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <!-- Chart.js -->
    <!-- Chart.js and jQuery already included -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script type="text/javascript">
    let paymentChart;

    function initPaymentChart() {
        $.ajax({
            type: "POST",
            url: "AdminDashboard.aspx/GetCurrentYearMaintenanceData",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                const data = response.d;
                renderChart(data.months, data.paid, data.pending);
            },
            error: function (err) {
                console.error("Error fetching chart data:", err);
            }
        });
    }

    function renderChart(months, paidData, pendingData) {
        var ctx = document.getElementById('paymentChart').getContext('2d');
        if (paymentChart) paymentChart.destroy();

        paymentChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: months,
                datasets: [
                    {
                        label: 'Paid',
                        data: paidData,
                        backgroundColor: 'rgba(54, 185, 204, 0.7)',
                        borderColor: 'rgba(54, 185, 204, 1)',
                        borderWidth: 1
                    },
                    {
                        label: 'Pending',
                        data: pendingData,
                        backgroundColor: 'rgba(255, 99, 132, 0.7)',
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return '₹' + value;
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.dataset.label + ': ₹' + context.raw;
                            }
                        }
                    }
                }
            }
        });
    }

    document.addEventListener('DOMContentLoaded', initPaymentChart);
    setInterval(initPaymentChart, 60000); // Refresh every 60s
</script>


</asp:Content>