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
    public partial class EditEvent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["EventId"] != null)
                {
                    int eventId = Convert.ToInt32(Request.QueryString["EventId"]);
                    LoadEventData(eventId);
                }
                else
                {
                    // Redirect if no event ID is provided
                    Response.Redirect("ViewEvents.aspx");
                }
            }
        }

        private void LoadEventData(int eventId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM tblEvents WHERE EventId = @EventId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);

                    try
                    {
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnEventId.Value = eventId.ToString();
                            txtEventName.Text = reader["EventName"].ToString();
                            txtEventDescription.Text = reader["EventDescription"].ToString();

                            DateTime eventDate = Convert.ToDateTime(reader["EventDate"]);
                            txtEventDate.Text = eventDate.ToString("yyyy-MM-ddTHH:mm");

                            txtEventLocation.Text = reader["EventLocation"].ToString();
                            txtOrganizerName.Text = reader["OrganizerName"].ToString();
                            txtOrganizerEmail.Text = reader["OrganizerEmail"].ToString();

                            // Display current image
                            if (reader["ImageUrl"] != DBNull.Value)
                            {
                                imgCurrentImage.ImageUrl = reader["ImageUrl"].ToString();
                                imgCurrentImage.Visible = true;
                                lblNoImage.Visible = false;
                            }
                            else
                            {
                                imgCurrentImage.Visible = false;
                                lblNoImage.Visible = true;
                            }
                        }
                        else
                        {
                            // Event not found, redirect
                            Response.Redirect("ViewEvents.aspx");
                        }
                    }
                    catch (Exception ex)
                    {
                        // Handle error
                        lblMessage.Text = "Error loading event: " + ex.Message;
                        lblMessage.CssClass = "text-danger";
                        lblMessage.Visible = true;
                    }
                }
            }
        }

        protected void btnUpdateEvent_Click(object sender, EventArgs e)
        {
            int eventId = Convert.ToInt32(hdnEventId.Value);
            string imageUrl = GetCurrentImageUrl(eventId);

            // Handle file upload if a new image was provided
            if (fileEventImage.HasFile)
            {
                try
                {
                    // Delete old image if it exists
                    if (!string.IsNullOrEmpty(imageUrl))
                    {
                        string oldFilePath = Server.MapPath("~/" + imageUrl);
                        if (File.Exists(oldFilePath))
                        {
                            File.Delete(oldFilePath);
                        }
                    }

                    // Save new image
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

                    // Set the new image URL
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

            // Update event in database
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"UPDATE tblEvents SET 
                                EventName = @EventName, 
                                EventDescription = @EventDescription, 
                                EventDate = @EventDate, 
                                EventLocation = @EventLocation, 
                                OrganizerName = @OrganizerName, 
                                OrganizerEmail = @OrganizerEmail, 
                                ImageUrl = @ImageUrl 
                                WHERE EventId = @EventId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);
                    cmd.Parameters.AddWithValue("@EventName", txtEventName.Text);
                    cmd.Parameters.AddWithValue("@EventDescription", txtEventDescription.Text);
                    cmd.Parameters.AddWithValue("@EventDate", DateTime.Parse(txtEventDate.Text));
                    cmd.Parameters.AddWithValue("@EventLocation", txtEventLocation.Text);
                    cmd.Parameters.AddWithValue("@OrganizerName", txtOrganizerName.Text);
                    cmd.Parameters.AddWithValue("@OrganizerEmail", txtOrganizerEmail.Text);
                    cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageUrl) ? DBNull.Value : (object)imageUrl);

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Show success message
                            lblMessage.Text = "Event updated successfully!";
                            lblMessage.CssClass = "text-success";
                            lblMessage.Visible = true;

                            // Refresh the image display
                            if (!string.IsNullOrEmpty(imageUrl))
                            {
                                imgCurrentImage.ImageUrl = imageUrl;
                                imgCurrentImage.Visible = true;
                                lblNoImage.Visible = false;
                            }
                        }
                        else
                        {
                            lblMessage.Text = "No changes were made to the event.";
                            lblMessage.CssClass = "text-info";
                            lblMessage.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error updating event: " + ex.Message;
                        lblMessage.CssClass = "text-danger";
                        lblMessage.Visible = true;
                    }
                }
            }
        }

        protected void btnDeleteEvent_Click(object sender, EventArgs e)
        {
            int eventId = Convert.ToInt32(hdnEventId.Value);
            string imageUrl = GetCurrentImageUrl(eventId);

            // Delete the image file if it exists
            if (!string.IsNullOrEmpty(imageUrl))
            {
                string filePath = Server.MapPath("~/" + imageUrl);
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
            }

            // Delete event from database
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Events WHERE EventId = @EventId and admin_id=@id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                    try
                    {
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Redirect to events list after successful deletion
                            Response.Redirect("ViewEvents.aspx?deleted=true");
                        }
                        else
                        {
                            lblMessage.Text = "Event could not be deleted.";
                            lblMessage.CssClass = "text-danger";
                            lblMessage.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error deleting event: " + ex.Message;
                        lblMessage.CssClass = "text-danger";
                        lblMessage.Visible = true;
                    }
                }
            }
        }

        private string GetCurrentImageUrl(int eventId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string imageUrl = string.Empty;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ImageUrl FROM Events WHERE EventId = @EventId and admin_id=@id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());


                    try
                    {
                        con.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != DBNull.Value && result != null)
                        {
                            imageUrl = result.ToString();
                        }
                    }
                    catch
                    {
                        // If there's an error, just return empty string
                    }
                }
            }

            return imageUrl;
        }
    }
}