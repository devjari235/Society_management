<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MyFlat.aspx.cs" Inherits="Society_management.MyFlat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
      <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
        }

        .container {
            width: 80%;
            margin: 30px auto;
            background-color: #ffffff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

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
            width: 20%;
        }

        h3 {
            text-align: center;
            color: #0044cc;
            margin: 20px 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <asp:Button ID="btn1" runat="server" Text="Register Family Memeber" OnClick="btn1_Click" />
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
   <div class="container">
            <!-- Header Block & Flat Number Table -->
            <table class="header-table">
                <tr>
                    <td>Block:</td>
                    <td><asp:Label ID="lblBlockTop" runat="server" /></td>
                    <td>Flat Number:</td>
                    <td><asp:Label ID="lblFlatTop" runat="server" /></td>
                </tr>
            </table>

            <!-- Panel with Allotment Details -->
            <asp:Panel ID="pnlDetails" runat="server">
                <h3>Flat Details</h3>
                <table class="details-table">
                    <tr>
                        <td>Name</td>
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
            </asp:Panel>
        </div>

</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
