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
    public partial class Past_Committee : System.Web.UI.Page
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
            con.Open();
            string updateQuery = @"UPDATE tblCommitteeMember 
                               SET Status = 'Past' 
                               WHERE To_date < GETDATE() AND Status != 'Past'";
            SqlCommand updateCmd = new SqlCommand(updateQuery, con);
            updateCmd.ExecuteNonQuery();

            string query = "SELECT c.*,u.User_name from tblCommitteeMember c join tblUser u on u.User_id=c.User_id join tblOwner o on o.Owner_id=u.Owner_id join tblblock b on  b.Block_id = o.Block_id JOIN tblSociety s ON s.Society_id = b.Society_id WHERE s.admin_id = @id AND (Status='Past')";
           
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