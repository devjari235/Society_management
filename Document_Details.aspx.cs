using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Document_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int noticeId;
                    if (int.TryParse(Request.QueryString["id"], out noticeId))
                    {
                        LoadComplaintDetails(noticeId);
                    }
                    else
                    {
                        lblMessage.Text = "Invalid notice ID.";
                    }
                }
                else
                {
                    lblMessage.Text = "No notice selected.";
                }
            }
        }
        private void LoadComplaintDetails(int id)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT d.DocumentID,d.FilePath, d.DocumentTitle, d.DocumentType, d.Description, d.UploadDate,a.name FROM tblDocuments d JOIN tblAdmin a ON d.admin_id = a.admin_id WHERE a.admin_id = @id ORDER BY d.UploadDate DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lbltype.Text = dr["DocumentType"].ToString();
                    lblDescription.Text = dr["Description"].ToString();
                    lbltitle.Text= dr["DocumentTitle"].ToString();
                    lblDate.Text = Convert.ToDateTime(dr["UploadDate"]).ToString("dd MMM yyyy");
                    lblupload.Text = dr["name"].ToString();
                    

                    string filePath = dr["FilePath"].ToString();
                    if (!string.IsNullOrEmpty(filePath))
                    {
                        hlAttachment.NavigateUrl = filePath;
                        hlAttachment.Text = "📎 View Attachment";
                    }
                    else
                    {
                        hlAttachment.Text = "No attachment";
                    }

                    pnlNotice.Visible = true;
                }
                else
                {
                    lblMessage.Text = "Notice not found.";
                }
            }
        }
    }
}