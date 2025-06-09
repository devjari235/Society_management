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
    public partial class User_Complaint_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {

                int noticeId;
                if (int.TryParse(Request.QueryString["id"], out noticeId))
                {
                    LoadComplaintDetails(noticeId);
                    LoadRemarks(noticeId);
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

        private void LoadRemarks(int complaintId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT r.*, a.name AS AdminName 
                        FROM tblRemarks r
                        JOIN tblAdmin a ON r.admin_id = a.admin_id
                        WHERE r.Complaint_id = @ComplaintId
                        ORDER BY r.RemarkDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ComplaintId", complaintId);

                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    rptRemarks.DataSource = dt;
                    rptRemarks.DataBind();
                }
            }
        }
        private void LoadComplaintDetails(int id)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT u.User_name,c.Complaint_type,c.Complaint_id,c.Priority,c.Status,c.Description,c.image,c.Create_date,c.Resolve_date,b.Block_name,f.Flate_no from tblComplaint c join tblUser u on c.User_id=u.User_id \r\nJOIN tblOwner o ON u.Owner_id = o.Owner_id\r\nJOIN tblBlock b ON o.Block_id = b.Block_id\r\nJOIN tblFlat f ON o.Flate_id=f.Flate_id where c.Complaint_id=@c_id and u.User_id=@id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@c_id", id);
                cmd.Parameters.AddWithValue("@id", Session["U_id"]);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lbltype.Text = dr["Complaint_type"].ToString();
                    lblDescription.Text = dr["Description"].ToString();
                    lblblock.Text = dr["Block_name"].ToString();
                    lblNo.Text = dr["Flate_no"].ToString();
                    lblBy.Text = dr["User_name"].ToString();
                    lblCDate.Text = Convert.ToDateTime(dr["Create_date"]).ToString("dd MMM yyyy");
                    if (dr["Resolve_date"] != DBNull.Value)
                    {
                        lblRDate.Text = Convert.ToDateTime(dr["Resolve_date"]).ToString("dd MMM yyyy");
                    }
                    else
                    {
                        lblRDate.Text = "Not resolved yet"; // or leave it blank: ""
                    }

                    lblStatus.Text = dr["Status"].ToString();
                    lblPriority.Text = dr["Priority"].ToString();

                    string filePath = dr["image"].ToString();
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