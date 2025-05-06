using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace Society_management
{
    public partial class Owner : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SocietyID();
                BindBlockName();
                txtdate.Text = DateTime.Now.ToString("dd-MM-yyyy");
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

        protected void ddlBlock_SelectedIndexChanged(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(strcon);

            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * \r\nFROM tblFlat \r\nWHERE Block_id = @B_id\r\nAND Flate_id NOT IN (\r\n    SELECT Flate_id FROM tblOwner\r\n) ", conn);
            cmd.Parameters.AddWithValue("B_id", ddlBlock.SelectedValue);
            ddlFlat.DataSource = cmd.ExecuteReader();
            ddlFlat.DataTextField = "Flate_no";
            ddlFlat.DataValueField = "Flate_id";
            ddlFlat.DataBind();
            conn.Close();
            ddlFlat.Items.Insert(0, new ListItem("-- Select Flat --"));
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string name = txtname.Text;
            string no = txtnumber.Text;
            string block = ddlBlock.SelectedValue;
            string flat = ddlFlat.SelectedValue;
            string email = txtEmail.Text;
            string e_number = txtE_number.Text;
            string member = txtmember.Text;
            string date = txtdate.Text;
            string query = "insert into tblOwner values(@name,@no,@block,@flat,@email,@e_number,@member,@date)";
            SqlConnection conn = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("name", name);
            cmd.Parameters.AddWithValue("no", no);
            cmd.Parameters.AddWithValue("block", block);
            cmd.Parameters.AddWithValue("flat", flat);
            cmd.Parameters.AddWithValue("email", email);
            cmd.Parameters.AddWithValue("e_number", e_number);
            cmd.Parameters.AddWithValue("member", member);
            cmd.Parameters.AddWithValue("date", date);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Add successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'Owner.aspx';
            });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
        }

    }
}