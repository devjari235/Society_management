using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class PollCreate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlAdmin.Visible = true;
            }
        }

        protected void btnCreatePoll_Click(object sender, EventArgs e)
        {
            // Reset messages
            lblAdminMessage.Visible = false;
            lblAdminSuccess.Visible = false;

            // Validate question
            if (string.IsNullOrWhiteSpace(txtNewQuestion.Text))
            {
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'Please enter a question for the poll.',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);
                //ShowError("Please enter a question for the poll.");
                return;
            }

            // Get options from hidden field
            string[] options = hdnOptions.Value.Split(new[] { "|||" }, StringSplitOptions.RemoveEmptyEntries);

            // Validate options
            if (options.Length < 2)
            {
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'Please enter at least two options for the poll.',
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);
                //ShowError("Please enter at least two options for the poll.");
                return;
            }

            try
            {
                // First, close any active polls
               

                // Create new poll
                int newPollId = CreateNewPoll(txtNewQuestion.Text);

                // Add options
                foreach (string option in options)
                {
                    if (!string.IsNullOrWhiteSpace(option))
                    {
                        AddPollOption(newPollId, option.Trim());
                    }
                }
                string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'New poll created successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'PollCreate.aspx';
            });";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
                //ShowSuccess("New poll created successfully!");
            }
            catch (Exception ex)
            {
                string script = @"
                    <script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Oops...',
                            text: 'An error occurred while creating the poll:'+ ex.Message,
                            confirmButtonColor: '#d33',
                            confirmButtonText: 'Try Again'
                        });
                    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);
                //ShowError("An error occurred while creating the poll: " + ex.Message);
            }
        }

        //private void ShowError(string message)
        //{
        //    lblAdminMessage.Text = message;
        //    lblAdminMessage.Visible = true;
        //    lblAdminMessage.CssClass = "alert alert-danger";
        //}

        //private void ShowSuccess(string message)
        //{
        //    lblAdminSuccess.Text = message;
        //    lblAdminSuccess.Visible = true;
        //    lblAdminSuccess.CssClass = "alert alert-success";
        //}



        private int CreateNewPoll(string question)
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("INSERT INTO tblPolls (Question, IsActive, CreatedDate, Expried_date, admin_id) OUTPUT INSERTED.PollId VALUES (@Question, 1, @CreatedDate, @expire, @id)", conn);
                cmd.Parameters.AddWithValue("@Question", question);
                cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@expire", txtExpireDate.Text);
                cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
                return (int)cmd.ExecuteScalar();
            }
        }

        private void AddPollOption(int pollId, string optionText)
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("INSERT INTO tblPollOptions (PollId, OptionText) VALUES (@PollId, @OptionText)", conn);
                cmd.Parameters.AddWithValue("@PollId", pollId);
                cmd.Parameters.AddWithValue("@OptionText", optionText);
                cmd.ExecuteNonQuery();
            }
        }
    }
}