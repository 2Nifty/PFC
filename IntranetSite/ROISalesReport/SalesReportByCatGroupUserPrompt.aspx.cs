using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.Securitylayer;

public partial class ROISalesReport_SalesReportByCatGroupUserPrompt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();

        if (!IsPostBack)
        {
            ddlYear.Items.Clear();
            string strYear = string.Empty;
            for (int i = 0; ; i++)
            {
                strYear = i.ToString();
                strYear = (strYear.Length == 1) ? "200" + i.ToString() : "20" + i.ToString();
                if (Convert.ToInt32(strYear) > DateTime.Now.Year)
                    break;

                ddlYear.Items.Insert(i, new ListItem(strYear, strYear));
            }

            int month = (int)DateTime.Now.Month;
            int year = Convert.ToInt16(DateTime.Now.Year.ToString().Substring(2));
            if (month != 1)
            {
                ddlMonth.Items[month - 2].Selected = true;
                ddlYear.Items[year].Selected = true;
            }
            else
            {
                ddlMonth.Items[ddlMonth.Items.Count - 1].Selected = true;
                ddlYear.Items[year - 1].Selected = true;
            }

        }
    }
}
