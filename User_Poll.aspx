<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_Poll.aspx.cs" Inherits="Society_management.User_Poll" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
       <style>
        .poll-container {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            font-family: Arial;
        }
        .poll-question {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .poll-options {
            margin-bottom: 10px;
        }
        .error-message {
            color: red;
            margin-top: 10px;
            display: block;
        }
        .success-message {
            color: green;
            margin-top: 10px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
   <div class="poll-container">

            <!-- Active Poll Panel -->
            <asp:Panel ID="pnlActivePoll" runat="server" Visible="false">
                <div class="poll-question">
                    <asp:Literal ID="litQuestion" runat="server"></asp:Literal>
                </div>

                <!-- Vote Panel -->
                <asp:Panel ID="pnlVote" runat="server">
                    <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="poll-options" />
                    <asp:Button ID="btnVote" runat="server" Text="Vote" OnClick="btnVote_Click" />
                    <asp:Label ID="lblVoteError" runat="server" CssClass="error-message" Visible="false" />
                </asp:Panel>

                <!-- Already Voted Message -->
                <asp:Panel ID="pnlAlreadyVoted" runat="server" Visible="false">
                    <p>You have already voted in this poll. Thank you for your participation!</p>
                </asp:Panel>
            </asp:Panel>

            <!-- No Active Poll Message -->
            <asp:Panel ID="pnlNoActivePoll" runat="server" Visible="false">
                <p>There is no active poll at the moment. Please check back later.</p>
            </asp:Panel>

        </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
