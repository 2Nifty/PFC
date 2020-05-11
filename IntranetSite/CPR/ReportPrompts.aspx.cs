using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Utility;
using PFC.Intranet.Securitylayer;

public partial class CPRReportPrompts : System.Web.UI.Page 
{
    Utility utility = new Utility();
    PFC.Intranet.BusinessLogicLayer.CPR cpr = new PFC.Intranet.BusinessLogicLayer.CPR();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    int TimeOutSeconds;
    Decimal Factor;
    Boolean ReportOK = false;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            RunByLabel.Text = Session["UserName"].ToString();
            RemoveNoStock.Checked = true;
            ReportType.Value = "";
            CurItemsName.Value = "CurItems";
            //scrollbars=no,
            ReportLinkButt.Attributes.Add("onfocus", "document.getElementById('RunReportButt').focus();window.open('CPRReport.aspx','CPR','height=768,width=1024,scrollbars=yes,toolbar=no,menubar=yes,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');");
            ManualXFerLinkButt.Attributes.Add("onfocus", "document.getElementById('ManualXFerButt').focus();window.open('ManualTransfer.aspx','ManualXFer','height=768,width=1024,scrollbars=yes,toolbar=no,menubar=yes,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');");
            ItemListLinkButt.Attributes.Add("onfocus", "document.getElementById('RunReportButt').focus();window.open('Showitems.aspx','Items','scrollbars=yes,toolbar=no,menubar=yes,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');");
            if (Request.QueryString["Type"] != null)
            {
                CurItemsName.Value = "BuyItems";
                ReportType.Value = Request.QueryString["Type"];
                LongReport.Enabled = false;
                ShortReport.Enabled = false;
                TransferReport.Enabled = false;
                this.Title = "CPR Buy Report Prompts";
                lblParentMenuName.Text = "CPR Buy Report Options";
                ReportLinkButt.Attributes.Add("onfocus", "document.getElementById('RunReportButt').focus();window.open('CPRBuyReport.aspx','CPRBuy','height=768,width=1024,scrollbars=yes,toolbar=no,menubar=yes,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');");
            }
            if (Session["CPRSort"] != null)
            {
                if (Session["CPRSort"].ToString() == "SortPlating") SortPlating.Checked = true;
                if (Session["CPRSort"].ToString() == "SortItem") SortItem.Checked = true;
                if (Session["CPRSort"].ToString() == "SortVariance") SortVariance.Checked = true;
                if (Session["CPRSort"].ToString() == "SortNetBuyBucks") SortNetBuyBucks.Checked = true;
                if (Session["CPRSort"].ToString() == "SortNewBuyLBS") SortNewBuyLBS.Checked = true;
                if (Session["CPRSort"].ToString() == "SortCFVC") SortCFVC.Checked = true;
            }
            if ((Session["IncludeSummQtys"] != null) && (Session["IncludeSummQtys"].ToString().ToUpper() == "TRUE"))
            {
                IncludeSummQtys.Checked = true;
            }
            if ((Session["CPRFactor"] != null) && (Session["CPRFactor"].ToString() != "-1"))
            {
                CPRFactor.Text = Session["CPRFactor"].ToString();
            }
            CPRFactor.Focus();
            try
            {
                dt = (DataTable)Session[CurItemsName.Value];
                RecCountLabel.Text = dt.Rows.Count.ToString();
            }
            catch { };
            int ExceptPcnt = (int)(cpr.GetAppPrefNumber("ExceptPcnt") * 100);
            Exception3.Text = "Hub Required > Company Excess; " + ExceptPcnt.ToString() + "% Hub Required < Company Excess";
            Exception4.Text = "Hub Required > Company Excess; " + ExceptPcnt.ToString() + "% Hub Required < Branch " + cpr.GetAppPrefValue("ExceptHubs") + " Excess";
        }
        else
        {
            ScriptManager1.AsyncPostBackTimeout = TimeOutSeconds;
        }
        TimeOutSeconds = (int)cpr.GetAppPrefNumber("CPR", "TimeOut");

    }

    protected void ClearPageMessages()
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
    }

    protected string CurItemKey()
    {
        if (ReportType.Value == "Buy")
        {
            return ReportType.Value.ToString() + Session["UserName"].ToString();
        }
        else
        {
            return Session["UserName"].ToString();
        }
    }

    protected void RunReportButt_Click(object sender, ImageClickEventArgs e)
    {
        if (ValidatePage())
        {
            if (ReportType.Value == "")
            {
                if (LongReport.Checked)
                    Session["GridType"] = "Long"; ;
                if (ShortReport.Checked)
                    Session["GridType"] = "Short"; ;
                if (TransferReport.Checked)
                    Session["GridType"] = "Transfer"; ;
            }
            if (SortPlating.Checked) Session["CPRSort"] = "SortPlating";
            if (SortItem.Checked) Session["CPRSort"] = "SortItem";
            if (SortVariance.Checked) Session["CPRSort"] = "SortVariance";
            if (SortNetBuyBucks.Checked) Session["CPRSort"] = "SortNetBuyBucks";
            if (SortNewBuyLBS.Checked) Session["CPRSort"] = "SortNewBuyLBS";
            if (SortCFVC.Checked) Session["CPRSort"] = "SortCFVC";
            Session["IncludeSummQtys"] = IncludeSummQtys.Checked.ToString().ToUpper();
            ReportLinkButt.Focus();
        }
    }

    protected void ManualXFerButt_Click(object sender, ImageClickEventArgs e)
    {
        if (ValidatePage())
        {
            if (ReportType.Value == "")
            {
                if (LongReport.Checked)
                    Session["GridType"] = "Long"; ;
                if (ShortReport.Checked)
                    Session["GridType"] = "Short"; ;
                if (TransferReport.Checked)
                    Session["GridType"] = "Transfer"; ;
            }
            if (SortPlating.Checked) Session["CPRSort"] = "SortPlating";
            if (SortItem.Checked) Session["CPRSort"] = "SortItem";
            if (SortVariance.Checked) Session["CPRSort"] = "SortVariance";
            if (SortNetBuyBucks.Checked) Session["CPRSort"] = "SortNetBuyBucks";
            if (SortNewBuyLBS.Checked) Session["CPRSort"] = "SortNewBuyLBS";
            if (SortCFVC.Checked) Session["CPRSort"] = "SortCFVC";
            Session["IncludeSummQtys"] = IncludeSummQtys.Checked.ToString().ToUpper();
            ManualXFerLinkButt.Focus();
        }
    }

    bool ValidatePage()
    {
        ClearPageMessages();
        ReportOK = false;
        if (decimal.TryParse(CPRFactor.Text, NumberStyles.Number, null, out Factor))
        {
            Session["CPRFactor"] = Factor;
            ReportOK = true;
        }
        if (!ReportOK)
        {
            if (CPRFactor.Text.ToString().Trim() == "")
            {
                Session["CPRFactor"] = -1m;
                ReportOK = true;
            }
            else
            {
                lblErrorMessage.Text = "A Factor is required for the report";
                CPRFactor.Focus();
                return ReportOK;
            }
        }
        //lblErrorMessage.Text = "Factor:" + Session["CPRFactor"].ToString();
        dt = (DataTable)Session[CurItemsName.Value];
        if (dt.Rows.Count > 0)
        {
            ReportOK = true;
        }
        else
        {
            lblErrorMessage.Text = "There a no records to report";
            ReportOK = false;
        }
        return ReportOK;
    }

    protected void ItemButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        dt = (DataTable)Session[CurItemsName.Value];
        if (dt.Rows.Count > 0)
        {
            ItemListLinkButt.Focus();
        }
        else
        {
            lblErrorMessage.Text = "There a no items to show";
        }
    }

    protected void RemoveEmptyButt_Click(object sender, ImageClickEventArgs e)
    {
        int Action = 0;
        ClearPageMessages();
        if (DeleteEmpties.Checked || KeepEmpties.Checked)
        {
            if (DeleteEmpties.Checked)
            {
                Action = 0;
                lblSuccessMessage.Text = "Empty Pantry items have been removed.";
            }
            if (KeepEmpties.Checked)
            {
                Action = 1;
                lblSuccessMessage.Text = "Only Empty Pantry items remain.";
            }
            dt = cpr.ClearEmptyItems(CurItemKey(), Action, IncludeSummQtys.Checked).Tables[0];
            Session[CurItemsName.Value] = dt;
            RecCountLabel.Text = dt.Rows.Count.ToString();
        }
        else
        {
            lblErrorMessage.Text = "Please select to Remove or Keep Only 'Empty Pantry' items.";
            DeleteEmpties.Focus();
        }
    }

    protected void RemoveNoActionButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        if (RemoveNoAction.Checked)
        {
            dt = cpr.ClearNoActionItems(CurItemKey(), IncludeSummQtys.Checked).Tables[0];
            Session[CurItemsName.Value] = dt;
            RecCountLabel.Text = dt.Rows.Count.ToString();
            lblSuccessMessage.Text = "Items with no requirements have been removed.";
        }
        else
        {
            lblErrorMessage.Text = "Please select Remove Items with no requirements.";
            RemoveNoAction.Focus();
        }
    }

    protected void RemoveNoStockButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        if (RemoveNoStock.Checked)
        {
            dt = cpr.ClearNoStockItems(CurItemKey()).Tables[0];
            Session[CurItemsName.Value] = dt;
            RecCountLabel.Text = dt.Rows.Count.ToString();
            lblSuccessMessage.Text = "Non Stock Items have been removed.";
        }
        else
        {
            lblErrorMessage.Text = "Please select Remove Non Stock Items.";
            RemoveNoAction.Focus();
        }
    }

    protected void FilterBuyRangeButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        decimal BuyBeg;
        decimal BuyEnd;
        if (ValidatePage())
        {
            if (decimal.TryParse(BuyLowerTextBox.Text.ToString(), out BuyBeg))
            {
                if (BuyUpperTextBox.Text.ToString() == "") BuyUpperTextBox.Text = "1000000000";
                if (decimal.TryParse(BuyUpperTextBox.Text.ToString(), out BuyEnd))
                {
                    //if (BuyEnd == 0) BuyEnd = 1000000000;
                    if (BuyBeg < BuyEnd)
                    {
                        dt = cpr.FilterNetBuy(CurItemKey(), Factor, BuyBeg, BuyEnd, IgnoreChild.Checked, IncludeSummQtys.Checked
                            , NetBuyPosRadioButton.Checked).Tables[0];
                        Session[CurItemsName.Value] = dt;
                        RecCountLabel.Text = dt.Rows.Count.ToString();
                        if (IgnoreChild.Checked)
                        {
                            lblSuccessMessage.Text = "Items with a total Net Buy Range (Children Ignored) from $" + BuyBeg.ToString("####,###,##0") + " to $" + BuyEnd.ToString("####,###,##0") + " have been selected.";
                        }
                        else
                        {
                            lblSuccessMessage.Text = "Items with a total Net Buy Range (Children included) from $" + BuyBeg.ToString("####,###,##0") + " to $" + BuyEnd.ToString("####,###,##0") + " have been selected.";
                        }
                        ItemButt.Focus();
                    }
                    else
                    {
                        lblErrorMessage.Text = "Beginning Net Buy must be less than the Ending Net Buy amount.";
                        BuyUpperTextBox.Focus();
                    }
                }
                else
                {
                    lblErrorMessage.Text = "Ending Net Buy range is invalid.";
                    BuyUpperTextBox.Focus();
                }
            }
            else
            {
                lblErrorMessage.Text = "Beginning Net Buy range is invalid.";
                BuyLowerTextBox.Focus();
            }
        }
    }

    //protected void IgnoreChildButt_Click(object sender, ImageClickEventArgs e)
    //{
    //    ClearPageMessages();
    //    if (IgnoreChild.Checked)
    //    {
    //        dt = cpr.ClearNoActionItems(CurItemKey()).Tables[0];
    //        Session[CurItemsName.Value] = dt;
    //        RecCountLabel.Text = dt.Rows.Count.ToString();
    //        lblSuccessMessage.Text = "Child Data will not affect Need Calculation.";
    //    }
    //    else
    //    {
    //        lblErrorMessage.Text = "Please select Ignore Child Data in Calculation.";
    //        RemoveNoAction.Focus();
    //    }
    //}

    protected void ExceptionButt_Click(object sender, ImageClickEventArgs e)
    {
        int ExceptionNo = 1;
        ClearPageMessages();
        if (Exception1.Checked || Exception2.Checked || Exception3.Checked || Exception4.Checked)
        {
            try
            {
                if (Exception1.Checked) ExceptionNo = 1;
                if (Exception2.Checked) ExceptionNo = 2;
                if (Exception3.Checked) ExceptionNo = 3;
                if (Exception4.Checked) ExceptionNo = 4;
                //dt = cpr.FilterExceptionItems(Session["UserName"].ToString(), ExceptionNo).Tables[0];
                //dt = cpr.FilterExceptionItems(CurItemKey(), ExceptionNo, TimeOutSeconds, IncludeSummQtys.Checked).Tables[0];
                dt = cpr.FilterExceptionItems(CurItemKey(), ExceptionNo, IncludeSummQtys.Checked).Tables[0];
                Session[CurItemsName.Value] = dt;
                RecCountLabel.Text = dt.Rows.Count.ToString();
                lblSuccessMessage.Text = "Items not matching execption have been removed.";
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = ex.ToString();
            }
        }
        else lblErrorMessage.Text = "Please select one of the Exceptions to use.";
        
    }

}