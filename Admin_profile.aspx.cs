using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Society_management
{
    public partial class Admin_profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            display();
        }
        public void display()
        {
            txtname.Text = Session["A_name"].ToString();
            txtemail.Text = Session["A_email"].ToString();
            txtphone.Text = Session["A_phone"].ToString();
        }
    }
}