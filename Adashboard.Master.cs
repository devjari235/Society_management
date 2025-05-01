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
    public partial class Adashboard : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ShowNotificationCount();
            }
        }

        private void ShowNotificationCount()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString))
            {
                string query = "SELECT COUNT(*) FROM tblNoticeBoard WHERE IsSeen = 0 AND Status = 'Active'";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());

                if (count > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowBadge",
                        $"document.getElementById('notificationBadge').innerText = '{count}';" +
                        "document.getElementById('notificationBadge').style.display = 'inline';", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "HideBadge",
                        "document.getElementById('notificationBadge').style.display = 'none';", true);
                }
            }
        }
    }
}