using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class EventDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["EventId"] != null)
            {
                int eventId = Convert.ToInt32(Request.QueryString["EventId"]);
                LoadEventDetails(eventId);
            }
            else
            {
                // Redirect if no event ID is provided
                Response.Redirect("ViewEvents.aspx");
            }
        }


        private void LoadEventDetails(int eventId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM tblEvents WHERE EventId = @EventId and admin_id=@id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EventId", eventId);
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

                    try
                    {
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Set the edit link
                            lnkEdit.NavigateUrl = $"EditEvent.aspx?EventId={eventId}";
                            // Display event details
                            lblEventName.InnerText = reader["EventName"].ToString();
                            lblEventDescription.InnerText = reader["EventDescription"].ToString();

                            DateTime eventDate = Convert.ToDateTime(reader["EventDate"]);
                            lblEventDate.InnerText = eventDate.ToString("MMMM dd, yyyy");
                            lblFullEventDate.InnerText = eventDate.ToString("MMMM dd, yyyy hh:mm tt");

                            lblEventLocation.InnerText = reader["EventLocation"].ToString();
                            lblFullEventLocation.InnerText = reader["EventLocation"].ToString();

                            lblOrganizerName.InnerText = reader["OrganizerName"].ToString();
                            lblOrganizerEmail.InnerText = reader["OrganizerEmail"].ToString();

                            DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
                            lblCreatedDate.InnerText = createdDate.ToString("MMMM dd, yyyy");

                            // Set image
                            if (reader["ImageUrl"] != DBNull.Value)
                            {
                                imgEvent.ImageUrl = reader["ImageUrl"].ToString();
                            }
                            else
                            {
                                imgEvent.ImageUrl = "https://via.placeholder.com/900x400?text=No+Image";
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
                        throw;
                    }
                }
            }
        }
    }
}