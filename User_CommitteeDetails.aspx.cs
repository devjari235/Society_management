using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class User_CommitteeDetails : System.Web.UI.Page
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

            // FIXED QUERY: Joins the current user's data chain to filter committee members belonging ONLY to the same society
            string query = @"
        SELECT 
            c.Designation, c.Role, c.Email, c.Phone_no, c.Block_name, c.Flat_no, 
            c.From_Date, c.To_date, c.Status, u.User_name, u.Photo 
        FROM tblCommitteeMember c 
        JOIN tblUser u ON u.User_id = c.User_id 
        WHERE (c.To_date IS NULL OR c.To_date >= GETDATE())
        AND c.User_id IN (
            SELECT cm.User_id 
            FROM tblCommitteeMember cm
            JOIN tblUser usr ON cm.User_id = usr.User_id
            JOIN tblOwner o ON usr.Owner_id = o.Owner_id
            JOIN tblBlock b ON o.Block_id = b.Block_id
            WHERE b.Society_id = (
                SELECT top 1 b2.Society_id 
                FROM tblUser u2
                JOIN tblOwner o2 ON u2.Owner_id = o2.Owner_id
                JOIN tblBlock b2 ON o2.Block_id = b2.Block_id
                WHERE u2.User_id = @id
            )
        )";

            using (SqlConnection con = new SqlConnection(strcon))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    // Secure parameterized mapping matching the subquery filter
                    cmd.Parameters.AddWithValue("@id", userId);

                    using (SqlDataAdapter ad = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        ad.Fill(dt);

                        // Toggle rendering components cleanly based on result set count
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            gvDisplay.DataSource = dt;
                            gvDisplay.DataBind();

                            pnlEmpty.Visible = false;
                            phDataContent.Visible = true;
                        }
                        else
                        {
                            pnlEmpty.Visible = true;
                            phDataContent.Visible = false;
                        }
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

                if (img != null && drv != null)
                {
                    string photoPath = drv["Photo"]?.ToString();

                    if (string.IsNullOrEmpty(photoPath))
                    {
                        img.ImageUrl = "~/Profile/Default.png";
                    }
                    else
                    {
                        img.ImageUrl = photoPath;
                    }
                }
            }
        }
    }
}