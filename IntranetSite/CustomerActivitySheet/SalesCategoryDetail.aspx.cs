
/********************************************************************************************
 * File	Name			:	SalesCategoryDetails.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	To display sales details
 * Created By			:	MaheshKumar.S
 * Created Date			:	11/14/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 11/14/2006		    Version 1		Mahesh      		Created 
 * 
 * 4/9/2007             Version 2       Sathya              Edited 
 *********************************************************************************************/


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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;

public partial class CustomerActivitySheet_SalesCategoryDetail : System.Web.UI.Page
{
    PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerData = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();
    string strTable = "CAS_CategorySum";
    string strDisplayColumns = " CurYear, CurMonth, CustNo, replace(convert(varchar,cast((cast(isnull(MTDSales,0) as bigint)) as money),1),'.00','') as MTDSales,cast(isnull(MTDLbs,0) as bigint) as MTDLbs, cast((isnull(MTDGMPct,0)) as Decimal(25,1)) as MTDGMPct, cast((isnull(MTDPctTotSales,0)) as Decimal(25,1)) as MTDPctTotSales, cast(MTDDolPerLb as Decimal(25,2)) as MTDDolPerLb, CategoryRank, BranchNo, CatGrpNo, CatGrpDesc, replace(convert(varchar,cast((cast(isnull(MTDGM,0) as bigint)) as money),1),'.00','') as MTDGM,cast(isnull(MTDGMPctCorpAvg,0) as decimal(15,1)) as MTDGMPctCorpAvg,cast(isnull(MTDPctTotSalesCorpAvg,0) as decimal(15,1)) as MTDPctTotSalesCorpAvg,cast(isnull(MTDDolPerLBCorpAvg,0) as decimal(15,2)) as MTDDolPerLBCorpAvg";
    public DataTable dtSalesDetails = new DataTable();
    public string strHTML = string.Empty;
    public string customerNumber = string.Empty;
    public string strWhere = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["PrintMode"] == null)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
        }
        if (!IsPostBack)
        {
            string strWhere = "CustNo='" + Request.QueryString["CustNo"].ToString() + "'";
            DataTable dtCustName = customerData.GetCustomerActivityDetail(strWhere, "CustName", "CAS_CustomerData");
            if (dtCustName != null && dtCustName.Rows.Count > 0)
                lblCustName.Text = dtCustName.Rows[0]["CustName"].ToString();
        }
        // Call the function to display the customer data
        FillSalesDetails();
    }

    /// <summary>
    /// Function to display the customer data
    /// </summary>
    public void FillSalesDetails()
    {


        try
        {

            if (Request.QueryString["CASMode"] == null)
            {
                customerNumber = Request.QueryString["CustNo"].ToString().Replace("||", "&");
                strWhere = "curmonth=" + Request.QueryString["Month"].Trim() + " and " +
                              "curYear=" + Request.QueryString["Year"].Trim() + " and CustNo='" + customerNumber + "' and Branchno is not null and CategoryRank>=1 and CategoryRank<=99  order by CategoryRank asc";
            }
            else
            {
                customerNumber = Request.QueryString["Chain"].ToString().Replace("||", "&");
                strWhere = "curmonth=" + Request.QueryString["Month"].Trim() + " and " +
                              "curYear=" + Request.QueryString["Year"].Trim() + " and CustNo='" + customerNumber + "' and Branchno is null and CategoryRank>=1 and CategoryRank<=99  order by CategoryRank asc";
            }




            //PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerData = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();
            dtSalesDetails = customerData.GetCustomerActivityDetail(strWhere, strDisplayColumns, strTable);

            if (dtSalesDetails.Rows.Count > 0)
            {
                if ((Request.QueryString["mode"] != null && Request.QueryString["mode"].Trim() != "Print" && Request.QueryString["mode"].Trim() != "Export") || Request.QueryString["mode"] == null)
                {
                    dgSalesDetails.DataSource = dtSalesDetails;
                    dgSalesDetails.DataBind();
                    lblStatus.Visible = false;
                    if (!IsPostBack)
                    {
                        if (Session["DetailType"] != null)
                        {
                            rbtnlCustType.Items[0].Selected = (Session["DetailType"].ToString() == "PFC Employee") ? false : true;
                            rbtnlCustType.Items[1].Selected = (Session["DetailType"].ToString() == "PFC Employee") ? true : false;
                            rbtnlCustType_SelectedIndexChanged(rbtnlCustType, new EventArgs());
                        }
                        else
                        {
                            rbtnlCustType.Items[1].Selected = true;
                        }
                    }
                }
                else
                    BuildHTML();
            }
            else
            {
                dgSalesDetails.Visible = false;
                lblStatus.Visible = true;
            }

        }
        catch (Exception ex) { }
    }

    /// <summary>
    /// Function to print the customer activity sheet with heading
    /// </summary>
    public void BuildHTML()
    {
        try
        {
            #region Declaration

            string strHeadTag = string.Empty;
            string strBgColor = string.Empty;
            string strContent = string.Empty;
            int i;
            int cnt = 0;
            string strEndTag = "</table></td></tr></table></td></tr></table></td></tr></table>";

            #endregion

            string strRadio = string.Empty;
            string strHeader = string.Empty;
            if (Request.QueryString["DetailType"].ToString() == "PFC Employee")
            {
                strRadio = "<td class=\"redhead\"><table id='rbtnlCustType' border='0' width=100%><tr><td width=10px><input id='rbtnlCustType_0' type='radio' name='rbtnlCustType' value='Customer'  /><label class=\"redhead\" for='rbtnlCustType_0'>Customer</label></td><td width=100px><input id='rbtnlCustType_1' checked='checked' type='radio' name='rbtnlCustType' value='PFC Employee'/><label class=\"redhead\" for='rbtnlCustType_1'>PFC Employee</label></td><td align=\"right\" class=\"BlackBold\" style=\"padding-right:10px\">" + Request.QueryString["MonthName"].Trim() + "'" + Request.QueryString["Year"].Trim() + "</td></tr></table></td>";
                strHeader = "<tr class=\"GridHead\" borderColor=\"#c9c6c6\"  align=\"center\" style=\"background-color:#DFF3F9;\"><td>SALES DETAILS</td><td>Ext Sales Amt</td><td>Margins $</td><td>Pounds Sold</td><td>Margin %</td><td>Crp Avg</td><td>$/Lb</td><td>Crp Avg</td><td>% Of Sales</td><td>Crp Avg</td></tr>";

            }
            else
            {
                strRadio = "<td class=\"redhead\"><table id='rbtnlCustType' border='0' width=100%><tr><td width=10px><input id='rbtnlCustType_0' type='radio' name='rbtnlCustType' value='Customer' checked='checked' /><label for='rbtnlCustType_0' class=\"redhead\">Customer</label></td><td width=100px><input id='rbtnlCustType_1' type='radio' name='rbtnlCustType' value='PFC Employee'/><label for='rbtnlCustType_1' class=\"redhead\">PFC Employee</label></td><td align=\"right\" class=\"BlackBold\" style=\"padding-right:10px\" >" + Request.QueryString["MonthName"].Trim() + "'" + Request.QueryString["Year"].Trim() + "</td></tr></table></td>";
                strHeader = "<tr borderColor=\"#c9c6c6\" class=\"GridHead\"  align=\"center\" style=\"background-color:#DFF3F9;\"><td>SALES DETAILS</td><td>Ext Sales Amt</td><td>Pounds Sold</td><td>$/Lb</td><td>% Of Sales</td></tr>";
            }

            #region Bind the header tag in the string

            strHeadTag = "<table id=\"master\" class=DashBoardBk  width=100% style=\"page-break-after:always\">" +
                    "<tr>" +
                    "<td valign=top colspan='2'>" +
                    "<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"SheetHolder\">" +
                    "<tr>" +
                    "<td valign=top >" +
                    "<table width=\"100%\" border=\"0\"  align=\"center\" cellpadding=\"1\" cellspacing=\"1\" class=\"PageBorder\">" +
                    "<tr>" +
                    "<td  colspan='2'> <table width=\"100%\"  border=\"0\" cellpadding=\"2\" cellspacing=\"2\" class=\"SheetHead\">" +
                    "<tr>" +
                    "<td class=\"redhead\">Run Date:" + DateTime.Now.ToString() + "</td>" +
                    "<td class=\"redhead\">" + "SALES CATEGORY DETAIL" + "</td>" +
                    "<td class=\"redhead\">" + "PAGE 4" + "</td>" +
                    "</tr>" +
                    "</table></td>" +
                    "</tr>" +
                    "<tr>" +
                    //"<td ><div class=\"BlackBold\">" + Request.QueryString["BranchName"].Trim() + "&nbsp;&nbsp;&nbsp;&nbsp;" +
                    "<td> <div class=\"BlackBold\"> Customer # &nbsp;"+ Request.QueryString["CustNo"].Trim() + "&nbsp;&nbsp;"+ lblCustName.Text +
                 "</div></td>" + strRadio +
                "</tr>" + "<tr><td colspan='2'><table width=100% cellspacing=0 borderColor=\"#c9c6c6\" style=\"border-color:#C9C6C6;border-width:1px;border-style:solid;width:100%;border-collapse:collapse;\" rules=all border=1>" +
                strHeader;

            #endregion

            int recordCount = 32;
            int totalHead = (dtSalesDetails.Rows.Count / recordCount);
            int headCount = 0;
            for (i = 0; i < dtSalesDetails.Rows.Count; i++)
            {
                if (i == 0)
                    strHTML = strHeadTag;

                strBgColor = (strBgColor == "" || strBgColor == "#F4FBFD") ? "white" : "#F4FBFD";

                strContent = "<tr  style=\"background-color:" + strBgColor + ";white-space:nowrap;\">" +
                            "<td class=\"CASGridPadding\" align=\"left\">" + dtSalesDetails.Rows[i]["CatGrpDesc"] + "</td>" +
                            "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDSales"] + "</td>";
                if (Request.QueryString["DetailType"].ToString() == "PFC Employee")
                    strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDGM"] + "</td>";
                strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDLbs"] + "</td>";
                if (Request.QueryString["DetailType"].ToString() == "PFC Employee")
                {
                    strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDGMPct"] + "</td>";
                    strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDGMPctCorpAvg"] + "</td>";
                }
                strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDDOLPerLb"] + "</td>";
                if (Request.QueryString["DetailType"].ToString() == "PFC Employee")
                {
                    strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + string.Format("{0:#,##0.00}", dtSalesDetails.Rows[i]["MTDDolPerLBCorpAvg"]) + "</td>";
                }
                strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDPctTotSales"] + "</td>";
                if (Request.QueryString["DetailType"].ToString() == "PFC Employee")
                {
                    strContent = strContent + "<td class=\"CASGridPadding\" align=\"right\">" + dtSalesDetails.Rows[i]["MTDPctTotSalesCorpAvg"] + "</td>";
                }
                strContent = strContent + " </tr>";

                if (cnt == recordCount)
                {
                    headCount++;
                    if (totalHead == headCount)
                    {
                        strHeadTag = Server.HtmlDecode(strHeadTag);

                        if (Request.QueryString["DetailType"].ToString() == "PFC Employee")
                        {
                            strHeadTag = strHeadTag.Replace("<td class=\"redhead\"><table id='rbtnlCustType' border='0'><tr><td><input id='rbtnlCustType_0' type='radio' name='rbtnlCustType' value='Customer'  /><label class=\"redhead\" for='rbtnlCustType_0'>Customer</label></td><td><input id='rbtnlCustType_1' checked='checked' type='radio' name='rbtnlCustType' value='PFC Employee'/><label class=\"redhead\" for='rbtnlCustType_1'>PFC Employee</label></td></tr></table></td>", "");
                        }
                        else
                        {
                            strHeadTag = strHeadTag.Replace("<td class=\"redhead\"><table id='rbtnlCustType' border='0'><tr><td><input id='rbtnlCustType_0' type='radio' name='rbtnlCustType' value='Customer' checked='checked' /><label for='rbtnlCustType_0' class=\"redhead\">Customer</label></td><td><input id='rbtnlCustType_1' type='radio' name='rbtnlCustType' value='PFC Employee'/><label for='rbtnlCustType_1' class=\"redhead\">PFC Employee</label></td></tr></table></td>", "");
                        }
                    }
                    strHTML += strEndTag + ((totalHead == headCount) ? strHeadTag.Replace("style=\"page-break-after:always\"", "style=\"page-break-after:always;\"") : strHeadTag);
                    cnt = 0;
                }
                strHTML += strContent; cnt++;
            }
            divHTML.InnerHtml = (i % 32 == 0) ? strHTML : strHTML + strEndTag;
        }
        catch (Exception ex) { }
    }

    /// <summary>
    /// rbtnlCustType_SelectedIndexChanged :used to bind values based in the condition
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void rbtnlCustType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnlCustType.Items[0].Selected)
        {
            dgSalesDetails.Columns[2].Visible = false;
            dgSalesDetails.Columns[4].Visible = false;
            dgSalesDetails.Columns[5].Visible = false;
            dgSalesDetails.Columns[7].Visible = false;
            dgSalesDetails.Columns[9].Visible = false;
            Session["DetailType"] = "Customer";
        }
        else
        {
            dgSalesDetails.Columns[2].Visible = true;
            dgSalesDetails.Columns[4].Visible = true;
            dgSalesDetails.Columns[5].Visible = true;
            dgSalesDetails.Columns[7].Visible = true;
            dgSalesDetails.Columns[9].Visible = true;
            Session["DetailType"] = "PFC Employee";
        }
    }
}
