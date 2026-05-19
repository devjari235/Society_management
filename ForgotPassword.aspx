<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="Society_management.ForgotPassword" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="icon" href="/Images/Logo.png" type="image/png" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Forgot Password - Society Management System</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Playfair+Display:wght@600&display=swap" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            background-color: #f8fafc;
            margin: 0;
            padding: 0;
        }

        /* ── Page wrapper ── */
        .fp-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
            font-family: 'DM Sans', sans-serif;
        }

        /* ── Card ── */
        .fp-card {
            width: 100%;
            max-width: 480px;
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.10);
            overflow: hidden;
            position: relative;
        }

        /* ── Card top accent bar ── */
        .fp-card::before {
            content: '';
            display: block;
            height: 5px;
            background: linear-gradient(90deg, #4e73df, #36b9cc, #8E2DE2);
        }

        .fp-card-body { padding: 40px 40px 36px; }

        /* ── Icon circle ── */
        .fp-icon-wrap {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: linear-gradient(135deg, #eef2ff, #e0e7ff);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            box-shadow: 0 8px 20px rgba(78,115,223,0.15);
        }

        .fp-icon-wrap i { font-size: 1.8rem; color: #4e73df; }

        /* ── Heading ── */
        .fp-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.75rem;
            color: #1e293b;
            text-align: center;
            margin-bottom: 8px;
        }

        .fp-subtitle {
            font-size: 0.9rem;
            color: #64748b;
            text-align: center;
            margin-bottom: 32px;
            line-height: 1.6;
        }

        /* ── Step indicator ── */
        .fp-steps {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0;
            margin-bottom: 32px;
        }

        .fp-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
        }

        .fp-step-circle {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: #e2e8f0;
            color: #94a3b8;
            font-size: 0.85rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }

        .fp-step-label {
            font-size: 0.7rem;
            color: #94a3b8;
            font-weight: 500;
            white-space: nowrap;
        }

        .fp-step.active .fp-step-circle {
            background: #4e73df;
            color: #fff;
            box-shadow: 0 4px 12px rgba(78,115,223,0.35);
        }

        .fp-step.active .fp-step-label { color: #4e73df; }
        .fp-step.done .fp-step-circle { background: #10b981; color: #fff; }
        .fp-step.done .fp-step-label { color: #10b981; }

        .fp-step-line {
            width: 50px;
            height: 2px;
            background: #e2e8f0;
            margin-bottom: 20px;
            transition: background 0.3s;
        }

        .fp-step-line.done { background: #10b981; }

        /* ── Input group ── */
        .fp-input-group { position: relative; margin-bottom: 20px; }
        .fp-input-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .fp-input-group .input-wrap { position: relative; width: 100%; }
        .fp-input-group .input-wrap i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 0.95rem;
            z-index: 5;
        }

        .fp-input-group .fp-input {
            width: 100%;
            padding: 13px 44px 13px 44px; /* Balanced left and right bounds padding */
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 0.95rem;
            color: #1e293b;
            background: #f8fafc;
            transition: all 0.2s;
            outline: none;
            box-sizing: border-box;
        }

        .fp-input-group input:focus {
            border-color: #4e73df;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(78,115,223,0.08);
        }

        /* OTP inputs */
        .otp-group { display: flex; gap: 10px; justify-content: center; margin-bottom: 20px; }
        .otp-input {
            width: 52px;
            height: 56px;
            text-align: center;
            font-size: 1.4rem;
            font-weight: 700;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            background: #f8fafc;
            color: #1e293b;
            outline: none;
            transition: all 0.2s;
        }

        .otp-input:focus {
            border-color: #4e73df;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(78,115,223,0.08);
        }

        .otp-input.filled { border-color: #10b981; background: #f0fdf4; }

        /* ── Method selector ── */
        .method-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 24px; }
        .method-card {
            border: 2px solid #e2e8f0;
            border-radius: 14px;
            padding: 18px 14px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            background: #f8fafc;
            position: relative;
        }

        .method-card:hover { border-color: #4e73df; background: #eef2ff; transform: translateY(-2px); }
        .method-card.selected { border-color: #4e73df; background: #eef2ff; box-shadow: 0 4px 14px rgba(78,115,223,0.15); }
        .method-card i { font-size: 1.6rem; color: #4e73df; margin-bottom: 8px; display: block; }
        .method-card span { font-size: 0.85rem; font-weight: 600; color: #374151; display: block; }
        .method-card small { font-size: 0.75rem; color: #94a3b8; }

        /* ── Primary button ── */
        .fp-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(78,115,223,0.35);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .fp-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(78,115,223,0.4); }

        /* ── Password toggle ── */
        .pw-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #94a3b8;
            cursor: pointer;
            padding: 0;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .error-message { color: #ef4444; font-size: 0.8rem; font-weight: 500; display: none; margin-top: 5px; align-items: center; gap: 4px; }
        
        .fp-success-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            animation: popIn 0.4s ease;
        }
        .fp-success-icon i { font-size: 2rem; color: #10b981; }

        @keyframes popIn {
            0%   { transform: scale(0); opacity: 0; }
            80%  { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }

        .step { display: none; }
        .step.active { display: block; animation: fadeSlide 0.3s ease; }

        @keyframes fadeSlide {
            from { opacity: 0; transform: translateX(20px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        .fp-back, .fp-try-another { text-align: center; margin-top: 15px; }
        .fp-back a, .fp-try-another a { color: #4e73df; font-weight: 600; text-decoration: none; font-size: 0.88rem;}
        
        .resend-row { display: flex; align-items: center; justify-content: space-between; margin-top: 14px; font-size: 0.85rem;}
        .resend-btn { background: none; border: none; color: #4e73df; font-weight: 600; cursor: pointer; padding: 0; }
        .resend-btn:disabled { color: #94a3b8; cursor: not-allowed; }
        .strength-bar { height: 4px; border-radius: 4px; background: #e2e8f0; margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 4px; width: 0%; transition: width 0.3s; }
        .strength-text { font-size: 0.75rem; margin-top: 4px; font-weight: 500; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="fp-page">
            <div class="fp-card">
                <div class="fp-card-body">

                    <div class="fp-steps" id="stepIndicator">
                        <div class="fp-step active" id="stepIndicator1">
                            <div class="fp-step-circle">1</div>
                            <div class="fp-step-label">Identify</div>
                        </div>
                        <div class="fp-step-line" id="line1"></div>
                        <div class="fp-step" id="stepIndicator2">
                            <div class="fp-step-circle">2</div>
                            <div class="fp-step-label">Verify</div>
                        </div>
                        <div class="fp-step-line" id="line2"></div>
                        <div class="fp-step" id="stepIndicator3">
                            <div class="fp-step-circle">3</div>
                            <div class="fp-step-label">Reset</div>
                        </div>
                    </div>

                    <div id="step1" class="step active">
                        <div class="fp-icon-wrap"><i class="fas fa-lock"></i></div>
                        <h2 class="fp-title">Forgot Password?</h2>
                        <p class="fp-subtitle">Enter your registered email address or mobile number to verify your profile account details.</p>

                        <div class="fp-input-group">
                            <label>Email Address or Mobile Number</label>
                            <div class="input-wrap">
                                <i class="fas fa-user"></i>
                                <asp:TextBox ID="txtIdentifier" runat="server" CssClass="fp-input" placeholder="Enter email or mobile number" AutoCompleteType="Disabled" />
                            </div>
                            <div id="identifierError" class="error-message">
                                <i class="fas fa-exclamation-circle me-1"></i>Please enter valid email or mobile number
                            </div>
                            <asp:Label ID="lblIdentifierError" runat="server" ForeColor="Red" Style="font-size:0.8rem; display:block; margin-top:5px;" />
                        </div>
                        
                        <asp:Button ID="btnCheckIdentifier" runat="server" Text="Continue" CssClass="fp-btn" OnClick="btnCheckIdentifier_Click" OnClientClick="return goToStep2();" />
                        
                        <div class="fp-back">
                            <a href="Login.aspx"><i class="fas fa-arrow-left"></i> Back to Login</a>
                        </div>
                    </div>

                    <div id="step2" class="step">
                        <div class="fp-icon-wrap"><i class="fas fa-paper-plane"></i></div>
                        <h2 class="fp-title">Choose Delivery</h2>
                        <p class="fp-subtitle">How would you like to receive your verification code?</p>

                        <div class="method-grid">
                            <div class="method-card selected" id="methodEmail" onclick="selectMethod('Email')">
                                <i class="fas fa-envelope"></i> <span>Email OTP</span> <small id="emailHint">your@email.com</small>
                            </div>
                            <div class="method-card" id="methodSMS" onclick="selectMethod('SMS')">
                                <i class="fas fa-mobile-alt"></i> <span>SMS OTP</span> <small id="smsHint">+91 XXXXX XXXXX</small>
                            </div>
                        </div>
                        
                        <asp:RadioButton ID="rbEmail" runat="server" GroupName="DeliveryMethod" Checked="true" style="display:none;" />
                        <asp:RadioButton ID="rbSMS" runat="server" GroupName="DeliveryMethod" style="display:none;" />

                        <asp:Button ID="btnSendOTP" runat="server" Text="Send OTP" CssClass="fp-btn" OnClick="btnSendOTP_Click" OnClientClick="return prepareOTP()" />
                        <div class="fp-try-another">
                            <a href="#" onclick="goToStep1(); return false;"><i class="fas fa-edit"></i> Change Details</a>
                        </div>
                    </div>

                    <div id="step3" class="step">
                        <div class="fp-icon-wrap"><i class="fas fa-shield-alt"></i></div>
                        <h2 class="fp-title">Verify OTP</h2>
                        <p class="fp-subtitle" id="otpMessage">Enter the verification code sent to your selection.</p>

                        <div class="otp-group" id="otpGroup">
                            <input type="text" class="otp-input" maxlength="1" id="otp1" onkeyup="moveToNext(this, 'otp2')" onkeydown="handleBackspace(event, this, 'otp1')">
                            <input type="text" class="otp-input" maxlength="1" id="otp2" onkeyup="moveToNext(this, 'otp3')" onkeydown="handleBackspace(event, this, 'otp1')">
                            <input type="text" class="otp-input" maxlength="1" id="otp3" onkeyup="moveToNext(this, 'otp4')" onkeydown="handleBackspace(event, this, 'otp2')">
                            <input type="text" class="otp-input" maxlength="1" id="otp4" onkeyup="moveToNext(this, 'otp5')" onkeydown="handleBackspace(event, this, 'otp3')">
                            <input type="text" class="otp-input" maxlength="1" id="otp5" onkeyup="moveToNext(this, 'otp6')" onkeydown="handleBackspace(event, this, 'otp4')">
                            <input type="text" class="otp-input" maxlength="1" id="otp6" onkeyup="moveToNext(this, null)" onkeydown="handleBackspace(event, this, 'otp5')">
                        </div>
                        <asp:HiddenField ID="hdnOTP" runat="server" />
                        <div id="otpError" class="error-message text-center mb-3" style="justify-content:center;">
                            <i class="fas fa-exclamation-circle me-1"></i>Please enter complete 6-digit OTP
                        </div>
                        <asp:Label ID="lblOTPError" runat="server" ForeColor="Red" Style="font-size:0.8rem; display:block; text-align:center; margin-bottom:8px;" />
                        
                        <asp:Button ID="btnVerifyOTP" runat="server" Text="Verify OTP" CssClass="fp-btn" OnClick="btnVerifyOTP_Click" OnClientClick="return collectOTP();" />
                        
                        <div class="resend-row">
                            <span id="timerText">Resend in <strong id="timerCount">60</strong>s</span>
                            <button type="button" class="resend-btn" id="resendBtn" disabled onclick="resendOTP(); return false;"><i class="fas fa-redo-alt"></i> Resend</button>
                        </div>
                    </div>

                    <div id="step4" class="step">
                        <div class="fp-icon-wrap"><i class="fas fa-key"></i></div>
                        <h2 class="fp-title">New Password</h2>
                        <p class="fp-subtitle">Create a strong password for your account.</p>

                        <div class="fp-input-group">
                            <label>New Password</label>
                            <div class="input-wrap">
                                <i class="fas fa-lock"></i>
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="fp-input" placeholder="Enter new password" onkeyup="checkStrength(this.value)" />
                                <button type="button" class="pw-toggle" onclick="togglePw('txtNewPassword',this)"><i class="fas fa-eye-slash"></i></button>
                            </div>
                            <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                            <div class="strength-text" id="strengthText"></div>
                            <div id="pwError" class="error-message"><i class="fas fa-exclamation-circle me-1"></i>Password must be at least 8 characters</div>
                        </div>
                        <div class="fp-input-group">
                            <label>Confirm Password</label>
                            <div class="input-wrap">
                                <i class="fas fa-lock"></i>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="fp-input" placeholder="Confirm new password" />
                                <button type="button" class="pw-toggle" onclick="togglePw('txtConfirmPassword',this)"><i class="fas fa-eye-slash"></i></button>
                            </div>
                            <div id="confirmError" class="error-message"><i class="fas fa-exclamation-circle me-1"></i>Passwords do not match</div>
                        </div>
                        <asp:Label ID="lblResetError" runat="server" ForeColor="Red" style="font-size:0.8rem; display:block; margin-bottom:10px;" />
                        <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="fp-btn" OnClick="btnResetPassword_Click" OnClientClick="return validatePasswords();" />
                    </div>

                    <div id="step5" class="step">
                        <div class="text-center">
                            <div class="fp-success-icon"><i class="fas fa-check"></i></div>
                            <h2 class="fp-title" style="color:#10b981;">Password Reset Successful!</h2>
                            <p class="fp-subtitle">Your password has been updated. You can now login with your new password.</p>
        
                            <asp:LinkButton ID="lnkGoToLogin" runat="server" CssClass="fp-btn" Style="text-decoration:none;" OnClick="lnkGoToLogin_Click">
                                <i class="fas fa-sign-in-alt"></i> Go to Login
                            </asp:LinkButton>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <asp:HiddenField ID="hdnIdentifier" runat="server" />
        <asp:HiddenField ID="hdnMethod" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnCurrentStep" runat="server" />

        <script>
            var timerInterval = null;

            window.addEventListener('DOMContentLoaded', function () {
                var stepHdn = document.getElementById('<%= hdnCurrentStep.ClientID %>');
                var step = stepHdn ? parseInt(stepHdn.value) || 1 : 1;
                showStep(step);

                var methodHdn = document.getElementById('hdnMethod');
                if (methodHdn && methodHdn.value) {
                    selectMethod(methodHdn.value);
                }

                var id = document.getElementById('<%= hdnIdentifier.ClientID %>').value;
                if (id && step === 2) setHints(id);
                if (step === 3) startTimer();
            });

            function goToStep1() {
                showStep(1);
                document.getElementById('<%= hdnCurrentStep.ClientID %>').value = '1';
            }

            function goToStep2() {
                var identifier = document.getElementById('<%= txtIdentifier.ClientID %>').value.trim();
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                var mobileRegex = /^[6-9]\d{9}$/;

                if (!identifier) {
                    showError('identifierError', 'Please enter email or mobile number');
                    return false;
                }

                if (!emailRegex.test(identifier) && !mobileRegex.test(identifier)) {
                    showError('identifierError', 'Please enter valid email or 10-digit mobile number');
                    return false;
                }

                hideError('identifierError');
                document.getElementById('<%= hdnIdentifier.ClientID %>').value = identifier;
                return true;
            }

            function setHintsFromCodeBehind(maskedEmail, maskedSMS) {
                var emailHint = document.getElementById('emailHint');
                var smsHint = document.getElementById('smsHint');
                
                if (emailHint) emailHint.textContent = maskedEmail;
                if (smsHint) smsHint.textContent = maskedSMS;
                
                if(maskedEmail !== "N/A") {
                    selectMethod('Email');
                } else {
                    selectMethod('SMS');
                }
            }

            function showStep(step) {
                for (var i = 1; i <= 5; i++) {
                    var el = document.getElementById('step' + i);
                    if (el) el.classList.remove('active');
                }
                var activeEl = document.getElementById('step' + step);
                if (activeEl) activeEl.classList.add('active');
                updateStepsIndicator(step);
                document.getElementById('<%= hdnCurrentStep.ClientID %>').value = step;
            }

            function updateStepsIndicator(step) {
                var stepMap = { 1: 1, 2: 1, 3: 2, 4: 3, 5: 3 };
                var active = stepMap[step] || 1;
                for (var i = 1; i <= 3; i++) {
                    var s = document.getElementById('stepIndicator' + i);
                    if (!s) continue;
                    s.classList.remove('active', 'done');
                    if (i < active) s.classList.add('done');
                    else if (i === active) s.classList.add('active');
                }
                for (var j = 1; j <= 2; j++) {
                    var l = document.getElementById('line' + j);
                    if (!l) continue;
                    l.classList.toggle('done', j < active);
                }
            }

            function selectMethod(method) {
                document.getElementById('methodEmail').classList.toggle('selected', method === 'Email');
                document.getElementById('methodSMS').classList.toggle('selected', method === 'SMS');
                document.getElementById('hdnMethod').value = method;
                
                if(method === 'Email') {
                    document.getElementById('<%= rbEmail.ClientID %>').checked = true;
                } else {
                    document.getElementById('<%= rbSMS.ClientID %>').checked = true;
                }

                var btn = document.getElementById('<%= btnSendOTP.ClientID %>');
                if (btn) btn.value = 'Send OTP via ' + method;
            }

            function prepareOTP() { return true; }

            function moveToNext(current, nextId) {
                current.value = current.value.replace(/[^0-9]/g,'');
                if (current.value.length === 1 && nextId) {
                    current.classList.add('filled');
                    document.getElementById(nextId).focus();
                } else if(current.value.length === 1) {
                    current.classList.add('filled');
                } else {
                    current.classList.remove('filled');
                }
                collectOTP();
            }

            function handleBackspace(event, current, prevId) {
                if (event.key === 'Backspace' && current.value.length === 0 && prevId) {
                    current.classList.remove('filled');
                    document.getElementById(prevId).focus();
                }
            }

            function collectOTP() {
                var otp = '';
                for (var i = 1; i <= 6; i++) {
                    var val = document.getElementById('otp' + i).value;
                    if (val) otp += val;
                }
                document.getElementById('<%= hdnOTP.ClientID %>').value = otp;

                if (otp.length === 6) {
                    document.getElementById('otpError').style.display = 'none';
                    return true;
                }
                return false;
            }

            function startTimer() {
                var count = 60;
                var countEl = document.getElementById('timerCount');
                var resendBtn = document.getElementById('resendBtn');
                var timerText = document.getElementById('timerText');
                if (resendBtn) resendBtn.disabled = true;
                if (timerText) timerText.style.display = 'inline';

                clearInterval(timerInterval);
                timerInterval = setInterval(function () {
                    count--;
                    if (countEl) countEl.textContent = count;
                    if (count <= 0) {
                        clearInterval(timerInterval);
                        if (resendBtn) resendBtn.disabled = false;
                        if (timerText) timerText.style.display = 'none';
                    }
                }, 1000);
            }

            function resendOTP() {
                var method = document.getElementById('<%= rbEmail.ClientID %>').checked ? 'Email' : 'SMS';
                document.getElementById('<%= hdnMethod.ClientID %>').value = method;
                document.getElementById('<%= btnSendOTP.ClientID %>').click();
            }

            function togglePw(fieldId, btn) {
                var field = document.getElementById('<%= txtNewPassword.ClientID %>');
                if (fieldId === 'txtConfirmPassword') {
                    field = document.getElementById('<%= txtConfirmPassword.ClientID %>');
                }
                var icon = btn.querySelector('i');
                if (field.type === 'password') {
                    field.type = 'text';
                    icon.classList.replace('fa-eye-slash', 'fa-eye');
                } else {
                    field.type = 'password';
                    icon.classList.replace('fa-eye', 'fa-eye-slash');
                }
            }

            function checkStrength(pw) {
                var fill = document.getElementById('strengthFill');
                var text = document.getElementById('strengthText');
                var score = 0;
                if (pw.length >= 8) score++;
                if (/[A-Z]/.test(pw)) score++;
                if (/[0-9]/.test(pw)) score++;
                if (/[^A-Za-z0-9]/.test(pw)) score++;

                var colors = ['#e2e8f0', '#ef4444', '#f59e0b', '#3b82f6', '#10b981'];
                var labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];

                fill.style.width = (score * 25) + '%';
                fill.style.background = colors[score];
                text.textContent = labels[score];
                text.style.color = colors[score];
            }

            function validatePasswords() {
                var pw = document.getElementById('<%= txtNewPassword.ClientID %>').value;
                var cpw = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;
                var isValid = true;

                if (pw.length < 8) {
                    document.getElementById('pwError').style.display = 'flex';
                    isValid = false;
                } else {
                    document.getElementById('pwError').style.display = 'none';
                }

                if (pw !== cpw) {
                    document.getElementById('confirmError').style.display = 'flex';
                    isValid = false;
                } else {
                    document.getElementById('confirmError').style.display = 'none';
                }

                return isValid;
            }

            function showError(elementId, message) {
                var el = document.getElementById(elementId);
                el.innerHTML = '<i class="fas fa-exclamation-circle me-1"></i>' + message;
                el.style.display = 'flex';
                setTimeout(function () { el.style.display = 'none'; }, 4000);
            }

            function hideError(elementId) {
                var el = document.getElementById(elementId);
                if (el) el.style.display = 'none';
            }
        </script>
    </form>
</body>
</html>