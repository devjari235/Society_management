<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="PollCreate.aspx.cs" Inherits="Society_management.PollCreate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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

        .validation-error {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 3px;
            display: block;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .validation-error::before {
            content: "⚠ ";
            font-size: 0.85rem;
            margin-right: 4px;
        }

        .is-invalid {
            border-color: #dc3545 !important;
        }
        
        /* Button Group Container */
        .action-button-group {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            width: 100%;
        }

        /* Base Button Styles */
        .btn-register-notice{
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            text-decoration: none;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* Register Button */
        .btn-register-notice {
            background: linear-gradient(135deg, #7f8c8d 0%, #57606f 100%);
            color: white;
        }

        .btn-register-notice:hover {
            background-color: #2980b9;
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            text-decoration:none;
            color: white;
        }

        /* Icons */
        .btn-register-notice i{
            margin-right: 10px;
            font-size: 18px;
        }

        /* Active State */
        .btn-register-notice:active{
            transform: scale(0.98);
        }

        /* Focus State */
        .btn-register-notice:focus{
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.5);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .action-button-group {
                flex-direction: column;
                align-items: flex-end;
                gap: 10px;
            }
            
            .btn-register-notice{
                width: 100%;
                max-width: 300px;
                padding: 15px 20px;
                font-size: 18px;
                text-align: center;
            }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>    
    <script>
        $(document).ready(function () {
            // Counter for tracking total inputs safely
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
                updateHiddenOptions();
            });

            // Function to compile all valid data into the hidden element before postback 
            function updateHiddenOptions() {
                const options = [];
                $('.option-input').each(function () {
                    if ($(this).val().trim() !== '') {
                        options.push($(this).val().trim());
                    }
                });
                $('#<%= hdnOptions.ClientID %>').val(options.join('|||'));
            }

            // Real-time tracking listeners
            $(document).on('input', '.option-input', function () {
                updateHiddenOptions();
            });

            // Enforce update directly during submit trigger element click
            $('#<%= btnCreatePoll.ClientID %>').click(function() {
                updateHiddenOptions();
            });
        });
        
        // Remove option
        function removeOption(element) {
            if ($('.option-group').length > 2) {
                $(element).closest('.option-group').remove();
                
                // Renumber remaining options sequentially
                $('.option-group').each(function(index) {
                    $(this).find('.option-input').attr('placeholder', `Option ${index + 1}`);
                });

                // Pull value collection logic to verify accurate sync count matches cleanly
                const options = [];
                $('.option-input').each(function () {
                    if ($(this).val().trim() !== '') {
                        options.push($(this).val().trim());
                    }
                });
                $('#<%= hdnOptions.ClientID %>').val(options.join('|||'));
            } else {
                alert('A poll must have at least two options.');
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BreadcrumbContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitleContent" runat="server">
    <div class="action-button-group">
        <a href="Poll_Result.aspx" class="btn-register-notice">
            <i class="fas fa-arrow-left"></i>Poll Result
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="poll-container bg-white">
            <h2 class="mb-4">Create New Poll</h2>
            
            <asp:Panel ID="pnlAdmin" runat="server">
                <div class="mb-3">
                    <label for="txtNewQuestion" class="form-label fw-bold">Poll Question</label>
                    <asp:TextBox ID="txtNewQuestion" runat="server" CssClass="form-control" placeholder="Enter your poll question"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvQuestion" runat="server" ControlToValidate="txtNewQuestion"
                        ErrorMessage="Poll question is required."
                        CssClass="validation-error" Display="Dynamic" SetFocusOnError="True" />
                </div>

                <div class="mb-3">
                    <label for="txtExpireDate" class="form-label fw-bold">Expire Date</label>
                    <asp:TextBox ID="txtExpireDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvExpireDate" runat="server" ControlToValidate="txtExpireDate"
                        ErrorMessage="Expire date is required."
                        CssClass="validation-error" Display="Dynamic" SetFocusOnError="True" />
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Poll Options</label>
                    <div id="optionsContainer">
                        <div class="input-group option-group mb-2">
                            <input type="text" class="form-control option-input" placeholder="Option 1" />
                            <span class="input-group-text remove-option" onclick="removeOption(this)">×</span>
                        </div>
                        
                        <div class="input-group option-group mb-2">
                            <input type="text" class="form-control option-input" placeholder="Option 2" />
                            <span class="input-group-text remove-option" onclick="removeOption(this)">×</span>
                        </div>
                    </div>

                    <asp:CustomValidator ID="cvOptions" runat="server" 
                        ErrorMessage="At least two options are required."
                        CssClass="validation-error" Display="Dynamic" 
                        OnServerValidate="cvOptions_ServerValidate" />
                    
                    <button type="button" class="btn btn-outline-primary add-option-btn" id="addOptionBtn">
                        <i class="bi bi-plus"></i> Add Another Option
                    </button>
                </div>
                
                <asp:HiddenField ID="hdnOptions" runat="server" />

                <div class="d-flex justify-content-between mt-4">
                    <asp:Button ID="btnCreatePoll" runat="server" Text="Create Poll" 
                        CssClass="btn btn-primary px-4" OnClick="btnCreatePoll_Click" />
                    <asp:Button ID="btnClosePoll" runat="server" Text="Close Current Poll" 
                        CssClass="btn btn-danger px-4" Visible="false" />
                </div>

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