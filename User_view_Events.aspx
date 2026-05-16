<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_view_Events.aspx.cs" Inherits="Society_management.User_view_Events" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
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
      }/* =========================================
   EMPTY STATE COMPONENT 
========================================= */
.empty-state-container {
    padding: 60px 20px;
    text-align: center;
    background-color: #ffffff;
    border-radius: 1rem;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 6rem rgba(0,0,0,0.05);
    margin: 30px auto;
    max-width: 800px;
}

.empty-state-icon {
    font-size: 4rem;
    color: #0d6efd;
    opacity: 0.2;
    margin-bottom: 1.5rem;
    display: inline-block;
    animation: float 3s ease-in-out infinite;
}

@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
    100% { transform: translateY(0px); }
}

.empty-state-title {
    color: #1e293b;
    font-weight: 700;
    margin-bottom: 10px;
}

  </style>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center no-border-header">
            <h1>Upcoming Events</h1>
        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <asp:Label ID="lblMessage" runat="server" CssClass="alert" Visible="false" style="display: block;"></asp:Label>

        <%-- ── New Animated Empty State Panel (Old card completely replaced) ── --%>
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container">
                <div class="empty-state-icon">
                    <i class="bi bi-calendar-x"></i>
                </div>
                <h3 class="empty-state-title">No Upcoming Events</h3>
                <p class="text-muted mb-0">
                    There are no dynamic functions, general body meetings, or holiday celebrations scheduled at this moment.
                </p>
            </div>
        </asp:Panel>

        <%-- ── Data Presentation Grid Container Wrapper ── --%>
        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="row">
                <asp:Repeater ID="rptEvents" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 d-flex align-items-stretch">
                            <div class="card event-card shadow-sm w-100">
                                <asp:Image ID="imgEvent" runat="server"
                                    ImageUrl='<%# Society_management.User_view_Events.GetImageUrl(Eval("ImageUrl")) %>'
                                    CssClass="card-img-top event-image" AlternateText="Event Image" />
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title text-primary fw-bold"><%# Eval("EventName") %></h5>
                                    <p class="card-text text-muted flex-grow-1"><%# Society_management.User_view_Events.TruncateDescription(Eval("EventDescription").ToString()) %></p>
                                </div>
                                <div class="card-footer bg-transparent border-top-0">
                                    <div class="d-flex justify-content-between align-items-center small mb-3">
                                        <span class="event-date">
                                            <i class="bi bi-calendar-event me-1"></i>
                                            <%# Society_management.User_view_Events.FormatDate(Eval("EventDate")) %>
                                        </span>
                                        <span class="event-location">
                                            <i class="bi bi-geo-alt me-1"></i><%# Eval("EventLocation") %>
                                        </span>
                                    </div>
                                    <div class="d-grid">
                                        <asp:HyperLink ID="lnkDetails" runat="server"
                                            NavigateUrl='<%# "User_Event_Details.aspx?EventId=" + Eval("EventId") %>'
                                            CssClass="btn btn-sm btn-outline-primary fw-semibold">View Details</asp:HyperLink>
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
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
