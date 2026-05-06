using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Society_management
{
    public partial class User : System.Web.UI.MasterPage
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["U_id"] == null)
            {
                Response.Redirect("~/u_login.aspx");
                return;
            }

            Details();

            if (!IsPostBack)
            {
                IsCommitteeMember();
                visibleForCommitteeMember();
                ShowUnreadNotificationCount(); // 🔥 UPDATED
            }
        }

        // 🔥 NEW METHOD (MERGED COUNT)
        private void ShowUnreadNotificationCount()
        {
            int userId = Convert.ToInt32(Session["U_id"]);

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
                SELECT 
                    (
                        SELECT COUNT(*)
                        FROM tblRemarks r
                        INNER JOIN tblComplaint c ON r.Complaint_id = c.Complaint_id
                        WHERE c.User_id = @UserId 
                        AND r.IsSeenByUser = 0
                    )
                    +
                    (
                        SELECT COUNT(*)
                        FROM Notifications
                        WHERE User_id = @UserId
                        AND IsRead = 0
                    )";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                con.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());

                lblRemarkCount.Visible = (count > 0);
                lblRemarkCount.Text = count.ToString();
            }
        }

        // 🔥 USER DETAILS
        string name;
        string img;

        public void Details()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string Query = "SELECT User_name, Photo FROM tblUser WHERE User_id = @id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@id", Session["U_id"]);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    name = reader["User_name"].ToString();
                    img = reader["Photo"].ToString();

                    image.ImageUrl = !string.IsNullOrEmpty(img)
                        ? img
                        : "~/Profile/Default.png";
                }

                lblUserName.Text = name;
                reader.Close();
            }
        }

        // 🔥 CHECK COMMITTEE MEMBER
        public bool IsCommitteeMember()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                int userId = Convert.ToInt32(Session["U_id"]);

                string query = @"
                SELECT COUNT(*) 
                FROM tblCommitteeMember 
                WHERE User_id = @UserId 
                AND Status = 'Current' 
                AND (Designation='President' 
                     OR Designation='Vice-President' 
                     OR Designation='Secretary')";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                con.Open();
                int count = (int)cmd.ExecuteScalar();

                return count > 0;
            }
        }

        public void visibleForCommitteeMember()
        {
            if (IsCommitteeMember())
            {
                // show features if needed
            }
            else
            {
                // hide features if needed
            }
        }
    }
}