using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Society_management.NoticeBoard;


namespace Society_management
{
    public partial class NoticeBoard : System.Web.UI.Page
    {
       // private static List<Notice> Notices = new List<Notice>();
        protected void Page_Load(object sender, EventArgs e)
        {
          
        }
       
        protected void btnPost_Click(object sender, EventArgs e)
        {
            string title =txtTitle.Text;
            string message = txtDescription.Text;
            
            DateTime currentDate = DateTime.Now;

            if (!string.IsNullOrEmpty(title) && !string.IsNullOrEmpty(message))
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString))
                {
                    string query = "INSERT INTO tblNoticeBoard(Title,Description,Date,admin_id,Status) VALUES (@title, @Des,@date, @a_Id, 'Active')";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@Des", message);
                    cmd.Parameters.AddWithValue("@date",currentDate);
                    cmd.Parameters.AddWithValue("a_Id", Session["A_id"]);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                    string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Add successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'NoticeBoard.aspx';
            });";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                }

                txtDescription.Text = "";
                txtTitle.Text = "";
            }
        }
        

       
    }
}