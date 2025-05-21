using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class CreateEvent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default date to today
                txtEventDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
            }
        }

        protected void btnCreateEvent_Click(object sender, EventArgs e)
        {
            string imageUrl = string.Empty;

            // Handle file upload if an image was provided
            if (fileEventImage.HasFile)
            {
                try
                {
                    string fileName = Path.GetFileName(fileEventImage.FileName);
                    string uploadFolder = Server.MapPath("~/EventImages/");

                    // Create directory if it doesn't exist
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Save the file
                    string filePath = Path.Combine(uploadFolder, fileName);
                    fileEventImage.SaveAs(filePath);

                    // Set the image URL for database
                    imageUrl = "EventImages/" + fileName;
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error uploading image: " + ex.Message;
                    lblMessage.CssClass = "text-danger";
                    lblMessage.Visible = true;
                    return;
                }
            }

            // Save event to database
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO tblEvents (EventName, EventDescription, EventDate, EventLocation, 
                                    OrganizerName, OrganizerEmail, ImageUrl,admin_id) 
                                    VALUES (@EventName, @EventDescription, @EventDate, @EventLocation, 
                                    @OrganizerName, @OrganizerEmail, @ImageUrl, @id)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventName", txtEventName.Text);
                    cmd.Parameters.AddWithValue("@EventDescription", txtEventDescription.Text);
                    cmd.Parameters.AddWithValue("@EventDate", DateTime.Parse(txtEventDate.Text));
                    cmd.Parameters.AddWithValue("@EventLocation", txtEventLocation.Text);
                    cmd.Parameters.AddWithValue("@OrganizerName", txtOrganizerName.Text);
                    cmd.Parameters.AddWithValue("@OrganizerEmail", txtOrganizerEmail.Text);
                    cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageUrl) ? DBNull.Value : (object)imageUrl);
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                        string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Event created successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'CreateEvent.aspx';
            });";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                        // Clear form
                        txtEventName.Text = "";
                        txtEventDescription.Text = "";
                        txtEventLocation.Text = "";
                        txtOrganizerName.Text = "";
                        txtOrganizerEmail.Text = "";
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error creating event: " + ex.Message;
                        lblMessage.CssClass = "text-danger";
                        lblMessage.Visible = true;
                    }
                }
            }
        }
    }
}