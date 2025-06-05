<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="ScheduledVisitors.aspx.cs" Inherits="Society_management.ScheduledVisitors" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
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
    });
</script>
    <style>
        .btn-action { min-width: 100px; margin: 2px; }
        .disabled-btn { opacity: 0.65; cursor: not-allowed; }
        .dashboard-btn { padding: 10px 20px; border-radius: 8px; font-weight: bold; color: #fff; border: none; }
        .btn-Dashboard { background: linear-gradient(135deg, #7f8c8d, #57606f); }
        .btn-create { background: linear-gradient(135deg, #8E2DE2, #4A00E0); }
    </style>
     <style>
     /* Page Title Buttons Container */
     .page-title-buttons {
         display: flex;
         justify-content: space-between;
         align-items: center;
         gap: 10px;
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
         background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
     }

     .btn-Expire {
         background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
     }

     /* Hover Effects */
     .dashboard-btn:hover {
         transform: translateY(-2px);
         box-shadow: 0 4px 10px rgba(0,0,0,0.2);
         color: #FFD700;
         text-decoration: none;
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
     .btn-Dashboard { background: linear-gradient(135deg, #7f8c8d, #57606f); }
.btn-create { background: linear-gradient(135deg, #8E2DE2, #4A00E0); }

 </style>
    <script>
        function showToast(message, type) {
            var toastEl = document.getElementById("customToast");
            var toastMessage = document.getElementById("toastMessage");
            toastMessage.innerText = message;

            toastEl.classList.remove("bg-success", "bg-danger", "bg-info");
            toastEl.classList.add("bg-" + type);

            var toast = bootstrap.Toast.getOrCreateInstance(toastEl);
            toast.show();
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server"></asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="d-flex justify-content-between align-items-center">
        <a href="VisitorApproval.aspx" class="dashboard-btn btn-Dashboard"><i class="fas fa-arrow-left"></i> Back to Details</a>
        <h2>Scheduled Visitors</h2>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <!-- ADD ScriptManager here -->
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <asp:GridView ID="gvScheduledVisitors" runat="server" AutoGenerateColumns="False"
        CssClass="table table-bordered"
        OnRowCommand="gvScheduledVisitors_RowCommand"
        OnRowDataBound="gvScheduledVisitors_RowDataBound"
        DataKeyNames="ScheduleID,IsCompleted">
        <Columns>
            <asp:BoundField DataField="VisitorName" HeaderText="Visitor Name" />
            <asp:BoundField DataField="ContactNumber" HeaderText="Contact" />
            <asp:BoundField DataField="ScheduledDateTime" HeaderText="Scheduled Time" DataFormatString="{0:g}" />
            <asp:BoundField DataField="Purpose" HeaderText="Purpose" />
            <asp:BoundField DataField="User_name" HeaderText="Meeting With" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnCheckIn" runat="server" Text="Check In" CommandName="CheckIn"
                        CommandArgument='<%# Eval("ScheduleID") %>' CssClass="btn btn-success btn-action" />
                    <asp:Button ID="btnCheckOut" runat="server" Text="Check Out" CommandName="CheckOut"
                        CommandArgument='<%# Eval("ScheduleID") %>' CssClass="btn btn-warning btn-action" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <!-- Toast -->
    <div aria-live="polite" aria-atomic="true" class="position-relative">
        <div class="toast-container position-fixed bottom-0 end-0 p-3">
            <div id="customToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" id="toastMessage"></div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
