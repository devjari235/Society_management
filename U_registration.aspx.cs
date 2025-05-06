using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;
using System.Xml.Linq;
using System.Windows.Forms;

namespace Society_management
{
    public partial class U_registration : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void BindDetails()
        {
            bool isMatched = false;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string Query = "SELECT Owner_name, Email_id, Contact_no, Owner_id FROM tblOwner";
                SqlCommand cmds = new SqlCommand(Query, con);
                SqlDataReader reader = cmds.ExecuteReader();

                while (reader.Read())
                {
                    string dbEmail = reader["Email_id"].ToString().Trim();
                    string dbPhone = reader["Contact_no"].ToString().Trim();
                    string dbName = reader["Owner_name"].ToString().Trim();

                    string inputEmail = txtEmail.Text.Trim();
                    string inputPhone = txtPhone.Text.Trim();
                    string inputName = txtName.Text.Trim();

                    if (inputEmail.Equals(dbEmail, StringComparison.OrdinalIgnoreCase) &&
                        inputPhone.Equals(dbPhone) &&
                        inputName.Equals(dbName, StringComparison.OrdinalIgnoreCase))
                    {
                        isMatched = true;
                        int ID = Convert.ToInt32(reader["Owner_id"]);
                        reader.Close();

                        string filename = "";
                        if (filePhoto.HasFile)
                        {
                            filename = Path.GetFileName(filePhoto.FileName);
                            filePhoto.SaveAs(Server.MapPath("~/Profile/" + filename));
                        }

                        using (SqlConnection conn = new SqlConnection(strcon))
                        {
                            string insertQuery = "INSERT INTO tblUser (User_name, Phone_no, Email, Gender, Age, Marital_Status, Photo, Password, Owner_id) VALUES (@Name, @ph, @Email, @gen, @age, @mstatus, @photo, @password, @user)";
                            SqlCommand cmd = new SqlCommand(insertQuery, conn);
                            cmd.Parameters.AddWithValue("@Name", inputName);
                            cmd.Parameters.AddWithValue("@Email", inputEmail);
                            cmd.Parameters.AddWithValue("@password", txtPassword.Text.Trim());
                            cmd.Parameters.AddWithValue("@ph", inputPhone);
                            cmd.Parameters.AddWithValue("@gen", ddlGender.SelectedValue);
                            cmd.Parameters.AddWithValue("@age", txtAge.Text.Trim());
                            cmd.Parameters.AddWithValue("@mstatus", ddlMarital.SelectedValue);
                            cmd.Parameters.AddWithValue("@photo", filename);
                            cmd.Parameters.AddWithValue("@user", ID);

                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }

                        Response.Redirect("U_login.aspx");
                        return;
                    }
                }

                reader.Close();
            }

            if (!isMatched)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Name, Email, or Phone number does not match owner record.');", true);
            }
        }


        protected void btnRegister_Click(object sender, EventArgs e)
        {
            BindDetails();
        }
    }
}