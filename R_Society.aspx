<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="R_Society.aspx.cs" Inherits="Society_management.R_Society" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Society Registration</title>

    <!-- Bootstrap CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" />

    <!-- DataTables CSS -->
    <link href="datatable/css/dataTables.dataTables.min.css" rel="stylesheet" />

    <!-- Font Awesome -->
    <link href="fontawesome/css/all.css" rel="stylesheet" />

    <!-- Custom CSS -->
    <link href="css/Customstylesheet.css" rel="stylesheet" />

    <!-- jQuery (full, required for DataTables) -->
    <script src="bootstrap/js/jquery-3.5.1.min.js"></script>
    <script>window.jQuery || document.write('<script src="https://code.jquery.com/jquery-3.5.1.min.js"><\\/script>');</script>

    <!-- Popper JS -->
    <script src="bootstrap/js/popper.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="bootstrap/js/bootstrap.min.js"></script>

    <!-- DataTables JS -->
    <script src="datatable/js/dataTables.min.js"></script>

    <style>
        .asp-validation {
            color: firebrick;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 6px;
            margin-left: 5px;
        }

        .asp-validation::before {
            content: "⚠";
            font-size: 14px;
        }

        .btn-space {
            margin-top: 10px;
        }

        .form-control,
        .custom-select,
        select {
            width: 100%;
        }

        /* Mobile (<=768px) tweaks */
        @media (max-width: 768px) {
            html, body {
                max-width: 100%;
                overflow-x: hidden;
            }

            .container {
                margin-top: 16px !important;
                margin-bottom: 16px !important;
                padding-left: 12px;
                padding-right: 12px;
            }

            /* Prevent Bootstrap row gutters from creating horizontal overflow */
            .container .row {
                margin-left: 0;
                margin-right: 0;
            }

            .container .row > [class*='col-'] {
                padding-left: 0;
                padding-right: 0;
            }

            .card-body {
                padding: 14px;
            }

            h4 {
                font-size: 18px;
            }

            label {
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 6px;
            }

            .form-control,
            .custom-select,
            select {
                font-size: 14px;
                padding: 10px 12px;
                max-width: 100%;
                box-sizing: border-box;
            }

            input[type="file"] {
                width: 100%;
                max-width: 100%;
            }

            textarea.form-control {
                min-height: 90px;
            }

            /* Buttons: full width stacked */
            .row.justify-content-center > [class*='col-'] {
                margin-bottom: 10px;
            }

            .btn-lg {
                font-size: 16px;
                padding: 10px 12px;
            }

            /* Grid/table readability */
            .table-responsive {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                border-radius: 10px;
            }

            table.dataTable,
            .table {
                font-size: 13px;
            }

            .dataTables_wrapper .dataTables_filter input,
            .dataTables_wrapper .dataTables_length select {
                font-size: 14px;
                padding: 6px 10px;
            }

            .dataTables_wrapper .dataTables_filter {
                text-align: left;
                margin-top: 10px;
            }

            .dataTables_wrapper .dataTables_length,
            .dataTables_wrapper .dataTables_filter {
                float: none !important;
            }

            .dataTables_wrapper .dataTables_paginate {
                margin-top: 10px;
            }

            /* Logo preview */
            #imgLogoPreview {
                max-height: 70px !important;
            }
        }
    </style>

    <script>
        function initSocietyDataTable() {
            try {
                if (!window.jQuery || !$.fn || !$.fn.DataTable) return;

                var $table = $('#gvSociety');
                if ($table.length === 0) return;

                // DataTables needs a consistent header/body column count
                var hasHeader = $table.find('thead th').length > 0;
                var hasRows = $table.find('tbody tr').length > 0;
                if (!hasHeader || !hasRows) return;

                if ($.fn.DataTable.isDataTable('#gvSociety')) {
                    $table.DataTable().destroy();
                }

                $table.DataTable({
                    pageLength: 10,
                    lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    ordering: true,
                    searching: true,
                    responsive: false
                });
            } catch (e) { }
        }

        $(document).ready(initSocietyDataTable);
        // In case of partial postback
        if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(initSocietyDataTable);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <!-- Hidden Field for Update -->
        <asp:HiddenField ID="hfSocietyId" runat="server" />

        <div class="container" style="margin-top: 5%; margin-bottom: 5%;">
            <div class="row">
                <div class="col-md-8 mx-auto">
                    <div class="card shadow">
                        <div class="card-body">

                            <!-- Logo -->
                            <div class="row">
                                <div class="col text-center">
                                    <img src="Images/Logo.png" width="100" />
                                </div>
                            </div>

                            <!-- Heading -->
                            <div class="row">
                                <div class="col text-center">
                                    <h4>Society Registration</h4>
                                </div>
                            </div>

                            <hr />

                            <!-- Row 1 -->
                            <div class="row">
                                <div class="col-md-4">
                                    <label>Admin Name</label>
                                    <asp:DropDownList ID="ddlAdmin" runat="server" CssClass="form-control"></asp:DropDownList>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator1"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="ddlAdmin"
                                        InitialValue="-- Select Admin Name --"
                                        ErrorMessage="Select Admin Name"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>

                                <div class="col-md-4">
                                    <label>Society Name</label>
                                    <asp:TextBox ID="txtSname" runat="server" CssClass="form-control" placeholder="Society Name"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator2"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtSname"
                                        ErrorMessage="Enter Society Name"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>

                                <div class="col-md-4">
                                    <label>Incorporation Date</label>
                                    <asp:TextBox ID="txtINCdate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator3"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtINCdate"
                                        ErrorMessage="Select Date"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>
                            </div>

                            <br />

                            <!-- Row 2 -->
                            <div class="row">
                                <div class="col-md-6">
                                    <label>Registration Number</label>
                                    <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control" placeholder="Registration Number"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator4"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtNumber"
                                        ErrorMessage="Enter Registration Number"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>

                                <div class="col-md-6">
                                    <label>Slogan</label>
                                    <asp:TextBox ID="txtSlogan" runat="server" CssClass="form-control" placeholder="Slogan"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator5"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtSlogan"
                                        ErrorMessage="Enter Slogan"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>
                            </div>

                            <br />

                            <!-- Row 3 -->
                            <div class="row">
                                <div class="col-md-4">
                                    <label>Registration Date</label>
                                    <asp:TextBox ID="txtRDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator6"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtRDate"
                                        ErrorMessage="Select Date"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>

                                <div class="col-md-4">
                                    <label>Entry Date</label>
                                    <asp:TextBox ID="txtEntryDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator7"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtEntryDate"
                                        ErrorMessage="Select Date"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>

                                <div class="col-md-4">
                                    <label>Logo</label>
                                    <asp:FileUpload ID="FuLogo" runat="server" CssClass="form-control" />
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator8"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="FuLogo"
                                        ErrorMessage="Attach Logo"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                    <div class="mt-2">
                                        <asp:Image ID="imgLogoPreview" runat="server" CssClass="img-fluid rounded border" Style="max-height: 90px;" Visible="false" />
                                    </div>
                                </div>
                            </div>

                            <br />

                            <!-- Row 4 -->
                            <div class="row">
                                <div class="col-md-6">
                                    <label>Full Address</label>
                                    <asp:TextBox ID="txtAdd" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Full Address"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator9"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtAdd"
                                        ErrorMessage="Enter Address"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>

                                <div class="col-md-6">
                                    <label>Builder Details</label>
                                    <asp:TextBox ID="txtBuilderDetails" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Builder Details"></asp:TextBox>
                                    <asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator10"
                                        runat="server"
                                        CssClass="asp-validation"
                                        ControlToValidate="txtBuilderDetails"
                                        ErrorMessage="Enter Builder Details"
                                        Display="Dynamic"
                                        SetFocusOnError="True" />
                                </div>
                            </div>

                            <br />

                            <!-- Buttons -->
                            <div class="row justify-content-center">
                                <div class="col-md-3">
                                    <asp:Button
                                        ID="btnAdd"
                                        runat="server"
                                        Text="Add"
                                        CssClass="btn btn-success btn-block btn-lg"
                                        OnClick="btnAdd_Click" />
                                </div>

                                <div class="col-md-3">
                                    <asp:Button
                                        ID="btnUpdate"
                                        runat="server"
                                        Text="Update"
                                        CssClass="btn btn-primary btn-block btn-lg"
                                        OnClick="btnUpdate_Click" />
                                </div>

                                <div class="col-md-3">
                                    <asp:Button
                                        ID="btnGoBlock"
                                        runat="server"
                                        Text="Go to Block"
                                        CssClass="btn btn-secondary btn-block btn-lg"
                                        OnClick="btnGoBlock_Click"
                                        CausesValidation="False" />
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center flex-wrap">
                                <h5 class="mb-3 mb-md-0">Society List</h5>
                                <small class="text-muted">Select a row to edit & update</small>
                            </div>

                            <div class="table-responsive mt-3">
                                <asp:GridView
                                    ID="gvSociety"
                                    runat="server"
                                    CssClass="table table-striped table-bordered table-hover"
                                    ClientIDMode="Static"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="Society_id,admin_id"
                                    UseAccessibleHeader="True"
                                    OnPreRender="gvSociety_PreRender"
                                    OnSelectedIndexChanged="gvSociety_SelectedIndexChanged">
                                    <Columns>
                                        <asp:CommandField ShowSelectButton="True" SelectText="Select" ControlStyle-CssClass="btn btn-sm btn-outline-primary" />
                                        <asp:BoundField DataField="Society_id" HeaderText="ID" ReadOnly="True" />
                                        <asp:BoundField DataField="Society_name" HeaderText="Society Name" />
                                        <asp:BoundField DataField="AdminName" HeaderText="Admin" />
                                        <asp:BoundField DataField="IncorporationDate" HeaderText="Incorporation" />
                                        <asp:BoundField DataField="RegistrationNumber" HeaderText="Reg No." />
                                        <asp:BoundField DataField="Slogan" HeaderText="Slogan" />
                                        <asp:BoundField DataField="RegistrationDate" HeaderText="Reg Date" />
                                        <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" />
                                        <asp:BoundField DataField="Address" HeaderText="Address" />
                                        <asp:BoundField DataField="BuilderDetails" HeaderText="Builder Details" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>