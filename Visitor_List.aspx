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
                    <asp:GridView ID="gvPendingVisitors" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered">
                   <%--     <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Visitor Name"/>
                            <asp:BoundField DataField="ContactNumber" HeaderText="Contact Number" />
                            <asp:BoundField DataField="VisitPurpose" HeaderText="Purpose" />
                            <asp:BoundField DataField="CheckInTime" HeaderText="Visit Time" DataFormatString="{0:g}" />
                            <asp:BoundField DataField="CheckOutTime" HeaderText="Visit Time" DataFormatString="{0:g}"/>
                        </Columns>--%>
                            <Columns>
        
        <asp:TemplateField HeaderText="Name">
            <ItemTemplate>
              <asp:Label Text='<%#Eval("Name") %>' runat="server"></asp:Label>
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
        <asp:TemplateField HeaderText="Visit Time">
            <ItemTemplate>
                <asp:Label Text='<%#Eval("CheckInTime") %>' runat="server"></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="CheckOutTime">
            <ItemTemplate>
                <asp:Label Text='<%#Eval("CheckOutTime") %>' runat="server"></asp:Label>
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
