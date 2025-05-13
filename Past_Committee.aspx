<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Past_Committee.aspx.cs" Inherits="Society_management.Past_Committee" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
            <script type="text/javascript">

$(document).ready(function () {
    $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
}) 

            </script>
            <style>
 /* Page Title Buttons Container */
.page-title-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
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

.btn-Expire{
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
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
    
    .btn-create {
        width: 100%;
        margin-left: 0;
        order: -1; /* Moves Create button to top on mobile */
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
   <a href="View_CommiteeMember.aspx" class="dashboard-btn btn-Dashboard">
        <i class="fas fa-arrow-left"></i>Back to Details
   </a>
           </div>
     <a href="CommiteeMember.aspx" class="dashboard-btn btn-create">
         <i class="fas fa-plus-circle"></i> Create Committee
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
