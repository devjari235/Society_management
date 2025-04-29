using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;
using System.Reflection;

namespace Society_management
{
    public partial class R_Society : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAdminName();
            }
        }
        public void BindAdminName()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select * from tblAdmin Order by name";
            SqlDataAdapter sda = new SqlDataAdapter(Query, con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            ddlAdmin.DataSource = dt;
            ddlAdmin.DataBind();
            ddlAdmin.DataTextField = "name";
            ddlAdmin.DataValueField = "admin_id";
            ddlAdmin.DataBind();
            con.Close();
            ddlAdmin.Items.Insert(0, new ListItem("-- Select Admin Name --"));
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string s_name = txtSname.Text;
            string In_date = txtINCdate.Text;
            string R_number = txtNumber.Text;
            string slogan = txtSlogan.Text;
            string R_date = txtRDate.Text;
            string E_date = txtEntryDate.Text;
            string logo = Path.GetFileName(FuLogo.FileName);
            FuLogo.SaveAs(Server.MapPath("~/Logo/" + logo));
            string Add = txtAdd.Text;
            string Builder = txtBuilderDetails.Text;
            string Admin = ddlAdmin.SelectedValue.ToString();
            string query = "insert into tblSociety values(@name,@in_date,@r_number,@slogan,@r_date,@e_date,@logo,@add,@builder,@admin)";
            SqlConnection conn = new SqlConnection(strcon);
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@name", s_name);
            cmd.Parameters.AddWithValue("@in_date", In_date);
            cmd.Parameters.AddWithValue("@r_number", R_number);
            cmd.Parameters.AddWithValue("@slogan", slogan);
            cmd.Parameters.AddWithValue("@r_date", R_date);
            cmd.Parameters.AddWithValue("@e_date", E_date);
            cmd.Parameters.AddWithValue("@logo", "~/Logo/" + logo);
            cmd.Parameters.AddWithValue("@add", Add);
            cmd.Parameters.AddWithValue("@builder", Builder);
            cmd.Parameters.AddWithValue("@admin", Admin);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            //Response.Write("<script>alert('Thank you For Sing up and go to Login')</script>");
            Response.Redirect("Block.aspx");
        }
    }
}