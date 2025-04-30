using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace Society_management
{
    public partial class Admin_profile : System.Web.UI.Page
    {
        private string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["A_id"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                BindAdminDetails();
                LoadProfilePicture();
            }
        }

        private void BindAdminDetails()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    string query = @"SELECT name, email, phone_no, Profile_picture 
                                     FROM tblAdmin 
                                     WHERE admin_id = @adminId";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@adminId", Session["A_id"].ToString());

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtname.Text = reader["name"].ToString();
                            txtemail.Text = reader["email"].ToString();
                            txtphone.Text = reader["phone_no"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowSweetAlert("Error", "Failed to load admin details: " + ex.Message, "error");
            }
        }

        private void LoadProfilePicture()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string query = @"SELECT Profile_picture FROM tblAdmin WHERE admin_id = @adminId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@adminId", Session["A_id"]);

                object result = cmd.ExecuteScalar();
                string imagePath = result?.ToString() ?? "";

                if (!string.IsNullOrEmpty(imagePath))
                {
                    string physicalPath = Server.MapPath(imagePath);
                    if (File.Exists(physicalPath))
                    {
                        imgProfile.ImageUrl = ResolveUrl(imagePath) + "?v=" + DateTime.Now.Ticks;
                    }
                    else
                    {
                        SetDefaultProfileImage();
                        UpdateProfilePicture("~/Images/default-profile.png");
                    }
                }
                else
                {
                    SetDefaultProfileImage();
                }
            }
        }

        private void SetDefaultProfileImage()
        {
            imgProfile.ImageUrl = "~/Images/default-profile.png";
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    string query = @"UPDATE tblAdmin 
                                   SET name = @name, email = @email, phone_no = @phone 
                                   WHERE admin_id = @adminId";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@name", txtname.Text.Trim());
                    cmd.Parameters.AddWithValue("@email", txtemail.Text.Trim());
                    cmd.Parameters.AddWithValue("@phone", txtphone.Text.Trim());
                    cmd.Parameters.AddWithValue("@adminId", Session["A_id"].ToString());

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowSweetAlert("Success", "Profile updated successfully!", "success");
                    }
                    else
                    {
                        ShowSweetAlert("Warning", "No changes were made to your profile.", "warning");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowSweetAlert("Error", "Failed to update profile: " + ex.Message, "error");
            }
        }

        protected void fuUpload_Changed(object sender, EventArgs e)
        {
            if (fuUpload.HasFile)
            {
                string ext = Path.GetExtension(fuUpload.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                {
                    ShowSweetAlert("Error", "Only JPG, JPEG, PNG allowed.", "error");
                    return;
                }

                if (fuUpload.PostedFile.ContentLength > 5 * 1024 * 1024)
                {
                    ShowSweetAlert("Error", "Max file size is 5MB.", "error");
                    return;
                }

                string dir = Server.MapPath("~/Images/");
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                string filename = $"admin_{Session["A_id"]}_{DateTime.Now:yyyyMMddHHmmss}{ext}";
                string relativePath = "~/Images/" + filename;
                string fullPath = Server.MapPath(relativePath);

                // Delete old image if it's not default
                string oldImage = Server.MapPath(imgProfile.ImageUrl);
                if (File.Exists(oldImage) && !imgProfile.ImageUrl.Contains("default-profile"))
                    File.Delete(oldImage);

                fuUpload.SaveAs(fullPath);
                UpdateProfilePicture(relativePath);
                imgProfile.ImageUrl = relativePath + "?v=" + DateTime.Now.Ticks;

                ShowSweetAlert("Success", "Profile picture updated!", "success");
            }
        }
        private void UpdateProfilePicture(string imagePath)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("UPDATE tblAdmin SET Profile_picture = @img WHERE admin_id = @id", con);
                cmd.Parameters.AddWithValue("@img", imagePath);
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                cmd.ExecuteNonQuery();
            }
        }

        private void ShowSweetAlert(string title, string text, string type)
        {
            string script = $@"
                <script>
                    Swal.fire({{
                        title: '{title}',
                        text: '{text}',
                        icon: '{type}',
                        confirmButtonColor: '#4285f4',
                        confirmButtonText: 'OK'
                    }});
                </script>";

            ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert", script, false);
        }
    }
}