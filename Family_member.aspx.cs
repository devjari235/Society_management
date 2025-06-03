using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Family_member : System.Web.UI.Page
    {
     
        string connStr = WebConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
           
                OwnerID();
            

        }
        protected void cvDOB_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (DateTime.TryParse(txtDOB.Text, out DateTime dob))
            {
                args.IsValid = dob <= DateTime.Today;
            }
            else
            {
                args.IsValid = false;
            }
        }

        int id;
        public void OwnerID()
        {
            SqlConnection con = new SqlConnection(connStr);
            con.Open();
            string Query = "Select Owner_id from tblUser where User_id=@u_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@u_id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                id = Convert.ToInt32(reader["Owner_id"]);
            }

        }
        protected void btnAddMember_Click(object sender, EventArgs e)
        {
            int ownerId = id;
            int totalAllowed = 0;
            int currentCount = 1;

            string connStr = WebConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // 1. Get total allowed members
                SqlCommand cmd1 = new SqlCommand("SELECT Total_member FROM tblOwner WHERE Owner_id = @Owner_id", con);
                cmd1.Parameters.AddWithValue("@Owner_id", ownerId);
                totalAllowed = Convert.ToInt32(cmd1.ExecuteScalar());

                // 2. Count current members
                SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM tblFamilyMember WHERE Owner_id = @Owner_id", con);
                cmd2.Parameters.AddWithValue("@Owner_id", ownerId);
                currentCount = Convert.ToInt32(cmd2.ExecuteScalar());

                if (currentCount < (totalAllowed - 1))
                {
                    // 3. Insert family member
                    SqlCommand cmd3 = new SqlCommand(@"INSERT INTO tblFamilyMember 
                    (Owner_id, Member_name, Email, Phone_no, Age, Gender, Relationship) 
                    VALUES (@Owner_id, @Member_name, @email, @no, @Age, @Gender, @Relationship)", con);
                    cmd3.Parameters.AddWithValue("@Owner_id", ownerId);
                    cmd3.Parameters.AddWithValue("@Member_name", txtName.Text);
                    cmd3.Parameters.AddWithValue("@email",txtEmail.Text);
                    cmd3.Parameters.AddWithValue("@no",txtPhone.Text);
                    cmd3.Parameters.AddWithValue("@Age", Convert.ToInt32(txtAge.Text));
                    cmd3.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                    cmd3.Parameters.AddWithValue("@Relationship", ddlRelationship.Text);

                    cmd3.ExecuteNonQuery();
                    //lblMessage.ForeColor = System.Drawing.Color.Green;
                    //lblMessage.Text = "Member added successfully.";

                    string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Member added successfully.!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'Family_member.aspx';
            });";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);

                    txtName.Text = "";
                    txtAge.Text = "";
                    ddlRelationship.Text = "";
                    ddlGender.SelectedIndex = 0;
                }
                else
                {
                    string script = @"
                        <script>
                            Swal.fire({
                                icon: 'error',
                                title: 'error',
                                text: 'You have already added the maximum number of family members.',
                                confirmButtonColor: '#d33',
                                confirmButtonText: 'Try Again'
                            });
                        </script>";

                    ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);

                    //lblMessage.ForeColor = System.Drawing.Color.Red;
                    //lblMessage.Text = "You have already added the maximum number of family members.";
                }

                con.Close();
            }
        }
    }
}