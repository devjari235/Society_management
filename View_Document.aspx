<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Document.aspx.cs" Inherits="Society_management.View_Document" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
        <script type="text/javascript">

            $(document).ready(function () {
                $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
            })

        </script>
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
        <asp:GridView CssClass="table table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" DataKeyNames="FilePath">
    <Columns>
        <asp:TemplateField HeaderText="Document Info">
            <ItemTemplate>
                <div class="row align-items-center">
                    <!-- Image Column -->
                    <div class="col-md-3">
                        <asp:Image CssClass="img-fluid" ID="Image1" ImageUrl='<%# Eval("FilePath") %>' runat="server" Style="max-height: 120px;" />
                    </div>

                    <!-- Details Column -->
                    <div class="col-md-6">
                        <div><strong>DocumentTitle:</strong> <asp:Label ID="lblDocumentTitle" runat="server" Text='<%#Eval("DocumentTitle") %>' /></div>
                        <div><strong>DocumentType:</strong> <asp:Label ID="lblDocumentType" runat="server" Text='<%#Eval("DocumentType") %>' /></div>
                        <div><strong>Description:</strong> <asp:Label ID="lblDescription" runat="server" Text='<%#Eval("Description") %>' /></div>
                        <div><strong>UploadDate:</strong> <asp:Label ID="lblUploadDate" runat="server" Text='<%#Eval("UploadDate") %>' /></div>
                        <div><strong>Upload By:</strong> <asp:Label ID="lblUpload_By" runat="server" Text='<%#Eval("name") %>' /></div>
                    </div>

                    <!-- Actions Column -->
                    <div class="col-md-3 d-flex flex-column justify-content-center align-items-start gap-2">
                        <asp:LinkButton ID="lnkDownload" runat="server" CommandName="Download" CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-primary btn-sm mb-2">
                            <i class="fas fa-download"></i> Download
                        </asp:LinkButton>
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteDocument" CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirmDelete();">
                            <i class="fas fa-trash-alt"></i> Delete
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

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