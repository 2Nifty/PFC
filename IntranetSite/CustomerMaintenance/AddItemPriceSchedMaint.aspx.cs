using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.Threading;
using System.Reflection;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using PFC.Intranet;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.MaintenanceApps;

public partial class AddItemPriceSchedMaint : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    DataSet dsCustPriceSched;
    DataTable dtCustPriceSched;
    string dtFormat = "MM/dd/yyyy";
    string PageMode, itemType, categoryNo = "";
    
    int PageSize = 18;
    int dgOffSet = 3;    

    CustomerMaintenance CustClass = new CustomerMaintenance();
    MaintenanceUtility MaintClass = new MaintenanceUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(AddItemPriceSchedMaint));

        if (Request.QueryString["Mode"] != null)
        {
            PageMode = Request.QueryString["Mode"].ToLower();
            itemType = Request.QueryString["ItemType"].ToLower();
            lblHeading.Text = "Contract Name: " + Request.QueryString["CustNo"].ToLower() + " - " + Request.QueryString["CustName"].ToLower().Replace("~","&") ; 
        }
        

        if (!Page.IsPostBack)
        {
            GetSecurity();
        }

        if (pnlTop.Visible == true)
            if (string.IsNullOrEmpty(txtItem.Text.ToString()))
            {
                hidSellUM.Value = "";
                hidSellStkUM.Value = "";
                hidAltSellStkUMQty.Value = "1";
            }
            else
            {
                if (string.IsNullOrEmpty(txtAltPrice.Text.ToString()))
                {
                    //lblAltPriceUM.Text = "";
                    lblSellPrice.Text = "";
                    lblSellPriceUM.Text = "";
                }
                lblAltPriceUM.Text = "&nbsp;/&nbsp;" + hidSellUM.Value;

                if (string.IsNullOrEmpty(txtAltPriceFut.Text.ToString()))
                {
                    lblSellPriceFut.Text = "";
                    lblSellPriceFutUM.Text = "";
                }
                lblAltPriceFutUM.Text = "&nbsp;/&nbsp;" + hidSellUM.Value;

            }

        
        if (!Page.IsPostBack && PageMode == "singleitem")
        {
            btnAdd_Click(this.Page, new ImageClickEventArgs(0, 0));
            
            lblContract.Text = Request.QueryString["CustNo"].ToLower();
            txtPriceMeth.Text = "P";
            txtPriceMeth.ReadOnly = true;            
            tblGrid.Visible = false;
        }
        else if (!Page.IsPostBack && PageMode == "itemsbycategory")
        {
            lblContract.Text = Request.QueryString["CustNo"].ToLower();
            categoryNo = Request.QueryString["Category"].ToLower();
            txtPriceMeth.Text = "P";
            txtPriceMeth.ReadOnly = true;
            btnSearch_Click(this.Page, new ImageClickEventArgs(0, 0));
        }
        else if (!Page.IsPostBack && PageMode == "itemsbycustomer")
        {
            lblContract.Text = Request.QueryString["CustNo"].ToLower();
            categoryNo = "";
            txtPriceMeth.Text = "P";
            txtPriceMeth.ReadOnly = true;
            btnSearch_Click(this.Page, new ImageClickEventArgs(0, 0));
        }
        else if(!Page.IsPostBack && PageMode == "lllcontracts")
        {
            lblContract.Text = Request.QueryString["LLLContractCd"].ToString();
            categoryNo = Request.QueryString["Category"].ToLower();
            txtPriceMeth.Text = "P";
            txtPriceMeth.ReadOnly = true;
            btnSearch_Click(this.Page, new ImageClickEventArgs(0, 0));
        }
    }

    #region Button Events
    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        tPager.Visible = true;
        dgCustPriceSched.CurrentPageIndex = 0;
        Pager1.GotoPageNumber = 0;
        pnlPager.Update();

        lblMessage.Text = "";
        pnlProgress.Update();

        if (hidSort.Attributes["sortType"] != null)
            hidSort.Attributes["sortType"] = "ASC";
        else
            hidSort.Attributes.Add("sortType", "ASC");
        hidSort.Value = "ItemNo " + hidSort.Attributes["sortType"].ToString();
        String sortExpression = (hidSort.Value == "") ? " ItemNo ASC" : hidSort.Value;

        dsCustPriceSched = GetCustPriceSched();
        dsCustPriceSched.Tables[0].DefaultView.Sort = sortExpression;
        hidRowCount.Value = dsCustPriceSched.Tables[0].Rows.Count.ToString();
        dtCustPriceSched = dsCustPriceSched.Tables[0].DefaultView.ToTable();
        Session["dtCustPrice"] = dtCustPriceSched;
        BindDataGrid();
    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        hidMode.Value = "Add";
        ClearFields();
        
        if(PageMode != "")
            txtPriceMeth.Text = "P";

        smCustPriceSched.SetFocus(txtItem);
        lblMessage.Text = "";
        pnlProgress.Update();
        ContentTable.Visible = true;
        btnSave.Visible = true;
        btnCancel.Visible = true;
        divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 330px; border: 0px solid; vertical-align: top;";
        pnlTop.Update();
        pnlContent.Update();
        pnlPriceGrid.Update();
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {       
        if (string.IsNullOrEmpty(txtItem.Text.ToString()))
        {
            DisplaStatusMessage("Please enter a valid Item No", "fail");
        }
        else
        {
            if (hidMode.Value == "Edit")
            {
                UpdateCustPriceFromHeader();
            }
            else
            {
                AddCustPriceSched();
            }

            if (tPager.Visible == true)
                BindDataGrid();
        }
        smCustPriceSched.SetFocus(txtItem);        
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        btnAdd_Click(btnCancel,new ImageClickEventArgs(0,0));
        lblMessage.Text = "";
        pnlProgress.Update();
        if (PageMode != "singleitem")
        {
            ContentTable.Visible = false;
            btnSave.Visible = false;
            btnCancel.Visible = false;
        }        
        divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 495px; border: 0px solid; vertical-align: top;";
        pnlTop.Update();
        pnlContent.Update();
        pnlPriceGrid.Update();
    }
    #endregion

    #region Change Events
    
    #region Add Panel change events
    protected void txtAltPrice_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        if (!string.IsNullOrEmpty(txtAltPrice.Text.ToString()))
        {
            txtAltPrice.Text = txtAltPrice.Text.ToString().Trim().Replace("$", "").Replace(",", "");
            lblSellPrice.Text = String.Format("{0:c}", Convert.ToDecimal(txtAltPrice.Text) * Convert.ToDecimal(hidAltSellStkUMQty.Value)).ToString().Trim();
            if (!string.IsNullOrEmpty(hidSellStkUM.Value.ToString()))
                lblSellPriceUM.Text = "&nbsp;/&nbsp;" + hidSellStkUM.Value;
            txtAltPrice.Text = String.Format("{0:c}", Convert.ToDecimal(txtAltPrice.Text)).ToString().Trim();
            lblUOM.Text = hidSellStkUM.Value;
            lblPcs.Text = hidPcs.Value;
            lblDesc.Text = hidDesc.Value;

            if (hidMode.Value == "Edit")
            {
                DateTime _90DaysFromNow = DateTime.Now.AddDays(90);
                DateTime firstDayOfTheMonth = new DateTime(_90DaysFromNow.Year, _90DaysFromNow.Month, 1);
                dpEffEndDt.SelectedDate = firstDayOfTheMonth.AddMonths(1).ToShortDateString();
            }

            smCustPriceSched.SetFocus(btnSave);
        }
    }

    //protected void txtSellPrice_TextChanged(object sender, EventArgs e)
    //{
    //    lblMessage.Text = "";
    //    pnlProgress.Update();
        
    //    txtSellPrice.Text = txtSellPrice.Text.ToString().Trim().Replace("$", "").Replace(",", "");
    //    txtSellPrice.Text = String.Format("{0:c}", Convert.ToDecimal(txtSellPrice.Text)).ToString().Trim();
    //    smCustPriceSched.SetFocus(txtDisc);
    //}

    protected void txtDisc_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        txtDisc.Text = txtDisc.Text.ToString().Trim().Replace("%", "").Replace(",", "");
        txtDisc.Text = String.Format("{0:0.00%}", Convert.ToDecimal(txtDisc.Text) / 100).ToString().Trim().Replace("%", "");
        smCustPriceSched.SetFocus(txtPriceMethFut);
    }

    protected void txtAltPriceFut_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        if (!string.IsNullOrEmpty(txtAltPriceFut.Text.ToString()))
        {
            txtAltPriceFut.Text = txtAltPriceFut.Text.ToString().Trim().Replace("$", "").Replace(",", "");
            lblSellPriceFut.Text = String.Format("{0:c}", Convert.ToDecimal(txtAltPriceFut.Text) * Convert.ToDecimal(hidAltSellStkUMQty.Value)).ToString().Trim();
            if (!string.IsNullOrEmpty(hidSellStkUM.Value.ToString()))
                lblSellPriceFutUM.Text = "&nbsp;/&nbsp;" + hidSellStkUM.Value;
            txtAltPriceFut.Text = String.Format("{0:c}", Convert.ToDecimal(txtAltPriceFut.Text)).ToString().Trim();
            //smCustPriceSched.SetFocus(txtSellPriceFut);
            smCustPriceSched.SetFocus(txtDiscFut);
        }
    }

    //protected void txtSellPriceFut_TextChanged(object sender, EventArgs e)
    //{
    //    lblMessage.Text = "";
    //    pnlProgress.Update();
        
    //    txtSellPriceFut.Text = txtSellPriceFut.Text.ToString().Trim().Replace("$", "").Replace(",", "");
    //    txtSellPriceFut.Text = String.Format("{0:c}", Convert.ToDecimal(txtSellPriceFut.Text)).ToString().Trim();
    //    smCustPriceSched.SetFocus(txtDiscFut);
    //}

    protected void txtDiscFut_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();
        
        txtDiscFut.Text = txtDiscFut.Text.ToString().Trim().Replace("%", "").Replace(",", "");
        txtDiscFut.Text = String.Format("{0:0.00%}", Convert.ToDecimal(txtDiscFut.Text) / 100).ToString().Trim().Replace("%", "");
        smCustPriceSched.SetFocus(btnSave);
    }
    #endregion  //Add Panel change events

    #region DataGrid change events
    protected void txtPriceMethGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();
        
        TextBox _txtPriceMethGrid = sender as TextBox;

        //Update the DataSet
        string rowId = _txtPriceMethGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtPriceMethGrid", "");
        UpdateDataSet(rowId, "PriceMethod", _txtPriceMethGrid.Text.ToString().Trim());

        //Set focus on PriceMethod in next record
        string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
        if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
        string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtPriceMethGrid";
        smCustPriceSched.SetFocus(nextCtl.ToString());
    }

    protected void txtEffDtGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        TextBox _txtEffDtGrid = sender as TextBox;
        _txtEffDtGrid.Text = _txtEffDtGrid.Text.ToString().Trim().Replace("-", "/");

        if (ValidateDate(_txtEffDtGrid.Text, dtFormat))
        {
            //Update the DataSet
            string rowId = _txtEffDtGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtEffDtGrid", "");
            UpdateDataSet(rowId, "EffDt", _txtEffDtGrid.Text);

            //Set focus on EffDt in next record
            string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
            if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
            string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtEffDtGrid";
            smCustPriceSched.SetFocus(nextCtl.ToString());
        }
        else
        {
            _txtEffDtGrid.Text = "";
            smCustPriceSched.SetFocus(_txtEffDtGrid.ClientID);
            lblMessage.Text = "Valid date format is MM/DD/YYYY";
            pnlProgress.Update();
        }
    }

    protected void txtEffEndDtGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        TextBox _txtEffDtGrid = sender as TextBox;
        _txtEffDtGrid.Text = _txtEffDtGrid.Text.ToString().Trim().Replace("-", "/");

        if (ValidateDate(_txtEffDtGrid.Text, dtFormat))
        {
            //Update the DataSet
            string rowId = _txtEffDtGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtEffEndDtGrid", "");
            UpdateDataSet(rowId, "EffEndDt", _txtEffDtGrid.Text);

            //Set focus on EffDt in next record
            string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
            if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
            string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtEffEndDtGrid";
            smCustPriceSched.SetFocus(nextCtl.ToString());
        }
        else
        {
            _txtEffDtGrid.Text = "";
            smCustPriceSched.SetFocus(_txtEffDtGrid.ClientID);
            lblMessage.Text = "Valid date format is MM/DD/YYYY";
            pnlProgress.Update();
        }
    }

    protected void txtAltPriceGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        //UPDATE AltPrice & SellPrice
        TextBox _txtAltPriceGrid = sender as TextBox;
        if (string.IsNullOrEmpty(_txtAltPriceGrid.Text))
            _txtAltPriceGrid.Text = "0";

        //Update the DataSet (AltPrice)
        string rowId = _txtAltPriceGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtAltPriceGrid", "");
        _txtAltPriceGrid.Text = _txtAltPriceGrid.Text.ToString().Trim().Replace("$", "").Replace(",", "");
        UpdateDataSet(rowId, "AltSellPrice", _txtAltPriceGrid.Text);

        //Update the DataSet (SellPrice)
        DropDownList _ddlPageNo = Pager1.FindControl("ddlPages") as DropDownList;
        int dataRow = ((Convert.ToInt16(_ddlPageNo.SelectedItem.Text) - 1) * PageSize) + Convert.ToInt16(rowId) - dgOffSet;
        Decimal _SellPriceDec = Convert.ToDecimal(_txtAltPriceGrid.Text.ToString().Trim().Replace("$", "").Replace(",", ""));
        _SellPriceDec = _SellPriceDec * Convert.ToDecimal(dtCustPriceSched.Rows[dataRow]["AltSellStkUMQty"].ToString());
        string _SellPriceStr = String.Format("{0:c}", _SellPriceDec).ToString().Trim().Replace("$", "").Replace(",", "");
        UpdateDataSet(rowId, "SellPrice", _SellPriceStr);

        //Set focus on AltSellPrice in next record
        string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
        if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
        string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtAltPriceGrid";
        smCustPriceSched.SetFocus(nextCtl.ToString());    
    }

    protected void txtDiscGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        TextBox _txtDiscGrid = sender as TextBox;
        if (string.IsNullOrEmpty(_txtDiscGrid.Text))
            _txtDiscGrid.Text = "0";

        //Update the DataSet
        string rowId = _txtDiscGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtDiscGrid", "");
        _txtDiscGrid.Text = _txtDiscGrid.Text.ToString().Trim().Replace("%", "").Replace(",", "");
        UpdateDataSet(rowId, "DiscPct", _txtDiscGrid.Text);

        //Set focus on DiscPct in next record
        string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
        if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
        string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtDiscGrid";
        smCustPriceSched.SetFocus(nextCtl.ToString());
    }

    protected void txtPriceMethFutGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        TextBox _txtPriceMethFutGrid = sender as TextBox;

        //Update the DataSet
        string rowId = _txtPriceMethFutGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtPriceMethFutGrid", "");
        UpdateDataSet(rowId, "FutPriceMethod", _txtPriceMethFutGrid.Text.ToString().Trim());

        //Set focus on FutPriceMethod in next record
        string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
        if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
        string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtPriceMethFutGrid";
        smCustPriceSched.SetFocus(nextCtl.ToString());

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scroll", "ScrollIt();", true);
    }

    protected void txtEffDtFutGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        TextBox _txtEffDtFutGrid = sender as TextBox;
        _txtEffDtFutGrid.Text = _txtEffDtFutGrid.Text.ToString().Trim().Replace("-", "/");

        if (ValidateDate(_txtEffDtFutGrid.Text, dtFormat))
        {
            //Update the DataSet
            string rowId = _txtEffDtFutGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtEffDtFutGrid", "");
            UpdateDataSet(rowId, "FutEffDt", _txtEffDtFutGrid.Text);

            //Set focus on FutEffDt in next record
            string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
            if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
            string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtEffDtFutGrid";
            smCustPriceSched.SetFocus(nextCtl.ToString());
        }
        else
        {
            _txtEffDtFutGrid.Text = "";
            smCustPriceSched.SetFocus(_txtEffDtFutGrid.ClientID);
            lblMessage.Text = "Valid date format is MM/DD/YYYY";
            pnlProgress.Update();
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scroll", "ScrollIt();", true);
    }

    protected void txtEffEndDtFutGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        TextBox _txtEffEndDtFutGrid = sender as TextBox;
        _txtEffEndDtFutGrid.Text = _txtEffEndDtFutGrid.Text.ToString().Trim().Replace("-", "/");

        if (ValidateDate(_txtEffEndDtFutGrid.Text, dtFormat))
        {
            //Update the DataSet
            string rowId = _txtEffEndDtFutGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtEffEndDtFutGrid", "");
            UpdateDataSet(rowId, "FutEffEndDt", _txtEffEndDtFutGrid.Text);

            //Set focus on FutEffDt in next record
            string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
            if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
            string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtEffEndDtFutGrid";
            smCustPriceSched.SetFocus(nextCtl.ToString());
        }
        else
        {
            _txtEffEndDtFutGrid.Text = "";
            smCustPriceSched.SetFocus(_txtEffEndDtFutGrid.ClientID);
            lblMessage.Text = "Valid date format is MM/DD/YYYY";
            pnlProgress.Update();
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scroll", "ScrollIt();", true);
    }

    protected void txtAltPriceFutGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        //UPDATE AltPriceFut & SellPriceFut
        TextBox _txtAltPriceFutGrid = sender as TextBox;
        if (string.IsNullOrEmpty(_txtAltPriceFutGrid.Text))
            _txtAltPriceFutGrid.Text = "0";

        //Update the DataSet (AltPriceFut)
        string rowId = _txtAltPriceFutGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtAltPriceFutGrid", "");
        _txtAltPriceFutGrid.Text = _txtAltPriceFutGrid.Text.ToString().Trim().Replace("$", "").Replace(",", "");
        UpdateDataSet(rowId, "FutAltSellPrice", _txtAltPriceFutGrid.Text);

        //Update the DataSet (SellPriceFut)
        DropDownList _ddlPageNo = Pager1.FindControl("ddlPages") as DropDownList;
        int dataRow = ((Convert.ToInt16(_ddlPageNo.SelectedItem.Text) - 1) * PageSize) + Convert.ToInt16(rowId) - dgOffSet;
        Decimal _SellPriceDec = Convert.ToDecimal(_txtAltPriceFutGrid.Text.ToString().Trim().Replace("$", "").Replace(",", ""));
        _SellPriceDec = _SellPriceDec * Convert.ToDecimal(dtCustPriceSched.Rows[dataRow]["AltSellStkUMQty"].ToString());
        string _SellPriceStr = String.Format("{0:c}", _SellPriceDec).ToString().Trim().Replace("$", "").Replace(",", "");
        UpdateDataSet(rowId, "FutSellPrice", _SellPriceStr);

        //Set focus on FutAltSellPrice in next record
        string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
        if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
        string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtAltPriceFutGrid";
        smCustPriceSched.SetFocus(nextCtl.ToString());

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scroll", "ScrollIt();", true);
    }

    protected void txtDiscFutGrid_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        TextBox _txtDiscFutGrid = sender as TextBox;
        if (string.IsNullOrEmpty(_txtDiscFutGrid.Text))
            _txtDiscFutGrid.Text = "0";

        //Update the DataSet
        string rowId = _txtDiscFutGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtDiscFutGrid", "");
        _txtDiscFutGrid.Text = _txtDiscFutGrid.Text.ToString().Trim().Replace("%", "").Replace(",", "");
        UpdateDataSet(rowId, "FutDiscPct", _txtDiscFutGrid.Text);

        //Set focus on FutDiscPct in next record
        string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
        if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
        string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtDiscFutGrid";
        smCustPriceSched.SetFocus(nextCtl.ToString());

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scroll", "ScrollIt();", true);
    }
    #endregion  //DataGrid change events
    #endregion  //Change Events

    #region DataGrid
    private void BindDataGrid()
    {
        dtCustPriceSched = (DataTable)Session["dtCustPrice"];
        String sortExpression = (hidSort.Value == "") ? " ItemNo ASC" : hidSort.Value;
        dtCustPriceSched.DefaultView.Sort = sortExpression;
        hidRowCount.Value = dtCustPriceSched.Rows.Count.ToString();
        Session["dtCustPrice"] = dtCustPriceSched.DefaultView.ToTable();

        dgCustPriceSched.DataSource = dtCustPriceSched;
        dgCustPriceSched.DataBind();
        pnlPriceGrid.Update();

        if (dtCustPriceSched.Rows.Count == 0)
            DisplaStatusMessage("No records found", "fail");

        Pager1.InitPager(dgCustPriceSched, PageSize);
        pnlPager.Update();
    }

    protected void dgCustPriceSched_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
            Label lblNoAction = e.Item.FindControl("lblNoAction") as Label;            

            if (hidSecurity.Value.ToString() == "Full")
            {   
                lblNoAction.Visible = false;
                lnkDelete.Visible = true;
            }
            else
            {   
                lblNoAction.Visible = true;
                lnkDelete.Visible = false;
            }

            TextBox _txtEffDtGrid = e.Item.FindControl("txtEffDtGrid") as TextBox;
            if (!string.IsNullOrEmpty(_txtEffDtGrid.Text))
                _txtEffDtGrid.Text = String.Format("{0:MM/dd/yyyy}", Convert.ToDateTime(_txtEffDtGrid.Text)).ToString().Trim();

            TextBox _txtEffEndDtGrid = e.Item.FindControl("txtEffEndDtGrid") as TextBox;
            if (!string.IsNullOrEmpty(_txtEffEndDtGrid.Text))
                _txtEffEndDtGrid.Text = String.Format("{0:MM/dd/yyyy}", Convert.ToDateTime(_txtEffEndDtGrid.Text)).ToString().Trim();

            TextBox _txtAltPriceGrid = e.Item.FindControl("txtAltPriceGrid") as TextBox;
            _txtAltPriceGrid.Text = String.Format("{0:c}", Convert.ToDecimal(_txtAltPriceGrid.Text)).ToString().Trim();

            //TextBox _txtSellPriceGrid = e.Item.Cells[5].FindControl("txtSellPriceGrid") as TextBox;
            //_txtSellPriceGrid.Text = String.Format("{0:c}", Convert.ToDecimal(_txtSellPriceGrid.Text)).ToString().Trim();
            Label _lblSellPriceGrid = e.Item.FindControl("lblSellPriceGrid") as Label;
            _lblSellPriceGrid.Text = String.Format("{0:c}", Convert.ToDecimal(_lblSellPriceGrid.Text)).ToString().Trim();

            TextBox _txtDiscGrid = e.Item.FindControl("txtDiscGrid") as TextBox;
            _txtDiscGrid.Text = String.Format("{0:0.00%}", Convert.ToDecimal(_txtDiscGrid.Text) / 100).ToString().Trim().Replace("%", "");

            TextBox _txtEffDtFutGrid = e.Item.FindControl("txtEffDtFutGrid") as TextBox;
            if (!string.IsNullOrEmpty(_txtEffDtFutGrid.Text))
                _txtEffDtFutGrid.Text = String.Format("{0:MM/dd/yyyy}", Convert.ToDateTime(_txtEffDtFutGrid.Text)).ToString().Trim();

            TextBox _txtEffEndDtFutGrid = e.Item.FindControl("txtEffEndDtFutGrid") as TextBox;
            if (!string.IsNullOrEmpty(_txtEffEndDtFutGrid.Text))
                _txtEffEndDtFutGrid.Text = String.Format("{0:MM/dd/yyyy}", Convert.ToDateTime(_txtEffEndDtFutGrid.Text)).ToString().Trim();
            
            TextBox _txtAltPriceFutGrid = e.Item.FindControl("txtAltPriceFutGrid") as TextBox;
            _txtAltPriceFutGrid.Text = String.Format("{0:c}", Convert.ToDecimal(_txtAltPriceFutGrid.Text)).ToString().Trim();

            //TextBox _txtSellPriceFutGrid = e.Item.Cells[5].FindControl("txtSellPriceFutGrid") as TextBox;
            //_txtSellPriceFutGrid.Text = String.Format("{0:c}", Convert.ToDecimal(_txtSellPriceFutGrid.Text)).ToString().Trim();
            Label _lblSellPriceFutGrid = e.Item.FindControl("lblSellPriceFutGrid") as Label;
            _lblSellPriceFutGrid.Text = String.Format("{0:c}", Convert.ToDecimal(_lblSellPriceFutGrid.Text)).ToString().Trim();

            TextBox _txtDiscFutGrid = e.Item.FindControl("txtDiscFutGrid") as TextBox;
            _txtDiscFutGrid.Text = String.Format("{0:0.00%}", Convert.ToDecimal(_txtDiscFutGrid.Text) / 100).ToString().Trim().Replace("%", "");


            // In LLL Mode make all the controls read only
            if (PageMode == "lllcontracts")
            {
                TextBox _txtPriceMethGrid = e.Item.FindControl("txtPriceMethGrid") as TextBox;
                lnkDelete.Visible = false;
                _txtPriceMethGrid.Enabled = _txtEffDtGrid.Enabled = _txtEffEndDtGrid.Enabled = _txtAltPriceGrid.Enabled = _txtDiscGrid.Enabled = false;
                _txtEffDtFutGrid.Enabled = _txtEffEndDtFutGrid.ReadOnly = _txtAltPriceFutGrid.ReadOnly = _txtDiscFutGrid.ReadOnly = false;
            }
        }
    }

    protected void dgCustPriceSched_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        hidRecID.Value = e.CommandArgument.ToString().Trim();

        if (e.CommandName == "Delete")
        {
            if (hidDelConf.Value == "true")
            {
                DelCustPriceSched();
                BindDataGrid();
            }
        }
    }

    protected void dgCustPriceSched_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgCustPriceSched.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }
    #endregion

    #region I/O
    public DataSet GetCustPriceSched()
    {
        //try
        //{
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pMaintCustPriceSched",
                                                new SqlParameter("@Mode", "Select"),
                                                new SqlParameter("@CustPriceID", 0),
                                                new SqlParameter("@ContractID", lblContract.Text.Trim()),
                                                new SqlParameter("@ItemNo", null),
                                                new SqlParameter("@PriceMethod", null),
                                                new SqlParameter("@EffDt", null),
                                                new SqlParameter("@AltSellPrice", null),
                                                new SqlParameter("@ContractPrice", null),
                                                new SqlParameter("@DiscPct", null),
                                                new SqlParameter("@PriceMethodFut", null),
                                                new SqlParameter("@EffDtFut", null),
                                                new SqlParameter("@AltSellPriceFut", null),
                                                new SqlParameter("@ContractPriceFut", null),
                                                new SqlParameter("@DiscPctFut", null),
                                                new SqlParameter("@UserName", null),
                                                new SqlParameter("@itemType", itemType),
                                                new SqlParameter("@catgoryNo", categoryNo),
                                                new SqlParameter("@EffEndDt", ""),
                                                new SqlParameter("@EffEndDtFut", ""));
            return dsResult;
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
    }

    private void AddCustPriceSched()
    {
        string priceMeth = "";
        string effDt = null;
        string effEndDt = null;
        decimal altPrice = 0;
        decimal sellPrice = 0;
        decimal discPct = 0;

        string priceMethFut = "";
        string effDtFut = null;
        string effEndDtFut = null;
        decimal altPriceFut = 0;
        decimal sellPriceFut = 0;
        decimal discPctFut = 0;

        if (!string.IsNullOrEmpty(txtPriceMeth.Text.ToString().Trim()))
            priceMeth = txtPriceMeth.Text.ToString().Trim();

        if (!string.IsNullOrEmpty(dtEffDt.SelectedDate.ToString()))
            effDt = dtEffDt.SelectedDate.ToString();

        if (!string.IsNullOrEmpty(dpEffEndDt.SelectedDate.ToString()))
            effEndDt = dpEffEndDt.SelectedDate.ToString();

        if (!string.IsNullOrEmpty(txtAltPrice.Text.ToString()))
            altPrice = Convert.ToDecimal(txtAltPrice.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        //if (!string.IsNullOrEmpty(txtSellPrice.Text.ToString()))
        //    sellPrice = Convert.ToDecimal(txtSellPrice.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));
        if (!string.IsNullOrEmpty(lblSellPrice.Text.ToString()))
            sellPrice = Convert.ToDecimal(lblSellPrice.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        if (!string.IsNullOrEmpty(txtDisc.Text.ToString()))
            discPct = Convert.ToDecimal(txtDisc.Text);

        if (!string.IsNullOrEmpty(txtPriceMethFut.Text.ToString().Trim()))
            priceMethFut = txtPriceMethFut.Text.ToString().Trim();

        if (!string.IsNullOrEmpty(dtEffDtFut.SelectedDate.ToString()))
            effDtFut = dtEffDtFut.SelectedDate.ToString();

        if (!string.IsNullOrEmpty(dpEffEndDatFut.SelectedDate.ToString()))
            effEndDtFut = dpEffEndDatFut.SelectedDate.ToString();

        if (!string.IsNullOrEmpty(txtAltPriceFut.Text.ToString()))
            altPriceFut = Convert.ToDecimal(txtAltPriceFut.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        //if (!string.IsNullOrEmpty(txtSellPriceFut.Text.ToString()))
        //    sellPriceFut = Convert.ToDecimal(txtSellPriceFut.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));
        if (!string.IsNullOrEmpty(lblSellPriceFut.Text.ToString()))
            sellPriceFut = Convert.ToDecimal(lblSellPriceFut.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        if (!string.IsNullOrEmpty(txtDiscFut.Text.ToString()))
            discPctFut = Convert.ToDecimal(txtDiscFut.Text);

        //try
        //{
            //Add the record to the Database
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pMaintCustPriceSched",
                                                new SqlParameter("@Mode", "Add"),
                                                new SqlParameter("@CustPriceID", 0),
                                                new SqlParameter("@ContractID", lblContract.Text.ToString().Trim()),
                                                new SqlParameter("@ItemNo", txtItem.Text.ToString().Trim()),
                                                new SqlParameter("@PriceMethod", priceMeth),
                                                new SqlParameter("@EffDt", effDt),
                                                new SqlParameter("@AltSellPrice", altPrice),
                                                new SqlParameter("@ContractPrice", sellPrice),
                                                new SqlParameter("@DiscPct", discPct),
                                                new SqlParameter("@PriceMethodFut", priceMethFut),
                                                new SqlParameter("@EffDtFut", effDtFut),
                                                new SqlParameter("@AltSellPriceFut", altPriceFut),
                                                new SqlParameter("@ContractPriceFut", sellPriceFut),
                                                new SqlParameter("@DiscPctFut", discPctFut),
                                                new SqlParameter("@UserName", Session["UserName"].ToString()),
                                                new SqlParameter("@ItemType", null),
                                                new SqlParameter("@catgoryNo", ""),
                                                new SqlParameter("@EffEndDt", effEndDt),
                                                new SqlParameter("@EffEndDtFut", effEndDtFut));

            //Add the record to the DataTable
            if (dsResult.Tables[0].DefaultView.ToTable().Rows.Count > 0 && PageMode != "singleitem")
            {
                dtCustPriceSched = (DataTable)Session["dtCustPrice"];
                DataRow newCustPriceRow = dsResult.Tables[0].DefaultView.ToTable().Rows[0];
                dtCustPriceSched.ImportRow(newCustPriceRow);
                Session["dtCustPrice"] = dtCustPriceSched.DefaultView.ToTable();
            }

            DisplaStatusMessage("Record Added", "success");
            ClearFields();
        //}
        //catch (Exception ex) { }
    }

    private void UpdateCustPriceFromHeader()
    {
        string priceMeth = "";
        string effDt = null;
        string effEndDt = null;
        decimal altPrice = 0;
        decimal sellPrice = 0;
        decimal discPct = 0;

        string priceMethFut = "";
        string effDtFut = null;
        string effEndDtFut = null;
        decimal altPriceFut = 0;
        decimal sellPriceFut = 0;
        decimal discPctFut = 0;

        priceMeth = txtPriceMeth.Text.Trim();
        if (!string.IsNullOrEmpty(dtEffDt.SelectedDate) &&
            Convert.ToDateTime(dtEffDt.SelectedDate.ToString()) != Convert.ToDateTime("1753-01-01"))            
            effDt = dtEffDt.SelectedDate.ToString();

        if (!string.IsNullOrEmpty(dpEffEndDt.SelectedDate) &&
            Convert.ToDateTime(dpEffEndDt.SelectedDate) != Convert.ToDateTime("1753-01-01"))
            effEndDt = dpEffEndDt.SelectedDate.ToString();

        if (!string.IsNullOrEmpty(txtAltPrice.Text))
            altPrice = Convert.ToDecimal(txtAltPrice.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        if (!string.IsNullOrEmpty(lblSellPrice.Text))
            sellPrice = Convert.ToDecimal(lblSellPrice.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        if (!string.IsNullOrEmpty(txtDisc.Text))
            discPct = Convert.ToDecimal(txtDisc.Text);

        if (!string.IsNullOrEmpty(txtPriceMethFut.Text))
            priceMethFut = txtPriceMethFut.Text.Trim();

        if (!string.IsNullOrEmpty(dtEffDtFut.SelectedDate) &&
            Convert.ToDateTime(dtEffDtFut.SelectedDate) != Convert.ToDateTime("1753-01-01"))            
            effDtFut = dtEffDtFut.SelectedDate;

        if (!string.IsNullOrEmpty(dpEffEndDatFut.SelectedDate) &&
           Convert.ToDateTime(dpEffEndDatFut.SelectedDate) != Convert.ToDateTime("1753-01-01"))            
            effEndDtFut = dpEffEndDatFut.SelectedDate;

        if (!string.IsNullOrEmpty(txtAltPriceFut.Text))
            altPriceFut = Convert.ToDecimal(txtAltPriceFut.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        if (!string.IsNullOrEmpty(lblSellPriceFut.Text))
            sellPriceFut = Convert.ToDecimal(lblSellPriceFut.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

        if (!string.IsNullOrEmpty(txtDiscFut.Text))
            discPctFut = Convert.ToDecimal(txtDiscFut.Text);

        DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pMaintCustPriceSched",
                                            new SqlParameter("@Mode", "Update"),            
                                            new SqlParameter("@CustPriceID", hidpCustomerPriceID.Value),
                                            new SqlParameter("@ContractID", null),
                                            new SqlParameter("@ItemNo", null),
                                            new SqlParameter("@PriceMethod", priceMeth),
                                            new SqlParameter("@EffDt", effDt),
                                            new SqlParameter("@AltSellPrice", altPrice),
                                            new SqlParameter("@ContractPrice", sellPrice),
                                            new SqlParameter("@DiscPct", discPct),
                                            new SqlParameter("@PriceMethodFut", priceMethFut),
                                            new SqlParameter("@EffDtFut", effDtFut),
                                            new SqlParameter("@AltSellPriceFut", altPriceFut),
                                            new SqlParameter("@ContractPriceFut", sellPriceFut),
                                            new SqlParameter("@DiscPctFut", discPctFut),
                                            new SqlParameter("@UserName", Session["UserName"].ToString()),
                                            new SqlParameter("@ItemType", null),
                                            new SqlParameter("@catgoryNo", ""),
                                            new SqlParameter("@EffEndDt", effEndDt),
                                            new SqlParameter("@EffEndDtFut", effEndDtFut));

        if( PageMode != "singleitem")
        {
            //Add the record to the DataTable              
            btnSearch_Click(btnSave, new ImageClickEventArgs(0, 0));        
        }

        DisplaStatusMessage("Record has been modified", "success");
        hidMode.Value = "Add";
        ClearFields();
    }


    private void DelCustPriceSched()
    {
        //try
        //{
            //Delete the record from the Database
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pMaintCustPriceSched",
                                                new SqlParameter("@Mode", "Delete"),
                                                //new SqlParameter("@CustPriceID", Session["CPSRecID"].ToString()),
                                                new SqlParameter("@CustPriceID", hidRecID.Value),
                                                new SqlParameter("@ContractID", null),
                                                new SqlParameter("@ItemNo", null),
                                                new SqlParameter("@PriceMethod", null),
                                                new SqlParameter("@EffDt", null),
                                                new SqlParameter("@AltSellPrice", null),
                                                new SqlParameter("@ContractPrice", null),
                                                new SqlParameter("@DiscPct", null),
                                                new SqlParameter("@PriceMethodFut", null),
                                                new SqlParameter("@EffDtFut", null),
                                                new SqlParameter("@AltSellPriceFut", null),
                                                new SqlParameter("@ContractPriceFut", null),
                                                new SqlParameter("@DiscPctFut", null),
                                                new SqlParameter("@UserName", null),
                                                new SqlParameter("@ItemType", null),
                                                new SqlParameter("@catgoryNo", ""),
                                                new SqlParameter("@EffEndDt", ""),
                                                new SqlParameter("@EffEndDtFut", ""));

            //Remove the record from the DataTable
            dtCustPriceSched = (DataTable)Session["dtCustPrice"];
            DataRow[] dr = dtCustPriceSched.Select("pCustomerPriceID = " + hidRecID.Value);
            dtCustPriceSched.Rows.Remove(dr[0]);
            Session["dtCustPrice"] = dtCustPriceSched.DefaultView.ToTable();
        
            DisplaStatusMessage("Record Deleted", "success");
        //}
        //catch (Exception ex) {}
    }

    private void UpdCustPriceSched(int rowID)
    {
        string priceMeth = "";
        string effDt = null;
        string effEndDt = null;
        decimal altPrice = 0;
        decimal sellPrice = 0;
        decimal discPct = 0;

        string priceMethFut = "";
        string effDtFut = null;
        string effEndDtFut = null;
        decimal altPriceFut = 0;
        decimal sellPriceFut = 0;
        decimal discPctFut = 0;

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["PriceMethod"].ToString().Trim()))
            priceMeth = dtCustPriceSched.Rows[rowID]["PriceMethod"].ToString().Trim();

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["EffDt"].ToString()) &&
            Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["EffDt"].ToString()) != Convert.ToDateTime("1753-01-01"))
            //effDt = dtCustPriceSched.Rows[rowID]["EffDt"].ToString();
            effDt = Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["EffDt"].ToString()).ToString();

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["EffEndDt"].ToString()) &&
            Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["EffEndDt"].ToString()) != Convert.ToDateTime("1753-01-01"))            
            effEndDt = Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["EffEndDt"].ToString()).ToString();

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["AltSellPrice"].ToString()))
            altPrice = Convert.ToDecimal(dtCustPriceSched.Rows[rowID]["AltSellPrice"]);

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["SellPrice"].ToString()))
            sellPrice = Convert.ToDecimal(dtCustPriceSched.Rows[rowID]["SellPrice"]);

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["DiscPct"].ToString()))
            discPct = Convert.ToDecimal(dtCustPriceSched.Rows[rowID]["DiscPct"]);

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["FutPriceMethod"].ToString().Trim()))
            priceMethFut = dtCustPriceSched.Rows[rowID]["FutPriceMethod"].ToString().Trim();

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["FutEffDt"].ToString()) &&
            Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["FutEffDt"].ToString()) != Convert.ToDateTime("1753-01-01"))
            //effDtFut = dtCustPriceSched.Rows[rowID]["FutEffDt"].ToString();
            effDtFut = Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["FutEffDt"].ToString()).ToString();

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["FutEffEndDt"].ToString()) &&
           Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["FutEffEndDt"].ToString()) != Convert.ToDateTime("1753-01-01"))
            //effDtFut = dtCustPriceSched.Rows[rowID]["FutEffDt"].ToString();
            effEndDtFut = Convert.ToDateTime(dtCustPriceSched.Rows[rowID]["FutEffEndDt"].ToString()).ToString();

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["FutAltSellPrice"].ToString()))
            altPriceFut = Convert.ToDecimal(dtCustPriceSched.Rows[rowID]["FutAltSellPrice"]);

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["FutSellPrice"].ToString()))
            sellPriceFut = Convert.ToDecimal(dtCustPriceSched.Rows[rowID]["FutSellPrice"]);

        if (!string.IsNullOrEmpty(dtCustPriceSched.Rows[rowID]["FutDiscPct"].ToString()))
            discPctFut = Convert.ToDecimal(dtCustPriceSched.Rows[rowID]["FutDiscPct"]);
        
        //try
        //{
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pMaintCustPriceSched",
                                                new SqlParameter("@Mode", "Update"),
                                                //new SqlParameter("@CustPriceID", Session["CPSRecID"].ToString()),
                                                new SqlParameter("@CustPriceID", dtCustPriceSched.Rows[rowID]["pCustomerPriceID"].ToString()),
                                                new SqlParameter("@ContractID", null),
                                                new SqlParameter("@ItemNo", null),
                                                new SqlParameter("@PriceMethod", priceMeth),
                                                new SqlParameter("@EffDt", effDt),
                                                new SqlParameter("@AltSellPrice", altPrice),
                                                new SqlParameter("@ContractPrice", sellPrice),
                                                new SqlParameter("@DiscPct", discPct),
                                                new SqlParameter("@PriceMethodFut", priceMethFut),
                                                new SqlParameter("@EffDtFut", effDtFut),
                                                new SqlParameter("@AltSellPriceFut", altPriceFut),
                                                new SqlParameter("@ContractPriceFut", sellPriceFut),
                                                new SqlParameter("@DiscPctFut", discPctFut),
                                                new SqlParameter("@UserName", dtCustPriceSched.Rows[rowID]["ChangeID"].ToString()),
                                                new SqlParameter("@ItemType", null),
                                                new SqlParameter("@catgoryNo", ""),
                                                new SqlParameter("@EffEndDt", effEndDt),
                                                new SqlParameter("@EffEndDtFut", effEndDtFut));
        //}
        //catch (Exception ex) { }
    }

    protected void UpdateDataSet(string rowId, string rowName, string rowValue)
    {
        DropDownList _ddlPageNo = Pager1.FindControl("ddlPages") as DropDownList;
        int updRow = ((Convert.ToInt16(_ddlPageNo.SelectedItem.Text) - 1) * PageSize) + Convert.ToInt16(rowId) - dgOffSet;
        dtCustPriceSched = (DataTable)Session["dtCustPrice"];

        // if user changed the price updated margin
        if (rowName.ToLower() == "sellprice")
        {
            if(Convert.ToDecimal(rowValue) > 0)
            {
                //(CP.ContractPrice-isnull(IB.UnitCost,0))/CP.ContractPrice)*100 
                decimal _contractPrice = Convert.ToDecimal(rowValue);
                decimal _AvgCost = Convert.ToDecimal(dtCustPriceSched.Rows[updRow]["UnitCost"]);
                decimal _RplcCost = Convert.ToDecimal(dtCustPriceSched.Rows[updRow]["ReplacementCost"]);

                dtCustPriceSched.Rows[updRow]["GMPctAvg"] = (((_contractPrice - _AvgCost)/ _contractPrice) * 100);
                dtCustPriceSched.Rows[updRow]["GMPctRpl"] = (((_contractPrice - _RplcCost) / _contractPrice) * 100);
            }
            else
            {
                dtCustPriceSched.Rows[updRow]["GMPctAvg"]  = "0.00";
                dtCustPriceSched.Rows[updRow]["GMPctRpl"]  = "0.00";
            }
        }

        dtCustPriceSched.Rows[updRow][rowName.ToString()] = rowValue.ToString();
        dtCustPriceSched.Rows[updRow]["ChangeID"] = Session["UserName"].ToString();
        dtCustPriceSched.Rows[updRow]["ChangeDt"] = DateTime.Now;
        UpdCustPriceSched(updRow);

        dgCustPriceSched.DataSource = dtCustPriceSched.DefaultView.ToTable();
        dgCustPriceSched.AllowPaging = true;
        dgCustPriceSched.DataBind();
        pnlPriceGrid.Update();

        Session["dtCustPrice"] = dtCustPriceSched.DefaultView.ToTable();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string[] ValidateItem(string itemNo)
    {
        string[] result = new string[10];
        result[0] = "false";

        DataSet dsItem = SqlHelper.ExecuteDataset(cnERP, "pMaintCustPriceSched",
                                            new SqlParameter("@Mode", "Item"),
                                            new SqlParameter("@CustPriceID", null),
                                            new SqlParameter("@ContractID", null),
                                            new SqlParameter("@ItemNo", itemNo),
                                            new SqlParameter("@PriceMethod", null),
                                            new SqlParameter("@EffDt", null),
                                            new SqlParameter("@AltSellPrice", null),
                                            new SqlParameter("@ContractPrice", null),
                                            new SqlParameter("@DiscPct", null),
                                            new SqlParameter("@PriceMethodFut", null),
                                            new SqlParameter("@EffDtFut", null),
                                            new SqlParameter("@AltSellPriceFut", null),
                                            new SqlParameter("@ContractPriceFut", null),
                                            new SqlParameter("@DiscPctFut", null),
                                            new SqlParameter("@UserName", null),
                                            new SqlParameter("@ItemType", null),
                                            new SqlParameter("@catgoryNo", ""),
                                            new SqlParameter("@EffEndDt", ""),
                                            new SqlParameter("@EffEndDtFut", ""));

        if (dsItem.Tables[0].Rows.Count > 0)
        {
            result[0] = "true";    //Valid Item
            result[1] = dsItem.Tables[0].Rows[0]["SellUM"].ToString();
            result[2] = dsItem.Tables[0].Rows[0]["SellStkUM"].ToString();
            result[3] = dsItem.Tables[0].Rows[0]["AltSellStkUMQty"].ToString();
            result[4] = DateTime.Now.ToShortDateString(); // effective date
            result[5] = dsItem.Tables[0].Rows[0]["ItemDesc"].ToString();
            result[6] = dsItem.Tables[0].Rows[0]["SellStkUMQty"].ToString();


            DateTime _90DaysFromNow = DateTime.Now.AddDays(90);
            DateTime firstDayOfTheMonth = new DateTime(_90DaysFromNow.Year, _90DaysFromNow.Month, 1);
            result[7] = firstDayOfTheMonth.AddMonths(1).ToShortDateString();

            Session["ItemMasterRecord"] = result; // if item found load it to session variable (to avoid extra DB call)
        }
        else
            result[0] = "false";   //Invalid Item

        return result;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string CheckDup(string contractName, string itemNo)
    {
        string status = "";
        
        DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pMaintCustPriceSched",
                                            new SqlParameter("@Mode", "Dup"),
                                            new SqlParameter("@CustPriceID", 0),
                                            new SqlParameter("@ContractID", contractName),
                                            new SqlParameter("@ItemNo", itemNo),
                                            new SqlParameter("@PriceMethod", null),
                                            new SqlParameter("@EffDt", null),
                                            new SqlParameter("@AltSellPrice", null),
                                            new SqlParameter("@ContractPrice", null),
                                            new SqlParameter("@DiscPct", null),
                                            new SqlParameter("@PriceMethodFut", null),
                                            new SqlParameter("@EffDtFut", null),
                                            new SqlParameter("@AltSellPriceFut", null),
                                            new SqlParameter("@ContractPriceFut", null),
                                            new SqlParameter("@DiscPctFut", null),
                                            new SqlParameter("@UserName", null),
                                            new SqlParameter("@ItemType", null),
                                            new SqlParameter("@catgoryNo", ""),
                                            new SqlParameter("@EffEndDt", ""),
                                            new SqlParameter("@EffEndDtFut", ""));

        if (dsResult.Tables[0].Rows.Count > 0)
        {
            status = "true";    //Duplicate found
            Session["ItemPriceRecord"] = dsResult.Tables[0]; // if item already exist load it to session variable (to avoid extra DB call)
        }
        else
            status = "false";   //No duplicate found

        return status;
    }

    #endregion

    protected void ClearFields()
    {
        txtItem.Text = "";
        
        txtPriceMeth.Text = "";
        dtEffDt.SelectedDate = "";
        dpEffEndDt.SelectedDate = "";
        txtAltPrice.Text = "";
        lblAltPriceUM.Text = "";
        //txtSellPrice.Text = "";
        lblSellPrice.Text = "";
        lblSellPriceUM.Text = "";
        txtDisc.Text = "";

        txtPriceMethFut.Text = "";
        dtEffDtFut.SelectedDate = "";
        txtAltPriceFut.Text = "";
        lblAltPriceFutUM.Text = "";
        //txtSellPriceFut.Text = "";
        lblSellPriceFut.Text = "";
        lblSellPriceFutUM.Text = "";
        txtDiscFut.Text = "";

        lblUOM.Text = "";
        lblPcs.Text = "";
        lblDesc.Text = ""; 

        if (PageMode == "singleitem")
            txtPriceMeth.Text = "P";
    }

    static bool ValidateDate(String date, String format)
    {
        try
        {
            System.Globalization.DateTimeFormatInfo dtfi = new System.Globalization.DateTimeFormatInfo();
            dtfi.ShortDatePattern = format;
            DateTime dt = DateTime.ParseExact(date, format, dtfi);
        }
        catch (Exception)
        {
            return false;
        }
        return true;
    }

    //
    //Determine user security for this page
    //For CustPriceSchedMaint: ADMIN (W); MAINTENANCE (W); CustPriceMaint (W)
    //
    private void GetSecurity()
    {
        hidSecurity.Value = MaintClass.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CustPriceSchedMaint);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";

        //
        //If the page does not allow 'Query' only, change to 'None'
        //
        if (hidSecurity.Value.ToString() == "Query")
            hidSecurity.Value = "None";


        //Hard code the security value(s) until specific security is implemented
        //Toggle between Query, Full and None
        //hidSecurity.Value = "Query";
        //hidSecurity.Value = "Full";
        //hidSecurity.Value = "None";


        switch (hidSecurity.Value.ToString())
        {
            case "None":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
                break;
            case "Full":
                break;
        }
    }

    private void DisplaStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
        pnlProgress.Update();
    }

    [Ajax.AjaxMethod()]
    public void UnloadPage()
    {
        Session["dtCustPrice"] = "";
    }

    protected void btnReloadItem_Click(object sender, EventArgs e)
    {
        DataTable dtItemInfo = Session["ItemPriceRecord"] as DataTable;
        DataRow drItemInfo = dtItemInfo.Rows[0];

        hidMode.Value = "Edit";
        hidpCustomerPriceID.Value = drItemInfo["pCustomerPriceID"].ToString().Trim();
        txtPriceMeth.Text = drItemInfo["PriceMethod"].ToString().Trim();
        dtEffDt.SelectedDate = (drItemInfo["EffDt"].ToString() != "" ? Convert.ToDateTime(drItemInfo["EffDt"].ToString()).ToShortDateString() : "");
        dpEffEndDt.SelectedDate = (drItemInfo["EffEndDt"].ToString() != "" ? Convert.ToDateTime(drItemInfo["EffEndDt"].ToString()).ToShortDateString() : "");
        txtAltPrice.Text = Math.Round(Convert.ToDecimal(drItemInfo["AltSellPrice"].ToString()), 2).ToString();
        lblSellPrice.Text = Math.Round(Convert.ToDecimal(drItemInfo["ContractPrice"].ToString()), 2).ToString();
        txtDisc.Text = drItemInfo["DiscPct"].ToString();
        txtPriceMethFut.Text = drItemInfo["FutPriceMetod"].ToString().Trim();
        dtEffDtFut.SelectedDate = (drItemInfo["FutEffDt"].ToString() != "" ? Convert.ToDateTime(drItemInfo["FutEffDt"].ToString()).ToShortDateString() : "");
        dpEffEndDatFut.SelectedDate = (drItemInfo["FutEffEndDt"].ToString() != "" ? Convert.ToDateTime(drItemInfo["FutEffEndDt"].ToString()).ToShortDateString() : "");
        txtAltPriceFut.Text = drItemInfo["FutAltSellPrice"].ToString();
        lblSellPriceFut.Text = drItemInfo["FutContractPrice"].ToString();
        txtDiscFut.Text = drItemInfo["FutDiscPct"].ToString();

        string[] itemMaster = Session["ItemMasterRecord"] as string[];                
        lblUOM.Text = itemMaster[2];
        lblDesc.Text = itemMaster[5];
        lblPcs.Text = itemMaster[6];

    }
}
