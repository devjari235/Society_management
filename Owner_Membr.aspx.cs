using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;

namespace Society_management
{
    public partial class Owner_Membr : System.Web.UI.Page
    {
        string connStr = WebConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int ownerId;
                    if (int.TryParse(Request.QueryString["id"], out ownerId))
                    {
                        BindGrid(ownerId);
                    }
                   
                }
            }
        }

        public void BindGrid(int ownerId)
        {

            SqlConnection con = new SqlConnection(connStr);
            //string query = "select * from tblImage where A_id=@aid";
            string query = "select Member_name, Email, Phone_no, Age, Gender , Relationship from tblFamilyMember where Owner_id=@id";
            con.Open();
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", ownerId);
            SqlDataAdapter ad = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            ad.Fill(ds);
            gvDisplay.DataSource = ds;
            gvDisplay.DataBind();
            con.Close();
        }
    }
}