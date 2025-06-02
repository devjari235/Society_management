<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="VisitorApproval.aspx.cs" Inherits="Society_management.VisitorApproval" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
        }
        #container {
            max-width: 1200px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .status-approved {
            color: #28a745;
            font-weight: bold;
        }
        .status-pending {
            color: #ffc107;
            font-weight: bold;
        }
        .status-rejected {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    
            <h1>Visitor Approval Status</h1>
            <asp:GridView ID="gvVisitorApprovals" runat="server" AutoGenerateColumns="False"
                CssClass="table table-striped table-bordered"
                OnRowCommand="gvVisitorApprovals_RowCommand"
                DataKeyNames="VisitorID" OnRowDataBound="gvVisitorApprovals_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="VisitorID" HeaderText="Visitor ID" />
                    <asp:BoundField DataField="Name" HeaderText="Visitor Name" />
                    <asp:BoundField DataField="ContactNumber" HeaderText="Contact Number" />
                    <asp:BoundField DataField="VisitPurpose" HeaderText="Purpose" />
                    <asp:BoundField DataField="VisitDateTime" HeaderText="Visit Time" DataFormatString="{0:g}" />
                    <asp:TemplateField HeaderText="Approval Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" 
                                CssClass='<%# ((Society_management.VisitorApproval)Page).GetStatusCssClass(Eval("IsApproved")) %>'
                                Text='<%# ((Society_management.VisitorApproval)Page).GetStatusText(Eval("IsApproved")) %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnSchedule" runat="server" Text="Schedule" 
                                CommandName="Schedule" 
                                CommandArgument='<%# Eval("VisitorID") %>'
                                CssClass="btn btn-primary btn-sm" 
                                Visible='<%# ((Society_management.VisitorApproval)Page).IsApproved(Eval("IsApproved")) %>' />
                        </ItemTemplate>
                        <ItemTemplate>
                            <asp:Button ID="btnCheckIn" runat="server" Text="Check In" CommandName="CheckIn" 
                                CommandArgument='<%# Eval("VisitorID") %>' 
                                CssClass="btn btn-success btn-action" />
                            <asp:Button ID="btnCheckOut" runat="server" Text="Check Out" CommandName="CheckOut" 
                                CommandArgument='<%# Eval("VisitorID") %>' 
                                CssClass="btn btn-warning btn-action" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-dismissible fade show" Visible="false"></asp:Label>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
