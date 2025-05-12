<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePassOtp.aspx.cs" Inherits="Society_management.ChangePassOtp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <title></title>
    <style>
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
    #btnUpdate{
        margin-top:10px;
    }

    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

</head>
<body>
<form method="post" runat="server"> 
    <div class="container" style="margin-top: 7%; margin-bottom: 5%">
     <div class="row justify-content-center">
         <div class="col-md-8 col-lg-6">
             <div class="card shadow">
                 <div class="card-body p-4">
                     <div class="text-center mb-4">
                         <h3 class="mt-3">Change Password</h3>
                         <hr class="my-3" />
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
                        <div>
                        <a href="ChangePassword.aspx" style="text-decoration:none; color:blue"><b>Try another way</b></a>
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
</form>
</body>
</html>
