<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="AdminPaymentReceipt.aspx.cs" Inherits="Society_management.AdminPaymentReceipt" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .receipt {
            max-width: 600px;
            margin: 0 auto;
            border: 1px solid #ddd;
            padding: 30px;
            background-color: #fff;
        }
        .receipt-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .receipt-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
        .receipt-body {
            margin-bottom: 20px;
        }
        .receipt-row {
            display: flex;
            margin-bottom: 10px;
        }
        .receipt-label {
            font-weight: bold;
            width: 150px;
        }
        .receipt-value {
            flex: 1;
        }
        .receipt-footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px dashed #ddd;
        }
        .success-icon {
            color: #28a745;
            font-size: 48px;
            margin-bottom: 15px;
        }
        @media print {
            body * {
                visibility: hidden;
            }
            .receipt, .receipt * {
                visibility: visible;
            }
            .receipt {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                border: none;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row mb-4 no-print">
            <div class="col-md-12">
                <h2><i class="fas fa-receipt me-2"></i>Payment Receipt</h2>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="receipt">
                    <div class="receipt-header">
                        <div class="success-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="receipt-title">Payment Receipt</div>
                        <div class="text-muted">Society Management System</div>
                    </div>

                    <div class="receipt-body">
                        <div class="receipt-row">
                            <div class="receipt-label">Receipt Number:</div>
                            <div class="receipt-value"><asp:Literal ID="litReceiptNo" runat="server"></asp:Literal></div>
                        </div>
                        <div class="receipt-row">
                            <div class="receipt-label">Transaction ID:</div>
                            <div class="receipt-value"><asp:Literal ID="litTransactionId" runat="server"></asp:Literal></div>
                        </div>
                        <div class="receipt-row">
                            <div class="receipt-label">Payment Date:</div>
                            <div class="receipt-value"><asp:Literal ID="litPaymentDate" runat="server"></asp:Literal></div>
                        </div>
                        <div class="receipt-row">
                            <div class="receipt-label">Resident Name:</div>
                            <div class="receipt-value"><asp:Literal ID="litResidentName" runat="server"></asp:Literal></div>
                        </div>
                        <div class="receipt-row">
                            <div class="receipt-label">Flat Details:</div>
                            <div class="receipt-value"><asp:Literal ID="litFlatDetails" runat="server"></asp:Literal></div>
                        </div>
                        <div class="receipt-row">
                            <div class="receipt-label">Month/Year:</div>
                            <div class="receipt-value"><asp:Literal ID="litMonthYear" runat="server"></asp:Literal></div>
                        </div>
                        <div class="receipt-row">
                            <div class="receipt-label">Payment Method:</div>
                            <div class="receipt-value"><asp:Literal ID="litPaymentMethod" runat="server"></asp:Literal></div>
                        </div>
                        <div class="receipt-row">
                            <div class="receipt-label">Status:</div>
                            <div class="receipt-value"><span class="badge bg-success"><asp:Literal ID="litStatus" runat="server"></asp:Literal></span></div>
                        </div>
                    </div>

                    <div class="receipt-footer">
                        <h4>Amount Paid: ₹<asp:Literal ID="litAmount" runat="server"></asp:Literal></h4>
                        <p class="text-muted mt-3">Thank you for your payment</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4 no-print">
            <div class="col-md-12 text-center">
                <button class="btn btn-primary me-2" onclick="window.print();"><i class="fas fa-print me-2"></i>Print Receipt</button>
                <asp:Button ID="btnBack" runat="server" Text="Back to Payments" CssClass="btn btn-secondary" OnClick="btnBack_Click" />
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
