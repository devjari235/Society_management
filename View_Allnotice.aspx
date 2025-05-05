<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Allnotice.aspx.cs" Inherits="Society_management.View_Allnotice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>


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

.notice-card {
    background: #ffffff;
    border-radius: 10px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    color: #212529;
    height: auto;
    border-left: 6px solid transparent; /* default to transparent */
}

.notice-live {
    border-left-color: #198754; /* green */
}

.notice-expired {
    border-left-color: #dc3545; /* red */
}

.swiper-slide {
/*    background: #ffffff;
    border-radius: 10px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    color: #212529;
    height: auto;
    border-left: 6px solid transparent;*/
    margin-bottom: 20px; /* <-- add space between cards */
}



</style>


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
            <a href="LiveNotice.aspx" class="dashboard-btn btn-Live">
                <i class="fas fa-broadcast-tower"></i> Live Notice
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
    <div class="notice-scroller-container">
        <asp:Repeater ID="rptAllNotices" runat="server">
            <ItemTemplate>
                <div class='<%# "swiper-slide notice-card " + 
                    (Eval("Status").ToString().ToLower() == "live" ? "notice-live" : "notice-expired") %>'>
                    
                    <div class="notice-title"><%# Eval("Title") %></div>

                    <%-- Importance Badge --%>
                    <span class='<%# "badge me-2 " + 
                        (Eval("Importance").ToString().ToLower() == "urgent" ? "bg-danger" : 
                         Eval("Importance").ToString().ToLower() == "important" ? "bg-warning text-dark" : 
                         "bg-primary") %>'>
                        <%# Eval("Importance") %>
                    </span>

                    <%-- Status Badge --%>
                    <span class='<%# "badge " + 
                        (Eval("Status").ToString().ToLower() == "live" ? "bg-success" : "bg-secondary") %>'>
                        <%# Eval("Status") %>
                    </span>

                    <p class="text-muted mt-2">Expires: <%# Eval("Expiry_date", "{0:dd MMM yyyy}") %></p>
                    <p><%# Eval("Description") %></p>

                    <asp:HyperLink runat="server" NavigateUrl='<%# Eval("File_path") %>'
                        Text="📎 View Attachment" Target="_blank"
                        CssClass="btn btn-sm btn-outline-secondary mt-2"
                        Visible='<%# !string.IsNullOrEmpty(Eval("File_path").ToString()) %>' />
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
