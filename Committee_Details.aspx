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
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="Card">
    <h2>Committee Member Details</h2>
    <asp:Panel ID="pnlNotice" runat="server" Visible="false">
         <asp:Image ID="imgPhoto" runat="server" 
     ClientIDMode="Static"
     Height="210px" 
     AlternateText="Profile Picture"
     CssClass="image11"/>
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
