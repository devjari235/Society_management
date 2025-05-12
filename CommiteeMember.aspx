<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="CommiteeMember.aspx.cs" Inherits="Society_management.CommiteeMember" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Client-side validation if needed
        document.getElementById('form1').addEventListener('submit', function(e) {
            var toDate = document.getElementById('<%= txtToDate.ClientID %>').value;
            var fromDate = document.getElementById('<%= txtFromDate.ClientID %>').value;
            
            if (toDate && fromDate && new Date(toDate) < new Date(fromDate)) {
                alert('To Date cannot be earlier than From Date');
                e.preventDefault();
            }
        });
    </script>
    <style>
        body {
    background-color: #f8f9fa;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.card {
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}

.card-header {
    border-radius: 10px 10px 0 0 !important;
    padding: 15px 20px;
}

.form-label {
    font-weight: 500;
    color: #495057;
}

.btn {
    padding: 8px 20px;
    border-radius: 5px;
    font-weight: 500;
}

.table th {
    background-color: #f1f5f9;
    color: #495057;
    font-weight: 600;
}

.table-responsive {
    overflow-x: auto;
}

.pagination {
    margin: 0;
}

.datepicker {
    cursor: pointer;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .card-body {
        padding: 15px;
    }
    
    .btn {
        width: 100%;
        margin-bottom: 10px;
    }
    
    .row.mb-3 > div {
        margin-bottom: 15px;
    }
}
.gradient-btn {
    display: inline-block;
    padding: 10px 20px;
    color:darkred;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    background: linear-gradient(to right, #FF7E5F, #FEB47B);
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    margin: 5px 0;
}

.gradient-btn:hover {
    color:black;
    text-decoration:none;
    box-shadow: 0 4px 8px rgba(0,0,0,0.3);
    transform: translateY(-2px);
}

.gradient-btn:active {
    transform: translateY(0);
}

.gradient-btn i {
    margin-right: 8px;
}
 .create-notice-container{
     display:flex;
     justify-content:flex-end;
 }
    </style>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
   <div class="create-notice-container">
       <a href="View_CommiteeMember.aspx" class="gradient-btn"><b><i class="bi bi-eye-fill"></i> View Committee Member</b></a>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h2 class="text-center">Committee Member Registration</h2>
                </div>
                <div class="card-body">
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="ddlUser" class="form-label">Comimitee Member Name</label>
                            <asp:DropDownList ID="ddlUser" runat="server" CssClass="form-select" DataTextField="UserName" DataValueField="User_id" required="required" AutoPostBack="True" OnSelectedIndexChanged="ddlUser_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label for="txtDesignation" class="form-label">Designation</label>
                            <asp:DropDownList ID="ddlDesignation"  CssClass="form-control" runat="server">
                                <asp:ListItem>-- Select Designation --</asp:ListItem>
                                <asp:ListItem>President</asp:ListItem>
                                <asp:ListItem>Vice-President</asp:ListItem>
                                <asp:ListItem>Secretary</asp:ListItem>
                                <asp:ListItem>Treasurer</asp:ListItem>
                                <asp:ListItem>Executive Commitee Member</asp:ListItem>
                                <asp:ListItem>Facilities Manager</asp:ListItem>
                                <asp:ListItem>Other</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="txtBlockName" class="form-label">Block Name</label>
                            <asp:TextBox ID="txtBlockName" runat="server" CssClass="form-control" required="required" Enabled="False" ReadOnly="True"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label for="txtFlatNo" class="form-label">Flat No</label>
                            <asp:TextBox ID="txtFlatNo" runat="server" CssClass="form-control" required="required" Enabled="False" ReadOnly="True"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label for="ddlRole" class="form-label">Role</label>
                            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select" required="required">
                                <asp:ListItem Value="">-- Select Role --</asp:ListItem>
                                <asp:ListItem>Manage All</asp:ListItem>
                                <asp:ListItem>Maintenance Handling</asp:ListItem>
                                <asp:ListItem>Security Management</asp:ListItem>
                                <asp:ListItem>Event Planning</asp:ListItem>
                                <asp:ListItem>Finance &amp; Accounting</asp:ListItem>
                                <asp:ListItem>Parking Allocation</asp:ListItem>
                                <asp:ListItem>Communication &amp; Notices</asp:ListItem>
                                <asp:ListItem>Cleaning &amp; Sanitation</asp:ListItem>
                                <asp:ListItem>Facility Management </asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="txtEmail" class="form-label">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" required="required" Enabled="False" ReadOnly="True"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtContactNo" class="form-label">Contact No</label>
                            <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-control" required="required" Enabled="False" ReadOnly="True"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="txtFromDate" class="form-label">From Date</label>
                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control datepicker" TextMode="Date" required="required"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtToDate" class="form-label">To Date</label>
                            <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control datepicker" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-md-12 text-center">
                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary me-2" OnClick="btnSave_Click" />
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
