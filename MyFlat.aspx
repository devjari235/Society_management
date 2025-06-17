<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MyFlat.aspx.cs" Inherits="Society_management.MyFlat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    My Flat Details
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* No need to define body styles here, Master Page handles it */

        /* Custom styles for tables (can be moved to Customstylesheet.css for global use) */
        .header-table, .details-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }

        .header-table td {
            padding: 10px;
            font-weight: bold;
        }

        .details-table td {
            padding: 12px 10px;
            border: 1px solid #ddd;
        }

        .details-table td:first-child,
        .details-table td:nth-child(3) {
            background-color: #f9f9f9;
            font-weight: bold;
            width: 20%; /* Keep for desktop, table-responsive handles mobile */
        }

        h3 {
            text-align: center;
            color: #0044cc;
            margin: 20px 0;
        }
       
        /* Button Group Container */
        .action-button-group {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
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
            background-color: #3498db;
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
            text-decoration:none;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
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

        /* Responsive Design for Buttons */
        @media (max-width: 768px) {
            .action-button-group {
                flex-direction: column;
                align-items: flex-end; /* Keeps buttons aligned to right, or change to center */
                gap: 10px;
            }
           
            .btn-register-notice,
            .btn-view-notice {
                width: 100%; /* Make them full width of the parent container */
                max-width: 300px; /* Optional: cap maximum width even when 100% */
                padding: 15px 20px;
                font-size: 18px;
                text-align: center;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <div class="action-button-group">
        <a href="Family_member.aspx" class="btn-register-notice">
            <i class="fas fa-user-plus"></i> Register a member
        </a>
        <a href="View_family.aspx" class="btn-view-notice">
            <i class="fas fa-users"></i> View members
        </a>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <%-- Using Bootstrap's .container for better responsiveness and styling --%>
    <div class="container bg-white p-4 rounded shadow-sm my-4">
        <div class="table-responsive mb-4">
            <table class="header-table table table-borderless"> <%-- Added Bootstrap table classes --%>
                <tr>
                    <td>Block:</td>
                    <td><asp:Label ID="lblBlockTop" runat="server" /></td>
                    <td>Flat Number:</td>
                    <td><asp:Label ID="lblFlatTop" runat="server" /></td>
                </tr>
            </table>
        </div>

        <asp:Panel ID="pnlDetails" runat="server">
            <h3>Flat Details</h3>
            <div class="table-responsive">
                <table class="details-table table table-bordered"> <%-- Added Bootstrap table classes --%>
                    <tr>
                        <td>Owner Name</td>
                        <td><asp:Label ID="lblName" runat="server" /></td>
                        <td>Mobile Number</td>
                        <td><asp:Label ID="lblContact" runat="server" /></td>
                    </tr>
                    <tr>
                        <td>Emergency Contact Number</td>
                        <td><asp:Label ID="lblEmergency" runat="server" /></td>
                        <td>No of Member</td>
                        <td><asp:Label ID="lblMembers" runat="server" /></td>
                    </tr>
                    <tr>
                        <td>Block</td>
                        <td><asp:Label ID="lblBlock" runat="server" /></td>
                        <td>Flat No</td>
                        <td><asp:Label ID="lblFlatNo" runat="server" /></td>
                    </tr>
                    <tr>
                        <td>Floor</td>
                        <td><asp:Label ID="lblFloor" runat="server" /></td>
                        <td>Flat Type</td>
                        <td><asp:Label ID="lblFlatType" runat="server" /></td>
                    </tr>
                    <tr>
                        <td>Maintenance Charge</td>
                        <td><asp:Label ID="lblMaintenance" runat="server" /></td>
                        <td>Allotment Date</td>
                        <td><asp:Label ID="lblAllotmentDate" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </div>

</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>