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
    public partial class View_Owner : System.Web.UI.Page
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
                string query = "SELECT b.Block_name,f.Flate_no,o.Owner_id,o.Owner_name,o.Contact_no,o.Email_id,o.Emergency_Number, o.Total_member, o.Allotment_Date FROM tblBlock b JOIN tblFlat f ON b.Block_id = f.Block_id JOIN tblOwner o ON f.Flate_id = o.Flate_id AND b.Block_id = o.Block_id JOIN tblSociety s ON s.Society_id = b.Society_id WHERE s.admin_id = @id;";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
                    SqlDataAdapter ad = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    ad.Fill(dt);

                    gvDisplay.DataSource = dt;
                    gvDisplay.DataBind();

                    // Toggle visibility logic
                    if (dt.Rows.Count > 0)
                    {
                        phDataContent.Visible = true; // Shows the card and table
                        pnlEmpty.Visible = false;     // Hides the centered empty state
                    }
                    else
                    {
                        phDataContent.Visible = false; // Hides the whole white card
                        pnlEmpty.Visible = true;      // Shows the centered empty state
                    }
                }
            }
        }

        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvDisplay, "Select$" + e.Row.RowIndex);
                e.Row.ToolTip = "Click to select this row.";
            }
        }

        protected void gvDisplay_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedIndex = gvDisplay.SelectedIndex;
            if (selectedIndex >= 0)
            {
                // Get the Notice_id from DataKeys
                string OwnerId = gvDisplay.DataKeys[selectedIndex].Value.ToString();

                // Redirect to details page with the id
                Response.Redirect("Owner_Membr.aspx?id=" + OwnerId);
            }
        }
    }
}