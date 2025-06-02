<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="ScheduledVisitors.aspx.cs" Inherits="Society_management.ScheduledVisitors" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1200px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .btn-action {
            min-width: 100px;
            margin: 2px;
        }
        .disabled-btn {
            opacity: 0.65;
            cursor: not-allowed;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
            <h1 class="mb-4">Scheduled Visitors</h1>
            
            <asp:GridView ID="gvScheduledVisitors" runat="server" AutoGenerateColumns="False"
                CssClass="table table-striped table-bordered"
                OnRowCommand="gvScheduledVisitors_RowCommand"
                OnRowDataBound="gvScheduledVisitors_RowDataBound"
                DataKeyNames="ScheduleID,IsCompleted">
                <Columns>
                    <asp:BoundField DataField="ScheduleID" HeaderText="ID" />
                    <asp:BoundField DataField="VisitorName" HeaderText="Visitor Name" />
                    <asp:BoundField DataField="ContactNumber" HeaderText="Contact" />
                    <asp:BoundField DataField="ScheduledDateTime" HeaderText="Scheduled Time" DataFormatString="{0:g}" />
                    <asp:BoundField DataField="Purpose" HeaderText="Purpose" />
                    <asp:BoundField DataField="MemberName" HeaderText="Meeting With" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnCheckIn" runat="server" Text="Check In" CommandName="CheckIn" 
                                CommandArgument='<%# Eval("ScheduleID") %>' 
                                CssClass="btn btn-success btn-action" />
                            <asp:Button ID="btnCheckOut" runat="server" Text="Check Out" CommandName="CheckOut" 
                                CommandArgument='<%# Eval("ScheduleID") %>' 
                                CssClass="btn btn-warning btn-action" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            
            <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-dismissible fade show" Visible="false"></asp:Label>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
