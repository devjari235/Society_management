<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Flat.aspx.cs" Inherits="Society_management.Flat" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div style="margin-bottom: 20px; text-align: left;">
    <asp:Button ID="btnAddFlat" runat="server" Text="Add Flat" CssClass="btn btn-primary"  />
    <asp:Button ID="btnViewFlats" runat="server" Text="View All Flats" CssClass="btn btn-secondary"  />
    <asp:Button ID="btnFlatHistory" runat="server" Text="Flat History" CssClass="btn btn-info" />
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
                          <h4>Add Flat</h4>
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
                               <label>Flat No</label>
                                <div class="form-group">
                                   <asp:TextBox CssClass="form-control" ID="txtFno" runat="server" placeholder="Flat No"></asp:TextBox>
                                 </div>
                           </div>

                        <div class="col-md-6">
                            <label>Floor</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtFloor" runat="server" placeholder="Floor"></asp:TextBox>
                            </div>
                       </div>
                        

                    </div>


                    <div class="row">
                        <div class="col-md-4">
                            <label>Flat Type</label>
                            <div class="form-group">
                                <asp:DropDownList ID="ddlType" runat="server">
                                    <asp:ListItem Value="0">--Select Flat Type--</asp:ListItem>
                                    <asp:ListItem>Studio Apartment</asp:ListItem>
                                    <asp:ListItem>1 BHK</asp:ListItem>
                                    <asp:ListItem>2 BHK</asp:ListItem>
                                    <asp:ListItem>3 BHK</asp:ListItem>
                                    <asp:ListItem>4 BHK and above</asp:ListItem>
                                    <asp:ListItem>Duplex</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                       <div class="col-md-6">
                           <label>Sqft</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtsqft" runat="server" placeholder="Sqft"></asp:TextBox>
                            </div>
                       </div>
                   </div>


                      <div class="row">
                           <div class="col-md-4">
                            <label>Occupancy status</label>
                                <div class="form-group">
                                     <asp:DropDownList ID="ddlstatus" runat="server">
                                         <asp:ListItem Value="0">--Select Status--</asp:ListItem>
                                         <asp:ListItem>Rental</asp:ListItem>
                                         <asp:ListItem>Self occupy</asp:ListItem>
                                     </asp:DropDownList>
                                </div>
                           </div>

                         <div class="col-md-4">
                          <label>Mentanance</label>
                             <div class="form-group">
                                  <asp:TextBox CssClass="form-control" ID="txtMentanance" runat="server" placeholder="Mentanance"></asp:TextBox>
                             </div>
                          </div>
                          <div class="col-md-4">
                            <label>Block</label>
                                  <div class="form-group">
                                      <asp:DropDownList ID="ddlBlock" runat="server"></asp:DropDownList>
                                      <br />
                                 </div>
                            </div>
                      </div>

                    <div class="container">
                        <div class="row justify-content-center" style="margin-top: 20px;">
                            <div class="col-md-6">
                                <div class="form-group text-center">
                                    <asp:Button class="btn btn-success btn-block btn-lg" ID="btnAdd" runat="server" Text="Add" />
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
