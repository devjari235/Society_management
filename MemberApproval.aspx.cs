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
    public partial class MemberApproval : System.Web.UI.Page
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
            string query = @"SELECT v.VisitorID, v.Name, v.ContactNumber, v.VisitPurpose, v.VisitDateTime, 
                            u.User_name AS MemberName
                            FROM Visitors v
                            INNER JOIN tblUser u ON v.User_id = u.User_id
                            WHERE v.IsApproved = 0";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlDataAdapter adapter = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                gvPendingVisitors.DataSource = dt;
                gvPendingVisitors.DataBind();
            }
        }

        protected void gvPendingVisitors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Approve" || e.CommandName == "Reject")
            {
                int visitorId = Convert.ToInt32(e.CommandArgument);
                bool isApproved = e.CommandName == "Approve";

                string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                string query = "UPDATE Visitors SET IsApproved = @IsApproved WHERE VisitorID = @VisitorID";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@IsApproved", isApproved);
                    command.Parameters.AddWithValue("@VisitorID", visitorId);

                    try
                    {
                        connection.Open();
                        command.ExecuteNonQuery();

                        // Redirect to the approval status page
                        Response.Redirect("VisitorApproval.aspx");
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error: " + ex.Message;
                    }
                }
            }
        }
    }
}
