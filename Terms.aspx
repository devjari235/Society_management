<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Terms.aspx.cs" Inherits="Society_management.Terms" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Terms of Service - Society Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #f7f7f7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .terms-container {
            margin-top: 60px;
            margin-bottom: 60px;
        }
        .card {
            border-radius: 20px;
            border: none;
        }
        .card h1 {
            font-size: 2.5rem;
            color: #333;
        }
        .card h4 {
            margin-top: 30px;
            font-weight: 600;
            color: #0056b3;
        }
        .card ul {
            padding-left: 20px;
        }
        .card p, .card li {
            font-size: 1.05rem;
            color: #555;
        }
        .btn-primary {
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid terms-container px-3">
            <div class="card shadow-sm p-5">
                <h1 class="mb-4">Terms of Service</h1>

                <p>Welcome to our Society Management System. By accessing or using this platform, you agree to the following terms and conditions designed to ensure a safe, respectful, and transparent experience for all users.</p>

                <h4>1. User Responsibilities</h4>
                <ul>
                    <li>All users are required to provide accurate and truthful personal information during registration and profile updates.</li>
                    <li>Administrative features are strictly restricted to authorized committee members and security personnel.</li>
                    <li>Residents should use complaint forms, suggestions, and helpdesk features responsibly without misuse or repeated spam.</li>
                    <li>All communication must be respectful and appropriate, whether through notices, group chat, or personal messages.</li>
                </ul>

                <h4>2. Data Collection and Usage</h4>
                <ul>
                    <li>We collect personal data such as name, flat number, email, mobile number, and vehicle details for verification and internal use only.</li>
                    <li>Usage data such as logins, service requests, and event participation may also be recorded to improve functionality.</li>
                    <li>All collected data is stored securely and used only for society operations such as maintenance billing, visitor tracking, and emergency alerts.</li>
                    <li>No data is shared with third parties unless explicitly permitted by the user or required by law.</li>
                </ul>

                <h4>3. Acceptable Conduct</h4>
                <ul>
                    <li>Harassment, hate speech, discrimination, or threats towards other users will not be tolerated.</li>
                    <li>Uploading or sharing offensive, misleading, or illegal content is strictly prohibited.</li>
                    <li>Users must not attempt to bypass system security or access restricted features without permission.</li>
                    <li>Group messaging and forums are monitored for compliance and may be moderated as needed.</li>
                </ul>

                <h4>4. Account Suspension or Termination</h4>
                <ul>
                    <li>Accounts may be suspended or permanently banned for violating any of these terms, including inappropriate content, harassment, or misuse of services.</li>
                    <li>Before termination, the user will generally receive a warning unless the violation is severe.</li>
                    <li>Suspended users may appeal through the committee for review, depending on the nature of the violation.</li>
                </ul>

                <h4>5. Service Modifications</h4>
                <ul>
                    <li>We may update these Terms of Service from time to time to reflect changes in features, policy updates, or legal requirements.</li>
                    <li>Users will be notified about significant changes through platform notifications or registered email addresses.</li>
                    <li>Continued usage of the platform after updates implies your acceptance of the revised terms.</li>
                </ul>

                <h4>6. Contact & Support</h4>
                <ul>
                    <li>For questions regarding these terms or for help using the platform, please reach out to the society office or email the IT administrator.</li>
                    <li>Support is available Monday to Saturday from 10 AM to 6 PM through in-app help or phone lines provided on your dashboard.</li>
                </ul>

                <p class="mt-4">By continuing to use this platform, you confirm that you have read, understood, and accepted these Terms of Service. Your cooperation ensures a better and safer community for all residents.</p>

                <a href="A_registration.aspx" class="btn btn-primary mt-3">Back to Sign Up</a>
            </div>
        </div>
    </form>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
