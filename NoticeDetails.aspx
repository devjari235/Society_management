<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="NoticeDetails.aspx.cs" Inherits="Society_management.NoticeDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Notice Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
    /* 1. MASTER PAGE OVERRIDES */
    /* Hides the extra Dashboard/Home text injected by the Master Page */
    .page-title, .breadcrumb, .dashboard-header, .home-link {
        display: none !important;
    }

    /* 2. CARD LAYOUT */
    .card {
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        padding: 20px;
        margin: 10px auto;
        width: 95%;
        max-width: 900px;
        background-color: #fff;
        box-sizing: border-box;
        overflow: hidden;
    }

    h2 {
        text-align: center;
        color: #007bff;
        margin-top: 0;
        margin-bottom: 20px;
        font-family: Arial, sans-serif;
    }

    /* 3. TABLE STYLES */
    .table-container {
        width: 100%;
        overflow: hidden;
    }

    table {
        width: 100%;
        margin: 10px auto;
        border-collapse: collapse;
        font-family: Arial, sans-serif;
        table-layout: auto;
        background-color: #fff;
        border: 1px solid #ddd;
    }

    th, td {
        padding: 12px;
        border: 1px solid #eee;
        word-wrap: break-word;
        vertical-align: middle;
    }

    th {
        background-color: #ffffff; 
        text-align: left;
        width: 1%; 
        white-space: nowrap;
        font-weight: bold;
        color: #333;
        border-right: 1px solid #ddd;
    }

    /* 4. ATTACHMENT BUTTON FIX (CSS ONLY) */
    /* Targets the hyperlink inside the last row to prevent mobile blowout */
    table tr:last-child td a {
        display: inline-block;
        width: fit-content;
        max-width: 200px;
        padding: 8px 15px;
        background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        color: white !important;
        text-decoration: none;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 600;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        vertical-align: middle;
        text-align: center;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* 5. TOP ACTION BUTTONS */
    .action-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        margin: 10px 0;
        width: 100%;
    }

    .btn-register-notice {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 10px 20px;
        text-decoration: none;
        font-family: 'Segoe UI', sans-serif;
        font-size: 14px;
        font-weight: 600;
        border-radius: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        color: white;
    }

    .btn-register-notice:hover {
        transform: translateY(-2px);
        color: white;
        text-decoration: none;
    }

    /* 6. RESPONSIVE MOBILE FIXES */
    @media (max-width: 768px) {
        .action-button-group {
            justify-content: center;
        }
        
        .btn-register-notice { 
            width: 100%; 
        }

        /* Prevent table from expanding wider than the phone screen */
        table {
            table-layout: fixed;
        }

        th {
            width: 90px !important; /* Keep labels narrow */
            font-size: 13px;
            white-space: nowrap;
        }

        td {
            font-size: 13px;
        }

        /* Shrink the attachment button so it doesn't cause a scrollbar */
        table tr:last-child td a {
            max-width: 130px;
            font-size: 12px;
            padding: 6px 10px;
        }
    }
</style>
</asp:Content>

<%-- CLEARING BREADCRUMB CONTENT --%>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<%-- CLEARING PAGE HEADER CONTENT --%>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <div class="action-button-group">
        <a href="UserDashboard.aspx" class="btn-register-notice">
            <i class="fas fa-arrow-left"></i> Back to Details
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card">
        <h2>Notice Details</h2>
        <asp:Panel ID="pnlNotice" runat="server" Visible="true">
            <div class="table-container">
                <table>
                    <tr><th>Title</th><td><asp:Label ID="lblTitle" runat="server" Text="Upcoming Maintenance of Community Hall" /></td></tr>
                    <tr><th>Description</th><td><asp:Label ID="lblDescription" runat="server" Text="Please be informed that the community hall will undergo scheduled maintenance..." /></td></tr>
                    <tr><th>Posted By</th><td><asp:Label ID="lblPostedBy" runat="server" Text="Harsh" /></td></tr>
                    <tr><th>Posted Date</th><td><asp:Label ID="lblPostedDate" runat="server" Text="05 May 2026" /></td></tr>
                    <tr><th>Expiry Date</th><td><asp:Label ID="lblExpiryDate" runat="server" Text="14 May 2026" /></td></tr>
                    <tr><th>Status</th><td><asp:Label ID="lblStatus" runat="server" Text="Live" /></td></tr>
                    <tr><th>Importance</th><td><asp:Label ID="lblImportance" runat="server" Text="High" /></td></tr>
                    <tr>
                        <th>Attachment</th>
                        <td>
                            <asp:HyperLink runat="server" ID="hlAttachment" 
                                Text="📎 View Attachment" Target="_blank"
                                CssClass="btn-register-notice" style="padding: 5px 10px; font-size: 12px;" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
    </div>
</asp:Content>