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
    public partial class MemberSchedule : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               
            }
        }

        protected void btnSchedule_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtVisitorName.Text) ||
                string.IsNullOrEmpty(txtContactNumber.Text) ||
                string.IsNullOrEmpty(txtVisitDateTime.Text) ||
                string.IsNullOrEmpty(txtVisitPurpose.Text))
            {
                lblMessage.Text = "Please fill in all fields.";
                return;
            }

            if (!DateTime.TryParse(txtVisitDateTime.Text, out DateTime visitDateTime))
            {
                lblMessage.Text = "Please enter a valid date and time.";
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string query = @"INSERT INTO ScheduledVisits 
                            (VisitorName, ContactNumber, ScheduledDateTime, Purpose, User_id)
                             VALUES 
                            (@VisitorName, @ContactNumber, @ScheduledDateTime, @Purpose, @MemberID)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@VisitorName", txtVisitorName.Text.Trim());
                command.Parameters.AddWithValue("@ContactNumber", txtContactNumber.Text.Trim());
                command.Parameters.AddWithValue("@ScheduledDateTime", visitDateTime);
                command.Parameters.AddWithValue("@Purpose", txtVisitPurpose.Text.Trim());
                command.Parameters.AddWithValue("@MemberID", Session["U_id"]);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    lblMessage.Text = "Visitor scheduled successfully.";
                    ClearForm();
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
        }

        private void ClearForm()
        {
            txtVisitorName.Text = "";
            txtContactNumber.Text = "";
            txtVisitDateTime.Text = "";
            txtVisitPurpose.Text = "";
        }
    }
}
