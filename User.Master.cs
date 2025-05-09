using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class User : System.Web.UI.MasterPage
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            Details();
        }
        string name;
        string img;

        public void Details()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT User_name,Photo FROM tblUser WHERE User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {

                name=reader["User_name"].ToString();
                img = reader["Photo"].ToString();


                if (!string.IsNullOrEmpty(img))
                {
                    image.ImageUrl = img;
                }
                else
                {
                    image.ImageUrl = "~/Profile/Default.png";
                }
            }
            lblUserName.Text = name;
            reader.Close();
            con.Close();
        }
    }
}