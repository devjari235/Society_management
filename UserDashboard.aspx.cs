using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class UserDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadDashboardData();
        }
        private void LoadDashboardData()
        {


            // Load user stats
            lblMaintenanceDue.Text = "₹2,500";
            lblDueDate.Text = DateTime.Now.AddDays(10).ToString("dd MMM yyyy");
            lblPendingPayments.Text = "2";
            lblOpenComplaints.Text = "3";
            lblNewNotices.Text = "5";

            // Load recent activity
            var recentActivity = new List<dynamic>
        {
            new {
                Title = "Complaint Registered",
                Description = "Water leakage in bathroom has been registered",
                Date = DateTime.Now.AddHours(-2).ToString("dd MMM hh:mm tt"),
                Link = "MyComplaints.aspx",
                ActivityClass = "complaint"
            },
            new {
                Title = "Payment Received",
                Description = "Maintenance payment for October received",
                Date = DateTime.Now.AddDays(-1).ToString("dd MMM hh:mm tt"),
                Link = "MyPayments.aspx",
                ActivityClass = "payment"
            },
            new {
                Title = "New Notice",
                Description = "Society meeting on 25th October",
                Date = DateTime.Now.AddDays(-2).ToString("dd MMM hh:mm tt"),
                Link = "NoticeBoard.aspx",
                ActivityClass = "notice"
            }
        };

            if (recentActivity.Count > 0)
            {
                rptRecentActivity.DataSource = recentActivity;
                rptRecentActivity.DataBind();
                pnlNoActivity.Visible = false;
            }
            else
            {
                pnlNoActivity.Visible = true;
            }

            // Load important notices
            var importantNotices = new List<dynamic>
        {
            new {
                Title = "Annual Maintenance Hike",
                Summary = "Maintenance charges will increase by 10% from next month",
                Date = "15 Oct 2023",
                Link = "NoticeDetails.aspx?id=1"
            },
            new {
                Title = "Diwali Celebration",
                Summary = "Society Diwali celebration on 12th November at club house",
                Date = "10 Oct 2023",
                Link = "NoticeDetails.aspx?id=2"
            }
        };

            if (importantNotices.Count > 0)
            {
                rptImportantNotices.DataSource = importantNotices;
                rptImportantNotices.DataBind();
                pnlNoNotices.Visible = false;
            }
            else
            {
                pnlNoNotices.Visible = true;
            }
        }
    }
}