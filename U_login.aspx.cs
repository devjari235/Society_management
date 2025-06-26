using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using DocumentFormat.OpenXml.Spreadsheet;

namespace Society_management
{
    public partial class U_login : System.Web.UI.Page
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
            //string query = "select * from tblUser where (Email=@mail or Phone_no=@phone) and (Password=@pass)";
            string query = @"
SELECT * FROM tblUser 
WHERE 
    (Email COLLATE SQL_Latin1_General_CP1_CI_AS = @mail 
     OR Phone_no COLLATE SQL_Latin1_General_CP1_CI_AS = @phone)
AND 
    Password COLLATE SQL_Latin1_General_CP1_CS_AS = @pass";

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
                        Session["U_id"] = dr.GetValue(0).ToString();
                        HttpCookie userCookie = new HttpCookie("UserInfo");
                        userCookie["U_id"] = dr.GetValue(0).ToString();
                        Response.Cookies.Add(userCookie);
                    }
                    Response.Redirect("UserDashboard.aspx");
                }
            }
        }
    }
}