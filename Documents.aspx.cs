using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Documents : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && fileUpload.HasFile)
            {
                try
                {
                    string documentType = ddlDocumentType.SelectedValue;
                    string title = txtDocumentTitle.Text.Trim();
                    string description = txtDescription.Text.Trim();
                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string fileExtension = Path.GetExtension(fileName).ToLower();
                    int fileSize = fileUpload.PostedFile.ContentLength;

                    // Validate file extension
                    string[] allowedExtensions = { ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".jpg", ".jpeg", ".png" };
                    if (Array.IndexOf(allowedExtensions, fileExtension) == -1)
                    {
                        cvFileUpload.ErrorMessage = "Invalid file format. Only PDF, DOC, XLS, JPG, PNG are allowed.";
                        cvFileUpload.IsValid = false;
                        return;
                    }

                    // Create upload directory if it doesn't exist
                    string uploadFolder = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Generate unique filename
                    string uniqueFileName = Guid.NewGuid().ToString() + fileExtension;
                    string filePath = Path.Combine(uploadFolder, uniqueFileName);

                    // Save file to server
                    fileUpload.SaveAs(filePath);

                    // Insert document info into database
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        string query = @"INSERT INTO tblDocuments 
                                        (DocumentTitle, DocumentType, Description, FileName, 
                                         StoredFileName, FilePath, FileSize, admin_id, UploadDate)
                                        VALUES 
                                        (@Title, @Type, @Description, @FileName, 
                                         @StoredFileName, @FilePath, @FileSize, @admin_id, GETDATE())";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@Type", documentType);
                            cmd.Parameters.AddWithValue("@Description",
                                string.IsNullOrEmpty(description) ? DBNull.Value : (object)description);
                            cmd.Parameters.AddWithValue("@FileName", fileName);
                            cmd.Parameters.AddWithValue("@StoredFileName", uniqueFileName);
                            cmd.Parameters.AddWithValue("@FilePath", "~/Uploads/" + uniqueFileName);
                            cmd.Parameters.AddWithValue("@FileSize", fileSize);
                            cmd.Parameters.AddWithValue("@admin_id", Convert.ToInt32(Session["A_id"]));

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Document Add successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'Documents.aspx';
            });";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                    ClearForm();
                }
                catch (Exception ex)
                {
                    ShowErrorMessage("Error uploading document: " + ex.Message);
                }
            }
        }

        protected void ValidateFileUpload(object source, ServerValidateEventArgs args)
        {
            if (fileUpload.HasFile)
            {
                args.IsValid = fileUpload.PostedFile.ContentLength <= 5242880; // 5MB
            }
        }

        protected void gvDocuments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Download")
            {
                DownloadDocument(Convert.ToInt32(e.CommandArgument));
            }
            else if (e.CommandName == "DeleteDocument")
            {
                DeleteDocument(Convert.ToInt32(e.CommandArgument));
            }
        }

        private void DownloadDocument(int documentId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT FileName, StoredFileName FROM tblDocuments WHERE DocumentID = @DocumentID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@DocumentID", documentId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string fileName = reader["FileName"].ToString();
                                string storedFileName = reader["StoredFileName"].ToString();

                                string filePath = Server.MapPath("~/Uploads/" + storedFileName);

                                if (File.Exists(filePath))
                                {
                                    Response.Clear();
                                    Response.ContentType = GetContentType(Path.GetExtension(fileName));
                                    Response.AddHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
                                    Response.WriteFile(filePath);
                                    Response.End();
                                }
                                else
                                {
                                    ShowErrorMessage("File not found on server.");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error downloading document: " + ex.Message);
            }
        }

        private string GetContentType(string fileExtension)
        {
            switch (fileExtension.ToLower())
            {
                case ".pdf": return "application/pdf";
                case ".doc": return "application/msword";
                case ".docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                case ".xls": return "application/vnd.ms-excel";
                case ".xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                case ".jpg":
                case ".jpeg": return "image/jpeg";
                case ".png": return "image/png";
                default: return "application/octet-stream";
            }
        }

        private void DeleteDocument(int documentId)
        {
            try
            {
                string storedFileName = "";

                // First get the filename from database
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT StoredFileName FROM tblDocuments WHERE DocumentID = @DocumentID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@DocumentID", documentId);
                        con.Open();
                        storedFileName = cmd.ExecuteScalar()?.ToString();
                    }
                }

                // Delete from database
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "DELETE FROM tblDocuments WHERE DocumentID = @DocumentID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@DocumentID", documentId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Delete file from server
                if (!string.IsNullOrEmpty(storedFileName))
                {
                    string filePath = Server.MapPath("~/Uploads/" + storedFileName);
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                ShowSuccessMessage("Document deleted successfully!");
            
            }
            catch (Exception ex)
            {
                ShowErrorMessage("Error deleting document: " + ex.Message);
            }
        }

       

        private void ClearForm()
        {
            ddlDocumentType.SelectedIndex = 0;
            txtDocumentTitle.Text = "";
            txtDescription.Text = "";
            fileUpload.Dispose();
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }


    }
}