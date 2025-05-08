<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Family_member.aspx.cs" Inherits="Society_management.Family_member" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card">
            <div class="card-header bg-primary text-white text-center">
                <h4>Add Family Member</h4>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label for="txtName" class="form-label">Member Name</label>
                    <asp:TextBox ID="txtName" CssClass="form-control" runat="server" />
                </div>
                <div class="mb-3">
                    <label for="txtAge" class="form-label">Age</label>
                    <asp:TextBox ID="txtAge" CssClass="form-control" TextMode="Number" runat="server" />
                </div>
                <div class="mb-3">
                    <label for="ddlGender" class="form-label">Gender</label>
                    <asp:DropDownList ID="ddlGender" CssClass="form-select" runat="server">
                        <asp:ListItem Text="Select Gender" Value="" />
                        <asp:ListItem Text="Male" />
                        <asp:ListItem Text="Female" />
                    </asp:DropDownList>
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
                </div>
                <div class="d-grid">
                    <asp:Button ID="btnAddMember" CssClass="btn btn-primary" runat="server" Text="Add Member"
                        OnClientClick="return validateForm();" OnClick="btnAddMember_Click" />
                </div>
                <div class="mt-3 text-center">
                    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold" />
                </div>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
