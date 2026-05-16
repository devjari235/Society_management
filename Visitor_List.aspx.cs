using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Visitor_List : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPendingVisitors();
            }
        }
        private void LoadPendingVisitors()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string query = @"SELECT v.VisitorID, v.Name, v.ContactNumber, v.VisitPurpose, v.CheckInTime, v.CheckOutTime , v.IsCompleted ,
                    u.User_name AS MemberName
                    FROM Visitors v
                    INNER JOIN tblUser u ON v.User_id = u.User_id
                    WHERE v.IsCompleted = 1 and v.User_id=@id";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, connection);
                cmd.Parameters.AddWithValue("id", Session["U_id"]);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                adapter.Fill(ds);

                // Control state switches based on the checked row evaluation count
                if (ds != null && ds.Tables[0].Rows.Count > 0)
                {
                    gvPendingVisitors.DataSource = ds;
                    gvPendingVisitors.DataBind();

                    pnlEmpty.Visible = false;
                    phDataContent.Visible = true;
                }
                else
                {
                    gvPendingVisitors.DataSource = null;
                    gvPendingVisitors.DataBind();

                    pnlEmpty.Visible = true;
                    phDataContent.Visible = false;
                }
            }
        }
    }
}