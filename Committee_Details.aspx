<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Committee_Details.aspx.cs" Inherits="Society_management.Committee_Details" %>
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
    #imgPhoto{
        height:150px;
        width:150px;
        border-radius:50%;
        display:flex;
        justify-content:center;
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
<a href="View_CommiteeMember.aspx" class="btn-register-notice">
    <i class="fas fa-arrow-left"></i> Back to Details
</a>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="Card">
    <h2>Committee Member Details</h2>
    <asp:Panel ID="pnlNotice" runat="server" Visible="false">
        <center>
        <div  CssClass="image11">
        <asp:Image ID="imgPhoto" runat="server" ClientIDMode="Static"/>
            </div>
            </center>
        <table>
            <tr><th>Committee Member Name:</th><td><asp:Label ID="lblname" runat="server" /></td></tr>
            <tr><th>Designation</th><td><asp:Label ID="lbldes" runat="server" /></td></tr>
            <tr><th>Role</th><td><asp:Label ID="lblRole" runat="server" /></td></tr>
            <tr><th>Email</th><td><asp:Label ID="lblEmail" runat="server" /></td></tr>
            <tr><th>Phone Number</th><td><asp:Label ID="lblphone" runat="server" /></td></tr>
            <tr><th>Block Name</th><td><asp:Label ID="lblblock" runat="server" /></td></tr>
            <tr><th>Flat No</th><td><asp:Label ID="lblNo" runat="server" /></td></tr>
            <tr><th>From Date</th><td><asp:Label ID="lblFdate" runat="server"></asp:Label></td></tr>
            <tr><th>To Date</th><td><asp:Label ID="lblTdate" runat="server"></asp:Label></td></tr>
            <tr><th>Status</th><td><asp:Label ID="lblStatus" runat="server"></asp:Label></td></tr>
        </table>
    </asp:Panel>
</div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
