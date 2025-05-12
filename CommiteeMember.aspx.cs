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
    public partial class CommiteeMember : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                BindUsers();

            }
        }

            string connectionString = "MyDb";


        public void BindUsers()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select User_name,User_id from tblUser Order by User_name";
            SqlDataAdapter sda = new SqlDataAdapter(Query, con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            ddlUser.DataSource = dt;
            //ddlUser.DataBind();
            ddlUser.DataTextField = "User_name";
            ddlUser.DataValueField = "User_id";
            ddlUser.DataBind();
            con.Close();
            ddlUser.Items.Insert(0, new ListItem("-- Select User Name --"));
        }

        string email;
        string contactNo;
        public void BindData()
        {
            int id = Convert.ToInt32(ddlUser.SelectedValue);
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select Email,Phone_no from tblUser where User_id=@id";
            SqlCommand cmd=new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", id);  
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                email = reader["Email"].ToString();
                contactNo = reader["Phone_no"].ToString();
            }
            txtEmail.Text = email;
            txtContactNo.Text = contactNo;
        }

        string block;
        string flat;
        public void BindBlock()
        {
            int id = Convert.ToInt32(ddlUser.SelectedValue);
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = "Select b.Block_name,f.Flate_no from tblBlock b join tblFlat f on b.Block_id=f.Block_id join tblOwner o on f.Flate_id=o.Flate_id and b.Block_id=o.Block_id join tblFamilyMember fam on o.Owner_id=fam.Owner_id join tblUser u on o.Owner_id=u.Owner_id where u.User_id=@id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@id", id);
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                block = reader["Block_name"].ToString();
                flat = reader["Flate_no"].ToString();
            }
            txtBlockName.Text = block;
            txtFlatNo.Text = flat;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
               
        }

        protected void ddlUser_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindData();
            BindBlock();
        }
    }
    }
