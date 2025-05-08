using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class MyFlat : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                OwnerID();
                LoadDetails(id);
            }
        }

        int id;
        public void OwnerID()
        {
            SqlConnection con = new SqlConnection(connStr);
            con.Open();
            string Query = "Select Owner_id from tblUser where User_id=@u_id";
            SqlCommand cmd = new SqlCommand(Query, con);
            cmd.Parameters.AddWithValue("@u_id", Session["U_id"].ToString());
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                id = Convert.ToInt32(reader["Owner_id"]);
            }

        }


        private void LoadDetails(int ownerId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT 
                            o.Owner_name,
                            o.Contact_no,
                            o.Emergency_Number,
                            o.Total_member,
                            o.Allotment_Date,
                            f.Flate_no,
                            f.Floor,
                            f.Flat_type,
                            f.Mentanance,
                            b.Block_name
                         FROM tblOwner o
                         JOIN tblFlat f ON o.Flate_id = f.Flate_id
                         JOIN tblBlock b ON o.Block_id = b.Block_id
                         WHERE o.Owner_id = @OwnerId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@OwnerId", ownerId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblName.Text = reader["Owner_name"].ToString();
                    lblContact.Text = reader["Contact_no"].ToString();
                    lblEmergency.Text = reader["Emergency_Number"].ToString();
                    lblMembers.Text = reader["Total_member"].ToString();
                    lblFlatNo.Text = reader["Flate_no"].ToString();
                    lblFloor.Text = reader["Floor"].ToString();
                    lblFlatType.Text = reader["Flat_type"].ToString();
                    lblBlock.Text = reader["Block_name"].ToString();
                    lblMaintenance.Text = reader["Mentanance"].ToString();
                    lblAllotmentDate.Text = reader["Allotment_Date"].ToString();
                    lblBlockTop.Text = reader["Block_name"].ToString();
                    lblFlatTop.Text= reader["Flate_no"].ToString();
                }
            }
        }

        protected void btn1_Click(object sender, EventArgs e)
        {
            Response.Redirect("Family_member.aspx");
        }
    }
}