<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Document.aspx.cs" Inherits="Society_management.View_Document" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Required CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <!-- jQuery (required for Bootstrap dropdowns) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap JS Bundle with Popper (required for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Font Awesome (for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Required JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            // Initialize DataTable after ensuring proper structure
            var $table = $('#<%= gvDisplay.ClientID %>');

            // First, ensure we have proper thead/tbody structure
            if ($table.find('thead').length === 0) {
                var $headerRow = $table.find('tr:first');
                $table.prepend($('<thead></thead>').append($headerRow));
                $table.find('tbody').prepend($('<tr style="display:none"></tr>')); // Hidden row to maintain structure
            }

            // Now initialize DataTable
            if (!$.fn.DataTable.isDataTable($table)) {
                $table.DataTable({
                    "paging": true,
                    "lengthChange": true,
                    "searching": true,
                    "ordering": true,
                    "info": true,
                    "autoWidth": false,
                    "responsive": true,
                    "columnDefs": [
                        { "visible": false, "targets": [0] }, // Hide DocumentID column
                        { "orderable": false, "targets": [3] } // Make Action column non-orderable
                    ]
                });
            }

            // Row click handler (excluding action cells)
            $table.on('click', 'tbody tr', function (e) {
                // Check if click was on an action button
                if ($(e.target).closest('.btn').length === 0) {
                    var documentId = $(this).find('td:first').text();
                    if (documentId) {
                        window.location.href = 'Document_Details.aspx?id=' + documentId;
                    }
                }
            });
        });

        function ConfirmDelete(uniqueId) {
            Swal.fire({
                title: 'Are you sure?',
                text: "This document will be deleted permanently.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            }).then((result) => {
                if (result.isConfirmed) {
                    __doPostBack(uniqueId, '');
                }
            });
            return false;
        }
    </script>

    <style>
        #<%= gvDisplay.ClientID %> {
            width: 100% !important;
            border-collapse: separate;
            border-spacing: 0 8px;
        }
        
        #<%= gvDisplay.ClientID %> tbody tr {
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        #<%= gvDisplay.ClientID %> tbody tr:hover {
            background-color: #f8f9fa !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        #<%= gvDisplay.ClientID %> tbody td {
            padding: 12px 15px;
            border-top: none !important;
            border-bottom: none !important;
            vertical-align: middle;
        }
        
        #<%= gvDisplay.ClientID %> tbody td:first-child {
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }
        
        #<%= gvDisplay.ClientID %> tbody td:last-child {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }
        
        #<%= gvDisplay.ClientID %> thead th {
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
            padding: 12px 15px;
        }
        
        .action-buttons {
            white-space: nowrap;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server" />

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <a href="Documents.aspx" class="btn btn-primary">
        <i class="fas fa-file-upload"></i> Add Document
    </a>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <asp:GridView ID="gvDisplay" runat="server" AutoGenerateColumns="False"
                    CssClass="table table-striped"
                    DataKeyNames="DocumentID"
                    OnRowCommand="gvDisplay_RowCommand"
                    OnRowDataBound="gvDisplay_RowDataBound"
                    EmptyDataText="No documents found"
                    EmptyDataRowStyle-CssClass="text-center">
                    <Columns>
                        <asp:BoundField DataField="DocumentID" HeaderText="ID" />
                        <asp:BoundField DataField="DocumentTitle" HeaderText="Document Title" />
                        <asp:BoundField DataField="UploadDate" HeaderText="Upload Date" DataFormatString="{0:dd-MMM-yyyy}" />
                        <asp:BoundField DataField="name" HeaderText="Uploaded By" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="action-buttons">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDownload" runat="server" CommandName="Download"
                                    CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-primary btn-sm"
                                    ToolTip="Download document">
                                    <i class="fas fa-download"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteIncome"
                                    CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-danger btn-sm"
                                    OnClientClick='return ConfirmDelete(this.uniqueID);' ToolTip="Delete Document">
                                    <i class="fas fa-trash-alt"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</div>

</asp:Content>
