using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace Society_management
{
    public partial class User_profile : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack && profileImageUpload.HasFile)
            {
                string filename = Path.GetFileName(profileImageUpload.FileName);
                string filepath = "~/Profile/" + filename;
                profileImageUpload.SaveAs(Server.MapPath(filepath));

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("UPDATE tblUser SET Photo=@img WHERE User_id=@id", con);
                    cmd.Parameters.AddWithValue("@img", filepath);
                    cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                    cmd.ExecuteNonQuery();
                }

                string successScript = @"
                <script>
                    Swal.fire({
                        icon: 'success',
                        title: 'Profile Picture Updated',
                        text: 'Your profile picture has been successfully updated.',
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }).then(function() {
                        window.location = 'User_profile.aspx';
                    });
                </script>";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdatePhoto", successScript, false);
            }
        
            if (!IsPostBack)
            {
                BindDetails();
            }
        }

        public void BindDetails()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = "SELECT User_name, Email, Phone_no, Gender, Age, Marital_Status, Photo FROM tblUser WHERE User_id = @id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtname.Text = reader["User_name"].ToString();
                    txtemail.Text = reader["Email"].ToString();
                    txtphone.Text = reader["Phone_no"].ToString();
                    txtGender.Text = reader["Gender"].ToString();
                    txtAge.Text = reader["Age"].ToString();
                    txtMarital.Text = reader["Marital_Status"].ToString();

                    string img = reader["Photo"].ToString();
                    imgPhoto.ImageUrl = string.IsNullOrEmpty(img)
                        ? "https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2023/08/tiktok-no-profile-picture.png"
                        : img;
                }

                reader.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = @"UPDATE tblUser SET 
                    User_name = @name, 
                    Email = @mail, 
                    phone_no = @ph, 
                    Gender = @gen, 
                    Age = @age, 
                    Marital_Status = @marite 
                    WHERE User_id = @id";

                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@name", txtname.Text);
                cmd.Parameters.AddWithValue("@mail", txtemail.Text);
                cmd.Parameters.AddWithValue("@ph", txtphone.Text);
                cmd.Parameters.AddWithValue("@gen", txtGender.Text);
                cmd.Parameters.AddWithValue("@age", txtAge.Text);
                cmd.Parameters.AddWithValue("@marite", txtMarital.Text);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                cmd.ExecuteNonQuery();
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

        protected void profileImageUpload_Load(object sender, EventArgs e)
        {
        //    if (IsPostBack && profileImageUpload.HasFile)
        //    {
        //        string filename = Path.GetFileName(profileImageUpload.FileName);
        //        string filepath = "~/Profile/" + filename;
        //        profileImageUpload.SaveAs(Server.MapPath(filepath));

        //        using (SqlConnection con = new SqlConnection(strcon))
        //        {
        //            con.Open();
        //            SqlCommand cmd = new SqlCommand("UPDATE tblUser SET Photo=@img WHERE User_id=@id", con);
        //            cmd.Parameters.AddWithValue("@img", filepath);
        //            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
        //            cmd.ExecuteNonQuery();
        //        }

        //        string successScript = @"
        //        <script>
        //            Swal.fire({
        //                icon: 'success',
        //                title: 'Profile Picture Updated',
        //                text: 'Your profile picture has been successfully updated.',
        //                confirmButtonColor: '#3085d6',
        //                confirmButtonText: 'OK'
        //            }).then(function() {
        //                window.location = 'User_profile.aspx';
        //            });
        //        </script>";
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdatePhoto", successScript, false);
        //    }
        }
    }
}
