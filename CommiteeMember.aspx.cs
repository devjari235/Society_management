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

        

            protected void btnSave_Click(object sender, EventArgs e)
            {
               
            }
        }
    }
