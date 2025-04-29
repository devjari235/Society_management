<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Flat.aspx.cs" Inherits="Society_management.Flat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
             <div class="container" style="margin-top:5%; margin-bottom:5%">
    <div class="row">
        <div class="col-md-8 mx-auto">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col">
                            <center>
                                <img src="Images\Logo.png" width="100px" />
                            </center>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                         <center>
                          <h4>Registration</h4>
                         </center>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <hr />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label>Admin Name</label>
                            <div class="form-group">
                                <asp:DropDownList ID="ddlAdmin" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                           <div class="col-md-4">
                               <label>Society Name</label>
                                <div class="form-group">
                                   <asp:TextBox CssClass="form-control" ID="txtSname" runat="server" placeholder="Society Name"></asp:TextBox>
                                 </div>
                           </div>

                        <div class="col-md-4">
                            <label>IncorporationDate</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtINCdate" runat="server" placeholder="IncorporationDate" TextMode="Date"></asp:TextBox>
                            </div>
                       </div>
                        

                    </div>


                    <div class="row">
                       <div class="col-md-6">
                           <label>Registration Number</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtNumber" runat="server" placeholder="Registration Number"></asp:TextBox>
                            </div>
                       </div>

                   
                        <div class="col-md-6">
                            <label>Slogan</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtSlogan" runat="server" placeholder="Slogan"></asp:TextBox>
                            </div>
                        </div>
                         
                   </div>


                      <div class="row">
                           <div class="col-md-4">
                            <label>RegistrationDate</label>
                                <div class="form-group">
                                     <asp:TextBox CssClass="form-control" ID="txtRDate" runat="server" placeholder="RegistrationDate" TextMode="Date"></asp:TextBox>
                                </div>
                           </div>

                         <div class="col-md-4">
                          <label>EntryDate</label>
                             <div class="form-group">
                                  <asp:TextBox CssClass="form-control" ID="txtEntryDate" runat="server" placeholder="EntryDate" TextMode="Date"></asp:TextBox>
                             </div>
                          </div>
                          <div class="col-md-4">
                            <label>Logo</label>
                                 <div class="form-group">
                                     <asp:FileUpload ID="FuLogo" runat="server" />
                                  </div>
                            </div>
                      </div>


                     <div class="row">
                             <div class="col-md-6">
                         <label>Full Address</label>
                          <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtAdd" runat="server" placeholder="Full Address" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </div>
                             <div class="col-md-6">
                         <label>BuilderDetails</label>
                          <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtBuilderDetails" runat="server" placeholder="BuilderDetails" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </div>
                   </div>



                     <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="form-group">
                                <asp:Button class="btn btn-success btn-block btn-lg" ID="btnAdd" runat="server" Text="Add"/>
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
