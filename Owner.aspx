<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Owner.aspx.cs" Inherits="Society_management.Owner" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .col-md-6, .col-md-4 {
            margin-top: 10px;
        }
        .validation-error {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 5px;
        }
        .form-control, .form-select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
        .form-select {
            height: 38px;
        }
        .btn-container {
            margin-top: 20px;
        }
                .validation-error{
                color: firebrick;
    font-size: 14px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 6px;
    margin-left: 5px;
    transition: all 0.3s ease-in-out;
}

    .validation-error::before {
        content: "⚠  ";
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        font-size: 14px;
    }
    </style>

    <script type="text/javascript">
        window.onload = function () {
            var today = new Date().toISOString().substr(0, 10);
            document.getElementById('<%= txtdate.ClientID %>').value = today;
        };
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div style="margin-bottom: 20px; text-align: left;">
<asp:Label ID="lblOwner" runat="server" CssClass="btn btn-primary"><b><a href="Owner.aspx" style="color:black; text-decoration: none;">Add Owner</a></b></asp:Label>
<asp:Label id="lblFlatView" runat="server" CssClass="btn btn-secondary"><b><a href="View_Owner.aspx" style="color:black; text-decoration: none;">View All Owner</a></b></asp:Label>
<asp:Label id="lblHist" runat="server" CssClass="btn btn-info"><b><a  href="#" style="color:black; text-decoration: none; ">Owner History</a></b></asp:Label>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col">
                                <center>
                                    <h4>Add Owner Details</h4>
                                </center>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">
                                <hr />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label>Owner Name</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtname" runat="server" placeholder="Owner Name" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvName" runat="server" 
                                        ControlToValidate="txtname" ErrorMessage="Owner name is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revName" runat="server"
                                        ControlToValidate="txtname" ErrorMessage="Only alphabets and spaces allowed"
                                        ValidationExpression="^[a-zA-Z ]+$" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label>Email</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtEmail" runat="server" placeholder="Email" TextMode="Email" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                        ControlToValidate="txtEmail" ErrorMessage="Email is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                        ControlToValidate="txtEmail" ErrorMessage="Invalid email format"
                                        ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label>Contact Number</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtnumber" runat="server" placeholder="Contact Number" MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvContact" runat="server" 
                                        ControlToValidate="txtnumber" ErrorMessage="Contact number is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revContact" runat="server"
                                        ControlToValidate="txtnumber" ErrorMessage="Invalid phone number (10 digits)"
                                        ValidationExpression="^[0-9]{10}$" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label>Emergency Number</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtE_number" runat="server" placeholder="Emergency Number" MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmergency" runat="server" 
                                        ControlToValidate="txtE_number" ErrorMessage="Emergency number is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revEmergency" runat="server"
                                        ControlToValidate="txtE_number" ErrorMessage="Invalid phone number (10 digits)"
                                        ValidationExpression="^[0-9]{10}$" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                    <asp:CompareValidator ID="cvEmergency" runat="server"
                                        ControlToValidate="txtE_number" ControlToCompare="txtnumber"
                                        Operator="NotEqual" ErrorMessage="Emergency number should be different from contact number"
                                        CssClass="validation-error" Display="Dynamic"></asp:CompareValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label>Block</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlBlock" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="ddlBlock_SelectedIndexChanged">
                                        <asp:ListItem Value="">--Select Block--</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvBlock" runat="server" 
                                        ControlToValidate="ddlBlock" InitialValue="" 
                                        ErrorMessage="Please select block" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label>Flat</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlFlat" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="">--Select Flat--</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvFlat" runat="server" 
                                        ControlToValidate="ddlFlat" InitialValue="" 
                                        ErrorMessage="Please select flat" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label>Total Member</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtmember" runat="server" placeholder="Total Member" TextMode="Number" min="1" max="20" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvMember" runat="server" 
                                        ControlToValidate="txtmember" ErrorMessage="Total member is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="rvMember" runat="server"
                                        ControlToValidate="txtmember" MinimumValue="1" MaximumValue="20"
                                        Type="Integer" ErrorMessage="Members must be between 1-20"
                                        CssClass="validation-error" Display="Dynamic"></asp:RangeValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label>Allotment Date</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtdate" runat="server" placeholder="Allotment Date" Enabled="False" TextMode="Date" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvDate" runat="server" 
                                        ControlToValidate="txtdate" ErrorMessage="Allotment date is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="container">
                            <div class="row justify-content-center btn-container">
                                <div class="col-md-6">
                                    <div class="form-group text-center">
                                        <asp:Button class="btn btn-success btn-block btn-lg" ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        function validateForm() {
            return Page_ClientValidate();
        }
    </script>
</asp:Content>