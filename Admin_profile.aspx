<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master"
    AutoEventWireup="true"
    CodeBehind="Admin_profile.aspx.cs"
    Inherits="Society_management.Admin_profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style type="text/css">
        input[type="file"] {
            display: none;
        }

        .profile-pic {
            position: absolute;
            height: 120px;
            width: 120px;
            left: 50%;
            transform: translateX(-50%);
            top: 0px;
            z-index: 1001;
            padding: 10px;
        }

        .profile-pic img {
            border-radius: 50%;
            box-shadow: 0px 0px 5px 0px #c1c1c1;
            cursor: pointer;
            width: 100px;
            height: 100px;
        }

        .image11 {
            border-radius: 50%;
            box-shadow: 0px 0px 5px 0px #c1c1c1;
            cursor: pointer;
            object-fit: cover;
        }

        .image11:hover {
            cursor: pointer;
            opacity: 0.9;
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

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script type="text/javascript">
        $(document).ready(function () {

            // Click image to open file chooser
            $("#imgPhoto").on("click", function (e) {
                e.preventDefault();
                $("#profileImageUpload").click();
            });

        });

        function previewAndUpload(input) {
            if (input.files && input.files[0]) {

                var reader = new FileReader();

                reader.onload = function (e) {

                    // Show preview immediately
                    $("#imgPhoto").attr("src", e.target.result);

                    // Show loading popup
                    Swal.fire({
                        title: 'Uploading...',
                        text: 'Please wait while we upload your photo.',
                        allowOutsideClick: false,
                        showConfirmButton: false,
                        didOpen: function () {
                            Swal.showLoading();
                        }
                    });

                    // Submit full form (required for FileUpload)
                    setTimeout(function () {
                        document.forms[0].submit();
                    }, 1000);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>

    <link rel="stylesheet" type="text/css"
        href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />

    <link rel="stylesheet" type="text/css" href="profileone.css" />

    <meta name="viewport" content="width=device-width, initial-scale=1" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container profile-container">
        <div class="card">
            <div class="card-body">

                <div class="text-center mb-4">
                    <h3 class="card-title">Admin Profile</h3>
                    <hr class="w-25 mx-auto" style="border-top: 2px solid #4285f4;" />
                </div>

                <div class="row">

                    <!-- Profile Picture -->
                    <div class="col-md-4 text-center">
                        <div id="Div1" runat="server">
                            <asp:Image
                                ID="imgPhoto"
                                runat="server"
                                ClientIDMode="Static"
                                Height="210px"
                                Width="210px"
                                ImageUrl="~/Profile/Default.png"
                                AlternateText="User Pic"
                                CssClass="image11"
                                Style="cursor:pointer;" />
                        </div>

                        <asp:FileUpload
                            ID="profileImageUpload"
                            runat="server"
                            ClientIDMode="Static"
                            Style="display:none;"
                            onchange="previewAndUpload(this);" />

                        <asp:Label
                            ID="lblInstruction"
                            runat="server"
                            Text="Click image to upload new photo"
                            CssClass="text-muted d-block mt-2" />
                    </div>

                    <!-- Profile Details -->
                    <div class="col-md-8">
                        <div class="profile-details">

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label form-label">Name</label>
                                <div class="col-sm-9">
                                    <asp:TextBox
                                        ID="txtname"
                                        runat="server"
                                        CssClass="form-control"
                                        AutoCompleteType="Disabled">
                                    </asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label form-label">Email</label>
                                <div class="col-sm-9">
                                    <asp:TextBox
                                        ID="txtemail"
                                        runat="server"
                                        CssClass="form-control"
                                        TextMode="Email"
                                        AutoCompleteType="Disabled">
                                    </asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-3 col-form-label form-label">Phone</label>
                                <div class="col-sm-9">
                                    <asp:TextBox
                                        ID="txtphone"
                                        runat="server"
                                        CssClass="form-control"
                                        TextMode="Phone"
                                        AutoCompleteType="Disabled">
                                    </asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group row mt-4">
                                <div class="col-sm-9 offset-sm-3">
                                    <asp:Button
                                        ID="btnUpdate"
                                        runat="server"
                                        Text="Update Profile"
                                        CssClass="btn btn-update text-white"
                                        OnClick="btnUpdate_Click" />
                                </div>
                            </div>

                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>