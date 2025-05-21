using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class ViewEvents : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["deleted"] != null)
                {
                    lblMessage.Text = "Event was deleted successfully.";
                    lblMessage.CssClass = "alert alert-success";
                    lblMessage.Visible = true;
                }
                BindEvents();
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
                    cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());

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
