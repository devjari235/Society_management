<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_CommiteeMember.aspx.cs" Inherits="Society_management.View_CommiteeMember" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <script type="text/javascript">

$(document).ready(function () {
    $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
}) 

        </script>
    <style>
        .btn-create-notice {
            background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            text-decoration:none;
        }
        
        .btn-create-notice:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            color: #FFD700;
            background: linear-gradient(135deg, #9d3df1 0%, #5b1ae6 100%);
            text-decoration:none;
        }
        
        .btn-create-notice i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        .create-notice-container{
            display:flex;
            justify-content:flex-end;
        }
    </style>
       <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link href="fontawesome\css\all.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="create-notice-container">
        <a href="CommiteeMember.aspx" class="btn-create-notice">
            <i class="fas fa-plus-circle"></i> Create Notice
        </a>
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
                <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" OnRowCommand="gvDisplay_RowCommand">
     <Columns>
         
         <asp:TemplateField HeaderText="Committee Member ">
             <ItemTemplate>
               <asp:Label Text='<%#Eval("User_name") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Designation">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Designation") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Phone Number">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Phone_no") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>
         <asp:TemplateField HeaderText="Role">
             <ItemTemplate>
                 <asp:Label Text='<%#Eval("Role") %>' runat="server"></asp:Label>
             </ItemTemplate>
         </asp:TemplateField>         
         <asp:TemplateField HeaderText="Action">
    <ItemTemplate>
       <asp:Button ID="btnView" runat="server" Text="View" CommandName="ViewNotice" CommandArgument='<%# Eval("Committee_id") %>' Style="background-color:aquamarine; color:black" />
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
