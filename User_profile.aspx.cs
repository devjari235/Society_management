using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class User_profile : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDetails();
            }
            //if (Request.Form["__EVENTTARGET"] == profileImageUpload.ClientID && profileImageUpload.HasFile)
            //{
            //    UpdateProfilePicture();
            //}
            if (profileImageUpload.HasFile)
            {
                UpdateProfilePicture();
            }
        }
        string name;
        string email;
        string ph;
        string gen;
        string age;
        string marite;
        string img;

        public void BindDetails()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "SELECT User_name, Phone_no,Email,Gender,Age,Marital_Status,Photo FROM tblUser WHERE User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                name = reader["User_name"].ToString();
                email = reader["Email"].ToString();
                ph = reader["Phone_no"].ToString();
                gen = reader["Gender"].ToString();
                age = reader["Age"].ToString() ;
                marite = reader["Marital_Status"].ToString();
                img = reader["Photo"].ToString();

                txtname.Text = name;
                txtemail.Text = email;
                txtphone.Text = ph;
                txtAge.Text = age;
                txtmarite.Text = marite;
                txtGender.Text = gen;
                if (!string.IsNullOrEmpty(img))
                {
                    imgPhoto.ImageUrl = img;
                }
                else
                {
                    imgPhoto.ImageUrl = "~/Profile/Default.png";
                }
            }

            reader.Close();
            con.Close();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Update tblUser set User_name=@name, Email=@mail, Phone_no=@ph,Gender=@gen,Age=@age,Marital_Status=@marite where  User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@name", txtname.Text);
            cmd.Parameters.AddWithValue("@mail", txtemail.Text);
            cmd.Parameters.AddWithValue("@ph", txtphone.Text);
            cmd.Parameters.AddWithValue("@gen", txtGender.Text);
            cmd.Parameters.AddWithValue("@age", txtAge.Text);
            cmd.Parameters.AddWithValue("@marite", txtmarite.Text);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
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
                window.location = 'User_profile.aspx';
            });
        </script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSuccess", successScript, false);
        }


        private void UpdateProfilePicture()
        {
            string filename = Path.GetFileName(profileImageUpload.FileName);
            profileImageUpload.SaveAs(Server.MapPath("~/Profile/" + filename));
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Update tblUser set Photo=@img where  User_id = @id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@img", "~/Profile/" + filename);
            cmd.Parameters.AddWithValue("@id", Session["U_id"].ToString());
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
                    window.location = 'User_profile.aspx';
                });
            </script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSuccess", successScript, false);
        }
    }

}