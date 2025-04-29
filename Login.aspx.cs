using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Login : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text;
            string ph=txtEmail.Text;
            string pass = txtPassword.Text;
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string query = "select count(*) from tblAdmin where email=@mail or phone_no=@phone and password=@pass";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("mail", email);
            cmd.Parameters.AddWithValue("phone", ph);
            cmd.Parameters.AddWithValue("pass", pass);
            int i = Convert.ToInt16(cmd.ExecuteScalar());
            if (i == 0)
            {
                string script = @"
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'Invalid User or Password',
            confirmButtonColor: '#d33',
            confirmButtonText: 'Try Again'
        });
    </script>";

                ClientScript.RegisterStartupScript(this.GetType(), "LoginError", script);

            }
            else
            {
                 Session["a"] = txtEmail.Text;
                Response.Redirect("AdminDashboard.aspx");


            }
        }
    }
}