<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="ViewEvents.aspx.cs" Inherits="Society_management.ViewEvents" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <!-- jQuery (must come first) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Popper.js (required for Bootstrap dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        .event-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 25px;
            height: 100%;
        }
        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        .event-image {
            height: 200px;
            object-fit: cover;
        }
        .event-date, .event-location {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .page-header {
            margin: 30px 0;
            padding-bottom: 15px;

        }
        .no-events {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        /* --- ICON ANIMATION --- */
    .floating-icon {
        display: inline-block;
        animation: float-up-down 3s ease-in-out infinite;
        font-size: 4rem;
        color: #cbd5e1;
        margin-bottom: 15px;
    }
    @keyframes float-up-down {
        0% { transform: translateY(0px); }
        50% { transform: translateY(-12px); }
        100% { transform: translateY(0px); }
    }

    /* --- BALANCED EMPTY STATE --- */
    .empty-state-container {
        padding: 80px 20px;
        margin-top: 20px;
        background: #ffffff;
        border-radius: 12px;
        text-align: center;
    }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center no-border-header">
                    <h1>Upcoming Events</h1>
                    <asp:HyperLink ID="lnkCreateEvent" runat="server" NavigateUrl="~/CreateEvent.aspx" CssClass="btn btn-primary"><i class="fas fa-plus-circle"></i> Create New Event</asp:HyperLink>
                </div>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <asp:Label ID="lblMessage" runat="server" CssClass="alert shadow-sm w-100" Visible="false" style="display: block; margin-bottom:20px;"></asp:Label>

        <asp:Panel ID="pnlNoEvents" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border rounded bg-white">
                <div class="empty-state-icon text-center">
                    <i class="bi bi-calendar-x floating-icon"></i>
                </div>
                <h4 style="color: #495057; font-weight: 700; margin-bottom: 8px;">No Upcoming Events</h4>
                <p style="color: #adb5bd; font-size: 0.95rem; max-width: 400px; margin-bottom: 24px; margin-left: auto; margin-right: auto;">
                    It looks like there are no events scheduled at the moment. Stay tuned or create a new event for the society.
                </p>
                <div class="text-center">
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/CreateEvent.aspx" CssClass="btn btn-primary"><i class="fas fa-plus-circle"></i> Create New Event</asp:HyperLink>
                </div>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="row">
                <asp:Repeater ID="rptEvents" runat="server">
                    <ItemTemplate>
                        <div class="col-xl-4 col-lg-6 col-md-6 mb-4">
                            <div class="card event-card shadow-sm border-0 h-100 bg-white">
                                <asp:Image ID="imgEvent" runat="server"
                                    ImageUrl='<%# Society_management.ViewEvents.GetImageUrl(Eval("ImageUrl")) %>'
                                    CssClass="card-img-top event-image" AlternateText="Event Image" />
                                <div class="card-body">
                                    <h5 class="card-title fw-bold text-dark"><%# Eval("EventName") %></h5>
                                    <p class="card-text text-muted" style="font-size: 0.9rem;">
                                        <%# Society_management.ViewEvents.TruncateDescription(Eval("EventDescription").ToString()) %>
                                    </p>
                                </div>
                                <div class="card-footer bg-transparent border-0 pb-3">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <span class="event-date">
                                            <i class="bi bi-calendar-event text-primary me-1"></i>
                                            <%# Society_management.ViewEvents.FormatDate(Eval("EventDate")) %>
                                        </span>
                                        <span class="event-location text-truncate" style="max-width:150px;">
                                            <i class="bi bi-geo-alt text-danger me-1"></i> <%# Eval("EventLocation") %>
                                        </span>
                                    </div>
                                    <div class="d-grid">
                                        <asp:HyperLink ID="lnkDetails" runat="server"
                                            NavigateUrl='<%# "~/EventDetails.aspx?EventId=" + Eval("EventId") %>'
                                            CssClass="btn btn-sm btn-outline-primary rounded-pill">View Details</asp:HyperLink>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server" />
