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
    public partial class A_registration : System.Web.UI.Page
    {
         string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            //SqlConnection con = new SqlConnection(strcon);
            //if (con.State != System.Data.ConnectionState.Open)
            //{
            //    con.Open();
            //    Response.Write("Connection Successfully");
            //}
            //else
            //{
            //    Response.Write("Fail");
            //}
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string name = txtName.Text;
            string ph = txtPhone.Text;
            string mail = txtEmail.Text;
            string pass = txtPassword.Text;
            string query = "insert into tblAdmin values(@Name,@Email,@password,@ph)";
            SqlConnection conn = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Email", mail);
            cmd.Parameters.AddWithValue("@password", pass);
            cmd.Parameters.AddWithValue("@ph", ph);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            //Response.Write("<script>alert('Thank you For Sing up and go to Login')</script>");
            Response.Redirect("Login.aspx");
        }
        protected void cvTerms_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkTerms.Checked;
        }

    }
}