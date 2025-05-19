<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Active_Complaints.aspx.cs" Inherits="Society_management.Active_Complaints" EnableEventValidation="false" %>
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
            var ComplainId = $(this).attr('data-Complain-Id');
            if (noticeId) {
                window.location.href = 'Complaint_Details.aspx?id=' + ComplainId;
            }
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
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
 <asp:GridView ID="gvDisplay" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="Complaint_id"
    CssClass="table table-striped table-bordered grid-view-custom"
    OnRowDataBound="gvDisplay_RowDataBound" 
    OnSelectedIndexChanged="gvDisplay_SelectedIndexChanged">
    <Columns>
    <asp:TemplateField HeaderText="User Name">
        <ItemTemplate>
            <asp:Label Text='<%# Eval("User_name") %>' runat="server" />
        </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Complaint type">
        <ItemTemplate>
            <asp:Label Text='<%# Eval("Complaint_type") %>' runat="server" />
        </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Priority">
        <ItemTemplate>
            <asp:Label Text='<%# Eval("Priority") %>' runat="server" />
        </ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Status">
        <ItemTemplate>
             <asp:Label Text='<%# Eval("Status") %>' runat="server" />
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
