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

public partial class shippingStatusExport : System.Web.UI.Page
{
    Utility utility = new Utility();

    ShipStatus soShipStatus = new ShipStatus();

    string soNumber = "";
    string srcTable = "";
    string controlId = "";

    DataTable dsDetail = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            soNumber = txtSONumber.Text = Request.QueryString["SoNumber"].ToString();

            lblASN.Text = Request.QueryString["ASNNO"].ToString();
            lblEDI.Text = Request.QueryString["EDI"].ToString();
            lblPackage.Text = Request.QueryString["Package"].ToString();
            controlId = Request.QueryString["ControlId"].ToString();

            //soNumber = txtSONumber.Text = "445";
            // lblASN.Text = "1";
            //lblEDI.Text = "t";
            //lblPackage.Text = "Package";
            //controlId = "2";
            
            BindOrderDetails();
            
            if (controlId != "")
            {
                divDetailDisp.Visible = true;
                divControlDisp.Visible = false;
            }
            else
            {
                divControlDisp.Visible = true;
            }


        }
        

    }

    public void BindOrderDetails()
    {
        //srcTable = soShipStatus.ValidateSoNumber(soNumber);
        string type = Request.QueryString["Type"].ToString();
       
            DataTable dsSalesHeaderDetails = soShipStatus.GetShipHeaderDetails(soNumber,type );

            if (dsSalesHeaderDetails != null && dsSalesHeaderDetails.Rows.Count > 0)
            {

                //SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToProvidence,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToCd,ShipToName,ShipToAddress1,ShipToAddress2,ShipToAddress3,City,State,Zip,PhoneNo,FaxNo,ContactName,ContactPhoneNo";
                lblSold_Name.Text = dsSalesHeaderDetails.Rows[0]["SellToCustName"].ToString().Trim();
                lblSold_Contact.Text = dsSalesHeaderDetails.Rows[0]["SellToAddress1"].ToString().Trim();
                lblSold_City.Text = dsSalesHeaderDetails.Rows[0]["SellToCity"].ToString().Trim();
                lblSold_State.Text = dsSalesHeaderDetails.Rows[0]["SellToState"].ToString().Trim();
                lblSold_Phone.Text = dsSalesHeaderDetails.Rows[0]["SellToContactPhoneNo"].ToString().Trim();
                lblSold_Pincode.Text = dsSalesHeaderDetails.Rows[0]["SellToZip"].ToString().Trim();
                lblSoldCom.Visible = ((lblSold_City.Text.Trim() != "" && lblSold_State.Text.Trim() != "") ? true : false);
                lblSoldCountry.Text = dsSalesHeaderDetails.Rows[0]["SellToCountry"].ToString().Trim();

                lblShip_Name.Text = dsSalesHeaderDetails.Rows[0]["ShipToName"].ToString().Trim();
                lblShip_Contact.Text = dsSalesHeaderDetails.Rows[0]["ShipToAddress1"].ToString().Trim();
                lblShip_City.Text = dsSalesHeaderDetails.Rows[0]["City"].ToString().Trim();
                lblShip_State.Text = dsSalesHeaderDetails.Rows[0]["State"].ToString().Trim();
                lblShip_Phone.Text = dsSalesHeaderDetails.Rows[0]["PhoneNo"].ToString().Trim();
                lblShip_Pincode.Text = dsSalesHeaderDetails.Rows[0]["Zip"].ToString().Trim();
                lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_State.Text.Trim() != "") ? true : false);
                lblShipCountry.Text = dsSalesHeaderDetails.Rows[0]["Country"].ToString().Trim();

                lblSoldCustNum.Text = dsSalesHeaderDetails.Rows[0]["SellToCustNo"].ToString().Trim();
                lblShipCustNum.Text = dsSalesHeaderDetails.Rows[0]["SellToCustNo"].ToString().Trim();


                //Get Order Details.

                lblOrderNo.Text = dsSalesHeaderDetails.Rows[0]["OrderNo"].ToString().Trim();
                lblOrderType.Text = dsSalesHeaderDetails.Rows[0]["OrderType"].ToString().Trim();
                lblOrderDt.Text = dsSalesHeaderDetails.Rows[0]["OrderDt"].ToString().Trim();
                lblShipLoc.Text = dsSalesHeaderDetails.Rows[0]["ShipLoc"].ToString().Trim();
                lblInvoiceNo.Text = dsSalesHeaderDetails.Rows[0]["InvoiceNo"].ToString().Trim();
                lblCarrier.Text = dsSalesHeaderDetails.Rows[0]["Carrier"].ToString();
                lblCarrierPro.Text = dsSalesHeaderDetails.Rows[0]["BolNo"].ToString();
                lblProNo.Text = dsSalesHeaderDetails.Rows[0]["ShipTrackingNo"].ToString();
                lblMinCharge.Text = dsSalesHeaderDetails.Rows[0]["Amount"].ToString();
                lblReason.Text = dsSalesHeaderDetails.Rows[0]["HoldReason"].ToString();
               
                lblVerify.Text = dsSalesHeaderDetails.Rows[0]["VerifyType"].ToString();
                lblPrintDt.Text = dsSalesHeaderDetails.Rows[0]["PrintDt"].ToString().Trim();
                lblReprints.Text = dsSalesHeaderDetails.Rows[0]["OrderReprints"].ToString().Trim();
                
                //Get Order Dates

                lblAckDt.Text = dsSalesHeaderDetails.Rows[0]["AckPrintedDt"].ToString().Trim();
                lblSuggestDt.Text = dsSalesHeaderDetails.Rows[0]["AllocDt"].ToString().Trim();
                lblShipInstructions.Text = dsSalesHeaderDetails.Rows[0]["ShipInstr"].ToString().Trim();
                lblBeginDt.Text = dsSalesHeaderDetails.Rows[0]["PickDt"].ToString().Trim();
                lblEndPickDt.Text = dsSalesHeaderDetails.Rows[0]["PickCompDt"].ToString().Trim();
                lblShipDt.Text = dsSalesHeaderDetails.Rows[0]["ConfirmShipDt"].ToString().Trim();
                lblShippedDt.Text = dsSalesHeaderDetails.Rows[0]["ShippedDt"].ToString().Trim();
                lblInvoiceDt.Text = dsSalesHeaderDetails.Rows[0]["InvoiceDt"].ToString().Trim();
                lblARDt.Text = dsSalesHeaderDetails.Rows[0]["ARPostDt"].ToString().Trim();

                lblRefSONo.Text = dsSalesHeaderDetails.Rows[0]["RefSoNo"].ToString().Trim();
                lblOrgOrderNo.Text = dsSalesHeaderDetails.Rows[0]["origOrdNo"].ToString().Trim();

                if (lblASN.Text != "")
                {
                    //Bind Control Grid
                    BindDetailGrid(controlId);
                }
                else
                {
                    BindControlGrid();
                }

                if (IsPostBack)
                {
                    txtSONumber.Text = " ";
                    // BindDetailGrid(controlId);

                }
                //utility.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
                //upMessage.Update();
            }
            else
            {
                //utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                //upMessage.Update();
                //ClearControl();
            }
        
    }

    public void BindControlGrid()
    {
        DataTable dsControl = soShipStatus.GetGridControl(soNumber);


        if (dsControl != null)
        {

            dsControl.DefaultView.Sort = (hidSortControl.Value == "") ? "CartonNo asc" : hidSortControl.Value;
            gvControl.DataSource = dsControl;
            gvControl.DataBind();
        }

    }
    public void BindDetailGrid(string asnControlId)
    {
        controlId = asnControlId;
        dsDetail = soShipStatus.GetGridDetail(controlId);

        if (dsDetail != null && dsDetail.Rows.Count > 0)
        {
            dsDetail.DefaultView.Sort = (hidSortDetail.Value == "") ? "ItemNo asc" : hidSortDetail.Value;
            gvDetail.DataSource = dsDetail;
            gvDetail.DataBind();
        }
    }

    public void ClearControl()
    {
        txtSONumber.Text = "";


    }

    protected void txtSONumber_TextChanged(object sender, EventArgs e)
    {

        soNumber = txtSONumber.Text;
        BindOrderDetails();

    }
    

    protected void gvDetail_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (hidSortDetail.Attributes["sortType"] != null)
        {
            if (hidSortDetail.Attributes["sortType"].ToString() == "ASC")
                hidSortDetail.Attributes["sortType"] = "DESC";
            else
                hidSortDetail.Attributes["sortType"] = "ASC";
        }
        else
            hidSortDetail.Attributes.Add("sortType", "ASC");

        hidSortDetail.Value = e.SortExpression + " " + hidSortDetail.Attributes["sortType"].ToString();
        // BindDetailGrid();
    }

    protected void gvControl_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[0].Text = (e.Row.Cells.Count - 2).ToString();


        }
    }
    protected void gvControl_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (hidSortControl.Attributes["sortType"] != null)
        {
            if (hidSortControl.Attributes["sortType"].ToString() == "ASC")
                hidSortControl.Attributes["sortType"] = "DESC";
            else
                hidSortControl.Attributes["sortType"] = "ASC";
        }
        else
            hidSortControl.Attributes.Add("sortType", "ASC");

        hidSortControl.Value = e.SortExpression + " " + hidSortControl.Attributes["sortType"].ToString();
        BindControlGrid();
    }

    protected void gvDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            // e.Row.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", ""));
            e.Row.Cells[0].Text = String.Format("{0:#,##0}", dsDetail.Compute("sum(TotalQty)", ""));
            e.Row.Cells[3].Text = String.Format("{0:#,##0.00}", dsDetail.Compute("sum(TotalWeight)", ""));
        }
    }
}