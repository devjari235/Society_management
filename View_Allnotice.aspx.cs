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
    public partial class View_Allnotice : System.Web.UI.Page
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

                SqlCommand cmd = new SqlCommand("SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE a.admin_id=@id  ORDER BY Expiry_date DESC", conn);
                cmd.Parameters.AddWithValue("id", Session["A_id"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAllNotices.DataSource = dt;
                rptAllNotices.DataBind();
            }
        }

    }
}