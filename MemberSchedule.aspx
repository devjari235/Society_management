<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MemberSchedule.aspx.cs" Inherits="Society_management.MemberSchedule" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
    /* Remove body background and centering */
body, html {
    height: 100%;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Center the card horizontally with some margin top */
.container {
    display: flex;
    justify-content: center;
    margin-top: 60px;
}

/* Fixed width for the card */
.custom-schedule-card {
    background: #ffffff;
    padding: 40px 35px;
    border-radius: 12px;
    width: 600px; /* fixed width */
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    transition: box-shadow 0.3s ease;
}

/* Hover effect for the card */
.custom-schedule-card:hover {
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
}

/* Heading style */
.custom-schedule-card h4 {
    color: #333;
    font-weight: 700;
    margin-bottom: 30px;
    text-align: center;
    font-size: 1.8rem;
}

/* Form label style */
.form-label {
    font-weight: 600;
    color: #555;
}

/* Inputs style */
.form-control {
    border: 2px solid #ddd;
    border-radius: 8px;
    padding: 10px 15px;
    font-size: 1rem;
    transition: border-color 0.3s ease;
}

.form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 8px rgba(102, 126, 234, 0.5);
    outline: none;
}

/* Button style */
#btnSchedule {
    width: 100%;
    padding: 12px;
    font-size: 1.1rem;
    border-radius: 8px;
    background: #667eea;
    border: none;
    font-weight: 600;
    transition: background 0.3s ease;
}

.btn-primary:hover {
    background: #5a67d8;
}

/* Message label styles */
#lblMessage {
    display: block;
    margin-top: 20px;
    font-weight: 600;
    text-align: center;
    padding: 12px;
    border-radius: 6px;
    font-size: 1rem;
}

#lblMessage.success {
    background-color: #d4edda;
    color: #155724;
}

#lblMessage.error {
    background-color: #f8d7da;
    color: #721c24;
}
/* Page Title Buttons Container */
.page-title-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

/* Left-aligned button group */
.button-group-left {
    display: flex;
    gap: 10px;
}

/* Base Button Style */
.dashboard-btn {
    padding: 10px 20px;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 600;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    cursor: pointer;
    text-decoration: none;
    color: white;
    border: none;
}

.dashboard-btn i {
    margin-right: 8px;
    font-size: 1rem;
}

/* Individual Button Colors */
.btn-create {
    background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
    margin-left: auto; /* Pushes Create button to the right */
}

.btn-Dashboard {
     background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}

/* Hover Effects */
.dashboard-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    color: #FFD700;
    text-decoration:none;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .page-title-buttons {
        flex-direction: column;
        gap: 8px;
    }
    
    .button-group-left {
        width: 100%;
        justify-content: space-between;
    }
    
    .dashboard-btn {
        width: 100%;
        text-align: center;
        justify-content: center;
    }
}
.validation-error {
    color: #dc3545;
    font-size: 0.85rem;
    margin-top: 3px;
    display: block;
    font-weight: 500;
    transition: all 0.3s ease;
}

.validation-error::before {
    content: "⚠ ";
    font-size: 0.85rem;
    margin-right: 4px;
}

.is-invalid {
    border-color: #dc3545 !important;
}

</style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
          <div class="page-title-buttons">
     <div class="button-group-left">
         <a href="MemberApproval.aspx" class="dashboard-btn btn-Dashboard">
             <i class="fas fa-arrow-left"></i>Back to Details
         </a>        
     </div>
 </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container mt-5">
        <div class="custom-schedule-card">

            <h4>Schedule a Visitor</h4>

            <!-- Visitor Name -->
            <div class="mb-3">
                <asp:Label ID="lblVisitorName" runat="server" Text="Visitor Name:" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtVisitorName" runat="server" CssClass="form-control" AutoCompleteType="Disabled"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvVisitorName" runat="server" ControlToValidate="txtVisitorName"
                    ErrorMessage="Visitor name is required." CssClass="validation-error" Display="Dynamic" />
            </div>

            <!-- Contact Number -->
            <div class="mb-3">
                <asp:Label ID="lblContactNumber" runat="server" Text="Contact Number:" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtContactNumber" runat="server" CssClass="form-control" AutoCompleteType="Disabled"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvContactNumber" runat="server" ControlToValidate="txtContactNumber"
                    ErrorMessage="Contact number is required." CssClass="validation-error" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revContactNumber" runat="server" ControlToValidate="txtContactNumber"
                    ValidationExpression="^\d{10}$" ErrorMessage="Enter a valid 10-digit number."
                    CssClass="validation-error" Display="Dynamic" />
            </div>

            <!-- Visit Date & Time -->
            <div class="mb-3">
                <asp:Label ID="lblVisitDateTime" runat="server" Text="Visit Date & Time:" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtVisitDateTime" runat="server" CssClass="form-control"
                    placeholder="e.g., 2025-06-01 14:00" TextMode="DateTimeLocal" AutoCompleteType="Disabled"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvVisitDateTime" runat="server" ControlToValidate="txtVisitDateTime"
                    ErrorMessage="Visit date and time is required." CssClass="validation-error" Display="Dynamic" />
                <asp:CustomValidator ID="cvFutureDate" runat="server" ControlToValidate="txtVisitDateTime"
                    OnServerValidate="cvFutureDate_ServerValidate"
                    ErrorMessage="Visit date and time cannot be in the past." CssClass="validation-error" Display="Dynamic" />
            </div>

            <!-- Visit Purpose -->
            <div class="mb-3">
                <asp:Label ID="lblVisitPurpose" runat="server" Text="Visit Purpose:" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtVisitPurpose" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPurpose" runat="server" ControlToValidate="txtVisitPurpose"
                    ErrorMessage="Visit purpose is required." CssClass="validation-error" Display="Dynamic" />
                <asp:CustomValidator ID="cvPurposeLength" runat="server" ControlToValidate="txtVisitPurpose"
                    OnServerValidate="cvPurposeLength_ServerValidate"
                    ErrorMessage="Purpose must be at least 5 characters." CssClass="validation-error" Display="Dynamic" />
            </div>

            <!-- Submit Button -->
            <asp:Button ID="btnSchedule" runat="server" Text="Schedule Visitor" CssClass="btn btn-primary" OnClick="btnSchedule_Click" />

            <!-- Message Label -->
            <div class="mt-3">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
