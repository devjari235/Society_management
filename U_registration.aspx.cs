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
using Quartz;

namespace Society_management
{
    public partial class U_registration : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }
        public bool RegisterFromMember()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                string query = "SELECT Member_name, Email, Phone_no, Age, Gender, Relationship, Owner_id FROM tblFamilyMember";
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string dbEmail = reader["Email"].ToString().Trim();
                    string dbPhone = reader["Phone_no"].ToString().Trim();
                    string dbName = reader["Member_name"].ToString().Trim();

                    string inputEmail = txtEmail.Text.Trim();
                    string inputPhone = txtPhone.Text.Trim();
                    string inputName = txtName.Text.Trim();
                    if (IsUserAlreadyRegistered(inputEmail, inputPhone))
                    {
                        reader.Close();
                        ShowAlreadyRegisteredAlert();
                        return false;
                    }

                    if (inputEmail.Equals(dbEmail, StringComparison.OrdinalIgnoreCase) &&
                        inputPhone.Equals(dbPhone) &&
                        inputName.Equals(dbName, StringComparison.OrdinalIgnoreCase))
                    {
                        int ownerID = Convert.ToInt32(reader["Owner_id"]);
                        string age = reader["Age"].ToString();
                        string gender = reader["Gender"].ToString();

                        reader.Close();

                        string filename = "";
                        if (filePhoto.HasFile)
                        {
                            filename = Path.GetFileName(filePhoto.FileName);
                            filePhoto.SaveAs(Server.MapPath("~/Profile/" + filename));
                        }

                        using (SqlConnection conn = new SqlConnection(strcon))
                        {
                            string insertQuery = "INSERT INTO tblUser (User_name, Phone_no, Email, Gender, Age, Marital_Status, Photo, Password, Owner_id) VALUES (@Name, @ph, @Email, @gen, @age, @mstatus, @photo, @password, @owner)";
                            SqlCommand cmdInsert = new SqlCommand(insertQuery, conn);
                            cmdInsert.Parameters.AddWithValue("@Name", inputName);
                            cmdInsert.Parameters.AddWithValue("@Email", inputEmail);
                            cmdInsert.Parameters.AddWithValue("@password", txtPassword.Text.Trim());
                            cmdInsert.Parameters.AddWithValue("@ph", inputPhone);
                            cmdInsert.Parameters.AddWithValue("@gen", gender);
                            cmdInsert.Parameters.AddWithValue("@age", age);
                            cmdInsert.Parameters.AddWithValue("@mstatus", ddlMarital.SelectedValue);
                            if (!string.IsNullOrEmpty(filename))
                                cmd.Parameters.AddWithValue("@photo", "~/Profile/" + filename);
                            else
                                cmd.Parameters.AddWithValue("@photo", DBNull.Value);
                            cmdInsert.Parameters.AddWithValue("@owner", ownerID);

                            conn.Open();
                            cmdInsert.ExecuteNonQuery();
                        }

                        Response.Redirect("U_login.aspx");
                        return true;

                    }
                }

                reader.Close();
            }

            return false;
        }



        public bool RegisterFromOwner()
        {
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
                            if (!string.IsNullOrEmpty(filename))
                                cmd.Parameters.AddWithValue("@photo", "~/Profile/" + filename);
                            else
                                cmd.Parameters.AddWithValue("@photo", DBNull.Value);
                            cmd.Parameters.AddWithValue("@user", ID);

                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }

                        Response.Redirect("U_login.aspx");
                        return true;
                    }
                }

                reader.Close();
            }

            return false;
        }



        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string inputEmail = txtEmail.Text.Trim();
            string inputPhone = txtPhone.Text.Trim();
            if (IsUserAlreadyRegistered(inputEmail, inputPhone))
            {
                ShowAlreadyRegisteredAlert();
                return;
            }
            bool registered = RegisterFromOwner() || RegisterFromMember();

            if (!registered)
            {
                string script = @"
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Oops...',
                    text: 'Name, Email, or Phone number does not match any records.',
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'Try Again'
                });
            </script>";
                ClientScript.RegisterStartupScript(this.GetType(), "RegisterError", script);
            }
        }
        private bool IsUserAlreadyRegistered(string email, string phone)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT COUNT(*) FROM tblUser WHERE Email = @Email OR Phone_no = @Phone";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Phone", phone);

                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
        private void ShowAlreadyRegisteredAlert()
        {
            string script = @"
            <script>
                Swal.fire({
                    icon: 'info',
                    title: 'Already Registered',
                    text: 'You are already registered. Please login.',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'Go to Login'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = 'U_login.aspx';
                    }
                });
            </script>";
            ClientScript.RegisterStartupScript(this.GetType(), "AlreadyRegistered", script);
        }


    }
}