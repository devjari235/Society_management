<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="Society_management.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
      .asp-validation {
    color: firebrick;
    font-size: 14px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 6px;
    margin-left: 5px;
    transition: all 0.3s ease-in-out;
}

    .asp-validation::before {
        content: "⚠  ";
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        font-size: 14px;
    }
    .custom-link {
    color: #007bff;
    text-decoration: none;
    font-weight: 600;
    transition: color 0.3s ease;
}

.custom-link:hover {
    color: #0056b3;
    text-decoration: underline;
}
   #btnUpdate{
       margin-top:10px;
   }

    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="margin-top: 3%; margin-bottom: 5%">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <h3 class="mt-3">Change Password</h3>
                            <hr class="my-3" />
                        </div>

                        <div class="mb-3">
                            <label for="txtCurrent" class="form-label">Current Password</label>
                            <asp:TextBox CssClass="form-control" ID="txtCurrent" runat="server" placeholder="Current Password" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator CssClass="asp-validation" ID="rfvCurrent" runat="server" 
                                ControlToValidate="txtCurrent" ErrorMessage="Current password is required" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="mb-3">
                            <label for="txtnewpass" class="form-label">New Password</label>
                            <asp:TextBox CssClass="form-control" ID="txtnewpass" runat="server" placeholder="New Password" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator CssClass="asp-validation" ID="rfvNewPass" runat="server" 
                                ControlToValidate="txtnewpass" ErrorMessage="New password is required" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator CssClass="asp-validation" ID="revPassword" runat="server" 
                                ControlToValidate="txtnewpass" Display="Dynamic" 
                                ErrorMessage="Password must be at least 8 characters with at least one uppercase, one lowercase, one number and one special character"
                                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{8,}$"></asp:RegularExpressionValidator>
                        </div>

                        <div class="mb-4">
                            <label for="txtCpass" class="form-label">Confirm Password</label>
                            <asp:TextBox CssClass="form-control" ID="txtCpass" runat="server" placeholder="Confirm Password" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator CssClass="asp-validation" ID="rfvConfirmPass" runat="server" 
                                ControlToValidate="txtCpass" ErrorMessage="Please confirm your password" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CompareValidator CssClass="asp-validation" ID="cvPasswords" runat="server" 
                                ControlToValidate="txtCpass" ControlToCompare="txtnewpass" 
                                ErrorMessage="Passwords do not match" Display="Dynamic"></asp:CompareValidator>
                        </div>
                        <div class="text-start mt-2">
                            <a href="EmailSend.aspx" class="custom-link"><b>Try another way</b></a>
                            <br />
                            <br />
                        </div>
                        <div class="d-grid gap-2">
                            <asp:Button class="btn btn-primary btn-lg" ID="btnUpdate" runat="server" Text="Update Password" OnClick="btnUpdate_Click" />
                            <asp:HyperLink ID="hlCancel" runat="server" CssClass="btn btn-outline-secondary btn-lg" NavigateUrl="AdminDashboard.aspx">Cancel</asp:HyperLink>
                        </div>
                        
                        <div class="mt-3 text-center">
                            <asp:Label ID="lblMessage" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
                            <asp:Label ID="lblSuccess" runat="server" CssClass="text-success" Visible="false"></asp:Label>
                        </div>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        // Client-side script if needed
        function validateForm() {
            // Additional client-side validation can be added here
            return true;
        }
    </script>
</asp:Content>