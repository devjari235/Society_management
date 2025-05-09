using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class ExpireNotice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindExpiredNotices();
            }

        }

        private void BindExpiredNotices()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Update expired statuses
                SqlCommand updateCmd = new SqlCommand("UPDATE tblNotices SET Status='Expired' WHERE Expiry_date < GETDATE() AND Status != 'Expired'", conn);
                updateCmd.ExecuteNonQuery();

                SqlCommand cmd = new SqlCommand("SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE a.admin_id=@id AND Status='Expired' ORDER BY Expiry_date DESC", conn);
                cmd.Parameters.AddWithValue("id", Session["A_id"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();
            }
        }

        protected void gvDisplay_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewNotice")
            {
                int noticeId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("Admin_noticeDetails.aspx?id=" + noticeId);
            }
        }
    }
}