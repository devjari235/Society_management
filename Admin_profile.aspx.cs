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
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    string query = @"SELECT Profile_picture FROM tblAdmin 
                                   WHERE admin_id = @adminId";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@adminId", Session["A_id"].ToString());

                    object result = cmd.ExecuteScalar();
                    string imagePath = result != null ? result.ToString() : "";

                    if (!string.IsNullOrEmpty(imagePath))
                    {
                        string physicalPath = Server.MapPath(imagePath);
                        if (File.Exists(physicalPath))
                        {
                            imgProfile.ImageUrl = ResolveUrl(imagePath);
                        }
                        else
                        {
                            // If stored path is invalid, set default and update DB
                            SetDefaultProfileImage();
                            UpdateProfilePicture("~/Images/default-profile.png");
                        }
                    }
                    else
                    {
                        // No profile picture set
                        SetDefaultProfileImage();
                    }
                }
            }
            catch (Exception ex)
            {
                SetDefaultProfileImage();
                ShowSweetAlert("Error", "Failed to load profile picture: " + ex.Message, "error");
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
                try
                {
                    // Validate file type
                    string fileExtension = Path.GetExtension(fuUpload.FileName).ToLower();
                    if (fileExtension != ".jpg" && fileExtension != ".jpeg" && fileExtension != ".png")
                    {
                        ShowSweetAlert("Error", "Only JPG, JPEG, and PNG files are allowed.", "error");
                        return;
                    }

                    // Validate file size (max 5MB)
                    if (fuUpload.PostedFile.ContentLength > 5242880) // 5MB
                    {
                        ShowSweetAlert("Error", "File size must be less than 5MB.", "error");
                        return;
                    }

                    // Create Images directory if it doesn't exist
                    string imagesDir = Server.MapPath("~/Images/");
                    if (!Directory.Exists(imagesDir))
                    {
                        Directory.CreateDirectory(imagesDir);
                    }

                    // Generate unique filename
                    string newFileName = $"admin_{Session["A_id"]}_{DateTime.Now:yyyyMMddHHmmss}{fileExtension}";
                    string newFilePath = "~/Images/" + newFileName;
                    string fullPath = Server.MapPath(newFilePath);

                    // Delete old profile picture if it exists and isn't the default
                    string oldImagePath = Server.MapPath(imgProfile.ImageUrl);
                    if (File.Exists(oldImagePath) && !oldImagePath.Contains("default-profile"))
                    {
                        File.Delete(oldImagePath);
                    }

                    // Save new file
                    fuUpload.SaveAs(fullPath);

                    // Update database
                    UpdateProfilePicture(newFilePath);

                    // Update image display
                    imgProfile.ImageUrl = newFilePath;

                    ShowSweetAlert("Success", "Profile picture updated successfully!", "success");
                }
                catch (Exception ex)
                {
                    ShowSweetAlert("Error", "Failed to upload profile picture: " + ex.Message, "error");
                }
            }
        }

        private void UpdateProfilePicture(string imagePath)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string query = @"UPDATE tblAdmin 
                               SET Profile_picture = @imagePath 
                               WHERE admin_id = @adminId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@imagePath", imagePath);
                cmd.Parameters.AddWithValue("@adminId", Session["A_id"].ToString());
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