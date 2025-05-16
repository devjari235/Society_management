using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Complaint : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (ValidateComplaint())
            {
                try
                {
                    SqlConnection con = new SqlConnection(strcon);
                    con.Open();

                    // Handle file upload if applicable
                    string imagePath = null;
                    if (fileUpload.HasFile)
                    {
                        string fileName = Path.GetFileName(fileUpload.FileName);
                        imagePath = "~/Uploads/" + fileName;
                        fileUpload.SaveAs(Server.MapPath(imagePath));
                    }

                    string Query = "INSERT INTO tblComplaint (Complaint_type, Priority, Description, image, User_id) VALUES (@type, @prio, @desc, @image, @id)";
                    SqlCommand cmd = new SqlCommand(Query, con);
                    cmd.Parameters.AddWithValue("@type", ddlComplaintType.SelectedValue);
                    cmd.Parameters.AddWithValue("@prio", ddlPriority.SelectedValue);
                    cmd.Parameters.AddWithValue("@desc", txtDescription.Text);
                    cmd.Parameters.AddWithValue("@image", (object)imagePath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                    cmd.ExecuteNonQuery();

                    con.Close();

                    string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Complaint submitted successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'Complaint.aspx';
            });";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                        "alert('Error submitting complaint: " + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }

        private void BindNotices()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Step 1: Update expired notices
                string updateQuery = @"UPDATE tblNotices 
                               SET Status = '' 
                               WHERE Expiry_date < GETDATE() AND Status != 'Expired'";
                SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                updateCmd.ExecuteNonQuery();

                // Step 2: Fetch notices
                //string selectQuery = @"SELECT Notice_id, Title, Description, Expiry_date, File_path, Importance, Status 
                //               FROM tblNotices 
                //               WHERE Expiry_date IS NULL OR Expiry_date >= GETDATE() 
                //               ORDER BY Posted_date DESC";

                string selectQuery = "SELECT n.Notice_id, n.Title, n.Description, n.Expiry_date, n.File_path, n.Importance, n.Status,  n.Posted_date,  a.name FROM tblNotices n INNER JOIN tblAdmin a ON n.admin_id = a.admin_id WHERE a.admin_id = @id AND (n.Expiry_date IS NULL OR n.Expiry_date >= GETDATE())  ORDER BY  n.Posted_date DESC";
                SqlCommand cmd = new SqlCommand(selectQuery, conn);
                cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvDisplay.DataSource = dt;
                gvDisplay.DataBind();
            }
        }
        private void SaveUploadedFiles(string complaintId)
        {
            string uploadFolder = Server.MapPath("~/Uploads/" + complaintId);

            // Create directory if it doesn't exist


            // Save each file
            foreach (HttpPostedFile file in fileUpload.PostedFiles)
            {
                // Validate file size (5MB max)
                if (file.ContentLength > 5 * 1024 * 1024)
                {
                    continue; // Skip or handle oversized files
                }

                // Generate a safe filename
                string fileName = Path.GetFileName(file.FileName);
                string filePath = Path.Combine(uploadFolder, fileName);

                // Save the file
                file.SaveAs(filePath);


            }
        }

        private bool ValidateComplaint()
        {
            // Server-side validation
            if (string.IsNullOrEmpty(ddlComplaintType.SelectedValue))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "validationError",
                    "alert('Please select a complaint type');", true);
                return false;
            }

            if (string.IsNullOrEmpty(txtSubject.Text.Trim()))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "validationError",
                    "alert('Please enter a subject');", true);
                return false;
            }

            if (string.IsNullOrEmpty(txtDescription.Text.Trim()))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "validationError",
                    "alert('Please enter a description');", true);
                return false;
            }

            return true;
        }
    }
}