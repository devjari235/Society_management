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
                string query = @"SELECT d.DocumentID, d.DocumentTitle, 
                               FORMAT(d.UploadDate, 'dd-MMM-yyyy') as UploadDate, 
                               a.name, d.FileName, d.StoredFileName 
                               FROM tblDocuments d 
                               JOIN tblAdmin a ON d.admin_id = a.admin_id 
                               WHERE a.admin_id = @id 
                               ORDER BY d.UploadDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    con.Open();

                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    gvDisplay.DataSource = dt;
                    gvDisplay.DataBind();
                }
            }
        }

        protected void gvDisplay_RowCommand(object sender, GridViewCommandEventArgs e)
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
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT FileName, StoredFileName FROM tblDocuments WHERE DocumentID = @DocumentID", con))
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
                                Response.TransmitFile(filePath);
                                Response.End();
                            }
                            else
                            {
                                ShowAlert("Error", "File not found on server", "error");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error", "Download failed: " + ex.Message, "error");
            }
        }

        private void DeleteDocument(int documentId)
        {
            try
            {
                string storedFileName = null;

                // First get the filename
                using (SqlConnection con = new SqlConnection(strcon))
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT StoredFileName FROM tblDocuments WHERE DocumentID = @DocumentID", con))
                {
                    cmd.Parameters.AddWithValue("@DocumentID", documentId);
                    con.Open();
                    storedFileName = cmd.ExecuteScalar() as string;
                }

                // Delete from database
                using (SqlConnection con = new SqlConnection(strcon))
                using (SqlCommand cmd = new SqlCommand(
                    "DELETE FROM tblDocuments WHERE DocumentID = @DocumentID", con))
                {
                    cmd.Parameters.AddWithValue("@DocumentID", documentId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // Delete physical file
                if (!string.IsNullOrEmpty(storedFileName))
                {
                    string filePath = Server.MapPath("~/Uploads/" + storedFileName);
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                BindDocuments();
                ShowAlert("Success", "Document deleted successfully", "success");
            }
            catch (Exception ex)
            {
                ShowAlert("Error", "Delete failed: " + ex.Message, "error");
            }
        }

        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add click event to all cells except the action buttons cell
                for (int i = 0; i < e.Row.Cells.Count - 1; i++)
                {
                    e.Row.Cells[i].Attributes["onclick"] =
                        "window.location.href='Document_Details.aspx?id=" +
                        DataBinder.Eval(e.Row.DataItem, "DocumentID") + "'";
                    e.Row.Cells[i].Style["cursor"] = "pointer";
                }

                // Hide the DocumentID column (index 0)
                e.Row.Cells[0].Style["display"] = "none";
            }
            else if (e.Row.RowType == DataControlRowType.Header)
            {
                // Hide the DocumentID header
                e.Row.Cells[0].Style["display"] = "none";
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
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"Swal.fire('{title}', '{message.Replace("'", "\\'")}', '{type}');", true);
        }
    }
}