using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class ScheduledVisitors : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadScheduledVisitors();
        }

        private void LoadScheduledVisitors()
        {
            string adminId = Session["A_id"]?.ToString();
            if (string.IsNullOrEmpty(adminId))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string query = @"SELECT s.ScheduleID, s.VisitorName, s.ContactNumber, 
                            s.ScheduledDateTime, s.Purpose, ISNULL(s.IsCompleted, 0) AS IsCompleted,
                            m.User_name, v.CheckOutTime
                     FROM ScheduledVisits s
                     INNER JOIN tblUser m ON s.User_id = m.User_id
                     INNER JOIN tblOwner o ON m.Owner_id = o.Owner_id
                     INNER JOIN tblBlock b ON o.Block_id = b.Block_id
                     INNER JOIN tblSociety soc ON b.Society_id = soc.Society_id
                     LEFT JOIN Visitors v ON v.Name = s.VisitorName AND v.ContactNumber = s.ContactNumber AND v.IsScheduled = 1
                     WHERE soc.admin_id = @AdminID
                     ORDER BY s.ScheduledDateTime DESC";

            using (SqlConnection conn = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AdminID", adminId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvScheduledVisitors.DataSource = dt;
                gvScheduledVisitors.DataBind();

                // --- TOGGLE VISIBILITY LOGIC ---
                if (dt.Rows.Count > 0)
                {
                    phDataContent.Visible = true; // Show Card with Table
                    pnlEmpty.Visible = false;     // Hide Empty State
                }
                else
                {
                    phDataContent.Visible = false; // Hide White Card
                    pnlEmpty.Visible = true;       // Show Centered Empty State
                }
            }
        }

        protected void gvScheduledVisitors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null || string.IsNullOrEmpty(e.CommandArgument.ToString())) return;
            int scheduleId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "CheckIn") HandleCheckIn(scheduleId);
            else if (e.CommandName == "CheckOut") HandleCheckOut(scheduleId);
        }

        private void HandleCheckIn(int scheduleId)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(cs))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    SqlCommand getCmd = new SqlCommand("SELECT VisitorName, ContactNumber, Purpose, User_id FROM ScheduledVisits WHERE ScheduleID = @ScheduleID", conn, trans);
                    getCmd.Parameters.AddWithValue("@ScheduleID", scheduleId);

                    using (SqlDataReader rdr = getCmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            string name = rdr["VisitorName"].ToString();
                            string contact = rdr["ContactNumber"].ToString();
                            string purpose = rdr["Purpose"].ToString();
                            int memberId = Convert.ToInt32(rdr["User_id"]);
                            rdr.Close();

                            SqlCommand updateCmd = new SqlCommand("UPDATE ScheduledVisits SET IsCompleted = 1 WHERE ScheduleID = @ScheduleID", conn, trans);
                            updateCmd.Parameters.AddWithValue("@ScheduleID", scheduleId);
                            updateCmd.ExecuteNonQuery();

                            SqlCommand insertCmd = new SqlCommand(@"INSERT INTO Visitors (Name, ContactNumber, VisitPurpose, User_id, IsApproved, IsScheduled, CheckInTime) 
                                VALUES (@Name, @ContactNumber, @Purpose, @User_id, 1, 1, @CheckInTime)", conn, trans);
                            insertCmd.Parameters.AddWithValue("@Name", name);
                            insertCmd.Parameters.AddWithValue("@ContactNumber", contact);
                            insertCmd.Parameters.AddWithValue("@Purpose", purpose);
                            insertCmd.Parameters.AddWithValue("@User_id", memberId);
                            insertCmd.Parameters.AddWithValue("@CheckInTime", DateTime.Now);
                            insertCmd.ExecuteNonQuery();

                            trans.Commit();
                            ShowToast($"Visitor '{name}' checked in successfully!", "success");
                        }
                        else { trans.Rollback(); }
                    }
                }
                catch (Exception ex)
                {
                    if (trans.Connection != null) trans.Rollback();
                    ShowToast("Error: " + ex.Message, "danger");
                }
            }
            LoadScheduledVisitors();
        }

        private void HandleCheckOut(int scheduleId)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(cs))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    SqlCommand getCmd = new SqlCommand(@"SELECT v.VisitorID, v.Name FROM Visitors v INNER JOIN ScheduledVisits s ON v.Name = s.VisitorName AND v.ContactNumber = s.ContactNumber WHERE s.ScheduleID = @ScheduleID AND v.IsScheduled = 1", conn, trans);
                    getCmd.Parameters.AddWithValue("@ScheduleID", scheduleId);
                    using (SqlDataReader rdr = getCmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            int visitorId = Convert.ToInt32(rdr["VisitorID"]);
                            string name = rdr["Name"].ToString();
                            rdr.Close();

                            SqlCommand updateCmd = new SqlCommand("UPDATE Visitors SET IsCompleted = 1, CheckOutTime = @CheckOutTime WHERE VisitorID = @VisitorID", conn, trans);
                            updateCmd.Parameters.AddWithValue("@CheckOutTime", DateTime.Now);
                            updateCmd.Parameters.AddWithValue("@VisitorID", visitorId);
                            updateCmd.ExecuteNonQuery();

                            trans.Commit();
                            ShowToast($"Visitor '{name}' checked out successfully!", "success");
                        }
                        else { trans.Rollback(); }
                    }
                }
                catch (Exception ex)
                {
                    if (trans.Connection != null) trans.Rollback();
                    ShowToast("Error: " + ex.Message, "danger");
                }
            }
            LoadScheduledVisitors();
        }

        protected void gvScheduledVisitors_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                bool isCompleted = Convert.ToBoolean(row["IsCompleted"]);
                bool isCheckedOut = row["CheckOutTime"] != DBNull.Value;

                Button btnCheckIn = (Button)e.Row.FindControl("btnCheckIn");
                Button btnCheckOut = (Button)e.Row.FindControl("btnCheckOut");

                if (btnCheckIn != null) btnCheckIn.Enabled = !isCompleted;
                if (btnCheckOut != null) btnCheckOut.Enabled = isCompleted && !isCheckedOut;
            }
        }

        private void ShowToast(string message, string type)
        {
            string cleanMsg = message.Replace("'", "\\'");
            string script = $"showToast('{cleanMsg}', '{type}');";
            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
        }
    }
}