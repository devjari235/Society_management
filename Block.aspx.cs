using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                BindGridView();

                // Add mode
                btnAdd.Visible = true;
                btnUpdate.Visible = false;

                // Edit mode
                if (Request.QueryString["id"] != null)
                {
                    hfBlockId.Value = Request.QueryString["id"];
                    LoadBlockData(hfBlockId.Value);

                    btnAdd.Visible = false;
                    btnUpdate.Visible = true;
                }
            }
        }

        // Bind society dropdown
        private void BindSocietyName()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT Society_id, Society_name FROM tblSociety ORDER BY Society_name";

                using (SqlDataAdapter sda = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    ddlSociety.DataSource = dt;
                    ddlSociety.DataTextField = "Society_name";
                    ddlSociety.DataValueField = "Society_id";
                    ddlSociety.DataBind();

                    ddlSociety.Items.Insert(0, new ListItem("-- Select Society Name --", ""));
                }
            }
        }

        // Bind GridView
        private void BindGridView()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
                    SELECT
                        b.Block_id,
                        b.Block_name,
                        b.Location,
                        b.Society_id,
                        s.Society_name
                    FROM tblBlock b
                    INNER JOIN tblSociety s ON b.Society_id = s.Society_id
                    ORDER BY b.Block_id DESC";

                using (SqlDataAdapter sda = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    gvBlock.DataSource = dt;
                    gvBlock.DataBind();
                }
            }
        }

        protected void gvBlock_PreRender(object sender, EventArgs e)
        {
            if (gvBlock.Rows.Count > 0)
            {
                gvBlock.UseAccessibleHeader = true;
                gvBlock.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void gvBlock_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvBlock.SelectedDataKey == null)
                return;

            string blockId = Convert.ToString(gvBlock.SelectedDataKey.Value);
            if (string.IsNullOrWhiteSpace(blockId))
                return;

            hfBlockId.Value = blockId;

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM tblBlock WHERE Block_id = @BlockId", conn))
            {
                cmd.Parameters.AddWithValue("@BlockId", blockId);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        txtBname.Text = dr["Block_name"].ToString();

                        if (ddlLocation.Items.FindByValue(dr["Location"].ToString()) != null)
                            ddlLocation.SelectedValue = dr["Location"].ToString();

                        if (ddlSociety.Items.FindByValue(dr["Society_id"].ToString()) != null)
                            ddlSociety.SelectedValue = dr["Society_id"].ToString();
                    }
                }
            }

            btnAdd.Visible = false;
            btnUpdate.Visible = true;
        }

        // Add new block
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtBname.Text))
            {
                ShowAlert("Please enter Block Name.", "error");
                return;
            }

            if (string.IsNullOrEmpty(ddlLocation.SelectedValue))
            {
                ShowAlert("Please select Location.", "error");
                return;
            }

            if (string.IsNullOrEmpty(ddlSociety.SelectedValue))
            {
                ShowAlert("Please select Society Name.", "error");
                return;
            }

            string query = @"
                INSERT INTO tblBlock
                (
                    Block_name,
                    Location,
                    Society_id
                )
                VALUES
                (
                    @BlockName,
                    @Location,
                    @SocietyId
                )";

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@BlockName", txtBname.Text.Trim());
                cmd.Parameters.AddWithValue("@Location", ddlLocation.SelectedValue);
                cmd.Parameters.AddWithValue("@SocietyId", ddlSociety.SelectedValue);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ShowAlertAndRedirect("Block inserted successfully!", "success", "Block.aspx");
        }

        // Update existing block
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfBlockId.Value))
            {
                ShowAlert("Please select a block to update.", "error");
                return;
            }

            string query = @"
                UPDATE tblBlock
                SET
                    Block_name = @BlockName,
                    Location = @Location,
                    Society_id = @SocietyId
                WHERE Block_id = @BlockId";

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@BlockName", txtBname.Text.Trim());
                cmd.Parameters.AddWithValue("@Location", ddlLocation.SelectedValue);
                cmd.Parameters.AddWithValue("@SocietyId", ddlSociety.SelectedValue);
                cmd.Parameters.AddWithValue("@BlockId", hfBlockId.Value);

                conn.Open();
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    ShowAlertAndRedirect("Block updated successfully!", "success", "Block.aspx");
                }
                else
                {
                    ShowAlert("No block found to update.", "error");
                }
            }
        }

        // Load existing block data
        private void LoadBlockData(string blockId)
        {
            string query = "SELECT * FROM tblBlock WHERE Block_id = @BlockId";

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@BlockId", blockId);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        txtBname.Text = dr["Block_name"].ToString();

                        if (ddlLocation.Items.FindByValue(dr["Location"].ToString()) != null)
                            ddlLocation.SelectedValue = dr["Location"].ToString();

                        if (ddlSociety.Items.FindByValue(dr["Society_id"].ToString()) != null)
                            ddlSociety.SelectedValue = dr["Society_id"].ToString();
                    }
                }
            }
        }

        // SweetAlert helper
        private void ShowAlert(string message, string icon)
        {
            string script = $@"
                Swal.fire({{
                    text: '{message.Replace("'", "\\'")}',
                    icon: '{icon}',
                    confirmButtonText: 'OK'
                }});";

            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }

        // SweetAlert with redirect
        private void ShowAlertAndRedirect(string message, string icon, string redirectUrl)
        {
            string script = $@"
                Swal.fire({{
                    text: '{message.Replace("'", "\\'")}',
                    icon: '{icon}',
                    confirmButtonText: 'OK'
                }}).then(function() {{
                    window.location = '{redirectUrl}';
                }});";

            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }
    }
}