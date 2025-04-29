<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Block.aspx.cs" Inherits="Society_management.Block" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />

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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container" style="margin-top: 5%; margin-bottom: 5%">
            <div class="row">
                <div class="col-md-8 mx-auto">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col text-center">
                                    <h1>
                                        <p><i class="bi bi-buildings-fill"></i></p>
                                    </h1>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col">
                                    <center>
                                        <h4>Block</h4>
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
                                    <label>Block Name</label>
                                    <div class="form-group">
                                        <asp:TextBox CssClass="form-control" ID="txtBname" runat="server" placeholder="Block Name"></asp:TextBox>
                                    </div>
                                </div>
                            </div>


                            <div class="row">
                                <div class="col-md-12">
                                    <label>Location</label>
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlLocation" runat="server">
                                            <asp:ListItem>-- Select Location --</asp:ListItem>
                                            <asp:ListItem>North</asp:ListItem>
                                            <asp:ListItem>South</asp:ListItem>
                                            <asp:ListItem>East</asp:ListItem>
                                            <asp:ListItem>West</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12">
                                    <label>Society Name</label>
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlSociety" runat="server"></asp:DropDownList>
                                        <br />
                                        <br />
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <asp:Button CssClass="btn btn-success btn-block btn-lg" ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" />
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <a href="R_Society.aspx"><< Back To Registration</a><br />
                    <br />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
