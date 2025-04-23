<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Society_management.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Society Management - Login</title>
  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --primary-color: #4a6bff;
      --white: #ffffff;
      --dark: #1e293b;
      --light-bg: rgba(255, 255, 255, 0.1);
      --border-color: rgba(255, 255, 255, 0.2);
      --text-color: #f8fafc;
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
      background: url('Images/l_bg.jpg') no-repeat center center;
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
      -webkit-backdrop-filter: blur(20px); /* Safari support */
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
      border: none;
      outline: none;
      border: 2px solid var(--border-color);
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
      background: rgba(0, 0, 0, 0.5);
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
      background: var(--white);
      border: none;
      outline: none;
      border-radius: 40px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      cursor: pointer;
      font-size: 16px;
      color: var(--dark);
      font-weight: 600;
      transition: all 0.3s;
    }

    .login-button:hover {
      background: rgba(255, 255, 255, 0.9);
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

    /* Checkbox styling */
    input[type="checkbox"] {
      accent-color: var(--primary-color);
      width: 16px;
      height: 16px;
      cursor: pointer;
    }

    /* Responsive design */
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
</head>
<body>
  <form id="form1" runat="server">
    <div class="wrapper">
      <h2 style="color:black">Admin Login</h2>

      <div class="input-field">
        <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" placeholder=" " AutoCompleteType="Disabled"></asp:TextBox>
        <label for="txtEmail">Email Address</label>
        <i class="fas fa-envelope"></i>
      </div>

      <div class="input-field">
        <asp:TextBox ID="txtPassword" runat="server" CssClass="textbox" TextMode="Password" placeholder=" "></asp:TextBox>
        <label for="txtPassword">Password</label>
        <i class="fas fa-lock"></i>
      </div>

      <div class="forget">
        <label for="chkRemember">
          <asp:CheckBox ID="chkRemember" runat="server" />
          <p>Remember me</p>
        </label>
        <a href="ForgotPassword.aspx">Forgot password?</a>
      </div>

      <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login-button" />

      <div class="register">
        <p>Not a member? <a href="A_registration.aspx" style="color:black">Create account</a></p>
      </div>
    </div>
  </form>
</body>
</html>
