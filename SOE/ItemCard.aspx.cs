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
using PFC.SOE.Enums;

public partial class ItemCard : System.Web.UI.Page
{
    Utility utility = new Utility();
    ItemCards icard = new ItemCards();

    string invalidMessage = "Invalid Item Number";
    string noRecordMessage = "No Records Found";
    string queryMessage = "Query Completed Successfully";

    DataTable dtItems = new DataTable ();

    string iNo = "";
    string loc = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register AJAX
        Ajax.Utility.RegisterTypeForAjax(typeof(ItemCard));

        lnkItemNo.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
        if (!IsPostBack)
        {
            txtItemNumber.Focus();
            txtItemNumber.Text = Request.QueryString["ItemNumber"].ToString();
            ddlLocation.SelectedValue = Request.QueryString["ShipLoc"].ToString();
            BindLocations();

            ddlLocation.SelectedIndex = -1;
            ListItem lstItem = ddlLocation.Items.FindByValue(Request.QueryString["ShipLoc"].ToString().Trim()) as ListItem;
            if (lstItem != null)
                lstItem.Selected = true;

            BindLabels();
       }

      
    }

    private void BindLabels()
    {
        iNo = txtItemNumber.Text.ToString();
        loc = ddlLocation.SelectedItem.Value.ToString();

        dtItems = icard.GetItCards(iNo, loc);
       
        if (dtItems != null && dtItems.Rows.Count > 0)
        {
            lblItem.Text = dtItems.Rows[0]["ItemNo"].ToString();
            lblDescription.Text = dtItems.Rows[0]["ItemDesc"].ToString();
            lblCategory.Text = dtItems.Rows[0]["CatDesc"].ToString();
            lblAltItem.Text = dtItems.Rows[0]["AltItemNo"].ToString();
            lblSell.Text = dtItems.Rows[0]["SellStkUM"].ToString();
            lblPriceUM.Text = dtItems.Rows[0]["PriceUM"].ToString();
            lblListPrice.Text = dtItems.Rows[0]["ListPrice"].ToString();
            lblAvgCost.Text = Math.Round(Convert.ToDecimal(dtItems.Rows[0]["Avgcost"].ToString()),2).ToString();
            lblStatus.Text = dtItems.Rows[0]["statusCd"].ToString();
            lblParentItem.Text = dtItems.Rows[0]["ParentProdNo"].ToString();
            lblCustomTraiff.Text = dtItems.Rows[0]["TariffCd"].ToString();
            lblStock.Text = dtItems.Rows[0]["StockInd"].ToString();
            lblCommodity.Text = dtItems.Rows[0]["CommodityCd"].ToString();
            lblWeight.Text = Math.Round(Convert.ToDecimal(dtItems.Rows[0]["Wght"].ToString()), 2).ToString();  
            lblHeight.Text = dtItems.Rows[0]["Height"].ToString();
            lblWidth.Text = dtItems.Rows[0]["Width"].ToString();
            lblDepth.Text = dtItems.Rows[0]["Depth"].ToString();
            lblCube.Text = dtItems.Rows[0]["CubicMsr"].ToString();
            lblEntryDate.Text = dtItems.Rows[0]["EntryDt"].ToString() == "" ? "" : Convert.ToDateTime(dtItems.Rows[0]["EntryDt"].ToString()).ToShortDateString();
            lblEntryID.Text = dtItems.Rows[0]["EntryID"].ToString();
            lblChangeID.Text = dtItems.Rows[0]["ChangeID"].ToString();
            lblChangeDate.Text = dtItems.Rows[0]["ChangeDt"].ToString() == "" ? "" : Convert.ToDateTime(dtItems.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
            lblLoc.Text = ddlLocation.SelectedValue.ToString(); // used for printing

            if (IsPostBack)
            {
                txtItemNumber.Text = "";
                ddlLocation.ClearSelection();
                utility.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
                upMessage.Update();
            }
          


            PrintDialogue1.CustomerNo = (Session["CustomerNumber"] != null ? Session["CustomerNumber"].ToString():"");
            PrintDialogue1.PageTitle = "Item Card for " + lblItem.Text;
            string TempUrl = "itemCardExport.aspx?ItemNumber=" + lblItem.Text + "&ShipLoc=" + lblLoc.Text;
            PrintDialogue1.PageUrl = Server.UrlEncode(TempUrl);
            upMessage.Update();

        }
        

        else
        {
            utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
            upMessage.Update();
            ClearControl();
        }

        pnlItemCard.Update();
        pnlItemCardDisp.Update();
    }

    private void BindLocations()
    {
        utility.BindListControls(ddlLocation, "Name", "Code", icard.GetLocationName(), "-- Select Location --");           
    }

    protected void ClearControl()
    {
        ddlLocation.SelectedIndex = 0;
        txtItemNumber.Text = "";
        lblItem.Text=  lblDescription.Text= lblCategory.Text=lblAltItem.Text =lblSell.Text=lblPriceUM.Text="";
        lblListPrice.Text = lblAvgCost.Text = lblStatus.Text = lblParentItem.Text = lblCustomTraiff.Text = "";
        lblWeight.Text = lblHeight.Text = lblWidth.Text = lblDepth.Text = lblCube.Text = lblEntryDate.Text = "";
        lblEntryID.Text = lblChangeID.Text = lblChangeDate.Text = "";
        lblStock.Text = lblCommodity.Text = "";
    }

    protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
    {
        ClearControl();
    }

    protected void GetItemLabelValues()
    {
        string iNo = (hidItemNumber.Value == "" ? txtItemNumber.Text.Trim().ToString() : hidItemNumber.Value );

        if (iNo != "")
        {
            DataTable dtItemNo = icard.ValidateItemNumber(iNo);
            if (dtItemNo != null && dtItemNo.Rows.Count > 0)
            {
                BindLabels();                
            }
            else
            {
                ClearControl();
                utility.DisplayMessage(MessageType.Failure, invalidMessage, lblMessage);
                upMessage.Update();
            }
        }
        else
        {
            ClearControl();
            utility.DisplayMessage(MessageType.Failure, invalidMessage, lblMessage);
            upMessage.Update();
        }

        pnlItemCard.Update();
        pnlItemCardDisp.Update();
        
       
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetPFCItemNumbers(string itemNo)
    {
        try
        {
            //DataTable dtItemNo = new DataTable();
            string tableName = "ItemMaster";
            string columnName = "Top 100 ItemNo"; //Contract No,Form Dist,
            string whereClause = "ItemNo Like '" + itemNo.Trim() + "'";
            //string whereClause = "ItemNo Like '00050%'";
            string detail = "";

            DataSet dsItemNumber = icard.ExecuteSelectQuery(tableName, columnName, whereClause);

            if (dsItemNumber != null && dsItemNumber.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in dsItemNumber.Tables[0].Rows)
                    detail = detail + "`" + dr["ItemNo"].ToString().Trim() ;

                if (detail != "")
                    detail = detail.Remove(0, 1);

                return detail;
            }
            else

                return "";            

        }
        catch (Exception ex)
        {
            return "";
        }
    }

    protected void btnLoadItem_Click(object sender, EventArgs e)
    {
        GetItemLabelValues();
        ScriptManager1.SetFocus(ddlLocation);        
    }
}
