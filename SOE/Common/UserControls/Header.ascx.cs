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

using System.Data.SqlClient;

using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.Securitylayer;

public partial class Common_UserControls_Header : System.Web.UI.UserControl
{
    #region Class objects

    Utility utils = new Utility();
    CustomerDetail custDet = new CustomerDetail();
    OrderEntry orderEntry = new OrderEntry();
    Common common = new Common();
    string termDesc="";
    string colorCd = "";

    #endregion

    #region Propery Bags

    public string HeaderIDColumn
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "fSOHeaderID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "pSOHeaderRelID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "pSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }

    public string custNumber
    {
        get
        {
            return txtCustNo.Text.Trim();
        }
        set
        {
            txtCustNo.Text = value;
            hidCust.Value = value;
        }
    }

    public string BillToCustomerNumber
    {
        get
        {
            return lblBillCustNo.Text.Trim();
        }
    }

    public string CreditInd
    {
        get
        {
            return hidCreditInd.Value.Trim();
        }
        set
        {
            hidCreditInd.Value = value;
        }
    }

    public string custName
    {
        get
        {
            return lblSold_Name.Text.Trim();
        }
    }

    public string CustPriceCode
    {
        set
        {
            ViewState["PriceCode"] = value;
        }
        get {
            return (ViewState["PriceCode"] != null) ? ViewState["PriceCode"].ToString() : "";
        }
    }

    public string CustomerName
    {
        set
        {
            ViewState["CustomerName"] = value;
        }
        get
        {
            return (ViewState["CustomerName"] != null) ? ViewState["CustomerName"].ToString() : "";
        }
    }

    public string SOrderNumber
    {
        get { return txtSONumber.Text; }
    }

    public string SOOrderID
    {
        set
        {
            Session["OrderHeaderID"] = value;
        }
        get
        {
            return Session["OrderHeaderID"].ToString();
        }

    }

    bool _isBilltoCust;
    public bool ISBillToCustomer
    {
        set
        {
            _isBilltoCust = value;
        }
        get
        {
            return _isBilltoCust;
        }

    }
   
    
#endregion

    #region Page load event handler
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (txtSONumber.Text == "")
            {
                lblShipCom.Visible = false;
                lblSoldCom.Visible = false;
            }

