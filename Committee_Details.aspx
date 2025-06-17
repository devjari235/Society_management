<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Committee_Details.aspx.cs" Inherits="Society_management.Committee_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        .card-committee {
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin: 30px auto;
            background-color: #fff;
            max-width: 900px;
        }

        .profile-img {
            height: 150px;
            width: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #ccc;
        }

        .action-button-group {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin: 15px auto;
            width: 100%;
            max-width: 900px;
        }

        .btn-register-notice {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
            color: white;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .btn-register-notice:hover {
            background-color: #2980b9;
            transform: translateY(-3px);
            color: white;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        @media (max-width: 768px) {
            .action-button-group {
                flex-direction: column;
                align-items: flex-end;
            }

            .btn-register-notice {
                width: 100%;
                text-align: center;
                padding: 14px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="action-button-group">
        <a href="View_CommiteeMember.aspx" class="btn-register-notice">
            <i class="fas fa-arrow-left"></i> Back to Details
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card-committee">
        <h2 class="text-center text-primary mb-4">Committee Member Details</h2>
        <asp:Panel ID="pnlNotice" runat="server" Visible="false">
            <div class="text-center mb-4">
                <asp:Image ID="imgPhoto" runat="server" CssClass="profile-img" ClientIDMode="Static" />
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <tbody>
                        <tr>
                            <th>Committee Member Name</th>
                            <td><asp:Label ID="lblname" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Designation</th>
                            <td><asp:Label ID="lbldes" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Role</th>
                            <td><asp:Label ID="lblRole" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Email</th>
                            <td><asp:Label ID="lblEmail" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Phone Number</th>
                            <td><asp:Label ID="lblphone" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Block Name</th>
                            <td><asp:Label ID="lblblock" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Flat No</th>
                            <td><asp:Label ID="lblNo" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>From Date</th>
                            <td><asp:Label ID="lblFdate" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>To Date</th>
                            <td><asp:Label ID="lblTdate" runat="server" /></td>
                        </tr>
                        <tr>
                            <th>Status</th>
                            <td><asp:Label ID="lblStatus" runat="server" /></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
