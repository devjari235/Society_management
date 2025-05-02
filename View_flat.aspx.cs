using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Collections;

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
            string query = "SELECT b.Block_name, f.Flate_id, f.Flate_no, f.Floor, f.Flat_type, f.sqft, f.Occupancy_status, f.Mentanance, o.Owner_name FROM tblBlock b JOIN tblFlat f ON b.Block_id = f.Block_id JOIN  tblSociety s ON s.Society_id = b.Society_id LEFT JOIN  tblOwner o ON o.Block_id = f.Block_id AND o.Flate_id = f.Flate_id WHERE s.admin_id = @id";
            con.Open();
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            SqlDataAdapter ad = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            ad.Fill(ds);
            gvDisplay.DataSource = ds;
            gvDisplay.DataBind();
            con.Close();
        }

        
    }
}