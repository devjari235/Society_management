using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML.Excel;
using iTextSharp.text;
using iTextSharp.text.pdf;
using WebListItem = System.Web.UI.WebControls.ListItem;

namespace Society_management
{
    public partial class AdminMaintenanceList : System.Web.UI.Page
    {
        private string ConnectionString =>
            ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

        private int AdminId =>
            Session["A_id"] != null ? Convert.ToInt32(Session["A_id"]) : 0;

        // ─────────────────────────────────────────────
        //  PAGE LOAD
        // ─────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadYears();
                LoadBlocks();
                BindAllData();
                CalculateTotals();
            }
        }

        // ─────────────────────────────────────────────
        //  LOAD YEARS
        // ─────────────────────────────────────────────
        private void LoadYears()
        {
            ddlYear.Items.Clear();
            ddlYear.Items.Add(new WebListItem("All Years", "0"));

            int currentYear = DateTime.Now.Year;
            for (int year = currentYear - 3; year <= currentYear + 3; year++)
                ddlYear.Items.Add(new WebListItem(year.ToString(), year.ToString()));

            ddlYear.SelectedValue = currentYear.ToString();
        }

        // ─────────────────────────────────────────────
        //  LOAD BLOCKS  (admin-scoped)
        // ─────────────────────────────────────────────
        private void LoadBlocks()
        {
            ddlBlock.Items.Clear();
            ddlBlock.Items.Add(new WebListItem("All Blocks", "0"));

            const string query = @"
                SELECT b.Block_id, b.Block_name
                FROM   tblBlock   b
                INNER JOIN tblSociety s ON b.Society_id = s.Society_id
                WHERE  s.admin_id = @AdminId
                ORDER  BY b.Block_name";

            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@AdminId", AdminId);
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                        ddlBlock.Items.Add(new WebListItem(
                            reader["Block_name"].ToString(),
                            reader["Block_id"].ToString()));
                }
            }
        }

        // ─────────────────────────────────────────────
        //  LOAD FLATS  (block-scoped)
        // ─────────────────────────────────────────────
        protected void ddlBlock_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadFlats();
        }

        private void LoadFlats()
        {
            ddlFlat.Items.Clear();
            ddlFlat.Items.Add(new WebListItem("All Flats", "0"));

            if (ddlBlock.SelectedValue == "0") return;

            const string query = @"
                SELECT Flate_id, Flate_no
                FROM   tblFlat
                WHERE  Block_id = @BlockId
                ORDER  BY Flate_no";

            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);
                con.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                        ddlFlat.Items.Add(new WebListItem(
                            reader["Flate_no"].ToString(),
                            reader["Flate_id"].ToString()));
                }
            }
        }

        // ─────────────────────────────────────────────
        //  BIND PAYMENTS  (admin-scoped + all filters)
        // ─────────────────────────────────────────────
        private void BindPayments()
        {
            // Base query — always restricted to this admin's society blocks
            string query = @"
                SELECT  mp.PaymentID,
                        u.User_name,
                        b.Block_name,
                        f.Flate_no,
                        mp.Amount,
                        mp.PaymentDate,
                        mp.Month,
                        mp.Year,
                        mp.PaymentMethod,
                        mp.TransactionID,
                        mp.Status
                FROM    MaintenancePayments mp
                INNER JOIN tblFlat    f ON mp.Flate_id  = f.Flate_id
                INNER JOIN tblBlock   b ON f.Block_id   = b.Block_id
                INNER JOIN tblSociety s ON b.Society_id = s.Society_id
                INNER JOIN tblUser    u ON mp.User_id   = u.User_id
                WHERE   s.admin_id = @AdminId";

            if (ddlMonth.SelectedValue != "0")         query += " AND mp.Month         = @Month";
            if (ddlYear.SelectedValue  != "0")         query += " AND mp.Year          = @Year";
            if (ddlBlock.SelectedValue != "0")         query += " AND b.Block_id       = @BlockId";
            if (ddlFlat.SelectedValue  != "0")         query += " AND mp.Flate_id      = @FlatId";
            if (ddlStatus.SelectedValue != "all")      query += " AND mp.Status        = @Status";
            if (ddlPaymentMethod.SelectedValue != "all") query += " AND mp.PaymentMethod = @PaymentMethod";

            query += " ORDER BY mp.PaymentDate DESC";

            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@AdminId", AdminId);

                if (ddlMonth.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@Month", ddlMonth.SelectedValue);
                if (ddlYear.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@Year", ddlYear.SelectedValue);
                if (ddlBlock.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);
                if (ddlFlat.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@FlatId", ddlFlat.SelectedValue);
                if (ddlStatus.SelectedValue != "all")
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                if (ddlPaymentMethod.SelectedValue != "all")
                    cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue);

                con.Open();
                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);
                gvPayments.DataSource = dt;
                gvPayments.DataBind();
            }
        }

        private void BindPendingFlats()
        {
            int month = ddlMonth.SelectedValue != "0"
                ? Convert.ToInt32(ddlMonth.SelectedValue)
                : DateTime.Now.Month;

            int year = ddlYear.SelectedValue != "0"
                ? Convert.ToInt32(ddlYear.SelectedValue)
                : DateTime.Now.Year;

            string query = @"
    SELECT 
        0 AS PaymentID,
        '---' AS User_name,
        b.Block_name,
        f.Flate_no,
        f.Mentanance AS Amount,
        NULL AS PaymentDate,
        @Month AS Month,
        @Year AS Year,
        '---' AS PaymentMethod,
        '---' AS TransactionID,
        'Pending' AS Status
    FROM tblFlat f
    INNER JOIN tblBlock b ON f.Block_id = b.Block_id
    INNER JOIN tblSociety s ON b.Society_id = s.Society_id
    WHERE s.admin_id = @AdminId
    AND NOT EXISTS (
        SELECT 1
        FROM MaintenancePayments mp
        WHERE mp.Flate_id = f.Flate_id
        AND mp.Month = @Month
        AND mp.Year = @Year
        AND mp.Status = 'Completed'
    )";

            // Filters
            if (ddlBlock.SelectedValue != "0")
                query += " AND b.Block_id = @BlockId";

            if (ddlFlat.SelectedValue != "0")
                query += " AND f.Flate_id = @FlatId";

            query += " ORDER BY b.Block_name, f.Flate_no";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@AdminId", AdminId);
                cmd.Parameters.AddWithValue("@Month", month);
                cmd.Parameters.AddWithValue("@Year", year);

                if (ddlBlock.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);

                if (ddlFlat.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@FlatId", ddlFlat.SelectedValue);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                gvPayments.DataSource = dt;
                gvPayments.DataBind();
            }
        }


        private void BindAllData()
        {
            int month = ddlMonth.SelectedValue != "0"
                ? Convert.ToInt32(ddlMonth.SelectedValue)
                : 0;

            int year = ddlYear.SelectedValue != "0"
                ? Convert.ToInt32(ddlYear.SelectedValue)
                : 0;

            string query = @"

    ---------------- PAID ----------------
    SELECT  
        mp.PaymentID,
        u.User_name,
        b.Block_name,
        f.Flate_no,
        mp.Amount,
        mp.PaymentDate,
        mp.Month,
        mp.Year,
        mp.PaymentMethod,
        mp.TransactionID,
        mp.Status
    FROM MaintenancePayments mp
    INNER JOIN tblFlat f ON mp.Flate_id = f.Flate_id
    INNER JOIN tblBlock b ON f.Block_id = b.Block_id
    INNER JOIN tblSociety s ON b.Society_id = s.Society_id
    INNER JOIN tblUser u ON mp.User_id = u.User_id
    WHERE s.admin_id = @AdminId
    AND (@Month = 0 OR mp.Month = @Month)
    AND (@Year = 0 OR mp.Year = @Year)

    /** BLOCK FILTER **/
    /** FLAT FILTER **/
    /** METHOD FILTER **/

    UNION ALL

    ---------------- PENDING ----------------
    SELECT 
        0 AS PaymentID,
        '---' AS User_name,
        b.Block_name,
        f.Flate_no,
        f.Mentanance AS Amount,
        NULL AS PaymentDate,
        @Month AS Month,
        @Year AS Year,
        '---' AS PaymentMethod,
        '---' AS TransactionID,
        'Pending' AS Status
    FROM tblFlat f
    INNER JOIN tblBlock b ON f.Block_id = b.Block_id
    INNER JOIN tblSociety s ON b.Society_id = s.Society_id
    WHERE s.admin_id = @AdminId
    AND NOT EXISTS (
        SELECT 1
        FROM MaintenancePayments mp2
        WHERE mp2.Flate_id = f.Flate_id
        AND (@Month = 0 OR mp2.Month = @Month)
        AND (@Year = 0 OR mp2.Year = @Year)
        AND mp2.Status = 'Completed'
    )

    /** BLOCK FILTER2 **/
    /** FLAT FILTER2 **/

    ORDER BY Block_name, Flate_no
    ";

            // 🔥 APPLY FILTERS SAFELY

            if (ddlBlock.SelectedValue != "0")
            {
                query = query.Replace("/** BLOCK FILTER **/", "AND b.Block_id = @BlockId");
                query = query.Replace("/** BLOCK FILTER2 **/", "AND b.Block_id = @BlockId");
            }
            else
            {
                query = query.Replace("/** BLOCK FILTER **/", "");
                query = query.Replace("/** BLOCK FILTER2 **/", "");
            }

            if (ddlFlat.SelectedValue != "0")
            {
                query = query.Replace("/** FLAT FILTER **/", "AND mp.Flate_id = @FlatId");
                query = query.Replace("/** FLAT FILTER2 **/", "AND f.Flate_id = @FlatId");
            }
            else
            {
                query = query.Replace("/** FLAT FILTER **/", "");
                query = query.Replace("/** FLAT FILTER2 **/", "");
            }

            if (ddlPaymentMethod.SelectedValue != "all")
            {
                query = query.Replace("/** METHOD FILTER **/", "AND mp.PaymentMethod = @PaymentMethod");
            }
            else
            {
                query = query.Replace("/** METHOD FILTER **/", "");
            }

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@AdminId", AdminId);
                cmd.Parameters.AddWithValue("@Month", month);
                cmd.Parameters.AddWithValue("@Year", year);

                if (ddlBlock.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);

                if (ddlFlat.SelectedValue != "0")
                    cmd.Parameters.AddWithValue("@FlatId", ddlFlat.SelectedValue);

                if (ddlPaymentMethod.SelectedValue != "all")
                    cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                gvPayments.DataSource = dt;
                gvPayments.DataBind();
            }
        }        // ─────────────────────────────────────────────
                 //  CALCULATE TOTALS
                 //  Pending = flats that have NO "Completed" payment
                 //            for the selected month/year (admin-scoped)
                 // ─────────────────────────────────────────────
        private void CalculateTotals()
        {
            int month = ddlMonth.SelectedValue != "0"
                ? int.Parse(ddlMonth.SelectedValue)
                : 0;

            int year = ddlYear.SelectedValue != "0"
                ? int.Parse(ddlYear.SelectedValue)
                : 0;

            using (var con = new SqlConnection(ConnectionString))
            {
                con.Open();

                // ── 1. TOTAL PAID ───────────────────────────
                string paidSql = @"
            SELECT ISNULL(SUM(mp.Amount), 0)
            FROM MaintenancePayments mp
            INNER JOIN tblFlat f ON mp.Flate_id = f.Flate_id
            INNER JOIN tblBlock b ON f.Block_id = b.Block_id
            INNER JOIN tblSociety s ON b.Society_id = s.Society_id
            WHERE s.admin_id = @AdminId
            AND mp.Status = 'Completed'
            AND (@Month = 0 OR mp.Month = @Month)
            AND (@Year = 0 OR mp.Year = @Year)";

                if (ddlBlock.SelectedValue != "0")
                    paidSql += " AND b.Block_id = @BlockId";

                if (ddlFlat.SelectedValue != "0")
                    paidSql += " AND mp.Flate_id = @FlatId";

                if (ddlPaymentMethod.SelectedValue != "all")
                    paidSql += " AND mp.PaymentMethod = @PaymentMethod";

                using (var cmd = new SqlCommand(paidSql, con))
                {
                    cmd.Parameters.AddWithValue("@AdminId", AdminId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);

                    if (ddlBlock.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);

                    if (ddlFlat.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@FlatId", ddlFlat.SelectedValue);

                    if (ddlPaymentMethod.SelectedValue != "all")
                        cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue);

                    litTotalPaid.Text = Convert.ToDecimal(cmd.ExecuteScalar()).ToString("N2");
                }

                // ── 2. TOTAL PENDING ───────────────────────
                string pendingSql = @"
            SELECT ISNULL(SUM(f.Mentanance), 0)
            FROM tblFlat f
            INNER JOIN tblBlock b ON f.Block_id = b.Block_id
            INNER JOIN tblSociety s ON b.Society_id = s.Society_id
            WHERE s.admin_id = @AdminId
            AND NOT EXISTS (
                SELECT 1
                FROM MaintenancePayments mp2
                WHERE mp2.Flate_id = f.Flate_id
                AND mp2.Status = 'Completed'
                AND (@Month = 0 OR mp2.Month = @Month)
                AND (@Year = 0 OR mp2.Year = @Year)
            )";

                if (ddlBlock.SelectedValue != "0")
                    pendingSql += " AND b.Block_id = @BlockId";

                if (ddlFlat.SelectedValue != "0")
                    pendingSql += " AND f.Flate_id = @FlatId";

                using (var cmd = new SqlCommand(pendingSql, con))
                {
                    cmd.Parameters.AddWithValue("@AdminId", AdminId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);

                    if (ddlBlock.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);

                    if (ddlFlat.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@FlatId", ddlFlat.SelectedValue);

                    litTotalPending.Text = Convert.ToDecimal(cmd.ExecuteScalar()).ToString("N2");
                }

                // ── 3. TOTAL FLATS ─────────────────────────
                string flatsSql = @"
            SELECT COUNT(*)
            FROM tblFlat f
            INNER JOIN tblBlock b ON f.Block_id = b.Block_id
            INNER JOIN tblSociety s ON b.Society_id = s.Society_id
            WHERE s.admin_id = @AdminId";

                if (ddlBlock.SelectedValue != "0")
                    flatsSql += " AND b.Block_id = @BlockId";

                if (ddlFlat.SelectedValue != "0")
                    flatsSql += " AND f.Flate_id = @FlatId";

                using (var cmd = new SqlCommand(flatsSql, con))
                {
                    cmd.Parameters.AddWithValue("@AdminId", AdminId);

                    if (ddlBlock.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);

                    if (ddlFlat.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@FlatId", ddlFlat.SelectedValue);

                    litTotalFlats.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                }

                // ── 4. PAID FLATS ─────────────────────────
                string paidFlatsSql = @"
            SELECT COUNT(DISTINCT mp.Flate_id)
            FROM MaintenancePayments mp
            INNER JOIN tblFlat f ON mp.Flate_id = f.Flate_id
            INNER JOIN tblBlock b ON f.Block_id = b.Block_id
            INNER JOIN tblSociety s ON b.Society_id = s.Society_id
            WHERE s.admin_id = @AdminId
            AND mp.Status = 'Completed'
            AND (@Month = 0 OR mp.Month = @Month)
            AND (@Year = 0 OR mp.Year = @Year)";

                if (ddlBlock.SelectedValue != "0")
                    paidFlatsSql += " AND b.Block_id = @BlockId";

                if (ddlFlat.SelectedValue != "0")
                    paidFlatsSql += " AND mp.Flate_id = @FlatId";

                using (var cmd = new SqlCommand(paidFlatsSql, con))
                {
                    cmd.Parameters.AddWithValue("@AdminId", AdminId);
                    cmd.Parameters.AddWithValue("@Month", month);
                    cmd.Parameters.AddWithValue("@Year", year);

                    if (ddlBlock.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@BlockId", ddlBlock.SelectedValue);

                    if (ddlFlat.SelectedValue != "0")
                        cmd.Parameters.AddWithValue("@FlatId", ddlFlat.SelectedValue);

                    litPaidFlats.Text = Convert.ToInt32(cmd.ExecuteScalar()).ToString();
                }
            }
        }
        // ─────────────────────────────────────────────
        //  FILTER / RESET
        // ─────────────────────────────────────────────
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            if (ddlStatus.SelectedValue == "Pending")
            {
                BindPendingFlats();
            }
            else if (ddlStatus.SelectedValue == "Completed")
            {
                BindPayments();
            }
            else // 🔥 "All"
            {
                BindAllData();   // NEW FUNCTION
            }

            CalculateTotals();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlMonth.SelectedValue         = "0";
            ddlYear.SelectedValue          = DateTime.Now.Year.ToString();
            ddlBlock.SelectedValue         = "0";
            ddlFlat.Items.Clear();
            ddlFlat.Items.Add(new WebListItem("All Flats", "0"));
            ddlStatus.SelectedValue        = "all";
            ddlPaymentMethod.SelectedValue = "all";

            BindAllData();
            CalculateTotals();
        }

        // ─────────────────────────────────────────────
        //  GRIDVIEW ROW COMMANDS
        // ─────────────────────────────────────────────
        protected void gvPayments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int paymentId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "ViewReceipt":
                    Response.Redirect($"AdminPaymentReceipt.aspx?paymentid={paymentId}");
                    break;

                case "EditPayment":
                    Response.Redirect($"AdminEditPayment.aspx?paymentid={paymentId}");
                    break;

                case "DeletePayment":
                    DeletePayment(paymentId);
                    BindPayments();
                    CalculateTotals();
                    break;
            }
        }

        private void DeletePayment(int paymentId)
        {
            using (var con = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(
                "DELETE FROM MaintenancePayments WHERE PaymentID = @PaymentID", con))
            {
                cmd.Parameters.AddWithValue("@PaymentID", paymentId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // ─────────────────────────────────────────────
        //  EXPORT – EXCEL
        // ─────────────────────────────────────────────
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            gvPayments.AllowPaging = false;
            BindPayments();

            using (var workbook = new XLWorkbook())
            {
                var ws = workbook.Worksheets.Add("Payments");

                // Headers
                for (int i = 0; i < gvPayments.Columns.Count; i++)
                    ws.Cell(1, i + 1).Value = gvPayments.Columns[i].HeaderText;

                // Data
                for (int i = 0; i < gvPayments.Rows.Count; i++)
                    for (int j = 0; j < gvPayments.Columns.Count; j++)
                        ws.Cell(i + 2, j + 1).Value = gvPayments.Rows[i].Cells[j].Text;

                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;filename=MaintenancePayments.xlsx");

                using (var ms = new MemoryStream())
                {
                    workbook.SaveAs(ms);
                    ms.WriteTo(Response.OutputStream);
                }
                Response.End();
            }
        }

        // ─────────────────────────────────────────────
        //  EXPORT – PDF
        // ─────────────────────────────────────────────
        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            gvPayments.AllowPaging = false;
            BindPayments();

            using (var ms = new MemoryStream())
            {
                var doc = new Document(PageSize.A4.Rotate());
                PdfWriter.GetInstance(doc, ms);
                doc.Open();

                doc.Add(new Paragraph("Maintenance Payments Report",
                    FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16))
                { Alignment = Element.ALIGN_CENTER });
                doc.Add(new Paragraph(" "));

                var pdfTable = new PdfPTable(gvPayments.Columns.Count) { WidthPercentage = 100 };

                foreach (DataControlField col in gvPayments.Columns)
                    pdfTable.AddCell(new Phrase(col.HeaderText,
                        FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 9)));

                foreach (GridViewRow row in gvPayments.Rows)
                    foreach (TableCell cell in row.Cells)
                        pdfTable.AddCell(new Phrase(cell.Text,
                            FontFactory.GetFont(FontFactory.HELVETICA, 8)));

                doc.Add(pdfTable);
                doc.Close();

                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment;filename=Payments.pdf");
                Response.BinaryWrite(ms.ToArray());
            }
            Response.End();
        }

        // ─────────────────────────────────────────────
        //  HELPERS
        // ─────────────────────────────────────────────
        public override void VerifyRenderingInServerForm(Control control) { }

        public string GetMonthName(int month)
        {
            if (month < 1 || month > 12)
                return "All";

            return new DateTime(2020, month, 1).ToString("MMMM");
        }
    }
}