using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class A_logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            // Expire session ID cookie
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddDays(-1);
            }

            // Expire user cookie
            if (Request.Cookies["AdminInfo"] != null)
            {
                HttpCookie expiredCookie = new HttpCookie("AdminInfo");
                expiredCookie.Expires = DateTime.Now.AddDays(-1);
                expiredCookie.Value = null;
                Response.Cookies.Add(expiredCookie);
            }
        }
    }
}