            txtSONumber.ReadOnly = false;
            txtCustNo.ReadOnly = false;
            
        }

        hidTableName.Value = (Session["OrderTableName"] != null) ? Session["OrderTableName"].ToString() : "SOHeader";
    } 
    #endregion

    #region Event handlers
    protected void txtCustNo_TextChanged(object sender, EventArgs e)
    {
        hidTableName.Value = "SOHeader";
        LoadCustomerDetails();
    }
   
    public void btnLoadAll_Click(object sender, EventArgs e)
    {
        try
        {
            LoadHeaderValue();
        }
        catch (Exception ex) { }
    } 
    #endregion

    #region Developer Code

    /// <summary>ear
    /// Function to load the customer details
    /// </summary>
    public void LoadCustomerDetails()
    {
        string strCustNo = custNumber = txtCustNo.Text;
        int strCnt = 0;

        bool textIsNumeric = true;
        try
        {
            int.Parse(strCustNo);
        }
        catch
        {
            textIsNumeric = false;
        }

        if ((strCustNo != "") && !textIsNumeric)
        {
            ScriptManager.RegisterClientScriptBlock(txtCustNo, txtCustNo.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo)) + "');", true);
        }
        else
        {
            if (strCustNo != "")
            {
                #region Code to fill the customer details in the controls

                // Call the webservice to get the customer address detail
                DataSet dsCustomer = orderEntry.GetCustomerDetails(txtCustNo.Text.Trim().Replace("'", ""));

                // Function to clear the value in the label
                ClearLabels();

                if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count != 0)
                {
                    string creditStatus = "";
                    if (dsCustomer.Tables[0].Rows[0]["CustCd"].ToString() != "BT" && dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString() != "")
                    {

                        creditStatus = orderEntry.GetCreditReview(dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString().ToString(), dsCustomer.Tables[2].Rows[0]["CreditInd"].ToString().Trim(), "0", "Order");
                        if (creditStatus.ToUpper() == "OK")
                        {
                            hidCust.Value = txtCustNo.Text;
                            Session["CustomerNumber"] = hidCust.Value.Trim();
                            Session["CustomerDetail"] = dsCustomer;
                            CustPriceCode = dsCustomer.Tables[0].Rows[0]["Customer Price Code"].ToString().Trim();
                            CustomerName = dsCustomer.Tables[0].Rows[0]["Name"].ToString().Trim();
                            FillCustomerAddress(dsCustomer);
                            lblCusNum.Text = hidCust.Value.Trim();
                            lblCustNum.Text = hidCust.Value.Trim();
                            lblChainValue.Text = dsCustomer.Tables[0].Rows[0]["Chain Name"].ToString().Trim();
                            lblBillCustNo.Text = dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString().Trim();
                            lblShip_Name.Text = dsCustomer.Tables[3].Rows[0]["Name"].ToString().Trim();
                            lblSold_Name.Text = dsCustomer.Tables[0].Rows[0]["Name"].ToString().Trim();
                            lblSoDate.Text = DateTime.Now.ToShortDateString();
                            // Code to bind the location details
                            DataSet dsLocation = custDet.GetLocationDetails();
                            CreditInd = dsCustomer.Tables[2].Rows[0]["CreditInd"].ToString().Trim();
                            InsertHeaderDetail();
                            lblTermDesc.Text = termDesc;
                            string script = "var popUp=window.open (\"CASReport.aspx?CustNo=" + Session["CustomerNumber"].ToString() + "\",\"Maximize\",'height=505,width=705,scrollbars=no,status=no,top='+((screen.height/2) - (460/2))+',left='+((screen.width/2) - (705/2))+',resizable=NO','');" +
                                            "popUp.focus();";
                            lblTermDesc.Attributes.Add("onclick", script);
                            SetTermColor();
                            ISBillToCustomer = false;
                            // txtSONumber.ReadOnly = true;
                            txtCustNo.ReadOnly = true;
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(txtCustNo, typeof(TextBox), "invalid", "alert('" + creditStatus + "');", true);
                            return;
                        }
                    }
                    else
                    {
                        ISBillToCustomer = true;
                        ScriptManager.RegisterClientScriptBlock(txtCustNo, typeof(TextBox), "invalid", "alert('Bill To Only Customer could not process order');document.getElementById('" + txtCustNo.ClientID + "').value='';document.getElementById('" + txtCustNo.ClientID + "').focus();document.getElementById('" + txtCustNo.ClientID + "').select();", true);
                    }

                }
                else
                {
                    hidCust.Value = "";
                    ScriptManager.RegisterClientScriptBlock(txtCustNo, typeof(TextBox), "invalid", "alert('Invalid Customer value');document.getElementById('" + txtCustNo.ClientID + "').value='';document.getElementById('" + txtCustNo.ClientID + "').focus();document.getElementById('" + txtCustNo.ClientID + "').select();", true);
                }
                #endregion
            }
            else
            {
                ClearLabels();
            }
        }
    }

    /// <summary>
    /// Function to fill the customer address
    /// </summary>
    /// <param name="dtAddress"></param>
    public void FillCustomerAddress(DataSet dtAddress)
    {
        // Set the customer address details to the control
        if (dtAddress != null && dtAddress.Tables[2].Rows.Count > 0)
        {
            lblBill_To.Text = dtAddress.Tables[2].Rows[0]["Name"].ToString().Trim();
            lblBillCustNo.Text = dtAddress.Tables[2].Rows[0]["CustNo"].ToString().Trim();
        }

        if (dtAddress != null && dtAddress.Tables[1].Rows.Count > 0)
        {

            lblSoldTo_Address.Text = dtAddress.Tables[1].Rows[0]["Address"].ToString().Trim();
            lblSold_Address2.Text = dtAddress.Tables[1].Rows[0]["Address 2"].ToString().Trim();
            lblSold_City.Text = dtAddress.Tables[1].Rows[0]["City"].ToString().Trim();
            lblSold_Territory.Text = dtAddress.Tables[1].Rows[0]["State"].ToString().Trim();
            HttpContext.Current.Session["CustomerCity"] = lblSold_City.Text;
            HttpContext.Current.Session["CustomerState"] = lblSold_Territory.Text;
            lblSold_Phone.Text = utils.FormatPhoneNumber(dtAddress.Tables[1].Rows[0]["Phone No_"].ToString().Trim());
            lblSold_Pincode.Text = dtAddress.Tables[1].Rows[0]["Post Code"].ToString().Trim();
            //lblUsageLoc.Text = dtAddress.Rows[0]["Usage Location"].ToString();
            lblSoldCom.Visible = ((lblSold_City.Text.Trim() != "" && lblSold_Territory.Text.Trim() != "") ? true : false);
            lblSoldCountry.Text = dtAddress.Tables[1].Rows[0]["Country"].ToString().Trim();
            lblOrderContact.Text = dtAddress.Tables[1].Rows[0]["Contact"].ToString().Trim();
        }
        if (dtAddress != null && dtAddress.Tables[3].Rows.Count > 0)
            FillShipTo(dtAddress.Tables[3]);
    }

    /// <summary>
    /// Function to fill ship to details
    /// </summary>
    /// <param name="dtShipTo"></param>
    public void FillShipTo(DataTable dtShipTo)
    {
        // Code to fill the ship to details

        lblShip_Address.Text = dtShipTo.Rows[0]["Address"].ToString().Trim();
        lblShip_Address2.Text = dtShipTo.Rows[0]["Address 2"].ToString().Trim();        
        lblShip_City.Text = dtShipTo.Rows[0]["City"].ToString().Trim();
        lblShip_Territory.Text = dtShipTo.Rows[0]["State"].ToString().Trim();
        lblShip_Phone.Text = utils.FormatPhoneNumber(dtShipTo.Rows[0]["Phone No_"].ToString().Trim());
        lblShip_Pincode.Text = dtShipTo.Rows[0]["Post Code"].ToString().Trim();
        lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_Territory.Text.Trim() != "") ? true : false);
        lblShipCountry.Text = dtShipTo.Rows[0]["Country"].ToString().Trim();
    }

    /// <summary>
    /// Function to clear labels 
    /// </summary>
    public void ClearLabels()
    {
        try
        {
            lblSold_Name.Text = "";
            lblSold_Contact.Text = "";
            lblSold_City.Text = "";
            lblSold_Territory.Text = "";
            lblSold_Phone.Text = "";
            lblSold_Pincode.Text = "";
            lblSoldTo_Address.Text = "";
            lblShip_Name.Text = "";
            lblShip_Address.Text = "";
            lblShip_City.Text = "";
            lblShip_Territory.Text = "";
            lblShip_Phone.Text = "";
            lblShip_Pincode.Text = "";
            lblCustNum.Text = "";
            lblCusNum.Text = "";
            lblChainValue.Text = "";
            lblSoldCountry.Text = "";
            lblShipCountry.Text = "";
            lblBill_To.Text = "";
            lblBillCustNo.Text = "";
            lblSoDate.Text = "";
            lblOrderContact.Text = "";
            lblTermDesc.Text = "";
            pnlCustomer.Update();
        }
        catch (Exception ex) { }
    }

    public void InsertHeaderDetail()
    {
        DataSet dsCustomer = new DataSet();
        DataSet dtCustomer = (DataSet)Session["CustomerDetail"];

        #region Insert into SOHeader Table

        string _tableName = "SOHeader";
        string _columnName = "DocumentSortInd,[CusttypeName],[OrderType],[OrderTypeDsc],[CustPoNo],SubType,[PriceCd],StatusCd," +
       "[BillToCustNo],[SellToCustNo],[SellToCustName]," +
       "[OrderDt],[ShipLoc],[ShipLocName],[UsageLoc],[UsageLocName],[CustShiploc],[OrderLoc],[OrderLocName]," +
       "[ReasonCd],[ReasonCdName],[OrderFreightCd],[OrderFreightName],[OrderPriorityCd]," +
       "[OrderPriName],[OrderExpdCd],[OrderExpdCdName],[SalesRepNo],[SalesRepName],CustSvcRepNo,CustSvcRepName," +
       "[OrderCarrier],[OrderCarName] ,[CustoType],[BranchReqDt],[CustReqDt],SchShipDt,OrderTermsCd,[OrderTermsName],[CertRequiredInd]," +
       "[BillToCustName],[BillToAddress1],[BillToAddress2],[BillToCity],[BillToState],[BillToZip],[BillToCountry],[BillToContactName],[BillToContactPhoneNo]," +
       "[SellToAddress1],[SellToAddress2],[SellToCity],[SellToState],[SellToZip],[SellToCountry],[SellToContactName],[SellToContactPhoneNo],[SellToContactID],[ShipToName],[ShipToAddress1]," +
       "[ShipToAddress2],[City],[State],[Zip],[PhoneNo],[FaxNo],[Country],[ContactName],[ContactPhoneNo],[ShipToContactID],[EntryDt],[EntryID],OrderSource";


        DateTime dtShipDate = DateTime.Today.AddDays(10);

        string orderType = ((dtCustomer.Tables[0].Rows[0]["TypeofOrder"].ToString().Trim() == "") ? "0" : dtCustomer.Tables[0].Rows[0]["TypeofOrder"].ToString().Trim());
        string carrierCd = ((dtCustomer.Tables[0].Rows[0]["Shipping Agent Code"].ToString().Trim() == "") ? "01" : ((custDet.GetTablesName(dtCustomer.Tables[0].Rows[0]["Shipping Agent Code"].ToString().Trim(), "CAR") == "") ? "01" : dtCustomer.Tables[0].Rows[0]["Shipping Agent Code"].ToString().Trim()));
        string custPONo = (orderType == "TO" ? "Transfer" : "");
        string freightCd = ((dtCustomer.Tables[0].Rows[0]["Freight Code"].ToString().Trim() == "" || custDet.GetTablesName(dtCustomer.Tables[0].Rows[0]["Freight Code"].ToString().Trim(), "FGHT") == "") ? "PPD-1500" : dtCustomer.Tables[0].Rows[0]["Freight Code"].ToString().Trim());
        string expediteCd = ((dtCustomer.Tables[0].Rows[0]["ExpediteCd"].ToString().Trim() == "") ? "AR" : dtCustomer.Tables[0].Rows[0]["ExpediteCd"].ToString().Trim());
        string priorityCd = ((dtCustomer.Tables[0].Rows[0]["Priority"].ToString().Trim() == "") ? "N" : ((custDet.GetTablesName(dtCustomer.Tables[0].Rows[0]["Priority"].ToString().Trim(), "PRI") == "") ? "N" : dtCustomer.Tables[0].Rows[0]["Priority"].ToString().Trim()));
        string reasonCd = ((dtCustomer.Tables[0].Rows[0]["ReasonCd"].ToString().Trim() == "") ? "SO" : dtCustomer.Tables[0].Rows[0]["ReasonCd"].ToString().Trim());
        string orderTermsCd = dtCustomer.Tables[0].Rows[0]["TradeTermCd"].ToString().Trim();
        DataTable dtTerm= custDet.GetTermDescription(dtCustomer.Tables[0].Rows[0]["TradeTermCd"].ToString().Trim(), "TRM");
        string orderLocID = Session["BranchID"].ToString(); 
        string orderLocName = common.GetBranchName(Session["BranchID"].ToString());
        string statusCd = (orderType == "TO" ? "''" : "NULL");      
        if (dtTerm != null)
        {
            termDesc = dtTerm.Rows[0]["Dsc"].ToString();
            colorCd = dtTerm.Rows[0]["ColorCd"].ToString().ToUpper();
        }

        string _columnValue = "'" + dtCustomer.Tables[0].Rows[0]["SODocSortInd"].ToString().Trim() + "','" + dtCustomer.Tables[0].Rows[0]["CustCd"].ToString().Trim() + "','" + orderType + "','" + custDet.GetListName(orderType, "SOEOrderTypes") + "'," +
                                "'" + custPONo + "'," +
                                "'" + custDet.GetSubType(orderType, "SOEOrderTypes") + "'," +
                                "'" + dtCustomer.Tables[0].Rows[0]["Customer Price Code"].ToString().Trim() + "'," + statusCd + "," +                                
                                "'" + dtCustomer.Tables[0].Rows[0]["fBillToNo"].ToString().Trim() + "'," +
                                "'" + dtCustomer.Tables[0].Rows[0]["No_"].ToString().Trim() + "'," +
                                "'" + dtCustomer.Tables[0].Rows[0]["Name"].ToString().Trim().Replace("'","''") + "'," +
                                "'" + DateTime.Now.ToString() + "'," +
                                "'" + dtCustomer.Tables[0].Rows[0]["Shipping Location"].ToString().Trim() + "'," +
                                "'" + custDet.GetLocationName(dtCustomer.Tables[0].Rows[0]["CustLocation"].ToString().Trim()) + "'," +
                                "'" + ((dtCustomer.Tables[0].Rows[0]["Usage Location"].ToString().Trim() == "") ? dtCustomer.Tables[0].Rows[0]["Shipping Location"].ToString().Trim() : dtCustomer.Tables[0].Rows[0]["Usage Location"].ToString().Trim()) + "'," +
                                "'" + ((dtCustomer.Tables[0].Rows[0]["Usage Location"].ToString().Trim() == "") ? custDet.GetLocationName(dtCustomer.Tables[0].Rows[0]["Shipping Location"].ToString().Trim()) : custDet.GetLocationName(dtCustomer.Tables[0].Rows[0]["Usage Location"].ToString().Trim())) + "'," +
                                "'" + dtCustomer.Tables[0].Rows[0]["CustLocation"].ToString().Trim() + "'," + // Branch id the customer belongs to..
                                "'" + orderLocID + "','" + orderLocName + "'," + // PFC Branch from which the rep is creating the order...
                                "'" + reasonCd + "'," +
                                "'" + custDet.GetTablesName(reasonCd, "REAS") + "'," +
                                "'" + freightCd.Trim() + "'," +
                                "'" + custDet.GetTablesName(freightCd.Trim(), "FGHT") + "'," +
                                "'" + priorityCd + "'," +
                                "'" + custDet.GetTablesName(priorityCd.Trim(), "PRI") + "'," +
                                "'" + expediteCd + "'," +
                                "'" + custDet.GetTablesName(expediteCd, "EXPD") + "'," +
                                "'" + dtCustomer.Tables[0].Rows[0]["Salesperson Code"].ToString().Trim() + "'," +
                                 "'" + dtCustomer.Tables[0].Rows[0]["RepName"].ToString().Trim() + "'," +
                                 "'" + dtCustomer.Tables[0].Rows[0]["SupportRepNo"].ToString().Trim() + "'," +
                                 "'" + dtCustomer.Tables[0].Rows[0]["SupportRepName"].ToString().Trim().Replace("'", "''") + "'," +
                                 "'" + carrierCd + "'," +
                                 "'" + custDet.GetTablesName(carrierCd.Trim(), "CAR") + "'," +
                                 "'" + dtCustomer.Tables[0].Rows[0]["CustCd"].ToString().Trim() + "'," +
                                "'" + DateTime.Now.ToString() + "'," +
                                "'" + DateTime.Now.AddDays(1).ToString() + "'," +
                                "'" + DateTime.Now.ToString() + "'," +
                                "'" + orderTermsCd + "',"+
                                "'" + termDesc + "',"+
                                "'" + dtCustomer.Tables[0].Rows[0]["CertRequiredInd"].ToString().Trim() + "'";
        
        
        string billtodetail = "";
        if (dtCustomer.Tables[2].Rows.Count > 0)
        {
            //[BillToCustName],[BillToAddress1],[BillToAddress2],[BillToAddress3],[BillToCity],[BillToState],[BillToZip],[BillToCountry],[BillToContactName],[BillToContactPhoneNo]" +
            billtodetail = ",'" + dtCustomer.Tables[2].Rows[0]["Name"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[2].Rows[0]["Address"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[2].Rows[0]["Address 2"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[2].Rows[0]["City"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[2].Rows[0]["State"].ToString().Trim() + "','" +
                                dtCustomer.Tables[2].Rows[0]["Post Code"].ToString().Trim() + "','" +
                                dtCustomer.Tables[2].Rows[0]["Country"].ToString().Trim() + "','" +
                                dtCustomer.Tables[2].Rows[0]["Contact"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[2].Rows[0]["CPhone"].ToString().Trim() + "'";
        }
        else
        {
            billtodetail = ",'','','','','','','','',''";
        }
        string selltodetail = "";
        if (dtCustomer.Tables[1].Rows.Count > 0)
        {
            //[BillToCustName],[BillToAddress1],[BillToAddress2],[BillToAddress3],[BillToCity],[BillToState],[BillToZip],[BillToCountry],[BillToContactName],[BillToContactPhoneNo]" +
            selltodetail = ",'" + dtCustomer.Tables[1].Rows[0]["Address"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[1].Rows[0]["Address 2"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[1].Rows[0]["City"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[1].Rows[0]["State"].ToString().Trim() + "','" +
                                dtCustomer.Tables[1].Rows[0]["Post Code"].ToString().Trim() + "','" +
                                 dtCustomer.Tables[1].Rows[0]["Country"].ToString().Trim() + "','" +
                                dtCustomer.Tables[1].Rows[0]["Contact"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[1].Rows[0]["CPhone"].ToString().Trim() + "','" +
                                 dtCustomer.Tables[1].Rows[0]["ContactID"].ToString().Trim() + "'";
        }
        else
        {
            selltodetail = ",'','','','','','','','',''";
        }
        string shiptodetail = "";
        if (dtCustomer.Tables[3].Rows.Count > 0)
        {
            //[City],[State],[Zip],[PhoneNo],[FaxNo],[Country],[ContactName],[ContactPhoneNo]
            shiptodetail = ",'" + dtCustomer.Tables[3].Rows[0]["Name"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[3].Rows[0]["Address"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[3].Rows[0]["Address 2"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[3].Rows[0]["City"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[3].Rows[0]["State"].ToString().Trim() + "','" +
                                dtCustomer.Tables[3].Rows[0]["Post Code"].ToString().Trim() + "','" +
                                dtCustomer.Tables[3].Rows[0]["Phone No_"].ToString().Trim() + "','" +
                                dtCustomer.Tables[3].Rows[0]["Fax No_"].ToString().Trim() + "','" +
                                dtCustomer.Tables[3].Rows[0]["Country"].ToString().Trim() + "','" +
                                dtCustomer.Tables[3].Rows[0]["Contact"].ToString().Trim().Replace("'", "''") + "','" +
                                dtCustomer.Tables[3].Rows[0]["CPhone"].ToString().Trim() + "','" +
                                dtCustomer.Tables[3].Rows[0]["ContactID"].ToString().Trim() + "'";
        }
        else
        {
            shiptodetail = ",'','','','','','','','','','','',''";
        }
        _columnValue = _columnValue + billtodetail + selltodetail + shiptodetail + ",'" + DateTime.Now.ToString() + "','" +
            Session["UserName"].ToString() + "','MO'";
        txtSONumber.Text = orderEntry.GetIdentityAfterInsert(_tableName, _columnName, _columnValue);

        SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "pSOEGetStdComm",
                                            new SqlParameter("@orderID", txtSONumber.Text),
                                            new SqlParameter("@custNo", txtCustNo.Text));

        SOOrderID = txtSONumber.Text;
        Session["OrderTableName"] = "SOHeader";
        Session["DetailTableName"] = "SODetail";
     
        //Lock
        orderEntry.ReleaseLock();
        orderEntry.SetLock(SOOrderID);
        
        orderEntry.UpdateQuote("SoHeader", "fSOHeaderID=" + txtSONumber.Text + ",OrderNo=" + txtSONumber.Text, "pSoHeaderId=" + txtSONumber.Text);
        //orderEntry.UpdateQuote("SoHeader", "fSOHeaderID=" + txtSONumber.Text + ",OrderNo=" + txtSONumber.Text + ",SubType=50", "pSoHeaderId=" + txtSONumber.Text);
                
        Session["LineItemNumber"] = "0";
        DataSet dsHeader = orderEntry.ExecuteERPSelectQuery("SOHeader", " * ", "pSOHeaderID=" + txtSONumber.Text.Trim());
        Session["HeaderDetail"] = dsHeader.Tables[0];
        #endregion

        ScriptManager.RegisterClientScriptBlock(txtSONumber, typeof(TextBox), "", "document.getElementById('" + txtSONumber.ClientID + "').focus();", true);

    }

    public void LoadHeaderValue()
    {
        if (hidSOFindSOid.Value != "")
        {
            txtSONumber.Text = hidSOFindSOid.Value;
            hidSOFindSOid.Value = "";
        }

        orderEntry.SetLock(txtSONumber.Text.Trim().ToUpper().Replace("W",""));
        // string whereClause = HeaderIDColumn + "=" + SOOrderID;
        string whereClause = "OrderNo=" + txtSONumber.Text.Trim().ToUpper().Replace("W", "");
        hidTableName.Value = Session["OrderTableName"].ToString();
        DataSet dsHeader = orderEntry.ExecuteERPSelectQuery(Session["OrderTableName"].ToString(), " * ", whereClause);
        Session["HeaderDetail"] = dsHeader.Tables[0];
        Session["PromotionCd"] = dsHeader.Tables[0].Rows[0]["PromotionCd"].ToString().Trim();
        txtSONumber.Text = dsHeader.Tables[0].Rows[0]["OrderNo"].ToString().Trim() + ((Session["OrderTableName"].ToString() == "SOHeaderRel") ? "W" : "");

        SOOrderID = dsHeader.Tables[0].Rows[0][0].ToString();

        // Fill the header details  in the table
        Session["CustomerNumber"] = lblCusNum.Text = lblCustNum.Text = txtCustNo.Text = hidCust.Value = dsHeader.Tables[0].Rows[0]["SellToCustNo"].ToString().Trim();
        CustomerName = dsHeader.Tables[0].Rows[0]["SellToCustName"].ToString().Trim();
        lblSold_Name.Text = dsHeader.Tables[0].Rows[0]["SellToCustName"].ToString().Trim();
        lblSoldTo_Address.Text = dsHeader.Tables[0].Rows[0]["SellToAddress1"].ToString().Trim();
        lblSold_Address2.Text = dsHeader.Tables[0].Rows[0]["SellToAddress2"].ToString().Trim();
        lblSold_City.Text = dsHeader.Tables[0].Rows[0]["SellToCity"].ToString().Trim();
        lblSold_Territory.Text = dsHeader.Tables[0].Rows[0]["SellToState"].ToString().Trim();
        HttpContext.Current.Session["CustomerCity"] = lblSold_City.Text;
        HttpContext.Current.Session["CustomerState"] = lblSold_Territory.Text;
        lblSold_Phone.Text = utils.FormatPhoneNumber(dsHeader.Tables[0].Rows[0]["SellToContactPhoneNo"].ToString().Trim());
        lblSold_Pincode.Text = dsHeader.Tables[0].Rows[0]["SellToZip"].ToString().Trim();
        lblSoldCountry.Text = dsHeader.Tables[0].Rows[0]["SellToCountry"].ToString().Trim();
        lblCustNum.Text = dsHeader.Tables[0].Rows[0]["SellToCustNo"].ToString().Trim();
        lblSoldCom.Visible = ((lblSold_City.Text.Trim() != "" && lblSold_Territory.Text.Trim() != "") ? true : false);
        
        //lblChainValue.Text = dsHeader.Tables[0].Rows[0]["Chain"].ToString().Trim();
        lblSoDate.Text = (dsHeader.Tables[0].Rows[0]["OrderDt"].ToString().Trim()!= "" ? Convert.ToDateTime(dsHeader.Tables[0].Rows[0]["OrderDt"].ToString().Trim()).ToShortDateString() : "");
        SetChainName(txtCustNo.Text);

        lblShip_Name.Text = dsHeader.Tables[0].Rows[0]["ShipToName"].ToString().Trim();
        lblShip_Address.Text = dsHeader.Tables[0].Rows[0]["ShipToAddress1"].ToString().Trim();
        lblShip_Address2.Text = dsHeader.Tables[0].Rows[0]["ShipToAddress2"].ToString().Trim();
        lblShip_City.Text = dsHeader.Tables[0].Rows[0]["City"].ToString().Trim();
        lblShip_Territory.Text = dsHeader.Tables[0].Rows[0]["State"].ToString().Trim();
        lblShip_Phone.Text = utils.FormatPhoneNumber(dsHeader.Tables[0].Rows[0]["PhoneNo"].ToString().Trim());
        lblShip_Pincode.Text = dsHeader.Tables[0].Rows[0]["Zip"].ToString().Trim();
        lblShipCountry.Text = dsHeader.Tables[0].Rows[0]["Country"].ToString().Trim();
        lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_Territory.Text.Trim() != "") ? true : false);

        lblBill_To.Text = dsHeader.Tables[0].Rows[0]["BillToCustName"].ToString().Trim();
        lblBillCustNo.Text = dsHeader.Tables[0].Rows[0]["BillToCustNo"].ToString().Trim();
        lblOrderContact.Text = dsHeader.Tables[0].Rows[0]["SellToContactName"].ToString().Trim();
        lblTermDesc.Text = dsHeader.Tables[0].Rows[0]["OrderTermsName"].ToString().Trim();
        string script = "var popUp=window.open (\"CASReport.aspx?CustNo=" + Session["CustomerNumber"].ToString() + "\",\"Maximize\",'height=505,width=705,scrollbars=no,status=no,top='+((screen.height/2) - (460/2))+',left='+((screen.width/2) - (705/2))+',resizable=NO','');"+
        "popUp.focus();";
        lblTermDesc.Attributes.Add("onclick", script);

        DataTable dtTerm = custDet.GetTermDescription(dsHeader.Tables[0].Rows[0]["OrderTermsCd"].ToString().Trim(), "TRM");
        if (dtTerm != null)      
            colorCd = dtTerm.Rows[0]["ColorCd"].ToString().ToUpper();
        SetTermColor();      
        txtCustNo.ReadOnly = true;

        if (dsHeader.Tables[0].Rows[0]["OrderSource"].ToString().ToUpper() == "WQ" ||
            dsHeader.Tables[0].Rows[0]["OrderSource"].ToString().ToUpper() == "DC" ||
            dsHeader.Tables[0].Rows[0]["OrderSource"].ToString().ToUpper() == "IX" )
        {
            lnkeComm.Visible = true;
            lbleCommContactName.Text = dsHeader.Tables[0].Rows[0]["SellToContactName"].ToString().Trim();
            lbleCommContactPhone.Text = (dsHeader.Tables[0].Rows[0]["SellToContactPhoneNo"].ToString().Trim() != "" ? utils.FormatPhoneNumber(dsHeader.Tables[0].Rows[0]["SellToContactPhoneNo"].ToString().Trim()) : "N/A");
            lbleCommContactEmail.Text = (dsHeader.Tables[0].Rows[0]["SellToContactEmail"].ToString().Trim() != "" ? dsHeader.Tables[0].Rows[0]["SellToContactEmail"].ToString().Trim() : "N/A");
        }
        else
        {
            lnkeComm.Visible = false;
        }
        pnlCustomer.Update();
    }
    private void SetTermColor()
    {
        if (colorCd.Trim() == "R")
            lblTermDesc.ForeColor = System.Drawing.Color.Red;
        else if (colorCd.Trim() == "Y")
            lblTermDesc.ForeColor = System.Drawing.Color.Yellow;
        else if (colorCd.Trim() == "G")
            lblTermDesc.ForeColor = System.Drawing.Color.Green; 

    }

    public void SetChainName(string customerNo)
    {

        try
        {
            DataSet dsHeader = orderEntry.ExecuteERPSelectQuery("CustomerMaster", "ChainCd,CustName,PriceCd,CreditInd", "CustNo='" + customerNo + "'");
            if (dsHeader != null)
            {
                CustPriceCode = dsHeader.Tables[0].Rows[0]["PriceCd"].ToString().Trim();
                CustomerName = dsHeader.Tables[0].Rows[0]["CustName"].ToString().Trim();
                lblChainValue.Text = dsHeader.Tables[0].Rows[0]["ChainCd"].ToString().Trim();
                CreditInd = dsHeader.Tables[0].Rows[0]["CreditInd"].ToString().Trim();
            }
        }
        catch (Exception ex)
        {

        }
    } 
    #endregion

    #region Customer Validation
    public string cntCustName(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    public string cntCustNo(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = "[CustNo] Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    public bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
    {
        Double result;
        return Double.TryParse(val, NumberStyle,
            System.Globalization.CultureInfo.CurrentCulture, out result);
    }
    #endregion

    #region Clear Session variable
    private void ClearSessionVariable()
    {
        Session["CustomerNumber"] = null;
        Session["OrderNumber"] = null;
        Session["ShipLocation"] = null;
        Session["CustPriceCode"] = null;
        Session["CustomerName"] = null;
        Session["CustomerDetail"] = null;
        Session["ShipDetails"] = null;
        Session["OrderTableName"] = null;
        Session["DetailTableName"] = null;
        Session["ShipFrom"] = null;
        SOOrderID = null;
    } 
    #endregion
}
