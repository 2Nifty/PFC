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
using PFC.SOE.BusinessLogicLayer;

public partial class ShippingMarksExport : System.Web.UI.Page
{
    ShippingMark shippingMark = new ShippingMark();
    private String SONumber;
    private string soTableName;

    protected void Page_Load(object sender, EventArgs e)
    {
        SONumber = Request.QueryString["SONumber"].ToString();
        soTableName = Request.QueryString["SOTableName"].ToString();
        if (!Page.IsPostBack)
        {
            BindData();
        }
    }
    private void BindData()
    {
        try
        {
            DataSet dsShippingMarks = shippingMark.GetShippingMarksExport(SONumber, soTableName);
            dlSOEHeader.DataSource = dsShippingMarks.Tables[0];
            dlSOEHeader.DataBind();
        }
        catch (Exception ex) { }

    }

}
