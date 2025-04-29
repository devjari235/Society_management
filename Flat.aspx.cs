using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace Society_management
{
    public partial class Flat : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            BindBlockName();
        }
        public void BindBlockName()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select * from tblBlock where Society_id=1 Order by Block_name";
            SqlDataAdapter sda = new SqlDataAdapter(Query, con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            ddlBlock.DataSource = dt;
            ddlBlock.DataBind();
            ddlBlock.DataTextField = "Block_name";
            ddlBlock.DataValueField = "Block_id";
            ddlBlock.DataBind();
            con.Close();
            ddlBlock.Items.Insert(0, new ListItem("-- Select Society Name --"));
        }
    }
}