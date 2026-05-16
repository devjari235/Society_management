<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Admin_noticeDetails.aspx.cs" Inherits="Society_management.Admin_noticeDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .card-notice {
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin: 30px auto;
            background-color: #fff;
            max-width: 900px;
        }

        h2 {
            text-align: center;
            color: #007bff;
            margin-bottom: 30px;
        }

        .action-button-group {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin: 15px auto;
            width: 100%;
            max-width: 900px;
        }

        .btn-register-notice {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
            color: white;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .btn-register-notice:hover {
            background-color: #2980b9;
            transform: translateY(-3px);
            color: white;
            list-style-type:none;
            text-decoration:none;
        }

        .table td, .table th {
            vertical-align: middle;
            font-size: 16px;
        }

@media (max-width: 768px) {

    .card-notice {
        width: 100% !important;
        max-width: 100% !important;
        margin: 10px 0 !important;
        padding: 15px 12px !important;
        box-sizing: border-box !important;
        overflow: visible !important;
    }

    .card-notice .table tbody tr {
        display: block !important;
        width: 100% !important;
        margin-bottom: 12px !important;
        border: 1px solid #e3e6f0 !important;
        border-radius: 10px !important;
        overflow: hidden !important;
    }

    .card-notice .table tbody tr th {
        display: block !important;
        width: 100% !important;
        background: #f8f9fc !important;
        border: none !important;
        border-bottom: 1px solid #e3e6f0 !important;
        padding: 9px 12px !important;
        font-size: 13px !important;
        font-weight: 600 !important;
    }

    .card-notice .table tbody tr td {
        display: block !important;
        width: 100% !important;
        border: none !important;
        padding: 10px 12px !important;
        white-space: normal !important;
        word-break: break-word !important;
        overflow-wrap: break-word !important;
    }

    .card-notice .table tbody tr td span {
        display: block !important;
        width: 100% !important;
        white-space: normal !important;
        word-break: break-word !important;
        overflow-wrap: break-word !important;
    }

    span[id$="lblDescription"] {
        white-space: pre-wrap !important;
    }

    .action-button-group {
        flex-direction: column !important;
        width: 100% !important;
        margin: 10px 0 !important;
        padding: 0 !important;
    }

    .btn-register-notice {
        width: 100% !important;
        text-align: center !important;
        justify-content: center !important;
    }
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="action-button-group">
        <a href="NoticeDashboard.aspx" class="btn-register-notice">
            <i class="fas fa-arrow-left"></i> Back to Details
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-notice">
        <h2>Notice Details</h2>
        <asp:Panel ID="pnlNotice" runat="server" Visible="false">
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <tbody>
                        <tr>
                            <th>Title</th>
                            <td><asp:Label ID="lblTitle" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Description</th>
                            <td><asp:Label ID="lblDescription" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Posted By</th>
                            <td><asp:Label ID="lblPostedBy" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Posted Date</th>
                            <td><asp:Label ID="lblPostedDate" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Expiry Date</th>
                            <td><asp:Label ID="lblExpiryDate" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Status</th>
                            <td><asp:Label ID="lblStatus" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Importance</th>
                            <td><asp:Label ID="lblImportance" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Attachment</th>
                            <td>
                                <asp:HyperLink runat="server" ID="hlAttachment" Target="_blank"
                                    CssClass="btn btn-sm btn-outline-secondary"
                                    Text="📎 View Attachment" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </asp:Panel>
        <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
