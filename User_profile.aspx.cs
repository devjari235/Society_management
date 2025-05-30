using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace Society_management
{
    public partial class User_profile : System.Web.UI.Page
    {
        public static string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["U_id"] == null)
            {
                Response.Redirect("U_login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["U_id"]);
            if (!IsPostBack)
            {
                int id = GetMemberID(userId);
                ViewState["memberId"] = id; 
                BindDetails();
                bindRole();
                IsCommitteeMember(userId);
            }

            if (profileImageUpload.HasFile)
            {
                UpdateProfilePicture();
            }
        }

        public int GetMemberID(int userId)
        {
            int memberId = -1;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string query = @"SELECT TOP 1 fm.Member_id 
                         FROM tblFamilyMember fm 
                         JOIN tblUser u ON u.Owner_id = fm.Owner_id 
                         WHERE u.User_id = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        memberId = Convert.ToInt32(reader["Member_id"]);
                    }
                }
            }

            return memberId;
        }



        string name, email, ph, gen, age, marite, img;

        public void BindDetails()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = "SELECT User_name, Phone_no, Email, Gender, Age, Marital_Status, Photo FROM tblUser WHERE User_id = @id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
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

                        imgPhoto.ImageUrl = !string.IsNullOrEmpty(img) ? img : "~/Profile/Default.png";
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // First update the user table
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = @"UPDATE tblUser 
                                SET User_name=@name, Email=@mail, Phone_no=@ph,
                                    Gender=@gen, Age=@age, Marital_Status=@marite 
                                WHERE User_id = @id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@name", txtname.Text);
                cmd.Parameters.AddWithValue("@mail", txtemail.Text);
                cmd.Parameters.AddWithValue("@ph", txtphone.Text);
                cmd.Parameters.AddWithValue("@gen", txtGender.Text);
                cmd.Parameters.AddWithValue("@age", txtAge.Text);
                cmd.Parameters.AddWithValue("@marite", txtmarite.Text);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                cmd.ExecuteNonQuery();
            }

            int userId = Convert.ToInt32(Session["U_id"]);

            // Update owner table if user is an owner
            if (IsOwner(userId))
            {
                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    string query = @"UPDATE O
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
                        cmd1.Parameters.AddWithValue("@id", userId);

                        conn.Open();
                        cmd1.ExecuteNonQuery();
                    }
                }
            }

            // Update family member table if user is a family member
            if (IsFamilyMember(userId))
            {
                int id = (int)ViewState["memberId"];
                using (SqlConnection con1 = new SqlConnection(strcon))
                {
                    string query = @"UPDATE tblFamilyMember
                                    SET Member_name = @name, 
                                        Phone_no = @ph, 
                                        Email = @mail, 
                                        Age = @age, 
                                        Gender = @gen
                                    WHERE Member_id = @id";

                    using (SqlCommand cmd2 = new SqlCommand(query, con1))
                    {
                        cmd2.Parameters.AddWithValue("@name", txtname.Text);
                        cmd2.Parameters.AddWithValue("@ph", txtphone.Text);
                        cmd2.Parameters.AddWithValue("@mail", txtemail.Text);
                        cmd2.Parameters.AddWithValue("@age", Convert.ToInt32(txtAge.Text));
                        cmd2.Parameters.AddWithValue("@gen", txtGender.Text);
                        cmd2.Parameters.AddWithValue("@id", id);

                        con1.Open();
                        cmd2.ExecuteNonQuery();
                    }
                }
            }

            // Show success message
            ShowSuccessMessage("Details Updated", "Your profile details have been successfully updated.");
        }

        private void UpdateProfilePicture()
        {
            string filename = Path.GetFileName(profileImageUpload.FileName);
            string filepath = "~/Profile/" + filename;
            profileImageUpload.SaveAs(Server.MapPath(filepath));

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = "UPDATE tblUser SET Photo=@img WHERE User_id = @id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@img", filepath);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                cmd.ExecuteNonQuery();
            }

            ShowSuccessMessage("Profile Picture Updated", "Your profile picture has been successfully updated.");
        }

        private void ShowSuccessMessage(string title, string text)
        {
            string successScript = $@"
                <script>
                    Swal.fire({{
                        icon: 'success',
                        title: '{title}',
                        text: '{text}',
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }}).then(function() {{
                        window.location = 'User_profile.aspx';
                    }});
                </script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSuccess", successScript, false);
        }

        public bool IsCommitteeMember(int userId)
        {
            using (SqlConnection conn = new SqlConnection(strcon))
            {
                string query = "SELECT COUNT(*) FROM tblCommitteeMember WHERE User_id = @User_id AND Status = 'Active'";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@User_id", userId);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        public bool IsOwner(int userId)
        {
            using (SqlConnection conn = new SqlConnection(strcon))
            {
                string query = @"
        SELECT COUNT(*) 
FROM tblUser U
JOIN tblOwner O ON U.Owner_id = O.Owner_id
WHERE U.User_id = @User_id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@User_id", userId);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }


        public bool IsFamilyMember(int userId)
        {
            using (SqlConnection conn = new SqlConnection(strcon))
            {
                // More flexible matching - checks if user is listed as any family member for the owner
                string query = @"SELECT COUNT(*) 
                        FROM tblUser U
                        INNER JOIN tblFamilyMember FM ON U.Owner_id = FM.Owner_id
                        WHERE U.User_id = @User_id
                        AND (
                            FM.Email = U.Email 
                            OR FM.Phone_no = U.Phone_no
                            OR FM.Member_name = U.User_name
                        )";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@User_id", userId);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        string Desi, Role;
        public void bindRole()
        {
            int userId = Convert.ToInt32(Session["U_id"]);

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = "SELECT c.Designation, c.Role FROM tblCommitteeMember c JOIN tblUser u ON c.User_id = u.User_id WHERE u.User_id = @id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        Desi = reader["Designation"].ToString();
                        Role = reader["Role"].ToString();
                    }
                }
            }

            if (IsCommitteeMember(userId))
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