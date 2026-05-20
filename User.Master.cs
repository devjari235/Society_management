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
                // Added identical security query boundaries to isolate notice/event counts by society admin contexts
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
                FROM Notifications n
                WHERE n.User_id = @UserId
                AND n.IsRead = 0
                AND (
                    n.Type NOT IN ('Notice', 'Event') 
                    OR (n.Type = 'Notice' AND n.ReferenceID IN (
                        SELECT Notice_id FROM tblNotices WHERE admin_id = (
                            SELECT TOP 1 s.admin_id 
                            FROM tblUser u
                            INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id
                            INNER JOIN tblBlock b ON o.Block_id = b.Block_id
                            INNER JOIN tblSociety s ON b.Society_id = s.Society_id
                            WHERE u.User_id = @UserId
                        )
                    ))
                    OR (n.Type = 'Event' AND n.ReferenceID IN (
                        SELECT EventId FROM tblEvents WHERE admin_id = (
                            SELECT TOP 1 s.admin_id 
                            FROM tblUser u
                            INNER JOIN tblOwner o ON u.Owner_id = o.Owner_id
                            INNER JOIN tblBlock b ON o.Block_id = b.Block_id
                            INNER JOIN tblSociety s ON b.Society_id = s.Society_id
                            WHERE u.User_id = @UserId
                        )
                    ))
                )
            )";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);

                try
                {
                    con.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    lblRemarkCount.Visible = (count > 0);
                    lblRemarkCount.Text = count.ToString();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error calculating isolated master badge notifications count: {ex.Message}");
                    lblRemarkCount.Visible = false;
                }
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