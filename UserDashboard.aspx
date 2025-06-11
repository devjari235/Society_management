<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="Society_management.UserDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- jQuery (required for Bootstrap dropdowns) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap JS Bundle with Popper (required for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Font Awesome (for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --accent-color: #e74c3c;
            --light-gray: #f5f5f5;
            --dark-gray: #333;
            --white: #fff;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        body {
            background-color: var(--light-gray);
            font-family: 'Segoe UI', sans-serif;
        }

        .dashboard-container {
            padding: 20px;
        }

        /* Dashboard Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background-color: var(--white);
            border-radius: 8px;
            padding: 20px;
            box-shadow: var(--shadow);
            transition: transform 0.2s;
            border: none;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 0;
            background: transparent;
            border: none;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0;
        }

        .card-badge {
            background-color: var(--accent-color);
            color: var(--white);
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
        }

        .card-content {
            color: var(--dark-gray);
            margin-bottom: 15px;
        }

        .card-footer {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: #666;
            padding: 0;
            background: transparent;
            border: none;
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .action-btn {
            background-color: var(--white);
            border-radius: 8px;
            padding: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            box-shadow: var(--shadow);
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            text-decoration: none;
            color: var(--dark-gray);
        }

        .action-btn:hover {
            background-color: var(--primary-color);
            color: var(--white);
            text-decoration: none;
        }

        .action-btn i {
            font-size: 1.5rem;
            margin-bottom: 8px;
        }

        .action-btn span {
            font-size: 0.9rem;
        }

        /* Swiper Styles */
        .swiper-container-wrapper {
            width: 100%;
            display: flex;
            justify-content: center;
            position: relative;
            padding: 0 60px;
            margin-bottom: 30px;
        }

        .swiper {
            width: 100%;
            max-width: 900px;
            overflow: hidden;
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

        .swiper-slide:hover {
            cursor: pointer;
        }

        /* Upcoming Events */
        .upcoming-events {
            margin-bottom: 30px;
        }

        .event-item {
            display: flex;
            background-color: var(--white);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            box-shadow: var(--shadow);
        }

        .event-date {
            background-color: var(--primary-color);
            color: var(--white);
            border-radius: 6px;
            padding: 10px;
            text-align: center;
            min-width: 60px;
            margin-right: 15px;
        }

        .event-day {
            font-size: 1.2rem;
            font-weight: bold;
        }

        .event-month {
            font-size: 0.8rem;
            text-transform: uppercase;
        }

        .event-details {
            flex: 1;
        }

        .event-title {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .event-time {
            font-size: 0.8rem;
            color: #666;
        }

        @media (max-width: 768px) {
            .dashboard-cards {
                grid-template-columns: 1fr;
            }

            .quick-actions {
                grid-template-columns: repeat(2, 1fr);
            }

            .swiper-container-wrapper {
                padding: 0 40px;
            }

            .swiper-button-next,
            .swiper-button-prev {
                width: 30px;
                height: 30px;
            }
        }
        .quick-actions {
    width: 100%;
    margin: 0;
    padding: 0 1rem; /* Match Bootstrap card padding if needed */
    direction: rtl;
    display: flex;
    justify-content: flex-start;
    flex-wrap: wrap;
    gap: 1rem;
}
.quick-actions .action-btn {
    direction: ltr;
    flex: 1 1 150px;
    padding: 1rem;
    text-align: center;
    text-decoration: none;
    transition: all 0.3s;
}
.quick-actions .action-btn i {
    display: block;
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
}



    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
    <div class="d-flex justify-content-between align-items-center">
        <h1 class="h2 mb-0">Dashboard</h1>
      <%--  <div class="d-flex">
            <button class="btn btn-sm btn-outline-secondary me-2" onclick="window.print()">
                <i class="fas fa-print me-1"></i> Print
            </button>
            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#quickHelpModal">
                <i class="fas fa-question-circle me-1"></i> Help
            </button>
        </div>--%>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-container">
        <!-- Dashboard Cards -->
        <div class="dashboard-cards">
           <div class="card">
    <div class="card-header">
        <div class="card-title">Maintenance Due</div>
        <div class="card-badge" id="cardBadgeDiv" runat="server" ><asp:Literal ID="litBadgeText" runat="server" Text="1 Pending" /></div>
    </div>
    <div class="card-content">
        <asp:Panel ID="pnlDueMessage" runat="server">
            Your monthly maintenance payment of ₹<asp:Label ID="lblMaintenanceAmount" runat="server" Text="2,500"></asp:Label> 
            is due on <asp:Label ID="lblDueDate" runat="server" Text="25th June 2025"></asp:Label>.
        </asp:Panel>
        <asp:Label ID="lblPaymentStatus" runat="server" Font-Bold="true" />
    </div>
    <div class="card-footer">
        <span id="spanDaysLeft" runat="server"><i class="far fa-clock me-1"></i> <asp:Label ID="lblDaysLeft" runat="server" Text="3 days left"></asp:Label></span>
        
        <asp:Button ID="btnPayNow" runat="server" Text="Pay Now" CssClass="btn btn-primary"
            OnClick="btnPayNow_Click" Visible="false" />

        <asp:Button ID="btnViewReceipt" runat="server" Text="View Receipt" CssClass="btn btn-success"
            OnClick="btnViewReceipt_Click" Visible="false" />

        <asp:HiddenField ID="hdnUserId" runat="server" />
        <asp:HiddenField ID="hdnMonth" runat="server" />
        <asp:HiddenField ID="hdnYear" runat="server" />
    </div>
</div>

            <div class="card">
                <div class="card-header">
                    <div class="card-title">Active Visitors</div>
                    <div class="card-badge"><asp:Label ID="lblVisitorCount" runat="server" Text="2 Today"></asp:Label></div>
                </div>
                <div class="card-content">
                    You have <asp:Label ID="lblTotalVisitors" runat="server" Text="2"></asp:Label> visitors registered today. 
                    <asp:Panel ID="pnlNextVisitor" runat="server" Visible="true">
                        Next expected visitor at <asp:Label ID="lblNextVisitorTime" runat="server" Text="4:30 PM"></asp:Label>.
                    </asp:Panel>
                </div>
                <div class="card-footer">
                    <span><i class="fas fa-user-clock me-1"></i> Last visitor: <asp:Label ID="lblLastVisitorTime" runat="server" Text="11:30 AM"></asp:Label></span>
                    <asp:HyperLink ID="lnkViewVisitors" runat="server" CssClass="btn btn-sm btn-outline-primary" NavigateUrl="~/Visitor_List.aspx">View All</asp:HyperLink>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-title">Society Events</div>
                    <div class="card-badge">New</div>
                </div>
                <div class="card-content">
                    <asp:Label ID="lblEventTitle" runat="server" Text="Annual Society Day celebration"></asp:Label> on <asp:Label ID="lblEventDate" runat="server" Text="30th June"></asp:Label>. 
                </div>
                <div class="card-footer">
                    <span><i class="far fa-calendar-alt me-1"></i> <asp:Label ID="lblDaysToEvent" runat="server" Text="5 days to go"></asp:Label></span>
                    <asp:HyperLink ID="lnkRegisterEvent" runat="server" CssClass="btn btn-sm btn-primary" NavigateUrl="~/User_view_Events.aspx">View All Events</asp:HyperLink>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->

        <div class="quick-actions">
            <asp:HyperLink ID="lnkAddVisitor" runat="server" CssClass="action-btn" NavigateUrl="~/MemberSchedule.aspx">
                <i class="fas fa-plus-circle"></i>
                <span>Add Visitor</span>
            </asp:HyperLink>
            <asp:HyperLink ID="lnkRaiseComplaint" runat="server" CssClass="action-btn" NavigateUrl="~/Complaint.aspx">
                <i class="fas fa-file-alt"></i>
                <span>Raise Complaint</span>
            </asp:HyperLink>
            <asp:HyperLink ID="lnkMakePayment" runat="server" CssClass="action-btn" NavigateUrl="~/MaintenanceList.aspx">
                <i class="fas fa-rupee-sign"></i>
                <span>Make Payment</span>
            </asp:HyperLink>
            <asp:HyperLink ID="lnkVotePoll" runat="server" CssClass="action-btn" NavigateUrl="~/User_Poll.aspx">
                <i class="fas fa-vote-yea"></i>
                <span>Vote in Poll</span>
            </asp:HyperLink>
            <asp:HyperLink ID="lnkBookFacility" runat="server" CssClass="action-btn" NavigateUrl="~/Family_member.aspx">
                 <i class="fas fa-plus-circle"></i>
                <span>Add Member</span>
            </asp:HyperLink>
            <%--<asp:HyperLink ID="lnkSetReminder" runat="server" CssClass="action-btn" NavigateUrl="~/Reminders.aspx">
                <i class="fas fa-bell"></i>
                <span>Set Reminder</span>
            </asp:HyperLink>--%>
        </div>

        <!-- Announcements Swiper -->
        <h3 class="mb-3">&nbsp;</h3>
        <h3 class="mb-3">Latest Announcements</h3>
        <div class="swiper-container-wrapper">
            <div class="swiper-button-prev"></div>
            <div class="swiper mySwiper">
                <div class="swiper-wrapper">
                    <asp:Repeater ID="rptNotices" runat="server" OnItemCommand="rptNotices_ItemCommand">
                        <ItemTemplate>
                            <div class="swiper-slide">
                                <asp:LinkButton ID="lnkDetails" runat="server" CommandArgument='<%# Eval("Notice_id") %>' CommandName="ViewDetails" Style="all: unset; display: block;">
                                    <div class="notice-title"><%# Eval("Title") %></div>
                                    <span class="badge bg-primary me-2"><%# Eval("Importance") %></span>
                                    <span class="badge bg-success"><%# Eval("Status") %></span>
                                    <p class="text-muted mt-2">Expires: <%# Eval("Expiry_date", "{0:dd MMM yyyy}") %></p>
                                    <b><p>Posted By: <%# Eval("name") %></p></b>
                                    <p><%# Eval("Description") %></p>
                                    <asp:HyperLink runat="server" NavigateUrl='<%# Eval("File_path") %>' 
                                        Text="📎 View Attachment" Target="_blank"
                                        CssClass="btn btn-sm btn-outline-secondary mt-2"
                                        Visible='<%# !string.IsNullOrEmpty(Eval("File_path").ToString()) %>' />
                                </asp:LinkButton></div></ItemTemplate></asp:Repeater><asp:Panel ID="pnlNoNotice" runat="server" Visible="false">
                        <div class="swiper-slide d-flex align-items-center justify-content-center" style="height: 300px;">
                            <div class="text-center p-4">
                                <img src="https://cdn-icons-png.flaticon.com/512/4076/4076549.png" alt="No Notices" style="width: 80px;" />
                                <h5 class="mt-3 fw-bold text-secondary">No Notice Available</h5><p class="text-muted">Stay tuned! New notices will appear here soon.</p></div></div></asp:Panel></div><div class="swiper-pagination"></div>
            </div>
            <div class="swiper-button-next"></div>
        </div>

        <!-- Upcoming Events -->
        <h3 class="mb-3">Upcoming Events</h3><asp:Repeater ID="rptEvents" runat="server">
            <ItemTemplate>
                <div class="event-item">
                    <div class="event-date">
                        <div class="event-day"><%# Eval("EventDay", "{0:dd}") %></div>
                        <div class="event-month"><%# Eval("EventDay", "{0:MMM}") %></div>
                    </div>
                    <div class="event-details">
                        <div class="event-title"><%# Eval("EventName") %></div>
                        <div class="event-time"><%# Eval("StartTime", "{0:hh:mm tt}") %> - <%# Eval("EndTime", "{0:hh:mm tt}") %></div></div></div></ItemTemplate></asp:Repeater><asp:Panel ID="pnlNoEvents" runat="server" Visible="false" CssClass="text-center py-4">
            <i class="fas fa-calendar-alt fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">No Upcoming Events</h5><p>Check back later for scheduled events</p></asp:Panel></div><!-- Quick Help Modal --><div class="modal fade" id="quickHelpModal" tabindex="-1" aria-labelledby="quickHelpModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="quickHelpModalLabel">Dashboard Help</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h6>Dashboard Overview</h6><p>Your dashboard provides quick access to important society information and actions:</p><ul>
                        <li><strong>Cards:</strong> Summary of pending actions and important dates</li><li><strong>Quick Actions:</strong> One-click access to common tasks</li><li><strong>Announcements:</strong> Swipe through latest society notices</li><li><strong>Events:</strong> View upcoming society events</li></ul><p>For more detailed information, use the menu to navigate to specific sections.</p></div><div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button><asp:HyperLink ID="lnkFullHelp" runat="server" CssClass="btn btn-primary" NavigateUrl="~/Help.aspx">Full Help Guide</asp:HyperLink></div></div></div></div><!-- Toast Container for Notifications --><div id="toastContainer" style="position: fixed; top: 20px; right: 20px; z-index: 9999"></div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    
    <script>
        $(document).ready(function () {
            // Initialize Swiper
            new Swiper(".mySwiper", {
                loop: true,
                slidesPerView: 1,
                spaceBetween: 30,
                pagination: {
                    el: ".swiper-pagination",
                    clickable: true,
                    renderBullet: function (index, className) {
                        return '<span class="' + className + '">' + (index + 1) + "</span>";
                    }
                },
                navigation: {
                    nextEl: ".swiper-button-next",
                    prevEl: ".swiper-button-prev"
                },
                autoplay: {
                    delay: 5000,
                    disableOnInteraction: false
                }
            });

            // Show toast notification if there's a message
       <%--     //<% if (!string.IsNullOrEmpty(NotificationMessage)) { %>
            //  //  showToast('<%= NotificationType %>', '<%= NotificationMessage %>');
            <% } %>--%>

            // Load any dashboard data via AJAX if needed
            loadDashboardData();
        });

        function loadDashboardData() {
            // This would be replaced with actual API calls
            console.log('Loading dashboard data...');
            // Example: $.get('/api/dashboard', function(data) { updateUI(data); });
        }

        function showToast(type, message) {
            const toast = document.createElement('div');
            toast.className = `toast show align-items-center text-white bg-${type} border-0`;
            toast.setAttribute('role', 'alert');
            toast.setAttribute('aria-live', 'assertive');
            toast.setAttribute('aria-atomic', 'true');
            toast.innerHTML = `
                <div class="d-flex">
                    <div class="toast-body">${message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            `;
            document.getElementById('toastContainer').appendChild(toast);

            // Auto-hide after 5 seconds
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 300);
            }, 5000);
        }
    </script>
</asp:Content>