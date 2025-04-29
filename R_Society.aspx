<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="R_Society.aspx.cs" Inherits="Society_management.R_Society" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
             <%--bootstrap css--%>
     <link href="bootstrap\css\bootstrap.min.css" rel="stylesheet" />
   <%--datatable css--%>
 <link href="datatable\css\dataTables.dataTables.min.css" rel="stylesheet" />
   <%--fontawesome css--%>
 <link href="fontawesome\css\all.css" rel="stylesheet" />
 <%--Custom css--%>
  <link href="css\Customstylesheet.css" rel="stylesheet" />

 <%--jquery--%>
<script src="bootstrap\js\jquery-3.5.1.slim.min.js"></script>
<%-- popper js--%>
 <script src="bootstrap\js\popper.min.js"></script>
 <%--bootstrap js--%>
 <script src="bootstrap\js\bootstrap.min.js"></script>
 <%--Datatable  js--%>
<script src="datatable\js\dataTables.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
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
                                <asp:Button class="btn btn-success btn-block btn-lg" ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

           
        </div>
    </div>
</div>
    </form>
</body>
</html>
