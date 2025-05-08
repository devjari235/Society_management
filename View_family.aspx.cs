using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class View_family : System.Web.UI.Page
    {
        string connStr = WebConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            OwnerID();
            BindGrid();
        }

        int id;
        public void OwnerID()
        {
            SqlConnection con = new SqlConnection(connStr);
            con.Open();
            string Query = "Select Owner_id from tblUser where User_id=@u_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@u_id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                id = Convert.ToInt32(reader["Owner_id"]);
            }

        }

        public void BindGrid()
        {

            SqlConnection con = new SqlConnection(connStr);
            //string query = "select * from tblImage where A_id=@aid";
            string query = "select Member_name, Email, Phone_no, Age, Gender , Relationship from tblFamilyMember where Owner_id=@id";
            con.Open();
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", id);
            SqlDataAdapter ad = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            ad.Fill(ds);
            gvDisplay.DataSource = ds;
            gvDisplay.DataBind();
            con.Close();
        }
    }
}