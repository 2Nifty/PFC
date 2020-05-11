/********************************************************************************************
 * File	Name			:	ItemLookup.aspx.cs
 * File Type			:	C#
 * Project Name			:	SOE 
 * Module Description	:	Show Item and its details
 * Created By			:	Mahesh Kumar.S
 * Created Date			:	20/10/2007	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 20/10/2007           Mahesh Kumar.S                  Created

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
using PFC.SOE;
using PFC.SOE.BusinessLogicLayer;

public partial class ItemLookup : System.Web.UI.Page
{
    ItemBuilder itemBuilder = new ItemBuilder();
    DataTable dtProduct = new DataTable();
    DataTable dtItem = new DataTable();
    string crossReference = "";
    string sRbText="";
    protected void Page_Load(object sender, EventArgs e)
    {
        // Registering AJAX
        Ajax.Utility.RegisterTypeForAjax(typeof(ItemLookup));
        Session["dtProductNew"] = null;
        if (!Page.IsPostBack)
        {
            if (Session["ItemFamily"] != null && Request.QueryString["ItemProductLine"] != null && Request.QueryString["ItemCategory"] != null && Request.QueryString["ItemDiameter"] != null && Request.QueryString["ItemLength"] != null && Request.QueryString["ItemPlating"] != null && Request.QueryString["ItemPackage"] != null)
            {
                itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
                itemBuilder.ItemProductLine = Request.QueryString["ItemProductLine"].ToString();
                itemBuilder.ItemCategory = (Request.QueryString["ItemCategory"].ToString() == "All") ? "" : Request.QueryString["ItemCategory"].ToString();
                itemBuilder.ItemPlating = (Request.QueryString["ItemPlating"].ToString() == "All") ? "" : Request.QueryString["ItemPlating"].ToString();
                itemBuilder.ItemPackage = (Request.QueryString["ItemPackage"].ToString() == "All") ? "" : Request.QueryString["ItemPackage"].ToString();
                
                if (Session["ItemDiameter"] != null)
                    itemBuilder.ItemDiameter = (Session["ItemDiameter"].ToString() == "") ? "" : Session["ItemDiameter"].ToString();
                else
                    itemBuilder.ItemDiameter = "";
                
                if (Session["ItemLength"] != null)
                    itemBuilder.ItemLength = (Session["ItemLength"].ToString() == "") ? "" : Session["ItemLength"].ToString();
                else
                    itemBuilder.ItemLength = "";

                dtItem = itemBuilder.GetItemNumber();
                dtItem.Columns.Add("Select");

                foreach (DataRow dr in dtItem.Rows)
                    dr["Select"] = "False";
                
                if (dtItem != null && dtItem.Rows.Count != 0)
                {
                    if (dtItem.DefaultView.ToTable() != null && dtItem.DefaultView.ToTable().Rows.Count > 0)
                    {
                        Session["ItemDetail"] = dtItem.DefaultView.ToTable();
                        BindDataGrid();
                    }
                }
                else
                {
                    lblStatusFlag.Text = "No Records Found";
                    lblStatusFlag.Visible = true;
                    gridPager.Visible = false;
                }
            }
        }
    }
    #region Datagrid Bind method
    private void BindDataGrid()
    {
        try
        {

            dtItem = (DataTable)Session["ItemDetail"];

            //DataTable test = itemBuilder.GetCrossReferenceNumbers("201190", dtItem);

            if (dtItem != null && dtItem.Rows.Count != 0)
            {
                
                dtItem.DefaultView.Sort = hidSort.Value;
                dgItemLookup.DataSource = dtItem.DefaultView.ToTable();
                gridPager.InitPager(dgItemLookup, 20);
                gridPager.Visible = true;
            }
            else
            {
                lblStatusFlag.Visible = true;
                gridPager.Visible = false;
            }
        }
        catch (Exception ex)
        {
        }

    }
    #endregion

    /// <summary>
    /// event for page index change in pager
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        try
        {
            dgItemLookup.CurrentPageIndex = gridPager.GotoPageNumber;
            BindDataGrid();
        }
        catch (Exception ex)
        {

        }
    }

    protected void dgItemLookup_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            LinkButton lnkItem = e.Item.FindControl("lnkItem") as LinkButton;
            if(Request.QueryString["Page"] !=null)
                lnkItem.Attributes.Add("onclick", "javascript:WSSelectItem(this.id);");
            else
                lnkItem.Attributes.Add("onclick", "javascript:SelectItem(this.id);");
        }
    }

    #region Datagrid Sort Event handler
    protected void dgItemLookup_SortCommand(object source, DataGridSortCommandEventArgs e)
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
    #endregion

    #region AJAX Function to inser multiple quote in the table
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void SaveQuotation(string strItem, string soeID)
    {
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void GetItemDetail(bool chkState, string strItem)
    {
        DataTable dtItemDet = (DataTable)HttpContext.Current.Session["ItemDetail"];
        for (int i = 0; i < dtItemDet.Rows.Count; i++)
        {
            if (dtItemDet.Rows[i]["ItemNo"].ToString().Trim() == strItem.Trim())
            {
                dtItemDet.Rows[i]["Select"] =((chkState)? "True":"False");
                break;
            }
        }

        HttpContext.Current.Session["ItemDetail"] = dtItemDet;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetItemNo()
    {
        string strItemNo = "";
        DataTable dtItemDet = (DataTable)HttpContext.Current.Session["ItemDetail"];
        for (int i = 0; i < dtItemDet.Rows.Count; i++)
        {
            if (dtItemDet.Rows[i]["Select"].ToString().Trim() == "True")
                strItemNo += dtItemDet.Rows[i]["ItemNo"].ToString().Trim() + ",";
        }
        strItemNo = (strItemNo.IndexOf(',') != -1) ? strItemNo.Substring(0, strItemNo.Length - 1) : strItemNo;
        return strItemNo;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string BindDescription(string strItemValue)
    {
        //OrderEntry pfcQMSService = new OrderEntry();
        //DataSet dtDetail = pfcQMSService.GetProductInfo(strItemValue.Trim().ToUpper(), HttpContext.Current.Session["CustNo"].ToString(),PFC.SOE.BusinessLogicLayer.OrderEntry.ItemNumberType.CustomerItemNumber);
        //if (dtDetail != null && dtDetail.Tables.Count > 0)
        //{
        //    if (dtDetail.Tables[0].Rows.Count > 0)
        //        return dtDetail.Tables[0].Rows[0]["Description"].ToString();
        //}
       return "";
    }

    private void AddNewDataGridRow(DataSet dtProductNow, string strItemNo, string quote)
    {
        try
        {
           
            string strAltQtyUom = "";

            if (dtProductNow.Tables[0].Rows[0]["Super Equiv_ UOM"].ToString().Trim() != "")
                strAltQtyUom = Convert.ToInt32(dtProductNow.Tables[0].Rows[0]["Super Equiv_ Qty_"]).ToString() + " " + dtProductNow.Tables[0].Rows[0]["Base Unit of Measure"].ToString() + "/ " + dtProductNow.Tables[0].Rows[0]["Super Equiv_ UOM"].ToString();
            else
                strAltQtyUom = "";

            DataRow drProduct = dtProduct.NewRow();
            #region co
            //drProduct["CusItemNo"] = strItemNo;
            //drProduct["RequestQty"] = "0";
            //drProduct["BaseUOMQty"] = Convert.ToInt32(dtProductNow.Tables[0].Rows[0]["Qty__Base UOM"]).ToString() + "/ " + dtProductNow.Tables[0].Rows[0]["Base Unit of Measure"].ToString();
            //drProduct["Available"] = "0";
            //drProduct["AltUnitPrice"] = "$ " + dtProductNow.Tables[0].Rows[0]["Alt Unit Price"].ToString();
            //drProduct["AltPriceUOM"] = dtProductNow.Tables[0].Rows[0]["Alt Price UOM"].ToString();
            //drProduct["ItemValue"] = "$0";
            //drProduct["AlternateQtyUOM"] = strAltQtyUom;
            //drProduct["ExtentedWeight"] = "0.00";
            //drProduct["UnitPrice"] = "$ " + dtProductNow.Tables[0].Rows[0]["ItemPrice"].ToString();
            //drProduct["SNo"] = quote;
            //drProduct["ItemDesc"] = dtProductNow.Tables[0].Rows[0]["Description"].ToString();
            //drProduct["CGrossWeight"] = dtProductNow.Tables[0].Rows[0]["Gross Weight"];
            //drProduct["AvaiQty"] = dtProductNow.Tables[0].Rows[0]["AvailableQuantity"];
            //drProduct["hidUnitPrice"] = dtProductNow.Tables[0].Rows[0]["ItemPrice"].ToString();
            //drProduct["hidItemValue"] = "0";
            //drProduct["QuoteRemark"] = "";
            //drProduct["LocCode"] = dtProductNow.Tables[0].Rows[0]["LocationCode"].ToString();
            //drProduct["LocName"] = dtProductNow.Tables[0].Rows[0]["LocationName"].ToString();
            //drProduct["hidAltUnitPrice"] = dtProductNow.Tables[0].Rows[0]["Alt Unit Price"].ToString();
            //drProduct["PFCItemNo"] = dtProductNow.Tables[0].Rows[0]["No_"].ToString();
            //drProduct["DeletedDate"] = ""; 
            #endregion


            drProduct["CustItemNo"] = crossReference;
            drProduct["QtyOrdered"] = "0";
            drProduct["SellStkQty"] = Convert.ToInt32(dtProductNow.Tables[0].Rows[0]["Qty__Base UOM"]).ToString();
            drProduct["SellStkUM"] = dtProductNow.Tables[0].Rows[0]["Base Unit of Measure"].ToString();
            drProduct["QtyAvail1"] = dtProductNow.Tables[0].Rows[0]["AvailableQuantity"];
            drProduct["NetUnitPrice"] = dtProductNow.Tables[0].Rows[0]["ItemPrice"].ToString();
            drProduct["AlternateUM"] = dtProductNow.Tables[0].Rows[0]["Alt Price UOM"].ToString();
            drProduct["ExtendedPrice"] = "0";
            drProduct["AlternateUMQty"] = strAltQtyUom;
            drProduct["ExtendedNetWght"] = "0.00";
            drProduct["pSODetailID"] = quote;
            drProduct["ItemDsc"] = dtProductNow.Tables[0].Rows[0]["Description"].ToString();
            drProduct["NetWght"] = dtProductNow.Tables[0].Rows[0]["Gross Weight"];

            drProduct["Remark"] = "";
            drProduct["IMLoc"] = dtProductNow.Tables[0].Rows[0]["LocationCode"].ToString();
            drProduct["QtyAvailLoc1"] = dtProductNow.Tables[0].Rows[0]["LocationCode"].ToString();
            drProduct["ItemNo"] = dtProductNow.Tables[0].Rows[0]["No_"].ToString();
            drProduct["DeleteDt"] = DBNull.Value;



            dtProduct.Rows.Add(drProduct);





            Session["dtProductNew"] = dtProduct;
        }
        catch (Exception ex) { }
    }

    //protected void SelectCheck(object sender, EventArgs e)
    //{
    //    RadioButton rb = new RadioButton();
    //    rb = (RadioButton)sender;
    //    sRbText = rb.ClientID;

    //    foreach (DataGridItem i in dgItemLookup.Items)
    //    {
    //        rb = (RadioButton)i.FindControl("rdoSelect");
    //        rb.Checked = false;
    //        if (sRbText == rb.ClientID)
    //        {
    //            rb.Checked = true;
    //            Label txtItemNo = (Label)i.FindControl("lblItemNo");
    //            hidItem.Value = txtItemNo.Text.Trim();
    //            
    //        }
    //    }
    //}
    #endregion

}
