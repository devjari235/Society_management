<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Owner.aspx.cs" Inherits="Society_management.Owner" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
       <style>
       .col-md-6, .col-md-4{
           margin-top:10px;
       }
   </style>
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
        <div style="margin-bottom: 20px; text-align: left;">
    <asp:Button ID="btnAddOwner" runat="server" Text="Add Owner" CssClass="btn btn-primary"/>
    <asp:Button ID="btnViewOwner" runat="server" Text="View All Owner" CssClass="btn btn-secondary"/>
    <asp:Button ID="btnOwnerHistory" runat="server" Text="Owner History" CssClass="btn btn-info" />
</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col">
                                <center>
                                    <h4>Add Owner Details</h4>
                                </center>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">
                                <hr />
                            </div>
                        </div>

                        <div class="row">

                            <div class="col-md-6">
                                <label>Owner Name</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtname" runat="server" placeholder="Owner Name"></asp:TextBox>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label>Email</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtEmail" runat="server" placeholder="Email"></asp:TextBox>
                                </div>
                            </div>


                        </div>


                        <div class="row">
                            <div class="col-md-6">
                                <label>Contact Number</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtnumber" runat="server" placeholder="Contact Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label>Emergency Number</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtE_number" runat="server" placeholder="Emergency Number"></asp:TextBox>
                                </div>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-6">
                                <label>Block</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlBlock" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlBlock_SelectedIndexChanged"></asp:DropDownList>
                                    <br />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label>Flat</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlFlat" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                           
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label>Total Member</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtmember" runat="server" placeholder="Total Member"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label>Allotment Date</label>
                                <div class="form-group">
                                    <asp:TextBox CssClass="form-control" ID="txtdate" runat="server" placeholder="Allotment Date" TextMode="Date"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="container">
                            <div class="row justify-content-center" style="margin-top: 20px;">
                                <div class="col-md-6">
                                    <div class="form-group text-center">
                                        <asp:Button class="btn btn-success btn-block btn-lg" ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click"/>
                                    </div>
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
