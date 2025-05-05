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
    public partial class CreateNotice : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            string noticeType = ddlNoticeType.SelectedValue;
            string importance = ddlImportance.SelectedValue;
            DateTime expiryDate;
            string status;

            if (!DateTime.TryParse(txtExpiry.Text, out expiryDate))
            {
                expiryDate = DateTime.Now.AddDays(7); // fallback
            }

            status = (expiryDate >= DateTime.Now) ? "Live" : "Expired";

            string filePath = null;
            if (fuNoticeFile.HasFile)
            {
                string fileName = Path.GetFileName(fuNoticeFile.FileName);
                string savePath = Server.MapPath("~/Notice/") + fileName;
                fuNoticeFile.SaveAs(savePath);
                filePath = "~/Notice/" + fileName;
            }

            using (SqlConnection conn = new SqlConnection(strcon))
            {
                string query = @"
                INSERT INTO tblNotices
                (Title, Description, Posted_date, Expiry_date, File_path, Notice_type, Importance, Status, Admin_id)
                VALUES
                (@Title, @Description, GETDATE(), @ExpiryDate, @FilePath, @NoticeType, @Importance, @Status, @AdminId)
            ";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@ExpiryDate", expiryDate);
                cmd.Parameters.AddWithValue("@FilePath", (object)filePath ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@NoticeType", noticeType);
                cmd.Parameters.AddWithValue("@Importance", importance);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@AdminId", Session["A_id"]);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // Show a simple confirmation message
            string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Add successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'NoticeDashboard.aspx';
            });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
            

        }
    }
}