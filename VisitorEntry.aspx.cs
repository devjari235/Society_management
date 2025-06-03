using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class VisitorEntry : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SocietyID();
                BindBlockName();
                
            }
        }
        int id;
        public void SocietyID()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select Society_id from tblSociety where admin_id=@a_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@a_id", Session["A_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                id = Convert.ToInt32(reader["Society_id"]);
            }

        }
        public void BindBlockName()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select * from tblBlock where Society_id=@id Order by Block_name";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", id);
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            ddlBlock.DataSource = dt;
            ddlBlock.DataBind();
            ddlBlock.DataTextField = "Block_name";
            ddlBlock.DataValueField = "Block_id";
            ddlBlock.DataBind();
            con.Close();
            ddlBlock.Items.Insert(0, new ListItem("-- Select Block --"));
        }
        private void LoadSocietyMembers()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string query = "SELECT \r\n    u.User_id, \r\n    u.User_name + ' - ' + CAST(f.Flate_no AS VARCHAR) AS DisplayName \r\nFROM \r\n    tblUser u \r\nJOIN \r\n    tblOwner o ON o.Owner_id = u.Owner_id \r\nJOIN \r\n    tblFlat f ON f.Flate_id = o.Flate_id where o.Block_id = @B_id ORDER BY \r\n    u.User_name;\r\n";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("B_id", ddlBlock.SelectedValue);
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                DataTable dt = new DataTable();

                adapter.Fill(dt);

                ddlMembers.DataSource = dt;
                ddlMembers.DataTextField = "DisplayName";
                ddlMembers.DataValueField = "User_id";
                ddlMembers.DataBind();

                ddlMembers.Items.Insert(0, new ListItem("-- Select Member --", "0"));
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            string query = "INSERT INTO Visitors (Name, ContactNumber, VisitPurpose, User_id) VALUES (@Name, @ContactNumber, @VisitPurpose, @MemberID)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Name", txtVisitorName.Text.Trim());
                command.Parameters.AddWithValue("@ContactNumber", txtContactNumber.Text.Trim());
                command.Parameters.AddWithValue("@VisitPurpose", txtVisitPurpose.Text.Trim());
                command.Parameters.AddWithValue("@MemberID", ddlMembers.SelectedValue);

                    connection.Open();
                    command.ExecuteNonQuery();
                string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Visitor Entry successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'VisitorEntry.aspx';
            });";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);

                ClearForm();

            }
        }
        private void ClearForm()
        {
            txtVisitorName.Text = "";
            txtContactNumber.Text = "";
            txtVisitPurpose.Text = "";
            ddlMembers.SelectedIndex = 0;
        }

        protected void ddlBlock_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadSocietyMembers();
        }
    }
}
