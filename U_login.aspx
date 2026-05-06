<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="U_login.aspx.cs" Inherits="Society_management.U_login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Society Management - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function togglePassword() {
            var passwordInput = document.getElementById("txtPassword");
            var icon = document.getElementById("toggleIcon");

            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            } else {
                passwordInput.type = "password";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            }
        }
    </script>
  <style>
    :root {
      --primary-color: #000000;
      --white: #000000;
      --dark: #000000;
      --light-bg: rgba(0, 0, 0, 0.05);
      --border-color: #000000;
      --text-color: #000000;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Poppins', sans-serif;
    }

    body {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background: url('Images/U_bg.jpg') no-repeat center center;
      background-size: cover;
      background-blend-mode: overlay;
      color: var(--text-color);
    }

    .wrapper {
      width: 100%;
      max-width: 420px;
      background: var(--light-bg);
      border: 2px solid var(--border-color);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
      color: var(--white);
      border-radius: 12px;
      padding: 30px;
      margin: 20px;
      transition: all 0.3s ease;
    }

    .wrapper:hover {
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    }

    .wrapper h2 {
      font-size: 28px;
      text-align: center;
      margin-bottom: 30px;
      font-weight: 600;
    }

    .input-field {
      position: relative;
      width: 100%;
      height: 50px;
      margin: 25px 0;
    }

    .input-field .textbox {
      width: 100%;
      height: 100%;
      background: transparent;
      border: 2px solid var(--border-color);
      outline: none;
      border-radius: 40px;
      font-size: 16px;
      color: var(--white);
      padding: 20px 45px 20px 20px;
      transition: all 0.3s;
    }

    .input-field .textbox:focus {
      border-color: var(--white);
    }

    .input-field .textbox::placeholder {
      color: transparent;
    }

    .input-field i {
      position: absolute;
      right: 20px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--white);
      font-size: 16px;
    }

    .input-field label {
      position: absolute;
      top: 50%;
      left: 20px;
      transform: translateY(-50%);
      font-size: 16px;
      color: var(--white);
      pointer-events: none;
      transition: all 0.3s;
    }

    .input-field .textbox:focus ~ label,
    .input-field .textbox:not(:placeholder-shown) ~ label {
      top: 0;
      left: 20px;
      font-size: 12px;
      background: rgba(0, 0, 0, 0.1);
      padding: 0 6px;
      border-radius: 10px;
    }

    .forget {
      display: flex;
      justify-content: space-between;
      font-size: 14px;
      margin: 20px 0 25px;
    }

    .forget label {
      display: flex;
      align-items: center;
      gap: 5px;
      cursor: pointer;
    }

    .forget a {
      color: var(--white);
      text-decoration: none;
      transition: all 0.3s;
    }

    .forget a:hover {
      color: var(--primary-color);
      text-decoration: underline;
    }

    .login-button {
      width: 100%;
      height: 45px;
      background: #000000;
      border: none;
      outline: none;
      border-radius: 40px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      cursor: pointer;
      font-size: 16px;
      color: #ffffff;
      font-weight: 600;
      transition: all 0.3s;
    }

    .login-button:hover {
      background: #222222;
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
    }

    .register {
      text-align: center;
      margin-top: 25px;
      font-size: 14px;
    }

    .register p {
      color: var(--white);
    }

    .register a {
      color: var(--primary-color);
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s;
    }

    .register a:hover {
      text-decoration: underline;
    }

    input[type="checkbox"] {
      accent-color: var(--primary-color);
      width: 16px;
      height: 16px;
      cursor: pointer;
    }

    .asp-validation {
      color: #FFD700;
      font-size: 0.85rem;
      font-weight: 500;
      display: block;
      margin-top: 3px;
      transition: all 0.3s;
    }

    .asp-validation::before {
      content: "⚠ ";
      font-size: 0.85rem;
      margin-right: 4px;
    }

    .asp-validation.shake {
      animation: shake 0.3s ease-in-out 1;
    }

    @keyframes shake {
      0% { transform: translateX(0); }
      25% { transform: translateX(-4px); }
      50% { transform: translateX(4px); }
      75% { transform: translateX(-4px); }
      100% { transform: translateX(0); }
    }

    @media (max-width: 480px) {
      .wrapper {
        padding: 25px;
        margin: 15px;
      }

      .wrapper h2 {
        font-size: 24px;
      }

      .input-field {
        height: 45px;
        margin: 20px 0;
      }
    }
  </style>
    <script>
        history.pushState(null, null, location.href);

        window.onpopstate = function () {
            // 🔁 If back button is clicked, force redirect to login
            window.location.href = "U_logout.aspx";
        };
    </script>
</head>
<body>
  <form id="form1" runat="server">
    <div class="wrapper">
      <h2>Member Login</h2>

      <!-- Email -->
      <div class="input-field">
        <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" placeholder=" " AutoCompleteType="Disabled"></asp:TextBox>
        <label for="txtEmail" style="color:white">Email Or Mobile Number</label>

        <i class="fas fa-envelope"></i>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmail" Display="Dynamic" ErrorMessage="Please Enter Valid Email ID or Phone Number" CssClass="asp-validation" SetFocusOnError="True" />
      </div>

      <!-- Password -->
      <div class="input-field">
        <asp:TextBox ID="txtPassword" runat="server" CssClass="textbox" TextMode="Password" placeholder=" "></asp:TextBox>
        <label for="txtPassword" style="color:white">Password</label>
        <span  onclick="togglePassword()" style="cursor: pointer;">
            <i class="bi bi-eye-slash" id="toggleIcon"></i>
            </span>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ErrorMessage="Enter Your Login Password" CssClass="asp-validation" SetFocusOnError="True" />
      </div>

      <div class="forget">
        <a href="ForgotPassword.aspx">Forgot password?</a>
      </div>

      <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login-button" OnClick="btnLogin_Click" />

      <div class="register">
        <p>Not a member? <a href="U_registration.aspx" style="color:white">Create account</a></p>
      </div>
    </div>
  </form>
</body>
</html>
