<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="Society_management.Payment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap dropdowns) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap JS Bundle with Popper (required for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Font Awesome (for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .payment-card {
            transition: all 0.3s;
            cursor: pointer;
            border: 1px solid #dee2e6;
        }
        .payment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .payment-card.selected {
            border: 2px solid #0d6efd;
            background-color: #f8f9fa;
        }
        .hidden {
            display: none;
        }
        .receipt {
            max-width: 500px;
            margin: 0 auto;
            border: 1px solid #ddd;
            padding: 20px;
        }
                       
    /* Button Group Container */
    .action-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
       
        width: 100%;
    }

    /* Base Button Styles */
    .btn-register-notice{
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 12px 24px;
        text-decoration: none;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        font-size: 16px;
        font-weight: 600;
        border-radius: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    /* Register Button */
    .btn-register-notice {
        background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        color: white;
    }

    .btn-register-notice:hover {
        background-color: #2980b9;
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        text-decoration:none;
        color: white;
    }



    /* Icons */
    .btn-register-notice i{
        margin-right: 10px;
        font-size: 18px;
    }

    /* Active State */
    .btn-register-notice:active{
        transform: scale(0.98);
    }

    /* Focus State */
    .btn-register-notice:focus{
        outline: none;
    }

    .btn-register-notice:focus {
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.5);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .action-button-group {
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }
        
        .btn-register-notice{
            width: 100%;
            max-width: 300px;
            padding: 15px 20px;
            font-size: 18px;
            text-align: center;
        }
    }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
         <div class="action-button-group">
     <a href="UserDashboard.aspx" class="btn-register-notice">
         <i class="fas fa-arrow-left"></i>Back to Details
     </a>
 </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-2">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">Maintenance Payment</h4>
                        </div>
                        <div class="card-body">
                            <asp:Panel ID="pnlMaintenanceDetails" runat="server">
                                <div class="mb-4">
                                    <h5>Maintenance Details</h5>
                                    <hr />
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Resident Name:</strong> <asp:Label ID="lblResidentName" runat="server" Text=""></asp:Label></p>
                                            <p><strong>Flat Number:</strong> <asp:Label ID="lblFlatNumber" runat="server" Text=""></asp:Label></p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Month/Year:</strong> <asp:Label ID="lblMonthYear" runat="server" Text=""></asp:Label></p>
                                            <p><strong>Amount Due:</strong> <span class="text-danger fw-bold">₹<asp:Label ID="lblAmount" runat="server" Text=""></asp:Label></span></p>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlPaymentMethods" runat="server">
                                <div class="mb-4">
                                    <h5>Select Payment Method</h5>
                                    <hr />
                                    <div class="row g-3">
                                        <div class="col-md-3 col-6">
                                            <div class="card payment-card text-center p-3" onclick="selectPaymentMethod('creditcard')">
                                                <img src="https://cdn-icons-png.flaticon.com/512/196/196578.png" alt="Credit Card" class="img-fluid mb-2" style="height: 50px;" />
                                                <p class="mb-0">Credit Card</p>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-6">
                                            <div class="card payment-card text-center p-3" onclick="selectPaymentMethod('debitcard')">
                                                <img src="https://cdn-icons-png.flaticon.com/512/196/196578.png" alt="Debit Card" class="img-fluid mb-2" style="height: 50px;" />
                                                <p class="mb-0">Debit Card</p>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-6">
                                            <div class="card payment-card text-center p-3" onclick="selectPaymentMethod('paytm')">
                                                <img src="https://cdn-icons-png.flaticon.com/512/825/825454.png" alt="PayTM" class="img-fluid mb-2" style="height: 50px;" />
                                                <p class="mb-0">PayTM</p>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-6">
                                            <div class="card payment-card text-center p-3" onclick="selectPaymentMethod('gpay')">
                                                <img src="https://cdn-icons-png.flaticon.com/512/825/825462.png" alt="GPay" class="img-fluid mb-2" style="height: 50px;" />
                                                <p class="mb-0">GPay</p>
                                            </div>
                                        </div>
                                    </div>
                                    <asp:HiddenField ID="hdnPaymentMethod" runat="server" />
                                </div>

                                <div id="cardPaymentForm" class="hidden">
                                    <h5>Card Details</h5>
                                    <hr />
                                    <div class="row g-3">
                                        <div class="col-md-12">
                                            <label class="form-label">Card Number</label>
                                            <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="1234 5678 9012 3456" MaxLength="19"></asp:TextBox>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Name on Card</label>
                                            <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control" placeholder="John Doe"></asp:TextBox>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Expiry Date</label>
                                            <asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" placeholder="MM/YY"></asp:TextBox>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">CVV</label>
                                            <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" MaxLength="3" TextMode="Password"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>

                                <div id="upiPaymentForm" class="hidden">
                                    <h5>UPI Details</h5>
                                    <hr />
                                    <div class="row g-3">
                                        <div class="col-md-12">
                                            <label class="form-label">UPI ID</label>
                                            <asp:TextBox ID="txtUPIId" runat="server" CssClass="form-control" placeholder="yourname@upi"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlPaymentButtons" runat="server">
                                <div class="d-grid gap-2 mt-4">
                                    <asp:Button ID="btnPayNow" runat="server" Text="Pay Now" CssClass="btn btn-primary btn-lg" OnClick="btnPayNow_Click" OnClientClick="return validatePayment();" />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary" OnClick="btnCancel_Click" />
                                </div>
                            </asp:Panel>

                            <asp:Panel ID="pnlReceipt" runat="server" Visible="false">
                                <div class="receipt">
                                    <h3 class="text-center">Payment Receipt</h3>
                                    <hr />
                                    <div class="text-center mb-3">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="green" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                                            <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                                        </svg>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Resident Name:</strong> <asp:Label ID="lblReceiptName" runat="server" Text=""></asp:Label></p>
                                            <p><strong>Flat Number:</strong> <asp:Label ID="lblReceiptFlat" runat="server" Text=""></asp:Label></p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Payment Date:</strong> <asp:Label ID="lblPaymentDate" runat="server" Text=""></asp:Label></p>
                                            <p><strong>Transaction ID:</strong> <asp:Label ID="lblTransactionId" runat="server" Text=""></asp:Label></p>
                                        </div>
                                    </div>
                                    <hr />
                                    <div class="text-center">
                                        <h4>Amount Paid: ₹<asp:Label ID="lblReceiptAmount" runat="server" Text=""></asp:Label></h4>
                                        <p class="text-muted"><asp:Label ID="lblPaymentMethod" runat="server" Text=""></asp:Label></p>
                                    </div>
                                    <div class="text-center mt-4">
                                        <asp:Button ID="btnPrintReceipt" runat="server" Text="Print Receipt" CssClass="btn btn-primary" OnClientClick="window.print(); return false;" />
                                        <asp:Button ID="btnNewPayment" runat="server" Text="New Payment" CssClass="btn btn-outline-secondary" OnClick="btnNewPayment_Click" />
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>

