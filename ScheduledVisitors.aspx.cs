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
    public partial class ScheduledVisitors : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadScheduledVisitors();
            }
        }

        private void LoadScheduledVisitors()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                string query = @"SELECT 
                                s.ScheduleID, 
                                s.VisitorName, 
                                s.ContactNumber, 
                                s.ScheduledDateTime, 
                                s.Purpose, 
                                ISNULL(s.IsCompleted, 0) AS IsCompleted,
                                m.User_name AS MemberName,
                                v.CheckOutTime
                            FROM ScheduledVisits s
                            INNER JOIN tblUser m ON s.User_id = m.User_id
                            LEFT JOIN Visitors v 
                                ON v.Name = s.VisitorName 
                                AND v.ContactNumber = s.ContactNumber 
                                AND v.IsScheduled = 1
                            WHERE s.ScheduledDateTime >= @Today
                            ORDER BY s.ScheduledDateTime";


                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@Today", DateTime.Today);

                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvScheduledVisitors.DataSource = dt;
                    gvScheduledVisitors.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Error loading data: {ex.Message}", "danger");
            }
        }

        protected void gvScheduledVisitors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CheckIn")
            {
                HandleCheckIn(Convert.ToInt32(e.CommandArgument));
            }
            else if (e.CommandName == "CheckOut")
            {
                HandleCheckOut(Convert.ToInt32(e.CommandArgument));
            }
        }

        private void HandleCheckIn(int scheduleId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            string getDetailsQuery = @"SELECT VisitorName, ContactNumber, Purpose, MemberID 
                                     FROM ScheduledVisits 
                                     WHERE ScheduleID = @ScheduleID";

            string updateScheduleQuery = @"UPDATE ScheduledVisits 
                                        SET IsCompleted = 1 
                                        WHERE ScheduleID = @ScheduleID";

            string insertVisitorQuery = @"INSERT INTO Visitors 
                                        (Name, ContactNumber, VisitPurpose, MemberID, 
                                         IsApproved, IsScheduled, CheckInTime)
                                        VALUES 
                                        (@Name, @ContactNumber, @Purpose, @MemberID, 
                                         1, 1, @CheckInTime)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlTransaction transaction = connection.BeginTransaction();

                try
                {
                    // Step 1: Get visitor details
                    SqlCommand getCommand = new SqlCommand(getDetailsQuery, connection, transaction);
                    getCommand.Parameters.AddWithValue("@ScheduleID", scheduleId);

                    using (SqlDataReader reader = getCommand.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string name = reader["VisitorName"].ToString();
                            string contact = reader["ContactNumber"].ToString();
                            string purpose = reader["Purpose"].ToString();
                            int memberId = Convert.ToInt32(reader["MemberID"]);
                            reader.Close();

                            // Step 2: Mark schedule as completed
                            SqlCommand updateCommand = new SqlCommand(updateScheduleQuery, connection, transaction);
                            updateCommand.Parameters.AddWithValue("@ScheduleID", scheduleId);
                            updateCommand.ExecuteNonQuery();

                            // Step 3: Create visitor record
                            SqlCommand insertCommand = new SqlCommand(insertVisitorQuery, connection, transaction);
                            insertCommand.Parameters.AddWithValue("@Name", name);
                            insertCommand.Parameters.AddWithValue("@ContactNumber", contact);
                            insertCommand.Parameters.AddWithValue("@Purpose", purpose);
                            insertCommand.Parameters.AddWithValue("@MemberID", memberId);
                            insertCommand.Parameters.AddWithValue("@CheckInTime", DateTime.Now);
                            insertCommand.ExecuteNonQuery();

                            transaction.Commit();
                            ShowMessage("Visitor checked in successfully!", "success");
                        }
                        else
                        {
                            reader.Close();
                            transaction.Rollback();
                            ShowMessage("Schedule record not found.", "danger");
                            return;
                        }
                    }
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    ShowMessage($"Check-in failed: {ex.Message}", "danger");
                    return;
                }
            }

            LoadScheduledVisitors();
        }

        private void HandleCheckOut(int scheduleId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            string getVisitorQuery = @"SELECT v.VisitorID 
                                     FROM Visitors v
                                     INNER JOIN ScheduledVisits s ON 
                                        v.Name = s.VisitorName AND 
                                        v.ContactNumber = s.ContactNumber
                                     WHERE s.ScheduleID = @ScheduleID";

            string updateVisitorQuery = @"UPDATE Visitors 
                                        SET CheckOutTime = @CheckOutTime 
                                        WHERE VisitorID = @VisitorID";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlTransaction transaction = connection.BeginTransaction();

                try
                {
                    // Find the visitor record
                    SqlCommand getCommand = new SqlCommand(getVisitorQuery, connection, transaction);
                    getCommand.Parameters.AddWithValue("@ScheduleID", scheduleId);

                    object visitorId = getCommand.ExecuteScalar();

                    if (visitorId != null)
                    {
                        // Update checkout time
                        SqlCommand updateCommand = new SqlCommand(updateVisitorQuery, connection, transaction);
                        updateCommand.Parameters.AddWithValue("@CheckOutTime", DateTime.Now);
                        updateCommand.Parameters.AddWithValue("@VisitorID", visitorId);
                        updateCommand.ExecuteNonQuery();

                        transaction.Commit();
                        ShowMessage("Visitor checked out successfully!", "success");
                    }
                    else
                    {
                        transaction.Rollback();
                        ShowMessage("No matching visitor record found.", "danger");
                        return;
                    }
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    ShowMessage($"Check-out failed: {ex.Message}", "danger");
                    return;
                }
            }

            LoadScheduledVisitors();
        }

        protected void gvScheduledVisitors_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView rowView = (DataRowView)e.Row.DataItem;

                bool isCompleted = rowView["IsCompleted"] != DBNull.Value && Convert.ToBoolean(rowView["IsCompleted"]);
                bool isCheckedOut = rowView["CheckOutTime"] != DBNull.Value;

                Button btnCheckIn = (Button)e.Row.FindControl("btnCheckIn");
                Button btnCheckOut = (Button)e.Row.FindControl("btnCheckOut");

                // CheckIn: Enable only if not completed
                btnCheckIn.Enabled = !isCompleted;
                if (!btnCheckIn.Enabled)
                {
                    btnCheckIn.CssClass += " disabled-btn";
                }

                // CheckOut: Enable only if completed and not already checked out
                btnCheckOut.Enabled = isCompleted && !isCheckedOut;
                if (!btnCheckOut.Enabled)
                {
                    btnCheckOut.CssClass += " disabled-btn";
                }
            }
        }



        private void ShowMessage(string message, string alertType)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"alert alert-{alertType} alert-dismissible fade show";
            lblMessage.Visible = true;
        }
    }
}