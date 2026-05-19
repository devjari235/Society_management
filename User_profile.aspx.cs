using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace Society_management
{
    public partial class User_profile : System.Web.UI.Page
    {
        public static string strcon =
            ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        string name, email, ph, gen, age, marite, img;
        string Desi, Role;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check login session
            if (Session["U_id"] == null)
            {
                Response.Redirect("U_login.aspx");
                return;
            }

            // IMPORTANT:
            // Handle profile image upload FIRST before BindDetails().
            // Otherwise FileUpload loses its selected file.
            if (IsPostBack && profileImageUpload.HasFile)
            {
                UpdateProfilePicture();
                return;
            }

            if (!IsPostBack)
            {
                int userId = Convert.ToInt32(Session["U_id"]);

                int memberId = GetMemberID(userId);
                ViewState["memberId"] = memberId;

                BindDetails();
                bindRole();
                IsCommitteeMember(userId);
            }
        }

        public int GetMemberID(int userId)
        {
            int memberId = -1;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                string query = @"
                    SELECT TOP 1 fm.Member_id
                    FROM tblFamilyMember fm
                    INNER JOIN tblUser u ON u.Owner_id = fm.Owner_id
                    WHERE u.User_id = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            memberId = Convert.ToInt32(reader["Member_id"]);
                        }
                    }
                }
            }

            return memberId;
        }

        public void BindDetails()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                string query = @"
                    SELECT User_name,
                           Phone_no,
                           Email,
                           Gender,
                           Age,
                           Marital_Status,
                           Photo
                    FROM tblUser
                    WHERE User_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id",
                        Session["U_id"].ToString());

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
                            txtGender.Text = gen;
                            txtAge.Text = age;
                            txtmarite.Text = marite;

                            if (!string.IsNullOrWhiteSpace(img))
                                imgPhoto.ImageUrl =
                                    ResolveUrl(img) + "?v=" + DateTime.Now.Ticks;
                            else
                                imgPhoto.ImageUrl =
                                    ResolveUrl("~/Profile/Default.png");
                        }
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // Update tblUser
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                string query = @"
                    UPDATE tblUser
                    SET User_name = @name,
                        Email = @mail,
                        Phone_no = @ph,
                        Gender = @gen,
                        Age = @age,
                        Marital_Status = @marite
                    WHERE User_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@name",
                        txtname.Text.Trim());
                    cmd.Parameters.AddWithValue("@mail",
                        txtemail.Text.Trim());
                    cmd.Parameters.AddWithValue("@ph",
                        txtphone.Text.Trim());
                    cmd.Parameters.AddWithValue("@gen",
                        txtGender.Text.Trim());
                    cmd.Parameters.AddWithValue("@age",
                        txtAge.Text.Trim());
                    cmd.Parameters.AddWithValue("@marite",
                        txtmarite.Text.Trim());
                    cmd.Parameters.AddWithValue("@id",
                        Session["U_id"].ToString());

                    cmd.ExecuteNonQuery();
                }
            }

            int userId = Convert.ToInt32(Session["U_id"]);

            // Update tblOwner if user is owner
            if (IsOwner(userId))
            {
                using (SqlConnection conn = new SqlConnection(strcon))
                {
                    string query = @"
                        UPDATE O
                        SET O.Owner_name = @name,
                            O.Contact_no = @ph,
                            O.Email_id = @mail
                        FROM tblOwner O
                        INNER JOIN tblUser U
                            ON O.Owner_id = U.Owner_id
                        WHERE U.User_id = @id";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@name",
                            txtname.Text.Trim());
                        cmd.Parameters.AddWithValue("@ph",
                            txtphone.Text.Trim());
                        cmd.Parameters.AddWithValue("@mail",
                            txtemail.Text.Trim());
                        cmd.Parameters.AddWithValue("@id", userId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            // Update tblFamilyMember if user is family member
            if (IsFamilyMember(userId) &&
                ViewState["memberId"] != null &&
                Convert.ToInt32(ViewState["memberId"]) > 0)
            {
                int memberId =
                    Convert.ToInt32(ViewState["memberId"]);

                using (SqlConnection con1 = new SqlConnection(strcon))
                {
                    string query = @"
                        UPDATE tblFamilyMember
                        SET Member_name = @name,
                            Phone_no = @ph,
                            Email = @mail,
                            Age = @age,
                            Gender = @gen
                        WHERE Member_id = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con1))
                    {
                        cmd.Parameters.AddWithValue("@name",
                            txtname.Text.Trim());
                        cmd.Parameters.AddWithValue("@ph",
                            txtphone.Text.Trim());
                        cmd.Parameters.AddWithValue("@mail",
                            txtemail.Text.Trim());
                        cmd.Parameters.AddWithValue("@age",
                            txtAge.Text.Trim());
                        cmd.Parameters.AddWithValue("@gen",
                            txtGender.Text.Trim());
                        cmd.Parameters.AddWithValue("@id",
                            memberId);

                        con1.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            ShowSuccessMessage(
                "Details Updated",
                "Your profile details have been successfully updated.");
        }

        private void UpdateProfilePicture()
        {
            try
            {
                if (!profileImageUpload.HasFile)
                    return;

                // Create Profile folder if not exists
                string folderPath =
                    Server.MapPath("~/Profile/");

                if (!Directory.Exists(folderPath))
                    Directory.CreateDirectory(folderPath);

                // Generate unique filename
                string extension =
                    Path.GetExtension(
                        profileImageUpload.FileName);

                string fileName =
                    "User_" +
                    Session["U_id"].ToString() + "_" +
                    DateTime.Now.ToString("yyyyMMddHHmmssfff") +
                    extension;

                string fullPath =
                    Path.Combine(folderPath, fileName);

                // Save file
                profileImageUpload.SaveAs(fullPath);

                // Save path to database
                string dbPath =
                    "~/Profile/" + fileName;

                using (SqlConnection con =
                    new SqlConnection(strcon))
                {
                    con.Open();

                    string query =
                        "UPDATE tblUser SET Photo = @img WHERE User_id = @id";

                    using (SqlCommand cmd =
                        new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@img", dbPath);
                        cmd.Parameters.AddWithValue("@id",
                            Session["U_id"].ToString());

                        cmd.ExecuteNonQuery();
                    }
                }

                // Update image immediately
                imgPhoto.ImageUrl =
                    ResolveUrl(dbPath) +
                    "?v=" + DateTime.Now.Ticks;

                ShowSuccessMessage(
                    "Profile Picture Updated",
                    "Your profile picture has been successfully updated.");
            }
            catch (Exception ex)
            {
                string script = $@"
                    Swal.fire({{
                        icon: 'error',
                        title: 'Upload Failed',
                        text: '{ex.Message.Replace("'", "\\'")}'
                    }});";

                ScriptManager.RegisterStartupScript(
                    this,
                    this.GetType(),
                    Guid.NewGuid().ToString(),
                    script,
                    true);
            }
        }

        private void ShowSuccessMessage(string title, string text)
        {
            string script = $@"
                Swal.fire({{
                    icon: 'success',
                    title: '{title}',
                    text: '{text}',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                }}).then(function() {{
                    window.location = 'User_profile.aspx';
                }});";

            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }

        public bool IsCommitteeMember(int userId)
        {
            using (SqlConnection conn =
                new SqlConnection(strcon))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM tblCommitteeMember
                    WHERE User_id = @User_id
                    AND Status = 'Active'";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue(
                        "@User_id", userId);

                    conn.Open();
                    int count =
                        Convert.ToInt32(cmd.ExecuteScalar());

                    return count > 0;
                }
            }
        }

        public bool IsOwner(int userId)
        {
            using (SqlConnection conn =
                new SqlConnection(strcon))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM tblUser U
                    INNER JOIN tblOwner O
                        ON U.Owner_id = O.Owner_id
                    WHERE U.User_id = @User_id";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue(
                        "@User_id", userId);

                    conn.Open();
                    int count =
                        Convert.ToInt32(cmd.ExecuteScalar());

                    return count > 0;
                }
            }
        }

        public bool IsFamilyMember(int userId)
        {
            using (SqlConnection conn =
                new SqlConnection(strcon))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM tblUser U
                    INNER JOIN tblFamilyMember FM
                        ON U.Owner_id = FM.Owner_id
                    WHERE U.User_id = @User_id
                    AND (
                        FM.Email = U.Email
                        OR FM.Phone_no = U.Phone_no
                        OR FM.Member_name = U.User_name
                    )";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue(
                        "@User_id", userId);

                    conn.Open();
                    int count =
                        Convert.ToInt32(cmd.ExecuteScalar());

                    return count > 0;
                }
            }
        }

        public void bindRole()
        {
            int userId =
                Convert.ToInt32(Session["U_id"]);

            using (SqlConnection con =
                new SqlConnection(strcon))
            {
                con.Open();

                string query = @"
                    SELECT Designation, Role
                    FROM tblCommitteeMember
                    WHERE User_id = @id";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue(
                        "@id", userId);

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Desi =
                                reader["Designation"].ToString();
                            Role =
                                reader["Role"].ToString();
                        }
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