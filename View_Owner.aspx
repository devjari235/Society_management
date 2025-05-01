<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="View_Owner.aspx.cs" Inherits="Society_management.View_Owner" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">

$(document).ready(function () {
    $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
}) 

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div style="margin-bottom: 20px; text-align: left;">
<asp:Label ID="lblOwner" runat="server" CssClass="btn btn-primary"><b><a href="Owner.aspx" style="color:black; text-decoration: none;">Add Owner</a></b></asp:Label>
<asp:Label id="lblFlatView" runat="server" CssClass="btn btn-secondary"><b><a href="View_Owner.aspx" style="color:black; text-decoration: none;">View All Owner</a></b></asp:Label>
<asp:Label id="lblHist" runat="server" CssClass="btn btn-info"><b><a  href="#" style="color:black; text-decoration: none; ">Owner History</a></b></asp:Label>
</div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <asp:Panel CssClass="alert alert-success" role="alert" ID="Panel1" runat="server" Visible="false">
                <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
            </asp:Panel>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="table-responsive">
                <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" DataKeyNames="Block_name">
                    <Columns>
                        <asp:BoundField DataField="Block_name" HeaderText="Block Name" ReadOnly="true" SortExpression="Block_name" />
                        <asp:TemplateField HeaderText="Details">
                            <ItemTemplate>
                                <div class="container-fluid">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="row">
                                                <div class="col- 12">
                                                   
                                                    Owner Name-<asp:Label ID="lblOwner_name" runat="server" Text='<%#Eval("Owner_name") %>' Font-Bold="True" Font-Size="Large"></asp:Label>
                                                    &nbsp;| Email-<asp:Label ID="lblEmail" runat="server" Text='<%#Eval("Email_id") %>' Font-Bold="True" Font-Size="Large"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div>
                                                    Contact Number-<asp:Label ID="lblContact_no" runat="server" Text='<%#Eval("Contact_no") %>' Font-Bold="True"></asp:Label>
                                                    &nbsp;| Emergency Number-<asp:Label ID="lblEmergency_Number" runat="server" Text='<%#Eval("Emergency_Number") %>' Font-Bold="True"></asp:Label>

                                                </div>
                                            </div>
                                            <div class="row">
                                                <div>
                                                    Flat Number-<asp:Label ID="lblflat" runat="server" Text='<%#Eval("Flate_no") %>' Font-Bold="True" Font-Size="Medium"></asp:Label>
                                                    &nbsp;| Total Member-<asp:Label ID="lblmember" runat="server" Text='<%#Eval("Total_member") %>' Font-Size="Medium" Font-Bold="True"></asp:Label>

                                                </div>
                                            </div>
                                            <div class="row">
                                                <div>
                                                    Allotment Date-<asp:Label ID="lblAllotment_Date" runat="server" Text='<%#Eval("Allotment_Date") %>' Font-Bold="True" Font-Size="Medium"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
