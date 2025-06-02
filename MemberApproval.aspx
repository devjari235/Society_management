<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MemberApproval.aspx.cs" Inherits="Society_management.MemberApproval" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery (required for Bootstrap dropdowns) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>

<!-- Bootstrap JS Bundle with Popper (required for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Font Awesome (for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        h2 {
            color: #2c3e50;
            padding-bottom: 10px;
            font-weight: 700;
        }

        /* Override GridView table styles to fit Bootstrap */
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        th {
            background-color: #e74c3c;
            color: white;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f1f3f5;
        }

        /* Style buttons using Bootstrap utilities */
        #btnApprove, #btnReject {
            padding: 6px 15px;
            font-weight: 600;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            min-width: 90px;
            margin-right: 5px;
        }

        #btnApprove {
            background-color: #2ecc71;
            color: white;
        }

        #btnApprove:hover {
            background-color: #27ae60;
        }

        #btnReject {
            background-color: #e74c3c;
            color: white;
        }

        #btnReject:hover {
            background-color: #c0392b;
        }

        /* Message label styles */
        #lblMessage {
            display: block;
            margin: 15px 0;
            padding: 12px 15px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 1rem;
            text-align: center;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .create-notice-container {
            display: flex;
            justify-content: flex-end;
        }

        .btn-create-notice {
            background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            text-decoration: none;
        }

            .btn-create-notice:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
                color: #FFD700;
                background: linear-gradient(135deg, #9d3df1 0%, #5b1ae6 100%);
                text-decoration: none;
            }

            .btn-create-notice i {
                margin-right: 10px;
                font-size: 1.2rem;
            }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
     <div class="create-notice-container">
     <a href="MemberSchedule.aspx" class="btn-create-notice">
         <i class="fas fa-plus-circle"></i> Schedule Visitor 
     </a>
 </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">

            <asp:GridView ID="gvPendingVisitors" runat="server" AutoGenerateColumns="False" CssClass="table"
                OnRowCommand="gvPendingVisitors_RowCommand">
                <Columns>
                    
                    <asp:BoundField DataField="Name" HeaderText="Visitor Name" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="ContactNumber" HeaderText="Contact Number" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="VisitPurpose" HeaderText="Purpose" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="VisitDateTime" HeaderText="Visit Time" DataFormatString="{0:g}" ItemStyle-CssClass="align-middle" />
                    <asp:BoundField DataField="MemberName" HeaderText="Meeting With" ItemStyle-CssClass="align-middle" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnApprove" runat="server" Text="Approve" CommandName="Approve" 
                                CommandArgument='<%# Eval("VisitorID") %>' CssClass="btn btn-success btn-sm" />
                            <asp:Button ID="btnReject" runat="server" Text="Reject" CommandName="Reject" 
                                CommandArgument='<%# Eval("VisitorID") %>' CssClass="btn btn-danger btn-sm" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        <asp:Panel CssClass="alert alert-success" role="alert" ID="Panel1" runat="server" Visible="false">
            <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
        </asp:Panel>
        </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
