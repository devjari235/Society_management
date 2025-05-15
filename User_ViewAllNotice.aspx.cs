using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Reflection;
using System.Windows.Forms;

namespace Society_management
{
    public partial class User_ViewAllNotice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAllNotices();

            }
        }
        private void BindAllNotices()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Update expired statuses first
                SqlCommand updateCmd = new SqlCommand("UPDATE tblNotices SET Status='Expired' WHERE Expiry_date < GETDATE() AND Status != 'Expired'", conn);
                updateCmd.ExecuteNonQuery();

                SqlCommand cmd = new SqlCommand("SELECT n.Notice_id,n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status, n.Posted_date, u.User_name FROM tblNotices n INNER JOIN tblUser u ON n.User_id = u.User_id WHERE u.User_id=@id  ORDER BY Expiry_date DESC", conn);
                cmd.Parameters.AddWithValue("id", Session["U_id"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();
            }
        }


        protected void gvDisplay_RowCommand1(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewNotice")
            {
                int noticeId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("User_noticeDetails.aspx?id=" + noticeId);
            }
        }
    }
}