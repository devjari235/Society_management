using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class View_Document : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["A_id"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                BindDocuments();
            }
        }

        private void BindDocuments()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT d.DocumentID, d.FilePath, d.DocumentTitle, d.DocumentType, d.Description, d.UploadDate,a.name FROM tblDocuments d JOIN tblAdmin a ON d.admin_id = a.admin_id WHERE a.admin_id = @id ORDER BY d.UploadDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", Session["A_id"]);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            gvDisplay.DataSource = dt;
                            gvDisplay.DataBind();
                        }
                        else
                        {
                            dt.Rows.Add(dt.NewRow());
                            gvDisplay.DataSource = dt;
                            gvDisplay.DataBind();
                            gvDisplay.Rows[0].Cells.Clear();
                            gvDisplay.Rows[0].Cells.Add(new TableCell());
                            gvDisplay.Rows[0].Cells[0].ColumnSpan = gvDisplay.Columns.Count;
                            gvDisplay.Rows[0].Cells[0].Text = "No documents found";
                            gvDisplay.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
                        }
                    }
                }
            }
        }

        protected void gvDisplay_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Download")
            {
                int documentId = Convert.ToInt32(e.CommandArgument);
                DownloadDocument(documentId);
            }
            else if (e.CommandName == "DeleteDocument")
            {
                int documentId = Convert.ToInt32(e.CommandArgument);
                DeleteDocument(documentId);
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
                                    string script = @"
                                        <script type='text/javascript'>
                                            Swal.fire({
                                                title: 'Error!',
                                                text: 'File not found on server.',
                                                icon: 'error',
                                                confirmButtonText: 'OK'
                                            });
                                        </script>";
                                    ClientScript.RegisterStartupScript(this.GetType(), "FileNotFoundError", script);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //string script = $@"
                //    <script type='text/javascript'>
                //        Swal.fire({title: 'Error!',
                //            text: 'Error downloading document: {ex.Message}',
                //            icon: 'error',
                //            confirmButtonText: 'OK'
                //        });
                //    </script>";
                //ClientScript.RegisterStartupScript(this.GetType(), "DownloadError", script);
            }
        }

        private void DeleteDocument(int documentId)
        {
            try
            {
                //string storedFileName = "";

                // First get the filename from database
                //using (SqlConnection con = new SqlConnection(strcon))
                //{
                //    string query = "SELECT StoredFileName FROM tblDocuments WHERE DocumentID = @DocumentID";
                //    using (SqlCommand cmd = new SqlCommand(query, con))
                //    {
                //        cmd.Parameters.AddWithValue("@DocumentID", documentId);
                //        con.Open();
                //        storedFileName = cmd.ExecuteScalar()?.ToString();
                //    }
                //}

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
                //if (!string.IsNullOrEmpty(storedFileName))
                //{
                //    string filePath = Server.MapPath("~/Uploads/" + storedFileName);
                //    if (File.Exists(filePath))
                //    {
                //        File.Delete(filePath);
                //    }
                //}

                // **Crucially, rebind the GridView here to reflect the changes**
                BindDocuments();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "deleteSuccess", @"
            Swal.fire({
                title: 'Deleted!',
                text: 'Document deleted successfully.',
                icon: 'success',
                confirmButtonText: 'OK'
            });", true);
                // Optionally, show a success message
            }
            catch (Exception ex)
            {
                // Handle the error appropriately (logging, displaying a user-friendly message)
                //string script = $@"
                //    <script type='text/javascript'>
                //        Swal.fire({title: 'Error!',
                //            text: 'Error deleting document: {ex.Message}',
                //            icon: 'error',
                //            confirmButtonText: 'OK'
                //        });
                //    </script>";
                //ClientScript.RegisterStartupScript(this.GetType(), "DeleteError", script);
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

        protected void gvDisplay_PageIndexChanging1(object sender, GridViewPageEventArgs e)
        {
            gvDisplay.PageIndex = e.NewPageIndex;
            BindDocuments();
        }

        
    }
}