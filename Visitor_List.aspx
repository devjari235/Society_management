<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Visitor_List.aspx.cs" Inherits="Society_management.Visitor_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
          <script type="text/javascript">

              $(document).ready(function () {
                  $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
              })

          </script>
       <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
<link href="fontawesome\css\all.css" rel="stylesheet" />
    <style>
    /* Button Group Container */
    .action-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
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
    /* =========================================
   EMPTY STATE COMPONENT 
========================================= */
.empty-state-container {
    padding: 60px 20px;
    text-align: center;
    background-color: #ffffff;
    border-radius: 1rem;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 6rem rgba(0,0,0,0.05);
    margin-top: 15px;
    width: 100%;
}

.empty-state-icon {
    font-size: 4rem;
    color: #57606f;
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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
        <div class="action-button-group">
    <a href="MemberApproval.aspx" class="btn-register-notice">
        <i class="fas fa-arrow-left"></i>Back to Details
    </a>
</div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        
        <%-- ── Empty State Panel: Renders when total rows evaluate to 0 ── --%>
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container">
                <div class="empty-state-icon">
                    <i class="fas fa-history"></i>
                </div>
                <h3 class="empty-state-title">No Visitor History</h3>
                <p class="text-muted mb-0">
                    There are no recorded checkout timestamps or completed logs found in your visitor history.
                </p>
            </div>
        </asp:Panel>

        <%-- ── Data Presentation Content Placeholder Wrapper ── --%>
        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="table-responsive">
                        <asp:GridView ID="gvPendingVisitors" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered">
                            <Columns>
                                <asp:TemplateField HeaderText="Name">
                                    <ItemTemplate>
                                        <b><asp:Label Text='<%#Eval("Name") %>' runat="server"></asp:Label></b>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Contact Number">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("ContactNumber") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Visit Purpose">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("VisitPurpose") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Check-In Time">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("CheckInTime", "{0:dd MMM yyyy hh:mm tt}") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Check-Out Time">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("CheckOutTime", "{0:dd MMM yyyy hh:mm tt}") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </asp:PlaceHolder>

    </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
