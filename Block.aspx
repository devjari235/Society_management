<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Block.aspx.cs" Inherits="Society_management.Block" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Block Registration</title>

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Bootstrap CSS -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="datatable/css/dataTables.dataTables.min.css" rel="stylesheet" />
    <link href="fontawesome/css/all.css" rel="stylesheet" />
    <link href="css/Customstylesheet.css" rel="stylesheet" />

    <!-- Scripts -->
    <!-- jQuery (full, required for DataTables) -->
    <script src="bootstrap/js/jquery-3.5.1.min.js"></script>
    <script>window.jQuery || document.write('<script src="https://code.jquery.com/jquery-3.5.1.min.js"><\\/script>');</script>
    <script src="bootstrap/js/popper.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="datatable/js/dataTables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        .btn-custom {
            width: 100%;
        }

        .card {
            border-radius: 15px;
        }

        .card-body {
            padding: 30px;
        }

        label {
            font-weight: 600;
        }

        .form-control {
            border-radius: 8px;
        }

        /* Mobile (<=768px) tweaks */
        @media (max-width: 768px) {
            .container {
                margin-top: 16px !important;
                margin-bottom: 16px !important;
                padding-left: 12px;
                padding-right: 12px;
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
            select {
                font-size: 14px;
                padding: 10px 12px;
            }

            .btn-lg {
                font-size: 16px;
                padding: 10px 12px;
            }

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

            .dataTables_wrapper .dataTables_length,
            .dataTables_wrapper .dataTables_filter {
                float: none !important;
            }

            .dataTables_wrapper .dataTables_filter {
                text-align: left;
                margin-top: 10px;
            }

            .dataTables_wrapper .dataTables_paginate {
                margin-top: 10px;
            }
        }
    </style>

    <script>
        function initBlockDataTable() {
            try {
                if (!window.jQuery || !$.fn || !$.fn.DataTable) return;

                var $table = $('#gvBlock');
                if ($table.length === 0) return;

                // DataTables needs a consistent header/body column count
                var hasHeader = $table.find('thead th').length > 0;
                var hasRows = $table.find('tbody tr').length > 0;
                if (!hasHeader || !hasRows) return;

                if ($.fn.DataTable.isDataTable('#gvBlock')) {
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

        $(document).ready(initBlockDataTable);
        if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(initBlockDataTable);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container" style="margin-top: 5%; margin-bottom: 5%;">
            <div class="row">
                <div class="col-md-8 mx-auto">

                    <div class="card shadow">
                        <div class="card-body">

                            <!-- Icon -->
                            <div class="row mb-3">
                                <div class="col text-center">
                                    <h1>
                                        <i class="bi bi-buildings-fill text-primary"></i>
                                    </h1>
                                </div>
                            </div>

                            <!-- Heading -->
                            <div class="row mb-3">
                                <div class="col text-center">
                                    <h4>Block Registration</h4>
                                </div>
                            </div>

                            <hr />

                            <!-- Block Name -->
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label>Block Name</label>
                                    <asp:TextBox
                                        ID="txtBname"
                                        runat="server"
                                        CssClass="form-control"
                                        placeholder="Enter Block Name">
                                    </asp:TextBox>
                                </div>
                            </div>

                            <!-- Location -->
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label>Location</label>
                                    <asp:DropDownList
                                        ID="ddlLocation"
                                        runat="server"
                                        CssClass="form-control">
                                        <asp:ListItem Value="">-- Select Location --</asp:ListItem>
                                        <asp:ListItem Value="North">North</asp:ListItem>
                                        <asp:ListItem Value="South">South</asp:ListItem>
                                        <asp:ListItem Value="East">East</asp:ListItem>
                                        <asp:ListItem Value="West">West</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <!-- Society Name -->
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <label>Society Name</label>
                                    <asp:DropDownList
                                        ID="ddlSociety"
                                        runat="server"
                                        CssClass="form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="row">
                                <!-- Add Button -->
                                <div class="col-md-6 mb-2">
                                    <asp:Button
                                        ID="btnAdd"
                                        runat="server"
                                        Text="Add"
                                        CssClass="btn btn-success btn-lg btn-custom"
                                        OnClick="btnAdd_Click"
                                        UseSubmitBehavior="false" />
                                </div>

                                <!-- Update Button -->
                                <div class="col-md-6 mb-2">
                                    <asp:Button
                                        ID="btnUpdate"
                                        runat="server"
                                        Text="Update"
                                        CssClass="btn btn-primary btn-lg btn-custom"
                                        OnClick="btnUpdate_Click"
                                        UseSubmitBehavior="false"
                                        CausesValidation="false" />
                                </div>
                            </div>

                            <!-- Hidden Field -->
                            <asp:HiddenField ID="hfBlockId" runat="server" />

                        </div>
                    </div>

                    <br />
                    <a href="R_Society.aspx" class="btn btn-outline-secondary btn-sm">
                        &laquo;&laquo; Back To Registration
                    </a>
                    <br /><br />

                </div>
            </div>
        </div>

        <div class="container mb-5">
            <div class="row">
                <div class="col-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center flex-wrap">
                                <h5 class="mb-3 mb-md-0">Block List</h5>
                                <small class="text-muted">Select a row to edit & update</small>
                            </div>

                            <div class="table-responsive mt-3">
                                <asp:GridView
                                    ID="gvBlock"
                                    runat="server"
                                    CssClass="table table-striped table-bordered table-hover"
                                    ClientIDMode="Static"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="Block_id"
                                    UseAccessibleHeader="True"
                                    OnPreRender="gvBlock_PreRender"
                                    OnSelectedIndexChanged="gvBlock_SelectedIndexChanged">
                                    <Columns>
                                        <asp:CommandField ShowSelectButton="True" SelectText="Select" ControlStyle-CssClass="btn btn-sm btn-outline-primary" />
                                        <asp:BoundField DataField="Block_id" HeaderText="ID" ReadOnly="True" />
                                        <asp:BoundField DataField="Block_name" HeaderText="Block Name" />
                                        <asp:BoundField DataField="Location" HeaderText="Location" />
                                        <asp:BoundField DataField="Society_name" HeaderText="Society" />
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