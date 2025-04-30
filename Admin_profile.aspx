<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Admin_profile.aspx.cs" Inherits="Society_management.Admin_profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .profile-container {
            margin-top: 30px;
            max-width: 800px;
        }
        .profile-image-wrapper {
            width: 180px;
            height: 180px;
            margin: 0 auto 20px;
            position: relative;
            border-radius: 50%;
            overflow: hidden;
            border: 4px solid #e0e0e0;
            background-color: #f5f5f5;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .profile-image-wrapper:hover {
            border-color: #4285f4;
            box-shadow: 0 0 10px rgba(66, 133, 244, 0.5);
        }
        .profile-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .upload-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .profile-image-wrapper:hover .upload-overlay {
            opacity: 1;
        }
        .file-upload {
            display: none;
        }
        .profile-details {
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-label {
            font-weight: 600;
            color: #555;
        }
        .btn-update {
            background-color: #4285f4;
            border: none;
            padding: 10px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-update:hover {
            background-color: #3367d6;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
<div class="container profile-container">
    <div class="card">
        <div class="card-body">
            <div class="text-center mb-4">
                <h3 class="card-title">Admin Profile</h3>
                <hr class="w-25 mx-auto" style="border-top: 2px solid #4285f4;" />
            </div>

            <div class="row">
                <div class="col-md-4 text-center">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div class="profile-image-wrapper" onclick="document.getElementById('<%= fuUpload.ClientID %>').click();">
                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-image" AlternateText="Profile Picture"
                                    onerror="this.src='Images/default-profile.png'" />
                                <div class="upload-overlay">
                                    <i class="fas fa-camera fa-2x"></i>
                                </div>
                            </div>
                            <asp:FileUpload ID="fuUpload" runat="server" CssClass="file-upload" accept=".jpg,.jpeg,.png" />
                            <asp:Button ID="btnUpload" runat="server" Text="Upload Image" OnClick="fuUpload_Changed" CssClass="btn btn-sm btn-secondary mt-2" />
                            <small class="text-muted d-block mt-2">Click image to upload new photo</small>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <div class="col-md-8">
                    <div class="profile-details">
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label form-label">Name</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtname" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label form-label">Email</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtemail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label form-label">Phone</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtphone" runat="server" CssClass="form-control" TextMode="Phone"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group row mt-4">
                            <div class="col-sm-9 offset-sm-3">
                                <asp:Button ID="btnUpdate" runat="server" Text="Update Profile"
                                    CssClass="btn btn-update text-white" OnClick="btnUpdate_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</asp:Content>
