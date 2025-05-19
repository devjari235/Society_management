<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Complaint.aspx.cs" Inherits="Society_management.Complaint" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="Scripts/complaint.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Required for Bootstrap 5 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- OR for Bootstrap 4 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery (required for Bootstrap) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    .complaint-card {
    max-width: 800px;
    margin: 0 auto;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    overflow: hidden;
}

.complaint-card .card-header {
    padding: 15px 20px;
}

.complaint-card .card-body {
    padding: 30px;
}

.form-label {
    font-weight: 600;
    margin-bottom: 5px;
}

.invalid-feedback {
    display: none;
    color: #dc3545;
}

.is-invalid ~ .invalid-feedback {
    display: block;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .complaint-card .card-body {
        padding: 20px;
    }
    
    .row.mb-3 {
        margin-bottom: 1rem !important;
    }
}
</style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
            <div class="card complaint-card">
                <div class="card-header bg-primary text-white">
                    <h3 class="card-title">Register New Complaint</h3>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="ddlComplaintType" class="form-label">Complaint Type</label>
                            <asp:DropDownList ID="ddlComplaintType" runat="server" CssClass="form-select">
                                <asp:ListItem Value="">-- Select Complaint Type --</asp:ListItem>
                                <asp:ListItem Value="Maintenance">Maintenance</asp:ListItem>
                                <asp:ListItem Value="Security">Security</asp:ListItem>
                                <asp:ListItem Value="Parking">Parking</asp:ListItem>
                                <asp:ListItem Value="Noise">Noise Complaint</asp:ListItem>
                                <asp:ListItem Value="Cleanliness">Cleanliness</asp:ListItem>
                                <asp:ListItem Value="Cleanliness">Water</asp:ListItem>
                                <asp:ListItem Value="Cleanliness">Electricity</asp:ListItem>
                                <asp:ListItem Value="Other">Other</asp:ListItem>
                            </asp:DropDownList>
                            <div class="invalid-feedback" id="typeError">Please select a complaint type</div>
                        </div>
                        <div class="col-md-6">
                            <label for="txtPriority" class="form-label">Priority</label>
                            <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Low">Low</asp:ListItem>
                                <asp:ListItem Value="Medium" Selected="True">Medium</asp:ListItem>
                                <asp:ListItem Value="High">High</asp:ListItem>
                                <asp:ListItem Value="Emergency">Emergency</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="txtSubject" class="form-label">Subject</label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                        <div class="invalid-feedback" id="subjectError">Please enter a subject</div>
                    </div>

                    <div class="mb-3">
                        <label for="txtDescription" class="form-label">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
                        <div class="invalid-feedback" id="descError">Please enter a detailed description</div>
                        <div class="form-text">Please provide as much detail as possible to help us resolve your complaint quickly.</div>
                    </div>

                    <div class="mb-3">
                        <label for="fileUpload" class="form-label">Upload Supporting Documents (Optional)</label>
                        <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" multiple />
                        <div class="form-text">You can upload images or documents (max 5MB each)</div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary me-md-2" OnClientClick="return confirmCancel();" />
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit Complaint" CssClass="btn btn-primary" OnClick="btnSubmit_Click" OnClientClick="return validateForm();" />
                    </div>
                </div>
            </div>

            <!-- Success Modal -->
            <div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title">Complaint Submitted</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Your complaint has been submitted successfully!</p>
                            <p>Complaint ID: <strong><span id="complaintIdSpan" runat="server"></span></strong></p>
                            <p>We will get back to you soon.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
