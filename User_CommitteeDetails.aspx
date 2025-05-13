<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_CommitteeDetails.aspx.cs" Inherits="Society_management.User_CommitteeDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
     <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <script type="text/javascript">

        $(document).ready(function () {
            $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
        })

    </script>
    <style>
        .img-fluid {
            height: 150px;
            width: 150px;
            border-radius: 50%;
        }

        .button-group-left {
            display: flex;
            gap: 10px;
        }

        @media (max-width: 768px) {


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

        .btn-Dashboard {
            background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
        }

        .dashboard-btn i {
            margin-right: 8px;
            font-size: 1rem;
        }

        .dashboard-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            color: #FFD700;
            text-decoration: none;
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
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
    <div class="button-group-left">
        <a href="User_Past_Committee.aspx" class="dashboard-btn btn-Dashboard">
            <i class="bi bi-hourglass-bottom"></i> Past Committee
        </a>
        </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-sm-12">
                <center>
                    <h3>Committee Member List
                    </h3>
                </center>
            </div>
        </div>
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
                    <asp:GridView CssClass="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvDisplay_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="Committee Member">
                                <ItemTemplate>
                                    <asp:Image CssClass="img-fluid" ID="Image1" ImageUrl='<%#Eval("Photo","~/Profile/{0}") %>' runat="server"/>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Details">
                                <ItemTemplate>
                                    <div class="container-fluid">
                                        <div class="row">
                                            <div class="col-lg-10">
                                                <div class="row">
                                                    <div class="col- 12">
                                                        <asp:Label ID="lbldes" runat="server" Text='<%#Eval("Designation") %>' Font-Bold="True" Font-Size="X-Large"></asp:Label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div>

                                                        <asp:Label ID="lblName" runat="server" Text='<%#Eval("User_name") %>' Font-Bold="True"></asp:Label>
                                                        &nbsp;|
                                                        <asp:Label ID="lblRole" runat="server" Text='<%#Eval("Role") %>' Font-Bold="True"></asp:Label>

                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div>

                                                        <asp:Label ID="lblEmail" runat="server" Text='<%#Eval("Email") %>' Font-Bold="True" Font-Size="Medium"></asp:Label>
                                                        &nbsp;|
                                                        <asp:Label ID="lblphone" runat="server" Text='<%#Eval("Phone_no") %>' Font-Size="Medium" Font-Bold="True"></asp:Label>

                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div>

                                                        <asp:Label ID="lblBlock_name" runat="server" Text='<%#Eval("Block_name") %>' Font-Bold="True" Font-Size="Medium"></asp:Label>
                                                        &nbsp;|
                                    <asp:Label ID="lblFlat_no" runat="server" Text='<%#Eval("Flat_no") %>' Font-Size="Medium" Font-Bold="True"></asp:Label>

                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div>

                                                        <asp:Label ID="lblFrom_Date" runat="server" Text='<%#Eval("From_Date", "{0:dd MMM yyyy}") %>' Font-Bold="True" Font-Size="Medium"></asp:Label>
                                                        --<asp:Label ID="lblTo_date" runat="server" Text='<%#Eval("To_date", "{0:dd MMM yyyy}") %>' Font-Size="Medium" Font-Bold="True"></asp:Label>

                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div>

                                                        <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("Status") %>' Font-Bold="True" Font-Size="Medium" CssClass="badge bg-success"></asp:Label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
