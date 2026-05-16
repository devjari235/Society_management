using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;

namespace Society_management
{
    public partial class Owner_Membr : System.Web.UI.Page
    {
        string connStr = WebConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int ownerId;
                    if (int.TryParse(Request.QueryString["id"], out ownerId))
                    {
                        BindGrid(ownerId);
                    }
                   
                }
            }
        }

        public void BindGrid(int ownerId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT Member_name, Email, Phone_no, Age, Gender, Relationship FROM tblFamilyMember WHERE Owner_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", ownerId);
                    using (SqlDataAdapter ad = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        ad.Fill(dt);

                        // Conditional Presentation Layout Control Flow
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            gvDisplay.DataSource = dt;
                            gvDisplay.DataBind();

                            pnlEmpty.Visible = false;
                            phDataContent.Visible = true;
                        }
                        else
                        {
                            pnlEmpty.Visible = true;
                            phDataContent.Visible = false;
                        }
                    }
                }
            }
        }
    }
}