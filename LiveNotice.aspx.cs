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
    public partial class LiveNotice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindNotices();
        }
        private void BindNotices()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Step 1: Update expired notices
                string updateQuery = @"UPDATE tblNotices 
                               SET Status = 'Expired' 
                               WHERE Expiry_date < GETDATE() AND Status != 'Expired'";
                SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                updateCmd.ExecuteNonQuery();

                // Step 2: Fetch notices
                string selectQuery = @"SELECT Notice_id, Title, Description, Expiry_date, File_path, Importance, Status 
                               FROM tblNotices 
                               WHERE Expiry_date IS NULL OR Expiry_date >= GETDATE() 
                               ORDER BY Posted_date DESC";
                SqlDataAdapter da = new SqlDataAdapter(selectQuery, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptNotices.DataSource = dt;
                rptNotices.DataBind();
            }
        }


        public string GetImportanceClass(string importance)
        {
            switch (importance.ToLower())
            {
                case "important": return "badge-important";
                case "urgent": return "badge-urgent";
                default: return "badge-normal";
            }
        }

    }
}