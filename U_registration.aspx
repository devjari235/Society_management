<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="U_registration.aspx.cs" Inherits="Society_management.U_registration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Member Registration - Society Management</title>
    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

    <style>
     body {
    margin: 0;
    padding: 0;
    background: linear-gradient(
        rgba(0, 0, 0, 0.3),
        rgba(0, 0, 0, 0.3)
    ), url('Images/regis.jpg') no-repeat center center fixed;
    background-size: cover;
    font-family: 'Poppins', sans-serif;
    position: relative;
}

.register-container {
    background: rgba(255, 255, 255, 0.9);
    max-width: 720px;
    margin: 60px auto;
    padding: 40px 35px;
    border-radius: 18px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    animation: fadeIn 0.8s ease;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

h2 {
    text-align: center;
    font-weight: 600;
    margin-bottom: 30px;
    color: #333;
}

.form-label {
    font-weight: 500;
    color: #222;
}

.form-control,
.form-select {
    border-radius: 10px;
    border: 1px solid #ccc;
}

.form-control:focus,
.form-select:focus {
    border-color: #4a6bff;
    box-shadow: 0 0 5px rgba(74, 107, 255, 0.5);
}

.btn-primary {
    width: 100%;
    border-radius: 12px;
    padding: 10px;
    background-color: #4a6bff;
    border: none;
    font-weight: 500;
    transition: 0.3s ease;
}

.btn-primary:hover {
    background-color: #3452cc;
}

.text-center {
    color: #555;
}

@media (max-width: 576px) {
    .register-container {
        padding: 25px 20px;
    }

    h2 {
        font-size: 24px;
    }
}

    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function validateForm() {
            var password = document.getElementById('<%= txtPassword.ClientID %>').value;
            if (password.length < 6) {
                alert('Password must be at least 6 characters long.');
                return false;
            }
            return true;
        }
    </script>
    
    <script>
        function validateForm() {
            var password = document.getElementById('<%= txtPassword.ClientID %>').value;
            if (password.length < 6) {
                alert('Password must be at least 6 characters long.');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" onsubmit="return validateForm()">
        <div class="register-container">
            <h2>Member Registration</h2>
            
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" required AutoCompleteType="Disabled"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" TextMode="Phone" required AutoCompleteType="Disabled"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required AutoCompleteType="Disabled"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Gender</label>
                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select" required>
                    <asp:ListItem Text="Select Gender" Value="" />
                    <asp:ListItem Text="Male" Value="Male" />
                    <asp:ListItem Text="Female" Value="Female" />
                    <asp:ListItem Text="Other" Value="Other" />
                </asp:DropDownList>
            </div>

            <div class="mb-3">
                <label class="form-label">Age</label>
                <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" TextMode="Number" required AutoCompleteType="Disabled"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Marital Status</label>
                <asp:DropDownList ID="ddlMarital" runat="server" CssClass="form-select" required>
                    <asp:ListItem Text="Select Status" Value="" />
                    <asp:ListItem Text="Single" Value="Single" />
                    <asp:ListItem Text="Married" Value="Married" />
                    <asp:ListItem Text="Divorced" Value="Divorced" />
                    <asp:ListItem Text="Widowed" Value="Widowed" />
                </asp:DropDownList>
            </div>

            <div class="mb-3">
                <label class="form-label">Photo</label>
                <asp:FileUpload ID="filePhoto" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" required></asp:TextBox>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary" OnClick="btnRegister_Click" />
        </div>
    </form>

</body>
</html>

