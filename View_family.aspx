<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="View_family.aspx.cs" Inherits="Society_management.View_family" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">

        $(document).ready(function () {
            $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
        })

    </script>

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
    .btn-register-notice,
    .btn-view-notice {
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


    /* View Button */
    .btn-view-notice {
        background-color: #3498db;
        color: white;
    }

    .btn-view-notice:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        text-decoration:none;
        color: white;
    }

    /* Icons */
    .btn-register-notice i,
    .btn-view-notice i {
        margin-right: 10px;
        font-size: 18px;
    }

    /* Active State */
    .btn-register-notice:active,
    .btn-view-notice:active {
        transform: scale(0.98);
    }

    /* Focus State */
    .btn-register-notice:focus,
    .btn-view-notice:focus {
        outline: none;
    }

    .btn-register-notice:focus {
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.5);
    }

    .btn-view-notice:focus {
        box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.5);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .action-button-group {
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
        }
        
        .btn-register-notice,
        .btn-view-notice {
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
}

.empty-state-icon {
    font-size: 4rem;
    color: #4e73df;
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
     <a href="Myflat.aspx" class="btn-register-notice">
     <i class="fas fa-arrow-left"></i> Back to Details
 </a>
    <a href="Family_member.aspx" class="btn-view-notice">
        <i class="fas fa-user-plus"></i> Register a member
    </a>
</div>
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

        <%-- ── Empty State Panel: Renders when no records exist ── --%>
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container">
                <div class="empty-state-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="empty-state-title">No Family Members Registered</h3>
                <p class="text-muted mb-0">
                    You haven't added any family members to your profile yet. Click "Register a member" above to add your family details.
                </p>
            </div>
        </asp:Panel>

        <%-- ── Data Content Placeholder: Renders when records exist ── --%>
        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="row">
                <div class="col-sm-12 col-md-12">
                    <div class="table-responsive">
                        <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:TemplateField HeaderText="Member Name">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("Member_name") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Email">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("Email") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Phone Number">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("Phone_no") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Age">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("Age") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Gender">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("Gender") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Relationship">
                                    <ItemTemplate>
                                        <asp:Label Text='<%#Eval("Relationship") %>' runat="server"></asp:Label>
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
