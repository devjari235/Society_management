<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_Complaint_Details.aspx.cs" Inherits="Society_management.User_Complaint_Details" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
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

    .card {
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        padding: 20px;
        margin: 40px auto;
        width: 90%;
        background-color: #fff;
    }
</style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
           <div class="card">
    <h2>Complaint Details</h2>
    <asp:Panel ID="pnlNotice" runat="server" Visible="false">
        <table>
            <tr><th>Complaint Type</th><td><asp:Label ID="lbltype" runat="server" /></td></tr>
            <tr><th>Description</th><td><asp:Label ID="lblDescription" runat="server" /></td></tr>
            <tr><th>Block Name</th><td><asp:Label ID="lblblock" runat="server" /></td></tr>
            <tr><th>Flat No</th><td><asp:Label ID="lblNo" runat="server" /></td></tr>
            <tr><th>Complaint By</th><td><asp:Label ID="lblBy" runat="server" /></td></tr>
            <tr><th>Complaint Date</th><td><asp:Label ID="lblCDate" runat="server" /></td></tr>
            <tr><th>Resolve Date</th><td><asp:Label ID="lblRDate" runat="server" /></td></tr>
            <tr><th>Status</th><td><asp:Label ID="lblStatus" runat="server" /></td></tr>
            <tr><th>Priority</th><td><asp:Label ID="lblPriority" runat="server" /></td></tr>
            <tr><th>Attachment</th>
                      <td>
                          <asp:HyperLink runat="server" ID="hlAttachment" NavigateUrl='<%# Eval("image") %>'
                              Text="📎 View Attachment" Target="_blank"
                              CssClass="btn btn-sm btn-outline-secondary mt-2"
                              Visible='<%# !string.IsNullOrEmpty(Eval("image").ToString()) %>' />

                      </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
</div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
