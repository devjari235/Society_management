<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Flat.aspx.cs" Inherits="Society_management.Flat" %>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
 <link href="fontawesome\css\all.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div style="margin-bottom: 20px; text-align: left;">
<%--        <a href="Flat.aspx" style="color:white; text-decoration: none;"><asp:Label ID="lblFlat" runat="server" CssClass="btn btn-primary"><b><i class="bi bi-house-add-fill"></i> Add Flat</b></asp:Label></a>--%>
        <a href="View_flat.aspx" style="color:white; text-decoration: none;"><asp:Label id="lblFlatView" runat="server" CssClass="btn btn-secondary"><b><i class="bi bi-eye-fill"></i> View All Flats</b></asp:Label></a>
        <a  href="#" style="color:white; text-decoration: none; "><asp:Label id="lblHist" runat="server" CssClass="btn btn-info"><b style="color:white;"><i class="fa fa-history"></i> Flat History</b></asp:Label></a>
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
                                    <h4>Add Flat</h4>
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
                                <label>Flat No</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtFno" runat="server" placeholder="Flat No" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFlatNo" runat="server" 
                                        ControlToValidate="txtFno" ErrorMessage="Flat number is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revFlatNo" runat="server" 
                                        ControlToValidate="txtFno" ErrorMessage="Only numbers allowed" 
                                        ValidationExpression="^\d+$" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label>Floor</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtFloor" runat="server" placeholder="Floor" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFloor" runat="server" 
                                        ControlToValidate="txtFloor" ErrorMessage="Floor is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revFloor" runat="server" 
                                        ControlToValidate="txtFloor" ErrorMessage="Only numbers allowed" 
                                        ValidationExpression="^\d+$" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label>Flat Type</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="0">--Select Flat Type--</asp:ListItem>
                                        <asp:ListItem>Studio Apartment</asp:ListItem>
                                        <asp:ListItem>1 BHK</asp:ListItem>
                                        <asp:ListItem>2 BHK</asp:ListItem>
                                        <asp:ListItem>3 BHK</asp:ListItem>
                                        <asp:ListItem>4 BHK and above</asp:ListItem>
                                        <asp:ListItem>Duplex</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvFlatType" runat="server" 
                                        ControlToValidate="ddlType" InitialValue="0" 
                                        ErrorMessage="Please select flat type" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label>Sqft</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtsqft" runat="server" placeholder="Sqft" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvSqft" runat="server" 
                                        ControlToValidate="txtsqft" ErrorMessage="Sqft is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revSqft" runat="server" 
                                        ControlToValidate="txtsqft" ErrorMessage="Only numbers allowed" 
                                        ValidationExpression="^\d+$" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label>Occupancy status</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlstatus" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="0">--Select Status--</asp:ListItem>
                                        <asp:ListItem>Rental</asp:ListItem>
                                        <asp:ListItem>Self occupy</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvOccupancy" runat="server" 
                                        ControlToValidate="ddlstatus" InitialValue="0" 
                                        ErrorMessage="Please select occupancy status" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <label>Maintenance</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtMentanance" runat="server" placeholder="Maintenance" AutoCompleteType="Disabled"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvMaintenance" runat="server" 
                                        ControlToValidate="txtMentanance" ErrorMessage="Maintenance is required" 
                                        CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revMaintenance" runat="server" 
                                        ControlToValidate="txtMentanance" ErrorMessage="Only numbers allowed" 
                                        ValidationExpression="^\d+(\.\d{1,2})?$" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label>Block</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlBlock" runat="server" CssClass="form-select"></asp:DropDownList>
<asp:RequiredFieldValidator ID="rfvBlock" runat="server" 
    ControlToValidate="ddlBlock" InitialValue="" 
    ErrorMessage="Please select block" 
    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <div class="row justify-content-center btn-container">
                            <div class="col-md-6">
                                <div class="form-group text-center">
                                    <asp:Button class="btn btn-success btn-block btn-lg" ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" />
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
            // Client-side validation can be added here if needed
            return Page_ClientValidate();
        }
    </script>
</asp:Content>