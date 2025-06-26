using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Forms;

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
            string ph = txtEmail.Text;
            string pass = txtPassword.Text;
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            //string query = "select * from tblAdmin where (email=@mail or phone_no=@phone) and (password=@pass)";
            string query = "select * from tblAdmin where (email COLLATE SQL_Latin1_General_CP1_CI_AS = @mail or phone_no = @phone) and password COLLATE SQL_Latin1_General_CP1_CS_AS = @pass";
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
                // Session["a"] = txtEmail.Text;

                SqlDataReader dr = cmd.ExecuteReader();


                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        // Set admin session values
                        Session["A_id"] = dr.GetValue(0).ToString();
                        Session["A_name"] = dr.GetValue(1).ToString();
                        Session["A_email"] = dr.GetValue(2).ToString();
                        Session["A_pass"] = dr.GetValue(3).ToString();
                        Session["A_phone"] = dr.GetValue(4).ToString();

                        // ✅ Create a cookie for Admin ID only
                        HttpCookie adminCookie = new HttpCookie("AdminInfo");
                        adminCookie["A_id"] = dr.GetValue(0).ToString();
                        adminCookie.Expires = DateTime.Now.AddDays(1); // Optional: set expiry
                        Response.Cookies.Add(adminCookie);
                    }

                    Response.Redirect("AdminDashboard.aspx");
                }

            }
        }
    }
}