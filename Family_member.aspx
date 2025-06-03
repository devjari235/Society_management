<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Family_member.aspx.cs" Inherits="Society_management.Family_member" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<!--last 2 is for dropdown binding script-->
    <style>
        body {
            background-color: #f8f9fa;
        }

        .card {
            max-width: 600px;
            margin: 30px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, .25);
        }
    </style>

    <script>
        function validateForm() {
            let name = document.getElementById('<%= txtName.ClientID %>').value;
            let age = document.getElementById('<%= txtAge.ClientID %>').value;
            let relationship = document.getElementById('<%= ddlRelationship.ClientID %>').value;

            if (name === '' || age === '' || relationship === '') {
                alert('Please fill in all required fields.');
                return false;
            }
            return true;
        }
    </script>
    <style>
    /* Button Group Container */
    .action-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        margin: 15px 0;
        width: 100%;
    }

    /* Base Button Styles */
    .btn-register-notice,
    .btn-view-notice {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 12px 24px;
        text-decoration: none;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        font-size: 16px;
        font-weight: 600;
        border-radius: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    /* Register Button */
    .btn-register-notice {
        background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        color: white;
    }

    .btn-register-notice:hover {
        background-color: #2980b9;
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        text-decoration:none;
        color: white;
    }

    /* View Button */
    .btn-view-notice {
        background-color: #2ecc71;
        color: white;
    }

    .btn-view-notice:hover {
        background-color: #27ae60;
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        text-decoration:none;
        color: white;
    }

    /* Icons */
    .btn-register-notice i,
    .btn-view-notice i {
        margin-right: 10px;
        font-size: 18px;
    }

    /* Active State */
    .btn-register-notice:active,
    .btn-view-notice:active {
        transform: scale(0.98);
    }

    /* Focus State */
    .btn-register-notice:focus,
    .btn-view-notice:focus {
        outline: none;
    }

    .btn-register-notice:focus {
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.5);
    }

    .btn-view-notice:focus {
        box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.5);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .action-button-group {
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }
        
        .btn-register-notice,
        .btn-view-notice {
            width: 100%;
            max-width: 300px;
            padding: 15px 20px;
            font-size: 18px;
            text-align: center;
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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <div class="action-button-group">
    <a href="Myflat.aspx" class="btn-register-notice">
        <i class="fas fa-arrow-left"></i> Back to Details
    </a>
    <a href="View_family.aspx" class="btn-view-notice">
        <i class="fas fa-users"></i> View members
    </a>
</div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
<div class="card">
        <div class="card-header bg-primary text-white text-center">
            <h4>Add Family Member</h4>
        </div>
        <div class="card-body">

            <div class="mb-3">
                <label for="txtName" class="form-label">Member Name</label>
                <asp:TextBox ID="txtName" CssClass="form-control" runat="server" AutoCompleteType="Disabled" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server"
                    ControlToValidate="txtName"
                    CssClass="validation-error"
                    ErrorMessage="Name is required."
                    Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label for="txtEmail" class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" CssClass="form-control" TextMode="Email" runat="server" AutoCompleteType="Disabled" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    CssClass="validation-error"
                    ErrorMessage="Email is required."
                    Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label for="txtPhone" class="form-label">Phone Number</label>
                <asp:TextBox ID="txtPhone" CssClass="form-control" TextMode="Number" runat="server" AutoCompleteType="Disabled" />
                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                    ControlToValidate="txtPhone"
                    CssClass="validation-error"
                    ErrorMessage="Phone number is required."
                    Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label for="txtAge" class="form-label">Age</label>
                <asp:TextBox ID="txtAge" CssClass="form-control" TextMode="Number" runat="server" AutoCompleteType="Disabled" />
                <asp:RequiredFieldValidator ID="rfvAge" runat="server"
                    ControlToValidate="txtAge"
                    CssClass="validation-error"
                    ErrorMessage="Age is required."
                    Display="Dynamic" />
                <asp:RangeValidator ID="rvAge" runat="server"
                    ControlToValidate="txtAge"
                    MinimumValue="0"
                    MaximumValue="150"
                    Type="Integer"
                    CssClass="validation-error"
                    ErrorMessage="Enter a valid age." />
            </div>

            <div class="mb-3">
                <label for="ddlGender" class="form-label">Gender</label>
                <asp:DropDownList ID="ddlGender" CssClass="form-select" runat="server">
                    <asp:ListItem Text="Select Gender" Value="" />
                    <asp:ListItem Text="Male" />
                    <asp:ListItem Text="Female" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvGender" runat="server"
                    ControlToValidate="ddlGender"
                    InitialValue=""
                    CssClass="validation-error"
                    ErrorMessage="Please select gender."
                    Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label for="ddlRelationship" class="form-label">Relationship</label>
                <asp:DropDownList ID="ddlRelationship" CssClass="form-select" runat="server">
                    <asp:ListItem Text="Select Relationship" Value="" />
                    <asp:ListItem Text="Father" />
                    <asp:ListItem Text="Mother" />
                    <asp:ListItem Text="Spouse" />
                    <asp:ListItem Text="Son" />
                    <asp:ListItem Text="Daughter" />
                    <asp:ListItem Text="Brother" />
                    <asp:ListItem Text="Sister" />
                    <asp:ListItem Text="Other" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvRelationship" runat="server"
                    ControlToValidate="ddlRelationship"
                    InitialValue=""
                    CssClass="validation-error"
                    ErrorMessage="Please select relationship."
                    Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label for="txtDOB" class="form-label">Date of Birth</label>
                <asp:TextBox ID="txtDOB" CssClass="form-control" TextMode="Date" runat="server" AutoCompleteType="Disabled" />
                <asp:RequiredFieldValidator ID="rfvDOB" runat="server"
                    ControlToValidate="txtDOB"
                    CssClass="validation-error"
                    ErrorMessage="Date of birth is required."
                    Display="Dynamic" />
                <asp:CustomValidator ID="cvDOB" runat="server"
                    ControlToValidate="txtDOB"
                    OnServerValidate="cvDOB_ServerValidate"
                    CssClass="validation-error"
                    ErrorMessage="Date of birth cannot be in the future."
                    Display="Dynamic" />
            </div>

            <div class="d-grid">
                <asp:Button ID="btnAddMember" CssClass="btn btn-primary" runat="server" Text="Add Member" OnClick="btnAddMember_Click" />
            </div>

            <div class="mt-3 text-center">
                <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold" />
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
