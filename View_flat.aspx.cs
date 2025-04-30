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
    public partial class View_flat : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }
        public void BindGrid()
        {

            SqlConnection con = new SqlConnection(strcon);
            //string query = "select * from tblImage where A_id=@aid";
            string query = "select b.Block_name,f.Flate_id, f.Flate_no, f.Floor, f.Flat_type, f.sqft, f.Occupancy_status, f.Mentanance from tblBlock b join tblFlat f on b.Block_id=f.Block_id";
            con.Open();

            SqlDataAdapter ad = new SqlDataAdapter(query, con);
            DataSet ds = new DataSet();
            ad.Fill(ds);
            gvDisplay.DataSource = ds;
            gvDisplay.DataBind();
            con.Close();
        }

        protected void btnAddFlat_Click(object sender, EventArgs e)
        {
            Response.Redirect("Flat.aspx");
        }

        protected void btnViewFlats_Click(object sender, EventArgs e)
        {
            Response.Redirect("View_flat.aspx");
        }
    }
}