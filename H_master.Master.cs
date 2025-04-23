using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class H_master : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void LinkButton5_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }



        protected void LinkButton7_Click1(object sender, EventArgs e)
        {
            Response.Redirect("U_login.aspx");
        }
    }
}