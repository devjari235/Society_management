using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class User : System.Web.UI.MasterPage
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            Details();
            if (!IsPostBack)
            {
                IsCommitteeMember();
                visibleForCommitteeMember();
                ShowUnreadRemarkCount();
                MarkRemarksAsSeen(Convert.ToInt32(Session["U_id"]));
            }
        }

        private void MarkRemarksAsSeen(int userId)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"UPDATE r
                         SET IsSeenByUser = 1
                         FROM tblRemarks r
                         INNER JOIN tblComplaint c ON r.Complaint_id = c.Complaint_id
                         WHERE c.User_id = @UserID AND r.IsSeenByUser = 0";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void ShowUnreadRemarkCount()
        {
            int userId = Convert.ToInt32(Session["User_id"]); // Ensure this session is set at login

            string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
            SELECT COUNT(*) FROM tblRemarks r
            INNER JOIN tblComplaint c ON r.Complaint_id = c.Complaint_id
            WHERE r.IsSeenByUser = 0 AND c.User_id = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", Session["U_id"].ToString());
                con.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());

                lblRemarkCount.Visible = (count > 0);
                lblRemarkCount.Text = count.ToString();
            }
        }

        string name;
        string img;

        public void Details()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT User_name,Photo FROM tblUser WHERE User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {

                name=reader["User_name"].ToString();
                img = reader["Photo"].ToString();


                if (!string.IsNullOrEmpty(img))
                {
                    image.ImageUrl = img;
                }
                else
                {
                    image.ImageUrl = "~/Profile/Default.png";
                }
            }
            lblUserName.Text = name;
            reader.Close();
            con.Close();
        }
        public bool IsCommitteeMember()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                int userId = Convert.ToInt32(Session["U_id"]);
                string query = "SELECT COUNT(*) FROM tblCommitteeMember WHERE User_id = @UserId AND Status = 'Current' AND (Designation='President' or Designation='Vice-President' or Designation='Secretary')";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
        public void visibleForCommitteeMember()
        {
            if (IsCommitteeMember()==true) 
            {
             //  liNoticeBoard.Visible = true;
            }
            else
            {
               // liNoticeBoard.Visible = false;
            }
        }

    }
}