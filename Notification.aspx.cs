using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Notification : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["U_id"] != null)
                {
                    int userId = Convert.ToInt32(Session["U_id"]);
                    LoadRemarksForUser(userId);
                }
                else
                {
                    // Redirect to login or show error
                    Response.Redirect("~/Login.aspx");
                }
            }
        }


        private void LoadRemarksForUser(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT r.RemarkText, r.RemarkDate, a.name AS AdminName, c.Complaint_id
                    FROM tblRemarks r
                    INNER JOIN tblComplaint c ON r.Complaint_id = c.Complaint_id
                    INNER JOIN tblAdmin a ON r.admin_id = a.admin_id
                    WHERE c.User_id = @UserId
                    ORDER BY r.RemarkDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());

                    rptRemarks.DataSource = dt;
                    rptRemarks.DataBind();
                }
            }
        }
        protected void rptRemarks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "View")
            {
                int complaintId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("User_Complaint_Details.aspx?id="+ complaintId);
            }
        }
    }
}
