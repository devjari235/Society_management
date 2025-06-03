<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="ScheduledVisitors.aspx.cs" Inherits="Society_management.ScheduledVisitors" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
        }
        .btn-action {
            min-width: 100px;
            margin: 2px;
        }
        .disabled-btn {
            opacity: 0.65;
            cursor: not-allowed;
        }
        .btn-Dashboard {
    background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}
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
          background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
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
         
         .dashboard-btn {
             width: 100%;
             text-align: center;
             justify-content: center;
         }
     }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
      <div class="page-title-buttons">
     <div class="button-group-left">
         <a href="VisitorApproval.aspx" class="dashboard-btn btn-Dashboard">
             <i class="fas fa-arrow-left"></i>Back to Details
         </a>        
     </div>
 </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
            <h1 class="mb-4">Scheduled Visitors</h1>
            
            <asp:GridView ID="gvScheduledVisitors" runat="server" AutoGenerateColumns="False"
                CssClass="table table-striped table-bordered"
                OnRowCommand="gvScheduledVisitors_RowCommand"
                OnRowDataBound="gvScheduledVisitors_RowDataBound"
                DataKeyNames="ScheduleID,IsCompleted">
                <Columns>
                    <asp:BoundField DataField="VisitorName" HeaderText="Visitor Name" />
                    <asp:BoundField DataField="ContactNumber" HeaderText="Contact" />
                    <asp:BoundField DataField="ScheduledDateTime" HeaderText="Scheduled Time" DataFormatString="{0:g}" />
                    <asp:BoundField DataField="Purpose" HeaderText="Purpose" />
                    <asp:BoundField DataField="MemberName" HeaderText="Meeting With" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnCheckIn" runat="server" Text="Check In" CommandName="CheckIn" 
                                CommandArgument='<%# Eval("ScheduleID") %>' 
                                CssClass="btn btn-success btn-action" />
                            <asp:Button ID="btnCheckOut" runat="server" Text="Check Out" CommandName="CheckOut" 
                                CommandArgument='<%# Eval("ScheduleID") %>' 
                                CssClass="btn btn-warning btn-action" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            
            <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-dismissible fade show" Visible="false"></asp:Label>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
