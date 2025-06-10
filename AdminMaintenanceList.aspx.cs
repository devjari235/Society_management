using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML.Excel;
using System.Web.Helpers;
using iTextSharp.text.pdf;
using iTextSharp.text;

namespace Society_management
{
    public partial class AdminMaintenanceList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                LoadYears();
                LoadBlocks();
                BindPayments();
                CalculateTotals();
            }
        }

        private void LoadYears()
        {
            ddlYear.Items.Clear();
            ddlYear.Items.Add(new System.Web.UI.WebControls.ListItem("All Years", "0"));

            int currentYear = DateTime.Now.Year;
            for (int year = currentYear - 3; year <= currentYear + 3; year++)
            {
                ddlYear.Items.Add(new System.Web.UI.WebControls.ListItem(year.ToString(), year.ToString()));
            }

            ddlYear.SelectedValue = DateTime.Now.Year.ToString();
        }

        private void LoadBlocks()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT \r\n    b.Block_id, \r\n    b.Block_name, s.Society_name,a.name\r\nFROM \r\n    tblBlock b\r\nINNER JOIN tblSociety s ON b.Society_id = s.Society_id\r\nINNER JOIN tblAdmin a ON s.admin_id = a.admin_id where a.admin_id=@id ORDER BY b.Block_name";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    cmd.Parameters.AddWithValue("@id", Session["A_id"]);
                    cmd.ExecuteNonQuery();
                    
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        ddlBlock.Items.Add(new System.Web.UI.WebControls.ListItem(reader["Block_name"].ToString(), reader["Block_id"].ToString()));
                    }
                }
            }
        }

        protected void ddlBlock_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadFlats();
        }

        private void LoadFlats()
        {
            ddlFlat.Items.Clear();
            ddlFlat.Items.Add(new System.Web.UI.WebControls.ListItem("All Flats", "0"));

            if (ddlBlock.SelectedValue != "0")
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT Flate_id, Flate_no FROM tblFlat WHERE Block_id = @BlockID ORDER BY Flate_no";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@BlockID", ddlBlock.SelectedValue);
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            ddlFlat.Items.Add(new System.Web.UI.WebControls.ListItem(reader["Flate_no"].ToString(), reader["Flate_id"].ToString()));
                        }
                    }
                }
            }
        }

        private void BindPayments()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT mp.*, u.User_name, f.Flate_no, b.Block_name 
                               FROM MaintenancePayments mp
                               INNER JOIN tblUser u ON mp.User_id = u.User_id
                               INNER JOIN tblFlat f ON mp.Flate_id = f.Flate_id
                               INNER JOIN tblBlock b ON f.Block_id = b.Block_id
                               WHERE 1=1";

                if (ddlMonth.SelectedValue != "0")
                {
                    query += " AND mp.Month = @Month";
                }

                if (ddlYear.SelectedValue != "0")
                {
                    query += " AND mp.Year = @Year";
                }

                if (ddlBlock.SelectedValue != "0")
                {
                    query += " AND f.Block_id = @BlockID";
                }

                if (ddlFlat.SelectedValue != "0")
                {
                    query += " AND mp.Flate_id = @FlatID";
                }

                if (ddlStatus.SelectedValue != "all")
                {
                    query += " AND mp.Status = @Status";
                }

                if (ddlPaymentMethod.SelectedValue != "all")
                {
                    query += " AND mp.PaymentMethod = @PaymentMethod";
                }

                query += " ORDER BY mp.PaymentDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (ddlMonth.SelectedValue != "0")
                    {
                        cmd.Parameters.AddWithValue("@Month", ddlMonth.SelectedValue);
                    }

                    if (ddlYear.SelectedValue != "0")
                    {
                        cmd.Parameters.AddWithValue("@Year", ddlYear.SelectedValue);
                    }

                    if (ddlBlock.SelectedValue != "0")
                    {
                        cmd.Parameters.AddWithValue("@BlockID", ddlBlock.SelectedValue);
                    }

                    if (ddlFlat.SelectedValue != "0")
                    {
                        cmd.Parameters.AddWithValue("@FlatID", ddlFlat.SelectedValue);
                    }

                    if (ddlStatus.SelectedValue != "all")
                    {
                        cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                    }

                    if (ddlPaymentMethod.SelectedValue != "all")
                    {
                        cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue);
                    }

                    con.Open();
                    DataTable dt = new DataTable();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    gvPayments.DataSource = dt;
                    gvPayments.DataBind();
                }
            }
        }

        private void CalculateTotals()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Total Paid Amount
                string paidQuery = "SELECT ISNULL(SUM(Amount), 0) FROM MaintenancePayments WHERE Status = 'Completed'";
                if (ddlMonth.SelectedValue != "0")
                {
                    paidQuery += " AND Month = " + ddlMonth.SelectedValue;
                }
                if (ddlYear.SelectedValue != "0")
                {
                    paidQuery += " AND Year = " + ddlYear.SelectedValue;
                }

                using (SqlCommand cmd = new SqlCommand(paidQuery, con))
                {
                    con.Open();
                    decimal totalPaid = Convert.ToDecimal(cmd.ExecuteScalar());
                    litTotalPaid.Text = totalPaid.ToString("N2");
                }

                // Total Pending Amount (assuming pending is calculated based on flats that haven't paid)
                string pendingQuery = @"SELECT ISNULL(SUM(f.Mentanance), 0) 
                                      FROM tblFlat f
                                      WHERE NOT EXISTS (
                                          SELECT 1 FROM MaintenancePayments mp 
                                          WHERE mp.Flate_id = f.Flate_id 
                                          AND mp.Month = @Month 
                                          AND mp.Year = @Year
                                          AND mp.Status = 'Completed'
                                      )";

                if (ddlBlock.SelectedValue != "0")
                {
                    pendingQuery += " AND f.Block_id = " + ddlBlock.SelectedValue;
                }

                if (ddlFlat.SelectedValue != "0")
                {
                    pendingQuery += " AND f.Flate_id = " + ddlFlat.SelectedValue;
                }

                using (SqlCommand cmd = new SqlCommand(pendingQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Month", ddlMonth.SelectedValue != "0" ? ddlMonth.SelectedValue : DateTime.Now.Month.ToString());
                    cmd.Parameters.AddWithValue("@Year", ddlYear.SelectedValue != "0" ? ddlYear.SelectedValue : DateTime.Now.Year.ToString());

                    decimal totalPending = Convert.ToDecimal(cmd.ExecuteScalar());
                    litTotalPending.Text = totalPending.ToString("N2");
                }

                // Total Flats
                string flatsQuery = "SELECT COUNT(*) FROM tblFlat WHERE 1=1";
                if (ddlBlock.SelectedValue != "0")
                {
                    flatsQuery += " AND Block_id = " + ddlBlock.SelectedValue;
                }

                using (SqlCommand cmd = new SqlCommand(flatsQuery, con))
                {
                    int totalFlats = Convert.ToInt32(cmd.ExecuteScalar());
                    litTotalFlats.Text = totalFlats.ToString();
                }

                // Paid Flats
                string paidFlatsQuery = @"SELECT COUNT(DISTINCT mp.Flate_id) 
                                        FROM MaintenancePayments mp
                                        INNER JOIN tblFlat f ON mp.Flate_id = f.Flate_id
                                        WHERE mp.Status = 'Completed'";

                if (ddlMonth.SelectedValue != "0")
                {
                    paidFlatsQuery += " AND mp.Month = " + ddlMonth.SelectedValue;
                }
                if (ddlYear.SelectedValue != "0")
                {
                    paidFlatsQuery += " AND mp.Year = " + ddlYear.SelectedValue;
                }
                if (ddlBlock.SelectedValue != "0")
                {
                    paidFlatsQuery += " AND f.Block_id = " + ddlBlock.SelectedValue;
                }

                using (SqlCommand cmd = new SqlCommand(paidFlatsQuery, con))
                {
                    int paidFlats = Convert.ToInt32(cmd.ExecuteScalar());
                    litPaidFlats.Text = paidFlats.ToString();
                }
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            BindPayments();
            CalculateTotals();
    
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlMonth.SelectedValue = "0";
            ddlYear.SelectedValue = DateTime.Now.Year.ToString();
            ddlBlock.SelectedValue = "0";
            ddlFlat.Items.Clear();
            ddlFlat.Items.Add(new System.Web.UI.WebControls.ListItem("All Flats", "0"));
            ddlStatus.SelectedValue = "all";
            ddlPaymentMethod.SelectedValue = "all";

            BindPayments();
            CalculateTotals();
        }

        protected void gvPayments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewReceipt")
            {
                int paymentId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"AdminPaymentReceipt.aspx?paymentid={paymentId}");
            }
            else if (e.CommandName == "EditPayment")
            {
                int paymentId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"AdminEditPayment.aspx?paymentid={paymentId}");
            }
            else if (e.CommandName == "DeletePayment")
            {
                int paymentId = Convert.ToInt32(e.CommandArgument);
                DeletePayment(paymentId);
                BindPayments();
                CalculateTotals();
            }
        }

        private void DeletePayment(int paymentId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM MaintenancePayments WHERE PaymentID = @PaymentID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@PaymentID", paymentId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            // Bind all data
            gvPayments.AllowPaging = false;
            BindPayments();

            using (var workbook = new XLWorkbook())
            {
                var ws = workbook.Worksheets.Add("Payments");

                // Add headers
                for (int i = 0; i < gvPayments.Columns.Count; i++)
                {
                    ws.Cell(1, i + 1).Value = gvPayments.Columns[i].HeaderText;
                }

                // Add data
                for (int i = 0; i < gvPayments.Rows.Count; i++)
                {
                    for (int j = 0; j < gvPayments.Columns.Count; j++)
                    {
                        ws.Cell(i + 2, j + 1).Value = gvPayments.Rows[i].Cells[j].Text;
                    }
                }

                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;filename=MaintenancePayments.xlsx");

                using (var memoryStream = new MemoryStream())
                {
                    workbook.SaveAs(memoryStream);
                    memoryStream.WriteTo(Response.OutputStream);
                }

                Response.End();
            }
        }

        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            // Bind data
            gvPayments.AllowPaging = false;
            BindPayments();

            using (MemoryStream ms = new MemoryStream())
            {
                // Create PDF document
                Document doc = new Document(PageSize.A4.Rotate());
                PdfWriter writer = PdfWriter.GetInstance(doc, ms);
                doc.Open();

                // Add title
                doc.Add(new Paragraph("Maintenance Payments Report",
                    FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16))
                { Alignment = Element.ALIGN_CENTER });

                // Create PDF table
                PdfPTable pdfTable = new PdfPTable(gvPayments.Columns.Count)
                {
                    WidthPercentage = 100
                };

                // Add headers
                foreach (DataControlField column in gvPayments.Columns)
                {
                    pdfTable.AddCell(new Phrase(column.HeaderText,
                        FontFactory.GetFont(FontFactory.HELVETICA_BOLD)));
                }

                // Add data rows
                foreach (GridViewRow row in gvPayments.Rows)
                {
                    foreach (TableCell cell in row.Cells)
                    {
                        pdfTable.AddCell(new Phrase(cell.Text));
                    }
                }

                doc.Add(pdfTable);
                doc.Close();

                // Send to browser
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment;filename=Payments.pdf");
                Response.BinaryWrite(ms.ToArray());
            }
            Response.End();
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for Excel export
        }

        public string GetMonthName(int month)
        {
            return new DateTime(2020, month, 1).ToString("MMMM");
        }
    }
}