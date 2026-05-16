<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="CreateNotice.aspx.cs" Inherits="Society_management.CreateNotice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <!-- jQuery (required for Bootstrap 5 dropdown toggle) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap Bundle (includes Popper.js for dropdowns) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
             background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
        }

        /* Hover Effects */
        .dashboard-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            text-decoration:none;
            color:white;
        }

        /* Responsive Adjustments */
       @media (max-width: 768px) {

    /* Fix CheckBoxList table layout on mobile */
    .custom-checkbox-list table,
    .custom-checkbox-list tbody,
    .custom-checkbox-list tr,
    .custom-checkbox-list td {
        display: inline-flex !important;
        width: auto !important;
        padding: 0 !important;
        border: none !important;
        vertical-align: middle !important;
    }

    .custom-checkbox-list tr {
        flex-wrap: wrap !important;
        gap: 10px !important;
    }

    .custom-checkbox-list td {
        align-items: center !important;
        gap: 5px !important;
        white-space: nowrap !important;
    }

    .custom-checkbox-list input[type="checkbox"] {
        width: 16px !important;
        height: 16px !important;
        margin: 0 4px 0 0 !important;
        flex-shrink: 0 !important;
    }

    .custom-checkbox-list label {
        margin: 0 !important;
        font-size: 14px !important;
        line-height: 1.4 !important;
        white-space: nowrap !important;
    }

    /* Keep both checkbox lists consistent */
    #cblBroadcast table,
    #cblemail table {
        width: 100% !important;
    }

    #cblBroadcast tr,
    #cblemail tr {
        display: flex !important;
        flex-wrap: wrap !important;
        gap: 12px !important;
        width: 100% !important;
    }

    #cblBroadcast td,
    #cblemail td {
        display: inline-flex !important;
        align-items: center !important;
        gap: 5px !important;
        width: auto !important;
    }
}

        /* Body and Form Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .form-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 800px;
            margin: auto;
        }
        .header-title {
            font-weight: 600;
            color: #333;
        }
        .form-label {
            font-weight: 500;
            color: #555;
        }
        .btn-primary {
            background-color: #4e73df;
            border: none;
        }
        .btn-primary:hover {
            background-color: #2e59d9;
        }
        .custom-checkbox-list {
            font-family: Arial, sans-serif;
            font-size: 14px;
            color: #333;
        }

        .custom-checkbox-list input[type="checkbox"] {
            margin-right: 5px;
        }

        .custom-checkbox-list label {
            margin-right: 15px;
            cursor: pointer;
        }

        .custom-checkbox-list label:hover {
            color: #0066cc;
        }

        .custom-checkbox-list input[type="checkbox"]:checked + label {
            font-weight: bold;
            color: #0066cc;
        }

        .custom-checkbox-list .item {
            padding: 3px 0;
        }
        .validation-error {
          color: #dc3545;
          font-size: 0.85rem;
          margin-top: 3px;
          display: block;
          font-weight: 500;
          transition: all 0.3s ease;
        }
        .validation-error::before{
         content: "⚠ ";
         font-size: 0.85rem;
         margin-right: 4px;
        }
        .is-invalid {
            border-color: #dc3545 !important;
        }

        /* Loader Styles */
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            display: none;
        }

        .loader {
            border: 5px solid #f3f3f3;
            border-top: 5px solid #3498db;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loader-content {
            background: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .loader-message {
            margin-top: 15px;
            font-weight: bold;
            color: #333;
        }
    </style>
    <script type="text/javascript">
        function validateBroadcastGroups(sender, args) {
            var checkBoxList = document.getElementById('<%= cblBroadcast.ClientID %>');
            var checkboxes = checkBoxList.getElementsByTagName('input');
            var isValid = false;

            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    isValid = true;
                    break;
                }
            }

            args.IsValid = isValid;
        }

        function validateSendVia(sender, args) {
            var checkBoxList = document.getElementById('<%= cblemail.ClientID %>');
            var checkboxes = checkBoxList.getElementsByTagName('input');
            var isValid = false;
            
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    isValid = true;
                    break;
                }
            }
            
            args.IsValid = isValid;
        }
        
        function showLoader(message) {
            var loader = document.getElementById('loaderOverlay');
            var loaderMessage = document.getElementById('loaderMessage');
            if (loader && loaderMessage) {
                loaderMessage.textContent = message || 'Processing...';
                loader.style.display = 'flex';
            }
        }

        function hideLoader() {
            var loader = document.getElementById('loaderOverlay');
            if (loader) {
                loader.style.display = 'none';
            }
        }

        // Update your existing pageLoad function
        function pageLoad() {
            var btnPost = document.getElementById('<%= btnPost.ClientID %>');
            if (btnPost) {
                btnPost.onclick = function () {
                    Page_ClientValidate();
                    if (!Page_IsValid) {
                        // Add 'is-invalid' class to invalid controls
                        var validators = document.querySelectorAll('.validation-error');
                        validators.forEach(function (validator) {
                            var control = document.getElementById(validator.controltovalidate);
                            if (control && !control.classList.contains('is-invalid')) {
                                control.classList.add('is-invalid');
                            }
                        });
                        return false;
                    }

                    // Show loader when form is valid
                    showLoader('Posting notice and sending emails...');
                    return true;
                };
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="page-title-buttons">
        <div class="button-group-left">
            <a href="NoticeDashboard.aspx" class="dashboard-btn btn-Dashboard">
                <i class="fas fa-arrow-left"></i>Notice Dashboard
            </a>        
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="form-card">
            <h2 class="mb-4 text-center header-title"><i class="fas fa-bullhorn"></i> Post a New Notice</h2>

            <div class="mb-3">
                <label class="form-label">Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter notice title" AutoCompleteType="Disabled" />
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                ErrorMessage="Title is required" CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Enter notice description" />
                <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription"
                ErrorMessage="Description is required" CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            <div class="mb-3">
                <label class="form-label">Broad cast group</label>
                <asp:CheckBoxList ID="cblBroadcast" runat="server" RepeatDirection="Horizontal" CssClass="custom-checkbox-list">
                    <asp:ListItem>Committee Member</asp:ListItem>
                    <asp:ListItem>Owners</asp:ListItem>
                    <asp:ListItem>All Members</asp:ListItem>
                </asp:CheckBoxList>
                <asp:CustomValidator ID="cvBroadcast" runat="server" 
                ErrorMessage="Please select at least one broadcast group" 
                CssClass="validation-error" Display="Dynamic"
                ClientValidationFunction="validateBroadcastGroups"></asp:CustomValidator>
            </div>
            <div class="mb-3">
                <label class="form-label">Send Via</label>
                <asp:CheckBoxList ID="cblemail" runat="server" RepeatDirection="Horizontal" CssClass="custom-checkbox-list">
                    <asp:ListItem>Email</asp:ListItem>
                    <asp:ListItem>On App</asp:ListItem>
                </asp:CheckBoxList>
                <asp:CustomValidator ID="cvSendVia" runat="server" 
                ErrorMessage="Please select at least one delivery method" 
                CssClass="validation-error" Display="Dynamic"
                ClientValidationFunction="validateSendVia"></asp:CustomValidator>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Notice Type</label>
                    <asp:DropDownList ID="ddlNoticeType" runat="server" CssClass="form-select">
                        <asp:ListItem Text="General" Value="General" />
                        <asp:ListItem Text="Emergency" Value="Emergency" />
                        <asp:ListItem Text="Event" Value="Event" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvNoticeType" runat="server" ControlToValidate="ddlNoticeType"
                    InitialValue="" ErrorMessage="Notice type is required" CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Importance</label>
                    <asp:DropDownList ID="ddlImportance" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Normal" Value="Normal" />
                        <asp:ListItem Text="Important" Value="Important" />
                        <asp:ListItem Text="Urgent" Value="Urgent" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvImportance" runat="server" ControlToValidate="ddlImportance"
                    InitialValue="" ErrorMessage="Importance level is required" CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Expiry Date</label>
                <asp:TextBox ID="txtExpiry" runat="server" TextMode="Date" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvExpiry" runat="server" ControlToValidate="txtExpiry"
                ErrorMessage="Expiry date is required" CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="mb-3">
                <label class="form-label">Upload File (Optional)</label>
                <asp:FileUpload ID="fuNoticeFile" runat="server" CssClass="form-control" />
            </div>

            <div class="d-grid">
                <asp:Button ID="btnPost" runat="server" Text="Post Notice" CssClass="btn btn-primary btn-lg" OnClick="btnPost_Click"/>
            </div>
        </div>
    </div>

    <!-- Loader Overlay -->
    <div class="loader-overlay" id="loaderOverlay">
        <div class="loader-content">
            <div class="loader"></div>
            <div class="loader-message" id="loaderMessage">Posting notice and sending emails...</div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>