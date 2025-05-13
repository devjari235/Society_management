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
    public partial class ChangePassOtpUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void btnUpdate_Click(object sender, EventArgs e)
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
                window.location = 'U_login.aspx';
            });
            </script>";
            ClientScript.RegisterStartupScript(this.GetType(), "UpdateSuccess", successScript);
        }
    }
}