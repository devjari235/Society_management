using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Events : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["A_id"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                BindEvents();
            }
        }

        private void BindEvents()
        {
            DataTable dtLive = GetEventsByStatus("Live");
            rptLiveEvents.DataSource = dtLive;
            rptLiveEvents.DataBind();

            DataTable dtUpcoming = GetEventsByStatus("Upcoming");
            rptUpcomingEvents.DataSource = dtUpcoming;
            rptUpcomingEvents.DataBind();

            DataTable dtPast = GetEventsByStatus("Past");
            rptPastEvents.DataSource = dtPast;
            rptPastEvents.DataBind();
        }

        private DataTable GetEventsByStatus(string status)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT e.*, a.name AS OrganizerName 
                                FROM Events e
                                JOIN tblAdmin a ON e.OrganizerID = a.admin_id
                                WHERE ";

                switch (status)
                {
                    case "Live":
                        query += "GETDATE() BETWEEN StartDateTime AND EndDateTime";
                        break;
                    case "Upcoming":
                        query += "StartDateTime > GETDATE()";
                        break;
                    case "Past":
                        query += "EndDateTime < GETDATE()";
                        break;
                }

                query += " ORDER BY StartDateTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        [WebMethod]
        public static string GetCalendarEvents()
        {
            string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT EventID, EventTitle, StartDateTime, EndDateTime 
                                FROM Events
                                WHERE IsApproved = 1
                                ORDER BY StartDateTime";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            var events = new List<object>();
            foreach (DataRow row in dt.Rows)
            {
                events.Add(new
                {
                    id = row["EventID"],
                    title = row["EventTitle"],
                    start = Convert.ToDateTime(row["StartDateTime"]).ToString("yyyy-MM-ddTHH:mm:ss"),
                    end = Convert.ToDateTime(row["EndDateTime"]).ToString("yyyy-MM-ddTHH:mm:ss"),
                    allDay = false
                });
            }

            return new JavaScriptSerializer().Serialize(events);
        }

        protected void btnCreateEvent_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string imagePath = SaveUploadedImage();

                if (!DateTime.TryParse(txtStartDateTime.Text, out DateTime start) ||
                    !DateTime.TryParse(txtEndDateTime.Text, out DateTime end))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "dateError",
                        "Swal.fire('Error', 'Invalid date format.', 'error');", true);
                    return;
                }

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = @"INSERT INTO Events (EventTitle, EventDescription, StartDateTime, EndDateTime, 
                                    Location, OrganizerID, ImagePath, IsApproved)
                                    VALUES (@Title, @Description, @Start, @End, @Location, @Organizer, @Image, 1)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Title", txtEventTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtEventDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Start", start);
                        cmd.Parameters.AddWithValue("@End", end);
                        cmd.Parameters.AddWithValue("@Location", txtLocation.Text.Trim());
                        cmd.Parameters.AddWithValue("@Organizer", Convert.ToInt32(Session["A_id"]));
                        cmd.Parameters.AddWithValue("@Image", imagePath);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "closeModal",
                    "$('#createEventModal').modal('hide');", true);
                BindEvents();
            }
        }

        private string SaveUploadedImage()
        {
            if (fuEventImage.HasFile)
            {
                string ext = Path.GetExtension(fuEventImage.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "fileError",
                        "Swal.fire('Error', 'Only JPG, JPEG, and PNG files are allowed.', 'error');", true);
                    return "~/EventImages/default.jpg";
                }

                string fileName = Path.GetFileNameWithoutExtension(fuEventImage.FileName) +
                                 "_" + Guid.NewGuid().ToString().Substring(0, 8) +
                                 ext;

                string folderPath = Server.MapPath("~/EventImages/");
                string filePath = Path.Combine(folderPath, fileName);

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                fuEventImage.SaveAs(filePath);
                return "~/EventImages/" + fileName;
            }
            return "~/EventImages/default.jpg";
        }

        protected void btnViewDetails_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int eventID = Convert.ToInt32(btn.CommandArgument);

            DataTable dt = GetEventDetails(eventID);
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];

                string status = DateTime.Now < Convert.ToDateTime(row["StartDateTime"]) ? "Upcoming" :
                    (DateTime.Now <= Convert.ToDateTime(row["EndDateTime"]) ? "Live" : "Past");

                ScriptManager.RegisterStartupScript(this, GetType(), "showEventDetails",
                    $"showEventDetails('{row["EventTitle"]}', '{row["EventDescription"]}', " +
                    $"'{row["StartDateTime"]}', '{row["EndDateTime"]}', '{row["Location"]}', " +
                    $"'{row["ImagePath"]}', '{status}');", true);

                hdnEventID.Value = eventID.ToString();

                btnRegister.Visible = status != "Past";
                btnCancelRegistration.Visible = false;
                btnDeleteEvent.Visible = Session["A_id"].ToString() == row["OrganizerID"].ToString();

                if (btnRegister.Visible)
                {
                    CheckRegistrationStatus(eventID);
                }

                if (btnDeleteEvent.Visible)
                {
                    LoadAttendees(eventID);
                    divAttendees.Visible = true;
                }
            }
        }

        private DataTable GetEventDetails(int eventID)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT e.*, a.name AS OrganizerName 
                                FROM Events e
                                JOIN tblAdmin a ON e.OrganizerID = a.admin_id
                                WHERE e.EventID = @EventID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventID", eventID);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        private void CheckRegistrationStatus(int eventID)
        {
            int memberID = Convert.ToInt32(Session["A_id"]);

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT AttendanceStatus FROM EventAttendees 
                                WHERE EventID = @EventID AND MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventID", eventID);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);

                    con.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        btnRegister.Visible = false;
                        btnCancelRegistration.Visible = true;
                    }
                }
            }
        }

        private void LoadAttendees(int eventID)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT m.name AS MemberName, ea.AttendanceStatus 
                                FROM EventAttendees ea
                                JOIN Members m ON ea.MemberID = m.MemberID
                                WHERE ea.EventID = @EventID
                                ORDER BY ea.AttendanceStatus, m.name";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventID", eventID);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            gvAttendees.DataSource = dt;
            gvAttendees.DataBind();
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            int eventID = Convert.ToInt32(hdnEventID.Value);
            int memberID = Convert.ToInt32(Session["A_id"]);

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string checkQuery = @"SELECT COUNT(*) FROM EventAttendees 
                                      WHERE EventID = @EventID AND MemberID = @MemberID";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@EventID", eventID);
                    checkCmd.Parameters.AddWithValue("@MemberID", memberID);

                    con.Open();
                    int exists = (int)checkCmd.ExecuteScalar();
                    if (exists == 0)
                    {
                        string query = @"INSERT INTO EventAttendees (EventID, MemberID, AttendanceStatus)
                                         VALUES (@EventID, @MemberID, 'Confirmed')";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@EventID", eventID);
                            cmd.Parameters.AddWithValue("@MemberID", memberID);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            btnRegister.Visible = false;
            btnCancelRegistration.Visible = true;

            if (btnDeleteEvent.Visible)
            {
                LoadAttendees(eventID);
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "registrationSuccess",
                "Swal.fire('Success', 'You have successfully registered for this event', 'success');", true);
        }

        protected void btnCancelRegistration_Click(object sender, EventArgs e)
        {
            int eventID = Convert.ToInt32(hdnEventID.Value);
            int memberID = Convert.ToInt32(Session["A_id"]);

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"DELETE FROM EventAttendees 
                                WHERE EventID = @EventID AND MemberID = @MemberID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventID", eventID);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            btnRegister.Visible = true;
            btnCancelRegistration.Visible = false;

            if (btnDeleteEvent.Visible)
            {
                LoadAttendees(eventID);
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "cancelSuccess",
                "Swal.fire('Success', 'Your registration has been cancelled', 'success');", true);
        }

        protected void btnDeleteEvent_Click(object sender, EventArgs e)
        {
            int eventID = Convert.ToInt32(hdnEventID.Value);

            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query1 = "DELETE FROM EventAttendees WHERE EventID = @EventID";
                using (SqlCommand cmd1 = new SqlCommand(query1, con))
                {
                    cmd1.Parameters.AddWithValue("@EventID", eventID);
                    con.Open();
                    cmd1.ExecuteNonQuery();
                    con.Close();
                }

                string query2 = "DELETE FROM Events WHERE EventID = @EventID";
                using (SqlCommand cmd2 = new SqlCommand(query2, con))
                {
                    cmd2.Parameters.AddWithValue("@EventID", eventID);
                    con.Open();
                    cmd2.ExecuteNonQuery();
                }
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "deleteSuccess",
                "Swal.fire('Success', 'Event has been deleted', 'success').then(function() {" +
                "$('#eventDetailsModal').modal('hide'); __doPostBack('', ''); });", true);
        }

        protected void Page_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            Server.ClearError();

            ScriptManager.RegisterStartupScript(this, GetType(), "errorOccurred",
                $"Swal.fire('Error', '{ex.Message.Replace("'", "\\'")}', 'error');", true);
        }
    }
}
