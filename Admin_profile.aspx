<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Admin_profile.aspx.cs" Inherits="Society_management.Admin_profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
   <style>
       .col-md-6{
           margin-top:20px;
       }
   </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
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
                             <asp:Image ID="imgProfile" runat="server" />
                             <asp:FileUpload ID="fuUpload" runat="server" CssClass="btn" />
                             <asp:Button ID="btnUpload" runat="server" OnClick="btnUpload_Click" Text="Upload Picture" CssClass="btn" />
                          <h4>Profile</h4>
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
                               <label>Name</label>
                                <div class="form-group">
                                   <asp:TextBox CssClass="form-control" ID="txtname" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                                 </div>
                           </div>
                    </div>


                    <div class="row">
                        <div class="col-md-6">
                            <label>Email</label>
                            <div class="form-group">
                               <asp:TextBox CssClass="form-control" ID="txtemail" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                       
                   </div>


                      <div class="row">
                          <div class="col-md-6">
                              <label>Phone No</label>
                              <div class="form-group">
                                  <asp:TextBox CssClass="form-control" ID="txtphone" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                              </div>
                          </div>
                      </div>

                     <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:Button class="btn btn-success btn-block btn-lg" ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
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