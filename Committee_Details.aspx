<%@ Page Title="Committee Member Details" Language="C#" MasterPageFile="~/Adashboard.Master"
    AutoEventWireup="true" CodeBehind="Committee_Details.aspx.cs"
    Inherits="Society_management.Committee_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Font Awesome -->
    <link href="fontawesome/css/all.css" rel="stylesheet" />

    <style>
        /* Hide breadcrumb */
        .breadcrumb {
            display: none !important;
        }

        /* =====================================================
           PAGE TITLE BUTTON
        ===================================================== */
        .page-title-buttons {
            display: flex;
            justify-content: flex-start; /* Changed from flex-end to flex-start */
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .dashboard-btn {
            padding: 10px 24px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            text-decoration: none !important;
            color: #ffffff !important;
            box-shadow: 0 4px 6px rgba(0,0,0,0.10);
            border: none;
        }

        .dashboard-btn i {
            margin-right: 8px;
            font-size: 1rem;
        }

        .btn-back {
            background: #5a5c69 !important;
        }

        .dashboard-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 14px rgba(0,0,0,0.15);
            color: #ffffff !important;
        }

        /* =====================================================
           MAIN CARD
        ===================================================== */
        .card-committee {
            max-width: 1000px;
            margin: 0 auto 30px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            padding: 30px;
        }

        .card-title {
            color: #4e73df;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }

        /* =====================================================
           PROFILE IMAGE
        ===================================================== */
        .profile-img {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #e9ecef;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }

        /* =====================================================
           DETAILS TABLE
        ===================================================== */
        .details-table {
            width: 100%;
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }

        .details-table th,
        .details-table td {
            padding: 14px 18px;
            border: 1px solid #e3e6f0;
            vertical-align: middle;
        }

        /* Label column */
        .details-table th {
            width: 28%;
            min-width: 180px;
            background: #f8f9fc;
            color: #495057;
            font-weight: 600;
            white-space: normal;
            word-break: break-word;
        }

        /* Value column */
        .details-table td {
            width: 72%;
            background: #ffffff;
            color: #212529;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
        }

        /* Rounded corners */
        .details-table tr:first-child th {
            border-top-left-radius: 10px;
        }

        .details-table tr:first-child td {
            border-top-right-radius: 10px;
        }

        .details-table tr:last-child th {
            border-bottom-left-radius: 10px;
        }

        .details-table tr:last-child td {
            border-bottom-right-radius: 10px;
        }

        /* Better label display for long content */
        .details-table td span,
        .details-table td label {
            display: block;
            width: 100%;
            white-space: normal;
            word-break: break-word;
            overflow-wrap: anywhere;
        }
@media (max-width: 768px) {

    .page-title-buttons {
        justify-content: stretch;
    }

    .dashboard-btn {
        width: 100%;
        justify-content: center;
    }

    .card-committee {
        padding: 15px 10px;
        border-radius: 12px;
        margin: 0;
    }

    .card-title {
        font-size: 1.4rem;
        margin-bottom: 20px;
    }

    .profile-img {
        width: 120px;
        height: 120px;
    }

    /* Remove horizontal scroll on wrapper */
    .table-responsive {
        overflow-x: hidden !important;
    }

    /* Stack table into single column cards */
    .details-table,
    .details-table tbody,
    .details-table tr,
    .details-table th,
    .details-table td {
        display: block !important;
        width: 100% !important;
        box-sizing: border-box !important;
    }

    /* Each row becomes a card */
    .details-table tbody tr {
        margin-bottom: 12px !important;
        border: 1px solid #e3e6f0 !important;
        border-radius: 10px !important;
        overflow: hidden !important;
    }

    /* TH = label row */
    .details-table th {
        background: #f8f9fc !important;
        border: none !important;
        border-bottom: 1px solid #e3e6f0 !important;
        padding: 9px 14px !important;
        font-size: 12px !important;
        font-weight: 600 !important;
        color: #495057 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.4px !important;
        min-width: unset !important;
        width: 100% !important;
        white-space: normal !important;
    }

    /* TD = value row */
    .details-table td {
        background: #ffffff !important;
        border: none !important;
        padding: 10px 14px !important;
        font-size: 14px !important;
        color: #212529 !important;
        white-space: normal !important;
        word-break: break-word !important;
        overflow-wrap: anywhere !important;
        overflow: visible !important;
        width: 100% !important;
    }

    /* ASP Label spans inside td */
    .details-table td span,
    .details-table td label {
        display: block !important;
        width: 100% !important;
        white-space: normal !important;
        word-break: break-word !important;
        overflow-wrap: anywhere !important;
        overflow: visible !important;
    }

    /* Remove rounded corner overrides that break stacked layout */
    .details-table tr:first-child th,
    .details-table tr:first-child td,
    .details-table tr:last-child th,
    .details-table tr:last-child td {
        border-radius: 0 !important;
    }
}
/* Extra small devices */
@media (max-width: 576px) {
    .details-table {
        min-width: 700px !important;
    }

    .details-table th,
    .details-table td {
        font-size: 0.85rem !important;
        padding: 10px 14px !important;
    }

    .profile-img {
        width: 100px !important;
        height: 100px !important;
    }

    .card-title {
        font-size: 1.35rem !important;
    }
}

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="page-title-buttons">
        <a href="View_CommiteeMember.aspx" class="dashboard-btn btn-back">
            <i class="fas fa-arrow-left"></i>
            Back to Details
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container-fluid">
        <div class="card-committee">

            <h2 class="card-title">Committee Member Details</h2>

            <asp:Panel ID="pnlNotice" runat="server" Visible="false">

                <!-- Profile Image -->
                <div class="text-center mb-4">
                    <asp:Image ID="imgPhoto"
                        runat="server"
                        CssClass="profile-img"
                        ClientIDMode="Static" />
                </div>

                <!-- Details Table -->
                <div class="table-responsive">
                    <table class="table details-table">
                        <tbody>
                            <tr>
                                <th>Committee Member Name</th>
                                <td><asp:Label ID="lblname" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Designation</th>
                                <td><asp:Label ID="lbldes" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Role</th>
                                <td><asp:Label ID="lblRole" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Email</th>
                                <td><asp:Label ID="lblEmail" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Phone Number</th>
                                <td><asp:Label ID="lblphone" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Block Name</th>
                                <td><asp:Label ID="lblblock" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Flat No</th>
                                <td><asp:Label ID="lblNo" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>From Date</th>
                                <td><asp:Label ID="lblFdate" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>To Date</th>
                                <td><asp:Label ID="lblTdate" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Status</th>
                                <td><asp:Label ID="lblStatus" runat="server" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </asp:Panel>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>