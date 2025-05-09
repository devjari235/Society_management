<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="LiveNotice.aspx.cs" Inherits="Society_management.LiveNotice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Bootstrap & Swiper CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap 5 dropdown toggle) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap Bundle (includes Popper.js for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

     <script type="text/javascript">
         $(document).ready(function () {
             $('.table').prepend($('<thead></thead>').append($('.table').find('tr:first'))).dataTable();
         });
     </script>

  <%--  <style>
        body {
            background-color: #f4f4f4;
            font-family: 'Segoe UI', sans-serif;
        }

        .container-title {
            text-align: center;
            margin-top: 40px;
            margin-bottom: 20px;
        }

        /* Outer wrapper prevents overflow of slides */
        .swiper-container-wrapper {
            width: 100%;
            display: flex;
            justify-content: center;
            position: relative;
            padding: 0 60px; /* spacing for arrows */
        }

        .swiper {
            width: 100%;
            max-width: 900px;
            overflow: hidden; /* Hide next/prev cards */
        }

        .swiper-slide {
            background: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            color: #212529;
            height: auto;
        }

        .notice-title {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .badge {
            font-size: 0.8rem;
        }

        .text-muted {
            font-size: 0.85rem;
        }

        .swiper-pagination {
            text-align: center;
            margin-top: 20px;
        }

        .swiper-pagination-bullet {
            background: #adb5bd;
            opacity: 1;
            margin: 0 4px;
            padding: 5px 10px;
            border-radius: 6px;
        }

        .swiper-pagination-bullet-active {
            background: #0d6efd;
            color: #fff;
        }

        .swiper-button-next,
        .swiper-button-prev {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            color: #0d6efd;
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .swiper-button-next {
            right: 8.5%;
        }

        .swiper-button-prev {
            left: 8.5%;
        }
    </style>--%>

   

        <style>
 /* Page Title Buttons Container */
.page-title-buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    flex-wrap: wrap;
    
}

/* Left-aligned button group */
.button-group-left {
    display: flex;
    gap: 10px;
}

/* Base Button Style */
.dashboard-btn {
    padding: 10px 20px;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 600;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    cursor: pointer;
    text-decoration: none;
    color: white;
    border: none;
}

.dashboard-btn i {
    margin-right: 8px;
    font-size: 1rem;
}

/* Individual Button Colors */
.btn-create {
    background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
    margin-left: auto; /* Pushes Create button to the right */
}

.btn-Dashboard {
    background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
}

.btn-All {
    background: linear-gradient(135deg, #0575E6 0%, #021B79 100%);
}
.btn-Expire{
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
}

/* Hover Effects */
.dashboard-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    color: #FFD700;
    text-decoration:none;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .page-title-buttons {
        flex-direction: column;
        gap: 8px;
    }
    
    .button-group-left {
        width: 100%;
        justify-content: space-between;
    }
    
    .btn-create {
        width: 100%;
        margin-left: 0;
        order: -1; /* Moves Create button to top on mobile */
    }
    
    .dashboard-btn {
        width: 100%;
        text-align: center;
        justify-content: center;
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="page-title-buttons">
    <div class="button-group-left">
        <a href="NoticeDashboard.aspx" class="dashboard-btn btn-Dashboard">
            <i class="fas fa-arrow-left"></i>Notice Dashboard
        </a>
        <a href="View_Allnotice.aspx" class="dashboard-btn btn-All">
            <i class="fas fa-clipboard-list"></i> All Notice
        </a>
        <a href="ExpireNotice.aspx" class="dashboard-btn btn-Expire">
            <i class="far fa-calendar-times"></i> Expire Notice
        </a>
    </div>
    
    <a href="CreateNotice.aspx" class="dashboard-btn btn-create">
        <i class="fas fa-plus-circle"></i> Create Notice
    </a>
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
                <asp:GridView class="table table-striped table-bordered" ID="gvDisplay" runat="server" AutoGenerateColumns="False" OnRowCommand="gvDisplay_RowCommand">
                    <Columns>
                        
                        <asp:TemplateField HeaderText="Title">
                            <ItemTemplate>
                              <asp:Label Text='<%#Eval("Title") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Posted Date">
                            <ItemTemplate>
                                <asp:Label Text='<%# Eval("Posted_date", "{0:dd MMM yyyy}") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label Text='<%# Eval("Expiry_date", "{0:dd MMM yyyy}") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Importance">
                            <ItemTemplate>
                                <asp:Label Text='<%#Eval("Importance") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label Text='<%#Eval("Status") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                               <asp:Button ID="btnView" runat="server" Text="View" CommandName="ViewNotice" CommandArgument='<%# Eval("Notice_id") %>' Style="background-color:aquamarine; color:black" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>
</div>

   <%-- <div class="swiper-container-wrapper">
            <!-- Arrows -->
            <div class="swiper-button-prev"></div>

            <!-- Swiper -->
            <div class="swiper mySwiper">
                <div class="swiper-wrapper">
                    <asp:Repeater ID="rptNotices" runat="server">
                        <ItemTemplate>
                            <div class="swiper-slide">
                                <div class="notice-title"><%# Eval("Title") %></div>
                                <span class="badge bg-primary me-2"><%# Eval("Importance") %></span>
                                <span class="badge bg-success"><%# Eval("Status") %></span>
                                <p class="text-muted mt-2">Expires: <%# Eval("Expiry_date", "{0:dd MMM yyyy}") %></p>
                                <b><p>Posted By: <%# Eval("name") %></p></b>
                                <p><%# Eval("Description") %></p>
                                <asp:HyperLink runat="server" NavigateUrl='<%# Eval("File_path") %>' 
                                               Text="📎 View Attachment" Target="_blank"
                                               CssClass="btn btn-sm btn-outline-secondary mt-2"
                                               Visible='<%# !string.IsNullOrEmpty(Eval("File_path").ToString()) %>' />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="swiper-pagination"></div>
            </div>

            <div class="swiper-button-next"></div>
        </div>--%>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <%--<script>
        new Swiper(".mySwiper", {
            loop: true,
            slidesPerView: 1,
            spaceBetween: 30,
            pagination: {
                el: ".swiper-pagination",
                clickable: true,
                renderBullet: function (index, className) {
                    return '<span class="' + className + '">' + (index + 1) + "</span>";
                }
            },
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev"
            },
            autoplay: {
                delay: 5000,
                disableOnInteraction: false
            }
        });
    </script>--%>

</asp:Content>
