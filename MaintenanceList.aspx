<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MaintenanceList.aspx.cs" Inherits="Society_management.MaintenanceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <%-- Ensure Bootstrap CSS is loaded only once. If your User.Master already links it, you can remove this.
         Otherwise, keep it here or link the latest stable version (e.g., 5.3.3) --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        /* Your custom status colors (will be preserved) */
        .paid {
            color: #28a745; /* Green */
            font-weight: bold; /* Added for better emphasis */
        }
        .pending {
            color: #dc3545; /* Red */
            font-weight: bold; /* Added for better emphasis */
        }

        /* Styles for the GridView table */
        /* These will be applied along with Bootstrap's .table and .table-striped */
        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th, .table td {
            padding: 12px 15px;
            text-align: left;
            vertical-align: middle; /* Ensure content is vertically centered */
            white-space: nowrap; /* Prevent text wrapping in general cells, rely on table-responsive */
        }

        .table th {
            background-color: #f8f9fa; /* Default Bootstrap light grey for header, you can customize */
            color: #343a40; /* Dark text for header */
            border-bottom: 2px solid #dee2e6;
        }

        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, 0.05); /* Bootstrap's default stripe color */
        }

        /* Specific styles for the action buttons inside the table */
        .action-buttons-cell {
            white-space: nowrap; /* Ensures buttons stay on one line within the cell */
        }
        .action-buttons-cell .btn {
            margin-right: 8px; /* Spacing between buttons */
            min-width: 90px; /* Ensure buttons have a minimum width */
            /* Add any custom button styles you have here, e.g.,
            font-size: 0.9em;
            padding: 0.4rem 0.8rem;
            */
        }
        .action-buttons-cell .btn:last-child {
            margin-right: 0; /* No margin on the last button */
        }

        /* Adjust ddlYear on smaller screens if needed (optional) */
        @media (max-width: 575.98px) { /* Bootstrap 'sm' breakpoint */
            .d-flex.justify-content-between.align-items-center.mb-4 {
                flex-direction: column; /* Stack heading and dropdown */
                align-items: flex-start !important; /* Align stacked items to start */
                gap: 10px; /* Space between stacked items */
            }
            .d-flex.justify-content-between.align-items-center.mb-4 h2 {
                margin-bottom: 0; /* Remove default h2 margin when stacked */
            }
            .form-select.w-auto {
                width: 100% !important; /* Make dropdown full width when stacked */
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <%-- No specific buttons defined in your original Content5 --%>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-2">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Your Maintenance Charges</h2>
            <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged"></asp:DropDownList>
        </div>

        <%-- Wrap the GridView in a responsive container --%>
        <div class="table-responsive">
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
                    <asp:TemplateField HeaderText="Actions"> <%-- Added HeaderText for clarity --%>
                        <ItemTemplate>
                            <div class="d-flex flex-nowrap align-items-center action-buttons-cell">
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
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="alert alert-info">No maintenance records found for the selected year.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
    <%-- Bootstrap JS Bundle (required for some Bootstrap features, often placed at end of body) --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>