<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_profile.aspx.cs" Inherits="Society_management.User_profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        input[type="file"] {
    display: none;
}


.profile-pic{
    position: absolute;
    height:120px;
    width:120px;
    left: 50%;
    transform: translateX(-50%);
    top: 0px;
    z-index: 1001;
    padding: 10px;
}
.profile-pic img{
   
    border-radius: 50%;
    box-shadow: 0px 0px 5px 0px #c1c1c1;
    cursor: pointer;
    width: 100px;
    height: 100px;
}   
.image11:hover{
    cursor:pointer;
}
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
    <script>
            function uploadProfilePicture() {
                // Show loading indicator (optional)
                Swal.fire({
                    title: 'Uploading...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                // Trigger postback to server
                 __doPostBack('<%= profileImageUpload.ClientID %>', '');
                 }
    </script>
    <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>
      <link rel="stylesheet" type="text/css" href="profileone.css"/>
      <!-- <link rel="stylesheet" type="text/css" href="profile.css"> -->
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet"/>
             <script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container profile-container">
        <div class="card">
            <div class="card-body">
                <div class="text-center mb-4">
                    <h3 class="card-title">User Profile</h3>
                    <hr class="w-25 mx-auto" style="border-top: 2px solid #4285f4;" />
                </div>

                <div class="row">
                    <div class="col-md-4 text-center">
                        <asp:Image 
                            ID="imgPhoto" 
                            runat="server" 
                            Height="210px" 
                            CssClass="image11" 
                            ImageUrl="https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2023/08/tiktok-no-profile-picture.png"
                            AlternateText="User Pic"
                            onclick="document.getElementById('profileImageUpload').click();" />

                        <asp:FileUpload 
                            ID="profileImageUpload" 
                            runat="server" 
                            CssClass="hidden" 
                            ClientIDMode="Static"
                            AutoPostBack="true"
                            OnLoad="profileImageUpload_Load" />
                        
                        <asp:Label 
                            ID="lblInstruction" 
                            runat="server" 
                            Text="Click image to upload new photo" 
                            CssClass="text-muted d-block mt-2" />
                    </div>

                    <div class="col-md-8">
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label">Name</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtname" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label">Email</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtemail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label">Phone</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtphone" runat="server" CssClass="form-control" TextMode="Phone"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label">Gender</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtGender" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label">Age</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtAge" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label">Marital Status</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="txtMarital" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group row mt-4">
                            <div class="col-sm-9 offset-sm-3">
                                <asp:Button ID="btnUpdate" runat="server" Text="Update Profile" 
                                    CssClass="btn btn-primary" OnClick="btnUpdate_Click" />
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
