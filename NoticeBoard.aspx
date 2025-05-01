<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="NoticeBoard.aspx.cs" Inherits="Society_management.NoticeBoard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style>
        body {
            font-family: Arial, sans-serif;
            background: #f9f9f9;
        }

        .notice-board {
            width: 80%;
            margin: auto;
            padding: 20px;
            background: #fffbe6;
            border: 2px dashed #ffcc00;
            border-radius: 10px;
        }


        .form-group {
            margin-bottom: 10px;
        }

        .btn1 {
            background-color: #ff9900;
            border: none;
            color: white;
            padding: 8px 16px;
            cursor: pointer;
            border-radius: 4px;
        }

        .btn1:hover {
            background-color: #cc7a00;
        }
    </style>
     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
      <div class="notice-board">
            <h2>Society Notice Board</h2>

            <!-- Admin Input Form -->
            <asp:Panel ID="pnlAdmin" runat="server">
                <div class="form-group">
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" Placeholder="Notice Title"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" Placeholder="Notice Description"></asp:TextBox>
                </div>
                <asp:Button ID="btnPost" runat="server" Text="Post Notice" CssClass="btn1" OnClick="btnPost_Click"  />
                <hr />
            </asp:Panel>

            
        </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
