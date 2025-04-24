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
            string query = "select count(*) from tblAdmin where a_email=@mail or a_phone=@phone and a_pass=@pass";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("mail", email);
            cmd.Parameters.AddWithValue("phone", ph);
            cmd.Parameters.AddWithValue("pass", pass);
            int i = Convert.ToInt16(cmd.ExecuteScalar());
            if (i == 0)
            {
                Response.Write("Login not valid");
            }
            else
            {
                 Session["a"] = txtEmail.Text;
                Response.Redirect("Home.aspx");


            }
        }
    }
}