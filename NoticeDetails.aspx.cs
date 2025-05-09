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
    public partial class NoticeDetails : System.Web.UI.Page
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
                        LoadNoticeDetails(noticeId);
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
        private void LoadNoticeDetails(int id)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT n.Title, n.Description, n.Expiry_date, n.File_path, 
                                    n.Importance, n.Status, n.Posted_date, a.Name 
                             FROM tblNotices n 
                             INNER JOIN tblAdmin a ON n.admin_id = a.admin_id 
                             WHERE n.Notice_id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblTitle.Text = dr["Title"].ToString();
                    lblDescription.Text = dr["Description"].ToString();
                    lblPostedBy.Text = dr["Name"].ToString();
                    lblPostedDate.Text = Convert.ToDateTime(dr["Posted_date"]).ToString("dd MMM yyyy");
                    lblExpiryDate.Text = Convert.ToDateTime(dr["Expiry_date"]).ToString("dd MMM yyyy");
                    lblStatus.Text = dr["Status"].ToString();
                    lblImportance.Text = dr["Importance"].ToString();

                    string filePath = dr["File_path"].ToString();
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