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

                SqlCommand cmd = new SqlCommand("SELECT * FROM tblNotices WHERE Status='Expired' ORDER BY Expiry_date DESC", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptExpired.DataSource = dt;
                rptExpired.DataBind();
            }
        }

    }
}