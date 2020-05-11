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
using System.Text;
using PFC.POE.BusinessLogicLayer;


public partial class PORecall : System.Web.UI.Page
{
    string invalid = "No records found";
    string queryMessage = "Query Completed Successfully";
    
    DataTable dtCommentTop = new DataTable();
    DataTable dtCommentBtm = new DataTable();
    DataTable dtComments = new DataTable();

    POERecall poRecall = new POERecall();
    Utility utility = new Utility();
    public string HeaderIDColumn
    {
        get
        {
            return "POOrderNo";
        }
    }

    public string PONumber
    {
        set
        {
            hidPONo.Value = value;
        }
        get
        {
            return hidPONo.Value;
        }
    }

    string pPoInternalID = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hidPONo.Value= txtPONo.Text = Request.QueryString["PONumber"].ToString();
            BindHeader();
            txtPONo.Text = "";
                       
        }
           
            PrintDialogue1.CustomerNo = lblBuyFromVendorNo.Text;
            PrintDialogue1.PageSetup = PrintDialogue.PrinterSetup.Landscape;
            PrintDialogue1.PageTitle = "PO Recall for #:" + PONumber.ToString();
            PrintDialogue1.PageUrl = "PORecallExport.aspx?PONumber=" + PONumber + "&HeaderIDColumn=" + HeaderIDColumn;

      
    }
   
    private void BindHeader()
    {
        string whereClause = HeaderIDColumn + "='" +PONumber.ToUpper().Replace("W", "")+"'";                                                                                                        

        DataTable  dsHeader=poRecall.GetPurchaseOrderDetails("POHeader",  whereClause);
        if(dsHeader!=null && dsHeader.Rows.Count>0)
        {
            pPoInternalID = dsHeader.Rows[0]["pPOHeaderID"].ToString().Trim();
            //BuyFrom Info
            lblBuy_Name.Text = dsHeader.Rows[0]["OrderContactName"].ToString().Trim();
            lblBuy_Address.Text = dsHeader.Rows[0]["BuyFromAddress"].ToString().Trim();
            lblBuy_City.Text = dsHeader.Rows[0]["BuyFromCity"].ToString().Trim();
            lblBuy_Territory.Text = dsHeader.Rows[0]["BuyFromState"].ToString().Trim();
            lblBuy_Phone.Text = dsHeader.Rows[0]["OrderContactPhoneNo"].ToString().Trim();
            lblBuy_Pincode.Text = dsHeader.Rows[0]["BuyFromZip"].ToString().Trim();
            lblBuyCom.Visible = ((lblBuy_City.Text.Trim() != "" && lblBuy_Territory.Text.Trim() != "") ? true : false);
            lblBuyCountry.Text = dsHeader.Rows[0]["BuyFromCountry"].ToString().Trim();
            lblBuyFromContact.Text  = dsHeader.Rows[0]["OrderContactName"].ToString().Trim();
            lblBuyFromVendorNo.Text = dsHeader.Rows[0]["BuyFromVendorNo"].ToString().Trim();

            //Pay To
            lblPayTo.Text = dsHeader.Rows[0]["PayMethodCd"].ToString().Trim();
            
            //Ship To Info

            lblShip_Name.Text = dsHeader.Rows[0]["ShipToName"].ToString().Trim();
            lblShip_Address.Text = dsHeader.Rows[0]["ShipToAddress"].ToString().Trim();
            lblShip_City.Text = dsHeader.Rows[0]["ShipToCity"].ToString().Trim();
            lblShip_State.Text = dsHeader.Rows[0]["ShipToState"].ToString().Trim();
            lblShip_Phone.Text = dsHeader.Rows[0]["ShipToPhoneNo"].ToString().Trim();
            lblShip_Pincode.Text = dsHeader.Rows[0]["ShipToZip"].ToString().Trim();
            lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_State.Text.Trim() != "") ? true : false);
            lblShipCountry.Text = dsHeader.Rows[0]["ShipToCountry"].ToString().Trim();
            lblShipToContact.Text = dsHeader.Rows[0]["ShipToContactName"].ToString().Trim();

           
            //lblShipVendorNo.Text = dsHeader.Rows[0]["POVendorNo"].ToString().Trim();

            //Totals

            lblTotCost.Text  = String.Format("{0:#,##0.00}", dsHeader.Rows[0]["TotalCost"]);
            lblTotWeight.Text = String.Format("{0:#,##0.00}", dsHeader.Rows[0]["TotalGrossWeight"]);
            lblOrderStatus.Text = dsHeader.Rows[0]["PODocumentStatus"].ToString().Trim();
            lblPOStatus.Text=dsHeader.Rows[0]["POStatus"].ToString().Trim();
            lblShipStatus.Text = dsHeader.Rows[0]["ShipStatus"].ToString().Trim();
            lblExpenses.Text = dsHeader.Rows[0]["POExpenseInd"].ToString().Trim();

            //Order Details
            lblOrderNo.Text =dsHeader.Rows[0]["POOrderNo"].ToString().Trim();
            lblOrderDt.Text = dsHeader.Rows[0]["OrderDt"].ToString().Trim();
            lblOrderType.Text = dsHeader.Rows[0]["POTypeName"].ToString().Trim();

            //Ship Date

            lblBuyer.Text = dsHeader.Rows[0]["Buyer"].ToString().Trim();
            lblRefType.Text = dsHeader.Rows[0]["OrderRefType"].ToString().Trim();
            lblReferences.Text = dsHeader.Rows[0]["POReferences"].ToString().Trim();
            lblConfirming.Text = dsHeader.Rows[0]["ConfirmingTo"].ToString().Trim();
            lblShipInstructions.Text = dsHeader.Rows[0]["ShippingInstructions"].ToString().Trim();
            lblCarrier.Text = dsHeader.Rows[0]["Carrier"].ToString().Trim();
            lblShipMethod.Text = dsHeader.Rows[0]["ShipMethod"].ToString().Trim();
            lblTerms.Text = dsHeader.Rows[0]["OrderTerms"].ToString().Trim();
            lblSchdReptDt.Text = dsHeader.Rows[0]["ScheduledReceiptDt"].ToString().Trim();
            lblSchdShipDt.Text = dsHeader.Rows[0]["ScheduledShipDt"].ToString().Trim();
            lblPOPrintDt.Text = dsHeader.Rows[0]["POPrintDt"].ToString().Trim();
            lblDeleteDt.Text = dsHeader.Rows[0]["DeleteDt"].ToString().Trim();
            lblCompleteDt.Text = dsHeader.Rows[0]["CompleteDt"].ToString().Trim();
            lblReceiptDt.Text = dsHeader.Rows[0]["ReceiptDt"].ToString().Trim();
            lblReceivedBy.Text = dsHeader.Rows[0]["ReceivedBy"].ToString().Trim();
            lblEntryID.Text = dsHeader.Rows[0]["EntryID"].ToString().Trim();

            BindGrid();
            utility.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
           
        }
       
        else
        {
            ClearControl();
            utility.DisplayMessage(MessageType.Failure, invalid, lblMessage);
          
        }
        upHeader1.Update();
        upHeader2.Update();
        upRecallGrid.Update();
        upProgress.Update();
    }

    private void BindGrid()
    {
        DataTable dtRecall = poRecall.GetRecallDetail(PONumber);
        if (dtRecall != null && dtRecall.Rows.Count > 0)
        {
            gvRecallGird.DataSource = dtRecall;
            gvRecallGird.DataBind();
        }
        upRecallGrid.Update();

    }
    protected void BindComments()
    {
        dtCommentTop = poRecall.BindTop(PONumber);
        if (dtCommentTop != null)
        {
            dlCommentTop.DataSource = dtCommentTop.DefaultView.ToTable();
            dlCommentTop.DataBind();
        }
        dtCommentBtm = poRecall.BindBottom(PONumber);
        if (dtCommentBtm != null)
        {
            dlCommentBtm.DataSource = dtCommentBtm.DefaultView.ToTable();
            dlCommentBtm.DataBind();
        }
    }

    private void ClearControl()
    { 
        lblBuy_Name.Text =lblBuy_Address.Text = lblBuy_City.Text =lblBuy_Territory.Text =lblBuy_Phone.Text = "";
        lblBuy_Pincode.Text =  lblBuyCountry.Text = lblBuyFromContact.Text = "";
        lblShip_Name.Text = lblShip_Address.Text = lblShip_City.Text = lblShip_State.Text = lblShip_Phone.Text = "";
        lblShip_Pincode.Text =  lblShipCountry.Text = lblShipToContact.Text = lblBuyFromVendorNo.Text="";
        lblTotCost.Text = lblTotWeight.Text = lblOrderStatus.Text = lblPOStatus.Text = lblExpenses.Text = "";
        lblOrderNo.Text = lblOrderDt.Text = lblOrderType.Text = "";
        lblRefType.Text=lblConfirming.Text=lblShipInstructions.Text=lblCarrier.Text =lblShipMethod.Text= "";
        lblTerms.Text = lblSchdReptDt.Text = lblSchdShipDt.Text =lblPOPrintDt.Text = lblDeleteDt.Text = "";
        lblCompleteDt.Text = lblReceiptDt.Text = lblEntryID.Text = "";
        lblBuyer.Text = lblReferences.Text = lblReceivedBy.Text=lblShipStatus.Text="";
        lblBuyCom.Visible = lblShipCom.Visible = false;
        gvRecallGird.DataSource = "";
        gvRecallGird.DataBind();
        dlCommentTop.DataSource = ""; 
        dlCommentTop.DataBind();
        dlCommentBtm.DataSource = "";
        dlCommentBtm.DataBind();

    }

    protected void gvRecallGird_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[0].CssClass = "locked";
        e.Row.Cells[1].CssClass = "locked";

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
                Label lblLineNo = e.Row.FindControl("lblLineNo") as Label;
                DataList dlComment = e.Row.FindControl("dlComment") as DataList;
                dtComments = poRecall.BindComments(pPoInternalID, lblLineNo.Text.ToString());
                dlComment.DataSource = dtComments.DefaultView.ToTable();
                dlComment.DataBind();
                if (linkComment.Text=="Show Comments")
                    dlComment.Style.Add(HtmlTextWriterStyle.Display, "none");
           
        }

    }
    protected void txtPONo_TextChanged(object sender, EventArgs e)
    {
        hidPONo.Value = txtPONo.Text;
        ClearControl();
        BindHeader();
        txtPONo.Text = "";
        upHeader1.Update();
        upHeader2.Update();
        upRecallGrid.Update();
    }
    protected void linkComment_Click(object sender, EventArgs e)
    {
        if (linkComment.Text == "Show Comments")
        {
            linkComment.Text = "Hide Comments";
           
            dlCommentTop.Visible = true;
            
            for (int count = 0; count < gvRecallGird.Rows.Count; count++)
            {
                DataList dlList = gvRecallGird.Rows[count].FindControl("dlComment") as DataList;
                dlList.Style.Add(HtmlTextWriterStyle.Display, "");
            }
            dlCommentBtm.Visible = true;
            BindComments();
        }
        else
        {
            linkComment.Text = "Show Comments";
            dlCommentTop.Visible = false;
            for (int count = 0; count < gvRecallGird.Rows.Count; count++)
            {
                DataList dlList = gvRecallGird.Rows[count].FindControl("dlComment") as DataList;
                dlList.Style.Add(HtmlTextWriterStyle.Display, "none");
            }
            dlCommentBtm.Visible = false;
        }
        upRecallGrid.Update();
        upnlComment.Update();
    }
}
