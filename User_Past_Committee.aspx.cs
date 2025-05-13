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
    public partial class User_Past_Committee : System.Web.UI.Page
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
            string userId = Session["U_id"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            string query = "SELECT c.Designation,c.Role,c.Email,c.Phone_no,c.Block_name,c.Flat_no,c.From_Date,c.To_date,c.Status,u.User_name,u.Photo from tblCommitteeMember c join tblUser u on u.User_id=c.User_id where (Status='Past')";

            using (SqlConnection con = new SqlConnection(strcon))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", userId);
                    using (SqlDataAdapter ad = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        ad.Fill(ds);

                        // Add this to debug
                        if (ds.Tables[0].Rows.Count == 0)
                        {
                            Label1.Text = "No committee member data found.";
                            Panel1.Visible = true;
                        }

                        gvDisplay.DataSource = ds;
                        gvDisplay.DataBind();
                    }
                }
            }
        }

        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Image img = (Image)e.Row.FindControl("Image1");
                DataRowView drv = (DataRowView)e.Row.DataItem;

                string photoPath = drv["Photo"]?.ToString();

                if (string.IsNullOrEmpty(photoPath))
                {
                    img.ImageUrl = "~/Profile/Default.png"; // your default image path
                }
                else
                {
                    img.ImageUrl = photoPath;
                }
            }
        }
    }
}