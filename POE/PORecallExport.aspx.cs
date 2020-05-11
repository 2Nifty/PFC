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

public partial class PORecallExport : System.Web.UI.Page
{
    DataTable dtCommentTop = new DataTable();
    DataTable dtCommentBtm = new DataTable();
    DataTable dtComments = new DataTable();

    POERecall poRecall = new POERecall();

    string PONumber = "";
    string HeaderIDColumn = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblPONo.Text = PONumber = Request.QueryString["PONumber"].ToString();
            HeaderIDColumn = Request.QueryString["HeaderIDColumn"].ToString();
            BindHeader();
            BindGrid();
            BindComments();
        }
    }
    private void BindHeader()
    {
        string whereClause = HeaderIDColumn + "='" + PONumber.ToUpper().Replace("W", "")+"'";

        DataTable dsHeader = poRecall.GetPurchaseOrderDetails("POHeader", whereClause);
        if (dsHeader != null && dsHeader.Rows.Count > 0)
        {
            //BuyFrom Info
            lblBuy_Name.Text = dsHeader.Rows[0]["OrderContactName"].ToString().Trim();
            lblBuy_Address.Text = dsHeader.Rows[0]["BuyFromAddress"].ToString().Trim();
            lblBuy_City.Text = dsHeader.Rows[0]["BuyFromCity"].ToString().Trim();
            lblBuy_Territory.Text = dsHeader.Rows[0]["BuyFromState"].ToString().Trim();
            lblBuy_Phone.Text = dsHeader.Rows[0]["OrderContactPhoneNo"].ToString().Trim();
            lblBuy_Pincode.Text = dsHeader.Rows[0]["BuyFromZip"].ToString().Trim();
            lblBuyCom.Visible = ((lblBuy_City.Text.Trim() != "" && lblBuy_Territory.Text.Trim() != "") ? true : false);
            lblBuyCountry.Text = dsHeader.Rows[0]["BuyFromCountry"].ToString().Trim();
            lblBuyFromContact.Text = dsHeader.Rows[0]["OrderContactName"].ToString().Trim();

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

            lblBuyFromVendorNo.Text = dsHeader.Rows[0]["BuyFromVendorNo"].ToString().Trim();
            //lblShipVendorNo.Text = dsHeader.Rows[0]["POVendorNo"].ToString().Trim();

            //Totals

            lblTotCost.Text =string.Format("{0:#,##0.00}", dsHeader.Rows[0]["TotalCost"]);
            lblTotWeight.Text =string.Format("{0:#,##0.00}", dsHeader.Rows[0]["TotalGrossWeight"]);
            lblOrderStatus.Text = dsHeader.Rows[0]["PODocumentStatus"].ToString().Trim();
            lblPOStatus.Text = dsHeader.Rows[0]["POStatus"].ToString().Trim();
            // lblShipStatus.Text = dsHeader.Rows[0][""].ToString().Trim();
            lblExpenses.Text = dsHeader.Rows[0]["POExpenseInd"].ToString().Trim();

            //Order Details
            lblOrderNo.Text = dsHeader.Rows[0]["POOrderNo"].ToString().Trim();
            lblOrderDt.Text = dsHeader.Rows[0]["OrderDt"].ToString().Trim();
            lblOrderType.Text = dsHeader.Rows[0]["POTypeName"].ToString().Trim();

            //Ship Date

            lblBuyer.Text = dsHeader.Rows[0]["Buyer"].ToString().Trim();
            lblRefType.Text = dsHeader.Rows[0]["OrderRefType"].ToString().Trim();
            //lblReferences.Text = dsHeader.Rows[0][""].ToString().Trim();
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
            // lblReceivedBy.Text = dsHeader.Rows[0][""].ToString().Trim();
            lblEntryID.Text = dsHeader.Rows[0]["EntryID"].ToString().Trim();
        }

    }

    private void BindGrid()
    {
        DataTable dtRecall = poRecall.GetRecallDetail(PONumber);
        if (dtRecall != null && dtRecall.Rows.Count > 0)
        {
            gvRecallGird.DataSource = dtRecall;
            gvRecallGird.DataBind();
        }
      

    }

    protected void BindComments()
    {
        dtCommentTop = poRecall.BindTop(PONumber);
        dlCommentTop.DataSource = dtCommentTop.DefaultView.ToTable();
        dlCommentTop.DataBind();
        dtCommentBtm = poRecall.BindBottom(PONumber);
        dlCommentBtm.DataSource = dtCommentBtm.DefaultView.ToTable();
        dlCommentBtm.DataBind();
    }
    protected void gvRecallGird_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label lblLineNo = e.Row.FindControl("lblLineNo") as Label;
            DataList dlComment = e.Row.FindControl("dlComment") as DataList;
            dtComments = poRecall.BindComments(PONumber, lblLineNo.Text.ToString());
            dlComment.DataSource = dtComments.DefaultView.ToTable();
            dlComment.DataBind();
           

        }

    }
}
