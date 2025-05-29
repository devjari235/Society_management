<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="CreateEvent.aspx.cs" Inherits="Society_management.CreateEvent" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<style>
    .form-container {
        max-width: 800px;
        margin: 30px auto;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    }
    .form-header {
        text-align: center;
        margin-bottom: 30px;
        color: #343a40;
    }
</style>
                <style>
    /* Button Group Container */
    .action-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        margin: 15px 0;
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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
     <div class="action-button-group">
     <a href="ViewEvents.aspx" class="btn-register-notice">
         <i class="fas fa-arrow-left"></i>Back to Details
     </a>
 </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
     <div class="container">
     <div class="form-container bg-white">
         <h2 class="form-header">Create New Event</h2>
         
         <div class="mb-3">
             <label for="txtEventName" class="form-label">Event Name</label>
             <asp:TextBox ID="txtEventName" runat="server" CssClass="form-control" required="true"></asp:TextBox>
         </div>
         
         <div class="mb-3">
             <label for="txtEventDescription" class="form-label">Event Description</label>
             <asp:TextBox ID="txtEventDescription" runat="server" CssClass="form-control" 
                 TextMode="MultiLine" Rows="4" required="true"></asp:TextBox>
         </div>
         
         <div class="row mb-3">
             <div class="col-md-6">
                 <label for="txtEventDate" class="form-label">Event Date</label>
                 <asp:TextBox ID="txtEventDate" runat="server" CssClass="form-control" 
                     TextMode="DateTimeLocal" required="true"></asp:TextBox>
             </div>
             <div class="col-md-6">
                 <label for="txtEventLocation" class="form-label">Location</label>
                 <asp:TextBox ID="txtEventLocation" runat="server" CssClass="form-control" required="true"></asp:TextBox>
             </div>
         </div>
         
         <div class="row mb-3">
             <div class="col-md-6">
                 <label for="txtOrganizerName" class="form-label">Organizer Name</label>
                 <asp:TextBox ID="txtOrganizerName" runat="server" CssClass="form-control" required="true"></asp:TextBox>
             </div>
             <div class="col-md-6">
                 <label for="txtOrganizerEmail" class="form-label">Organizer Email</label>
                 <asp:TextBox ID="txtOrganizerEmail" runat="server" CssClass="form-control" 
                     TextMode="Email" required="true"></asp:TextBox>
             </div>
         </div>
         
         <div class="mb-3">
             <label for="fileEventImage" class="form-label">Event Image (Optional)</label>
             <asp:FileUpload ID="fileEventImage" runat="server" CssClass="form-control" />
         </div>
         
         <div class="d-grid gap-2">
             <asp:Button ID="btnCreateEvent" runat="server" Text="Create Event" 
                 CssClass="btn btn-primary btn-lg" OnClick="btnCreateEvent_Click" />
             <asp:HyperLink ID="lnkViewEvents" runat="server" NavigateUrl="~/ViewEvents.aspx" 
                 CssClass="btn btn-outline-secondary">View All Events</asp:HyperLink>
         </div>
         
         <div class="mt-3">
             <asp:Label ID="lblMessage" runat="server" CssClass="text-success" Visible="false"></asp:Label>
         </div>
     </div>
 </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