<asp:HiddenField ID="hdnUserID" runat="server" />
<asp:HiddenField ID="hdnMonth" runat="server" />
<asp:HiddenField ID="hdnYear" runat="server" />
<asp:HiddenField ID="hdnFlatID" runat="server" />  <%-- Add this line --%>
<asp:HiddenField ID="HiddenField1" runat="server" />


</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        function selectPaymentMethod(method) {
            document.getElementById('<%= hdnPaymentMethod.ClientID %>').value = method;

            var cards = document.querySelectorAll('.payment-card');
            cards.forEach(function (card) {
                card.classList.remove('selected');
            });

            event.currentTarget.classList.add('selected');

            document.getElementById('cardPaymentForm').classList.add('hidden');
            document.getElementById('upiPaymentForm').classList.add('hidden');

            if (method === 'creditcard' || method === 'debitcard') {
                document.getElementById('cardPaymentForm').classList.remove('hidden');
            } else if (method === 'paytm' || method === 'gpay') {
                document.getElementById('upiPaymentForm').classList.remove('hidden');
            }
        }

        function validatePayment() {
            var method = document.getElementById('<%= hdnPaymentMethod.ClientID %>').value;
            if (!method) {
                alert('Please select a payment method');
                return false;
            }

            if (method === 'creditcard' || method === 'debitcard') {
                var cardNumber = document.getElementById('<%= txtCardNumber.ClientID %>').value;
                var cardName = document.getElementById('<%= txtCardName.ClientID %>').value;
                var expiry = document.getElementById('<%= txtExpiry.ClientID %>').value;
                var cvv = document.getElementById('<%= txtCVV.ClientID %>').value;

                if (!cardNumber || !cardName || !expiry || !cvv) {
                    alert('Please fill all card details');
                    return false;
                }
            } else if (method === 'paytm' || method === 'gpay') {
                var upiId = document.getElementById('<%= txtUPIId.ClientID %>').value;
                if (!upiId) {
                    alert('Please enter your UPI ID');
                    return false;
                }
            }

            return confirm('Are you sure you want to proceed with the payment?');
        }
    </script>

</asp:Content>
