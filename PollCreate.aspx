<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="PollCreate.aspx.cs" Inherits="Society_management.PollCreate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .poll-container {
            max-width: 700px;
            margin: 30px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .option-group {
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        
        .option-group:last-child {
            margin-bottom: 0;
        }
        
        .add-option-btn {
            margin-top: 10px;
        }
        
        .remove-option {
            cursor: pointer;
            color: #dc3545;
            font-size: 1.2rem;
            line-height: 1;
            padding-left: 10px;
        }
        
        .remove-option:hover {
            color: #bb2d3b;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>    
    <script>
        $(document).ready(function () {
            // Counter for new options
            let optionCount = 2;
            
            // Add new option field
            $('#addOptionBtn').click(function () {
                optionCount++;
                const newOption = `
                <div class="input-group option-group mb-2">
                    <input type="text" class="form-control option-input" placeholder="Option ${optionCount}">
                    <span class="input-group-text remove-option" onclick="removeOption(this)">×</span>
                </div>
            `;

               
                $('#optionsContainer').append(newOption);
            });
            
            // Before form submission, collect all options
            $('form').submit(function () {
                const options = [];
                $('.option-input').each(function () {
                    if ($(this).val().trim() !== '') {
                        options.push($(this).val().trim());
                    }
                });
                $('#<%= hdnOptions.ClientID %>').val(options.join('|||'));
            });
        });
        
        // Remove option
        function removeOption(element) {
            if ($('.option-group').length > 2) {
                $(element).closest('.option-group').remove();
                
                // Renumber remaining options
                $('.option-group').each(function(index) {
                    $(this).find('.option-input').attr('placeholder', `Option ${index + 1}`);
                });
            } else {
                alert('A poll must have at least two options.');
            }
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <a href="Poll_Result.aspx" class="dashboard-btn btn-Dashboard">
    <i class="fas fa-arrow-left"></i>Poll Result
</a>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
            <div class="container">
            <div class="poll-container bg-white">
                <h2 class="mb-4">Create New Poll</h2>
                
                <asp:Panel ID="pnlAdmin" runat="server">
                    <!-- Poll Question -->
                    <div class="mb-3">
                        <label for="txtNewQuestion" class="form-label fw-bold">Poll Question</label>
                        <asp:TextBox ID="txtNewQuestion" runat="server" CssClass="form-control" placeholder="Enter your poll question"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtExpireDate" class="form-label fw-bold">Expire Date</label>
                        <asp:TextBox ID="txtExpireDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                    <!-- Poll Options -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Poll Options</label>
                        <div id="optionsContainer">
                            <!-- Option 1 -->
                            <div class="input-group option-group mb-2">
                                <input type="text" class="form-control option-input" placeholder="Option 1" runat="server" id="option1">
                                <span class="input-group-text remove-option" onclick="removeOption(this)">×</span>
                            </div>
                            
                            <!-- Option 2 -->
                            <div class="input-group option-group mb-2">
                                <input type="text" class="form-control option-input" placeholder="Option 2" runat="server" id="option2">
                                <span class="input-group-text remove-option" onclick="removeOption(this)">×</span>
                            </div>
                        </div>
                        
                        <button type="button" class="btn btn-outline-primary add-option-btn" id="addOptionBtn">
                            <i class="bi bi-plus"></i> Add Another Option
                        </button>
                    </div>
                    
                    <!-- Hidden field to store options -->
                    <asp:HiddenField ID="hdnOptions" runat="server" />
                    
                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-between mt-4">
                        <asp:Button ID="btnCreatePoll" runat="server" Text="Create Poll" 
                            CssClass="btn btn-primary px-4" OnClick="btnCreatePoll_Click" />
                        <asp:Button ID="btnClosePoll" runat="server" Text="Close Current Poll" 
                            CssClass="btn btn-danger px-4" Visible="false" />
                    </div>
                    
                    <!-- Messages -->
                    <div class="mt-3">
                        <asp:Label ID="lblAdminMessage" runat="server" CssClass="alert alert-danger d-none" Visible="false"></asp:Label>
                        <asp:Label ID="lblAdminSuccess" runat="server" CssClass="alert alert-success d-none" Visible="false"></asp:Label>
                    </div>
                </asp:Panel>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>
