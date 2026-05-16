using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

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

                // Show both buttons
                btnAdd.Visible = true;
                btnUpdate.Visible = true;

                // Bind society list
                BindGridView();

                // Load society data if admin_id is passed
                // Example: R_Society.aspx?admin_id=1
                if (Request.QueryString["admin_id"] != null)
                {
                    string adminId = Request.QueryString["admin_id"];

                    if (ddlAdmin.Items.FindByValue(adminId) != null)
                    {
                        ddlAdmin.SelectedValue = adminId;
                        LoadSocietyDataByAdmin(adminId);
                    }
                }
            }
        }

        // Bind admin dropdown
        private void BindAdminName()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "SELECT admin_id, name FROM tblAdmin ORDER BY name";

                using (SqlDataAdapter sda = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);

                    ddlAdmin.DataSource = dt;
                    ddlAdmin.DataTextField = "name";
                    ddlAdmin.DataValueField = "admin_id";
                    ddlAdmin.DataBind();

                    ddlAdmin.Items.Insert(0, new ListItem("-- Select Admin Name --", ""));
                }
            }
        }

        // Bind GridView with all society data
        private void BindGridView()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"
                    SELECT 
                        s.Society_id,
                        s.Society_name,
                        s.IncorporationDate,
                        s.RegistrationNumber,
                        s.Slogan,
                        s.RegistrationDate,
                        s.EntryDate,
                        s.Logo,
                        s.Address,
                        s.BuilderDetails,
                        a.name AS AdminName,
                        s.admin_id
                    FROM tblSociety s
                    INNER JOIN tblAdmin a ON s.admin_id = a.admin_id
                    ORDER BY s.Society_id DESC";

                using (SqlDataAdapter sda = new SqlDataAdapter(query, con))
                {
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    gvSociety.DataSource = dt;
                    gvSociety.DataBind();
                }
            }
        }

        protected void gvSociety_PreRender(object sender, EventArgs e)
        {
            // Make GridView render <thead> for DataTables
            if (gvSociety.Rows.Count > 0)
            {
                gvSociety.UseAccessibleHeader = true;
                gvSociety.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        // Add new society
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string adminId = ddlAdmin.SelectedValue;

            if (string.IsNullOrEmpty(adminId))
            {
                ShowAlert("Please select Admin Name.");
                return;
            }

            // Prevent duplicate entry for same admin
            if (SocietyExists(adminId))
            {
                ShowAlert("Society already exists for this Admin. Use Update button.");
                return;
            }

            string logoPath = SaveLogo();

            string query = @"
                INSERT INTO tblSociety
                (
                    Society_name,
                    IncorporationDate,
                    RegistrationNumber,
                    Slogan,
                    RegistrationDate,
                    EntryDate,
                    Logo,
                    Address,
                    BuilderDetails,
                    admin_id
                )
                VALUES
                (
                    @name,
                    @in_date,
                    @r_number,
                    @slogan,
                    @r_date,
                    @e_date,
                    @logo,
                    @add,
                    @builder,
                    @admin
                )";

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@name", txtSname.Text.Trim());
                cmd.Parameters.AddWithValue("@in_date", txtINCdate.Text.Trim());
                cmd.Parameters.AddWithValue("@r_number", txtNumber.Text.Trim());
                cmd.Parameters.AddWithValue("@slogan", txtSlogan.Text.Trim());
                cmd.Parameters.AddWithValue("@r_date", txtRDate.Text.Trim());
                cmd.Parameters.AddWithValue("@e_date", txtEntryDate.Text.Trim());
                cmd.Parameters.AddWithValue("@logo", logoPath);
                cmd.Parameters.AddWithValue("@add", txtAdd.Text.Trim());
                cmd.Parameters.AddWithValue("@builder", txtBuilderDetails.Text.Trim());
                cmd.Parameters.AddWithValue("@admin", adminId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ShowAlert("Society added successfully.");
            Response.Redirect("Block.aspx");
        }

        // Update society using admin_id
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // Logo is optional during update
            RequiredFieldValidator8.Enabled = false;

            // Prefer update by selected Society_id (GridView Select), else fallback to admin_id
            string societyId = (hfSocietyId != null) ? hfSocietyId.Value : "";
            string adminId = ddlAdmin.SelectedValue;

            if (string.IsNullOrEmpty(societyId) && string.IsNullOrEmpty(adminId))
            {
                ShowAlert("Please select a society from GridView or choose Admin Name.");
                return;
            }

            string logoPath = SaveLogo();
            string query;

            if (FuLogo.HasFile)
            {
                query = @"
                    UPDATE tblSociety SET
                        Society_name = @name,
                        IncorporationDate = @in_date,
                        RegistrationNumber = @r_number,
                        Slogan = @slogan,
                        RegistrationDate = @r_date,
                        EntryDate = @e_date,
                        Logo = @logo,
                        Address = @add,
                        BuilderDetails = @builder
                    WHERE " + (string.IsNullOrEmpty(societyId) ? "admin_id = @admin" : "Society_id = @id");
            }
            else
            {
                query = @"
                    UPDATE tblSociety SET
                        Society_name = @name,
                        IncorporationDate = @in_date,
                        RegistrationNumber = @r_number,
                        Slogan = @slogan,
                        RegistrationDate = @r_date,
                        EntryDate = @e_date,
                        Address = @add,
                        BuilderDetails = @builder
                    WHERE " + (string.IsNullOrEmpty(societyId) ? "admin_id = @admin" : "Society_id = @id");
            }

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@name", txtSname.Text.Trim());
                cmd.Parameters.AddWithValue("@in_date", txtINCdate.Text.Trim());
                cmd.Parameters.AddWithValue("@r_number", txtNumber.Text.Trim());
                cmd.Parameters.AddWithValue("@slogan", txtSlogan.Text.Trim());
                cmd.Parameters.AddWithValue("@r_date", txtRDate.Text.Trim());
                cmd.Parameters.AddWithValue("@e_date", txtEntryDate.Text.Trim());
                cmd.Parameters.AddWithValue("@add", txtAdd.Text.Trim());
                cmd.Parameters.AddWithValue("@builder", txtBuilderDetails.Text.Trim());
                cmd.Parameters.AddWithValue("@admin", adminId);
                cmd.Parameters.AddWithValue("@id", societyId);

                if (FuLogo.HasFile)
                {
                    cmd.Parameters.AddWithValue("@logo", logoPath);
                }

                conn.Open();
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    ShowAlertAndRedirect("Society updated successfully.", "Block.aspx");
                }
                else
                {
                    ShowAlert("Update failed.");
                }
            }
        }

        protected void btnGoBlock_Click(object sender, EventArgs e)
        {
            Response.Redirect("Block.aspx");
        }

        // GridView Select -> fill form for update
        protected void gvSociety_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvSociety.SelectedDataKey == null)
                return;

            string societyId = Convert.ToString(gvSociety.SelectedDataKey.Values["Society_id"]);
            if (string.IsNullOrWhiteSpace(societyId))
                return;

            hfSocietyId.Value = societyId;

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT
                    Society_id,
                    Society_name,
                    IncorporationDate,
                    RegistrationNumber,
                    Slogan,
                    RegistrationDate,
                    EntryDate,
                    Logo,
                    Address,
                    BuilderDetails,
                    admin_id
                FROM tblSociety
                WHERE Society_id = @id", con))
            {
                cmd.Parameters.AddWithValue("@id", societyId);
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (!dr.Read())
                    {
                        ShowAlert("Selected society not found.");
                        return;
                    }

                    txtSname.Text = Convert.ToString(dr["Society_name"]);
                    txtINCdate.Text = Convert.ToString(dr["IncorporationDate"]);
                    txtNumber.Text = Convert.ToString(dr["RegistrationNumber"]);
                    txtSlogan.Text = Convert.ToString(dr["Slogan"]);
                    txtRDate.Text = Convert.ToString(dr["RegistrationDate"]);
                    txtEntryDate.Text = Convert.ToString(dr["EntryDate"]);
                    txtAdd.Text = Convert.ToString(dr["Address"]);
                    txtBuilderDetails.Text = Convert.ToString(dr["BuilderDetails"]);

                    string adminId = Convert.ToString(dr["admin_id"]);
                    if (!string.IsNullOrEmpty(adminId) && ddlAdmin.Items.FindByValue(adminId) != null)
                        ddlAdmin.SelectedValue = adminId;

                    string logo = Convert.ToString(dr["Logo"]);
                    if (!string.IsNullOrWhiteSpace(logo))
                    {
                        imgLogoPreview.ImageUrl = logo;
                        imgLogoPreview.Visible = true;
                    }
                    else
                    {
                        imgLogoPreview.Visible = false;
                        imgLogoPreview.ImageUrl = "";
                    }
                }
            }

            // Logo not required during update
            RequiredFieldValidator8.Enabled = false;
        }

        // Check if society exists for selected admin
        private bool SocietyExists(string adminId)
        {
            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT COUNT(*) FROM tblSociety WHERE admin_id = @admin", conn))
            {
                cmd.Parameters.AddWithValue("@admin", adminId);

                conn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());

                return count > 0;
            }
        }

        // Save uploaded logo and return path
        private string SaveLogo()
        {
            string logoPath = "";

            if (FuLogo.HasFile)
            {
                string fileName = Path.GetFileName(FuLogo.FileName);
                string folderPath = Server.MapPath("~/Logo/");

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                FuLogo.SaveAs(Path.Combine(folderPath, fileName));
                logoPath = "~/Logo/" + fileName;
            }

            return logoPath;
        }

        // Load society data by admin_id
        private void LoadSocietyDataByAdmin(string adminId)
        {
            string query = "SELECT * FROM tblSociety WHERE admin_id = @admin";

            using (SqlConnection conn = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@admin", adminId);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        txtSname.Text = dr["Society_name"].ToString();
                        txtINCdate.Text = dr["IncorporationDate"].ToString();
                        txtNumber.Text = dr["RegistrationNumber"].ToString();
                        txtSlogan.Text = dr["Slogan"].ToString();
                        txtRDate.Text = dr["RegistrationDate"].ToString();
                        txtEntryDate.Text = dr["EntryDate"].ToString();
                        txtAdd.Text = dr["Address"].ToString();
                        txtBuilderDetails.Text = dr["BuilderDetails"].ToString();

                        if (ddlAdmin.Items.FindByValue(dr["admin_id"].ToString()) != null)
                        {
                            ddlAdmin.SelectedValue = dr["admin_id"].ToString();
                        }
                    }
                }
            }
        }

        // Load society when admin changes
        protected void ddlAdmin_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlAdmin.SelectedValue))
            {
                LoadSocietyDataByAdmin(ddlAdmin.SelectedValue);
            }
        }

        // Show alert message
        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                "alert('" + message.Replace("'", "\\'") + "');",
                true);
        }

        private void ShowAlertAndRedirect(string message, string url)
        {
            string safeMsg = message.Replace("'", "\\'");
            string safeUrl = url.Replace("'", "\\'");
            ScriptManager.RegisterStartupScript(
                this,
                this.GetType(),
                Guid.NewGuid().ToString(),
                "alert('" + safeMsg + "'); window.location='" + safeUrl + "';",
                true);
        }
    }
}