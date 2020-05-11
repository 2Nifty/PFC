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

public partial class CustPriceSchedMaint : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    DataSet dsCustPriceSched;
    DataTable dtCustPriceSched;
    string dtFormat = "MM/dd/yyyy";
    string PageMode = "";

    int PageSize = 18;
    int dgOffSet = 3;

    CustomerMaintenance CustClass = new CustomerMaintenance();
    MaintenanceUtility MaintClass = new MaintenanceUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CustPriceSchedMaint));

        if (!Page.IsPostBack)
        {
            GetSecurity();
            CustClass.BindListControls(ddlContract, "ListValue", "ListValue", CustClass.GetListDetails("CustContractSchd"), "-- Select --");
        }

        if (pnlTop.Visible == true)
            if (string.IsNullOrEmpty(txtItem.Text.ToString()))
            {
                hidSellUM.Value = "";
                hidSellStkUM.Value = "";
                hidAltSellStkUMQty.Value = "1";

                //txtAltPrice.Text = "";
                //lblAltPriceUM.Text = "";
                //lblSellPrice.Text = "";
                //lblSellPriceUM.Text = "";
                //txtAltPriceFut.Text = "";
                //lblAltPriceFutUM.Text = "";
                //lblSellPriceFut.Text = "";
                //lblSellPriceFutUM.Text = "";
            }
            else
            {
                if (string.IsNullOrEmpty(txtAltPrice.Text.ToString()))
                {
                    //lblAltPriceUM.Text = "";
                    lblSellPrice.Text = "";
                    lblSellPriceUM.Text = "";
                }
//                else
                    lblAltPriceUM.Text = "&nbsp;/&nbsp;" + hidSellUM.Value;

                if (string.IsNullOrEmpty(txtAltPriceFut.Text.ToString()))
                {
//                    lblAltPriceFutUM.Text = "";
                    lblSellPriceFut.Text = "";
                    lblSellPriceFutUM.Text = "";
                }
//                else
                    lblAltPriceFutUM.Text = "&nbsp;/&nbsp;" + hidSellUM.Value;

                //lblSellPriceUM.Text = "&nbsp;/&nbsp;" + hidSellStkUM.Value;
                //lblSellPriceFutUM.Text = "&nbsp;/&nbsp;" + hidSellStkUM.Value;
            }

        if (Request.QueryString["Mode"] != null && Request.QueryString["Mode"].ToLower() == "singleitem")
        {
            PageMode = Request.QueryString["Mode"].ToLower();

            //btnSearch.Visible  = false;
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
        ClearFields();
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
        if (ddlContract.SelectedIndex == 0)
        {
            DisplaStatusMessage("Please select a valid Contract Name", "fail");
        }
        else
        {
            if (string.IsNullOrEmpty(txtItem.Text.ToString()))
            {
                DisplaStatusMessage("Please enter a valid Item No", "fail");
            }
            else
            {
                AddCustPriceSched();
                if (tPager.Visible == true)
                    BindDataGrid();
            }
            smCustPriceSched.SetFocus(txtItem);
        }
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        ClearFields();
        lblMessage.Text = "";
        pnlProgress.Update();
        ContentTable.Visible = false;
        btnSave.Visible = false;
        btnCancel.Visible = false;
        divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 505px; border: 0px solid; vertical-align: top;";
        pnlTop.Update();
        pnlContent.Update();
        pnlPriceGrid.Update();
    }
    #endregion

    #region Change Events
    protected void ddlContract_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        if (ddlContract.SelectedIndex == 0)
            lblContract.Text = "Select a valid Contract above";
        else
        {
            lblContract.Text = ddlContract.SelectedItem.ToString().Trim();
            if (!string.IsNullOrEmpty(txtItem.Text))
            {
                string status = CheckDup(lblContract.Text, txtItem.Text);
                if (status == "true")   //Duplicate found
                {
                    DisplaStatusMessage("Item " + txtItem.Text + " already exists on Contract " + lblContract.Text, "fail");
                    txtItem.Text = "";
                    smCustPriceSched.SetFocus(txtItem);
                }
            }
        }
        pnlContent.Update();
    }

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
            //smCustPriceSched.SetFocus(txtSellPrice);
            smCustPriceSched.SetFocus(txtDisc);
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

    //protected void txtSellPriceGrid_TextChanged(object sender, EventArgs e)
    //{
    //    lblMessage.Text = "";
    //    pnlProgress.Update();

    //    TextBox _txtSellPriceGrid = sender as TextBox;
    //    if (string.IsNullOrEmpty(_txtSellPriceGrid.Text))
    //        _txtSellPriceGrid.Text = "0";

    //    //Update the DataSet
    //    string rowId = _txtSellPriceGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtSellPriceGrid", "");
    //    _txtSellPriceGrid.Text = _txtSellPriceGrid.Text.ToString().Trim().Replace("$", "").Replace(",", "");
    //    UpdateDataSet(rowId, "SellPrice", _txtSellPriceGrid.Text);

    //    //Set focus on SellPrice in next record
    //    string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
    //    if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
    //    string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtSellPriceGrid";
    //    smCustPriceSched.SetFocus(nextCtl.ToString());
    //}

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

    //protected void txtSellPriceFutGrid_TextChanged(object sender, EventArgs e)
    //{
    //    lblMessage.Text = "";
    //    pnlProgress.Update();

    //    TextBox _txtSellPriceFutGrid = sender as TextBox;
    //    if (string.IsNullOrEmpty(_txtSellPriceFutGrid.Text))
    //        _txtSellPriceFutGrid.Text = "0";

    //    //Update the DataSet
    //    string rowId = _txtSellPriceFutGrid.ClientID.ToString().Replace("dgCustPriceSched_ctl", "").Replace("_txtSellPriceFutGrid", "");
    //    _txtSellPriceFutGrid.Text = _txtSellPriceFutGrid.Text.ToString().Trim().Replace("$", "").Replace(",", "");
    //    UpdateDataSet(rowId, "FutSellPrice", _txtSellPriceFutGrid.Text);

    //    //Set focus on FutSellPrice in next record
    //    string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
    //    if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
    //    string nextCtl = "dgCustPriceSched_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtSellPriceFutGrid";
    //    smCustPriceSched.SetFocus(nextCtl.ToString());

    //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scroll", "ScrollIt();", true);
    //}

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
            if (ddlContract.SelectedIndex == 0)
                DisplaStatusMessage("Please select a valid Contract Name", "fail");
            else
                DisplaStatusMessage("No records found", "fail");

        Pager1.InitPager(dgCustPriceSched, PageSize);
        pnlPager.Update();
    }

    protected void dgCustPriceSched_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            if (hidSecurity.Value.ToString() == "Full")
            {
                Label lblNoAction = e.Item.FindControl("lblNoAction") as Label;
                lblNoAction.Visible = false;

                LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
                lnkDelete.Visible = true;
            }
            else
            {
                Label lblNoAction = e.Item.FindControl("lblNoAction") as Label;
                lblNoAction.Visible = true;

                LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
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
                                                new SqlParameter("@ContractID", ddlContract.SelectedValue.ToString().Trim()),
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
                                                new SqlParameter("@itemType", null),
                                                new SqlParameter("@catgoryNo", ""),
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

        if (!string.IsNullOrEmpty(dpEffEndDtFut.SelectedDate.ToString()))
            effEndDtFut = dpEffEndDtFut.SelectedDate.ToString();

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
                                                new SqlParameter("@ContractID", ddlContract.SelectedItem.ToString().Trim()),
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
                                                new SqlParameter("@itemType", null),
                                                new SqlParameter("@catgoryNo", ""),
                                                new SqlParameter("@EffEndDt", effEndDt),
                                                new SqlParameter("@EffEndDtFut", effEndDtFut));

            //Add the record to the DataTable
            if (dsResult.Tables[0].DefaultView.ToTable().Rows.Count > 0)
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
                                                new SqlParameter("@itemType", null),
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
                                                new SqlParameter("@itemType", null),
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
        string[] result = new string[5];
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
                                            new SqlParameter("@itemType", null),
                                            new SqlParameter("@catgoryNo", ""),
                                            new SqlParameter("@EffEndDt", ""),
                                            new SqlParameter("@EffEndDtFut", ""));

        if (dsItem.Tables[0].Rows.Count > 0)
        {
            result[0] = "true";    //Valid Item
            result[1] = dsItem.Tables[0].Rows[0]["SellUM"].ToString();
            result[2] = dsItem.Tables[0].Rows[0]["SellStkUM"].ToString();
            result[3] = dsItem.Tables[0].Rows[0]["AltSellStkUMQty"].ToString();
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
                                            new SqlParameter("@itemType", null),
                                            new SqlParameter("@catgoryNo", ""),
                                            new SqlParameter("@EffEndDt", ""),
                                            new SqlParameter("@EffEndDtFut", ""));

        if (dsResult.Tables[0].Rows.Count > 0)
            status = "true";    //Duplicate found
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
}
