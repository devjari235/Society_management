<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="VisitorEntry.aspx.cs" Inherits="Society_management.VisitorEntry" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        
        .form-container {
            background-color: white;
            width: 600px;
            margin: 0 auto;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        
        h2 {
            color: #444;
            margin-bottom:50px;
        }

        .form-row {
            margin-bottom: 15px;
        }
        
        .form-label {
            display: inline-block;
            width: 150px;
            font-weight: bold;
            vertical-align: top;
        }
        
        .form-control {
            width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        textarea.form-control {
            height: 80px;
        }
        
        .form-buttons {
            margin-top: 20px;
        }
        
        #btnSubmit,#btnCheckScheduled {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        
        .btn-secondary {
            background-color: #7f8c8d;
            color: white;
        }
        
        .message {
            margin-top: 20px;
            padding: 10px;
            border-radius: 4px;
        }
        
        .success {
            background-color: #dff0d8;
            color: #3c763d;
        }
        
        .error {
            background-color: #f2dede;
            color: #a94442;
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
.dashboard-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    color: #FFD700;
    text-decoration:none;
}
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
.btn-Live {
    background: linear-gradient(135deg, #0f9b0f 0%, #043927 100%);
}
.btn-create {
   background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="button-group-left">
        <a href="VisitorApproval.aspx" class="dashboard-btn btn-Live">
            <i class="bi-check-circle"></i>Check Approval
        </a>
        <a href="ScheduledVisitors.aspx" class="dashboard-btn btn-create">
            <i class="bi-check-circle-fill"></i>Check Scheduled Visitors
        </a>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-container">
            <h3><b>New Visitor Entry</b></h3>
            <p>&nbsp;</p>
            <div class="form-row">
                <asp:Label ID="lblVisitorName" runat="server" Text="Visitor Name:" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtVisitorName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div class="form-row">
                <asp:Label ID="lblContactNumber" runat="server" Text="Contact Number:" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtContactNumber" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div class="form-row">
                <asp:Label ID="lblVisitPurpose" runat="server" Text="Visit Purpose:" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtVisitPurpose" runat="server" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>
            </div>
        <div class="form-row">
            <asp:Label ID="lblBlock" runat="server" Text="Block Name:" CssClass="form-label"></asp:Label>
            <asp:DropDownList ID="ddlBlock" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlBlock_SelectedIndexChanged"></asp:DropDownList>
        </div>
            <div class="form-row">
                <asp:Label ID="lblMember" runat="server" Text="Meeting With:" CssClass="form-label"></asp:Label>
                <asp:DropDownList ID="ddlMembers" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            
            <div class="form-buttons">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Visitor Entry" 
                    OnClick="btnSubmit_Click" CssClass="btn btn-primary" />
                
            </div>
        </div>
    
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
