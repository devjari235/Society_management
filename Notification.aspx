<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Notification.aspx.cs" Inherits="Society_management.Notification" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style>
    body {
        font-family: Arial, sans-serif;
        background: #f9f9f9;
    }

    .notice-board {
        width: 80%;
        margin: auto;
        padding: 20px;
        background: #fffbe6;
        border: 2px dashed #ffcc00;
        border-radius: 10px;
    }

    .notice {
        background: #fff;
        border-left: 6px solid #ff9900;
        padding: 15px;
        margin-bottom: 15px;
        box-shadow: 0 0 5px rgba(0,0,0,0.1);
    }

    .notice h3 {
        margin: 0;
        color: #cc6600;
    }

    .notice p {
        margin-top: 5px;
    }

    .form-group {
        margin-bottom: 10px;
    }

</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
        <h4 style="margin: 0 0 10px 0; color: #cc6600;">🔔 Notifications</h4>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <%-- <div style="position: fixed; top: 20px; right: 20px; width: 300px; background: #fffbe6; border: 1px solid #ffcc00; padding: 10px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.2); z-index:1000;">--%>

    <!-- Display Notices -->
<asp:Repeater ID="rptNotices" runat="server">
    <ItemTemplate>
        <div class="notice">
            <h3><%# Eval("Title") %></h3>
            <p><%# Eval("Description") %></p>
            <small><%# Eval("Date", "{0:dd MMM yyyy hh:mm tt}") %></small>
        </div>
    </ItemTemplate>
</asp:Repeater>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
