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
    public partial class VisitorEntry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSocietyMembers();
            }
        }

        private void LoadSocietyMembers()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string query = "SELECT \r\n    u.User_id, \r\n    u.User_name + ' - ' + CAST(f.Flate_no AS VARCHAR) AS DisplayName \r\nFROM \r\n    tblUser u \r\nJOIN \r\n    tblOwner o ON o.Owner_id = u.Owner_id \r\nJOIN \r\n    tblFlat f ON f.Flate_id = o.Flate_id \r\nORDER BY \r\n    u.User_name;\r\n";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                DataTable dt = new DataTable();

                adapter.Fill(dt);

                ddlMembers.DataSource = dt;
                ddlMembers.DataTextField = "DisplayName";
                ddlMembers.DataValueField = "User_id";
                ddlMembers.DataBind();

                ddlMembers.Items.Insert(0, new ListItem("-- Select Member --", "0"));
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (ddlMembers.SelectedValue == "0")
            {
                lblMessage.Text = "Please select a society member.";
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string query = "INSERT INTO Visitors (Name, ContactNumber, VisitPurpose, MemberID) VALUES (@Name, @ContactNumber, @VisitPurpose, @MemberID)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Name", txtVisitorName.Text.Trim());
                command.Parameters.AddWithValue("@ContactNumber", txtContactNumber.Text.Trim());
                command.Parameters.AddWithValue("@VisitPurpose", txtVisitPurpose.Text.Trim());
                command.Parameters.AddWithValue("@MemberID", ddlMembers.SelectedValue);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    lblMessage.Text = "Visitor entry submitted successfully. Waiting for member approval.";
                    ClearForm();
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
        }

        protected void btnCheckScheduled_Click(object sender, EventArgs e)
        {
            Response.Redirect("ScheduledVisitors.aspx");
        }

        private void ClearForm()
        {
            txtVisitorName.Text = "";
            txtContactNumber.Text = "";
            txtVisitPurpose.Text = "";
            ddlMembers.SelectedIndex = 0;
        }
    }
}
