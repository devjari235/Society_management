using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace Society_management
{
    public partial class CreateEvent : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtEventDate.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
            }
        }

        protected void btnCreateEvent_Click(object sender, EventArgs e)
        {
            string imageUrl = "";

            // 🔹 IMAGE UPLOAD
            if (fileEventImage.HasFile)
            {
                try
                {
                    string fileName = Path.GetFileName(fileEventImage.FileName);
                    string folder = Server.MapPath("~/EventImages/");

                    if (!Directory.Exists(folder))
                        Directory.CreateDirectory(folder);

                    string filePath = Path.Combine(folder, fileName);
                    fileEventImage.SaveAs(filePath);

                    imageUrl = "EventImages/" + fileName;
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Image upload error: " + ex.Message;
                    lblMessage.CssClass = "text-danger";
                    return;
                }
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // 🔥 INSERT EVENT + GET EventId
                string eventQuery = @"
                    INSERT INTO tblEvents 
                    (EventName, EventDescription, EventDate, EventLocation, 
                     OrganizerName, OrganizerEmail, ImageUrl, admin_id)
                    
                    OUTPUT INSERTED.EventId
                    
                    VALUES 
                    (@EventName, @EventDescription, @EventDate, @EventLocation, 
                     @OrganizerName, @OrganizerEmail, @ImageUrl, @AdminId)";

                SqlCommand cmd = new SqlCommand(eventQuery, con);

                cmd.Parameters.AddWithValue("@EventName", txtEventName.Text);
                cmd.Parameters.AddWithValue("@EventDescription", txtEventDescription.Text);
                cmd.Parameters.AddWithValue("@EventDate", DateTime.Parse(txtEventDate.Text));
                cmd.Parameters.AddWithValue("@EventLocation", txtEventLocation.Text);
                cmd.Parameters.AddWithValue("@OrganizerName", txtOrganizerName.Text);
                cmd.Parameters.AddWithValue("@OrganizerEmail", txtOrganizerEmail.Text);
                cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageUrl) ? DBNull.Value : (object)imageUrl);
                cmd.Parameters.AddWithValue("@AdminId", Session["A_id"]);

                int eventId = Convert.ToInt32(cmd.ExecuteScalar()); // 🔥 GET EVENT ID

                // 🔥 INSERT NOTIFICATION FOR ALL USERS
                string notifyQuery = @"
                    INSERT INTO Notifications (User_id, Title, Message, Type, ReferenceID, IsRead, CreatedDate)
                    SELECT 
                        User_id,
                        'New Event',
                        'New Event: ' + @EventName + ' at ' + @Location,
                        'Event',
                        @EventId,
                        0,
                        GETDATE()
                    FROM tblUser";

                SqlCommand notifyCmd = new SqlCommand(notifyQuery, con);
                notifyCmd.Parameters.AddWithValue("@EventName", txtEventName.Text);
                notifyCmd.Parameters.AddWithValue("@Location", txtEventLocation.Text);
                notifyCmd.Parameters.AddWithValue("@EventId", eventId);

                notifyCmd.ExecuteNonQuery();

                // ✅ SUCCESS MESSAGE
                string script = @"
                    Swal.fire({
                        title: 'Success!',
                        text: 'Event created and notification sent!',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }).then(function() {
                        window.location = 'CreateEvent.aspx';
                    });";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Success", script, true);

                // 🔹 CLEAR FORM
                txtEventName.Text = "";
                txtEventDescription.Text = "";
                txtEventLocation.Text = "";
                txtOrganizerName.Text = "";
                txtOrganizerEmail.Text = "";
            }
        }
    }
}