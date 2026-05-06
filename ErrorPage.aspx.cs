using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class ErrorPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnDynamicHome_Click(object sender, EventArgs e)
        {
            if (Session["A_id"] != null)
            {
                // Admin Session
                Response.Redirect("~/AdminDashboard.aspx");
            }
            else if (Session["u_id"] != null)
            {
                // User Session
                Response.Redirect("~/UserDashboard.aspx");
            }
            else
            {
                // No session - send to login
                Response.Redirect("~/Login.aspx");
            }
        }
    }
}