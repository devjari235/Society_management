<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="AdminMaintenanceList.aspx.cs" Inherits="Society_management.AdminMaintenanceList"  EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .filter-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .payment-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-paid {
            background-color: #d4edda;
            color: #155724;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .total-summary {
            background-color: #e2e3e5;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .table-responsive {
            overflow-x: auto;
        }
        .export-buttons {
            margin-bottom: 15px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
            <div class="row">
            <div class="col-md-12">
                <h2><i class="fas fa-money-bill-wave me-2"></i>Maintenance Payments</h2>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container-fluid py-4">

        <div class="row mb-4">
            <div class="col-md-12 filter-section">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Month</label>
                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-select">
                            <asp:ListItem Value="0" Text="All Months"></asp:ListItem>
                            <asp:ListItem Value="1" Text="January"></asp:ListItem>
                            <asp:ListItem Value="2" Text="February"></asp:ListItem>
                            <asp:ListItem Value="3" Text="March"></asp:ListItem>
                            <asp:ListItem Value="4" Text="April"></asp:ListItem>
                            <asp:ListItem Value="5" Text="May"></asp:ListItem>
                            <asp:ListItem Value="6" Text="June"></asp:ListItem>
                            <asp:ListItem Value="7" Text="July"></asp:ListItem>
                            <asp:ListItem Value="8" Text="August"></asp:ListItem>
                            <asp:ListItem Value="9" Text="September"></asp:ListItem>
                            <asp:ListItem Value="10" Text="October"></asp:ListItem>
                            <asp:ListItem Value="11" Text="November"></asp:ListItem>
                            <asp:ListItem Value="12" Text="December"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Year</label>
                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select">
                            <asp:ListItem Value="0" Text="All Years"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Block</label>
                        <asp:DropDownList ID="ddlBlock" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBlock_SelectedIndexChanged">
                            <asp:ListItem Value="0" Text="All Blocks"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Flat</label>
                        <asp:DropDownList ID="ddlFlat" runat="server" CssClass="form-select">
                            <asp:ListItem Value="0" Text="All Flats"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Payment Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                            <asp:ListItem Value="all" Text="All Status"></asp:ListItem>
                            <asp:ListItem Value="Completed" Text="Paid"></asp:ListItem>
                            <asp:ListItem Value="Pending" Text="Pending"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Payment Method</label>
                        <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-select">
                            <asp:ListItem Value="all" Text="All Methods"></asp:ListItem>
                            <asp:ListItem Value="creditcard" Text="Credit Card"></asp:ListItem>
                            <asp:ListItem Value="debitcard" Text="Debit Card"></asp:ListItem>
                            <asp:ListItem Value="paytm" Text="PayTM"></asp:ListItem>
                            <asp:ListItem Value="gpay" Text="GPay"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6 d-flex align-items-end">
                        <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-primary me-2" OnClick="btnFilter_Click" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline-secondary" OnClick="btnReset_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-12 total-summary">
                <div class="row">
                    <div class="col-md-3">
                        <h5>Total Paid: <span class="text-success">₹<asp:Literal ID="litTotalPaid" runat="server" Text="0"></asp:Literal></span></h5>
                    </div>
                    <div class="col-md-3">
                        <h5>Total Pending: <span class="text-warning">₹<asp:Literal ID="litTotalPending" runat="server" Text="0"></asp:Literal></span></h5>
                    </div>
                    <div class="col-md-3">
                        <h5>Total Flats: <asp:Literal ID="litTotalFlats" runat="server" Text="0"></asp:Literal></h5>
                    </div>
                    <div class="col-md-3">
                        <h5>Paid Flats: <asp:Literal ID="litPaidFlats" runat="server" Text="0"></asp:Literal></h5>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-12 export-buttons">
                <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel" CssClass="btn btn-success me-2" OnClick="btnExportExcel_Click" />
                <asp:Button ID="btnExportPDF" runat="server" Text="Export to PDF" CssClass="btn btn-danger" OnClick="btnExportPDF_Click" />
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="table-responsive">
                    <asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered table-hover"
                        EmptyDataText="No payments found" OnRowCommand="gvPayments_RowCommand" DataKeyNames="PaymentID">
                        <Columns>
                            <asp:BoundField DataField="PaymentID" HeaderText="ID" SortExpression="PaymentID" />
                            <asp:BoundField DataField="User_name" HeaderText="Resident" SortExpression="User_name" />
                            <asp:BoundField DataField="Block_name" HeaderText="Block" SortExpression="Block_name" />
                            <asp:BoundField DataField="Flate_no" HeaderText="Flat No" SortExpression="Flate_no" />
                            <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" SortExpression="PaymentDate" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                            <asp:TemplateField HeaderText="Month/Year" SortExpression="Month">
                                <ItemTemplate>
                                    <%# GetMonthName(Convert.ToInt32(Eval("Month"))) %> <%# Eval("Year") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="PaymentMethod" HeaderText="Method" SortExpression="PaymentMethod" />
                            <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" SortExpression="TransactionID" />
                      <%--      <asp:TemplateField HeaderText="Status" SortExpression="Status">
                                <ItemTemplate>
                                    <span class='payment-status status-<%# Eval("Status").ToString().ToLower() %>'><%# Eval("Status") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkView" runat="server" CommandName="ViewReceipt" CommandArgument='<%# Eval("PaymentID") %>'
                                        CssClass="btn btn-sm btn-info" ToolTip="View Receipt">
                                        <i class="fas fa-receipt"></i>
                                    </asp:LinkButton>
<%--                                    <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditPayment" CommandArgument='<%# Eval("PaymentID") %>'
                                        CssClass="btn btn-sm btn-warning" ToolTip="Edit">
                                        <i class="fas fa-edit"></i>
                                    </asp:LinkButton>--%>
                                    <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeletePayment" CommandArgument='<%# Eval("PaymentID") %>'
                                        CssClass="btn btn-sm btn-danger" ToolTip="Delete" OnClientClick="return confirm('Are you sure you want to delete this payment?');">
                                        <i class="fas fa-trash-alt"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
