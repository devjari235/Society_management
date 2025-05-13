<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="U_EmailSend.aspx.cs" Inherits="Society_management.U_EmailSend" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server"> 
    <title>Send Email OTP</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        
        form {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
        }
        
        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        
        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="email"]:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }
        
        .btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            width: 100%;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #2980b9;
        }
        
        .message {
            text-align: center;
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
        }
        
        .success {
            color: #27ae60;
            background-color: rgba(39, 174, 96, 0.1);
        }
        
        .error {
            color: #e74c3c;
            background-color: rgba(231, 76, 60, 0.1);
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
    <form id="form1" runat="server">
        <h2>Send OTP to Email</h2>
        
        <div class="form-group">
            <asp:Label ID="lblEmail" runat="server" Text="Email Address:" AssociatedControlID="txtEmail"></asp:Label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email address" AutoCompleteType="Disabled"></asp:TextBox>
        </div>

        <asp:Button ID="btnSendOtp" runat="server" Text="Send OTP" OnClick="btnSendOtp_Click" CssClass="btn" />
        
        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
    </form>
</body>
</html>