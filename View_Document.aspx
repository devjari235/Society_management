<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Document.aspx.cs" Inherits="Society_management.View_Document" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server" />
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <a href="Documents.aspx" style="color:white; text-decoration: none;">
        <asp:Label ID="lblOwner" runat="server" CssClass="btn btn-primary">
            <b><i class="bi bi-file-earmark-plus-fill"></i> Add Document</b>
        </asp:Label>
    </a>
<%--    <a href="View_Document.aspx" style="color:white; text-decoration: none;">
        <asp:Label id="lblFlatView" runat="server" CssClass="btn btn-secondary">
            <b><i class="bi bi-eye-fill"></i> View All Document</b>
        </asp:Label>
    </a>--%>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <asp:GridView CssClass="table table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" DataKeyNames="FilePath"
                OnRowCommand="gvDisplay_RowCommand" OnPageIndexChanging="gvDisplay_PageIndexChanging1">
                <Columns>
                    <asp:TemplateField HeaderText="Documents">
                        <ItemTemplate>
                            <asp:Image CssClass="img-fluid" ID="Image1" ImageUrl='<%# Eval("FilePath") %>' runat="server" Style="max-height: 120px;" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="DocumentTitle">
                        <ItemTemplate>
                            <asp:Label Text='<%#Eval("DocumentTitle") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="DocumentType">
                        <ItemTemplate>
                            <asp:Label Text='<%#Eval("DocumentType") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Description">
                        <ItemTemplate>
                            <asp:Label Text='<%#Eval("Description") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="UploadDate">
                        <ItemTemplate>
                            <asp:Label Text='<%#Eval("UploadDate") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Upload By">
                        <ItemTemplate>
                            <asp:Label Text='<%#Eval("name") %>' runat="server"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDownload" runat="server" CommandName="Download" CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-primary btn-sm mb-2">
                                     <i class="fas fa-download"></i> Download
                            </asp:LinkButton>
                            <asp:LinkButton
                                ID="lnkDelete"
                                runat="server"
                                CommandName="DeleteDocument"
                                CommandArgument='<%# Eval("DocumentID") %>'
                                OnClientClick="return confirm('Are you sure you want to delete this document?');"
                                CssClass="btn btn-danger btn-sm">
                                     <i class="fas fa-trash-alt"></i> Delete
                            </asp:LinkButton>

                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('.table').prepend($('<thead></thead>').append($('.table').find('tr:first'))).dataTable();
        });
    </script>
</asp:Content>
