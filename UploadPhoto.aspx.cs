using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class UploadPhoto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                try
                {
                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string uploadFolder = Server.MapPath("~/Uploads/Photos/");

                    // Create directory if it doesn't exist
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Generate unique filename to prevent overwrites
                    string uniqueFileName = Guid.NewGuid().ToString() + "_" + fileName;
                    string filePath = Path.Combine(uploadFolder, uniqueFileName);
                    fileUpload.SaveAs(filePath);

                    // Save to database
                    string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "INSERT INTO SocietyPhotos (Title, Description, ImagePath, admin_id) " +
                                      "VALUES (@Title, @Description, @ImagePath, @UploadedBy)";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                            cmd.Parameters.AddWithValue("@ImagePath", "~/Uploads/Photos/" + uniqueFileName);
                            cmd.Parameters.AddWithValue("@UploadedBy", Session["A_id"].ToString());

                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    ShowMessage("Photo uploaded successfully!", true);
                    ClearForm();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, false);
                }
            }
            else
            {
                ShowMessage("Please select a file to upload.", false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            pnlMessage.CssClass = isSuccess ? "message success" : "message error";
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtDescription.Text = "";
        }
    }
}
