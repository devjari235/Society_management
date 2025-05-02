<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Documents.aspx.cs" Inherits="Society_management.Documents" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .document-upload-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        
        .upload-header {
            text-align: center;
            margin-bottom: 25px;
            color: #2c3e50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .document-list {
            margin-top: 30px;
        }
        
        .document-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            margin-bottom: 10px;
            background: #f9f9f9;
        }
        
        .document-item:hover {
            background: #f0f0f0;
        }
        
        .document-actions a {
            margin-left: 10px;
            color: #3498db;
        }
        
        .document-actions a.delete {
            color: #e74c3c;
        }
        
        .file-upload-wrapper {
            position: relative;
            margin-bottom: 20px;
        }
        
        .custom-file-upload {
            border: 2px dashed #3498db;
            border-radius: 5px;
            padding: 40px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .custom-file-upload:hover {
            background-color: #f8f9fa;
            border-color: #2980b9;
        }
        
        .custom-file-upload i {
            font-size: 48px;
            color: #3498db;
            margin-bottom: 10px;
        }
        
        .file-info {
            margin-top: 10px;
            font-size: 14px;
            color: #7f8c8d;
        }
        
        .btn-upload {
            background-color: #2ecc71;
            border-color: #2ecc71;
            width: 100%;
            padding: 10px;
            font-weight: bold;
        }
        
        .btn-upload:hover {
            background-color: #27ae60;
            border-color: #27ae60;
        }

   .validation-message{
    color: firebrick;
    font-size: 14px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 6px;
    margin-left: 5px;
    transition: all 0.3s ease-in-out;
}

    .validation-message::before {
        content: "⚠  ";
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        font-size: 14px;
    }
        .search-box {
            margin-bottom: 20px;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
        <asp:Label ID="lblDocument" runat="server" CssClass="btn btn-primary"><b><a href="Documents.aspx" style="color:black; text-decoration: none;">Add Document</a></b></asp:Label>
<asp:Label id="lblDocumentView" runat="server" CssClass="btn btn-secondary"><b><a href="View_Document.aspx" style="color:black; text-decoration: none;">View All Documents</a></b></asp:Label>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="document-upload-container">
        <div class="upload-header">
            <h3><i class="fas fa-cloud-upload-alt"></i> Upload Society Documents</h3>
            <p class="text-muted">Upload important society documents like notices, meeting minutes, financial reports, etc.</p>
        </div>
        
        <asp:Panel ID="pnlUpload" runat="server" DefaultButton="btnUpload">
            <div class="form-group">
                <label for="ddlDocumentType">Document Type</label>
                <asp:DropDownList ID="ddlDocumentType" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">-- Select Document Type --</asp:ListItem>
                    <asp:ListItem Value="Notice">Notice</asp:ListItem>
                    <asp:ListItem Value="Meeting Minutes">Meeting Minutes</asp:ListItem>
                    <asp:ListItem Value="Financial Report">Financial Report</asp:ListItem>
                    <asp:ListItem Value="Bye Laws">Bye Laws</asp:ListItem>
                    <asp:ListItem Value="Other">Other</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvDocumentType" runat="server" 
                    ControlToValidate="ddlDocumentType" InitialValue=""
                    ErrorMessage="Please select document type" 
                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label>Document Title</label>
                <asp:TextBox ID="txtDocumentTitle" runat="server" CssClass="form-control" placeholder="Enter document title"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDocumentTitle" runat="server" 
                    ControlToValidate="txtDocumentTitle"
                    ErrorMessage="Please enter document title" 
                    CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                    TextMode="MultiLine" Rows="3" placeholder="Enter document description (optional)"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Upload Document</label>
                <div class="file-upload-wrapper">
                    <label for="fileUpload" class="custom-file-upload">
                        <i class="fas fa-file-upload"></i>
                        <h5>Drag & Drop files here or click to browse</h5>
                        <p class="text-muted">Supported formats: PDF, DOC, DOCX, XLS, XLSX, JPG, PNG (Max 5MB)</p>
                    </label>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control-file d-none" />
                    <div class="file-info" id="fileInfo"></div>
                    <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" 
                        ControlToValidate="fileUpload"
                        ErrorMessage="Please select a file to upload" 
                        CssClass="validation-message" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="cvFileUpload" runat="server" 
                        ControlToValidate="fileUpload"
                        ErrorMessage="File size must be less than 5MB" 
                        CssClass="validation-message" Display="Dynamic"
                        OnServerValidate="ValidateFileUpload"></asp:CustomValidator>
                </div>
            </div>
            
            <div class="form-group">
                <asp:Button ID="btnUpload" runat="server" Text="Upload Document" 
                    CssClass="btn btn-upload" OnClick="btnUpload_Click" />
            </div>
        </asp:Panel>
        
        <%--<div class="document-list">
            <h5>Uploaded Documents</h5>
            <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="False" 
                CssClass="table table-striped table-bordered" EmptyDataText="No documents found."
                OnRowCommand="gvDocuments_RowCommand" DataKeyNames="DocumentID">
                <Columns>
                    <asp:BoundField DataField="DocumentTitle" HeaderText="Title" />
                    <asp:BoundField DataField="DocumentType" HeaderText="Type" />
                    <asp:BoundField DataField="UploadDate" HeaderText="Upload Date" DataFormatString="{0:dd-MMM-yyyy}" />
                    <asp:BoundField DataField="name" HeaderText="Uploaded By" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDownload" runat="server" CommandName="Download" 
                                CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-sm btn-primary">
                                <i class="fas fa-download"></i> Download
                            </asp:LinkButton>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteDocument" 
                                CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-sm btn-danger" 
                                OnClientClick="return confirm('Are you sure you want to delete this document?');">
                                <i class="fas fa-trash-alt"></i> Delete
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>--%>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            // File upload styling and display
            $('#<%= fileUpload.ClientID %>').change(function () {
                var fileName = $(this).val().split('\\').pop();
                var fileSize = this.files[0] ? (this.files[0].size / 1024 / 1024).toFixed(2) + ' MB' : '';
                
                if (fileName) {
                    $('#fileInfo').html('<strong>Selected file:</strong> ' + fileName + ' (' + fileSize + ')');
                } else {
                    $('#fileInfo').html('');
                }
            });

            // Drag and drop functionality
            $('.custom-file-upload').on('dragover', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).addClass('dragover');
            });

            $('.custom-file-upload').on('dragleave', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).removeClass('dragover');
            });

            $('.custom-file-upload').on('drop', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).removeClass('dragover');
                
                var files = e.originalEvent.dataTransfer.files;
                if (files.length > 0) {
                    $('#<%= fileUpload.ClientID %>')[0].files = files;
                    var fileName = files[0].name;
                    var fileSize = (files[0].size / 1024 / 1024).toFixed(2) + ' MB';
                    $('#fileInfo').html('<strong>Selected file:</strong> ' + fileName + ' (' + fileSize + ')');
                }
            });

            // Click event for custom file upload
            $('.custom-file-upload').click(function () {
                $('#<%= fileUpload.ClientID %>').click();
            });
        });
    </script>
</asp:Content>
