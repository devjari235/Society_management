<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" 
    CodeBehind="View_Allnotice.aspx.cs" Inherits="Society_management.View_Allnotice" 
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    
    <script type="text/javascript">
        $(document).ready(function () {
            var table = $('.table').DataTable({
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

            // Row click handler using data attribute on <tr>
            $('.table tbody').on('click', 'tr.clickable-row', function () {
                var noticeId = $(this).attr('data-notice-id');
                if (noticeId) {
                    window.location.href = 'Admin_noticeDetails.aspx?id=' + noticeId;
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

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="table-responsive">
                    <asp:GridView ID="gvDisplay" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="Notice_id"
    CssClass="table table-striped table-bordered grid-view-custom"
    OnRowDataBound="gvDisplay_RowDataBound" 
    OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged">
    <Columns>
        <asp:TemplateField HeaderText="Title">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Title") %>' runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Posted Date">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Posted_date", "{0:dd MMM yyyy}") %>' runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Expiry Date">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Expiry_date", "{0:dd MMM yyyy}") %>' runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Importance">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Importance") %>' runat="server"
                    CssClass='<%# GetImportanceClass(Eval("Importance").ToString()) %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Status">
            <ItemTemplate>
                <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                    <%# Eval("Status") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
