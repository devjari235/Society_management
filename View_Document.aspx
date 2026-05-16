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
        .floating-icon {
        display: inline-block;
        animation: float-up-down 3s ease-in-out infinite;
        font-size: 3.5rem;
        color: #cbd5e1;
        margin-bottom: 15px;
    }
    @keyframes float-up-down {
        0% { transform: translateY(0px); }
        50% { transform: translateY(-15px); }
        100% { transform: translateY(0px); }
    }

    /* --- EMPTY STATE --- */
    .empty-state-container {
        padding: 60px 20px;
        margin-top: 20px;
        background: #ffffff;
        border-radius: 12px;
        text-align: center;
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
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state-container shadow-sm border rounded bg-white">
                <div class="empty-state-icon text-center">
                    <i class="fas fa-file-invoice floating-icon"></i>
                </div>
                <h4 style="color: #495057; font-weight: 700; margin-bottom: 8px;">No Documents Found</h4>
                <p style="color: #adb5bd; font-size: 0.95rem; max-width: 380px; margin-bottom: 24px; margin-left: auto; margin-right: auto;">
                    You haven't uploaded any documents yet. Keep your society records organized by adding them here.
                </p>
                <div class="text-center">
                    <a href="Documents.aspx" class="btn btn-primary">
                        <i class="fas fa-file-upload"></i> Add Document
                    </a>
                </div>
            </div>
        </asp:Panel>

        <asp:PlaceHolder ID="phDataContent" runat="server">
            <div class="card shadow-sm border-0 mb-4 mt-3">
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <asp:GridView ID="gvDisplay" runat="server" AutoGenerateColumns="False"
                            CssClass="table table-hover grid-view-custom w-100"
                            DataKeyNames="DocumentID"
                            OnRowCommand="gvDisplay_RowCommand"
                            OnRowDataBound="gvDisplay_RowDataBound"
                            GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="DocumentID" HeaderText="ID" />
                                <asp:TemplateField HeaderText="Document Title">
                                    <ItemTemplate><b><%# Eval("DocumentTitle") %></b></ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="UploadDate" HeaderText="Upload Date" />
                                <asp:BoundField DataField="name" HeaderText="Uploaded By" />
                                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="action-buttons text-center">
                                    <ItemTemplate>
                                        <div class="d-flex gap-2 justify-content-center">
                                            <asp:LinkButton ID="lnkDownload" runat="server" CommandName="Download"
                                                CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-primary btn-sm">
                                                <i class="fas fa-download"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteDocument"
                                                CommandArgument='<%# Eval("DocumentID") %>' CssClass="btn btn-danger btn-sm"
                                                OnClientClick='return ConfirmDelete(this.uniqueID);'>
                                                <i class="fas fa-trash-alt"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:Content>
