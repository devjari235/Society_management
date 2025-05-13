<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerifyOtpUser.aspx.cs" Inherits="Society_management.VerifyOtpUser" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP</title>
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
        
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
        }
        
        h2 {
            color: #2c3e50;
            margin-bottom: 25px;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 25px;
            text-align: center;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        
        strong {
            color: #3498db;
            font-weight: 600;
        }
        
        .otp-container {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
        }
        
        .otp-input {
            width: 45px;
            height: 45px;
            text-align: center;
            font-size: 20px;
            font-weight: 600;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin: 0 5px;
            transition: all 0.3s;
        }
        
        .otp-input:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }
        
        .btn {
            background-color: #27ae60;
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
            background-color: #219653;
        }
        
        .message {
            display: block;
            margin-top: 20px;
            padding: 12px;
            border-radius: 6px;
            font-weight: 500;
        }
        
        .error {
            color: #e74c3c;
            background-color: rgba(231, 76, 60, 0.1);
        }
        
        .success {
            color: #27ae60;
            background-color: rgba(39, 174, 96, 0.1);
        }
        
        .otp-hint {
            font-size: 14px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        .email-display {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 15px;
        }
        
        .hidden-otp {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Verify OTP</h2>
            
            <div class="email-display">
                Enter OTP sent to: <strong><%= Session["EmailToVerify"] %></strong>
            </div>
            
            <div class="form-group">
                <div class="otp-container" id="otpContainer">
                    <input type="text" maxlength="1" class="otp-input" data-index="1" oninput="moveToNext(this, 2)" onkeydown="moveToPrevious(event, this, 1)" />
                    <input type="text" maxlength="1" class="otp-input" data-index="2" oninput="moveToNext(this, 3)" onkeydown="moveToPrevious(event, this, 2)" />
                    <input type="text" maxlength="1" class="otp-input" data-index="3" oninput="moveToNext(this, 4)" onkeydown="moveToPrevious(event, this, 3)" />
                    <input type="text" maxlength="1" class="otp-input" data-index="4" oninput="moveToNext(this, 5)" onkeydown="moveToPrevious(event, this, 4)" />
                    <input type="text" maxlength="1" class="otp-input" data-index="5" oninput="moveToNext(this, 6)" onkeydown="moveToPrevious(event, this, 5)" />
                    <input type="text" maxlength="1" class="otp-input" data-index="6" oninput="moveToNext(this, 6)" onkeydown="moveToPrevious(event, this, 6)" />
                </div>
                <asp:HiddenField ID="txtOtp" runat="server" ClientIDMode="Static" />
                <div class="otp-hint">Please enter the 6-digit code sent to your email</div>
            </div>
            
            <asp:Button ID="btnVerifyOtp" runat="server" Text="Verify OTP" OnClick="btnVerifyOtp_Click" CssClass="btn" OnClientClick="return collectOtp();" />
            
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
        </div>
    </form>

    <script>
        function moveToNext(current, nextIndex) {
            if (current.value.length === 1) {
                // Only allow numeric input
                current.value = current.value.replace(/\D/g, '');
                
                if (nextIndex <= 6) {
                    const nextInput = document.querySelector(`.otp-input[data-index="${nextIndex}"]`);
                    if (nextInput) {
                        nextInput.focus();
                    }
                }
            }
            updateHiddenOtp();
        }

        function moveToPrevious(event, current, currentIndex) {
            if (event.key === 'Backspace' && current.value.length === 0 && currentIndex > 1) {
                const prevInput = document.querySelector(`.otp-input[data-index="${currentIndex - 1}"]`);
                if (prevInput) {
                    prevInput.focus();
                }
            }
            updateHiddenOtp();
        }

        function updateHiddenOtp() {
            const otpInputs = document.querySelectorAll('.otp-input');
            let otpValue = '';
            otpInputs.forEach(input => {
                otpValue += input.value;
            });
            document.getElementById('txtOtp').value = otpValue;
        }

        function collectOtp() {
            updateHiddenOtp();
            const otpValue = document.getElementById('txtOtp').value;
            if (otpValue.length !== 6) {
                alert('Please enter a complete 6-digit OTP code');
                return false;
            }
            return true;
        }

        // Auto-focus first input on page load
        document.addEventListener('DOMContentLoaded', function() {
            const firstInput = document.querySelector('.otp-input[data-index="1"]');
            if (firstInput) {
                firstInput.focus();
            }
        });
    </script>
</body>
</html>
