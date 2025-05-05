<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="NoticeDashboard.aspx.cs" Inherits="Society_management.NoticeDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Dashboard Cards Styling */
.dashboard-card {
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    border: none;
    color: white;
    position: relative;
    overflow: hidden;
}

.dashboard-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.card-1 {
    background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
}

.card-2 {
    background: linear-gradient(135deg, #0f9b0f 0%, #043927 100%);
}

.card-3 {
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%); 
}

.card-icon {
    font-size: 2.5rem;
    margin-bottom: 15px;
}

.card-title {
    font-size: 1rem;
    font-weight: 500;
    margin-bottom: 10px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.card-value {
    font-size: 2.2rem;
    font-weight: 700;
    margin-bottom: 20px;
}

.card-footer-link {
    color: white;
    text-decoration: none;
    font-size: 0.9rem;
    display: inline-block;
    padding: 5px 10px;
    border-radius: 20px;
    background-color: rgba(255, 255, 255, 0.2);
    transition: all 0.3s ease;
}

.card-footer-link:hover {
    background-color: rgba(255, 255, 255, 0.3);
    color: white;
    text-decoration: none;
}

/* Full width container */
.row.mb-4 {
    width: 100%;
    margin: 0 auto;
    padding: 0 15px;
}
.btn-create-notice {
            background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            text-decoration:none;
        }
        
        .btn-create-notice:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            color: #FFD700;
            background: linear-gradient(135deg, #9d3df1 0%, #5b1ae6 100%);
            text-decoration:none;
        }
        
        .btn-create-notice i {
            margin-right: 10px;
            font-size: 1.2rem;
        }


/* Responsive adjustments */
@media (max-width: 768px) {
    .col-xl-3, .col-md-6 {
        flex: 0 0 100%;
        max-width: 100%;
    }
    
    .card-value {
        font-size: 1.8rem;
    }
}

@media (min-width: 768px) and (max-width: 1199px) {
    .col-md-6 {
        flex: 0 0 50%;
        max-width: 50%;
    }
}

@media (min-width: 1200px) {
    .col-xl-3 {
        flex: 0 0 33.333333%;
        max-width: 33.333333%;
    }
}
.create-notice-container{
    display: flex; 
    justify-content: flex-end;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="create-notice-container">
            <a href="CreateNotice.aspx" class="btn-create-notice">
                <i class="fas fa-plus-circle"></i> Create Notice
            </a>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
     <div class="row mb-4">
     <div class="col-xl-3 col-md-6 mb-4">
         <div class="dashboard-card card-1 h-100 py-2">
             <div class="card-body text-center">
                 <div class="card-icon">
                   <i class="fas fa-clipboard-list"></i>
                 </div>
                 <div class="card-title">TOTAL Notice</div>
                 <div class="card-value"><asp:Label ID="lblTotalNotice" runat="server" Text="0" /></div>
                 <a href="View_Allnotice.aspx" class="card-footer-link">View All Notice <i class="fas fa-arrow-right"></i></a>
             </div>
         </div>
     </div>
     
     <div class="col-xl-3 col-md-6 mb-4">
         <div class="dashboard-card card-2 h-100 py-2">
             <div class="card-body text-center">
                 <div class="card-icon">
                     <i class="fas fa-broadcast-tower"></i> 
                 </div>
                 <div class="card-title">TOTAL Live Notice</div>
                 <div class="card-value"><asp:Label ID="lblTotalLive" runat="server" Text="0" /></div>
                 <a href="LiveNotice.aspx" class="card-footer-link">View Live Notice <i class="fas fa-arrow-right"></i></a>
             </div>
         </div>
     </div>
     
     <div class="col-xl-3 col-md-6 mb-4">
         <div class="dashboard-card card-3 h-100 py-2">
             <div class="card-body text-center">
                 <div class="card-icon">
                     <i class="far fa-calendar-times"></i>
                 </div>
                 <div class="card-title">TOTAL Expire Notice</div>
                 <div class="card-value"><asp:Label ID="lblTotalExpire" runat="server" Text="0" /></div>
                 <a href="ExpireNotice.aspx" class="card-footer-link">View Expire Notice <i class="fas fa-arrow-right"></i></a>
             </div>
         </div>
     </div>
  </div>    
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
