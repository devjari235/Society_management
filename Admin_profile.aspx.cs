using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace Society_management
{
    public partial class Admin_profile : System.Web.UI.Page
    {
        private readonly string strcon =
            ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check login session
            if (Session["A_id"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            /*
             IMPORTANT:
             When uploading a file, FileUpload.HasFile must be checked
             BEFORE BindDetails() is called.
            */
            if (IsPostBack && profileImageUpload.HasFile)
            {
                UpdateProfilePicture();
                return;
            }

            // First page load
            if (!IsPostBack)
            {
                BindDetails();
            }
        }

        private void BindDetails()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
                    SELECT name, email, phone_no, Profile_picture
                    FROM tblAdmin
                    WHERE admin_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtname.Text = reader["name"].ToString();
                            txtemail.Text = reader["email"].ToString();
                            txtphone.Text = reader["phone_no"].ToString();

                            string profileImage =
                                reader["Profile_picture"] == DBNull.Value
                                    ? ""
                                    : reader["Profile_picture"].ToString();

                            if (!string.IsNullOrWhiteSpace(profileImage))
                            {
                                // Cache busting so latest image is always shown
                                imgPhoto.ImageUrl =
                                    ResolveUrl(profileImage) + "?v=" + DateTime.Now.Ticks;
                            }
                            else
                            {
                                imgPhoto.ImageUrl =
                                    ResolveUrl("~/Profile/Default.png");
                            }
                        }
                    }
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = @"
                        UPDATE tblAdmin
                        SET name = @name,
                            email = @email,
                            phone_no = @phone
                        WHERE admin_id = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@name", txtname.Text.Trim());
                        cmd.Parameters.AddWithValue("@email", txtemail.Text.Trim());
                        cmd.Parameters.AddWithValue("@phone", txtphone.Text.Trim());
                        cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowSuccess("Your profile details have been successfully updated.");
            }
            catch (Exception ex)
            {
                ShowError(ex.Message);
            }
        }

        private void UpdateProfilePicture()
        {
            try
            {
                if (!profileImageUpload.HasFile)
                    return;

                // Validate extension
                string extension = Path.GetExtension(profileImageUpload.FileName).ToLower();

                string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

                if (Array.IndexOf(allowedExtensions, extension) < 0)
                {
                    ShowError("Only JPG, JPEG, PNG, GIF, and WEBP files are allowed.");
                    return;
                }

                // Validate size (max 5 MB)
                if (profileImageUpload.PostedFile.ContentLength > 5 * 1024 * 1024)
                {
                    ShowError("Image size must be less than 5 MB.");
                    return;
                }

                // Create folder if not exists
                string folderPath = Server.MapPath("~/Profile/");

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                // Generate unique file name
                string fileName =
                    "Admin_" +
                    Session["A_id"].ToString() +
                    "_" +
                    DateTime.Now.ToString("yyyyMMddHHmmssfff") +
                    extension;

                string fullPath = Path.Combine(folderPath, fileName);

                // Save file
                profileImageUpload.SaveAs(fullPath);

                // Relative path for database
                string dbPath = "~/Profile/" + fileName;

                // Get old image path (to delete later)
                string oldImagePath = "";

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    // Fetch old image
                    using (SqlCommand cmdOld = new SqlCommand(
                        "SELECT Profile_picture FROM tblAdmin WHERE admin_id = @id", con))
                    {
                        cmdOld.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                        object result = cmdOld.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            oldImagePath = result.ToString();
                        }
                    }

                    // Update database
                    using (SqlCommand cmd = new SqlCommand(
                        @"UPDATE tblAdmin
                          SET Profile_picture = @img
                          WHERE admin_id = @id", con))
                    {
                        cmd.Parameters.AddWithValue("@img", dbPath);
                        cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                        cmd.ExecuteNonQuery();
                    }
                }

                // Delete old image if it exists and isn't default
                if (!string.IsNullOrWhiteSpace(oldImagePath) &&
                    !oldImagePath.Contains("Default.png"))
                {
                    string oldPhysicalPath = Server.MapPath(oldImagePath);

                    if (File.Exists(oldPhysicalPath))
                    {
                        try
                        {
                            File.Delete(oldPhysicalPath);
                        }
                        catch
                        {
                            // Ignore delete errors
                        }
                    }
                }

                // Update image on page immediately
                imgPhoto.ImageUrl =
                    ResolveUrl(dbPath) + "?v=" + DateTime.Now.Ticks;

                ShowSuccess("Profile picture updated successfully.");
            }
            catch (Exception ex)
            {
                ShowError(ex.Message);
            }
        }

        private void ShowSuccess(string message)
        {
            string script = $@"
                Swal.fire({{
                    icon: 'success',
                    title: 'Success',
                    text: '{message.Replace("'", "\\'")}',
                    confirmButtonColor: '#3085d6'
                }}).then(function () {{
                    window.location = 'Admin_profile.aspx';
                }});";

            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }

        private void ShowError(string message)
        {
            string script = $@"
                Swal.fire({{
                    icon: 'error',
                    title: 'Error',
                    text: '{message.Replace("'", "\\'")}'
                }});";

            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }
    }
}