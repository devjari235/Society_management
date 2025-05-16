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
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SocietyID();
                lblTotalResidents.Text = GetTotalResident().ToString();
                lblTotalFlats.Text = GetTotalFlats().ToString();
                lblActiveComplaints.Text=GetTotalActiveComplaint().ToString();
            }

        }
        string name;
        public void SocietyID()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select Society_name from tblSociety where admin_id=@a_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@a_id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                name = reader["Society_name"].ToString();
            }
            lblAdminName.Text = name;
        }
         public int GetTotalResident()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            // string query = "SELECT COUNT(*) \r\nFROM tblBlock b \r\nJOIN tblFlat f ON b.Block_id = f.Block_id \r\nJOIN tblOwner o ON f.Flate_id = o.Flate_id AND b.Block_id = o.Block_id \r\nJOIN tblSociety s ON s.Society_id = b.Society_id \r\nWHERE s.admin_id = @id";
            string query = "SELECT COUNT(*)\r\nFROM tblBlock b\r\nJOIN tblFlat f ON b.Block_id = f.Block_id\r\nJOIN tblOwner o ON f.Flate_id = o.Flate_id AND b.Block_id = o.Block_id\r\nJOIN tblSociety s ON s.Society_id = b.Society_id\r\nJOIN tblUser u ON o.Owner_id = u.Owner_id WHERE s.admin_id = @id;\r\n";
            SqlCommand cmd=new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());

        }
        public int GetTotalFlats()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "select COUNT(*) from tblBlock b join tblFlat f on b.Block_id=f.Block_id join tblSociety s on s.Society_id=b.Society_id where admin_id=@id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());

        }
        public int GetTotalActiveComplaint()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "SELECT COUNT(*) \r\nFROM tblComplaint c\r\nJOIN tblUser u ON c.User_id = u.User_id\r\nJOIN tblOwner o ON u.Owner_id = o.Owner_id\r\nJOIN tblBlock b ON o.Block_id = b.Block_id\r\nJOIN tblSociety s ON s.Society_id = b.Society_id\r\nWHERE s.admin_id = @id\r\n";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            return Convert.ToInt32(cmd.ExecuteScalar());

        }
    }
}