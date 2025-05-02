<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_flat.aspx.cs" Inherits="Society_management.View_flat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <script type="text/javascript">

        $(document).ready(function () {
            $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
        }) 

        </script>
       <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link href="fontawesome\css\all.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div style="margin-bottom: 20px; text-align: left;">
<%--<asp:Button ID="btnAddFlat" runat="server" Text="Add Flat" CssClass="btn btn-primary" OnClick="btnAddFlat_Click" />
<asp:Button ID="btnViewFlats" runat="server" Text="View All Flats" CssClass="btn btn-secondary" OnClick="btnViewFlats_Click" />
<asp:Button ID="btnFlatHistory" runat="server" Text="Flat History" CssClass="btn btn-info" />--%>
        <a href="Flat.aspx" style="color:white; text-decoration: none;"><asp:Label ID="lblFlat" runat="server" CssClass="btn btn-primary"><b><i class="bi bi-house-add-fill"></i> Add Flat</b></asp:Label></a>
        <a href="View_flat.aspx" style="color:white; text-decoration: none;"><asp:Label id="lblFlatView" runat="server" CssClass="btn btn-secondary"><b><i class="bi bi-eye-fill"></i> View All Flats</b></asp:Label></a>
        <a  href="#" style="color:white; text-decoration: none; "><asp:Label id="lblHist" runat="server" CssClass="btn btn-info"><b style="color:white;"><i class="fa fa-history"></i> Flat History</b></asp:Label></a>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
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
                    <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" DataKeyNames="Flate_no">
                        <Columns>
                            <asp:BoundField DataField="Flate_no" HeaderText="Flate No" ReadOnly="true" SortExpression="Flate_no" />
                            <asp:TemplateField HeaderText="Details">
                                <ItemTemplate>
                                    <div class="container-fluid">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div class="row">
                                                    <div class="col- 12">
                                                       
                                                        &nbsp;| Floor-<asp:Label ID="lblFloor" runat="server" Text='<%#Eval("Floor") %>' Font-Bold="True" Font-Size="Large"></asp:Label>
                                                        &nbsp;| Flat Type-<asp:Label ID="lblType" runat="server" Text='<%#Eval("Flat_type") %>' Font-Bold="True" Font-Size="Large"></asp:Label>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div>
                                                        Sqft-<asp:Label ID="lblsqft" runat="server" Text='<%#Eval("sqft") %>' Font-Bold="True"></asp:Label>
                                                        &nbsp;| Occupancy_status-<asp:Label ID="lblNumber" runat="server" Text='<%#Eval("Occupancy_status") %>' Font-Bold="True"></asp:Label>

                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div>
                                                        Mentanance-<asp:Label ID="tblMentanance" runat="server" Text='<%#Eval("Mentanance") %>' Font-Bold="True" Font-Size="Medium"></asp:Label>
                                                        &nbsp;| Block-<asp:Label ID="lblBlock" runat="server" Text='<%#Eval("Block_name") %>' Font-Size="Medium" Font-Bold="True"></asp:Label>

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
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
