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
                            WHERE v.IsApproved = 0 and v.User_id=@id";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand cmd= new SqlCommand(query, connection);
                cmd.Parameters.AddWithValue("id", Session["U_id"]);
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
               DataSet ds = new DataSet();
                adapter.Fill(ds);
                if (ds.Tables[0].Rows.Count == 0)
                {
                    Label1.Text = "You have no visitors at the moment.";
                    Panel1.Visible = true;
                }
                gvPendingVisitors.DataSource = ds;
                gvPendingVisitors.DataBind();
            }
        }

        protected void gvPendingVisitors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Approve" || e.CommandName == "Reject")
            {
                int visitorId = Convert.ToInt32(e.CommandArgument);
                bool isApproved = e.CommandName == "Approve";
                string resultMsg = isApproved ? "Visitor approved successfully!" : "Visitor rejected.";

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

                        // Inject toast script
                        string script = $"showToast('{resultMsg}', {isApproved.ToString().ToLower()});";
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowToast", script, true);

                        // Reload visitors
                        LoadPendingVisitors();
                    }
                    catch (Exception ex)
                    {
                        string errorScript = $"showToast('Error: {ex.Message}', false);";
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowErrorToast", errorScript, true);
                    }
                }
            }
        }
    }
}
