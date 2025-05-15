using System;
using System.Collections.Generic;
using System.Configuration;
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
                    SqlConnection con=new SqlConnection(strcon);
                    con.Open();
                    string Query = "Insert into (Complaint_type, Priority, Description, image, User_id)tblComplaint values(@type,@prio,@desc,@image,@id)";
                    SqlCommand cmd =new SqlCommand(Query, con);
                    cmd.Parameters.AddWithValue("@type",ddlComplaintType.SelectedValue);
                    cmd.Parameters.AddWithValue("@prio",ddlPriority.SelectedValue);
                    cmd.Parameters.AddWithValue("@desc",txtDescription.Text);
                    cmd.Parameters.AddWithValue("@image", "~/Uploads/");
                    cmd.Parameters.AddWithValue(",@id", Session["U_id"].ToString());
                    cmd.ExecuteNonQuery();
                    con.Close();
                    string script = @"
                    Swal.fire({
                        title: 'Success!',
                        text: 'Flat Add successfully!',
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }).then(function() {
                        window.location = 'Complaint.aspx';
                    });";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                }
                catch (Exception ex)
                {
                    // Log error and show error message
                    ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                        "alert('Error submitting complaint: " + ex.Message + "');", true);
                }
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