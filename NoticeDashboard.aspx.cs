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
    public partial class NoticeDashboard : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            lblTotalNotice.Text=GetTotalNotice().ToString();
            lblTotalLive.Text=GetTotalLiveNotice().ToString();
            lblTotalExpire.Text=GetTotalExpireNotice().ToString();
        }
        public int GetTotalNotice()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "SELECT COUNT(*) FROM tblNotices where admin_id=@id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
        public int GetTotalLiveNotice()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "SELECT COUNT(*) FROM tblNotices WHERE admin_id = @id AND Status = 'Live'";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
        public int GetTotalExpireNotice()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "SELECT COUNT(*) FROM tblNotices WHERE admin_id = @id AND Status = 'Expired'";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());
        }
    }
}