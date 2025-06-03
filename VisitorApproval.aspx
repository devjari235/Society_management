<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="VisitorApproval.aspx.cs" Inherits="Society_management.VisitorApproval" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap dropdowns) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap JS Bundle with Popper (required for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Font Awesome (for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
        }
        #container {
            max-width: 1200px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .status-approved {
            color: #28a745;
            font-weight: bold;
        }
        .status-pending {
            color: #ffc107;
            font-weight: bold;
        }
        .status-rejected {
            color: #dc3545;
            font-weight: bold;
        }

        .create-notice-container {
            display: flex;
            justify-content: flex-end;
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
            text-decoration: none;
        }

            .btn-create-notice:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
                color: #FFD700;
                background: linear-gradient(135deg, #9d3df1 0%, #5b1ae6 100%);
                text-decoration: none;
            }

            .btn-create-notice i {
                margin-right: 10px;
                font-size: 1.2rem;
            }
    </style>
                <style>
 /* Page Title Buttons Container */
.page-title-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
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
    background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
}

.btn-Expire{
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
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
    </style>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="page-title-buttons">
        <div class="button-group-left">

            <a href="ScheduledVisitors.aspx" class="dashboard-btn btn-Dashboard">
                <i class="bi-check-circle-fill"></i>Check Scheduled Visitors
            </a>

        </div>
        <a href="VisitorEntry.aspx" class="dashboard-btn btn-create">
            <i class="fas fa-plus-circle"></i>Visitor Entry
        </a>
    </div>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">   
            <asp:GridView ID="gvVisitorApprovals" runat="server" AutoGenerateColumns="False"
                CssClass="table table-striped table-bordered"
                OnRowCommand="gvVisitorApprovals_RowCommand"
                DataKeyNames="VisitorID" OnRowDataBound="gvVisitorApprovals_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Visitor Name" />
                    <asp:BoundField DataField="ContactNumber" HeaderText="Contact Number" />
                    <asp:BoundField DataField="VisitPurpose" HeaderText="Purpose" />
                    <asp:BoundField DataField="VisitDateTime" HeaderText="Visit Time" DataFormatString="{0:g}" />
                    <asp:TemplateField HeaderText="Approval Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" 
                                CssClass='<%# ((Society_management.VisitorApproval)Page).GetStatusCssClass(Eval("IsApproved")) %>'
                                Text='<%# ((Society_management.VisitorApproval)Page).GetStatusText(Eval("IsApproved")) %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnSchedule" runat="server" Text="Schedule" 
                                CommandName="Schedule" 
                                CommandArgument='<%# Eval("VisitorID") %>'
                                CssClass="btn btn-primary btn-sm" 
                                Visible='<%# ((Society_management.VisitorApproval)Page).IsApproved(Eval("IsApproved")) %>' />
                        </ItemTemplate>
                        <ItemTemplate>
                            <asp:Button ID="btnCheckIn" runat="server" Text="Check In" CommandName="CheckIn" 
                                CommandArgument='<%# Eval("VisitorID") %>' 
                                CssClass="btn btn-success btn-action" />
                            <asp:Button ID="btnCheckOut" runat="server" Text="Check Out" CommandName="CheckOut" 
                                CommandArgument='<%# Eval("VisitorID") %>' 
                                CssClass="btn btn-warning btn-action" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-dismissible fade show" Visible="false"></asp:Label>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
