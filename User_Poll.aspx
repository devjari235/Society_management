<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_Poll.aspx.cs" Inherits="Society_management.User_Poll" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .poll-container {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
            max-width: 500px;
            margin: 0 auto;
        }
        .poll-question {
            font-weight: bold;
            margin-bottom: 15px;
            font-size: 18px;
        }
        .poll-option {
            margin: 10px 0;
        }
        .poll-results {
            margin-top: 20px;
        }
        .result-bar {
            background-color: #f0f0f0;
            height: 20px;
            margin: 5px 0;
            position: relative;
        }
        .result-fill {
            background-color: #4CAF50;
            height: 100%;
        }
        .result-text {
            position: absolute;
            right: 5px;
            top: 0;
            line-height: 20px;
            color: #333;
        }
        .admin-section {
            margin-top: 30px;
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .error-message {
            color: red;
            margin: 10px 0;
        }
        .success-message {
            color: green;
            margin: 10px 0;
        }
        /* Base Styles */
:root {
    --primary-color: #4285f4;
    --secondary-color: #34a853;
    --danger-color: #ea4335;
    --light-gray: #f8f9fa;
    --medium-gray: #e9ecef;
    --dark-gray: #6c757d;
    --text-color: #212529;
    --border-radius: 0.375rem;
    --box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
    --transition: all 0.3s ease;
}

body {
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    line-height: 1.6;
    color: var(--text-color);
    background-color: #f5f7fa;
    margin: 0;
    min-height: 100vh;
}

/* Poll Container */
.poll-container {
    background-color: white;
    border-radius: var(--border-radius);
    box-shadow: var(--box-shadow);
    padding: 2rem;
    max-width: 600px;
    margin: 2rem auto;
    transition: var(--transition);
}

.poll-container:hover {
    box-shadow: 0 0.75rem 1.5rem rgba(0, 0, 0, 0.1);
}

/* Poll Question */
.poll-question {
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--text-color);
    margin-bottom: 1.5rem;
    padding-bottom: 0.75rem;
    border-bottom: 2px solid var(--medium-gray);
    position: relative;
}

.poll-question::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 50px;
    height: 2px;
    background-color: var(--primary-color);
}

/* Voting Options */
.poll-options {
    margin: 1.5rem 0;
}

.poll-option {
    margin: 0.75rem 0;
    display: flex;
    align-items: center;
    padding: 0.75rem;
    border-radius: var(--border-radius);
    transition: var(--transition);
    background-color: var(--light-gray);
}

.poll-option:hover {
    background-color: var(--medium-gray);
    transform: translateX(5px);
}

.poll-option input[type="radio"] {
    margin-right: 1rem;
    transform: scale(1.2);
    accent-color: var(--primary-color);
    cursor: pointer;
}

.poll-option label {
    font-size: 1.1rem;
    color: var(--text-color);
    cursor: pointer;
    flex-grow: 1;
}

/* Buttons */
.btn {
    display: inline-block;
    font-weight: 500;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    user-select: none;
    border: 1px solid transparent;
    padding: 0.5rem 1.25rem;
    font-size: 1rem;
    line-height: 1.5;
    border-radius: var(--border-radius);
    transition: var(--transition);
    cursor: pointer;
}

.btn-primary {
    color: white;
    background-color: var(--primary-color);
    border-color: var(--primary-color);
}

.btn-primary:hover {
    background-color: #3367d6;
    transform: translateY(-2px);
}

.btn-danger {
    color: white;
    background-color: var(--danger-color);
    border-color: var(--danger-color);
}

.btn-danger:hover {
    background-color: #d33426;
    transform: translateY(-2px);
}

/* Results Section */
.poll-results {
    margin-top: 2rem;
    padding-top: 1.5rem;
    border-top: 2px solid var(--medium-gray);
    animation: fadeIn 0.5s ease-out;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.result-item {
    margin-bottom: 1.25rem;
}

.result-label {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.5rem;
    font-weight: 500;
}

.result-bar-container {
    height: 1.5rem;
    background-color: var(--light-gray);
    border-radius: 1rem;
    overflow: hidden;
    position: relative;
}

.result-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
    border-radius: 1rem;
    transition: width 1s ease-out;
    min-width: 3%;
}

.result-text {
    position: absolute;
    right: 0.75rem;
    top: 50%;
    transform: translateY(-50%);
    color: white;
    font-size: 0.85rem;
    font-weight: 600;
    text-shadow: 0 0 2px rgba(0,0,0,0.3);
}

.total-votes {
    margin-top: 1.5rem;
    font-style: italic;
    color: var(--dark-gray);
    text-align: right;
}

/* Admin Section */
.admin-section {
    margin-top: 2.5rem;
    padding: 1.5rem;
    background-color: var(--light-gray);
    border-radius: var(--border-radius);
    border: 1px solid var(--medium-gray);
    animation: slideUp 0.4s ease-out;
}

@keyframes slideUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.admin-section h3 {
    color: var(--text-color);
    margin-top: 0;
    padding-bottom: 0.75rem;
    border-bottom: 2px solid var(--medium-gray);
    position: relative;
}

.admin-section h3::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 50px;
    height: 2px;
    background-color: var(--danger-color);
}

.form-group {
    margin-bottom: 1.25rem;
}

