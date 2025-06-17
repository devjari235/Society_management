<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_Complaint_Details.aspx.cs" Inherits="Society_management.User_Complaint_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* --- Styles for the Main Details Table --- */
        /* These custom table styles will be applied,
           but Bootstrap's .table and .table-responsive will enhance them. */
        table.complaint-details-table { /* Added a specific class to avoid affecting other tables */
            width: 100%; /* Ensure it takes full width of its parent */
            border-collapse: collapse;
            font-family: Arial, sans-serif;
            margin-bottom: 25px; /* Add some spacing below the table */
        }

        table.complaint-details-table th, 
        table.complaint-details-table td {
            padding: 12px;
            border: 1px solid #ddd;
            vertical-align: top; /* Align content to the top for better multi-line text display */
        }

        table.complaint-details-table th {
            background-color: #f4f4f4;
            text-align: left;
            width: 30%; /* Keep this for desktop, table-responsive handles overflow on mobile */
            white-space: nowrap; /* Prevent headers from wrapping too aggressively */
        }

        /* --- Card Styles --- */
        /* Using a custom class to avoid potential conflicts and keep your specific styling */
        .custom-card {
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin: 20px auto; /* Adjust margin for better spacing */
            width: 95%; /* Make it more responsive than fixed 90% */
            max-width: 900px; /* Optional: cap max width on very large screens */
            background-color: #fff;
        }

        h2 {
            text-align: center;
            color: #007bff;
            margin-bottom: 20px; /* Added margin-bottom for spacing below heading */
        }

        /* --- Action Button Group Styles --- */
        .action-button-group {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-bottom: 20px; /* Adjusted margin-bottom */
            width: 100%;
        }

        .btn-back-to-complaints { /* Specific class for this button */
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
            background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%); /* Your original gradient */
            color: white;
        }

        .btn-back-to-complaints:hover {
            background: linear-gradient(135deg, #6c7475 0%, #4a505b 100%); /* Adjusted hover background */
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            text-decoration: none;
            color: white;
        }

        .btn-back-to-complaints i {
            margin-right: 10px;
            font-size: 18px;
        }

        .btn-back-to-complaints:active {
            transform: scale(0.98);
        }

        .btn-back-to-complaints:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(127, 140, 141, 0.5); /* Adjusted focus shadow color */
        }

        /* --- Responsive Design for Buttons --- */
        @media (max-width: 768px) {
            .action-button-group {
                flex-direction: column;
                align-items: center; /* Center buttons on mobile */
                gap: 10px;
            }
           
            .btn-back-to-complaints {
                width: 100%;
                max-width: 300px; /* Keep max-width for better aesthetics */
                padding: 15px 20px;
                font-size: 18px;
                text-align: center;
            }
        }

        /* --- Remarks Section Styles --- */
        .remarks-section {
            margin-top: 30px;
            padding-top: 20px; /* Changed to padding-top */
            border-top: 1px solid #eee;
        }

        .remark-item {
            padding: 15px;
            margin-bottom: 15px;
            background-color: #f9f9f9;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }

        .remark-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
            /* On small screens, stack the "By" and "On" fields */
            flex-direction: column; 
            align-items: flex-start;
        }
        @media (min-width: 576px) { /* Above small mobile, allow side-by-side if space */
            .remark-header {
                flex-direction: row;
                align-items: center;
            }
        }

        .remark-text {
            padding: 10px;
            background-color: white;
            border-radius: 4px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <div class="action-button-group">
        <a href="User_Complain.aspx" class="btn-back-to-complaints"> <%-- Updated class name --%>
            <i class="fas fa-arrow-left"></i>Back to Complaints
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="custom-card">
        <asp:Panel ID="pnlNotice" runat="server" Visible="false">
            <h2 class="text-center text-primary mb-4">Complaint Details</h2>
            
            <%-- Key change: Wrap the table in .table-responsive --%>
            <div class="table-responsive">
                <table class="complaint-details-table table table-bordered table-striped"> <%-- Added specific class and Bootstrap table classes --%>
                    <tr><th>Complaint Type</th><td><asp:Label ID="lbltype" runat="server" /></td></tr>
                    <tr><th>Description</th><td><asp:Label ID="lblDescription" runat="server" /></td></tr>
                    <tr><th>Block Name</th><td><asp:Label ID="lblblock" runat="server" /></td></tr>
                    <tr><th>Flat No</th><td><asp:Label ID="lblNo" runat="server" /></td></tr>
                    <tr><th>Complaint By</th><td><asp:Label ID="lblBy" runat="server" /></td></tr>
                    <tr><th>Complaint Date</th><td><asp:Label ID="lblCDate" runat="server" /></td></tr>
                    <tr><th>Resolve Date</th><td><asp:Label ID="lblRDate" runat="server" /></td></tr>
                    <tr><th>Status</th><td><asp:Label ID="lblStatus" runat="server" /></td></tr>
                    <tr><th>Priority</th><td><asp:Label ID="lblPriority" runat="server" /></td></tr>
                    <tr><th>Attachment</th>
                        <td>
                            <asp:HyperLink runat="server" ID="hlAttachment" NavigateUrl='<%# Eval("image") %>'
                                Text="📎 View Attachment" Target="_blank"
                                CssClass="btn btn-sm btn-outline-secondary mt-2"
                                Visible='<%# !string.IsNullOrEmpty(Eval("image").ToString()) %>' />
                        </td>
                    </tr>
                </table>
            </div>

            <div class="remarks-section">
                <h3 class="mb-3">Remarks</h3>
                <asp:Repeater ID="rptRemarks" runat="server">
                    <ItemTemplate>
                        <div class="remark-item">
                            <div class="remark-header">
                                <span>By: <%# Eval("AdminName") %></span>
                                <span>On: <%# Eval("RemarkDate", "{0:dd MMM &nbsp; hh:mm tt}") %></span> <%-- Adjusted spacing here --%>
                            </div>
                            <div class="remark-text">
                                <%# Eval("RemarkText") %>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:Label ID="lblEmptyRemarks" runat="server" 
                            Text="No remarks yet." 
                            CssClass="text-muted fst-italic" 
                            Visible='<%# ((Repeater)Container.NamingContainer).Items.Count == 0 %>' />
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>
        <asp:Label ID="lblMessage" runat="server" ForeColor="Red" CssClass="text-center d-block mt-4" />
    </div>
</asp:Content>

<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>