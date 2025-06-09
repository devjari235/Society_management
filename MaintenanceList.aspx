<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MaintenanceList.aspx.cs" Inherits="Society_management.MaintenanceList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .paid {
            color: #28a745;
        }
        .pending {
            color: #dc3545;
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
    <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Your Maintenance Charges</h2>
                <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged"></asp:DropDownList>
            </div>
            
            <asp:GridView ID="gvMaintenance" runat="server" CssClass="table table-striped" AutoGenerateColumns="false" OnRowCommand="gvMaintenance_RowCommand">
                <Columns>
                    <asp:BoundField DataField="MonthName" HeaderText="Month" />
                    <asp:BoundField DataField="Year" HeaderText="Year" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="₹{0:N2}" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# Eval("Status").ToString() == "Paid" ? "paid" : "pending" %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <%-- Pay Now Button --%>
                            <asp:LinkButton ID="lnkPayNow" runat="server"
                                CommandName="Pay"
                                CommandArgument='<%# Eval("UserID") + "|" + Eval("Month") + "|" + Eval("Year") %>'
                                Text="Pay Now" CssClass="btn btn-primary btn-sm"
                                Visible='<%# Eval("Status").ToString() == "Pending" %>' />

                            <%-- View Receipt Button --%>
                            <asp:LinkButton ID="lnkViewReceipt" runat="server"
                                CommandName="ViewReceipt"
                                CommandArgument='<%# Eval("UserID") + "|" + Eval("Month") + "|" + Eval("Year") %>'
                                Text="View Receipt" CssClass="btn btn-success btn-sm"
                                Visible='<%# Eval("Status").ToString() == "Paid" %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="alert alert-info">No maintenance records found for the selected year.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
