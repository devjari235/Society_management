using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class U_logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            // ✅ Optional: remove ASP.NET session ID cookie too
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddDays(-1);
            }

            // ✅ Expire user-defined cookie
            if (Request.Cookies["UserInfo"] != null)
            {
                HttpCookie expiredCookie = new HttpCookie("UserInfo");
                expiredCookie.Expires = DateTime.Now.AddDays(-1); // Immediately expire
                Response.Cookies.Add(expiredCookie);
            }

            // ✅ Redirect to login page
            Response.Redirect("U_login.aspx");

        }
    }
}