<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MemberApproval.aspx.cs" Inherits="Society_management.MemberApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery (required for Bootstrap dropdowns) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Bootstrap JS Bundle with Popper (required for dropdowns) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Font Awesome (for icons) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        h2 {
            color: #2c3e50;
            padding-bottom: 10px;
            font-weight: 700;
        }

        /* Override GridView table styles to fit Bootstrap */
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        th {
            background-color: #e74c3c;
            color: white;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f1f3f5;
        }

        /* Style buttons using Bootstrap utilities */
        #btnApprove, #btnReject {
            padding: 6px 15px;
            font-weight: 600;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            min-width: 90px;
            margin-right: 5px;
        }

        #btnApprove {
            background-color: #2ecc71;
            color: white;
        }

            #btnApprove:hover {
                background-color: #27ae60;
            }

        #btnReject {
            background-color: #e74c3c;
            color: white;
        }

            #btnReject:hover {
                background-color: #c0392b;
            }

        /* Message label styles */
        #lblMessage {
            display: block;
            margin: 15px 0;
            padding: 12px 15px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 1rem;
            text-align: center;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

          /* Button Group Container */
  .action-button-group {
      display: flex;
      justify-content: flex-end;
      gap: 15px;
     
      width: 100%;
  }

  /* Base Button Styles */
  .btn-register-notice,
  .btn-view-notice {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 12px 24px;
      text-decoration: none;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      font-size: 16px;
      font-weight: 600;
      border-radius: 8px;
      transition: all 0.3s ease;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  /* Register Button */
  .btn-register-notice {
      background-color: #3498db;
      color: white;
  }

  .btn-register-notice:hover {
      background-color: #2980b9;
      transform: translateY(-3px);
      box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
      text-decoration:none;
      color: white;
  }

  /* View Button */
  .btn-view-notice {
      background-color: #2ecc71;
      color: white;
  }

  .btn-view-notice:hover {
      background-color: #27ae60;
      transform: translateY(-3px);
      text-decoration:none;
      box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
      color: white;
  }

  /* Icons */
  .btn-register-notice i,
  .btn-view-notice i {
      margin-right: 10px;
      font-size: 18px;
  }

  /* Active State */
  .btn-register-notice:active,
  .btn-view-notice:active {
      transform: scale(0.98);
  }

  /* Focus State */
  .btn-register-notice:focus,
  .btn-view-notice:focus {
      outline: none;
  }

  .btn-register-notice:focus {
      box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.5);
  }

  .btn-view-notice:focus {
      box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.5);
  }

  /* Responsive Design */
  @media (max-width: 768px) {
      .action-button-group {
          flex-direction: column;
          align-items: flex-end;
          gap: 10px;
      }
      
      .btn-register-notice,
      .btn-view-notice {
          width: 100%;
          max-width: 300px;
          padding: 15px 20px;
          font-size: 18px;
          text-align: center;
      }
  }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
    
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
   <div class="action-button-group">
    <a href="MemberSchedule.aspx" class="btn-register-notice">
        <i class="fas fa-plus-circle"></i> Scheduled Visitor
    </a>
    <a href="Visitor_List.aspx" class="btn-view-notice">
        <i class="fas fa-users"></i> Visitors
    </a>
</div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">

        <asp:GridView ID="gvPendingVisitors" runat="server" AutoGenerateColumns="False" CssClass="table"
            OnRowCommand="gvPendingVisitors_RowCommand">
            <Columns>

                <asp:BoundField DataField="Name" HeaderText="Visitor Name" ItemStyle-CssClass="align-middle" />
                <asp:BoundField DataField="ContactNumber" HeaderText="Contact Number" ItemStyle-CssClass="align-middle" />
                <asp:BoundField DataField="VisitPurpose" HeaderText="Purpose" ItemStyle-CssClass="align-middle" />
                <asp:BoundField DataField="VisitDateTime" HeaderText="Visit Time" DataFormatString="{0:g}" ItemStyle-CssClass="align-middle" />
                <asp:BoundField DataField="MemberName" HeaderText="Meeting With" ItemStyle-CssClass="align-middle" />
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnApprove" runat="server" Text="Approve" CommandName="Approve"
                            CommandArgument='<%# Eval("VisitorID") %>' CssClass="btn btn-success btn-sm" />
                        <asp:Button ID="btnReject" runat="server" Text="Reject" CommandName="Reject"
                            CommandArgument='<%# Eval("VisitorID") %>' CssClass="btn btn-danger btn-sm" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Panel CssClass="alert alert-success" role="alert" ID="Panel1" runat="server" Visible="false">
            <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
        </asp:Panel>
        <!-- Custom Toast -->
        <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="customToast" class="toast align-items-center text-white bg-success border-0" role="alert">
                <div class="d-flex">
                    <div class="toast-body" id="toastMessage">
                        Success!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
    function showToast(message, isSuccess) {
        const toastEl = document.getElementById('customToast');
        const toastBody = document.getElementById('toastMessage');

        toastBody.textContent = message;

        if (isSuccess) {
            toastEl.classList.remove('bg-danger');
            toastEl.classList.add('bg-success');
        } else {
            toastEl.classList.remove('bg-success');
            toastEl.classList.add('bg-danger');
        }

        const toast = new bootstrap.Toast(toastEl);
        toast.show();
    }
    </script>

</asp:Content>
