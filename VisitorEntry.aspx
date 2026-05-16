<%@ Page Title="New Visitor Entry" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="VisitorEntry.aspx.cs" Inherits="Society_management.VisitorEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- Bootstrap Icons (KEEP THIS) -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />

    <!-- jQuery (only if not already loaded in Master Page) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* --- Root Layout --- */
        .form-card {
            background-color: white;
            max-width: 750px;
            margin: 0 auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        .form-header {
            color: #333;
            font-weight: 700;
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f1f1f1;
        }

        /* --- Navigation Buttons --- */
        .page-action-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 0 auto 30px auto;
            max-width: 750px;
        }

        .dashboard-btn-pill {
            padding: 12px 20px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none !important;
            color: #FFFFFF !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            white-space: nowrap;
            border: none;
            font-size: 0.95rem;
        }

        .btn-blue-gradient { background: linear-gradient(135deg, #0575E6 0%, #021B79 100%); }
        .btn-grey-gradient { background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%); }

        .dashboard-btn-pill i { margin-right: 10px; font-size: 1.2rem; color: #FFFFFF; }

        .dashboard-btn-pill:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            filter: brightness(1.1);
        }

        /* --- Form Elements --- */
        .form-group-row {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .form-label-box {
            flex: 0 0 200px;
            font-weight: 700;
            color: #444;
            padding-top: 10px;
            font-size: 1rem;
        }

        .form-input-box {
            flex: 1;
            width: 100%;
        }

        .form-control-custom {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            border-radius: 10px;
            font-size: 1rem;
            background-color: #f8f9fa;
            transition: all 0.3s ease;
        }

        .form-control-custom:focus {
            background-color: #fff;
            border-color: #0575E6;
            box-shadow: 0 0 0 4px rgba(5, 117, 230, 0.1);
            outline: none;
        }

        .btn-submit-entry {
            background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
            color: white;
            border: none;
            padding: 14px 45px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            font-size: 1.1rem;
            box-shadow: 0 4px 15px rgba(2, 27, 121, 0.3);
            transition: all 0.3s ease;
        }

        /* --- Mobile UI Fixed --- */
        @media (max-width: 768px) {
            .page-action-container { 
                margin: 15px;
                grid-template-columns: 1fr;
            }
            
            .form-card { padding: 20px; margin: 15px; }

            .form-group-row { 
                display: block; 
                margin-bottom: 15px;
            }

            .form-label-box { 
                display: block;
                width: 100%; 
                margin-bottom: 5px; 
                padding-top: 0;
            }

            .form-input-box {
                display: block;
                width: 100%;
            }

            .btn-submit-entry { width: 100%; }
        }
    </style>
</asp:Content>

<%-- Content2 empty to remove the "Home" breadcrumb link --%>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="page-action-container">
        <a href="VisitorApproval.aspx" class="dashboard-btn-pill btn-blue-gradient">
            <i class="bi bi-check-circle-fill"></i>
            <span>Check Approval</span>
        </a>
        <a href="ScheduledVisitors.aspx" class="dashboard-btn-pill btn-grey-gradient">
            <i class="bi bi-calendar-check"></i>
            <span>Scheduled Visitors</span>
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-card">
        <h2 class="form-header">New Visitor Entry</h2>

        <div class="form-group-row">
            <asp:Label runat="server" Text="Visitor Name" CssClass="form-label-box" />
            <div class="form-input-box">
                <asp:TextBox ID="txtVisitorName" runat="server" CssClass="form-control-custom" placeholder="Full Name" />
                <asp:RequiredFieldValidator ID="rfvVisitorName" runat="server" ControlToValidate="txtVisitorName"
                    ErrorMessage="Required" CssClass="text-danger fw-bold small d-block mt-1" Display="Dynamic" />
            </div>
        </div>

        <div class="form-group-row">
            <asp:Label runat="server" Text="Contact Number" CssClass="form-label-box" />
            <div class="form-input-box">
                <asp:TextBox ID="txtContactNumber" runat="server" CssClass="form-control-custom" placeholder="10 Digit Number" MaxLength="10" />
                <asp:RequiredFieldValidator ID="rfvContact" runat="server" ControlToValidate="txtContactNumber"
                    ErrorMessage="Required" CssClass="text-danger fw-bold small d-block mt-1" Display="Dynamic" />
            </div>
        </div>

        <div class="form-group-row">
            <asp:Label runat="server" Text="Visit Purpose" CssClass="form-label-box" />
            <div class="form-input-box">
                <asp:TextBox ID="txtVisitPurpose" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control-custom" placeholder="Reason for visiting..." />
            </div>
        </div>

        <div class="form-group-row">
            <asp:Label runat="server" Text="Block Name" CssClass="form-label-box" />
            <div class="form-input-box">
                <asp:DropDownList ID="ddlBlock" runat="server" CssClass="form-control-custom" AutoPostBack="True" OnSelectedIndexChanged="ddlBlock_SelectedIndexChanged">
                    <asp:ListItem Text="-- Select Block --" Value="" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-group-row">
            <asp:Label runat="server" Text="Meeting With" CssClass="form-label-box" />
            <div class="form-input-box">
                <asp:DropDownList ID="ddlMembers" runat="server" CssClass="form-control-custom">
                    <asp:ListItem Text="-- Select Member --" Value="" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-group-row pt-2">
            <div class="form-label-box d-none d-md-block"></div>
            <div class="form-input-box">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Entry" OnClick="btnSubmit_Click" CssClass="btn-submit-entry" />
            </div>
        </div>
    </div>
</asp:Content>