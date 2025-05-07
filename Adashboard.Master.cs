using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;
using System.Xml.Linq;
using System.Web.Security;

namespace Society_management
{
    public partial class Adashboard : System.Web.UI.MasterPage
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ShowNotificationCount();
                Details();
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

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        string img;

        public void Details()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT Profile_picture FROM tblAdmin WHERE admin_id = @a_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@a_id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {

                img = reader["Profile_picture"].ToString();


                if (!string.IsNullOrEmpty(img))
                {
                    image.ImageUrl = img;
                }
                else
                {
                    image.ImageUrl = "https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2023/08/tiktok-no-profile-picture.png";
                }
            }

            reader.Close();
            con.Close();
        }

    }
}