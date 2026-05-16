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
            if (Session["A_id"] == null && Request.Cookies["AdminInfo"] != null)
            {
                string uid = Request.Cookies["AdminInfo"]["A_id"];
                if (!string.IsNullOrEmpty(uid))
                {
                    Session["A_id"] = uid;
                    Response.Redirect("AdminDashboard.aspx");
                }
            }
            if (!IsPostBack)
            {
                BindGrid();
            }
        }
        public void BindGrid()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT b.Block_name, f.Flate_id, f.Flate_no, f.Floor, 
                         f.Flat_type, f.sqft, f.Occupancy_status, f.Mentanance, o.Owner_name 
                         FROM tblBlock b 
                         JOIN tblFlat f ON b.Block_id = f.Block_id 
                         JOIN tblSociety s ON s.Society_id = b.Society_id 
                         LEFT JOIN tblOwner o ON o.Block_id = f.Block_id AND o.Flate_id = f.Flate_id 
                         WHERE s.admin_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
                    SqlDataAdapter ad = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable(); // Using DataTable is lighter than DataSet for a single grid
                    ad.Fill(dt);

                    gvDisplay.DataSource = dt;
                    gvDisplay.DataBind();

                    // Check row count from the DataTable
                    if (dt.Rows.Count > 0)
                    {
                        phDataContent.Visible = true;  // Show the White Card/Table
                        pnlEmpty.Visible = false;      // Hide the Empty State
                    }
                    else
                    {
                        phDataContent.Visible = false; // Hide the White Card/Table
                        pnlEmpty.Visible = true;       // Show the Centered Empty State
                    }
                }
            }
            // con.Close() is not needed here; 'using' handles it automatically
        }


    }
}