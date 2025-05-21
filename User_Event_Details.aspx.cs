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
    public partial class User_Event_Details : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AdminID();
            }
            if (Request.QueryString["EventId"] != null)
            {
                int eventId = Convert.ToInt32(Request.QueryString["EventId"]);
                LoadEventDetails(eventId);
            }
            else
            {
                // Redirect if no event ID is provided
                Response.Redirect("User_view_Events.aspx");
            }

        }

        int id;
        public void AdminID()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            SqlConnection con = new SqlConnection(connectionString);
            con.Open();
            string query = "SELECT a.admin_id from tblUser u join tblOwner o on o.Owner_id=u.Owner_id join tblblock b on  b.Block_id = o.Block_id JOIN tblSociety s ON s.Society_id = b.Society_id join tblAdmin a on s.admin_id = a.admin_id where u.User_id=@id";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                id = Convert.ToInt32(reader["admin_id"]);
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
                    cmd.Parameters.AddWithValue("@id", id);

                    try
                    {
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
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