<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Admin_noticeDetails.aspx.cs" Inherits="Society_management.Admin_noticeDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
              <style>
        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            font-family: Arial;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
        }

        th {
            background-color: #f4f4f4;
            text-align: left;
            width: 30%;
        }

        h2 {
            text-align: center;
            color: #007bff;
        }

        .Card {
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding:20px;
            margin: 40px auto;
            width: 80%;
            background-color: #fff;
        }
    </style>
        <style>
    /* Button Group Container */
    .action-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        margin: 15px 0;
        width: 100%;
    }

    /* Base Button Styles */
    .btn-register-notice{
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 12px 24px;
        text-decoration: none;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        font-size: 16px;
        font-weight: 600;
        border-radius: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    /* Register Button */
    .btn-register-notice {
        background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        color: white;
    }

    .btn-register-notice:hover {
        background-color: #2980b9;
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        text-decoration:none;
        color: white;
    }



    /* Icons */
    .btn-register-notice i{
        margin-right: 10px;
        font-size: 18px;
    }

    /* Active State */
    .btn-register-notice:active{
        transform: scale(0.98);
    }

    /* Focus State */
    .btn-register-notice:focus{
        outline: none;
    }

    .btn-register-notice:focus {
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.5);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .action-button-group {
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }
        
        .btn-register-notice{
            width: 100%;
            max-width: 300px;
            padding: 15px 20px;
            font-size: 18px;
            text-align: center;
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
    <div class="Card">
    <h2>Notice Details</h2>
    <asp:Panel ID="pnlNotice" runat="server" Visible="false">
        <table>
            <tr><th>Title</th><td><asp:Label ID="lblTitle" runat="server" /></td></tr>
            <tr><th>Description</th><td><asp:Label ID="lblDescription" runat="server" /></td></tr>
            <tr><th>Posted By</th><td><asp:Label ID="lblPostedBy" runat="server" /></td></tr>
            <tr><th>Posted Date</th><td><asp:Label ID="lblPostedDate" runat="server" /></td></tr>
            <tr><th>Expiry Date</th><td><asp:Label ID="lblExpiryDate" runat="server" /></td></tr>
            <tr><th>Status</th><td><asp:Label ID="lblStatus" runat="server" /></td></tr>
            <tr><th>Importance</th><td><asp:Label ID="lblImportance" runat="server" /></td></tr>
            <tr><th>Attachment</th>
                <td>
                    <asp:HyperLink runat="server" ID="hlAttachment" NavigateUrl='<%# Eval("File_path") %>' 
        Text="📎 View Attachment" Target="_blank"
        CssClass="btn btn-sm btn-outline-secondary mt-2"
        Visible='<%# !string.IsNullOrEmpty(Eval("File_path").ToString()) %>' />
     
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
</div>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
