using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace Society_management
{
    public partial class User_pass_change : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
                BindDetails();
        }
        string pass;

        public void BindDetails()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT Password FROM tblUser WHERE User_id=@id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                pass = reader["Password"].ToString();
            }

            reader.Close();
            con.Close();
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string Current = txtCurrent.Text;
            if (Current == pass.ToString())
            {
                SqlConnection con = new SqlConnection(strcon);
                con.Open();
                string Query = "Update tblUser set Password=@pass where User_id=@id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@pass", txtnewpass.Text);
                cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
                cmd.ExecuteNonQuery();
                string successScript = @"
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Password Updated',
                    text: 'Your password has been successfully changed.',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK'
                }).then(function() {
                window.location = 'User_pass_change.aspx';
            });
            </script>";
                ClientScript.RegisterStartupScript(this.GetType(), "UpdateSuccess", successScript);
            }
            else
            {
                string errorScript = @"
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Oops...',
                    text: 'Invalid Current Password',
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'Try Again'
                }).then(function() {
                window.location = 'User_pass_change.aspx';
            });
            </script>";
                ClientScript.RegisterStartupScript(this.GetType(), "UpdateError", errorScript);
            }
        }
    }
}