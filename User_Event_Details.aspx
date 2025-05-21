<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_Event_Details.aspx.cs" Inherits="Society_management.User_Event_Details" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- jQuery (must come first) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Popper.js (required for Bootstrap dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
    .event-detail-container {
        max-width: 900px;
        margin: 30px auto;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    }
    .event-image {
        width: 100%;
        height: 400px;
        object-fit:cover;
        width: 100%;
        height: auto;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    .event-header {
        margin-bottom: 30px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eee;
    }
    .event-meta {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    .meta-item {
        margin-bottom: 10px;
    }
    .meta-label {
        font-weight: 600;
        color: #495057;
    }
    .meta-value {
        color: #212529;
    }
</style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container">
    <div class="event-detail-container bg-white">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="User_view_Events.aspx"
                CssClass="btn btn-outline-secondary">Back to Events</asp:HyperLink>
        </div>
        <div class="event-header">
            <h1 runat="server" id="lblEventName"></h1>
            <div class="d-flex justify-content-between align-items-center">
                <span class="text-muted" runat="server" id="lblEventDate"></span>
                <span class="badge bg-info" runat="server" id="lblEventLocation"></span>
            </div>
        </div>
        
        <asp:Image ID="imgEvent" runat="server" CssClass="event-image" AlternateText="Event Image" />
        
        <div class="row">
            <div class="col-md-8">
                <div class="event-description">
                    <h4>Description</h4>
                    <p runat="server" id="lblEventDescription" class="lead"></p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="event-meta">
                    <h5>Event Details</h5>
                    <div class="meta-item">
                        <span class="meta-label">Date & Time:</span>
                        <div class="meta-value" runat="server" id="lblFullEventDate"></div>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Location:</span>
                        <div class="meta-value" runat="server" id="lblFullEventLocation"></div>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Organizer:</span>
                        <div class="meta-value" runat="server" id="lblOrganizerName"></div>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Contact:</span>
                        <div class="meta-value" runat="server" id="lblOrganizerEmail"></div>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Created:</span>
                        <div class="meta-value" runat="server" id="lblCreatedDate"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
