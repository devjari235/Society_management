<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_AllPoll.aspx.cs" Inherits="Society_management.View_AllPoll" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f4f4;
            margin: 0;
           
        }

        .poll-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: flex-start;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .poll-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            padding: 16px;
            width: 280px;
        }

        .poll-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 12px;
            color: #333;
        }

        .poll-description {
            font-size: 14px;
            color: #555;
            margin-bottom: 12px;
        }

        .poll-status {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            color: white;
            margin-bottom: 12px;
        }

        .status-active {
            background-color: #28a745;
        }

        .status-expired {
            background-color: #dc3545;
        }

        .option-row {
            margin-bottom: 8px;
            padding: 4px 0;
        }

        .option-text {
            font-weight: 500;
            display: inline-block;
            font-size: 14px;
        }

        .option-count {
            float: right;
            color: #666;
            font-size: 13px;
        }
    </style>
                <style>
    /* Button Group Container */
    .action-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        width: 100%;
    }

    /* Base Button Styles */
    .btn-register-notice{
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



    /* Icons */
    .btn-register-notice i{
        margin-right: 10px;
        font-size: 18px;
    }

    /* Active State */
    .btn-register-notice:active{
        transform: scale(0.98);
    }

    /* Focus State */
    .btn-register-notice:focus{
        outline: none;
    }

    .btn-register-notice:focus {
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.5);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .action-button-group {
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }
        
        .btn-register-notice{
            width: 100%;
            max-width: 300px;
            padding: 15px 20px;
            font-size: 18px;
            text-align: center;
        }
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
        <div class="action-button-group">
        <a href="Poll_Result.aspx" class="btn-register-notice">
            <i class="fas fa-arrow-left"></i>Poll Result
        </a>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="poll-container">
        <asp:Repeater ID="rptPolls" runat="server">
            <ItemTemplate>
                <div class="poll-card">
                    <div class="poll-title"><%# Eval("Title") %></div>
                    <div class='poll-status <%# (Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-expired") %>'>
                        <%# (Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Expired") %>
                    </div>
                    
                    <asp:Repeater ID="rptOptions" runat="server" DataSource='<%# Eval("Options") %>'>
                        <ItemTemplate>
                            <div class="option-row">
                                <span class="option-text"><%# Eval("OptionText") %></span>
                                <span class="option-count"><%# Eval("VoteCount") %> votes</span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>