<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_ExpireNotice.aspx.cs" Inherits="Society_management.User_ExpireNotice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
     <script type="text/javascript">
     $(document).ready(function () {
         $('.table').prepend($('<thead></thead>').append($('.table').find('tr:first'))).dataTable();
     });
     </script>
            <style>
 /* Page Title Buttons Container */
.page-title-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    flex-wrap: wrap;
    
}

/* Left-aligned button group */
.button-group-left {
    display: flex;
    gap: 10px;
}

/* Base Button Style */
.dashboard-btn {
    padding: 10px 20px;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 600;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    cursor: pointer;
    text-decoration: none;
    color: white;
    border: none;
}

.dashboard-btn i {
    margin-right: 8px;
    font-size: 1rem;
}

/* Individual Button Colors */
.btn-create {
    background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
    margin-left: auto; /* Pushes Create button to the right */
}

.btn-Dashboard {
     background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}

.btn-Live {
    background: linear-gradient(135deg, #0f9b0f 0%, #043927 100%);
}
.btn-All {
    background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
}

/* Hover Effects */
.dashboard-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    color: #FFD700;
    text-decoration:none;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .page-title-buttons {
        flex-direction: column;
        gap: 8px;
    }
    
    .button-group-left {
        width: 100%;
        justify-content: space-between;
    }
    
    .btn-create {
        width: 100%;
        margin-left: 0;
        order: -1; /* Moves Create button to top on mobile */
    }
    
    .dashboard-btn {
        width: 100%;
        text-align: center;
        justify-content: center;
    }
}
.notice-scroller-container {
        max-height: 600px; /* Adjust height as needed */
        overflow-y: auto;
        padding-right: 10px; /* Prevents content from touching scrollbar */
    }

    /* Custom scrollbar styling */
    .notice-scroller-container::-webkit-scrollbar {
        width: 8px;
    }

    .notice-scroller-container::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    .notice-scroller-container::-webkit-scrollbar-thumb {
        background: #888;
        border-radius: 10px;
    }

    .notice-scroller-container::-webkit-scrollbar-thumb:hover {
        background: #555;
    }

    /* Adjust card spacing for scroller */
    .swiper-slide {
        margin-bottom: 20px;
    }

    /* Remove any fixed heights from cards if they exist */
    .notice-card {
        height: auto !important;
    }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
        <div class="page-title-buttons">
    <div class="button-group-left">
        <a href="User_NoticeDashboard.aspx" class="dashboard-btn btn-Dashboard">
            <i class="fas fa-arrow-left"></i>Notice Dashboard
        </a>
        <a href="User_ViewAllNotice.aspx" class="dashboard-btn btn-All">
           <i class="fas fa-clipboard-list"></i> All Notice
       </a>
        <a href="User_LiveNotice.aspx" class="dashboard-btn btn-Live">
            <i class="fas fa-broadcast-tower"></i> Live Notice
        </a>
        
    </div>
    <a href="User_CreateNotice.aspx" class="dashboard-btn btn-create">
        <i class="fas fa-plus-circle"></i> Create Notice
    </a>
</div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <asp:Panel CssClass="alert alert-success" role="alert" ID="Panel1" runat="server" Visible="false">
                <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
            </asp:Panel>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="table-responsive">
                <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" OnRowCommand="gvDisplay_RowCommand" >
                    <Columns>
                        
                        <asp:TemplateField HeaderText="Title">
                            <ItemTemplate>
                              <asp:Label Text='<%#Eval("Title") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Posted Date">
                            <ItemTemplate>
                                <asp:Label Text='<%# Eval("Posted_date", "{0:dd MMM yyyy}") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label Text='<%# Eval("Expiry_date", "{0:dd MMM yyyy}") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Importance">
                            <ItemTemplate>
                                <asp:Label Text='<%#Eval("Importance") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label Text='<%#Eval("Status") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                               <asp:Button ID="btnView" runat="server" Text="View" CommandName="ViewNotice" CommandArgument='<%# Eval("Notice_id") %>' Style="background-color:aquamarine; color:black" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
