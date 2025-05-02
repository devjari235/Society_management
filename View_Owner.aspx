<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Owner.aspx.cs" Inherits="Society_management.View_Owner" %>
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
<asp:Label ID="lblOwner" runat="server" CssClass="btn btn-primary"><b><a href="Owner.aspx" style="color:black; text-decoration: none;">Add Owner</a></b></asp:Label>
<asp:Label id="lblFlatView" runat="server" CssClass="btn btn-secondary"><b><a href="View_Owner.aspx" style="color:black; text-decoration: none;">View All Owner</a></b></asp:Label>
<asp:Label id="lblHist" runat="server" CssClass="btn btn-info"><b><a  href="#" style="color:black; text-decoration: none; ">Owner History</a></b></asp:Label>
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
         
         <asp:TemplateField HeaderText="Block Name">
             <ItemTemplate>
               <asp:Label Text='<%#Eval("Block_name") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Flat Number">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Flate_no") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Owner name">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Owner_name") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Email">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Email_id") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Contact Number">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Contact_no") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Emergency Number">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Emergency_Number") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Total Member">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Total_member") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Allotment Date">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Allotment_Date") %>' runat="server"></asp:Label>
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
