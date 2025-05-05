<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Allnotice.aspx.cs" Inherits="Society_management.View_Allnotice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
