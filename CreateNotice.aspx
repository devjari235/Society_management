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
    color: #FFD700;
    text-decoration:none;
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
    
    .dashboard-btn {
        width: 100%;
        text-align: center;
        justify-content: center;
    }
}
    </style>

       <style>
        body {
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
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
    </style>
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
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Enter notice description" />
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Notice Type</label>
                        <asp:DropDownList ID="ddlNoticeType" runat="server" CssClass="form-select">
                            <asp:ListItem Text="General" Value="General" />
                            <asp:ListItem Text="Emergency" Value="Emergency" />
                            <asp:ListItem Text="Event" Value="Event" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Importance</label>
                        <asp:DropDownList ID="ddlImportance" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Normal" Value="Normal" />
                            <asp:ListItem Text="Important" Value="Important" />
                            <asp:ListItem Text="Urgent" Value="Urgent" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Expiry Date</label>
                    <asp:TextBox ID="txtExpiry" runat="server" TextMode="Date" CssClass="form-control" />
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
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
