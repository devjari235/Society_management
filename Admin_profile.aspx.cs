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
        public void BindDetails()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select name,email,phone_no from tblAdmin where admin_id=@a_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@a_id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                name = reader["name"].ToString();
                email = reader["email"].ToString();
                ph = reader["phone_no"].ToString();
            }
            txtname.Text = name;
            txtemail.Text = email;
            txtphone.Text = ph;

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
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fuUpload.HasFile)
            {
                string ext = Path.GetExtension(fuUpload.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                {

                    string fileName = Path.GetFileName(fuUpload.PostedFile.FileName);
                    string filePath = "~/Profile/" + fileName;
                    fuUpload.SaveAs(Server.MapPath(filePath));
                    imgProfile.ImageUrl = filePath;
                    int id = Convert.ToInt32(Session["A_id"]);
                    string Query = "Update tblAdmin set Profile_picture=@profile where admin_id=@id";
                    SqlConnection con = new SqlConnection(strcon);
                    con.Open();
                    SqlCommand cmd = new SqlCommand(Query, con);
                    cmd.Parameters.AddWithValue("@profile", filePath);
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.ExecuteNonQuery();
                    con.Close();

                }
                
                Response.Write("<script>alert('File is Update Successfully.');</script>");
            }
            else
            {
                Response.Write("<script>alert('Please select a file to upload.');</script>");
            }

        }
    }
}
