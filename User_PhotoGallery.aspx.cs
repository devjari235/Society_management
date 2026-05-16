using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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
            string userId = Session["U_id"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            DataTable dtPhotos = new DataTable();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // FIXED QUERY: Scopes the society gallery uploads strictly to the current resident's society account boundaries
                    string query = @"SELECT p.PhotoId, p.Title, p.Description, p.ImagePath, p.UploadDate, a.name 
                                   FROM SocietyPhotos p 
                                   JOIN tblAdmin a ON p.admin_id = a.admin_id
                                   WHERE a.admin_id = (
                                       SELECT TOP 1 b.admin_id 
                                       FROM tblUser u
                                       JOIN tblOwner o ON u.Owner_id = o.Owner_id
                                       JOIN tblBlock b ON o.Block_id = b.Block_id
                                       WHERE u.User_id = @UserId
                                   )
                                   ORDER BY UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
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
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlPhotos.Visible = false;
                    pnlEmpty.Visible = true;
                }
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Trace.TraceError($"Database error loading photos: {ex.Message}");
                ShowErrorMessage("Error loading photos. Please try again later.");
            }
            catch (Exception ex)
            {
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
                    // Store all data securely in custom attributes for programmatic front-end Lightbox queries
                    photoCard.Attributes["data-description"] = row["Description"]?.ToString();
                    photoCard.Attributes["data-uploader"] = row["name"]?.ToString();
                    photoCard.Attributes["data-date"] = Convert.ToDateTime(row["UploadDate"]).ToString("MMM dd, yyyy");
                }

                // Set image accessibility alt text parameters
                var imgPhoto = e.Item.FindControl("imgPhoto") as Image;
                if (imgPhoto != null)
                {
                    imgPhoto.AlternateText = row["Title"]?.ToString();
                }
            }
        }

        private void ShowErrorMessage(string message)
        {
            pnlPhotos.Visible = false;
            pnlEmpty.Visible = true;

            // Optional: If you want to customize your empty-state text on runtime exception faults
            Label lblTitle = pnlEmpty.FindControl("emptyStateTitle") as Label;
            if (lblTitle != null)
            {
                lblTitle.Text = message;
            }
        }
    }
}