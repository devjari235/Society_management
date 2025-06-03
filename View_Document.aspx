<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Document.aspx.cs" Inherits="Society_management.View_Document" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
                <!-- Bootstrap & Swiper CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap 5 dropdown toggle) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap Bundle (includes Popper.js for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Add DataTables CSS & JS in your HeadContent -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <!-- Bootstrap JS Bundle with Popper (required for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var $table = $('.table');

        // Ensure thead exists
        if ($table.find('thead').length === 0) {
            var $thead = $('<thead></thead>').append($table.find('tr:first'));
            $table.prepend($thead);
        }

        // Initialize only if not already done
        if (!$.fn.DataTable.isDataTable($table)) {
            $table.DataTable({
                "paging": true,
                "lengthChange": true,
                "searching": true,
                "ordering": true,
                "info": true,
                "autoWidth": false,
                "responsive": true,
                "serverSide": false,
                "processing": false
            });
        }

        // Row click handler
        $table.find('tbody').on('click', 'tr.clickable-row', function () {
            var OwnerId = $(this).attr('data-Owner-id');
            if (noticeId) {
                window.location.href = 'Document_Details.aspx?id=' + OwnerId;
            }
        });
    });
</script>
        <style>
/* GridView Button-Row Style */
.grid-view-custom {
    border-collapse: separate;
    border-spacing: 0 8px; /* Adds spacing between rows */
}

.grid-view-custom tbody tr {
    background-color: #ffffff;
    border: 1px solid #dee2e6;
    border-radius: 8px; /* Rounded corners */
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

/* Button-like hover effect */
.grid-view-custom tbody tr:hover {
    background-color: #f8f9fa !important;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    cursor: pointer;
}

/* Active/Selected row */
.grid-view-custom tbody tr:active,
.grid-view-custom tbody tr.highlight {
    background-color: #e9ecef !important;
    transform: translateY(0);
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

/* Cell styling for button effect */
.grid-view-custom tbody td {
    padding: 12px 15px;
    border-top: none !important;
    border-bottom: none !important;
}

/* First and last cell rounded corners */
.grid-view-custom tbody td:first-child {
    border-top-left-radius: 8px;
    border-bottom-left-radius: 8px;
    border-left: none;
}

.grid-view-custom tbody td:last-child {
    border-top-right-radius: 8px;
    border-bottom-right-radius: 8px;
    border-right: none;
}

/* Status Badge with Black Background */
.status-badge {
    border-radius: 50px;
    text-transform: uppercase;
}

/* Header Styling */
.grid-view-custom thead th {
    background-color: transparent;
    color: #495057;
    font-weight: 600;
    border-bottom: 2px solid #dee2e6;
    padding: 12px 15px;
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server" />
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <a href="Documents.aspx" style="color:white; text-decoration: none;">
        <asp:Label ID="lblOwner" runat="server" CssClass="btn btn-primary">
            <b><i class="bi bi-file-earmark-plus-fill"></i> Add Document</b>
        </asp:Label>
    </a>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <asp:GridView CssClass="table table-striped table-bordered grid-view-custom" ID="gvDisplay" runat="server" AutoGenerateColumns="False" DataKeyNames="DocumentID"
                OnRowCommand="gvDisplay_RowCommand" OnPageIndexChanging="gvDisplay_PageIndexChanging1" OnRowDataBound="gvDisplay_RowDataBound" OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged">
                <Columns>
                    <asp:TemplateField HeaderText="DocumentTitle">
                        <ItemTemplate>
                            <asp:Label Text='<%#Eval("DocumentTitle") %>' runat="server"></asp:Label>
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
