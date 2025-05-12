using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Committee_Details : System.Web.UI.Page
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
                   
                }
            }
        }

        private void LoadNoticeDetails(int id)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                //string query = @"SELECT c.Title, n.Description, n.Expiry_date, n.File_path, 
                //                    n.Importance, n.Status, n.Posted_date, a.Name 
                //             FROM tblNotices n 
                //             INNER JOIN tblAdmin a ON n.admin_id = a.admin_id 
                //             WHERE n.Notice_id = @id";
                //  string query = "SELECT c.*,u.User_name from tblCommitteeMember c join tblUser u on u.User_id=c.User_id join tblOwner o on o.Owner_id=u.Owner_id join tblblock b on  b.Block_id = o.Block_id JOIN tblSociety s ON s.Society_id = b.Society_id join tblAdmin a on s.admin_id=a.admin_id where c.Committee_id=@id";
                string query = @"SELECT 
    c.Designation,
    c.From_Date,
    c.To_date,
    c.Role,
    c.Status,
    c.Block_name,
    c.Flat_no,
    c.Email,
    c.Phone_no,
    u.User_name 
FROM tblCommitteeMember c
JOIN tblUser u ON u.User_id = c.User_id
JOIN tblOwner o ON o.Owner_id = u.Owner_id
JOIN tblBlock b ON b.Block_id = o.Block_id
JOIN tblSociety s ON s.Society_id = b.Society_id
JOIN tblAdmin a ON s.admin_id = a.admin_id
WHERE c.Committee_id = @id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblname.Text = dr["User_name"].ToString();
                    lbldes.Text = dr["Designation"].ToString();
                    lblRole.Text = dr["Role"].ToString();
                    lblEmail.Text = dr["Email"].ToString();
                    lblphone.Text = dr["Phone_no"].ToString();
                    lblblock.Text = dr["Block_name"].ToString();
                    lblNo.Text = dr["Flat_no"].ToString();
                    lblFdate.Text = Convert.ToDateTime(dr["From_Date"]).ToString("dd MMM yyyy");
                    lblTdate.Text = Convert.ToDateTime(dr["To_date"]).ToString("dd MMM yyyy");
                    lblStatus.Text = dr["Status"].ToString();
                    pnlNotice.Visible = true;
                }
            }
        }

    }
}