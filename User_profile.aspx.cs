using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class User_profile : System.Web.UI.Page
    {
        public static string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;


        protected void Page_Load(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["U_id"]);
            if (!IsPostBack)
            {
                BindDetails();
                bindRole();
                IsCommitteeMember(userId);
            }
            //if (Request.Form["__EVENTTARGET"] == profileImageUpload.ClientID && profileImageUpload.HasFile)
            //{
            //    UpdateProfilePicture();
            //}
            if (profileImageUpload.HasFile)
            {
                UpdateProfilePicture();
            }
        }
        string name;
        string email;
        string ph;
        string gen;
        string age;
        string marite;
        string img;

        public void BindDetails()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT User_name, Phone_no,Email,Gender,Age,Marital_Status,Photo FROM tblUser WHERE User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                name = reader["User_name"].ToString();
                email = reader["Email"].ToString();
                ph = reader["Phone_no"].ToString();
                gen = reader["Gender"].ToString();
                age = reader["Age"].ToString();
                marite = reader["Marital_Status"].ToString();
                img = reader["Photo"].ToString();

                txtname.Text = name;
                txtemail.Text = email;
                txtphone.Text = ph;
                txtAge.Text = age;
                txtmarite.Text = marite;
                txtGender.Text = gen;
                if (!string.IsNullOrEmpty(img))
                {
                    imgPhoto.ImageUrl = img;
                }
                else
                {
                    imgPhoto.ImageUrl = "~/Profile/Default.png";
                }
            }

            reader.Close();
            con.Close();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Update tblUser set User_name=@name, Email=@mail, Phone_no=@ph,Gender=@gen,Age=@age,Marital_Status=@marite where  User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@name", txtname.Text);
            cmd.Parameters.AddWithValue("@mail", txtemail.Text);
            cmd.Parameters.AddWithValue("@ph", txtphone.Text);
            cmd.Parameters.AddWithValue("@gen", txtGender.Text);
            cmd.Parameters.AddWithValue("@age", txtAge.Text);
            cmd.Parameters.AddWithValue("@marite", txtmarite.Text);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            cmd.ExecuteNonQuery();
            con.Close();
            if (IsOwner(Convert.ToInt32(Session["U_id"])))
            {
                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    string query = @"
            UPDATE O
            SET O.Owner_name = @name, 
                O.Contact_no = @ph, 
                O.Email_id = @mail
            FROM tblOwner O
            INNER JOIN tblUser U ON O.Owner_id = U.Owner_id
            WHERE U.User_id = @id";

                    using (SqlCommand cmd1 = new SqlCommand(query, conn))
                    {
                        cmd1.Parameters.AddWithValue("@name", txtname.Text);
                        cmd1.Parameters.AddWithValue("@ph", txtphone.Text);
                        cmd1.Parameters.AddWithValue("@mail", txtemail.Text);
                        cmd1.Parameters.AddWithValue("@id", Convert.ToInt32(Session["U_id"]));

                        conn.Open();
                        cmd1.ExecuteNonQuery();
                        conn.Close();
                    }
                }
            }
            else if (IsFamilyMember(Convert.ToInt32(Session["U_id"])))
            {
                using (SqlConnection con1 = new SqlConnection(strcon))
                {
                    string query = @"UPDATE f
SET f.Member_name = @name, 
    f.Phone_no = @ph, 
    f.Email = @mail, 
    f.Age = @age, 
    f.Gender = @gen
FROM tblFamilyMember f
INNER JOIN tblUser u 
    ON f.Owner_id = u.Owner_id
    AND f.Email = u.Email
    AND f.Phone_no = u.Phone_no
    AND f.Member_name = u.User_name
WHERE u.User_id = @id
";

                    using (SqlCommand cmd2 = new SqlCommand(query, con1))
                    {
                        cmd2.Parameters.AddWithValue("@name", txtname.Text);
                        cmd2.Parameters.AddWithValue("@ph", txtphone.Text);
                        cmd2.Parameters.AddWithValue("@mail", txtemail.Text);
                        cmd2.Parameters.AddWithValue("@age", Convert.ToInt32(txtAge.Text));
                        cmd2.Parameters.AddWithValue("@gen", txtGender.Text);
                        cmd2.Parameters.AddWithValue("@id", Convert.ToInt32(Session["U_id"]));

                        con1.Open();
                        cmd2.ExecuteNonQuery();
                        con1.Close();
                    }
                }
            }

            string successScript = @"
        <script>
            Swal.fire({
                icon: 'success',
                title: 'Details Updated',
                text: 'Your profile details have been successfully updated.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'User_profile.aspx';
            });
        </script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSuccess", successScript, false);
        }


        private void UpdateProfilePicture()
        {
            string filename = Path.GetFileName(profileImageUpload.FileName);
            profileImageUpload.SaveAs(Server.MapPath("~/Profile/" + filename));
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Update tblUser set Photo=@img where  User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@img", "~/Profile/" + filename);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            cmd.ExecuteNonQuery();
            con.Close();

            string successScript = @"
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Details Updated',
                    text: 'Your profile details have been successfully updated.',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                }).then(function() {
                    window.location = 'User_profile.aspx';
                });
            </script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSuccess", successScript, false);
        }
        public bool IsCommitteeMember(int userId)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT COUNT(*) FROM tblCommitteeMember WHERE User_id = @UserId AND Status = 'Current'";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        public static bool IsOwner(int userId)
        {
            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM tblUser U
                INNER JOIN tblOwner O ON U.Owner_id = O.Owner_id
                WHERE U.User_id = @UserId 
                AND O.Owner_id NOT IN (
                    SELECT F.Owner_id FROM tblFamilyMember F
                )
            ) THEN 1 ELSE 0 
        END", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                conn.Open();
                return Convert.ToBoolean(cmd.ExecuteScalar());
            }
        }

        public static bool IsFamilyMember(int userId)
        {
            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM tblUser U
                JOIN tblFamilyMember F ON U.Owner_id = F.Owner_id
                WHERE U.User_id = @UserId
            ) THEN 1 ELSE 0 
        END", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                conn.Open();
                return Convert.ToBoolean(cmd.ExecuteScalar());
            }
        }




        string Desi;
        string Role;
        public void bindRole()
        {
            int userId = Convert.ToInt32(Session["U_id"]);
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select c.Designation,c.Role from tblCommitteeMember c join tblUser u on c.User_id=u.User_id where u.User_id=@id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                Desi = reader["Designation"].ToString();
                Role = reader["Role"].ToString();
            }
            if (IsCommitteeMember(userId) == true)
            {
                txtDesi.Text = Desi;
                txtDesi.ReadOnly = true;
                txtDesi.Visible = true;
                lblDesi.Visible = true;
                txtRole.Text = Role;
                txtRole.ReadOnly = true;
                txtRole.Visible = true;
                lblRole.Visible = true;
            }
            else
            {
                txtDesi.Visible = false;
                txtRole.Visible = false;
                lblDesi.Visible = false;
                lblRole.Visible = false;
            }
        }
    }

}