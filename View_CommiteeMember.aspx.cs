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
    public partial class View_CommiteeMember : System.Web.UI.Page
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
                }
            }

            if (Session["A_id"] == null)
            {
                Response.Redirect("Login.aspx");
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
                con.Open();

                // 1. Transition expired members
                string updateQuery = @"UPDATE tblCommitteeMember 
                               SET Status = 'Past' 
                               WHERE To_date < GETDATE() AND Status != 'Past'";
                new SqlCommand(updateQuery, con).ExecuteNonQuery();

                // 2. Fetch Active members
                string query = @"SELECT c.*, u.User_name 
                         FROM tblCommitteeMember c 
                         JOIN tblUser u ON u.User_id = c.User_id 
                         JOIN tblOwner o ON o.Owner_id = u.Owner_id 
                         JOIN tblblock b ON b.Block_id = o.Block_id 
                         JOIN tblSociety s ON s.Society_id = b.Society_id 
                         WHERE s.admin_id = @id 
                         AND (c.To_date IS NULL OR c.To_date >= GETDATE())
                         AND c.Status != 'Past'";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                SqlDataAdapter ad = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                ad.Fill(dt);

                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();

                // ── TOGGLE VISIBILITY LOGIC ──
                if (dt.Rows.Count > 0)
                {
                    phDataContent.Visible = true; // Show Table Card
                    pnlEmpty.Visible = false;     // Hide Empty State
                }
                else
                {
                    phDataContent.Visible = false; // Hide Table Card Completely
                    pnlEmpty.Visible = true;       // Show Centered Empty State
                }
            }
        }

        protected void gvDisplay_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Enables PostBack on row click for SelectedIndexChanged
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvDisplay, "Select$" + e.Row.RowIndex);
                e.Row.ToolTip = "Click to view committee details.";
            }
        }

        protected void gvDisplay_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedIndex = gvDisplay.SelectedIndex;
            if (selectedIndex >= 0)
            {
                // Get the Committee_id from DataKeys defined in ASPX
                string Committee_id = gvDisplay.DataKeys[selectedIndex].Value.ToString();

                // Redirect to details page
                Response.Redirect("Committee_Details.aspx?id=" + Committee_id);
            }
        }
    }
}