/********************************************************************************************
 * File	Name			:	DataEntry.aspx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	04/12/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 04/12/2007		    Version 1		A.Nithyapriyadarshini		Created 
  *********************************************************************************************/

#region NameSpace
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
using System.Data.SqlClient;
using GER;
#endregion

public partial class DataEntry : System.Web.UI.Page
{

    #region Global Variable Decalaration
    DataTable dtBillLoad = new DataTable();
    DataTable dtLookup = new DataTable();
    DataTable dtContainer = new DataTable();
    DataTable dtCharge = new DataTable();
    DataTable dtList = new DataTable();
    Utility utility = new Utility();
    DataSet dsReconcile = new DataSet();
    PFC.Intranet.BusinessLogicLayer.GER ger = new PFC.Intranet.BusinessLogicLayer.GER();
    string BOL;
    #endregion

    #region Auto generated events

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(DataEntry));
        AddColumns();

        if (!IsPostBack)
        {
            ViewState["Header"] = "false";
            ViewState["Status"] = "true";
            ViewState["BillData"] = dtBillLoad;

            //
            // Invisible the datagrid when page first time load
            //
            dgContainerCost.Visible = false;
            dgCharges.Visible = false;
            dgList.Visible = false;

            //
            // Call the function to add the empty row
            //
            BindBillData();            
        }
        if (IsPostBack)
        {
            dtBillLoad = ViewState["BillData"] as DataTable;

        }
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
    // 
    // see if args were passed
    int loop1, loop2;
    BOL = "";
    // Load NameValueCollection object.
    System.Collections.Specialized.NameValueCollection coll = Request.QueryString;
    // Get names of all keys into a string array.
    String[] arr1 = coll.AllKeys;
    for (loop1 = 0; loop1 < arr1.Length; loop1++)
    {
        //Response.Write("Key: " + Server.HtmlEncode(arr1[loop1]) + "<br>");
        String[] arr2 = coll.GetValues(arr1[loop1]);
        for (loop2 = 0; loop2 < arr2.Length; loop2++)
        {
            //Response.Write("Value " + loop2 + ": " + Server.HtmlEncode(arr2[loop2]) + "<br>");
        }
        if (arr1[loop1] == "BOL")
        {
            BOL = arr2[0];
        }
    }
    //lblSuccessMessage.Text = "Go PLC" + BOL;
    //FamilyPanel.Update();
    if (BOL != "")
    {
        ViewState["Header"] = "true";
        dtBillLoad.Clear();
        GridVisible(dgBillLoad.ID);
        DataSet ds = ger.GetBOLDetail(BOL);
        dtBillLoad = ds.Tables[0];
        ViewState["BillData"] = dtBillLoad;
        BindBillData();
        plBillLoad.Update();
        HiddenPassedBOL.Value = BOL;
        DataSet dsGERList = ger.GetBOLDetailList("BOLNo='" + BOL + "'");
        string strHeaderValues = dsGERList.Tables[0].Rows[0]["VendNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["VendName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PFCLocCd"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PFCLocName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BOLNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PortofLading"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BOLDate"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["VesselName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BrokerInvTot"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["RcptTypeDesc"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["ProcDt"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BrokerInvBOLCount"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsEntryNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsPortofEntry"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsEntryDt"].ToString();
        BOLHeader.SetBOLHeaderValues = strHeaderValues;

    }
}


    #endregion

    #region Function used in multiple PO Line Selection

    protected void dgItemLookUp_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            TextBox txtQty = e.Item.Cells[4].Controls[1] as TextBox;
            txtQty.Attributes.Add("onblur", "javascript:this.value=addCommas(this.value);");
        }
    }

    public void BindLookup()
    {

        dgItemLookUp.DataSource = dtLookup;
        dgItemLookUp.DataBind();
    }

    #endregion

    #region Function used for Container Reconciliation

    public void BindContainer()
    {
        dsReconcile = ger.OpenReconcile(BOLHeader.refNo.ToString());
        if (dsReconcile.Tables[0] != null)
        {
            dtContainer = dsReconcile.Tables[0];

            // Add the total row at the end of Reconcile table and then bind the grid
            DataRow drTotalForBOL = dsReconcile.Tables[0].NewRow();
            drTotalForBOL["ContainerNo"] = "Total for BOL";
            drTotalForBOL["ContPOCost"] = dsReconcile.Tables[1].Rows[0]["ContPOCost"].ToString();
            drTotalForBOL["ContInvCost"] = dsReconcile.Tables[1].Rows[0]["ContInvCost"].ToString();
            drTotalForBOL["ContWeight"] = dsReconcile.Tables[1].Rows[0]["ContWeight"].ToString();
            dsReconcile.Tables[0].Rows.Add(drTotalForBOL);

        }
        dgContainerCost.DataSource = dtContainer;
        dgContainerCost.DataBind();
    }

    protected void btnAccept_Click(object sender, ImageClickEventArgs e)
    {
        lblSuccessMessage.Text = "";
        lblErrorMessage.Text = "";

        if (dtBillLoad.Rows.Count > 0)
        {

            GridVisible(dgContainerCost.ID);
            if (ViewState["Status"].ToString() == "false")
            {
                BindContainer();
                if (ViewState["ListStatus"] != null)
                {
                    if (ViewState["ListStatus"].ToString().ToLower().Trim() == "processed")
                    {
                        foreach (DataGridItem dgItem in dgContainerCost.Items)
                        {
                            TextBox txtPCost = dgItem.Cells[1].Controls[1] as TextBox;
                            txtPCost.ReadOnly = true;
                            TextBox txtICost = dgItem.Cells[2].Controls[1] as TextBox;
                            txtICost.ReadOnly = true;
                            TextBox txtWt = dgItem.Cells[3].Controls[1] as TextBox;
                            txtWt.ReadOnly = true;
                        }
                    }
                }
            }
            else
            {
                dgContainerCost.DataSource = dtContainer;
                dgContainerCost.DataBind();
                FamilyPanel.Update();
            }

            plBillLoad.Update();
        }
        else
        {
            lblErrorMessage.Text = "Enter PO lines";
        }


    }

    protected void btnRefresh_Click(object sender, ImageClickEventArgs e)
    {
        lblSuccessMessage.Text = "";
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "Refresh " + HiddenPassedBOL.Value;
        FamilyPanel.Update();

        ViewState["Header"] = "true";
        dtBillLoad.Clear();
        GridVisible(dgBillLoad.ID);
        string lclBol = BOLHeader.refNo.ToString();
        if (lclBol=="")
        {
            lclBol = HiddenPassedBOL.Value;
        }
        DataSet ds = ger.GetBOLDetail(lclBol);
        dtBillLoad = ds.Tables[0];
        ViewState["BillData"] = dtBillLoad;
        BindBillData();
        plBillLoad.Update();
        DataSet dsGERList = ger.GetBOLDetailList("BOLNo='" + lclBol + "'");
        string strHeaderValues = dsGERList.Tables[0].Rows[0]["VendNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["VendName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PFCLocCd"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PFCLocName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BOLNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PortofLading"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BOLDate"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["VesselName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BrokerInvTot"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["RcptTypeDesc"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["ProcDt"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BrokerInvBOLCount"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsEntryNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsPortofEntry"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsDate"].ToString();
        ScriptManager.RegisterClientScriptBlock(dgBillLoad, typeof(DataGrid), "BindHeader", "BindHeader('" + strHeaderValues + "')", true);


    }

    protected void imgContBack_Click(object sender, ImageClickEventArgs e)
    {
        BindBillData();
        GridVisible(dgBillLoad.ID);
        plBillLoad.Update();

    }

    protected void dgContainerCost_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {
            e.Item.Cells[1].ColumnSpan = 2;
            e.Item.Cells[1].Text = "<Table border=1px bordercolor='#DAEEEF' class=GridItem  Cellpadding=0 cellspacing=0 width=100% height='5px' >" +
                                    "<tr><td border=0px colspan=2 align=center valign=middle>Total Container Cost</td></tr>" +
                                    "<tr><td valign=middle align=center width='50%'>Purch.Order</td><td valign=middle align=center width='50%'>Invoice</td></tr></table>";

            e.Item.Cells[2].Visible = false;
        }

        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            TextBox txtPCost = e.Item.Cells[1].Controls[1] as TextBox;
            txtPCost.Attributes.Add("onblur", "javascript:roundNumber(this.value,2,this);this.value=addCommas(this.value);fillTotal(this.id);");

            TextBox txtInvCost = e.Item.Cells[2].Controls[1] as TextBox;
            txtInvCost.Attributes.Add("onblur", "javascript:roundNumber(this.value,2,this);this.value=addCommas(this.value);fillTotal(this.id);");

            TextBox txtTotalWt = e.Item.Cells[3].Controls[1] as TextBox;
            txtTotalWt.Attributes.Add("onblur", "javascript:roundNumber(this.value,2,this);this.value=addCommas(this.value);fillTotal(this.id);");


        }
    }

    /// <summary>
    /// Function to format decimal field in Container Grid
    /// </summary>
    /// <param name="container"></param>
    /// <param name="fieldName"></param>
    /// <param name="decimalPlaces"></param>
    /// <returns></returns>
    public string FormatToDecimal(object container, string fieldName, string decimalPlaces)
    {
        if (DataBinder.Eval(container, "DataItem." + fieldName).ToString() != "")
        {
            Decimal dcInvCost = Convert.ToDecimal(DataBinder.Eval(container, "DataItem." + fieldName).ToString());
            if (dcInvCost != 0)
                return dcInvCost.ToString("###,###,###,###,###.00");
        }
        return "0.00";
    }

    #endregion

    #region Function used for Accessorial Charges

    public void BindCharge()
    {
        DataSet dsCharge = ger.CHARGES(BOLHeader.refNo.ToString());
        if (dsCharge.Tables[0] != null)
            dtCharge = dsCharge.Tables[0];
        dgCharges.DataSource = dtCharge;
        dgCharges.DataBind();
    }

    protected void btnCharges_Click(object sender, ImageClickEventArgs e)
    {
        lblSuccessMessage.Text = "";

        if (dtBillLoad.Rows.Count > 0)
        {
            GridVisible(dgCharges.ID);
            if (ViewState["Status"].ToString() == "false")
            {
                BindCharge();
                foreach (DataGridItem dgItem in dgCharges.Items)
                {
                    Label lblCharge = dgItem.Cells[0].FindControl("lblType") as Label;
                    if (lblCharge.Text == "Duty")
                    {
                        TextBox txtLine = dgItem.Cells[1].Controls[1] as TextBox;
                        txtLine.ReadOnly = true;
                        TextBox txtRemarks = dgItem.Cells[2].Controls[1] as TextBox;
                        txtRemarks.Text = "No Changes Allowed";
                        txtRemarks.ReadOnly = true;
                    }
                }
                if (ViewState["ListStatus"] != null)
                {
                    if (ViewState["ListStatus"].ToString() == "Processed")
                    {
                        foreach (DataGridItem dgItem in dgCharges.Items)
                        {
                            TextBox txtLine = dgItem.Cells[1].Controls[1] as TextBox;
                            txtLine.ReadOnly = true;
                            TextBox txtRemarks = dgItem.Cells[2].Controls[1] as TextBox;
                            txtRemarks.ReadOnly = true;

                        }
                    }
                }
            }
            else
            {
                dgCharges.DataSource = dtCharge;
                dgCharges.DataBind();
                FamilyPanel.Update();
            }
            plBillLoad.Update();
        }
        else
        {
            lblErrorMessage.Text = "Enter PO lines";
        }

    }

    protected void dgCharges_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            TextBox txtQty = e.Item.Cells[1].Controls[1] as TextBox;
            txtQty.Attributes.Add("onblur", "javascript:roundNumber(this.value,2,this);this.value=addCommas(this.value);UpdateChargesLineAmount(this.id,this.value);");
        }
    }

    protected void imgChrgBack_Click(object sender, ImageClickEventArgs e)
    {
        BindBillData();
        GridVisible(dgBillLoad.ID);
        plBillLoad.Update();
    }

    #endregion

    #region Function used to update the BOL Header

    public void UpdHeader()
    {
        try
        {
            string whereCondition = "BOLNo='" + BOLHeader.refNo.ToString() + "'";
            string[] strHeader = BOLHeader.headerValues.Split('~');
            string columnValues = "VesselName='" + strHeader[5] + "'";
            columnValues += ", BOLDate='" + strHeader[1] + "'";
            columnValues += ", VendNo='" + strHeader[2] + "'";
            columnValues += ", VendName='" + strHeader[3] + "'";
            columnValues += ", RcptTypeDesc='" + strHeader[4] + "'";
            columnValues += ", PFCLocCd='" + strHeader[6] + "'";
            columnValues += ", PFCLocName='" + strHeader[7] + "'";
            columnValues += ", PortofLading='" + strHeader[8] + "'";
            columnValues += ", BrokerInvTot=" + strHeader[9] + " ";
            columnValues += ", BrokerInvBOLCount='" + strHeader[10] + "'";
            columnValues += ", CustomsEntryNo='" + strHeader[11] + "'";
            columnValues += ", CustomsPortofEntry='" + strHeader[12] + "'";
            columnValues += ", CustomsEntryDt='" + strHeader[13] + "'";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                      new SqlParameter("@tableName", "GERHeader"),
                      new SqlParameter("@columnNames", columnValues),
                      new SqlParameter("@whereClause", whereCondition));

            lblSuccessMessage.Text = "Header Updated";
            //return null;
        }
        catch (Exception ex)
        {
            //return null;
        }
        //ScriptManager.RegisterClientScriptBlock(dgList, typeof(DataGrid), "Bind", "Changeheight('" + dtList.Rows.Count + "')", true);
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        UpdHeader();

    }

    #endregion
    
    #region Function used to recall the BOL Details

    public void BindList()
    {
        DataSet dsGERList = ger.GetBOLDetailList("1=1 order by ProcDt,BOLNo");
        if (dsGERList.Tables[0] != null)
            dtList = dsGERList.Tables[0];
        dgList.DataSource = dtList;
        dgList.DataBind();
        lblSuccessMessage.Text = "";
        GridVisible(dgList.ID);
        plBillLoad.Update();
        //ScriptManager.RegisterClientScriptBlock(dgList, typeof(DataGrid), "Bind", "Changeheight('" + dtList.Rows.Count + "')", true);
    }

    protected void btnList_Click(object sender, EventArgs e)
    {
        BindList();

    }

    protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            LinkButton lnkStatus = e.Item.Cells[2].Controls[1] as LinkButton;
            Label lblProcDt = e.Item.Cells[1].Controls[1] as Label;

            if (lblProcDt.Text == "")
            {
                lblProcDt.Text = "NA";
                lnkStatus.Text = "Pending";
                lnkStatus.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lnkStatus.Text = "Processed";
                lnkStatus.ForeColor = System.Drawing.Color.Green;
            }
        }
    }

    protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "List")
            {
                ViewState["Status"] = "false";
                ViewState["Header"] = "true";
                LinkButton lnkStatus = e.Item.Cells[2].Controls[1] as LinkButton;
                Label lblNo = e.Item.Cells[0].Controls[1] as Label;
                HiddenField hidID = e.Item.Cells[0].Controls[3] as HiddenField;
                DataSet dsGERList = ger.GetBOLDetailList("BOLNo='" + lblNo.Text.ToString() + "' and pGERHdrID='" + hidID.Value.ToString() + "'");
                string strHeaderValues = dsGERList.Tables[0].Rows[0]["VendNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["VendName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PFCLocCd"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PFCLocName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BOLNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["PortofLading"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BOLDate"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["VesselName"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BrokerInvTot"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["RcptTypeDesc"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["ProcDt"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["BrokerInvBOLCount"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsEntryNo"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsPortofEntry"].ToString() + "~" + dsGERList.Tables[0].Rows[0]["CustomsEntryDt"].ToString();
                ScriptManager.RegisterClientScriptBlock(dgList, typeof(DataGrid), "BindHeader", "BindHeader('" + strHeaderValues + "')", true);
                
                if (lnkStatus.Text.Trim().ToLower() == "pending")
                {

                    ViewState["ListStatus"] = "Pending";
                    hidList.Value = "Pending";
                    dtBillLoad.Clear();
                    GridVisible(dgBillLoad.ID);
                    DataSet ds = ger.GetBOLDetail(lblNo.Text.ToString());
                    dtBillLoad = ds.Tables[0];
                    ViewState["BillData"] = dtBillLoad;
                    BindBillData();
                    //BOLHeader.tdUpdateButton.Visible = true;
                    btnRefresh.Visible = true;
                    btnAccept.Visible = true;
                    btnCharges.Visible = true;
                    btnProcess.Visible = true;
                    txtInvNo.ReadOnly = false;
                    txtDate.ReadOnly = false;
                    txtContainer.ReadOnly = false;
                    txtPO.ReadOnly = false;
                    txtItem.ReadOnly = false;
                    txtInvQty.ReadOnly = false;
                    txtInvCost.ReadOnly = false;
                }
                else
                {

                    ViewState["ListStatus"] = "Processed";
                    hidList.Value = "Processed";
                    dtBillLoad.Clear();
                    GridVisible(dgBillLoad.ID);
                    DataSet ds = ger.GetBOLDetail(lblNo.Text.ToString());
                    dtBillLoad = ds.Tables[0];
                    ViewState["BillData"] = dtBillLoad;
                    BindBillData();
                    foreach (DataGridItem dgItem in dgBillLoad.Items)
                    {
                        TextBox txtIQty = dgItem.Cells[6].Controls[1] as TextBox;
                        txtIQty.ReadOnly = true;
                        TextBox txtICost = dgItem.Cells[8].Controls[1] as TextBox;
                        txtICost.ReadOnly = true;
                    }
                    //imgUpdate.Visible = false;
                    btnRefresh.Visible = false;
                    btnAccept.Visible = false;
                    btnCharges.Visible = false;
                    btnProcess.Visible = false;
                    txtInvNo.ReadOnly = true;
                    txtDate.ReadOnly = true;
                    txtContainer.ReadOnly = true;
                    txtPO.ReadOnly = true;
                    txtItem.ReadOnly = true;
                    txtInvQty.ReadOnly = true;
                    txtInvCost.ReadOnly = true;
                }               
                plBillLoad.Update();
                ClearCommandLine();
               
            }
        }
        catch (Exception ex) { }
    }

    protected void imgLstBack_Click(object sender, ImageClickEventArgs e)
    {
        lblErrorMessage.Text = "";
        GridVisible(dgBillLoad.ID);
        plBillLoad.Update();
    }

    #endregion

    #region Function used for Processing

    protected void btnProcess_Click(object sender, ImageClickEventArgs e)
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        if (dtBillLoad.Rows.Count == 0)
        {
            lblErrorMessage.Text = "Enter PO lines";
        }
        else
        {
            ViewState["Header"] = "false";
            ViewState["Status"] = "true";
            int ProcessInd = 0;
            if (chkProcessNow.Checked) ProcessInd = 1;
            lblErrorMessage.Text = ger.PROCESS(BOLHeader.refNo.ToString(), ProcessInd);
            GridVisible(dgBillLoad.ID);
            txtContainer.Text = "";
            txtDate.Text = "";
            txtInvNo.Text = "";
            txtPO.Text = "";
            txtItem.Text = "";
            lblDesc.Text = "";
            lblLine.Text = "";
            lblQty.Text = "";
            txtInvQty.Text = "";
            lblPOCost.Text = "";
            lblUOM.Text = "";
            txtInvCost.Text = "";
            //
            // Clear view state value
            //
            if (lblErrorMessage.Text == "")
            {
                dtBillLoad.Clear();
                ViewState["BillData"] = dtBillLoad;
                lblSuccessMessage.Text = "Process successfully completed";
                chkProcessNow.Checked = false;
                BindBillData();
                plBillLoad.Update();
                ScriptManager.RegisterClientScriptBlock(dgBillLoad, typeof(DataGrid), "BindValue", "BindValue('" + DateTime.Now.ToShortDateString() + "')", true);
            }
        }
    }

    #endregion

    #region BOL Details Methods

    public void AddColumns()
    {
        dtBillLoad.Columns.Add("VendInvNo");
        dtBillLoad.Columns.Add("VendInvDt");
        dtBillLoad.Columns.Add("ContainerNo");
        dtBillLoad.Columns.Add("PFCPONo");
        dtBillLoad.Columns.Add("PFCItemNo");
        dtBillLoad.Columns.Add("POQty");
        dtBillLoad.Columns.Add("RcptQty");
        dtBillLoad.Columns.Add("POCostPerAlt");
        dtBillLoad.Columns.Add("UOPOPerAlt");
        dtBillLoad.Columns.Add("ExtLandAdder");
        dtBillLoad.Columns.Add("LandVsPOPct");
        dtBillLoad.Columns.Add("PFCPOLineNo");
    }

    public string GetText(object container)
    {
        string strCmd = string.Empty;
        strCmd = DataBinder.Eval(container, "DataItem.VendInvNo").ToString() + "," + DataBinder.Eval(container, "DataItem.VendInvDt").ToString() + "," + DataBinder.Eval(container, "DataItem.ContainerNo").ToString() + "," + DataBinder.Eval(container, "DataItem.PFCPONo").ToString();
        return strCmd;
    }

    protected void btnInvNo_Click(object sender, EventArgs e)
    {
        lblSuccessMessage.Text = "";
        string[] strHeader = BOLHeader.headerValues.Split('~');
        if ((ViewState["Header"].ToString().ToLower() == "false") && (lblErrorMessage.Text == ""))
        {
            DataSet dsHeader = ger.GERWriteHdr(strHeader[0], strHeader[1], strHeader[2], strHeader[3], hidPayTo.Value, strHeader[4], strHeader[5], strHeader[6], strHeader[7], strHeader[8], strHeader[9], strHeader[10], strHeader[11], strHeader[12], strHeader[13], strHeader[14]);
            ViewState["Header"] = "true";           
        }

        txtDate.Focus();

    }

    protected void btnInvCost_Click(object sender, EventArgs e)
    {
        //lblErrorMessage.Text = "";
        if (txtInvQty.Text.Trim() == "" || txtItem.Text == "")
        {
            lblErrorMessage.Text = "Command line incomplete";
        }
        else if (dgBillLoad.Visible == false)
        {
            lblErrorMessage.Text = "Invalid operation";
        }
        else
        {
            ViewState["Status"] = "false";
            //DataSet dsDetailCheck = ger.CheckBOLDetail(BOLHeader.refNo.ToString(), txtInvNo.Text, txtDate.Text, txtContainer.Text, txtPO.Text, txtItem.Text, lblLine.Text);
            //if (dsDetailCheck.Tables[0].Rows.Count > 0)
            //    lblErrorMessage.Text = "Product Line already exists";
            //else
            //{
                lblErrorMessage.Text = ger.CheckInvoiceNo(hidPayTo.Value, txtInvNo.Text);
                if (lblErrorMessage.Text == "")
                {
                    lblErrorMessage.Text = ger.CheckBOLExists(BOLHeader.refNo.ToString());
                    if (lblErrorMessage.Text == "")
                    {
                        DataSet ds = ger.ksENTER(BOLHeader.refNo.ToString(), txtInvNo.Text, txtDate.Text, txtContainer.Text, txtPO.Text, txtItem.Text, lblLine.Text, lblQty.Text.Replace(",", ""), txtInvQty.Text.Replace(",", ""), lblPOCost.Text.Replace(",", ""), lblUOM.Text, txtInvCost.Text.Replace(",", ""), Session["userid"].ToString(), lblDesc.Text, hidPFCLocNo.Value.ToString(), hidBaseUOM.Value.ToString(), hidPCSPerAlt.Value.Replace(",", ""), hidItemNetWght.Value.Replace(",", ""));
                        dtBillLoad = ds.Tables[0];
                    }
                }
            //}
            string[] strHeader = BOLHeader.headerValues.Split('~');
            if ((ViewState["Header"].ToString().ToLower() == "false") && (lblErrorMessage.Text == ""))
            {
                DataSet dsHeader = ger.GERWriteHdr(strHeader[0], strHeader[1], strHeader[2], strHeader[3], hidPayTo.Value, strHeader[4], strHeader[5], strHeader[6], strHeader[7], strHeader[8], strHeader[9], strHeader[10], strHeader[11], strHeader[12], strHeader[13], strHeader[14]);
                ViewState["Header"] = "true";
            }
            ViewState["BillData"] = dtBillLoad;
            BindBillData();
            txtItem.Text = "";
            lblDesc.Text = "";
            lblLine.Text = "";
            lblQty.Text = "";
            txtInvQty.Text = "";
            lblPOCost.Text = "";
            lblUOM.Text = "";
            txtInvCost.Text = "";
            plBillLoad.Update();
            txtItem.Focus();
        }
    }

    protected void btnItem_Click(object sender, EventArgs e)
    {
        lblSuccessMessage.Text = "";
        lblErrorMessage.Text = "";

        if (txtInvNo.Text.Trim() == "" || txtDate.Text.Trim() == "" || txtContainer.Text.Trim() == "" || txtPO.Text.Trim() == "")
        {
            lblErrorMessage.Text = "Command line incomplete";
            GridVisible(dgBillLoad.ID);
            plBillLoad.Update();
        }
        else if (!validatePFCItemNumber())
        {
            lblErrorMessage.Text = "Invalid PFC Item #";
            txtItem.Focus();
        }
        else
        {
            DataSet dsItem = ger.GetPOLine(txtPO.Text, txtItem.Text);
            if (dsItem.Tables[0].Rows.Count != 0)
            {
                if (dsItem.Tables[0].Rows.Count > 1)
                {
                    ViewState["Status"] = "false";
                    lblDesc.Text = dsItem.Tables[0].Rows[0]["Description"].ToString();
                    hidPFCLocNo.Value = dsItem.Tables[0].Rows[0]["Location Code"].ToString();
                    hidBaseUOM.Value = dsItem.Tables[0].Rows[0]["Unit of Measure Code"].ToString();
                    hidPCSPerAlt.Value = dsItem.Tables[0].Rows[0]["Alt_ Quantity"].ToString();
                    hidPayTo.Value = dsItem.Tables[0].Rows[0]["Pay-to Vendor No_"].ToString();
                    hidItemNetWght.Value = string.Format("{0:#,##0.00}", Convert.ToDecimal(dsItem.Tables[0].Rows[0]["Net Weight"].ToString()));
                    lblLine.Text = "";
                    lblQty.Text = "";
                    txtInvQty.Text = "";
                    lblPOCost.Text = "";
                    lblUOM.Text = "";
                    txtInvCost.Text = "";
                    GridVisible(dgItemLookUp.ID);
                    dtLookup = dsItem.Tables[0];
                    BindLookup();
                    plBillLoad.Update();
                }
                else
                {
                    lblDesc.Text = dsItem.Tables[0].Rows[0]["Description"].ToString();
                    lblLine.Text = dsItem.Tables[0].Rows[0]["Line No_"].ToString();
                    lblQty.Text = String.Format("{0:#,###}", Convert.ToDecimal(dsItem.Tables[0].Rows[0]["Outstanding Quantity"].ToString()));
                    txtInvQty.Text = String.Format("{0:#,###}", Convert.ToDecimal(dsItem.Tables[0].Rows[0]["Outstanding Quantity"].ToString()));
                    lblPOCost.Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dsItem.Tables[0].Rows[0]["Alt_ Price"].ToString()));
                    lblUOM.Text = dsItem.Tables[0].Rows[0]["Alt_ Price UOM"].ToString();
                    txtInvCost.Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dsItem.Tables[0].Rows[0]["Alt_ Price"].ToString()));
                    hidPFCLocNo.Value = dsItem.Tables[0].Rows[0]["Location Code"].ToString();
                    hidBaseUOM.Value = dsItem.Tables[0].Rows[0]["Unit of Measure Code"].ToString();
                    hidPCSPerAlt.Value = dsItem.Tables[0].Rows[0]["Alt_ Quantity"].ToString();
                    hidPayTo.Value = dsItem.Tables[0].Rows[0]["Pay-to Vendor No_"].ToString();
                    hidItemNetWght.Value = string.Format("{0:#,##0.00}", Convert.ToDecimal(dsItem.Tables[0].Rows[0]["Net Weight"].ToString()));
                    txtInvQty.Focus();
                    GridVisible(dgBillLoad.ID);
                    plBillLoad.Update();

                }
            }
            else
            {
                txtItem.Text = "";
                lblDesc.Text = "";
                lblLine.Text = "";
                lblQty.Text = "";
                txtInvQty.Text = "";
                lblPOCost.Text = "";
                lblUOM.Text = "";
                txtInvCost.Text = "";
                txtItem.Focus();
                lblErrorMessage.Text = ger.POLineStat;
            }
        }

    }

    protected void rdoSelect_CheckedChanged(object sender, EventArgs e)
    {

        foreach (DataGridItem dgItem in dgItemLookUp.Items)
        {
            RadioButton rdoSelect = dgItem.Cells[0].FindControl("rdoSelect") as RadioButton;
            if (rdoSelect.Checked)
            {

                TextBox txtPO = dgItem.Cells[1].FindControl("txtPO") as TextBox;
                TextBox txtLineNo = dgItem.Cells[2].FindControl("txtLineNo") as TextBox;
                TextBox txtItemNo = dgItem.Cells[3].FindControl("txtItemNo") as TextBox;
                DataSet ds = ger.MarkPOLine(txtPO.Text, txtLineNo.Text, txtItemNo.Text);
                if (ds.Tables[0].Rows.Count != 0)
                {
                    txtItem.Text = ds.Tables[0].Rows[0]["No_"].ToString();
                    lblLine.Text = ds.Tables[0].Rows[0]["Line No_"].ToString();
                    lblQty.Text = string.Format("{0:#,###}", Convert.ToDecimal(ds.Tables[0].Rows[0]["Outstanding Quantity"].ToString()));
                    txtInvQty.Text = string.Format("{0:#,###}", Convert.ToDecimal(ds.Tables[0].Rows[0]["Outstanding Quantity"].ToString()));
                    lblPOCost.Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(ds.Tables[0].Rows[0]["Alt_ Price"].ToString()));
                    lblUOM.Text = ds.Tables[0].Rows[0]["Alt_ Price UOM"].ToString();
                    txtInvCost.Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(ds.Tables[0].Rows[0]["Alt_ Price"].ToString()));
                    txtInvQty.Focus();
                    break;
                }
            }

        }

        GridVisible(dgBillLoad.ID);
        BindBillData();
        txtInvQty.Focus();
        FamilyPanel.Update();
        plBillLoad.Update();
    }

    protected void dgBillLoad_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        dtBillLoad.DefaultView.Sort = hidSort.Value;
        DataView dv = new DataView(dtBillLoad);
        dv.Sort = hidSort.Value;
        BindBillData();
        dgItemLookUp.Visible = false;
        plBillLoad.Update();
    }

    protected void dgBillLoad_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            TextBox txtQty = e.Item.Cells[6].Controls[1] as TextBox;
            txtQty.Attributes.Add("onblur", "javascript:this.value=addCommas(this.value);updateInvoiceQty(this.id,this.value);");

            TextBox txtInvCost = e.Item.Cells[8].Controls[1] as TextBox;
            txtInvCost.Attributes.Add("onblur", "javascript:roundNumber(this.value,2,this);this.value=addCommas(this.value);updateInvoiceCost(this.id,this.value);");

            try
            {
                Decimal dcInvCost = Convert.ToDecimal(txtInvCost.Text);
                txtInvCost.Text = dcInvCost.ToString("###,###,###,###,###.00");

                dcInvCost = Convert.ToDecimal(txtQty.Text);
                txtQty.Text = dcInvCost.ToString("###,###,###,###,###");
            }
            catch (Exception ex)
            {

            }
        }
    }

    protected void dgBillLoad_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        try
        {
            Label lblInv = e.Item.Cells[0].Controls[5] as Label;
            Label lblVendInvDt = e.Item.Cells[1].Controls[1] as Label;
            Label lblContainerNo = e.Item.Cells[2].Controls[1] as Label;
            Label lblPFCPONo = e.Item.Cells[3].Controls[1] as Label;
            Label lblPFCItemNo = e.Item.Cells[4].Controls[1] as Label;
            HiddenField hidPFCPOLineNo = e.Item.Cells[4].Controls[3] as HiddenField;

            if (e.CommandName == "Delete")
            {
                try
                {

                    string whereCondition = "VendInvNo='" + lblInv.Text.ToString() + "' and VendInvDt='" + lblVendInvDt.Text.ToString() + "' and ContainerNo='" + lblContainerNo.Text.ToString() + "' and PFCPONo='" + lblPFCPONo.Text.ToString() + "' and PFCItemNo='" + lblPFCItemNo.Text.ToString() + "' and PFCPOLineNo='" + hidPFCPOLineNo.Value.ToString() + "'";
                    SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_delete]",
                              new SqlParameter("@tableName", "GERDetail"),
                              new SqlParameter("@whereClause", whereCondition));

                }
                catch (Exception ex)
                { }
                dtBillLoad.Rows.RemoveAt(e.Item.ItemIndex);
                BindBillData();
                plBillLoad.Update();
            }
        }
        catch (Exception ex) { }
    }

    public void BindBillData()
    {
        dgBillLoad.DataSource = dtBillLoad.DefaultView;
        dgBillLoad.DataBind();
    }
    
    #region Ajax Function To update the BOL's Detail

    [Ajax.AjaxMethod()]
    public string UpdateInvoiceCost(string VendInvNo, string VendInvDt, string ContainerNo, string PFCPONo, string PFCItemNo, string poQty, string invCost, string strBOL)
    {
        try
        {
            string columnValues = "UOPOPerAlt='" + invCost.Replace(",", "") + "'";
            string whereCondition = "VendInvNo='" + VendInvNo + "' and VendInvDt='" + VendInvDt + "' and ContainerNo='" + ContainerNo + "' and PFCPONo='" + PFCPONo + "' and PFCItemNo='" + PFCItemNo + "' and BOLNo='" + strBOL + "'";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                      new SqlParameter("@tableName", "GERDetail"),
                      new SqlParameter("@columnNames", columnValues),
                      new SqlParameter("@whereClause", whereCondition));
            
            return GetExtendedAmount(whereCondition);
        }
        catch (Exception ex)
        {
            return null;
        }

    }
    [Ajax.AjaxMethod()]
    public string UpdateInvoiceQuantity(string VendInvNo, string VendInvDt, string ContainerNo, string PFCPONo, string PFCItemNo, string poQty, string invQty, string strBOL)
    {
        try
        {
            string columnValues = "RcptQty='" + invQty.Replace(",", "") + "'";
            string whereCondition = "VendInvNo='" + VendInvNo + "' and VendInvDt='" + VendInvDt + "' and ContainerNo='" + ContainerNo + "' and PFCPONo='" + PFCPONo + "' and PFCItemNo='" + PFCItemNo + "' and BOLNo='" + strBOL + "'";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                      new SqlParameter("@tableName", "GERDetail"),
                      new SqlParameter("@columnNames", columnValues),
                      new SqlParameter("@whereClause", whereCondition));

            return GetExtendedAmount(whereCondition);

        }
        catch (Exception ex)
        {
            return null;
        }

    }
    [Ajax.AjaxMethod()]
    public void UpdateInvoiceQuantity2(string VendInvNo, string VendInvDt, string ContainerNo, string PFCPONo, string PFCItemNo, string poQty, string invQty, string strBOL)
    {
        //ScriptManager.RegisterClientScriptBlock(dgBillLoad, typeof(DataGrid), "BindValue", "BindValue('" + DateTime.Now.ToShortDateString() + "')", true);
        //dtBillLoad.Clear();
        //ViewState["BillData"] = dtBillLoad;
        //BindBillData();
        //plBillLoad.Update();
        try
        {
            string columnValues = "RcptQty='" + invQty.Replace(",", "") + "'";
            string whereCondition = "VendInvNo='" + VendInvNo + "' and VendInvDt='" + VendInvDt + "' and ContainerNo='" + ContainerNo + "' and PFCPONo='" + PFCPONo + "' and PFCItemNo='" + PFCItemNo + "' and BOLNo='" + strBOL + "'";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                      new SqlParameter("@tableName", "GERDetail"),
                      new SqlParameter("@columnNames", columnValues),
                      new SqlParameter("@whereClause", whereCondition));

        }
        catch (Exception ex)
        { };
        //DataSet ds = ger.GetBOLDetail(strBOL);
        //dtBillLoad = ds.Tables[0];
    }
    [Ajax.AjaxMethod()]
    public void UpdateCharges(string columnValues, string whereCondition)
    {
        try
        {
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                      new SqlParameter("@tableName", "GERChrgDetail"),
                      new SqlParameter("@columnNames", columnValues),
                      new SqlParameter("@whereClause", whereCondition));

        }
        catch (Exception ex)
        { }

    }
    /// <summary>
    /// Function to return extended amount for Ajax method
    /// </summary>
    /// <param name="whereClause"></param>
    /// <returns></returns>
    private string GetExtendedAmount(string whereClause)
    {
        object objExtendedAmount = SqlHelper.ExecuteScalar(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
            new SqlParameter("@tableName", "GERDetail"),
            new SqlParameter("@columnNames", "UOMatlAmt"),
            new SqlParameter("@whereClause", whereClause));

        decimal extendedAmount = Math.Round(Convert.ToDecimal(objExtendedAmount), 2);
        return extendedAmount.ToString();
    }
    #endregion

    #endregion

    #region Utility

    public void GridVisible(string gridID)
    {
        dgBillLoad.Visible = ((gridID == dgBillLoad.ID) ? true : false);
        dgItemLookUp.Visible = ((gridID == dgItemLookUp.ID) ? true : false);
        dgCharges.Visible = ((gridID == dgCharges.ID) ? true : false);
        dgContainerCost.Visible = ((gridID == dgContainerCost.ID) ? true : false);
        dgList.Visible = ((gridID == dgList.ID) ? true : false);
    }

    public void ClearCommandLine()
    {
        txtInvNo.Text = "";
        txtDate.Text = "";
        txtContainer.Text = "";
        txtPO.Text = "";
        txtItem.Text = "";
        lblDesc.Text = "";
        lblLine.Text = "";
        lblQty.Text = "";
        txtInvQty.Text = "";
        lblPOCost.Text = "";
        lblUOM.Text = "";
        txtInvCost.Text = "";
        FamilyPanel.Update();
        txtInvQty.Focus();
    }

    private bool validatePFCItemNumber()
    {
        string result = utility.ValidatePFCItemNo(txtItem.Text.Trim());
        if (result == "true")
            return true;
        txtItem.Text = "";
        lblDesc.Text = "";
        lblLine.Text = "";
        lblQty.Text = "";
        txtInvQty.Text = "";
        lblPOCost.Text = "";
        lblUOM.Text = "";
        txtInvCost.Text = "";
        return false;

    }

    #endregion

}
