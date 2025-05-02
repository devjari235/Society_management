<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_flat.aspx.cs" Inherits="Society_management.View_flat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <script type="text/javascript">

        $(document).ready(function () {
            $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
        }) 

        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div style="margin-bottom: 20px; text-align: left;">
<%--<asp:Button ID="btnAddFlat" runat="server" Text="Add Flat" CssClass="btn btn-primary" OnClick="btnAddFlat_Click" />
<asp:Button ID="btnViewFlats" runat="server" Text="View All Flats" CssClass="btn btn-secondary" OnClick="btnViewFlats_Click" />
<asp:Button ID="btnFlatHistory" runat="server" Text="Flat History" CssClass="btn btn-info" />--%>
               <asp:Label ID="lblFlat" runat="server" CssClass="btn btn-primary"><b><a href="Flat.aspx" style="color:black; text-decoration: none;">Add Flat</a></b></asp:Label>
        <asp:Label id="lblFlatView" runat="server" CssClass="btn btn-secondary"><b><a href="View_flat.aspx" style="color:black; text-decoration: none;">View All Flats</a></b></asp:Label>
        <asp:Label id="lblHist" runat="server" CssClass="btn btn-info"><b><a  href="#" style="color:black; text-decoration: none; ">Flat History</a></b></asp:Label>
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
