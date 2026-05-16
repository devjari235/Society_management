using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class PhotoGallery : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPhotos();
                
            }
        }

        private void LoadPhotos()
        {
            if (Session["A_id"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int currentAdminId = Convert.ToInt32(Session["A_id"]);
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            DataTable dtPhotos = new DataTable();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT p.PhotoId, p.Title, p.Description, p.ImagePath, p.UploadDate, a.name 
                         FROM SocietyPhotos p 
                         JOIN tblAdmin a ON p.admin_id = a.admin_id
                         WHERE p.admin_id = @AdminId
                         ORDER BY p.UploadDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AdminId", currentAdminId);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dtPhotos);
                }
            }

            // ── TOGGLE VISIBILITY LOGIC ──
            if (dtPhotos.Rows.Count > 0)
            {
                rptPhotos.DataSource = dtPhotos;
                rptPhotos.DataBind();
                phDataContent.Visible = true;  // Show the gallery card
                pnlNoPhotos.Visible = false;   // Hide empty state
            }
            else
            {
                phDataContent.Visible = false; // Hide gallery card entirely
                pnlNoPhotos.Visible = true;    // Show centered empty state
            }
        }
        protected void rptPhotos_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                var photoCard = e.Item.FindControl("photoCard") as System.Web.UI.HtmlControls.HtmlGenericControl;

                if (photoCard != null)
                {
                    // Store all data in attributes for the lightbox
                    photoCard.Attributes["data-description"] = row["Description"].ToString();
                    photoCard.Attributes["data-uploader"] = row["name"].ToString();
                    photoCard.Attributes["data-date"] = Convert.ToDateTime(row["UploadDate"]).ToString("MMM dd, yyyy");
                }

                // Set image alt text (title)
                var imgPhoto = e.Item.FindControl("imgPhoto") as Image;
                if (imgPhoto != null)
                {
                    imgPhoto.AlternateText = row["Title"].ToString();
                }
            }
        }

        private void ShowErrorMessage(string message)
        {
            pnlNoPhotos.Visible = false;
            pnlNoPhotos.Visible = true;
            Label lblNoPhotos = pnlNoPhotos.FindControl("lblNoPhotos") as Label;
            if (lblNoPhotos != null)
            {
                lblNoPhotos.Text = message;
            }
        }

    }
}