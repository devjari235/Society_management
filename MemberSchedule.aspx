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
.btn-primary {
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
</style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
            <div class="custom-schedule-card">

                <h4>Schedule a Visitor</h4>

                <div class="mb-3">
                    <asp:Label ID="lblVisitorName" runat="server" Text="Visitor Name:" CssClass="form-label"></asp:Label>
                    <asp:TextBox ID="txtVisitorName" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:Label ID="lblContactNumber" runat="server" Text="Contact Number:" CssClass="form-label"></asp:Label>
                    <asp:TextBox ID="txtContactNumber" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:Label ID="lblVisitDateTime" runat="server" Text="Visit Date & Time:" CssClass="form-label"></asp:Label>
                    <asp:TextBox ID="txtVisitDateTime" runat="server" CssClass="form-control" placeholder="e.g., 2025-06-01 14:00" TextMode="DateTimeLocal"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <asp:Label ID="lblVisitPurpose" runat="server" Text="Visit Purpose:" CssClass="form-label"></asp:Label>
                    <asp:TextBox ID="txtVisitPurpose" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </div>

                <asp:Button ID="btnSchedule" runat="server" Text="Schedule Visitor" CssClass="btn btn-primary" OnClick="btnSchedule_Click" />

                <div class="mt-3">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </div>
            </div>
        </div>

</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
