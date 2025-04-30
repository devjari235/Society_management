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
    public partial class Flat : System.Web.UI.Page
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
            SqlCommand cmd=new SqlCommand(Query, con);
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

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string Fno = txtFno.Text;
            string Floor = txtFloor.Text;
            string F_type = ddlType.SelectedValue;
            string sqft = txtsqft.Text;
            string status = ddlstatus.SelectedValue;
            string mentanance=txtMentanance.Text;
            string block = ddlBlock.SelectedValue;
            string query = "insert into tblFlat values(@fno,@floor,@type,@sqft,@status,@mentanance,@block)";
            SqlConnection conn = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("fno", Fno);
            cmd.Parameters.AddWithValue("floor", Floor);
            cmd.Parameters.AddWithValue("type", F_type);
            cmd.Parameters.AddWithValue("sqft", sqft);
            cmd.Parameters.AddWithValue("status", status);
            cmd.Parameters.AddWithValue("mentanance", mentanance);
            cmd.Parameters.AddWithValue("block", block);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Flat Add successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'Flat.aspx';
            });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
        }
    }
}