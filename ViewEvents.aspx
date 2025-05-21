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
    <div class="container">
        <div class="row">
            <asp:Repeater ID="rptEvents" runat="server">
                <ItemTemplate>
                    <div class="col-md-4">
                        <div class="card event-card">
                            <asp:Image ID="imgEvent" runat="server"
                                ImageUrl='<%# Society_management.ViewEvents.GetImageUrl(Eval("ImageUrl")) %>'
                                CssClass="card-img-top event-image" AlternateText="Event Image" />
                            <div class="card-body">
                                <h5 class="card-title"><%# Eval("EventName") %></h5>
                                <p class="card-text"><%# Society_management.ViewEvents.TruncateDescription(Eval("EventDescription").ToString()) %></p>
                            </div>
                            <div class="card-footer bg-transparent">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="event-date">
                                        <i class="bi bi-calendar-event"></i>
                                        <%# Society_management.ViewEvents.FormatDate(Eval("EventDate")) %>
                                    </span>
                                    <span class="event-location">
                                        <i class="bi bi-geo-alt"></i> <%# Eval("EventLocation") %>
                                    </span>
                                </div>
                                <div class="d-grid mt-2">
                                    <asp:HyperLink ID="lnkDetails" runat="server"
                                        NavigateUrl='<%# "~/EventDetails.aspx?EventId=" + Eval("EventId") %>'
                                        CssClass="btn btn-sm btn-outline-primary">View Details</asp:HyperLink>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoEvents" runat="server" CssClass="col-12 no-events" Visible="false">
                <h3>No upcoming events found.</h3>
                <p>Would you like to <asp:HyperLink ID="lnkCreateFirstEvent" runat="server"
                    NavigateUrl="~/CreateEvent.aspx" CssClass="btn btn-link">create the first one</asp:HyperLink>?</p>
            </asp:Panel>

            <asp:Label ID="lblMessage" runat="server" CssClass="alert" Visible="false" style="display: block;"></asp:Label>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server" />
