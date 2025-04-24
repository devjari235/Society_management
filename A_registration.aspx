<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="A_registration.aspx.cs" Inherits="Society_management.A_registration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <style>
        .asp-validation, .asp-compare {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 3px;
            display: block;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .asp-validation::before, .asp-compare::before {
            content: "⚠ ";
            font-size: 0.85rem;
            margin-right: 4px;
        }

        .asp-validation.shake, .asp-compare.shake {
            animation: shake 0.3s ease-in-out 1;
        }

        @keyframes shake {
            0% { transform: translateX(0); }
            25% { transform: translateX(-4px); }
            50% { transform: translateX(4px); }
            75% { transform: translateX(-4px); }
            100% { transform: translateX(0); }
        }
    </style>

    <script type="text/javascript">
        function validateTerms(source, args) {
            args.IsValid = document.getElementById('<%= chkTerms.ClientID %>').checked;
        }
    </script>
</head>
<body style="background-color: #eee;">
    <form id="form1" runat="server">
        <section class="vh-100">
            <div class="container h-100">
                <div class="row d-flex justify-content-center align-items-center h-100">
                    <div class="col-lg-12 col-xl-11">
                        <div class="card text-black" style="border-radius: 25px;">
                            <div class="card-body p-md-5">
                                <div class="row justify-content-center">
                                    <div class="col-md-10 col-lg-6 col-xl-5 order-2 order-lg-1">

                                        <p class="text-center h1 fw-bold mb-5 mx-1 mx-md-4 mt-4">Sign up</p>

                                        <!-- Name -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                                            <div class="form-outline flex-fill mb-0">
                                                <label class="form-label" for="txtName">Your Name</label>
                                                <asp:TextBox ID="txtName" CssClass="form-control" runat="server" placeholder="Name" AutoCompleteType="Disabled"/>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                    ControlToValidate="txtName"
                                                    ErrorMessage="Please Enter Your Name"
                                                    SetFocusOnError="True"
                                                    CssClass="asp-validation">
                                                </asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <!-- Email -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-envelope fa-lg me-3 fa-fw"></i>
                                            <div class="form-outline flex-fill mb-0">
                                                <label class="form-label" for="txtEmail">Your Email</label>
                                                <asp:TextBox ID="txtEmail" CssClass="form-control" TextMode="Email" runat="server" placeholder="Email" AutoCompleteType="Disabled"/>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                    ControlToValidate="txtEmail"
                                                    ErrorMessage="Please Enter Your Email"
                                                    SetFocusOnError="True"
                                                    CssClass="asp-validation">
                                                </asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <!-- Password -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-lock fa-lg me-3 fa-fw"></i>
                                            <div class="form-outline flex-fill mb-0">
                                                <label class="form-label" for="txtPassword">Password</label>
                                                <asp:TextBox ID="txtPassword" CssClass="form-control" TextMode="Password" runat="server" placeholder="Password"/>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                    ControlToValidate="txtPassword"
                                                    ErrorMessage="Please Enter Your Password"
                                                    SetFocusOnError="True"
                                                    CssClass="asp-validation">
                                                </asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <!-- Confirm Password -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-key fa-lg me-3 fa-fw"></i>
                                            <div class="form-outline flex-fill mb-0">
                                                <label class="form-label" for="txtConfirmPassword">Repeat your password</label>
                                                <asp:TextBox ID="txtConfirmPassword" CssClass="form-control" TextMode="Password" runat="server" placeholder="Repeat Password"/>
                                                <asp:CompareValidator ID="CompareValidator1" runat="server"
                                                    ControlToCompare="txtPassword"
                                                    ControlToValidate="txtConfirmPassword"
                                                    ErrorMessage="Password and Confirm Password Must Be Same"
                                                    CssClass="asp-compare">
                                                </asp:CompareValidator>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                    ControlToValidate="txtConfirmPassword"
                                                    ErrorMessage="Please Enter Your Confirm Password"
                                                    SetFocusOnError="True"
                                                    CssClass="asp-validation">
                                                </asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <!-- Phone -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-phone fa-lg me-3 fa-fw"></i>
                                            <div class="form-outline flex-fill mb-0">
                                                <label class="form-label" for="txtPhone">Phone Number</label>
                                                <asp:TextBox ID="txtPhone" CssClass="form-control" TextMode="Phone" runat="server" placeholder="Phone Number" AutoCompleteType="Disabled"/>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                                    ControlToValidate="txtPhone"
                                                    ErrorMessage="Please Enter Your Number"
                                                    SetFocusOnError="True"
                                                    CssClass="asp-validation">
                                                </asp:RequiredFieldValidator>
                                            </div>
                                        </div>

                                        <!-- Terms -->
                                        <div class="form-check d-flex justify-content-center mb-1">
                                            <asp:CheckBox ID="chkTerms" CssClass="form-check-input me-2" runat="server" />
                                            <label class="form-check-label" for="chkTerms">
                                                I agree all statements in <a href="Terms.aspx">Terms of service</a>
                                            </label>
                                        </div>
                                        <div class="text-center mb-4">
                                            <asp:CustomValidator ID="cvTerms" runat="server"
                                                ErrorMessage="You must agree to the terms"
                                                ClientValidationFunction="validateTerms"
                                                OnServerValidate="cvTerms_ServerValidate"
                                                CssClass="asp-validation"
                                                Display="Dynamic">
                                            </asp:CustomValidator>
                                        </div>

                                        <!-- Button -->
                                        <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                                            <asp:Button ID="btnRegister" runat="server" CssClass="btn btn-primary btn-lg" Text="Register" OnClick="btnRegister_Click"/>
                                        </div>

                                    </div>
                                    <div class="col-md-10 col-lg-6 col-xl-7 d-flex align-items-center order-1 order-lg-2">
                                        <img src="https://wallpapercave.com/wp/wp2752752.jpg"
                                             class="img-fluid" alt="Sample image" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </form>
</body>
</html>