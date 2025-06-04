<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="User_PhotoGallery.aspx.cs" Inherits="Society_management.User_PhotoGallery" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
         <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .gallery-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        .photo-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 16px;
            padding: 16px;
        }
        .photo-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
            transition: all 0.3s cubic-bezier(.25,.8,.25,1);
            cursor: pointer;
        }
        .photo-card:hover {
            box-shadow: 0 14px 28px rgba(0,0,0,0.12), 0 10px 10px rgba(0,0,0,0.10);
            transform: translateY(-2px);
        }
        .photo-image-container {
            width: 100%;
            height: 200px;
            overflow: hidden;
        }
        .photo-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        .photo-card:hover .photo-image {
            transform: scale(1.05);
        }
        .upload-link {
            text-align: right;
            margin-bottom: 20px;
        }
        .btn-upload {
            background-color: #4285f4;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            display: inline-block;
        }
        .btn-upload:hover {
            background-color: #3367d6;
        }
        .no-photos {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 1.2em;
            background: white;
            border-radius: 8px;
            margin: 20px;
        }

        /* Lightbox styles */
        .lightbox {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.9);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .lightbox-content {
            max-width: 90%;
            max-height: 90%;
            display: flex;
            flex-direction: column;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        .lightbox-image-container {
            max-height: 70vh;
            overflow: hidden;
        }
        .lightbox-image {
            max-width: 100%;
            max-height: 70vh;
            object-fit: contain;
            display: block;
            margin: 0 auto;
        }
        .lightbox-info {
            padding: 16px;
            background: white;
        }
        .lightbox-title {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 8px;
            color: #333;
        }
        .lightbox-description {
            color: #555;
            margin-bottom: 12px;
        }
        .lightbox-meta {
            font-size: 14px;
            color: #777;
            display: flex;
            justify-content: space-between;
        }
        .lightbox-close {
            position: absolute;
            top: 20px;
            right: 20px;
            color: white;
            font-size: 30px;
            cursor: pointer;
            z-index: 1001;
        }
        .lightbox-nav {
            position: absolute;
            top: 50%;
            width: 100%;
            display: flex;
            justify-content: space-between;
            padding: 0 20px;
            box-sizing: border-box;
            z-index: 1001;
        }
        .lightbox-nav-btn {
            color: white;
            font-size: 30px;
            cursor: pointer;
            background: rgba(0,0,0,0.5);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
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
        <div class="gallery-container">
            <asp:Panel ID="pnlPhotos" runat="server">
                <div class="photo-grid">
                    <asp:Repeater ID="rptPhotos" runat="server" OnItemDataBound="rptPhotos_ItemDataBound">
                        <ItemTemplate>
                            <div class="photo-card" 
                                data-title='<%# Eval("Title") %>'
                                data-description='<%# Eval("Description") %>'
                                data-uploader='<%# Eval("name") %>'
                                data-date='<%# Convert.ToDateTime(Eval("UploadDate")).ToString("MMM dd, yyyy") %>'
                                onclick="openLightbox(this)">
                                <div class="photo-image-container">
                                    <asp:Image ID="imgPhoto" runat="server" 
                                        ImageUrl='<%# Eval("ImagePath") %>' 
                                        CssClass="photo-image" 
                                        AlternateText='<%# Eval("Title") %>' />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>
            
            <asp:Panel ID="pnlNoPhotos" runat="server" CssClass="no-photos" Visible="false">
                <asp:Label ID="lblNoPhotos" runat="server" Text="No photos available in the gallery yet." />
            </asp:Panel>
        </div>

        <!-- Lightbox HTML -->
        <div id="lightbox" class="lightbox">
            <span class="lightbox-close" onclick="closeLightbox()">&times;</span>
            <div class="lightbox-content">
                <div class="lightbox-image-container">
                    <img id="lightbox-image" class="lightbox-image" src="" alt="">
                </div>
                <div class="lightbox-info">
                    <div id="lightbox-title" class="lightbox-title"></div>
                    <div id="lightbox-description" class="lightbox-description"></div>
                    <div class="lightbox-meta">
                        <span id="lightbox-uploader">Uploaded by: </span>
                        <span id="lightbox-date"></span>
                    </div>
                </div>
            </div>
            <div class="lightbox-nav">
                <div class="lightbox-nav-btn" onclick="navigateLightbox(-1)">❮</div>
                <div class="lightbox-nav-btn" onclick="navigateLightbox(1)">❯</div>
            </div>
        </div>
</asp:Content>
<asp:Content ID="Content7" ContentPlaceHolderID="ScriptsContent" runat="server">
      <script>
      // Array to store all gallery items for lightbox navigation
      var galleryItems = [];
      var currentIndex = 0;

      // Function to initialize gallery items
      function initGalleryItems() {
          var cards = document.querySelectorAll('.photo-card');
          galleryItems = Array.from(cards).map(function (card) {
              return {
                  image: card.querySelector('img').src,
                  title: card.getAttribute('data-title'),
                  description: card.getAttribute('data-description'),
                  uploader: card.getAttribute('data-uploader'),
                  date: card.getAttribute('data-date')
              };
          });
      }

      // Function to open lightbox
      function openLightbox(card) {
          initGalleryItems();

          currentIndex = Array.from(document.querySelectorAll('.photo-card')).indexOf(card);

          updateLightboxContent(
              card.querySelector('img').src,
              card.getAttribute('data-title'),
              card.getAttribute('data-description'),
              card.getAttribute('data-uploader'),
              card.getAttribute('data-date')
          );

          document.getElementById('lightbox').style.display = 'flex';
          document.body.style.overflow = 'hidden';
      }

      // Function to close lightbox
      function closeLightbox() {
          document.getElementById('lightbox').style.display = 'none';
          document.body.style.overflow = 'auto';
      }

      // Function to navigate between images in lightbox
      function navigateLightbox(direction) {
          currentIndex += direction;

          // Wrap around if at beginning or end
          if (currentIndex < 0) {
              currentIndex = galleryItems.length - 1;
          } else if (currentIndex >= galleryItems.length) {
              currentIndex = 0;
          }

          var item = galleryItems[currentIndex];
          updateLightboxContent(item.image, item.title, item.description, item.uploader, item.date);
      }

      // Function to update lightbox content
      function updateLightboxContent(imageSrc, title, description, uploader, date) {
          document.getElementById('lightbox-image').src = imageSrc;
          document.getElementById('lightbox-image').alt = title;
          document.getElementById('lightbox-title').textContent = title;
          document.getElementById('lightbox-description').textContent = description;
          document.getElementById('lightbox-uploader').textContent = 'Uploaded by: ' + uploader;
          document.getElementById('lightbox-date').textContent = date;
      }

      // Close lightbox when clicking outside the content
      document.getElementById('lightbox').addEventListener('click', function (e) {
          if (e.target === this) {
              closeLightbox();
          }
      });

      // Keyboard navigation
      document.addEventListener('keydown', function (e) {
          var lightbox = document.getElementById('lightbox');
          if (lightbox.style.display === 'flex') {
              if (e.key === 'Escape') {
                  closeLightbox();
              } else if (e.key === 'ArrowLeft') {
                  navigateLightbox(-1);
              } else if (e.key === 'ArrowRight') {
                  navigateLightbox(1);
              }
          }
      });
      </script>
</asp:Content>