.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: var(--text-color);
}

.form-control {
    display: block;
    width: 100%;
    padding: 0.75rem;
    font-size: 1rem;
    line-height: 1.5;
    color: var(--text-color);
    background-color: white;
    background-clip: padding-box;
    border: 1px solid var(--medium-gray);
    border-radius: var(--border-radius);
    transition: var(--transition);
}

.form-control:focus {
    border-color: var(--primary-color);
    outline: 0;
    box-shadow: 0 0 0 0.2rem rgba(66, 133, 244, 0.25);
}

.textarea-options {
    min-height: 120px;
    resize: vertical;
}

/* Messages */
.message {
    margin: 1rem 0;
    border-radius: var(--border-radius);
    font-size: 0.95rem;
    animation: fadeIn 0.3s ease-out;
}

.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.success-message {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

/* Status Panels */
.already-voted, .no-poll {
    text-align: center;
    border-radius: var(--border-radius);
    margin: 1rem 0;
    animation: fadeIn 0.5s ease-out;
}

.already-voted {
    background-color: #e2e3e5;
    color: #383d41;
    border: 1px solid #d6d8db;
}

.no-poll {
    background-color: #d1ecf1;
    color: #0c5460;
    border: 1px solid #bee5eb;
}

/* Responsive Design */
@media (max-width: 768px) {
    .poll-container {
        margin: 1rem auto;
    }
    
    .poll-question {
        font-size: 1.3rem;
    }
    

}

@media (max-width: 576px) {
    .poll-question {
        font-size: 1.2rem;
    }
    
    .btn {
        width: 100%;
        margin-bottom: 0.5rem;
    }
    
    .btn-danger {
        margin-left: 0;
    }
}

/* Animation for voting */
@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}

.btn-vote:active {
    animation: pulse 0.3s ease;
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
    <div class="poll-container">
            <asp:Panel ID="pnlActivePoll" runat="server" Visible="false">
                <div class="poll-question">
                    <asp:Literal ID="litQuestion" runat="server"></asp:Literal>
                </div>
                
                <asp:Panel ID="pnlVote" runat="server">
                    <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="poll-options">
                    </asp:RadioButtonList>
                    <asp:Button ID="btnVote" runat="server" Text="Vote" OnClick="btnVote_Click" />
                    <asp:Label ID="lblVoteError" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                </asp:Panel>
                
                <asp:Panel ID="pnlAlreadyVoted" runat="server" Visible="false">
                    <p>You have already voted in this poll. Thank you for your participation!</p>
                </asp:Panel>
                
                <asp:Panel ID="pnlResults" runat="server" CssClass="poll-results" Visible="false">
                    <h3>Poll Results</h3>
                    <asp:Repeater ID="rptResults" runat="server">
                        <ItemTemplate>
                            <div>
                                <strong><%# Eval("OptionText") %></strong>
                                <div class="result-bar">
                                    <div class="result-fill" style='width:<%# Eval("Percentage") %>%;'></div>
                                    <div class="result-text"><%# Eval("VoteCount") %> votes (<%# Eval("Percentage") %>%)</div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <p>Total votes: <asp:Literal ID="litTotalVotes" runat="server"></asp:Literal></p>
                </asp:Panel>
            </asp:Panel>
            
            <asp:Panel ID="pnlNoActivePoll" runat="server" Visible="false">
                <p>There is no active poll at the moment. Please check back later.</p>
            </asp:Panel>
            
            <asp:Panel ID="pnlAdmin" runat="server" Visible="false" CssClass="admin-section">
                <h3>Admin Panel</h3>
                <div>
                    <asp:Label ID="lblNewQuestion" runat="server" Text="Poll Question:" AssociatedControlID="txtNewQuestion"></asp:Label>
                    <asp:TextBox ID="txtNewQuestion" runat="server" Width="100%"></asp:TextBox>
                </div>
                <div>
                    <asp:Label ID="lblOptions" runat="server" Text="Options (one per line):"></asp:Label>
                    <asp:TextBox ID="txtOptions" runat="server" TextMode="MultiLine" Rows="5" Width="100%"></asp:TextBox>
                </div>
                <asp:Button ID="btnCreatePoll" runat="server" Text="Create New Poll" />
                <asp:Button ID="btnClosePoll" runat="server" Text="Close Current Poll" Visible="false" />
                <asp:Label ID="lblAdminMessage" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                <asp:Label ID="lblAdminSuccess" runat="server" CssClass="success-message" Visible="false"></asp:Label>
                
                <asp:Panel ID="pnlCurrentPollResults" runat="server" Visible="false" style="margin-top: 20px;">
                    <h4>Current Poll Results</h4>
                    <asp:Repeater ID="rptAdminResults" runat="server">
                        <ItemTemplate>
                            <div>
                                <strong><%# Eval("OptionText") %></strong>
                                <div class="result-bar">
                                    <div class="result-fill" style='width:<%# Eval("Percentage") %>%;'></div>
                                    <div class="result-text"><%# Eval("VoteCount") %> votes (<%# Eval("Percentage") %>%)</div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <p>Total votes: <asp:Literal ID="litAdminTotalVotes" runat="server"></asp:Literal></p>
                </asp:Panel>
            </asp:Panel>
        </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
