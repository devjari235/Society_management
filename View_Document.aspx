<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Document.aspx.cs" Inherits="Society_management.View_Document" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <asp:Label ID="lblDocument" runat="server" CssClass="btn btn-primary"><b><a href="Documents.aspx" style="color:black; text-decoration: none;">Add Document</a></b></asp:Label>
    <asp:Label id="lblDocumentView" runat="server" CssClass="btn btn-secondary"><b><a href="View_Document.aspx" style="color:black; text-decoration: none;">View All Documents</a></b></asp:Label>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
   <%-- <div class="search-box">
        <div class="input-group">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search documents..." AutoCompleteType="Disabled"></asp:TextBox>
            <div class="input-group-append">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
            </div>
        </div>
    </div>--%>

    <div class="row">
     <div class="col-sm-12 col-md-12">
         <div class="table-responsive">
             <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" DataKeyNames="FilePath">
                 <Columns>
                     <asp:BoundField DataField="FilePath" HeaderText="Document" ReadOnly="true" SortExpression="FilePath" />
                     <asp:TemplateField HeaderText="Details">
                         <ItemTemplate>
                             <div class="container-fluid">
                                 <div class="row">
                                     <div class="col-lg-10">
                                         <div class="row">
                                             <div class="col- 12">
                                                
                                                 Document Title-<asp:Label ID="lblDocumentTitle" runat="server" Text='<%#Eval("DocumentTitle") %>' Font-Bold="True" Font-Size="Large"></asp:Label>
                                                 &nbsp;| DocumentType-<asp:Label ID="lblDocumentType" runat="server" Text='<%#Eval("DocumentType") %>' Font-Bold="True" Font-Size="Large"></asp:Label>
                                             </div>
                                         </div>
                                         <div class="row">
                                             <div>
                                                 Description-<asp:Label ID="lblDescription" runat="server" Text='<%#Eval("Description") %>' Font-Bold="True"></asp:Label>
                                                 

                                             </div>
                                         </div>
                                         <div class="row">
                                             <div>
                                                 UploadDate-<asp:Label ID="lblUploadDate" runat="server" Text='<%#Eval("UploadDate") %>' Font-Bold="True" Font-Size="Medium"></asp:Label>
                                                 &nbsp;| Upload By-<asp:Label ID="lblUploadBy" runat="server" Text='<%#Eval("name") %>' Font-Size="Medium" Font-Bold="True"></asp:Label>

                                             </div>
                                         </div>
                                     </div>
                                     <div class="col-lg-2">
                                         <asp:LinkButton ID="lnkDownload" runat="server" CommandName="Download" 
                         CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-sm btn-primary">
                         <i class="fas fa-download"></i> Download
                     </asp:LinkButton>
                     <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteDocument" 
                         CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-sm btn-danger" 
                         OnClientClick="return confirmDelete();">
                         <i class="fas fa-trash-alt"></i> Delete
                     </asp:LinkButton>

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
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function confirmDelete() {
            return Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                return result.isConfirmed;
            });
        }
    </script>
</asp:Content>