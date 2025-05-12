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
    public partial class ChangePassOtp : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
                SqlConnection con = new SqlConnection(strcon);
                con.Open();
                string Query = "Update tblAdmin set password=@pass where admin_id=@id";
                SqlCommand cmd = new SqlCommand(Query, con);
                cmd.Parameters.AddWithValue("@pass", txtnewpass.Text);
                cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
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
                window.location = 'Login.aspx';
            });
            </script>";
            ClientScript.RegisterStartupScript(this.GetType(), "UpdateSuccess", successScript);
        }
    }
}