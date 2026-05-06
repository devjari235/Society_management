<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Notification.aspx.cs" Inherits="Society_management.Notification" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
<style>
/* (NO CHANGE - YOUR FULL CSS KEPT SAME) */
.notification-item {
    padding: 15px;
    margin-bottom: 15px;
    border-left: 5px solid;
    border-radius: 6px;
    cursor: pointer;
    transition: 0.3s;
    background-color: #f8f9fa;
}

.notification-item:hover {
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.notification-header {
    display: flex;
    justify-content: space-between;
    font-weight: bold;
    margin-bottom: 8px;
}

.notification-text {
    padding: 10px;
    background-color: #ffffff;
    border-radius: 4px;
    color: #333;
}

.type-remark { border-color: #28a745; background-color: #ebfbee; }
.type-event { border-color: #007bff; background-color: #e7f1ff; }
.type-poll { border-color: #fd7e14; background-color: #fff4e6; }
.type-notice { border-color: #6f42c1; background-color: #f3f0ff; }

.unread {
    border-left: 5px solid #dc3545 !important;
    font-weight: bold;
}

.text-decoration-none { text-decoration: none !important; }
.text-dark { color: #212529 !important; }
.w-100 { width: 100% !important; }
.d-block { display: block !important; }
/* Legend Container Styles */
.style-legend {
    display: flex;
    gap: 20px;
}

.legend-item {
    display: flex;
    align-items: center;
    font-size: 0.9rem;
    color: #444;
}

.dot {
    height: 12px;
    width: 12px;
    border-radius: 50%;
    display: inline-block;
    margin-right: 8px;
}

/* Legend Specific Colors */
.bg-remark { background-color: #28a745; }
.bg-event  { background-color: #007bff; }
.bg-poll   { background-color: #fd7e14; }
.bg-notice { background-color: #6f42c1; }
.bg-unread { background-color: #dc3545; }

/* Responsive fix for smaller screens */
@media (max-width: 768px) {
    .style-legend {
        flex-direction: column;
        gap: 10px;
    }
}
</style>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">

<asp:HiddenField ID="hdnUserId" runat="server" />

<div>
    <h3>🔔 Notifications</h3>

    <div class="card mb-4 border-0 shadow-sm" style="background-color: #ffffff; border-radius: 10px;">
        <div class="card-body">
            <h6 class="fw-bold text-muted mb-3" style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">
                Color Guide
            </h6>
            <div class="d-flex flex-wrap style-legend">
                <div class="legend-item"><span class="dot bg-remark"></span> <b>Green:</b> Complaint Update</div>
                <div class="legend-item"><span class="dot bg-event"></span> <b>Blue:</b> Society Event</div>
                <div class="legend-item"><span class="dot bg-poll"></span> <b>Orange:</b> New Poll/Vote</div>
                <div class="legend-item"><span class="dot bg-notice"></span> <b>Purple:</b> Official Notice</div>
                <div class="legend-item"><span class="dot bg-unread"></span> <b>Red Edge:</b> New/Unread</div>
            </div>
        </div>
    </div>

    <!-- EMPTY STATE -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="alert alert-info mt-3">
            🔕 No notifications found
        </div>
    </asp:Panel>

    <!-- TODAY -->
    <asp:Panel ID="pnlToday" runat="server" Visible="false">
        <h5 class="mt-4">📂 Today</h5>

        <asp:Repeater ID="rptToday" runat="server" OnItemCommand="rptRemarks_ItemCommand">
            <ItemTemplate>
                <div class='notification-item type-<%# Eval("Type").ToString().ToLower() %> <%# Convert.ToBoolean(Eval("IsRead")) ? "" : "unread" %>'>

                    <asp:LinkButton runat="server"
                        CommandName='<%# Eval("Type") %>'
                        CommandArgument='<%# Eval("RefId") %>'
                        CssClass="text-decoration-none text-dark w-100 d-block">

                        <div class="notification-header">
                            <span>🔔 <%# Eval("Title") %></span>
                            <span><%# GetTimeAgo(Convert.ToDateTime(Eval("CreatedDate"))) %></span>
                        </div>

                        <div class="notification-text">
                            <%# Eval("Message") %>
                        </div>

                    </asp:LinkButton>

                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- YESTERDAY -->
    <asp:Panel ID="pnlYesterday" runat="server" Visible="false">
        <h5 class="mt-4">📂 Yesterday</h5>

        <asp:Repeater ID="rptYesterday" runat="server" OnItemCommand="rptRemarks_ItemCommand">
            <ItemTemplate>
                <div class='notification-item type-<%# Eval("Type").ToString().ToLower() %> <%# Convert.ToBoolean(Eval("IsRead")) ? "" : "unread" %>'>

                    <asp:LinkButton runat="server"
                        CommandName='<%# Eval("Type") %>'
                        CommandArgument='<%# Eval("RefId") %>'
                        CssClass="text-decoration-none text-dark w-100 d-block">

                        <div class="notification-header">
                            <span>🔔 <%# Eval("Title") %></span>
                            <span><%# GetTimeAgo(Convert.ToDateTime(Eval("CreatedDate"))) %></span>
                        </div>

                        <div class="notification-text">
                            <%# Eval("Message") %>
                        </div>

                    </asp:LinkButton>

                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- EARLIER -->
    <asp:Panel ID="pnlEarlier" runat="server" Visible="false">
        <h5 class="mt-4">📂 Earlier</h5>

        <asp:Repeater ID="rptEarlier" runat="server" OnItemCommand="rptRemarks_ItemCommand">
            <ItemTemplate>
                <div class='notification-item type-<%# Eval("Type").ToString().ToLower() %> <%# Convert.ToBoolean(Eval("IsRead")) ? "" : "unread" %>'>

                    <asp:LinkButton runat="server"
                        CommandName='<%# Eval("Type") %>'
                        CommandArgument='<%# Eval("RefId") %>'
                        CssClass="text-decoration-none text-dark w-100 d-block">

                        <div class="notification-header">
                            <span>🔔 <%# Eval("Title") %></span>
                            <span><%# GetTimeAgo(Convert.ToDateTime(Eval("CreatedDate"))) %></span>
                        </div>

                        <div class="notification-text">
                            <%# Eval("Message") %>
                        </div>

                    </asp:LinkButton>

                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

</div>

</asp:Content>

<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script>
setInterval(function () {
    loadNotifications();
}, 10000);

function loadNotifications() {
    $.ajax({
        type: "POST",
        url: "Notification.aspx/GetNotifications",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            userId: document.getElementById('<%= hdnUserId.ClientID %>').value
        }),
        success: function () {
            location.reload();
        }
    });
    }
</script>

</asp:Content>