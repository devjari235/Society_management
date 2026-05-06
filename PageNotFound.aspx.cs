using System;
using System.Web;
using System.Web.UI;

namespace Society_management
{
    public partial class PageNotFound : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Log the error or handle page load logic here
        }

        protected void btnDynamicHome_Click(object sender, EventArgs e)
        {
            // Logic to determine which home to provide based on existing Sessions

            if (Session["A_id"] != null)
            {
                // User is an Admin
                Response.Redirect("~/AdminDashboard.aspx");
            }
            else if (Session["u_id"] != null)
            {
                // User is a regular Society Member
                Response.Redirect("~/UserDashboard.aspx");
            }
            else
            {
                // Session likely expired or user not logged in
                Response.Redirect("~/Login.aspx");
            }
        }
    }
}