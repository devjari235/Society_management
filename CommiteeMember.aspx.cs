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



        public void BindUsers()
        {
            SqlConnection con = new SqlConnection(strcon);
            con.Open();
            string Query = @"SELECT User_name, User_id 
                            FROM tblUser 
                            WHERE User_id NOT IN (SELECT User_id FROM tblCommitteeMember where Status!='Past') 
                            ORDER BY User_name";
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
            string user = ddlUser.SelectedValue;
            string blockName = txtBlockName.Text;
            string flatNo = txtFlatNo.Text;
            string email = txtEmail.Text;
            string phoneNo = txtContactNo.Text;
            string designation = ddlDesignation.SelectedItem.Text;
            DateTime fromDate = Convert.ToDateTime(txtFromDate.Text).Date;
            DateTime toDate = Convert.ToDateTime(txtToDate.Text).Date;
            string role = ddlRole.SelectedValue;

            // Determine current status based on date
            string status;
            DateTime today = DateTime.Today;
            if (today >= fromDate && today <= toDate)
                status = "Current";
            else
                status = "Past";

            // Connection string from Web.config
            string connStr = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // First: Optional - Update all statuses based on current date
                string updateStatusQuery = @"
            UPDATE tblCommitteeMember
            SET Status = CASE 
                WHEN CAST(GETDATE() AS DATE)BETWEEN From_Date AND To_date THEN 'Current'
                WHEN CAST(GETDATE() AS DATE) > To_date THEN 'Past'
                ELSE Status
            END";

                using (SqlCommand updateCmd = new SqlCommand(updateStatusQuery, conn))
                {
                    updateCmd.ExecuteNonQuery();
                }

                // Second: Insert the new committee member
                string insertQuery = @"
            INSERT INTO tblCommitteeMember 
            (User_id, Block_name, Flat_no, Email, Phone_no, Designation, From_Date, To_date, Role, Status) 
            VALUES 
            (@User_id, @Block_name, @Flat_no, @Email, @Phone_no, @Designation, @From_Date, @To_date, @Role, @Status)";

                using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                {
                    insertCmd.Parameters.AddWithValue("@User_id", user);
                    insertCmd.Parameters.AddWithValue("@Block_name", blockName);
                    insertCmd.Parameters.AddWithValue("@Flat_no", flatNo);
                    insertCmd.Parameters.AddWithValue("@Email", email);
                    insertCmd.Parameters.AddWithValue("@Phone_no", phoneNo);
                    insertCmd.Parameters.AddWithValue("@Designation", designation);
                    insertCmd.Parameters.AddWithValue("@From_Date", fromDate);
                    insertCmd.Parameters.AddWithValue("@To_date", toDate);
                    insertCmd.Parameters.AddWithValue("@Role", role);
                    insertCmd.Parameters.AddWithValue("@Status", status);

                    insertCmd.ExecuteNonQuery();
                }

                conn.Close();
                string script = @"
            Swal.fire({
                title: 'Success!',
                text: 'Committee Member Add successfully!',
                icon: 'success',
                confirmButtonText: 'OK'
            }).then(function() {
                window.location = 'CommiteeMember.aspx';
            });";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessMessage", script, true);
            }

        }

        protected void ddlUser_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindData();
            BindBlock();
        }
    }
    }
