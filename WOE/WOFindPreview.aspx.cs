using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.WOE;
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;
using PFC.WOE.SecurityLayer;

public partial class WOFindPreview : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    DataSet dsWorkOrders = new DataSet();
    DataTable dtWorkOrders = new DataTable();

    string _UserId, _WOType, _MfgLoc, _StatusDesc, _StartDt, _EndDt, _Printed, _Routing;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Request.QueryString["UserId"].ToString().Trim()))
            _UserId = Request.QueryString["UserId"].ToString().Trim();
        else
            _UserId = "";

        if (!string.IsNullOrEmpty(Request.QueryString["WOType"].ToString().Trim()))
            _WOType = Request.QueryString["WOType"].ToString().Trim();
        else
            _WOType = "";

        if (!string.IsNullOrEmpty(Request.QueryString["MfgLoc"].ToString().Trim()))
            _MfgLoc = Request.QueryString["MfgLoc"].ToString().Trim();
        else
            _MfgLoc = "";

        if (!string.IsNullOrEmpty(Request.QueryString["StatusDesc"].ToString().Trim()))
            _StatusDesc = Request.QueryString["StatusDesc"].ToString().Trim();
        else
            _StatusDesc = "";

        if (!string.IsNullOrEmpty(Request.QueryString["StartDt"].ToString().Trim()))
            _StartDt = Request.QueryString["StartDt"].ToString().Trim();
        else
            _StartDt = DateTime.Now.AddDays(-7).ToShortDateString(); ;

        if (!string.IsNullOrEmpty(Request.QueryString["EndDt"].ToString().Trim()))
            _EndDt = Request.QueryString["EndDt"].ToString().Trim();
        else
            _EndDt = DateTime.Now.ToShortDateString();

        if (!string.IsNullOrEmpty(Request.QueryString["Printed"].ToString().Trim()))
            _Printed = Request.QueryString["Printed"].ToString().Trim();
        else
            _Printed = "";

        if (!string.IsNullOrEmpty(Request.QueryString["Routing"].ToString().Trim()))
            _Routing = Request.QueryString["Routing"].ToString().Trim();
        else
            _Routing = "";

        lblLegend.Text = "User Id: ";
        lblLegend.Text += (_UserId == "") ? "All" : _UserId;
        lblLegend.Text += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        lblLegend.Text += "WO Type: ";
        lblLegend.Text += (_WOType == "") ? "All" : _WOType;
        lblLegend.Text += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        lblLegend.Text += "Mfg Loc: ";
        lblLegend.Text += (_MfgLoc == "") ? "All" : _MfgLoc;
        lblLegend.Text += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        lblLegend.Text += "Status Desc: ";
        lblLegend.Text += (_StatusDesc == "") ? "All" : _StatusDesc;
        lblLegend.Text += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        lblLegend.Text += "Printed: ";
        lblLegend.Text += (_Printed == "") ? "All" : _Printed;
        lblLegend.Text += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        lblLegend.Text += "Routing: ";
        lblLegend.Text += (_Routing == "") ? "All" : _Routing;
        lblLegend.Text += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        lblLegend.Text += "Begin Date: " + _StartDt + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                          "End Date: " + _EndDt + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                          "Run Date: " + DateTime.Now.ToShortDateString();

        BindDataGrid();
    }

    private void BindDataGrid()
    {
        dsWorkOrders = GetWorkOrders();
        dgFind.DataSource = dsWorkOrders.Tables[0].DefaultView.ToTable();
        dgFind.DataBind();
    }

    public DataSet GetWorkOrders()
    {
        //try
        //{
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pWOFind",
                                            new SqlParameter("@UserId", _UserId),
                                            new SqlParameter("@WOType", _WOType),
                                            new SqlParameter("@MfgLoc", _MfgLoc),
                                            new SqlParameter("@StatusDesc", _StatusDesc),
                                            new SqlParameter("@StartDt", _StartDt),
                                            new SqlParameter("@EndDt", _EndDt),
                                            new SqlParameter("@Printed", _Printed),
                                            new SqlParameter("@Routing", _Routing));
            return dsResult;
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
    }
}