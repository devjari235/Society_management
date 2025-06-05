<%@ Page Title="" Language="C#" MasterPageFile="~/Adashboard.Master" AutoEventWireup="true" CodeBehind="UploadPhoto.aspx.cs" Inherits="Society_management.UploadPhoto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --success-color: #2ecc71;
            --error-color: #e74c3c;
            --light-gray: #f5f5f5;
            --medium-gray: #e0e0e0;
            --dark-gray: #333;
            --text-color: #444;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9;
            color: var(--text-color);
            margin: 0;
            padding: 0;
        }

        .form-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: var(--box-shadow);
        }

        h2 {
            color: var(--primary-color);
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark-gray);
        }

        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--medium-gray);
            border-radius: 6px;
            font-size: 16px;
            transition: var(--transition);
        }

        .form-group input[type="text"]:focus,
        .form-group textarea:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .btn-submit {
            background-color: var(--primary-color);
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            width: 100%;
            transition: var(--transition);
        }

        .btn-submit:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
        }

        .message {
            margin-top: 20px;
            padding: 15px;
            border-radius: 6px;
            text-align: center;
        }

        .success {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success-color);
            border: 1px solid var(--success-color);
        }

        .error {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--error-color);
            border: 1px solid var(--error-color);
        }

        .file-upload-wrapper {
            position: relative;
            margin-bottom: 20px;
        }

        .file-upload-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 30px;
            border: 2px dashed var(--medium-gray);
            border-radius: 6px;
            background-color: var(--light-gray);
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
            
        }

        .file-upload-label:hover {
            border-color: var(--primary-color);
            background-color: rgba(52, 152, 219, 0.05);
        }

        .file-upload-label i {
            font-size: 24px;
            color: var(--primary-color);
        }

        .file-upload-input {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 80%;
            cursor: pointer;
        }

        .navigation-links {
            margin-top: 25px;
            text-align: center;
        }

        .navigation-links a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .navigation-links a:hover {
            color: var(--secondary-color);
            text-decoration: underline;
        }

        .highlight {
            border-color: var(--primary-color) !important;
            background-color: rgba(52, 152, 219, 0.1) !important;
        }

        .file-upload-label.highlight i {
            color: var(--secondary-color);
        }
                /* Page Title Buttons Container */
        .page-title-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
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
            <a href="PhotoGallery.aspx" class="dashboard-btn btn-Dashboard">
                <i class="fas fa-arrow-left"></i>Back to Images
            </a>        
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-container">
            <h2>Upload New Photo</h2>

            <div class="form-group">
                <label for="txtTitle">Title:</label>
                <asp:TextBox ID="txtTitle" runat="server" AutoCompleteType="Disabled" ></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtDescription">Description:</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Select Image:</label>
                <div class="file-upload-wrapper">
                    <label class="file-upload-label" for="<%= fileUpload.ClientID %>">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <span id="upload-text">Click to browse or drag & drop your photo</span>
                    </label>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="file-upload-input" accept=".jpg,.jpeg,.png,.gif" />
                </div>
            </div>

            <asp:Button ID="btnUpload" runat="server" Text="Upload Photo" CssClass="btn-submit" OnClick="btnUpload_Click" />

            <asp:Panel ID="pnlMessage" runat="server" CssClass="message" Visible="false">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>
        </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ScriptsContent" runat="server">
     <script type="text/javascript">
         document.getElementById('<%= fileUpload.ClientID %>').addEventListener('change', function () {
        var uploadText = document.getElementById('upload-text');

        if (this.files.length > 0) {
            var fileName = this.files[0].name;
            uploadText.textContent = 'File selected: ' + fileName;
        } else {
            uploadText.textContent = 'Click to browse or drag & drop your photo';
        }
    });

    // Drag and drop functionality
    var dropArea = document.querySelector('.file-upload-label');

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropArea.addEventListener(eventName, preventDefaults, false);
    });

    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    ['dragenter', 'dragover'].forEach(eventName => {
        dropArea.addEventListener(eventName, highlight, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        dropArea.addEventListener(eventName, unhighlight, false);
    });

    function highlight() {
        dropArea.classList.add('highlight');
    }

    function unhighlight() {
        dropArea.classList.remove('highlight');
    }

    dropArea.addEventListener('drop', handleDrop, false);

    function handleDrop(e) {
        var dt = e.dataTransfer;
        var files = dt.files;
        var fileInput = document.getElementById('<%= fileUpload.ClientID %>');

             if (files.length > 0) {
                 fileInput.files = files;
                 var event = new Event('change');
                 fileInput.dispatchEvent(event);
             }
         }
     </script>
</asp:Content>
