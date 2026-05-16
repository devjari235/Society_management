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
            string name = txtName.Text.Trim();
            string ph = txtPhone.Text.Trim();
            string mail = txtEmail.Text.Trim();
            string pass = txtPassword.Text.Trim();

            // Specify column names explicitly.
            // Do not include admin_id because it is an IDENTITY column.
            // Profile_picture is nullable, so we insert NULL.
            string query = @"
        INSERT INTO tblAdmin
        (
            name,
            email,
            password,
            phone_no,
            Profile_picture
        )
        VALUES
        (
            @Name,
            @Email,
            @Password,
            @Phone,
            @ProfilePicture
        )";

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Email", mail);
                cmd.Parameters.AddWithValue("@Password", pass);
                cmd.Parameters.AddWithValue("@Phone", ph);

                // Insert NULL because Profile_picture allows NULL
                cmd.Parameters.AddWithValue("@ProfilePicture", DBNull.Value);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Login.aspx");
        }
        protected void cvTerms_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkTerms.Checked;
        }

    }
}