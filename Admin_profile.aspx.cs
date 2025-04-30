using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Society_management
{
    public partial class Admin_profile : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDetails();
            }
        }
        string name;
        string email;
        string ph;
        string img;

        public void BindDetails()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT name, email, phone_no, Profile_picture FROM tblAdmin WHERE admin_id = @a_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@a_id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                name = reader["name"].ToString();
                email = reader["email"].ToString();
                ph = reader["phone_no"].ToString();
                img = reader["Profile_picture"].ToString();

                txtname.Text = name;
                txtemail.Text = email;
                txtphone.Text = ph;

                if (!string.IsNullOrEmpty(img))
                {
                 imgPhoto.ImageUrl = img;
                }
                else
                {
                    imgPhoto.ImageUrl = "https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2023/08/tiktok-no-profile-picture.png";
                }
            }

            reader.Close();
            con.Close();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Update tblAdmin set name=@name, email=@mail, phone_no=@ph where admin_id=@id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@name", txtname.Text);
            cmd.Parameters.AddWithValue("@mail", txtemail.Text);
            cmd.Parameters.AddWithValue("@ph", txtphone.Text);
            cmd.Parameters.AddWithValue("@id", Session["A_id"].ToString());
            cmd.ExecuteNonQuery();
            con.Close();

            string successScript = @"
        <script>
            Swal.fire({
                icon: 'success',
                title: 'Details Updated',
                text: 'Your profile details have been successfully updated.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'Admin_profile.aspx';
            });
        </script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSuccess", successScript, false);
        }
       
    }
}
