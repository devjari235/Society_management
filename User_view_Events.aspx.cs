using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class User_view_Events : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AdminID();
                BindEvents();
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
        private void BindEvents()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM tblEvents WHERE EventDate >= @CurrentDate AND admin_id = @id ORDER BY EventDate ASC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CurrentDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@id", id);

                    try
                    {
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptEvents.DataSource = dt;
                            rptEvents.DataBind();
                            pnlNoEvents.Visible = false;
                        }
                        else
                        {
                            pnlNoEvents.Visible = true;
                            rptEvents.Visible = false;
                        }
                    }
                    catch (Exception ex)
                    {
                        // Optional logging
                        throw;
                    }
                }
            }
        }

        public static string GetImageUrl(object imageUrl)
        {
            if (imageUrl == DBNull.Value || string.IsNullOrEmpty(imageUrl.ToString()))
            {
                return "https://via.placeholder.com/300x200?text=No+Image";
            }
            return imageUrl.ToString();
        }

        public static string TruncateDescription(string description)
        {
            if (string.IsNullOrEmpty(description))
                return "";

            if (description.Length > 100)
            {
                return description.Substring(0, 100) + "...";
            }
            return description;
        }

        public static string FormatDate(object date)
        {
            if (date != DBNull.Value && date != null)
            {
                DateTime eventDate = Convert.ToDateTime(date);
                return eventDate.ToString("MMM dd, yyyy hh:mm tt");
            }
            return string.Empty;
        }
    }
}