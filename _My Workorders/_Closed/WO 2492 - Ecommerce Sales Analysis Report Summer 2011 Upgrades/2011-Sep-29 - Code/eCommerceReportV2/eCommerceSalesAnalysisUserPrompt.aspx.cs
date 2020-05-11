#region Namespaces
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
using System.Data.SqlClient;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.eCommerceReportV2;
using System.Threading;
#endregion

public partial class eCommerceSalesAnalysisUserPrompt : System.Web.UI.Page
{
    SalesReportUtils salesReportUtils = new SalesReportUtils();
    eCommerceReportV2 eComm = new eCommerceReportV2();
    string opt = string.Empty;
    
    SqlConnection cnxPERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    #region Page Load
    protected void Page_Load(object sender, EventArgs e)
    {
        //Session["SessionID"] = "1234";
        //Session["BranchID"] = "01";
        //Session["UserID"]   = "200";
        //Session["UserName"] = "Intranet";

        lblError.Text = ""; 

        salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());     
        
        if (!IsPostBack)
        {
            cldStartDt.Visible = false;
            cldEndDt.Visible = false;
            trByRange.Visible = false;

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

            FillBranches();     // Fill the Branch DDL

            BindListControls(ddlOrderSource, "ListDesc", "ListValue", "SOEOrderSource");    //Fill the OrderSource DDL

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
            
            for (int i = 0; i <= ddlBranch.Items.Count - 1; i++)
            {
                if (ddlBranch.Items[i].Value.Trim() == Session["BranchID"].ToString())
                {
                    ddlBranch.Items[i].Selected = true;
                    break;
                }
            }

            //if(ddlBranch.SelectedIndex == 0)
                FillCSRs();

            smEcommRpt.SetFocus(ddlMonth);
        }
    }
    #endregion

    #region Control Events
    #region Dates
    protected void rdoByMthPer_CheckedChanged(object sender, EventArgs e)
    {
        cldStartDt.Visible = false;
        cldEndDt.Visible = false;
        filloption("MO");
        smEcommRpt.SetFocus(ddlMonth);
    }
    
    protected void rdoByRange_CheckedChanged(object sender, EventArgs e)
    {
        cldStartDt.Visible = true;
        cldEndDt.Visible = true;
        filloption("DT");
        txtEndDt.Text = "";
        txtstartDt.Text = "";
        smEcommRpt.SetFocus(txtstartDt);
    }

    public void filloption(string opt)
    {
        if (opt == "DT")
        {
            trByRange.Visible = true;
            trrdoByMthPer.Visible = false;
        }
        else
        {
            trrdoByMthPer.Visible = true;
            trByRange.Visible = false;
        }
    }

    #region StartDt
    protected void ibtnStartDt_Click(object sender, ImageClickEventArgs e)
    {
        cldStartDt.Visible = true;
    }

    protected void txtstartDt_TextChanged(object sender, EventArgs e)
    {
        try
        {
            if (!ValidateDate(Convert.ToDateTime(txtstartDt.Text)))
            {
                cldStartDt.SelectedDate = DateTime.Now;
                txtstartDt.Text = "";
                lblError.Text = "Invalid Date Range";
            }

            if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtstartDt.Text)) == -1)
            {
                txtstartDt.Text = "";
                lblError.Text = "Invalid Date Range";
            }
        }
        catch (Exception ex)
        {

            txtstartDt.Text = "";
            lblError.Text = "Invalid Date Range";
        }

    }
    
    protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
    {
        if (ValidateDate(cldStartDt.SelectedDate))
            txtstartDt.Text = cldStartDt.SelectedDate.ToShortDateString();
        else
        {
            txtstartDt.Text = "";
            cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
        }

        if (txtEndDt.Text != "" && DateTime.Compare(cldEndDt.SelectedDate, cldStartDt.SelectedDate) == -1)
        {
            txtstartDt.Text = "";
            lblError.Text = "Invalid Date Range";
        }
    }
    #endregion

    #region EndDt
    protected void ibtnEndDt_Click(object sender, ImageClickEventArgs e)
    {
        cldEndDt.Visible = true;
    }

    protected void txtEndDt_TextChanged(object sender, EventArgs e)
    {
        try
        {
            if (!ValidateDate(Convert.ToDateTime(txtEndDt.Text)))
            {
                cldEndDt.SelectedDate = DateTime.Now;
                txtEndDt.Text = "";
                lblError.Text = "Invalid Date Range";
            }

            if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtstartDt.Text)) == -1)
            {
                txtEndDt.Text = "";
                lblError.Text = "Invalid Date Range";
            }
        }
        catch (Exception ex)
        {

            txtEndDt.Text = "";
            lblError.Text = "Invalid Date Range";
        }
    }

    protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
    {
        if (ValidateDate(cldEndDt.SelectedDate))
            txtEndDt.Text = cldEndDt.SelectedDate.ToShortDateString();
        else
        {
            txtEndDt.Text = "";
            cldEndDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
        }

        if (txtEndDt.Text != "" && DateTime.Compare(cldEndDt.SelectedDate, cldStartDt.SelectedDate) == -1)
        {
            txtEndDt.Text = "";
            lblError.Text = "Invalid Date Range";
        }
    }
    #endregion

    private bool ValidateDate(DateTime date)
    {
        if (DateTime.Compare(DateTime.Now, date) == -1 )
        {
            lblError.Text = "Invalid Date Range";
            return false;
        }
        else
            return true;
    }
    #endregion

    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillCSRs();
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            string popupScript = "<script language='javascript'>ViewReport()</script>";
            Page.RegisterStartupScript("Qoute and Order Analysis", popupScript);
        }
    }
    #endregion

    #region Bind filter prompts
    public void FillBranches()
    {
        try
        {
            salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());
        }
        catch (Exception ex) { }
    }

    public void FillCSRs()
    {
        try
        {
            string branchId = (ddlBranch.SelectedIndex == 0 ? "" : ddlBranch.SelectedValue);
            ddlCSR.DataSource = eComm.GetCSRNames(branchId);
            ddlCSR.ClearSelection();
            ddlCSR.Items.Clear();
            ddlCSR.DataTextField = "RepName";
            ddlCSR.DataValueField = "RepNo";
            ddlCSR.DataBind();
            ddlCSR.Items.Insert(0, new ListItem("All", ""));

        }
        catch (Exception ex) { }
    }

    public void BindListControls(ListControl lstControl, string textField, string valueField, string listName)
    {
        try
        {
            DataTable dtSource = GetListDetails(listName);
            if (dtSource != null && dtSource.Rows.Count > 0)
            {
                lstControl.DataSource = dtSource;
                lstControl.DataTextField = textField;
                lstControl.DataValueField = valueField;
                lstControl.DataBind();
                lstControl.Items.Insert(0, new ListItem("*All Orders*", "ALL"));
                lstControl.Items.Insert(1, new ListItem("*All CSR Orders*", "ALLCSR"));
                lstControl.Items.Insert(2, new ListItem("*All eCommerce Orders*", "ALLEC"));
            }
            else
            {
                if (lstControl.ID.IndexOf("lst") == -1)
                {
                    lstControl.Items.Clear();
                    lstControl.Items.Insert(0, new ListItem("N/A", ""));
                }

            }
        }
        catch (Exception ex) { }
    }

    public DataTable GetListDetails(string listName)
    {
        try
        {
            string _tableName = "ListMaster (NoLock) LM, ListDetail (NoLock) LD";
            string _columnName = "LD.ListValue, LD.ListValue + ' - ' + LD.ListDtlDesc AS ListDesc";
            string _whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID ORDER BY SequenceNo ASC";
            DataSet dsType = SqlHelper.ExecuteDataset(cnxPERP, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsType.Tables[0];

        }
        catch (Exception ex)
        {
            return null;
        }
    }
    #endregion
}
