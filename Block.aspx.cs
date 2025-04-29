using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace Society_management
{
    public partial class Block : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSocietyName();
            }
        }
        public void BindSocietyName()
        {
            SqlConnection con=new SqlConnection(strcon);
            con.Open();
            string Query = "Select * from tblSociety Order by Society_name";
            SqlDataAdapter sda = new SqlDataAdapter(Query,con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            ddlSociety.DataSource = dt;
            ddlSociety.DataBind();
            ddlSociety.DataTextField = "Society_name";
            ddlSociety.DataValueField = "Society_id";
            ddlSociety.DataBind();
            con.Close();
            ddlSociety.Items.Insert(0, new ListItem("-- Select Society Name --"));
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string name = txtBname.Text;
            string locat = ddlLocation.SelectedValue;
            string Sname = ddlSociety.SelectedValue;
            string query = "insert into tblBlock values(@Name,@locat,@Sname)";
            SqlConnection conn = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@locat", locat);
            cmd.Parameters.AddWithValue("@Sname", Sname);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Block inserted successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'Block.aspx';
            });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
        }
    }
}