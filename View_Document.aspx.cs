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

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT d.DocumentID, d.DocumentTitle, d.DocumentType, 
                               CONVERT(varchar, d.UploadDate, 106) AS UploadDate, 
                               a.name, d.FileName 
                               FROM tblDocuments d
                               INNER JOIN tblAdmin a ON d.admin_id = a.admin_id
                               WHERE (d.DocumentTitle LIKE @SearchTerm OR 
                                     d.DocumentType LIKE @SearchTerm OR
                                     d.Description LIKE @SearchTerm)
                               AND d.admin_id = @id
                               ORDER BY d.UploadDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    cmd.Parameters.AddWithValue("@id", Session["A_id"]);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            gvDocuments.DataSource = dt;
                            gvDocuments.DataBind();
                        }
                        else
                        {
                            ShowAlert("No Results", "No documents found matching your search criteria", "info");
                        }
                    }
                }
            }
        }

        private void BindDocuments()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT d.DocumentID, d.DocumentTitle, d.DocumentType, 
                               CONVERT(varchar, d.UploadDate, 106) AS UploadDate, 
                               a.name, d.FileName 
                               FROM tblDocuments d
                               INNER JOIN tblAdmin a ON d.admin_id = a.admin_id
                               WHERE d.admin_id = @id
                               ORDER BY d.UploadDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", Session["A_id"]);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            gvDocuments.DataSource = dt;
                            gvDocuments.DataBind();
                        }
                        else
                        {
                            dt.Rows.Add(dt.NewRow());
                            gvDocuments.DataSource = dt;
                            gvDocuments.DataBind();
                            gvDocuments.Rows[0].Cells.Clear();
                            gvDocuments.Rows[0].Cells.Add(new TableCell());
                            gvDocuments.Rows[0].Cells[0].ColumnSpan = gvDocuments.Columns.Count;
                            gvDocuments.Rows[0].Cells[0].Text = "No documents found";
                            gvDocuments.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
                        }
                    }
                }
            }
        }

        protected void gvDocuments_RowCommand(object sender, GridViewCommandEventArgs e)
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

        protected void gvDocuments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDocuments.PageIndex = e.NewPageIndex;
            BindDocuments();
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

                                string filePath = Server.MapPath("~/Uploads/Documents/" + storedFileName);

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
                                    ShowAlert("Error", "File not found on server.", "error");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error", "Error downloading document: " + ex.Message, "error");
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
                    string filePath = Server.MapPath("~/Uploads/Documents/" + storedFileName);
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                ShowAlert("Success", "Document deleted successfully!", "success");
                BindDocuments(); // Refresh the GridView
            }
            catch (Exception ex)
            {
                ShowAlert("Error", "Error deleting document: " + ex.Message, "error");
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

        private void ShowAlert(string title, string message, string type)
        {
            string script = $@"
                <script>
                    Swal.fire({{
                        title: '{title}',
                        text: '{message}',
                        icon: '{type}',
                        confirmButtonText: 'OK'
                    }});
                </script>";

            ClientScript.RegisterStartupScript(this.GetType(), "ShowAlert", script);
        }
    }
}