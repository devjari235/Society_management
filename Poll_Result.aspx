<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="Poll_Result.aspx.cs" Inherits="Society_management.Poll_Result" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Optional: Bootstrap CSS for styling (not required for icons to work) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap & Swiper CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" rel="stylesheet" />
    <!-- jQuery (required for Bootstrap 5 dropdown toggle) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap Bundle (includes Popper.js for dropdowns) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Swiper CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />

<!-- Swiper JS -->
<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>

<%--<script>
    document.addEventListener("DOMContentLoaded", function () {
        new Swiper(".pollSwiper", {
            slidesPerView: 1,
            spaceBetween: 30,
            loop: true,
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev"
            },
            pagination: {
                el: ".swiper-pagination",
                clickable: true
            }
        });
    });
</script>--%>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            new Swiper(".pollSwiper", {
                slidesPerView: 1,
                spaceBetween: 30,
                loop: true,
                autoplay: {
                    delay: 3000, // 3 seconds
                    disableOnInteraction: false
                },
                navigation: {
                    nextEl: ".swiper-button-next",
                    prevEl: ".swiper-button-prev"
                },
                pagination: {
                    el: ".swiper-pagination",
                    clickable: true
                }
            });
        });
    </script>

    <style>
        .poll-results {
            width: 60%;
            margin: 30px auto;
            font-family: Arial;
        }
        .result-bar {
            background-color: #ddd;
            height: 20px;
            margin: 5px 0;
            position: relative;
        }
        .result-fill {
            background-color: #4caf50;
            height: 100%;
        }
        .result-text {
            position: absolute;
            left: 10px;
            top: 0;
            height: 100%;
            line-height: 20px;
            font-size: 12px;
            color: #fff;
        }

        .poll-card {
        min-height: 300px;
        max-width: 500px;
        margin: auto;
    }

    .swiper {
        padding-top: 30px;
        padding-bottom: 30px;
    }

    .swiper-slide {
        background: #f9f9f9;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        transition: transform 0.3s ease-in-out;
    }

    .swiper-slide-active {
        transform: scale(1.05);
    }
    </style>
    <style>
    .swiper {
        width: 100%;
        max-width: 800px;
        margin: 20px auto;
    }

    .swiper-wrapper {
        display: flex;
    }

    .swiper-slide {
        display: flex;
        justify-content: center;
        align-items: center;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        padding: 20px;
        height: auto; /* important for content-based height */
        min-height: 250px; /* ensure some visible area */
    }

    .poll-card {
        width: 100%;
        max-width: 700px;
    }

    .progress {
        height: 20px;
    }

    .swiper-button-next,
    .swiper-button-prev {
        color: #007bff;
    }
    .create-notice-container{
    display: flex; 
    justify-content: flex-end;
}

    .btn-create-notice {
            background: linear-gradient(135deg, #8E2DE2 0%, #4A00E0 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 25px;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            text-decoration:none;
        }
        
        .btn-create-notice:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            color: #FFD700;
            background: linear-gradient(135deg, #9d3df1 0%, #5b1ae6 100%);
            text-decoration:none;
        }
        
        .btn-create-notice i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
</style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
        <div class="create-notice-container">
            <a href="PollCreate.aspx" class="btn-create-notice">
                <i class="fas fa-plus-circle"></i> Poll Create
            </a>
        </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<div class="swiper pollSwiper">
    <div class="swiper-wrapper">
        <asp:Repeater ID="rptPolls" runat="server" OnItemDataBound="rptPolls_ItemDataBound">
            <ItemTemplate>
                <div class="swiper-slide">
                    <div class="poll-card shadow p-4 rounded bg-white">
                        <h5 class="text-primary mb-3"><%# Eval("Question") %></h5>

                        <asp:Repeater ID="rptOptions" runat="server">
                            <ItemTemplate>
                                <div class="mb-3">
                                    <strong><%# Eval("OptionText") %></strong>
                                    <div class="progress mt-1" style="height: 20px;">
                                        <div class="progress-bar bg-success" role="progressbar"
                                            style='width:<%# Eval("Percentage") %>%;'
                                            aria-valuenow='<%# Eval("Percentage") %>' aria-valuemin="0" aria-valuemax="100">
                                            <%# Eval("VoteCount") %> votes (<%# Eval("Percentage") %>%)
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <p class="text-muted">Total votes: <%# Eval("TotalVotes") %></p>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlNoPoll" runat="server" Visible="false">
        <div class="swiper-slide d-flex align-items-center justify-content-center" style="height: 300px;">
            <div class="text-center p-4">
                <img src="https://cdn-icons-png.flaticon.com/512/4076/4076549.png" alt="No Polls" style="width: 80px;" />
                <h5 class="mt-3 fw-bold text-secondary">No Poll Available</h5>
                <p class="text-muted">Stay tuned! New polls will appear here soon.</p>
            </div>
        </div>
    </asp:Panel>

    <!-- Navigation -->
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
    <div class="swiper-pagination"></div>
</div>


</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
