<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_Poll.aspx.cs" Inherits="Society_management.User_Poll" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Swiper CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .pollSwiper {
            width: 100%;
            padding: 20px 0 40px;
        }
        
        .poll-card {
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
            height:300px;
        }
        
        .poll-question {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #0d6efd;
        }
        
        .poll-options {
            text-align: left;
            display: inline-block;
            margin-bottom: 20px;
            width: 100%;
        }
        
        .vote-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 15px;
        }
        
        .vote-btn:hover {
            background-color: #0056b3;
        }
        
        .poll-message.success {
            color: green;
            font-weight: bold;
            margin-top: 15px;
        }
        
        /* Navigation buttons */
        .swiper-button-next, .swiper-button-prev {
            color: #007bff;
            background: rgba(255,255,255,0.8);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .swiper-button-next:after, .swiper-button-prev:after {
            font-size: 20px;
        }
        
        /* Pagination */
        .swiper-pagination-bullet {
            background: #999;
            opacity: 1;
        }
        
        .swiper-pagination-bullet-active {
            background: #007bff;
        }
        
        /* No polls message */
        .no-poll-container {
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        
        .no-poll-container img {
            width: 80px;
            opacity: 0.7;
        }
        
        .no-poll-container h5 {
            color: #6c757d;
            font-weight: bold;
            margin-top: 15px;
        }
        /* =========================================
   EMPTY STATE COMPONENT 
========================================= */
.empty-state-container {
    padding: 60px 20px;
    text-align: center;
    background-color: #ffffff;
    border-radius: 1rem;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 6rem rgba(0,0,0,0.05);
    margin: 20px auto;
    max-width: 800px;
}

.empty-state-icon {
    font-size: 4rem;
    color: #007bff;
    opacity: 0.2;
    margin-bottom: 1.5rem;
    display: inline-block;
    animation: float 3s ease-in-out infinite;
}

@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
    100% { transform: translateY(0px); }
}

.empty-state-title {
    color: #1e293b;
    font-weight: 700;
    margin-bottom: 10px;
}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="PageHeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="PageHeaderButtons" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- ── Active Swiper Carousel Content Container ── --%>
    <asp:PlaceHolder ID="phDataContent" runat="server">
        <div class="swiper pollSwiper">
            <div class="swiper-wrapper">
                <asp:Repeater ID="rptPolls" runat="server" OnItemCommand="rptPolls_ItemCommand">
                    <ItemTemplate>
                        <div class="swiper-slide">
                            <div class="poll-card shadow rounded">
                                <h5 class="poll-question"><%# Eval("Question") %></h5>

                                <%-- Shows message if user has already voted --%>
                                <asp:PlaceHolder runat="server" Visible='<%# Convert.ToBoolean(Eval("HasVoted")) %>'>
                                    <div class='poll-message success'>
                                        <i class="fas fa-check-circle me-1"></i>You have already voted in this poll. Thank you!
                                    </div>
                                </asp:PlaceHolder>

                                <%-- Active Voting System Panel Controls --%>
                                <asp:Panel ID="pnlVote" runat="server" Visible='<%# !(bool)Eval("HasVoted") %>'>
                                    <asp:RadioButtonList ID="rblOptions" runat="server"
                                        CssClass="poll-options" 
                                        DataSource='<%# Eval("Options") %>'
                                        DataTextField="OptionText"
                                        DataValueField="OptionId">
                                    </asp:RadioButtonList>
                                    <asp:HiddenField ID="hfPollId" runat="server" Value='<%# Eval("PollId") %>' />
                                    <br />
                                    <asp:Button ID="btnVote" runat="server" Text="Submit Vote" CommandName="Vote" 
                                        CommandArgument='<%# Eval("PollId") %>' CssClass="vote-btn"
                                        OnClientClick="return validateSelection(this);" />
                                </asp:Panel>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="swiper-button-next"></div>
            <div class="swiper-button-prev"></div>
            <div class="swiper-pagination"></div>
        </div>
    </asp:PlaceHolder>

    <%-- ── New Animated Empty State Panel (Old structure completely removed) ── --%>
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-state-container">
            <div class="empty-state-icon">
                <i class="fas fa-poll-h"></i>
            </div>
            <h3 class="empty-state-title">No Active Polls</h3>
            <p class="text-muted mb-0">
                There are currently no active community opinion polls available for your society. Stay tuned!
            </p>
        </div>
    </asp:Panel>

</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Swiper JS -->
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize Swiper
            const swiper = new Swiper('.pollSwiper', {
                loop: true,
                
                speed: 800,
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
            });
        });
    </script>
    <script type="text/javascript">
        function validateSelection(btn) {
            var rbl = $(btn).closest('.poll-card').find('[id*=rblOptions]');
            if (rbl.find('input:checked').length === 0) {
                alert('Please select an option before voting.');
                return false;
            }
            return true;
        }
    </script>
</asp:Content>