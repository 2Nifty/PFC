using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;

public partial class SORecall : System.Web.UI.Page
{
    //For Get Invoice 

    SelectPrintInvoice printInvoice = new SelectPrintInvoice();

    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet dsOrd = new DataSet(), dsExp = new DataSet(), dsComm = new DataSet();

    Decimal DispVal, MerchTotShpQty, MerchTotReqQty, MerchTotExtPrice, TotExtPrice;
    Decimal TotalOrder, TotalCost, ShipWght, BOLWght, TotMgnPerLb, QtyShipped, QtyOrdered, ExtendedPrice, TaxExpAmt, NonTaxExpAmt;
    string DelFilter = " DeleteDt IS null";
    string TempTable;

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        //cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);

        TempTable = "tSORecall" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]");

        tStatus.Visible = false;
        tHeader1.Visible = true;
        tHeader2.Visible = true;
        tShipStatus1.Visible = true;
        tDetail.Visible = true;

        if (!Page.IsPostBack)
        {
            Session["DocNo"] = "";
            Session["DocType"] = "";
            if (Request.QueryString["DocNo"] != null && Request.QueryString["DocNo"].ToString() != "")
            {
                Session["DocNo"] = Request.QueryString["DocNo"].ToString();
                Session["DocType"] = Request.QueryString["DocType"].ToString();
                if (Session["DocNo"].ToString().Substring(0, 1) == "S" || Session["DocNo"].ToString().Substring(0, 1) == "s")
                    Session["DocType"] = "NV";
                NewDocument();
            }
            else
            {
                lblStatus.Text = "";
                tStatus.Visible = true;
                tHeader1.Visible = false;
                tHeader2.Visible = false;
                tShipStatus1.Visible = false;
                tDetail.Visible = false;
                txtOrderNo.Focus();
            }
        }
    }

    public void NewDocument()
    {
        txtOrderNo.Text = "";
        txtInvoiceNo.Text = "";
        txtOrigOrderNo.Text = "";

        int pos = Session["DocNo"].ToString().IndexOf("W", 0, StringComparison.OrdinalIgnoreCase);
        if (pos > 0 && Session["DocType"].ToString() != "NV")
            Session["DocNo"] = Session["DocNo"].ToString().Substring(0, pos);
        else
            Session["DocNo"] = Session["DocNo"].ToString();

        if (System.Text.RegularExpressions.Regex.IsMatch(Session["DocNo"].ToString(), @"\D") && Session["DocType"].ToString() != "I" && Session["DocType"].ToString() != "NV")
            DocNotNum();
        else
        {
            GetOrderData();
            if (dsOrd.Tables["Order"].Rows.Count > 0)
            {
                GetExpenseData();
                GetCommentData();
                DisplayHdrData();
                DisplayDtlData();
                DisplayExpData();
                InputFocus();
                BindPrintDialog();
            }
            else
                DocNotFound();

        }
    }

    public void GetOrderData()
    {
        cmd = new SqlCommand("pSOERecallOrd", cnxERP);
        cmd.Parameters.AddWithValue("@DocNo", Session["DocNo"].ToString());
        cmd.Parameters.AddWithValue("@DocType", Session["DocType"].ToString());
        cmd.Parameters.AddWithValue("@TempTable", TempTable.ToString());
        cmd.CommandType = CommandType.StoredProcedure;
        adp = new SqlDataAdapter(cmd);
        dsOrd.Clear();
        adp.Fill(dsOrd, "Order");
    }

    public void GetExpenseData()
    {
        DataRow OrderRow = dsOrd.Tables["Order"].DefaultView.ToTable().Rows[0];

        cmd = new SqlCommand("pSOERecallExp", cnxERP);
        cmd.Parameters.AddWithValue("@RecID", OrderRow["HeaderID"].ToString());
        cmd.Parameters.AddWithValue("@SOTable", OrderRow["SOTable"].ToString());
        cmd.Parameters.AddWithValue("@TempTable", TempTable.ToString());
        cmd.CommandType = CommandType.StoredProcedure;
        adp = new SqlDataAdapter(cmd);
        dsExp.Clear();
        adp.Fill(dsExp, "Expense");
    }

    public void GetCommentData()
    {
        DataRow OrderRow = dsOrd.Tables["Order"].DefaultView.ToTable().Rows[0];

        cmd = new SqlCommand("pSOERecallComm", cnxERP);
        cmd.Parameters.AddWithValue("@RecID", OrderRow["HeaderID"].ToString());
        cmd.Parameters.AddWithValue("@SOTable", OrderRow["SOTable"].ToString());
        cmd.Parameters.AddWithValue("@TempTable", TempTable.ToString());
        cmd.CommandType = CommandType.StoredProcedure;
        adp = new SqlDataAdapter(cmd);

        //Comment Top
        dsComm.Clear();
        adp.Fill(dsComm, "Comment");
        dsComm.Tables["Comment"].DefaultView.Sort = " CommLineNo, CommLineSeqNo";
        dsComm.Tables["Comment"].DefaultView.RowFilter = " Type='CT' AND DeleteDt IS null";
        dlCommentTop.DataSource = dsComm.Tables["Comment"].DefaultView.ToTable();
        dlCommentTop.DataBind();

        //Comment Bottom
        dsComm.Clear();
        adp.Fill(dsComm, "Comment");
        dsComm.Tables["Comment"].DefaultView.Sort = " CommLineNo, CommLineSeqNo";
        dsComm.Tables["Comment"].DefaultView.RowFilter = " Type='CB' AND DeleteDt IS null";
        dlCommentBtm.DataSource = dsComm.Tables["Comment"].DefaultView.ToTable();
        dlCommentBtm.DataBind();
    }

    public void DisplayHdrData()
    {
        //Load Order Header Data [Top Section]
        DataRow OrderRow = dsOrd.Tables["Order"].DefaultView.ToTable().Rows[0];
        txtOrderNo.Text = OrderRow["OrderNo"].ToString();
        txtInvoiceNo.Text = OrderRow["InvoiceNo"].ToString();
        txtOrigOrderNo.Text = OrderRow["OrigOrderNo"].ToString();
       
        lblOrderNo.Text = OrderRow["OrderNo"].ToString();
        lblOrderSource.Text = OrderRow["OrderSource"].ToString();
        lblOrderSource.ToolTip = GetOrderSourceDescription(OrderRow["OrderSource"].ToString());
        lblOrderType.Text = OrderRow["OrderTypeDsc"].ToString();
        lblOrderDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["OrderDt"]);
        lblCustShipLoc.Text = OrderRow["CustShipLoc"].ToString();
        lblShipLoc.Text = OrderRow["ShipLoc"].ToString();
        lblUsageLoc.Text = OrderRow["UsageLoc"].ToString();

        //Sell To Data
        lblSellToName.Text = OrderRow["SellToCustName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["SellToCustNo"].ToString()))
            lblSellToNo.Text = "&nbsp;";
        else
            lblSellToNo.Text = OrderRow["SellToCustNo"].ToString();
        lblSellToAddress1.Text = OrderRow["SellToAddress1"].ToString();
        if (string.IsNullOrEmpty(OrderRow["SellToCity"].ToString()))
            lblSellToAddress2.Text = OrderRow["SellToState"].ToString() + " " + OrderRow["SellToZip"].ToString() + " " + OrderRow["SellToCountry"].ToString();
        else
            lblSellToAddress2.Text = OrderRow["SellToCity"].ToString() + ", " + OrderRow["SellToState"].ToString() + " " + OrderRow["SellToZip"].ToString() + " " + OrderRow["SellToCountry"].ToString();
        lblSellToPhone.Text = OrderRow["SellToContactPhoneNo"].ToString();
        lblSellToContact.Text = OrderRow["SellToContactName"].ToString();

        //Bill To Data
        //if (string.IsNullOrEmpty(OrderRow["OrderTermsCd"].ToString()))
        //    lblBillToTerms.Text = "&nbsp;";
        //else
        //    lblBillToTerms.Text = OrderRow["OrderTermsCd"].ToString() + " - " + OrderRow["OrderTermsName"].ToString();
        lblBillToTerms.Text = OrderRow["OrderTermsName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["BillToCustNo"].ToString()))
            lblBillToNo.Text = "&nbsp;";
        else
            lblBillToNo.Text = OrderRow["BillToCustNo"].ToString();
        lblBillToName.Text = OrderRow["BillToCustName"].ToString();
        hidBillToCustNo.Value = OrderRow["BillToCustNo"].ToString();

        //Ship To Data
        lblShipToName.Text = OrderRow["ShipToName"].ToString();
        //if (string.IsNullOrEmpty(OrderRow["ShipToCd"].ToString()))
        //    lblShipToNo.Text = "&nbsp;";
        //else
        //    lblShipToNo.Text = OrderRow["ShipToCd"].ToString();
        if (string.IsNullOrEmpty(OrderRow["SellToCustNo"].ToString()))
            lblShipToNo.Text = "&nbsp;";
        else
            lblShipToNo.Text = OrderRow["SellToCustNo"].ToString();
        lblShipToAddress1.Text = OrderRow["ShipToAddress1"].ToString();
        if (string.IsNullOrEmpty(OrderRow["City"].ToString()))
            lblShipToAddress2.Text = OrderRow["State"].ToString() + " " + OrderRow["Zip"].ToString() + " " + OrderRow["Country"].ToString();
        else
            lblShipToAddress2.Text = OrderRow["City"].ToString() + ", " + OrderRow["State"].ToString() + " " + OrderRow["Zip"].ToString() + " " + OrderRow["Country"].ToString();
        lblShipToPhone.Text = OrderRow["PhoneNo"].ToString();
        lblShipToContact.Text = OrderRow["ContactName"].ToString();

        //Totals
        if (string.IsNullOrEmpty(OrderRow["TotalOrder"].ToString()))
            TotalOrder = 0;
        else
            TotalOrder = Convert.ToDecimal(OrderRow["TotalOrder"]);
        if (string.IsNullOrEmpty(OrderRow["TotalCost"].ToString()))
            TotalCost = 0;
        else
            TotalCost = Convert.ToDecimal(OrderRow["TotalCost"]);
        if (string.IsNullOrEmpty(OrderRow["ShipWght"].ToString()))
            ShipWght = 0;
        else
            ShipWght = Convert.ToDecimal(OrderRow["ShipWght"]);
        lblTotSales.Text = String.Format("{0:c}", TotalOrder);
        if (ShipWght == 0)
            TotMgnPerLb = 0;
        else
            TotMgnPerLb = Math.Round((TotalOrder - TotalCost) / ShipWght, 2);
        lblTotMgnPerLb.Text = String.Format("{0:c}", TotMgnPerLb, 2);
        lblTotWght.Text = String.Format("{0:N3}", ShipWght, 2);
        if (string.IsNullOrEmpty(OrderRow["TaxExpAmt"].ToString()))
            TaxExpAmt = 0;
        else
            TaxExpAmt = Convert.ToDecimal(OrderRow["TaxExpAmt"]);
        if (string.IsNullOrEmpty(OrderRow["NonTaxExpAmt"].ToString()))
            NonTaxExpAmt = 0;
        else
            NonTaxExpAmt = Convert.ToDecimal(OrderRow["NonTaxExpAmt"]);
        lblTotExp.Text = String.Format("{0:c}", TaxExpAmt + NonTaxExpAmt);

        //Load Order Header Data [Middle Section]
        //Column 1
        lblPONumber.Text = OrderRow["CustPONo"].ToString();
        lblReqDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["CustReqDt"]);
        lblShipDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["ConfirmShipDt"]);
        if (string.IsNullOrEmpty(OrderRow["OrderExpdCd"].ToString()))
            lblExpedite.Text = "&nbsp;";
        else
            lblExpedite.Text = OrderRow["OrderExpdCd"].ToString() + " - " + OrderRow["OrderExpdCdName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["RefSONo"].ToString()))
            lblRefSO.Text = "&nbsp;";
        else
            lblRefSO.Text = OrderRow["RefSONo"].ToString();

        //Column 2
        lblInvoiceNo.Text = OrderRow["InvoiceNo"].ToString();
        if (string.IsNullOrEmpty(OrderRow["DeleteDtHdr"].ToString()))
            lblInvoiceDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["InvoiceDt"]);
        else
        {
            lblInvoiceDtLbl.Text = "Delete Dt:";
            lblInvoiceDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["DeleteDtHdr"]);
        }
        if (string.IsNullOrEmpty(OrderRow["OrderCarrier"].ToString()))
            lblCarrier.Text = "&nbsp;";
        else
            lblCarrier.Text = OrderRow["OrderCarrier"].ToString() + " - " + OrderRow["OrderCarName"].ToString();
        lblCarrierPro.Text = OrderRow["BOLNO"].ToString();
        if (string.IsNullOrEmpty(OrderRow["ReferenceNo"].ToString()))
            lblRefNo.Text = "&nbsp;";
        else
            lblRefNo.Text = OrderRow["ReferenceNo"].ToString();

        //Column 3
        if (string.IsNullOrEmpty(OrderRow["OrderFreightCd"].ToString()))
            lblFreight.Text = "&nbsp;";
        else
            lblFreight.Text = OrderRow["OrderFreightCd"].ToString() + " - " + OrderRow["OrderFreightName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["OrderPriorityCd"].ToString()))
            lblPriority.Text = "&nbsp;";
        else
            lblPriority.Text = OrderRow["OrderPriorityCd"].ToString() + " - " + OrderRow["OrderPriName"].ToString();
        lblHoldRsn.Text = OrderRow["HoldReason"].ToString();
        if (string.IsNullOrEmpty(OrderRow["MinBillAmt"].ToString()))
            lblMinChg.Text = "&nbsp;";
        else
            lblMinChg.Text = String.Format("{0:c}", OrderRow["MinBillAmt"]);

        //Column 4
        lblSuggDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["AllocDt"]);
        lblAllocDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["AllocDt"]);
        lblPickPrDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["PrintDt"]);
        if (string.IsNullOrEmpty(OrderRow["ContractNo"].ToString()))
            lblContract.Text = "&nbsp;";
        else
            lblContract.Text = OrderRow["ContractNo"].ToString();

        //Load Shipping Status Section
        //Column 1
        if (string.IsNullOrEmpty(OrderRow["ShippingMark1"].ToString()))
            lblMark1.Text = "&nbsp;";
        else
            lblMark1.Text = OrderRow["ShippingMark1"].ToString();
        if (string.IsNullOrEmpty(OrderRow["ShippingMark2"].ToString()))
            lblMark2.Text = "&nbsp;";
        else
            lblMark2.Text = OrderRow["ShippingMark2"].ToString();
        if (string.IsNullOrEmpty(OrderRow["ShippingMark3"].ToString()))
            lblMark3.Text = "&nbsp;";
        else
            lblMark3.Text = OrderRow["ShippingMark3"].ToString();
        if (string.IsNullOrEmpty(OrderRow["ShippingMark4"].ToString()))
            lblMark4.Text = "&nbsp;";
        else
            lblMark4.Text = OrderRow["ShippingMark4"].ToString();
        if (string.IsNullOrEmpty(OrderRow["ShipInstrCd"].ToString()))
            lblShipInstr.Text = "&nbsp;";
        else
            lblShipInstr.Text = OrderRow["ShipInstrCd"].ToString() + " - " + OrderRow["ShipInstrCdName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["Remarks"].ToString()))
            lblRemark.Text = "&nbsp;";
        else
            lblRemark.Text = OrderRow["Remarks"].ToString();

        //Column 2
        lblUPSNo.Text = OrderRow["BOLNO"].ToString();
        if (string.IsNullOrEmpty(OrderRow["BOLWght"].ToString()))
            BOLWght = 0;
        else
            BOLWght = Convert.ToDecimal(OrderRow["BOLWght"]);
        lblShipWght.Text = String.Format("{0:N3}", BOLWght, 2);
        lblNoCtn.Text = String.Format("{0:N0}", OrderRow["NoCartons"]);

        //Column 3
        if (string.IsNullOrEmpty(OrderRow["OrigShipDt"].ToString()))
            lblOrigShipDt.Text = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        else
            lblOrigShipDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["OrigShipDt"]);
        lblActShipDt.Text = String.Format("{0:MM/dd/yyyy}", OrderRow["ConfirmShipDt"]);
    }

    public void DisplayDtlData()
    {
        dsOrd.Tables["Order"].DefaultView.Sort = " LineNumber";
        dsOrd.Tables["Order"].DefaultView.RowFilter = DelFilter;
        GridViewDtl1.DataSource = dsOrd.Tables["Order"].DefaultView.ToTable();
        GridViewDtl1.DataBind();

        lblMerchTotShpQty.Text = String.Format("{0:N0}", MerchTotShpQty);
        lblMerchTotReqQty.Text = String.Format("{0:N0}", MerchTotReqQty);
        lblMerchTotExtPrice.Text = String.Format("{0:c}", MerchTotExtPrice);
    }

    public void DisplayExpData()
    {
        dsExp.Tables["Expense"].DefaultView.Sort = " LineNumber";
        dsExp.Tables["Expense"].DefaultView.RowFilter = DelFilter;
        dlExpense.DataSource = dsExp.Tables["Expense"].DefaultView.ToTable();
        dlExpense.DataBind();

        TotExtPrice = MerchTotExtPrice;
        foreach (DataRow ExpenseRow in dsExp.Tables["Expense"].DefaultView.ToTable().Rows)
            TotExtPrice = TotExtPrice + Convert.ToDecimal(ExpenseRow["Amount"].ToString());
        lblTotExtPrice.Text = String.Format("{0:c}", TotExtPrice);  

        if (dsExp.Tables["Expense"].DefaultView.ToTable().Rows.Count > 0)
            trExpense.Visible = true;
        else
            trExpense.Visible = false;
    }

    public string GetOrderSourceDescription(string listValue)
    {
        string _tableName = "ListMaster LM ,ListDetail LD";
        string _columnName = "LD.ListdtlDesc as ListDesc";
        string _whereClause = "LM.ListName = 'SOEOrderSource' And LD.fListMasterID = LM.pListMasterID And LD.ListValue='" + listValue + "'";
        object result = (object) SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));
        return (result != null ? result.ToString() : "");
        
    }

    protected void GridViewDtl1_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            if (string.IsNullOrEmpty(e.Item.Cells[3].Text.ToString()) || e.Item.Cells[3].Text == "&nbsp;")
                QtyShipped = 0;
            else
                QtyShipped = Convert.ToDecimal(e.Item.Cells[3].Text);
            MerchTotShpQty = MerchTotShpQty + QtyShipped;

            if (string.IsNullOrEmpty(e.Item.Cells[5].Text.ToString()) || e.Item.Cells[5].Text == "&nbsp;")
                QtyOrdered = 0;
            else
                QtyOrdered = Convert.ToDecimal(e.Item.Cells[5].Text);
            MerchTotReqQty = MerchTotReqQty + QtyOrdered;

            if (string.IsNullOrEmpty(e.Item.Cells[10].Text.ToString()) || e.Item.Cells[10].Text == "&nbsp;")
                ExtendedPrice = 0;
            else
                ExtendedPrice = Convert.ToDecimal(e.Item.Cells[10].Text);
            MerchTotExtPrice = MerchTotExtPrice + ExtendedPrice;
            DispVal = ExtendedPrice;
            e.Item.Cells[10].Text = String.Format("{0:c}", DispVal);

            //Comment Line
            if (e.Item.Cells[13].Text.ToString() != null && e.Item.Cells[13].Text.ToString() != "&nbsp;")
            {
                DataList dlComment = e.Item.FindControl("dlComment") as DataList;
                dsComm.Clear();
                adp.Fill(dsComm, "Comment");
                dsComm.Tables["Comment"].DefaultView.Sort = " CommLineNo, CommLineSeqNo";
                dsComm.Tables["Comment"].DefaultView.RowFilter = " Type='LC' AND CommLineNo=" + e.Item.Cells[13].Text.ToString() + " AND DeleteDt IS null";
                dlComment.DataSource = dsComm.Tables["Comment"].DefaultView.ToTable();
                dlComment.DataBind();
            }
        }
    }

    protected void txtOrderNo_TextChanged(object sender, EventArgs e)
    {
        Session["DocNo"] = txtOrderNo.Text;
        if (Session["DocNo"].ToString().Substring(0, 1) == "S" || Session["DocNo"].ToString().Substring(0, 1) == "s")
            Session["DocType"] = "NV";
        else
            Session["DocType"] = "S";
        NewDocument();
        BindPrintDialog();
    }
    
    protected void txtInvoiceNo_TextChanged(object sender, EventArgs e)
    {
        Session["DocNo"] = txtInvoiceNo.Text;
        Session["DocType"] = "I";
        NewDocument();
        BindPrintDialog();
    }

    protected void txtOrigOrderNo_TextChanged(object sender, EventArgs e)
    {
        Session["DocNo"] = txtOrigOrderNo.Text;
        Session["DocType"] = "O";
        NewDocument();
        BindPrintDialog();
    }

    protected void btnShipStatus_Click(object sender, ImageClickEventArgs e)
    {
        if (tShipStatus2.Visible == false)
        {
            divdtlgrid.Style.Add("height", "203px");
            btnShipStatus.ImageUrl = "Images/minus.jpg";
            trShipStatus1.Visible = false;
            tShipStatus2.Visible = true;
            tShipStatus3.Visible = true;
        }
        else
        {
            divdtlgrid.Style.Add("height", "290px");
            btnShipStatus.ImageUrl = "Images/plus.jpg";
            trShipStatus1.Visible = true;
            tShipStatus2.Visible = false;
            tShipStatus3.Visible = false;
        }
    }

    protected void linkComment_OnClick(object sender, EventArgs e)
    {
        if (linkComment.Text == "Show Comments")
        {
            linkComment.Text = "Hide Comments";
            dlCommentTop.Visible = true;
            for (int count = 0; count < GridViewDtl1.Items.Count; count++)
                GridViewDtl1.Items[count].FindControl("dlComment").Visible = true; 
            dlCommentBtm.Visible = true;
        }
        else
        {
            linkComment.Text = "Show Comments";
            dlCommentTop.Visible = false;
            for (int count = 0; count < GridViewDtl1.Items.Count; count++)
                GridViewDtl1.Items[count].FindControl("dlComment").Visible = false; 
            dlCommentBtm.Visible = false;
        }
    }

    protected void linkDeleted_OnClick(object sender, EventArgs e)
    {
        if (linkDeleted.Text == "Show Deleted Lines")
        {
            linkDeleted.Text = "Hide Deleted Lines";
            DelFilter = "";
        }
        else
        {
            linkDeleted.Text = "Show Deleted Lines";
            DelFilter = " DeleteDt IS null";
        }

        GetOrderData();
        GetExpenseData();
        GetCommentData();
        DisplayDtlData();
        for (int count = 0; count < GridViewDtl1.Items.Count; count++)
            GridViewDtl1.Items[count].FindControl("dlComment").Visible = dlCommentBtm.Visible; 
        DisplayExpData();
    }

    public void InputFocus()
    {
        if (Session["DocType"].ToString() == "S" || Session["DocType"].ToString() == "NV")
        {
            lblStatus.Text = "Sales Order # ";
            if (Session["DocType"].ToString() != "NV")
                txtOrderNo.Text = Session["DocNo"].ToString();
            txtOrderNo.Focus();
        }
        if (Session["DocType"].ToString() == "I")
        {
            lblStatus.Text = "Invoice # ";
            txtInvoiceNo.Text = Session["DocNo"].ToString();
            txtInvoiceNo.Focus();
        }
        if (Session["DocType"].ToString() == "O")
        {
            lblStatus.Text = "Orig Order # ";
            txtOrigOrderNo.Text = Session["DocNo"].ToString();
            txtOrigOrderNo.Focus();
        }
    }

    public void DocNotNum()
    {
        InputFocus();
        lblStatus.Text += Session["DocNo"].ToString() + " must be numeric";
        tStatus.Visible = true;
        tHeader1.Visible = false;
        tHeader2.Visible = false;
        tShipStatus1.Visible = false;
        tDetail.Visible = false;
    }

    public void DocNotFound()
    {
        InputFocus();
        lblStatus.Text += Session["DocNo"].ToString() + " Not Found";
        tStatus.Visible = true;
        tHeader1.Visible = false;
        tHeader2.Visible = false;
        tShipStatus1.Visible = false;
        tDetail.Visible = false;
    }

    public void BindPrintDialog()
    {
        if (Session["DocNo"] != "")
        {
            Print.CustomerNo = hidBillToCustNo.Value;
            Print.PageTitle = "SO Recall for Order # " + Session["DocNo"];
            Print.PageUrl = "SORecall/SoRecallExport.aspx?DocNo=" + Session["DocNo"] + "&DocType=" + Session["DocType"];
            pnlStatusMessage.Update();
        }       
    }

    /// <summary>
    /// Get Invoice libertypage 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnInvoice_Click(object sender, ImageClickEventArgs e)
    {
        if (txtOrderNo.Text.Trim() != "")
        {
            string invoiceNo = "";

            string orderNo = txtOrderNo.Text.ToLower().Replace("w", "");

            string whereClause = txtOrderNo.Text.Trim().ToLower().Contains("w") ? "OrderRelNo='" + orderNo + "'" : "OrderNo='" + orderNo + "'";

            DataTable dtOrder = printInvoice.GetInvoice(whereClause);

            if (dtOrder != null && dtOrder.Rows.Count > 0)
            {
                if (dtOrder.Rows.Count == 1)
                {
                    invoiceNo = dtOrder.Rows[0]["InvoiceNo"].ToString();
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableInvoice", "AvailInvoice('" + orderNo + "');", true);
                }
            }
        }
    }
}
