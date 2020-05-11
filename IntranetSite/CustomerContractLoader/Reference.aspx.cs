using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class Reference : System.Web.UI.Page
{ 
    #region Variable Declarations
    //SqlConnection PFCERPConnectionString; 
    //string PFCQuoteconnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"];  
 
    //SqlConnection ReportsConnectionString; 
    //string PFCQuoteconnectionString = System.Configuration.ConfigurationManager.AppSettings["ReportsConnectionString"];

    SqlConnection PFCERPConnectionString;
    string PFCQuoteconnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"];

    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    //string custNumber = "";
    string sessionCustomerNo = "";
    string inpFile;

    DataSet dsCustPriceSched;

    DataSet ds = new DataSet();
    DataTable dtItemValidation = new DataTable();
    DataTable dtCustomerInformation = new DataTable();   
    DataTable dsRecord = new DataTable();
    DataTable dtCustPriceSched;

    ItemBuilder itembuilder = new ItemBuilder();
    MaintenanceUtility MaintUtil = new MaintenanceUtility();
    MailSystem mail = new MailSystem();
    #endregion

    #region Page_Load
    protected void Page_Load(object sender, EventArgs e) 
    {
        //ReportsConnectionString = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["ReportsConnectionString"]);
        PFCERPConnectionString = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"]);
        Ajax.Utility.RegisterTypeForAjax(typeof(Reference));
        btnVerify.Attributes.Add("OnClick", "javascript:return SubmitForm()");

        if (!IsPostBack)
        {
            GetSecurity();

            lblStatus.Text = "";
            Session["CustNo"] = Request.QueryString["CustomerNumber"];
            Session["UploadOption"] = Request.QueryString["UploadOption"];
            Session["NoItemsOnContract"] = itembuilder.GetItemCustomerPriceCount(Session["CustNo"].ToString());

            if (Request.QueryString["UserName"] != null)
            {
                Session["CustNo"] = Request.QueryString["CustomerNumber"].ToString();
                Session["UserName"] = Request.QueryString["UserName"].ToString();

                //Session["NoItemsOnContract"] = itembuilder.GetItemCustomerPriceCount(Session["CustNo"].ToString());
                string noItemsOnContract = Session["NoItemsOnContract"].ToString();
                    

                string chkDCUser = Session["UserName"].ToString().Trim();
                if (chkDCUser == "DC")
                {
                    Header1.Visible = false;
                    btnUpload.Visible = true;
                    btnCancel.Visible = true;
                    btnVerify.Visible = false;
                    btnClose.Visible = false;
                }
                else
                {
                    Header1.Visible = true;
                    btnUpload.Visible = false;
                    btnCancel.Visible = false;
                    btnVerify.Visible = true;
                    btnClose.Visible = true;
                    rdoExcel.Enabled = true;
                    rdoText.Enabled = true;
                    rdoRealTime.Enabled = true;
                    rdoBatch.Enabled = true;

                    //2010-Apr-20 - Remove "Realtime" option
                    rdoRealTime.Checked = false;
                    rdoRealTime.Enabled = false;
                    rdoRealTime.Visible = false;
                    rdoText.Checked = false;
                    rdoText.Enabled = false;
                    rdoText.Visible = false;
                    rdoBatch.Checked = true;
                    rdoExcel.Checked = true;
                }
            }

            if (rdoBatch.Checked == true)
            {
                rdoText.Checked = false;
                rdoExcel.Checked = true;
                rdoText.Enabled = false;
            }
            else
            {
                rdoText.Enabled = true;
            }

            uplXRefFile.Enabled = true;       
            
            string customerNo = Session["CustNo"].ToString();
            if (customerNo != "000000")
            {
                dtCustomerInformation = itembuilder.GetCustomerID(customerNo);
                lblCustomerName.Text = customerNo; //Session["CustNo"].ToString();
                lblnoItemsOnContract.Text = Session["NoItemsOnContract"].ToString(); 
                //lblAddress.Text = dtCustomerInformation.Rows[0]["AddrLine1"].ToString();
                //lblCity.Text = dtCustomerInformation.Rows[0]["City"].ToString();
                //lblState.Text = dtCustomerInformation.Rows[0]["State"].ToString();
                //lblPostCd.Text = dtCustomerInformation.Rows[0]["PostCd"].ToString();
            }
            else
            {
                lblCustomerName.Text = "Customer #000000";
                //lblCity.Text = "";
                //lblState.Text = "";
                //lblPostCd.Text = "";
            }
        }
    }
    #endregion

    #region Paging Links
    protected void lnkFirstPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = 0;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    protected void lnkPreviousPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = dgCrossReference.CurrentPageIndex - 1;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    protected void lnkLastPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = dgCrossReference.PageCount - 1;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    protected void lnkNextPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = dgCrossReference.CurrentPageIndex + 1;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    void EnableLinksFilter()
    {
        lnkFirsPage.Enabled = true;
        lnkLastPage.Enabled = true;
        lnlPreviousPage.Enabled = true;
        lnkNextPage.Enabled = true;

        if (dgCrossReference.CurrentPageIndex == 0)
        {
            lnkFirsPage.Enabled = false;
            lnlPreviousPage.Enabled = false;
        }

        if (dgCrossReference.CurrentPageIndex == dgCrossReference.PageCount - 1)
        {
            lnkLastPage.Enabled = false;
            lnkNextPage.Enabled = false;
        }
    }
    #endregion
    
    #region Change events
    protected void ddlFilterPage_SelectedIndexChanged(object sender, EventArgs e)
    {
        dgCrossReference.CurrentPageIndex = Convert.ToInt32(ddlFilterPage.SelectedItem.Value);
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        EnableLinksFilter();
    }

       
    
    #endregion

    #region Verify
    protected void btnVerify_Click(object sender, EventArgs e)
    {
        if (uplXRefFile.HasFile)        
            try
            {
            //if (uplXRefFile.HasFile)
            //{
                sessionCustomerNo = Session["CustNo"].ToString();
                Server.MapPath(".");
                uplXRefFile.SaveAs(@Server.MapPath(".") + "/Export/" + uplXRefFile.FileName);
                inpFile = Server.MapPath(".") + "/Export/" + uplXRefFile.FileName;

                #region Reading Excel/txt file into DataTable
                if (rdoExcel.Checked == true)
                {
                    #region Load file to DataSet
                    String strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;"
                                        + "Data Source=" + inpFile + ";"
                                        + "Extended Properties='Excel 8.0;HDR=No;IMEX=1'";                   
                    OleDbConnection connExcel = new OleDbConnection(strExcelConn);
                    OleDbCommand cmdExcel = new OleDbCommand();
                    cmdExcel.Connection = connExcel;
                    connExcel.Open();
                    DataTable dtExcelSchema;
                    dtExcelSchema = connExcel.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    connExcel.Close();
                    OleDbDataAdapter da = new OleDbDataAdapter();
                    string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                    cmdExcel.CommandText = "SELECT * From [" + SheetName + "]";
                    da.SelectCommand = cmdExcel;
                    da.Fill(ds);
                    #endregion

                    //Convert Xref column to String datatype
                    DataTable newDataTable = ds.Tables[0].Clone();
                    foreach (DataColumn dc in newDataTable.Columns)
                    {

                        //if (dc.ColumnName == "F2")
                        //{
                        //    dc.DataType = typeof(decimal);
                        //}
                        //else
                        //{
                            dc.DataType = typeof(string);
                       // }

                      // dc.DataType = typeof(string);
                    }
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        newDataTable.ImportRow(dr);
                    }

                    //If Excel contains only 2 or 3 columns then add the Whse & Desc columns
                    //if (newDataTable.Columns.Count == 2)
                    //    newDataTable.Columns.Add("STKSellPrice");

                    //if (newDataTable.Columns.Count == 3)
                    //    newDataTable.Columns.Add("PriceUM");

                    if (!newDataTable.Rows[0][0].ToString().Contains("-"))
                        newDataTable.Rows.RemoveAt(0);

                   // if (!chkPerAlt.Checked)
                    //dvBIOnhand.Columns[8].Visible = true;
                    // newDataTable.Columns[3]
                    //{
                    //    newDataTable.Columns[0].ColumnName = "Item";
                    //    newDataTable.Columns[1].ColumnName = "AltSellPrice";
                    //    newDataTable.Columns[2].ColumnName = "STKSellPrice";
                    //    newDataTable.Columns[3].ColumnName = "PriceUM";
                    //}

                    //else
                    //{
                        newDataTable.Columns[0].ColumnName = "Item";
                        newDataTable.Columns[1].ColumnName = "AltSellPrice";
                        //newDataTable.Columns[2].ColumnName = "STKSellPrice";
                        //newDataTable.Columns[3].ColumnName = "PriceUM";
                    //}
                    
                   
                    //Remove empty row from data table
                    newDataTable.DefaultView.RowFilter = "Item <> ''";
                    //newDataTable.DefaultView.RowFilter = "Item <> '',AltSellPrice= ''";

                    ds.Tables.Clear();
                    ds.Tables.Add(newDataTable.DefaultView.ToTable());                   
                }
               
                #endregion
               
                
                dgCrossReference.DataSource = ds.Tables[0].DefaultView;
                ViewState["DT"] = ds.Tables[0];
                dgCrossReference.CurrentPageIndex = 0;
                ddlFilterPage.Items.Clear();
                dgCrossReference.DataBind();

                for (int intcount = 0; intcount < dgCrossReference.PageCount; intcount++)
                {
                    ListItem LI = new ListItem();
                    LI.Value = Convert.ToString(intcount);
                    LI.Text = Convert.ToString(intcount + 1) + " of " + dgCrossReference.PageCount.ToString();
                    ddlFilterPage.Items.Add(LI);
                }

              
                EnableLinksFilter();

                btnUpload.Visible = true;
                btnCancel.Visible = true;
                btnVerify.Visible = false;
                btnClose.Visible = false;
                lblStatus.Text = "Upload File Successfully Verified";
                lblStatus.ForeColor = System.Drawing.Color.Green;
                dgCrossReference.Visible = true;
                tblPager.Visible = true;

                rdoExcel.Enabled = false;
                rdoText.Enabled = false;
                rdoRealTime.Enabled = false;
                rdoBatch.Enabled = false;
                uplXRefFile.Enabled = false;

               // dtCustPriIn = (DataTable)Session["dtCustPrice"]; 
        }
        catch (Exception ex)
        {
            //lblStatus.Text = "PFC Item # contains duplicate rows";
            lblStatus.Text = "Error Processing File";
            lblStatus.Visible = true;
            lblStatus.ForeColor = System.Drawing.Color.Red;
            tblPager.Visible = false;
            
            //Console.WriteLine(e.ToString);

            //dsCustPriceSched = GetCustPriceSched(); //Pete added
            //// dsCustPriceSched.Tables[0].DefaultView.Sort = sortExpression;
            //// hidRowCount.Value = dsCustPriceSched.Tables[0].Rows.Count.ToString();
            //dtCustPriceSched = dsCustPriceSched.Tables[0].DefaultView.ToTable();
            //Session["dtCustPrice"] = dtCustPriceSched;
            //BindDataGrid();

            return;
        }
        finally
        {
            //Once file information read to the Grid, delete the file uploaded
            FileInfo fileInfo = new FileInfo(inpFile);
            if (fileInfo.Exists)
                fileInfo.Delete();
        }
        else
            {
                lblStatus.Text = "Invalid File Path";
                lblStatus.Visible = true;
                lblStatus.ForeColor = System.Drawing.Color.Red;
                tblPager.Visible = false;
            }
        }

    #endregion


    #region DataGrid
     
    private void BindDataGrid()
    {
        dtCustPriceSched = (DataTable)Session["dtCustPrice"];      
        Session["dtCustPrice"] = dtCustPriceSched.DefaultView.ToTable();
               
    } 

    #endregion


    #region Upload
    protected void btnUpload_Click(object sender, EventArgs e)
    {
        DataTable dtInsert = (DataTable)ViewState["DT"];    //Contains excel import ItemNo, UnitSellPrice, AltSellPrice
              

        for (int i = 0; i < dtInsert.Rows.Count; i++)
        {
            string columnNames = "";
            string columnValues = "";

           // string updXRef, updUOM, updBinLoc, updClassCd, updUPC; //, updDesc,

            //decimal _altSellPrice = 0;
            //decimal updWhseNo = 0;

            //decimal _AltSellPrice = Math.Round(Convert.ToDecimal(dtInsert.Rows[0]["AltSellPrice"].ToString()), 2); // alt unit price

            //updXRef = dtInsert.Rows[i]["Item"].ToString().Trim();
            //if (updXRef.Length > 30) updXRef = updXRef.ToString().Substring(0,30);

           // updWhseNo = Convert.ToDecimal(dtInsert.Rows[i]["AltSellPrice"]).ToString();
            //updWhseNo = Convert.ToDecimal(dtInsert.Rows[i]["STKSellPrice"].ToString()).ToString();

            //if (!string.IsNullOrEmpty(dtInsert.Rows[i]["AltSellPrice"].ToString()))
              //  _altSellPrice = Convert.ToDecimal(dtInsert.Rows[i]["AltSellPrice"]);

            //if (updWhseNo.Length > 20) updWhseNo = updWhseNo.ToString().Substring(0, 20);
                  
            //if (!string.IsNullOrEmpty(txtAltPrice.Text.ToString()))
              //  altPrice = Convert.ToDecimal(txtAltPrice.Text.Replace("(", "-").Replace("$", "").Replace(",", "").Replace(")", ""));

            //updDesc = dtInsert.Rows[i]["Item"].ToString();
            //if (updDesc.Length > 50) updDesc = updDesc.ToString().Substring(0,50);

            if (dtInsert.Columns.Count == 10)
            {               
               //
            }
            else 
            {


                columnNames = "ItemNo, AltSellPrice, CustNo, PriceMethod, EntryID, EntryDt, StatusCd";      ///Left OFF Here is the error, PriceMethod,  ContractPrice,    ,  STKSellPrice,
                columnValues = "'"+ dtInsert.Rows[i]["Item"].ToString().Trim()+ "'," +
                                      //"'" + Math.Round(Convert.ToDecimal(dtInsert.Rows[0]["AltSellPrice"])) + "'," +
                                      //"'" + _AltSellPrice.ToString() + "'," + 
                                      //"'" + Math.Round(Convert.ToDecimal(dtInsert.Rows[0]["AltSellPrice"])) + "'," +
                                      "'" + dtInsert.Rows[i]["AltSellPrice"].ToString().Replace(",", "").Replace("$", "").Replace("(", "").Replace(")", "").Replace(" ", "0").Replace(")", "") + "'," +
                                      //"'" + Math.Round(Convert.ToDecimal(dtInsert.Rows[0]["STKSellPrice"])) + "'," +
                                      //"'" + (dtInsert.Rows[i]["STKSellPrice"].ToString()) + "'," +
                                      //"'" + updXRef.ToString().Replace("'", "''") + "', " +
                                      //"'" + _AltSellPrice.ToString().Replace("'", "''") + "', " +
                                      //"'" + updDesc.ToString().Replace("'", "''") + "', " +
                                      "'" + Session["CustNo"].ToString() + "', " +
                                      "'" + ddlAliasType.SelectedValue.ToString() + "', " +
                                      //"'C'," +
                                      "'" + Session["UserName"].ToString() + "', " +
                                      "'" + DateTime.Now + "'," +
                                      //"'" + uploadOption + "'";
                                      "'" + Session["UploadOption"].ToString() + "'";    
            }   

            string tableName = "";
            if (rdoBatch.Checked == true)
            {
                tableName = "[CustomerPriceQueue]";
            }
            else
            {
                tableName = "[CustomerPriceQueue]";
                //itembuilder.DeleteCrossReferenceNumber(dtInsert.Rows[i]["Item"].ToString(), Session["CustNo"].ToString()); //updXRef.ToString().Replace("'", "''"),
            }

            itembuilder.InsertCustomerContractItem(tableName, columnNames, columnValues);
        }

        ResetDisplay();

        #region Upload Email Notification
        string _mailFrom = Session["SalesPersonEmail"].ToString();
        //string _mailTo = Session["SalesPersonEmail"].ToString();
        string _mailTo = Session["SalesPersonEmail"].ToString() + "; it_ops@porteousfastener.com";
        //string _mailTo = Session["SalesPersonEmail"].ToString();
        string _mailSubj;
        string _mailBody;
        string _AliasCount = itembuilder.GetItemCustomerPriceCount(Session["CustNo"].ToString());    //GetItemCustomerPriceCount
        string _NewAliasCount = itembuilder.GetNewContractRecords(Session["CustNo"].ToString());    //GetItemCustomerPriceCount
        string _DupRecords = itembuilder.GetDupsUploadedRecords(Session["CustNo"].ToString());      //Dupps
        string _UpdtRecords = itembuilder.GetUpdatedRecords(Session["CustNo"].ToString());      //UpdatedItemCount
        string _NewUpdtRecords = itembuilder.GetNewUpdatedRecords(Session["CustNo"].ToString());      //NewUpdatedRecordsCount
        string _NewRecords = itembuilder.GetNewRecords(Session["CustNo"].ToString());      //NewRecordsCount
        string _uploadOption = Session["UploadOption"].ToString();

        if (_DupRecords == null)
            _DupRecords = "0";

        if (_UpdtRecords == null)
            _UpdtRecords = "0";

        if (_uploadOption != "U")
        {
            _NewAliasCount = dtInsert.Rows.Count.ToString();
        }
        if (_uploadOption == "U")
        {
            _NewAliasCount = itembuilder.GetNewContractRecords(Session["CustNo"].ToString());
        }

        if (_uploadOption == "U")
            _uploadOption = "Update";

        if (_uploadOption == "R")
            _uploadOption = "Replace";

        if (_uploadOption == "N")
            _uploadOption = "New Contract";

        if (rdoBatch.Checked == true)
        {
            //_mailSubj = "Pete is Testing...Customer Contract Price Upload: " + _AliasDesc + " Customer Price bulk update for Contract #" + Session["CustNo"].ToString() + " added to the nightly queue in " +
            _mailSubj = "Customer Contract Price Upload: " + " Customer Price bulk update for Contract #" + Session["CustNo"].ToString() + " added to the nightly queue in " +
                         System.Configuration.ConfigurationManager.AppSettings["Environment"].ToString();

            _mailBody = "Contract Name: <b>" + Session["CustNo"].ToString() + "</b><br>" +
                        "Submitted by: <b>" + Session["UserName"].ToString() + "</b><br>" +
                        "Existing record count: <b>" + _AliasCount + "</b><br>" +
                        "Uploaded record count: <b>" + dtInsert.Rows.Count.ToString() + "</b><br>" +
                        "Queue table: <b>CustomerPriceQueue" + "</b><br>" +
                        "Production table: <b>CustomerPrice" + "</b><br>" +
                        "Backup table: <b>CustomerPriceDeletes" + "</b><br>" +  //Outstanding need to create table
                        "Exceptions table: <b>tCustomerPriceQueueExceptions" + "</b><br>" +    //Outstanding need to create table
                        "Nightly SP: <b>pCustomerContractLoaderOvernight" + "</b><br><br>" +

                        "A Customer Contract Price update has been sent to the nightly processing queue in <b>" +
                        System.Configuration.ConfigurationManager.AppSettings["Environment"].ToString() + ".</b><br><br>" +
                        "The user selected the <b> " + _uploadOption + " Option. </b><br> " +
                        "<b>WARNING:</b> Contract Name <b>" + Session["CustNo"].ToString() + "</b> contained <b>" + _AliasCount + "</b> existing contract price records <br>" +
                        "<b>After this process, there will be a total of " + _NewAliasCount + " records on file.</b><br>";

            _mailBody = _mailBody + "The uploaded file contained";

            if (_uploadOption == "Update" && _AliasCount != "0")   //if Update do this...and _AliasCount != 0
            {
                _mailBody += " <li>" + _UpdtRecords + " record update(s)<br> " +  //FYI.._mailBody is an operator 
                             " <LI>" + _NewUpdtRecords + " new record(s) <br>";
            }

            if (_uploadOption != "Update") //if new or replace use this
            {
                _mailBody = _mailBody + " <LI>" + _NewRecords + " new record(s) <br>";
            }

            _mailBody = _mailBody + " <LI>" + _DupRecords + " distinct duplicated record(s)<br>";

            if (System.Configuration.ConfigurationManager.AppSettings["Environment"].ToString().ToUpper().Trim() == "LIVE")
            {
                _mailBody += "<br><b>This data will be processed tonight.</b><br><br>";
                             //"<b>WARNING:</b> All " + _AliasCount + " existing Contract Price records (CustomerPrice) for Contract#" + Session["CustNo"].ToString() + 
                             //" will be saved in the Backup table and then DELETED from the Production table" +
                             //" prior to being reloaded from the Queue table.  <b>After this process, only " + dtInsert.Rows.Count.ToString() + " records will be on file.</b>";
            }

            ScriptManager.RegisterClientScriptBlock(btnUpload, btnUpload.GetType(), "Insert", "alert('Batch file successfully queued for processing')", true);
        }
        else
        {
            _mailSubj = "Customer Contract: " + Session["CustNo"].ToString() + ": CustomerContract UPDATED";
            _mailBody = "Customer Contract: <b>" + Session["CustNo"].ToString() + "</b><br>";
            ScriptManager.RegisterClientScriptBlock(btnUpload, btnUpload.GetType(), "Insert", "alert('Contract Price file loaded successfully')", true);
        }

        mail.SendMail(_mailFrom, _mailTo, _mailSubj, _mailBody);
        #endregion
    }
    #endregion


    //private void CreateRelation()
    //{
    //    // Get the DataColumn objects from two DataTable objects 
    //    // in a DataSet. Code to get the DataSet not shown here.
    //    DataColumn parentColumn = dsCustPriceSched.Tables[0].Columns["Item"];
    //    DataColumn childColumn  = dsCustPriceSched.Tables[1].Columns["Item"]; //dtCustPriceSched["Sche"].Columns["ItemNo"];
    //    // Create DataRelation.
    //    DataRelation relCustOrder;
    //    relCustOrder = new DataRelation("CustomersOrders", parentColumn, childColumn);
    //    // Add the relation to the DataSet.
    //    dsCustPriceSched.Relations.Add(relCustOrder);
    //}
    

    //public DataTable JoinExcelDataWithCustPriceSched(DataTable dtExcelData, DataTable dtCustPriceSched)
    //{
    //    try
    //    {
    //        DataSet dsFinalResult = new DataSet();
    //        dtExcelData.TableName = "CustomerContract"; // Master // PFC Item No       
    //        dtCustPriceSched.TableName = "CustPriceSched";  // PFC Item No

    //        DataColumn dcCustName = new DataColumn("CustomerName", typeof(string));
    //        DataColumn dcRepNo = new DataColumn("RepNo", typeof(string));
    //        dcCustName.DefaultValue = "0";
    //        dtExcelData.Columns.Add(dcCustName); // Br
    //        dtExcelData.Columns.Add(dcRepNo); // rep no
    //        dsFinalResult.Tables.Add(dtExcelData.Copy());
    //        dsFinalResult.Tables.Add(dtCustPriceSched.Copy());

    //        DataRelation customerNumberRelation =
    //        dsFinalResult.Relations.Add("CustomerName",
    //        //new DataColumn[] { dsFinalResult.Tables["QuoteAnalysis"].Columns["customerNumber"] },
    //        //new DataColumn[] { dsFinalResult.Tables["CustomerMaster"].Columns["CustNo"] }, false);
    //        new DataColumn[] { dsFinalResult.Tables["QuoteAnalysis"].Columns["Item"] },
    //        new DataColumn[] { dsFinalResult.Tables["CustomerMaster"].Columns["ItemNo"] }, false);

    //        foreach (DataRow pfcBranchRow in dsFinalResult.Tables["QuoteAnalysis"].Rows)
    //        {
    //            foreach (DataRow CustNameRow in pfcBranchRow.GetChildRows(customerNumberRelation))
    //            {
    //                pfcBranchRow["CustomerName"] = CustNameRow["CustName"].ToString();
    //                pfcBranchRow["RepNo"] = CustNameRow["SupportRepNo"].ToString();
    //            }
    //        }

    //        return dsFinalResult.Tables[0];
    //    }
    //    catch (Exception ex)
    //    {
    //        return null;
    //    }
    //}


    #region Export
   
    protected void btnExport_Click(object sender, EventArgs e)
    {
        ResetDisplay();

        string strSQL = "SELECT CustNo as ContractName, ItemNo AS Item, AltSellPrice, ContractPrice, PriceMethod, EntryID, EntryDt, ChangeID, ChangeDt ";
        strSQL += "FROM CustomerPrice (NoLock) WHERE CustNo = '" + Session["CustNo"].ToString() + "' ";
        strSQL += "ORDER BY ItemNo ";
        string strIns = "INSERT INTO CustContLoaderWS (ContractName, Item, AltSellPrice, ContractPrice, PriceMethod, EntryID, EntryDt, ChangeID, ChangeDt)";
        DataSet dsExport = SqlHelper.ExecuteDataset(PFCERPConnectionString, CommandType.Text, strSQL);

        //char tab = '\t';

        String delFile = "CustomerContractLoader(" + Session["CustNo"].ToString() + ")" + Session["SessionID"];
        DeleteExcel(delFile);

        String xlsFile = "CustomerContractLoader(" + Session["CustNo"].ToString() + ")" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//CustomerContractLoader//Common//Excel//") + xlsFile;

        //StreamWriter swExcel = new StreamWriter(ExportFile, false);

        //swExcel.WriteLine("Item" + tab + "XRef" + tab + "AliasWhseNo" + tab + "AliasDesc" + tab + "AliasType" + tab +
        //                  "UOM" + tab + "CustBinLoc" + tab + "CustClassCd" + tab + "CustomerUPC" + tab + "OrganizationNo");

        //foreach (DataRow Row in dsExport.Tables[0].Rows)
        //    swExcel.WriteLine(Row["Item"].ToString() + tab + Row["XRef"].ToString() + tab + Row["AliasWhseNo"].ToString() + tab +
        //                      Row["AliasDesc"].ToString() + tab + Row["AliasType"].ToString() + tab + Row["UOM"].ToString() + tab +
        //                      Row["CustBinLoc"].ToString() + tab + Row["CustClassCd"].ToString() + tab + Row["CustomerUPC"].ToString() + tab + 
        //                      Row["OrganizationNo"].ToString());
        //swExcel.Close();


        ////http://support.microsoft.com/kb/316934
        OleDbConnection xlsConn = new OleDbConnection();
        xlsConn.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ExportFile + ";Extended Properties='Excel 8.0;HDR=Yes;'";
        xlsConn.Open();
        OleDbCommand xlsCreate = new OleDbCommand();
        xlsCreate.CommandText = "CREATE TABLE [CustContLoaderWS] ([ContractName] string, [Item] string, [AltSellPrice] string, [ContractPrice] string, [PriceMethod] string, [EntryID] string, [EntryDt] string, [ChangeID] string, [ChangeDt] string)";
        xlsCreate.Connection = xlsConn;
        xlsCreate.ExecuteNonQuery();

        foreach (DataRow Row in dsExport.Tables[0].Rows)
        {
            xlsCreate.CommandText = strIns + "VALUES ('" + Row["ContractName"].ToString() + "', '" +
                                                           Row["Item"].ToString().Replace("'", "''") + "', '" +
                                                          // Row["STKSellPrice"].ToString().Replace("'", "''") + "', '" +
                                                           Row["AltSellPrice"].ToString().Replace("'", "''") + "', '" +
                                                           Row["ContractPrice"].ToString().Replace("'", "''") + "', '" +
                                                           Row["PriceMethod"].ToString() + "', '" +
                                                           Row["EntryID"].ToString().Replace("'", "''") + "', '" +
                                                           Row["EntryDt"].ToString() + "','" +
                                                           Row["ChangeID"].ToString().Replace("'", "''") + "', '" +
                                                           Row["ChangeDt"].ToString() + "')"; 
            xlsCreate.ExecuteNonQuery();
        }

        xlsConn.Close();

        //Response.Redirect("ExcelExport.aspx?Filename=../ItemBuilder/Common/Excel/" + xlsFile, true);
        string URL = "ExcelExport.aspx?Filename=../CustomerContractLoader/Common/Excel/" + xlsFile;
        string script = "window.open('" + URL + "' ,'export','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	";
        ScriptManager.RegisterClientScriptBlock(btnExport, btnExport.GetType(), "export", script, true);
    }

    //[Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//CustomerContractLoader//Common//Excel//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }
    #endregion

    #region Security
    private void GetSecurity()
    {
        #region Customer Contract Loader Security
        hidXRefSec.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CustomerContractLoader);
        if (hidXRefSec.Value.ToString() == "")
            hidXRefSec.Value = "Query";
        else
            hidXRefSec.Value = "Full";

        if (hidXRefSec.Value.ToString() == "Query")
            hidXRefSec.Value = "None";

        switch (hidXRefSec.Value.ToString())
        {
            case "None":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
                break;
            case "Full":
                break;
        }
        #endregion

        
    }
    #endregion

    #region Distinct Class
    private static DataTable SelectDistinct(DataTable SourceTable, params string[] FieldNames)
    {
        object[] lastValues;
        DataTable newTable;
        DataRow[] orderedRows;

        if (FieldNames == null || FieldNames.Length == 0)
            throw new ArgumentNullException("FieldNames");

        lastValues = new object[FieldNames.Length];
        newTable = new DataTable();

        foreach (string fieldName in FieldNames)
            newTable.Columns.Add(fieldName, SourceTable.Columns[fieldName].DataType);

        orderedRows = SourceTable.Select("", string.Join(", ", FieldNames));

        foreach (DataRow row in orderedRows)
        {
            if (!fieldValuesAreEqual(lastValues, row, FieldNames))
            {
                newTable.Rows.Add(createRowClone(row, newTable.NewRow(), FieldNames));

                setLastValues(lastValues, row, FieldNames);
            }
        }

        return newTable;
    }

    private static bool fieldValuesAreEqual(object[] lastValues, DataRow currentRow, string[] fieldNames)
    {
        bool areEqual = true;

        for (int i = 0; i < fieldNames.Length; i++)
        {
            if (lastValues[i] == null || !lastValues[i].Equals(currentRow[fieldNames[i]]))
            {
                areEqual = false;
                break;
            }
        }

        return areEqual;
    }

    private static DataRow createRowClone(DataRow sourceRow, DataRow newRow, string[] fieldNames)
    {
        foreach (string field in fieldNames)
            newRow[field] = sourceRow[field];

        return newRow;
    }

    private static void setLastValues(object[] lastValues, DataRow sourceRow, string[] fieldNames)
    {
        for (int i = 0; i < fieldNames.Length; i++)
            lastValues[i] = sourceRow[fieldNames[i]];
    } 
    #endregion


    #region I/O

    //public DataSet GetCustPriceSched()  //Gets Cost data , GMPct
    //{
      
    //    DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pCustomerContractLoaderv22",
    //                                        new SqlParameter("@Mode", "Select"),
    //                                        new SqlParameter("@CustNo", sessionCustomerNo.ToString().Trim()),
    //                                        new SqlParameter("@ItemNo", null),
    //                                        new SqlParameter("@AltSellPrice", null),
    //                                        new SqlParameter("@ContractPrice", null),
    //                                        new SqlParameter("@UserName", null));
    //    return dsResult;
     
    //}


    #endregion

    protected void btnClose_Click(object sender, EventArgs e)
    {
        String delFile = "CustomerContractLoader(" + Session["CustNo"].ToString() + ")" + Session["SessionID"];
        DeleteExcel(delFile);
        ScriptManager.RegisterClientScriptBlock(btnClose, btnClose.GetType(), "close", "window.close();", true);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetDisplay();
    }

    protected void btnHelp_Click(object sender, EventArgs e)
    {
        tblPager.Visible = false;
    }

    protected void ResetDisplay()
    {
        rdoExcel.Enabled = true;
        if (rdoBatch.Checked != true) rdoText.Enabled = true;
        rdoRealTime.Enabled = true;
        rdoBatch.Enabled = true;

        //2010-Apr-20 - Remove "Realtime" option
        rdoRealTime.Checked = false;
        rdoRealTime.Enabled = false;
        rdoRealTime.Visible = false;
        rdoText.Checked = false;
        rdoText.Enabled = false;
        rdoText.Visible = false;
        rdoBatch.Checked = true;
        rdoExcel.Checked = true;

        uplXRefFile.Enabled = true;

        dgCrossReference.DataSource = null;
        dgCrossReference.DataBind();
        btnVerify.Visible = true;
        btnClose.Visible = true;
        btnUpload.Visible = false;
        btnCancel.Visible = false;
        tblPager.Visible = false;
        lblStatus.Text = "";
    }


    //public DataTable GetCustomerID(string custNo)
    //{
    //    try
    //    {
    //        _tableName = "customerMaster";
    //        _columnNames = "pcustmstrID";
    //        _whereClause = "custno='" + custNo + "'";

    //        DataSet dsCustomerID = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
    //                                               new SqlParameter("@tableName", _tableName),
    //                                               new SqlParameter("@columnNames", _columnNames),
    //                                               new SqlParameter("@whereClause", _whereClause));
    //        if (dsCustomerID.Tables[0] != null)
    //        {
    //            string custID = dsCustomerID.Tables[0].Rows[0]["pcustmstrID"].ToString();
    //            DataSet dsCustomerInfo = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
    //                                              new SqlParameter("@tableName", "customerAddress"),
    //                                              new SqlParameter("@columnNames", "Name1,PostCd,City,State,AddrLine1"),
    //                                              new SqlParameter("@whereClause", "fcustomermasterid='" + custID + "' and type not in('DSHP','SHP')"));
    //            return dsCustomerInfo.Tables[0];
    //        }
    //        return null;
    //    }
    //    catch (Exception ex)
    //    {
    //        return null;
    //    }
    //}

    //protected void CheckBox2_CheckedChanged(object sender, EventArgs e)
    //{

    //}
}
