<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Poll_Result.aspx.cs" Inherits="Society_management.Poll_Result" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .poll-results {
            width: 60%;
            margin: 30px auto;
            font-family: Arial;
        }
        .result-bar {
            background-color: #ddd;
            height: 20px;
            margin: 5px 0;
            position: relative;
        }
        .result-fill {
            background-color: #4caf50;
            height: 100%;
        }
        .result-text {
            position: absolute;
            left: 10px;
            top: 0;
            height: 100%;
            line-height: 20px;
            font-size: 12px;
            color: #fff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="poll-results">
            <asp:Literal ID="litQuestion" runat="server" />
            <asp:Repeater ID="rptResults" runat="server">
                <ItemTemplate>
                    <div>
                        <strong><%# Eval("OptionText") %></strong>
                        <div class="result-bar">
                            <div class="result-fill" style='width:<%# Eval("Percentage") %>%;'></div>
                            <div class="result-text"><%# Eval("VoteCount") %> votes (<%# Eval("Percentage") %>%)</div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <p>Total votes: <asp:Literal ID="litTotalVotes" runat="server" /></p>
        </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
