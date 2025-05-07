using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Web.UI;

namespace Society_management
{
    public partial class Admin_profile : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDetails();
            }
        }

        public void BindDetails()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT name, email, phone_no, Profile_picture FROM tblAdmin WHERE admin_id = @a_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@a_id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                txtname.Text = reader["name"].ToString();
                txtemail.Text = reader["email"].ToString();
                txtphone.Text = reader["phone_no"].ToString();

                string imgPath = reader["Profile_picture"].ToString();
                if (!string.IsNullOrEmpty(imgPath))
                {
                    imgPhoto.ImageUrl = imgPath;
                }
                else
                {
                    imgPhoto.ImageUrl = "https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2023/08/tiktok-no-profile-picture.png";
                }
            }

            reader.Close();
            con.Close();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "UPDATE tblAdmin SET name=@name, email=@mail, phone_no=@ph WHERE admin_id=@id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@name", txtname.Text);
            cmd.Parameters.AddWithValue("@mail", txtemail.Text);
            cmd.Parameters.AddWithValue("@ph", txtphone.Text);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            cmd.ExecuteNonQuery();
            con.Close();

            string successScript = @"
                Swal.fire({
                    icon: 'success',
                    title: 'Details Updated',
                    text: 'Your profile details have been successfully updated.',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                }).then(function() {
                    window.location = 'Admin_profile.aspx';
                });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSuccess", successScript, true);
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (profileImageUpload.HasFile)
            {
                try
                {
                    // Create directory if it doesn't exist
                    string profileDir = Server.MapPath("~/Profile/");
                    if (!Directory.Exists(profileDir))
                    {
                        Directory.CreateDirectory(profileDir);
                    }

                    // Generate unique filename
                    string fileName = Guid.NewGuid().ToString() + Path.GetExtension(profileImageUpload.FileName);
                    string filePath = Server.MapPath("~/Profile/" + fileName);

                    // Save file
                    profileImageUpload.SaveAs(filePath);

                    // Update database
                    SqlConnection con = new SqlConnection(strcon);
                    con.Open();
                    string Query = "UPDATE tblAdmin SET Profile_picture=@img WHERE admin_id=@id";
                    SqlCommand cmd = new SqlCommand(Query, con);
                    cmd.Parameters.AddWithValue("@img", "~/Profile/" + fileName);
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
                    cmd.ExecuteNonQuery();
                    con.Close();

                    // Update image display
                    imgPhoto.ImageUrl = "~/Profile/" + fileName;

                    string successScript = @"
                        Swal.fire({
                            icon: 'success',
                            title: 'Profile Picture Updated',
                            text: 'Your profile picture has been successfully updated.',
                            confirmButtonColor: '#3085d6',
                            confirmButtonText: 'OK'
                        });";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadSuccess", successScript, true);
                }
                catch (Exception ex)
                {
                    string errorScript = @"
                        Swal.fire({
                        icon: 'error',
                            title: 'Upload Failed',
                            text: 'An error occurred: {ex.Message.Replace("", "")}',
                            confirmButtonColor: '#3085d6',
                            confirmButtonText: 'OK'
                        }); ";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadError", errorScript, true);
                }
            }
        }
    }
}
