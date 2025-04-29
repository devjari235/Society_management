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
    <style>
  .asp-validation {
  color:firebrick;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 6px;
  margin-left: 5px;
  transition: all 0.3s ease-in-out;
}

.asp-validation::before {
  content: "⚠  ";
  font-family: "Font Awesome 6 Free";
  font-weight: 900;
  font-size: 14px;
}
    </style>
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
                                <br />
                                <asp:RequiredFieldValidator  CssClass="asp-validation"  ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlAdmin" Display="Dynamic" ErrorMessage="Select Admin Name" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                           <div class="col-md-4">
                               <label>Society Name</label>
                                <div class="form-group">
                                   <asp:TextBox CssClass="form-control" ID="txtSname" runat="server" placeholder="Society Name"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator  CssClass="asp-validation" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtSname" Display="Dynamic" ErrorMessage="Enetr Society Name" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                 </div>
                           </div>

                        <div class="col-md-4">
                            <label>IncorporationDate</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtINCdate" runat="server" placeholder="IncorporationDate" TextMode="Date"></asp:TextBox>
                                 <br />
                                 <asp:RequiredFieldValidator  CssClass="asp-validation" ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtINCdate" Display="Dynamic" ErrorMessage="Select Date" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </div>
                       </div>
                        

                    </div>


                    <div class="row">
                       <div class="col-md-6">
                           <label>Registration Number</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtNumber" runat="server" placeholder="Registration Number"></asp:TextBox>
                                 <br />
                                 <asp:RequiredFieldValidator  CssClass="asp-validation" ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtNumber" Display="Dynamic" ErrorMessage="Enter Registration NO." SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </div>
                       </div>

                   
                        <div class="col-md-6">
                            <label>Slogan</label>
                            <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtSlogan" runat="server" placeholder="Slogan"></asp:TextBox>
                                 <br />
                                 <asp:RequiredFieldValidator  CssClass="asp-validation" ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtSlogan" Display="Dynamic" ErrorMessage="Enter Slogan" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                         
                   </div>


                      <div class="row">
                           <div class="col-md-4">
                            <label>RegistrationDate</label>
                                <div class="form-group">
                                     <asp:TextBox CssClass="form-control" ID="txtRDate" runat="server" placeholder="RegistrationDate" TextMode="Date"></asp:TextBox>
                                     <br />
                                     <asp:RequiredFieldValidator  CssClass="asp-validation" ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtRDate" Display="Dynamic" ErrorMessage="Select Date" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                </div>
                           </div>

                         <div class="col-md-4">
                          <label>EntryDate</label>
                             <div class="form-group">
                                  <asp:TextBox CssClass="form-control" ID="txtEntryDate" runat="server" placeholder="EntryDate" TextMode="Date"></asp:TextBox>
                                  <br />
                                  <asp:RequiredFieldValidator  CssClass="asp-validation" ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtEntryDate" Display="Dynamic" ErrorMessage="Select Date" SetFocusOnError="True"></asp:RequiredFieldValidator>
                             </div>
                          </div>
                          <div class="col-md-4">
                            <label>Logo</label>
                                 <div class="form-group">
                                     <asp:FileUpload ID="FuLogo" runat="server" />
                                     <br />
                                     <asp:RequiredFieldValidator CssClass="asp-validation" ID="RequiredFieldValidator8" runat="server" ControlToValidate="FuLogo" Display="Dynamic" ErrorMessage="Attache Logo" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                  </div>
                            </div>
                      </div>


                     <div class="row">
                             <div class="col-md-6">
                         <label>Full Address</label>
                          <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtAdd" runat="server" placeholder="Full Address" TextMode="MultiLine"></asp:TextBox>
                                 <br />
                                 <asp:RequiredFieldValidator  CssClass="asp-validation" ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtAdd" ErrorMessage="Enter the Address." SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                             <div class="col-md-6">
                         <label>BuilderDetails</label>
                          <div class="form-group">
                                 <asp:TextBox CssClass="form-control" ID="txtBuilderDetails" runat="server" placeholder="BuilderDetails" TextMode="MultiLine"></asp:TextBox>
                                 <br />
                                 <asp:RequiredFieldValidator CssClass="asp-validation" ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtBuilderDetails" Display="Dynamic" ErrorMessage="Enter Builder Details." SetFocusOnError="True"></asp:RequiredFieldValidator>
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
