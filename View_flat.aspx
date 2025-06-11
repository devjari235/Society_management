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
    <div style="text-align: left;">
        <a href="Flat.aspx" style="color:white; text-decoration: none;"><asp:Label ID="lblFlat" runat="server" CssClass="btn btn-primary"><b><i class="bi bi-house-add-fill"></i> Add Flat</b></asp:Label></a>
       <%-- <a  href="#" style="color:white; text-decoration: none; "><asp:Label id="lblHist" runat="server" CssClass="btn btn-info"><b style="color:white;"><i class="fa fa-history"></i> Flat History</b></asp:Label></a>--%>
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
                    <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            
                            <asp:TemplateField HeaderText="Flate No">
                                <ItemTemplate>
                                  <asp:Label Text='<%#Eval("Flate_no") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Owner name">
                                <ItemTemplate>
                                    <asp:Label Text='<%#Eval("Owner_name") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Floor">
                                <ItemTemplate>
                                    <asp:Label Text='<%#Eval("Floor") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Flat Type">
                                <ItemTemplate>
                                    <asp:Label Text='<%#Eval("Flat_type") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Sqft">
                                <ItemTemplate>
                                    <asp:Label Text='<%#Eval("sqft") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Occupancy_status">
                                <ItemTemplate>
                                    <asp:Label Text='<%#Eval("Occupancy_status") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Mentanance">
                                <ItemTemplate>
                                    <asp:Label Text='<%#Eval("Mentanance") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Block">
                                <ItemTemplate>
                                    <asp:Label Text='<%#Eval("Block_name") %>' runat="server"></asp:Label>
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
