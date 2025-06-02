<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="VisitorEntry.aspx.cs" Inherits="Society_management.VisitorEntry" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
.dashboard-btn {
    display: inline-flex;
    align-items: center;
    padding: 8px 14px;
    background: #2d3748; /* Dark slate (gray-blue) */
    color: #e2e8f0;    /* Light gray text */
    text-decoration: none;
    border-radius: 5px;
    border: 1px solid #4a5568; /* Slightly darker border */
    font-size: 14px;
    transition: all 0.2s ease;
    box-shadow: 0 2px 3px rgba(0, 0, 0, 0.1);
}

.dashboard-btn:hover {
    background: #3c4657; /* Lighter slate on hover */
    border-color: #5a6778;
    transform: translateY(-1px); /* Slight lift effect */
    text-decoration:none;
}

.dashboard-btn i {
    margin-right: 8px;
    font-size: 13px;
    color: #a0aec0; /* Subdued icon color */
}.button-group-left{
    text-decoration:none;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="button-group-left">
        <a href="VisitorApproval.aspx" class="dashboard-btn btn-Dashboard">
            <i class="fas fa-arrow-left"></i>Check Approval
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
                <asp:Button ID="btnCheckScheduled" runat="server" Text="Check Scheduled Visitors" 
                    OnClick="btnCheckScheduled_Click" CssClass="btn btn-secondary" />
            </div>
        </div>
    
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
