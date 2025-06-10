<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Notification.aspx.cs" Inherits="Society_management.Notification" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
<style>
    .remarks-section {
        margin-top: 30px;
        padding: 20px;
        border-top: 1px solid #eee;
    }

    .remark-item {
        padding: 15px;
        margin-bottom: 15px;
        background-color: #ebfbee;         /* light green */
        border-left: 5px solid #28a745;    /* green line */
        color: #155724;                    /* green text */
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.3s, box-shadow 0.3s;
    }

    .remark-item:hover {
        background-color: #d1f3da;         /* lighter green on hover */
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .remark-header {
        display: flex;
        justify-content: space-between;
        font-weight: bold;
        margin-bottom: 8px;
        color: #155724;
    }

    .remark-text {
        padding: 10px;
        background-color: #ffffff;
        border-radius: 4px;
        color: #333;
    }

    /* Optional utility classes if not using Bootstrap */
    .text-decoration-none {
        text-decoration: none !important;
    }

    .text-dark {
        color: #212529 !important;
    }

    .w-100 {
        width: 100% !important;
    }

    .d-block {
        display: block !important;
    }
    .btn-remark:active {
    background-color: #1e7e34;  /* even darker green */
    transform: translateY(2px); /* button goes downward */
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1); /* less shadow = pressed look */
}
</style>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
<div>
    <h3>Remarks</h3>
    
   <asp:Repeater ID="rptRemarks" runat="server" OnItemCommand="rptRemarks_ItemCommand">
    <ItemTemplate>
        <div class="remark-item" style="cursor:pointer;">
            <asp:LinkButton ID="lnkRemark" runat="server" 
                CommandName="View" 
                CommandArgument='<%# Eval("Complaint_id") %>' 
                CssClass="text-decoration-none text-dark w-100 d-block">
                <div class="remark-header">
                    <span>By: <%# Eval("AdminName") %></span>
                    <span>On: <%# Eval("RemarkDate", "{0:dd MMM yyyy hh:mm tt}") %></span>
                </div>
                <div class="remark-text">
                    <%# Eval("RemarkText") %>
                </div>
            </asp:LinkButton>
        </div>
    </ItemTemplate>
</asp:Repeater>

</div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
