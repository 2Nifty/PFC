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
using System.Drawing;
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.Enums;

public partial class ShippingStatus : System.Web.UI.Page
{
    Utility utility = new Utility();
    ShipStatus soShipStatus = new ShipStatus();
    OrderEntry orderEntry = new OrderEntry();

    string soNumber = "";
    string srcTable = "";
    string controlId = "";

    // string invalidMessage = "Invalid Item Number";
    string noRecordMessage = "No Records Found";
    string queryMessage = "Query Completed Successfully";
    string queryString = "";
    string UPSTrackingURL = "http://wwwapps.ups.com/WebTracking/OnlineTool?TypeOfInquiryNumber=T&InquiryNumber1=[PFCTRACKINGNO]&UPS_HTML_License=9BE22368C905B940&UPS_HTML_Version=3.0&IATA=us&Lang=eng";
    DataTable dsDetail = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
       if (!IsPostBack)
       {
           soNumber = txtSONumber.Text = Request.QueryString["SONumber"].ToString().Trim().ToUpper();
           ViewState["SONumber"] = soNumber;
           
           string dtSource = null;
           if (!IsPostBack && Session["OrderTableName"] != null)
               dtSource = soShipStatus.ValidateSoNumber("OrderNo='" + soNumber.Trim().Replace("W", "") + "'", Session["OrderTableName"].ToString());
           else if (soNumber.Contains("W"))
               dtSource = soShipStatus.ValidateSoNumber("OrderNo='" + soNumber.Trim() + "'","SOheaderrel");
           if (dtSource != null)
            {
                hidTableName.Value = dtSource;
                BindOrderDetails();

                // Display Just Header on LOAD (By passing empty parameter)
                if (gvControl.Rows.Count <= 0)
                {                    
                    DataTable dsControl = soShipStatus.GetGridControl(soNumber.Replace("W", ""));
                    dsControl.Rows.Clear();
                    dsControl.Rows.Add(dsControl.NewRow());
                    gvControl.ShowFooter = false;
                    gvControl.DataSource = dsControl;
                    gvControl.DataBind();
                }
                if (gvDetail.Rows.Count <= 0)
                {
                   dsDetail = soShipStatus.GetGridDetail("");
                    dsDetail.Rows.Clear();
                    dsDetail.Rows.Add(dsDetail.NewRow());
                    gvDetail.ShowFooter = false;
                    gvDetail.DataSource = dsDetail;
                    gvDetail.DataBind();
               }
               
           }
           else
           {
                utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                upMessage.Update();
                ClearControl();
          }

          ScriptManager1.SetFocus(txtSONumber);
       }    
    }

    public void BindOrderDetails()
    {
        DataTable dsSalesHeaderDetails = soShipStatus.GetShipHeaderDetails(soNumber.Replace("W", ""), hidTableName.Value);

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
                lblShipNum.Text = dsSalesHeaderDetails.Rows[0]["SellToCustNo"].ToString().Trim();

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
                //Bind Control Grid
                BindControlGrid();

                //if (IsPostBack)
                //{
                //    txtSONumber.Text = "";
                    

                //    // BindDetailGrid(controlId);

                //}
                PrintDialogue1.CustomerNo = lblSoldCustNum.Text;
                PrintDialogue1.PageTitle = "Shipment status for OrderNo " + txtSONumber.Text;
                string TempUrl = "ShippingStatusExport.aspx?SoNumber=" + soNumber.ToUpper().Replace("W","") + "&ASNNo=&EDI=&Package=&ControlId=&Type="+hidTableName.Value ;
                PrintDialogue1.PageUrl = Server.UrlEncode(TempUrl);
                
                utility.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
                upMessage.Update();
            }
            else
            {
                utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                upMessage.Update();
                ClearControl();
            }
               pnlSoEntry.Update();
        upControlGrid.Update();
        upDetailGrid.Update();
        upShipOrder.Update();
    }

    public void BindControlGrid()
    {
        DataTable dsControl= soShipStatus.GetGridControl(soNumber.Replace("W",""));
        
        if (dsControl != null )
        {
            dsControl.DefaultView.Sort = (hidSortControl.Value == "") ? "CartonNo asc" : hidSortControl.Value;

            gvControl.ShowFooter = true;
            gvControl.DataSource = dsControl;
            gvControl.DataBind();



            
        }
    }

    public void BindDetailGrid(string asnControlId)
    {
        controlId = asnControlId;
        dsDetail = soShipStatus.GetGridDetail(controlId);

        if (dsDetail != null)
        {
            dsDetail.DefaultView.Sort = (hidSortDetail.Value == "") ? "TotalQty desc" : hidSortDetail.Value;
            gvDetail.ShowFooter = true;
            gvDetail.DataSource = dsDetail;
            gvDetail.DataBind();
            

            if (dsDetail.Rows.Count == 0)
            {
                utility.DisplayMessage(MessageType.Failure, "ASN Details Not Found", lblMessage);
                upMessage.Update();
            }
        }
    }

    public void ClearControl()
    {
        //txtSONumber.Text = "";
        lblSold_Name.Text =lblSold_Contact.Text=lblSold_City.Text =lblSold_State.Text =lblSold_Phone.Text="";
        lblSold_Pincode.Text=lblSoldCom.Text=lblSoldCountry.Text=lblSoldCustNum.Text = "";
        lblShip_Name.Text=lblShip_Contact.Text=lblShip_City.Text =lblShip_State.Text = "";
        lblShip_Phone.Text=lblShip_Pincode.Text=lblShipCom.Text=lblShipCountry.Text = " ";
        lblOrderNo.Text=lblOrderType.Text = lblOrderDt.Text = lblShipLoc.Text = lblInvoiceNo.Text = " ";
        lblCarrier.Text = lblMinCharge.Text = lblAckDt.Text = lblCarrierPro.Text = " ";
        lblShipNum.Text = " ";                  
        lblVerify.Text= lblPrintDt.Text = lblReprints.Text =  " ";
        lblShipInstructions.Text=lblBeginDt.Text =lblEndPickDt.Text =lblShipDt.Text=lblShippedDt.Text="";
        lblInvoiceDt.Text = lblARDt.Text = lblSuggestDt.Text="";

        gvControl.DataSource = "";
        gvControl.DataBind();

        gvDetail.DataSource = "";
        gvDetail.DataBind();

        pnlSoEntry.Update();
        upShipOrder.Update();
        upControlGrid.Update();
        upDetailGrid.Update();
    }

    protected void txtSONumber_TextChanged(object sender, EventArgs e)
    {
        soNumber = txtSONumber.Text.ToUpper();
        ClearControl();
        string dtSource = null;
        if (Convert.ToBoolean(hidIsMultiple.Value) && !txtSONumber.Text.ToLower().Contains("w"))
        {
            hidIsMultiple.Value = "false";
            //btnBind_Click(null, null);
        }
        else
        {
            if (soNumber.ToUpper().Contains("W"))
            {
                dtSource = soShipStatus.ValidateSoNumber("OrderNo=" + soNumber.Trim().Replace("W", ""), "SOheaderrel");

                if (dtSource != null)
                {
                    hidTableName.Value = dtSource;
                    ViewState["SONumber"] = soNumber;
                    BindOrderDetails();
                }
            }
            else
            {
                DataSet dsOrderType = orderEntry.GetAvailableOrderType(soNumber);
                if (dsOrderType != null && dsOrderType.Tables[0].Rows.Count > 0 && dsOrderType.Tables[2].Rows.Count == 0 && dsOrderType.Tables[1].Rows.Count == 0)
                {
                    hidTableName.Value = "ORDER";
                    ViewState["SONumber"] = soNumber;
                    BindOrderDetails();
                }
                else if (dsOrderType != null)
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "OpenPage", "OpenTypeDialog('" + soNumber + "');", true);
                else
                {
                    ClearControl();
                    utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                    upMessage.Update();
                }
            }
            PrintDialogue1.CustomerNo = lblSoldCustNum.Text;
            PrintDialogue1.PageTitle = "Shipment status for OrderNo " + lblOrderNo.Text;
            string TempUrl = "ShippingStatusExport.aspx?SoNumber=" + soNumber.ToUpper().Replace("W","") + "&Type=" + hidTableName.Value + "&ASNNo=&EDI=&Package=&ControlId=";
            PrintDialogue1.PageUrl = Server.UrlEncode(TempUrl);
            upMessage.Update();
        }
      
       
    }

    protected void btnBind_Click(object sender, EventArgs e)
    {
        soNumber = txtSONumber.Text;
        ViewState["SONumber"] = soNumber;
        ClearControl();
        BindOrderDetails();
        PrintDialogue1.CustomerNo = lblSoldCustNum.Text;
        PrintDialogue1.PageTitle = "Shipment status for OrderNo " + lblOrderNo.Text;
        string TempUrl = "ShippingStatusExport.aspx?SoNumber=" +  soNumber.ToUpper().Replace("W", "") + "&Type=" + hidTableName.Value + "&ASNNo=&EDI=&Package=&ControlId=";
        PrintDialogue1.PageUrl = Server.UrlEncode(TempUrl);
            upMessage.Update();
        
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
        soNumber = ViewState["SONumber"].ToString();
        BindControlGrid();
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
        BindDetailGrid(ViewState["SelectedASNNo"].ToString());
    }

    protected void gvControl_RowCommand(object sender, GridViewCommandEventArgs e)
    {
       
        if (e.CommandName == "BindDetails")
        {
            controlId = e.CommandArgument.ToString().Trim();
            LinkButton lnk = e.CommandSource as LinkButton;
            System.Drawing.ColorConverter colConvert = new ColorConverter();
            string asnNo = lnk.Text;

            // clear previous selection            
            foreach (GridViewRow gvRow in gvControl.Rows)
                gvRow.BackColor = Color.White;

            // Change the color of the current item
            GridViewRow dr = lnk.Parent.Parent as GridViewRow;
            dr.BackColor  = (System.Drawing.Color)colConvert.ConvertFromString("#FEF7CB");
            ViewState["SelectedASNNo"] = controlId;

            queryString = "SoNumber=" + lblOrderNo.Text + "&ASNNo=" + asnNo + "&EDI=" + dr.Cells[1].Text + "&Package=" + dr.Cells[2].Text +
                            "&ControlId=" + controlId+"&Type="+hidTableName.Value ;
            PrintDialogue1.PageTitle = "Shipment status for OrderNo " + lblOrderNo.Text;
            PrintDialogue1.PageUrl = "ShippingStatusExport.aspx?" + queryString; 
            upMessage.Update();
            BindDetailGrid(controlId);
            upDetailGrid.Update();            
        }
    }
   
    protected void gvDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HiddenField hidCarrier = e.Row.FindControl("hidCarrier") as HiddenField;

            if (hidCarrier.Value.ToLower().Contains("ups"))
            {
                e.Row.Cells[5].Attributes.Add("onclick", "javascript:window.open('"+ UPSTrackingURL.Replace("[PFCTRACKINGNO]",e.Row.Cells[5].Text) +"');");
                e.Row.Cells[5].Style.Add(HtmlTextWriterStyle.Cursor, "hand");
                e.Row.Cells[5].ForeColor = System.Drawing.Color.Blue;
                e.Row.Cells[5].Font.Underline = true;
                e.Row.Cells[5].ToolTip = "Click to view UPS tracking information.";
            }
        }
            
            if (e.Row.RowType == DataControlRowType.Footer)
        {
            // e.Row.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", ""));
            e.Row.Cells[0].Text = String.Format("{0:#,##0}", dsDetail.Compute("sum(TotalQty)", ""));
            e.Row.Cells[3].Text = String.Format("{0:#,##0.00}", dsDetail.Compute("sum(TotalWeight)", ""));
        }

    }

    protected void gvControl_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[0].Text = "Total: " +gvControl.Rows.Count.ToString();              
        }
    }
    
}

   
