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
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        public void BindGrid()
        {

            SqlConnection con = new SqlConnection(strcon);
            //string query = "select * from tblImage where A_id=@aid";
            // string query = "select b.Block_name,f.Flate_no,o.Owner_name,o.Contact_no,o.Email_id,o.Emergency_Number,o.Total_member,o.Allotment_Date from tblBlock b join tblFlat f on b.Block_id=f.Block_id join tblOwner o on b.Block_id=o.Block_id on f.Flate_id=o.Flate_id join tblSociety s on s.Society_id=b.Society_id where admin_id=@id";
            string query = "SELECT c.*,u.User_name from tblCommitteeMember c join tblUser u on u.User_id=c.User_id join tblOwner o on o.Owner_id=u.Owner_id join tblblock b on  b.Block_id = o.Block_id JOIN tblSociety s ON s.Society_id = b.Society_id WHERE s.admin_id = @id AND (c.To_date IS NULL OR c.To_date >= GETDATE())";
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

        protected void gvDisplay_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewNotice")
            {
                int noticeId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("Committee_Details.aspx?id=" + noticeId);
            }
        }
    }
}