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
    public partial class User_PhotoGallery : System.Web.UI.Page
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
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            DataTable dtPhotos = new DataTable();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"SELECT p.PhotoId, p.Title, p.Description, p.ImagePath, p.UploadDate, a.name 
                                   FROM SocietyPhotos p join tblAdmin a On p.admin_id=a.admin_id
                                   ORDER BY UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dtPhotos);
                    }
                }

                if (dtPhotos.Rows.Count > 0)
                {
                    rptPhotos.DataSource = dtPhotos;
                    rptPhotos.DataBind();
                    pnlPhotos.Visible = true;
                    pnlNoPhotos.Visible = false;
                }
                else
                {
                    pnlPhotos.Visible = false;
                    pnlNoPhotos.Visible = true;
                }
            }
            catch (SqlException ex)
            {
                // Log the error
                System.Diagnostics.Trace.TraceError($"Database error loading photos: {ex.Message}");
                ShowErrorMessage("Error loading photos. Please try again later.");
            }
            catch (Exception ex)
            {
                // Log general errors
                System.Diagnostics.Trace.TraceError($"Error loading photos: {ex.Message}");
                ShowErrorMessage("An unexpected error occurred. Please try again later.");
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
            pnlPhotos.Visible = false;
            pnlNoPhotos.Visible = true;
            Label lblNoPhotos = pnlNoPhotos.FindControl("lblNoPhotos") as Label;
            if (lblNoPhotos != null)
            {
                lblNoPhotos.Text = message;
            }
        }

    }
}