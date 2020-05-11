using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    public enum CustomerType
    {
        BT,
        BTST,
        ST
    }

    /// <summary>
    /// Summary description for CustomerMaintenance
    /// </summary>
    public class CustomerMaintenance
    {
        public CustomerMaintenance()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";
        private string spName = string.Empty;
        string _TaxExemptTable = "TaxExempt";

        string customerTable = "CustomerMaster";
        string custAddressTable = "CustomerAddress";

        string customerColumns = "[pCustMstrID],[CustNo],[CustName],[AltCustName],[SortName],[CustSearchKey],[CustSlsRank],[ShipLocation],[fBillToNo],[ARGLAcctID],[CustType],[ContractNo],[DunsNo],[DunsRating],[Territory],[SalesTerritory],[CustReg],[SalesOrgNo],[SlsRepNo],[SupportRepNo],[ResaleNo],[UPSNo],[TaxStat],[CreditInd],[SummBillInd],[CycBillInd],[DunInd],[BackOrderInd],[CreditAppInd],[CreditRvwInd],[NetPriceInd],[NextPriceInd],[AllowSubsInd],[AllowPartialsInd],[AllowDelProofInd],[AllowPTLInd],[ASNInd],[DelinqInd],[ChgBackInd],[NickelSurChrgInd],[PORequiredInd],[CertRequiredInd],[EDI870Ind],[ResidentialDeliveryInd],[FinChrgInd],[StmtCopies],[InvCopies],[CashStatus],[InvSortOrd],[TaxCd],[CustCd],[ReasonCd],[CLTradeCd],[PriorityCd],[ExpediteCd],[ShipMethCd],[ShipViaCd],[ShipTermsCd],[TradeTermCd],[ConsMethCd],[DateCdLimit],[SerialNoCd],[MultiTaxCd],[CashDiscCd],[GLPostCd],[DiscTypeCd],[BuyGroup],[RebateGroup],[SIC],[LOB],[Rebate],[InvInstr],[InvDeliveryInd],[ShipInstr],[TransferLocation],[CreditLmt],[FirstActivityDt],[CreditRvwDT],[SoldSinceDt],[WriteOffDt],[DeleteDt],[LateChrgPct],[ContractSchd1],[ContractSchd2],[ContractSchd3],[ContractSchedule4],[ContractSchedule5],[ContractSchedule6],[ContractSchedule7],[CustomerDefaultPrice],[CustomerPriceInd],[WebDiscountPct],[WebDiscountInd],[IRSEINNo],[SODocSortInd],[MinBillAmt],[SvcChrgMo],[ZeroBalMo],[SpecialLbl],[ASNFormat],[TypeofOrder],[EntryID],[EntryDt],[ChangeID],[ChangeDt],[StatusCd],[ABCCd],[ChainCd],[PriceCd],[CustShipLocation],[UsageLocation],[PackSlipRequired]";
        string CustomerAddressColumns = "CustNo,CustName,[pCustomerAddressID],[Type],[fCustomerMasterID],[Name1],[Name2],[AddrLine1],[AddrLine2],[AddrLine3],[AddrLine4],[AddrLine5],[City],[State],[PostCd],[Country],[PhoneNo],[CustContacts],[fCustContactsID],[UPSZone],[FaxPhoneNo],[EDIPhoneNo],[UPSShipperNo],[Email],CustomerAddress.[EntryID],CustomerAddress.[EntryDt],CustomerAddress.[ChangeID],CustomerAddress.[ChangeDt],CustomerAddress.[StatusCd],[LocationName],CustomerMaster.[EntryID] as CustMasterEntryID,CustomerMaster.[EntryDt] as CustMasterEntryDt,CustomerMaster.[ChangeID] as CustMasterChangeID,CustomerMaster.[ChangeDt] as CustMasterChangeDt";


        string contactColumn = "[fCustAddrID],CustNo,ContactType,ContactCd,[Name],[JobTitle],[Phone],[PhoneExt],[FaxNo],[MobilePhone],[EmailAddr],[Department],[EntryID],[EntryDt]";
        string contactTable = "CustomerContact";
        //For Security Code
        string securityTable = "SecurityGroups  (NOLOCK) SG,dbo.SecurityMembers  (NOLOCK) SM, dbo.SecurityUsers  (NOLOCK) SU";

        //ConnectionString
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        string updateSP = "pSOEUpdate";      

        public string UpdateMessage
        {
            get { return "Data has been successfully updated"; }
        }
        public string AddMessage
        {
            get { return "Data has been successfully added"; }
        }
        public string DeleteMessage
        {
            get { return "Data has been successfully deleted"; }
        }

        public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();

                    if (lstControl.ID == "ddlPlating" || lstControl.ID == "ddlPackage")
                        if (lstControl.Items.Count == 1)
                            lstControl.Items.Insert(0, new ListItem("-- Select All --", ""));


                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("N/A", ""));
                    }

                }
            }
            catch (Exception ex) { }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="lstControl"></param>
        /// <param name="textField"></param>
        /// <param name="valueField"></param>
        /// <param name="dtSource"></param>
        public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource, string defaultValue)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();
                    lstControl.Items.Insert(0, new ListItem(defaultValue, ""));
                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("N/A", ""));
                    }

                }
            }
            catch (Exception ex) { }
        }

        /// <summary>
        /// Set the selected values in List Controls
        /// </summary>
        /// <param name="control"></param>
        /// <param name="selectedValues"></param>
        public void SetSelectedValuesInListControl(
            ListControl listControl,
            string selectedValues)
        {

            try
            {
                if (listControl.GetType().Name == "ListBox")
                {
                    ListBox listBox = listControl as ListBox;
                    if (listBox.SelectionMode == ListSelectionMode.Single && listControl.SelectedIndex != -1)
                        throw (new Exception());
                }
                if ((listControl.GetType().Name == "DropDownList" || listControl.GetType().Name == "AutoFillCombo") && listControl.SelectedIndex != -1)
                {
                    listControl.SelectedIndex = -1;
                }

                if (selectedValues.Split('~').Length == 1)
                {
                    SetSelectedItems(listControl, selectedValues);
                }
                else
                {
                    string[] valuesList = selectedValues.Split('~');
                    for (int i = 0; i < valuesList.Length; i++)
                    {
                        SetSelectedItems(listControl, valuesList[i]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private void SetSelectedItems(
            ListControl listControl,
            string value)
        {
            try
            {
                ListItemCollection itemCollection = listControl.Items;

                foreach (ListItem item in itemCollection)
                {
                    if (item.Value.Trim().ToLower() == value.Trim().ToLower())
                    {
                        item.Selected = true;
                        break;
                    }
                    else if (listControl.GetType().FullName == "System.Web.UI.WebControls.RadioButtonList" && value.Trim() == "0")
                    {
                        listControl.Items[0].Selected = false;
                        listControl.Items[1].Selected = true;
                    }
                    else if (listControl.GetType().FullName == "System.Web.UI.WebControls.RadioButtonList" && value.Trim() == "1")
                    {
                        listControl.Items[0].Selected = true;
                        listControl.Items[1].Selected = false;
                    }


                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
            }
        }

        public DataTable GetCustomerAddress(string customerNo)
        {

            DataSet dsContact = GetDataToDateset("CustomerAddress  (NOLOCK) , CustomerMaster (NOLOCK) ", CustomerAddressColumns, "CustomerAddress.fCustomerMasterID=customermaster.pCustMstrID and customermaster.custno ='" + customerNo + "' and CustomerAddress.[Type]<>'SHP' and CustomerAddress.[Type]<>'DSHP'");
            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                return dsContact.Tables[0];
            else
                return null;
        }

        public DataTable GetCustomerSoldToAddress(string customerNo)
        {

            DataSet dsContact = GetDataToDateset("CustomerAddress (NOLOCK) , CustomerMaster (NOLOCK) ", CustomerAddressColumns, " CustomerMaster.pCustMstrID = CustomerAddress.fCustomerMasterID and (Type='P') And fCustomerMasterID in (select pCustMstrID from customerMaster where (fbilltoNo=" + customerNo + " And CustCd='ST') or (fbilltoNo ='" + customerNo + "' and custno='" + customerNo + "' And CustCd='BTST'))");
            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                return dsContact.Tables[0];
            else
                return null;
        }

        public DataTable GetCustomerShipToAddress(string addressID)
        {

            DataSet dsContact = GetDataToDateset("CustomerAddress (NOLOCK) ", " [pCustomerAddressID],[Type],[fCustomerMasterID],[Name1],[Name2],[AddrLine1],[AddrLine2],[AddrLine3],[AddrLine4],[AddrLine5],[City],[State],[PostCd],[Country],[PhoneNo],[CustContacts],[fCustContactsID],[UPSZone],[FaxPhoneNo],[EDIPhoneNo],[UPSShipperNo],[Email],[EntryID],[EntryDt],[ChangeID],[ChangeDt],[StatusCd],[LocationName]", "pCustomerAddressID='" + addressID + "'");
            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                return dsContact.Tables[0];
            else
                return null;
        }

        public DataTable GetListDetails(string listName)
        {
            try
            {
                _tableName = "ListMaster  (NOLOCK) LM ,ListDetail  (NOLOCK) LD";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = '" + listName + "' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }
         
        public DataTable GetCarrierDetails()
        {
            try
            {
                _tableName = "[CarrierMaster] (NOLOCK) ";
                _columnName = "Code as  ListValue,Code +' - '+ ShortDsc as ListDesc";
                _whereClause = " 1=1 order by Code asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetChainDetails()
        {
            try
            {
                _tableName = "[CustomerChainMaster] (NOLOCK) ";
                _columnName = "ChainCd as  ListValue,ChainCd +' - '+ ChainName as ListDesc";
                _whereClause = " 1=1 order by ChainCd asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetTableValues(string tblType)
        {
            try
            {
                _tableName = "[Tables] (NOLOCK) ";
                _columnName = "TableCd as  ListValue,ShortDsc as ListDesc";
                _whereClause = " TableType='" + tblType + "' order by TableCd asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetLocationList()
        {
            try
            {
                _tableName = "[LocMaster] (NOLOCK) ";
                _columnName = "convert(varchar(10),LOCid) +' - ' + LocName as ListDesc,rtrim(LOCid) as ListValue";
                _whereClause = "MaintainIMQtyInd='Y' order by LOCid asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetSalesRep()
        {
            try
            {
                _tableName = "[RepMaster] (NOLOCK) ";
                _columnName = "RepNo +' - ' + RepName as ListDesc,rtrim(RepNo) as ListValue";
                _whereClause = " 1=1 order by RepNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void SetValueListControl(DropDownList ddlControl, string value)
        {
            ListItem lItem = ddlControl.Items.FindByValue(value.Trim()) as ListItem;
            if (lItem != null)
                ddlControl.SelectedValue = value.Trim();
        }

        #region Contact Detail

        public DataSet GetContactDetails(string custAddressID)
        {
            DataSet dsContact = GetDataToDateset(contactTable + " (NOLOCK) ", contactColumn + ",pCustContactsID", "fCustAddrID=" + custAddressID + " And isnull(DeleteDt,'')=''");
            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                return dsContact;
            else
                return null;
        }

        public DataSet GetContactContact(string contactID)
        {
            DataSet dsContact = GetDataToDateset(contactTable + " (NOLOCK) ", contactColumn, "pCustContactsID=" + contactID);
            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                return dsContact;
            else
                return null;
        }

        #endregion

        /// <summary>
        /// Get the table values from the database
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <param name="whereClause"></param>
        /// <returns></returns>
        public DataTable GetCustomerDetail(string customerID)
        {
            try
            {
                string whereClause = "[pCustMstrID]="+customerID;
                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", customerTable + " (NOLOCK) "),
                    new SqlParameter("@columnNames", customerColumns),
                    new SqlParameter("@whereClause", whereClause));

                if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    return dsDetails.Tables[0];
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }

        /// <summary>
        /// Get the table values from the database
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <param name="whereClause"></param>
        /// <returns></returns>
        public bool CheckCustomer(string customerNo)
        {
            try
            {
                string whereClause = "[custno]='" + customerNo + "'";
                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", customerTable + " (NOLOCK) "),
                    new SqlParameter("@columnNames", customerColumns),
                    new SqlParameter("@whereClause", whereClause));

                if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex) { return false; }
        } 

        /// <summary>
        /// Code to insert the contact detail in the table
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="ColumnName"></param>
        /// <param name="ColumnValue"></param>
        public string InsertContactDetails(string columnValue)
        {
            object objID = InsertMaintenanceDetails(contactTable, contactColumn, columnValue);

            if (objID != null)
                return objID.ToString();
            else
                return "";
        }
        public string InsertCustomerDetails(string columnName,string columnValue)
        {
            object objID = InsertMaintenanceDetails(customerTable, columnName, columnValue);

            if (objID != null)
                return objID.ToString();
            else
                return "";
        }
        public string InsertAddressDetails(string columnName, string columnValue)
        {
            object objID = InsertMaintenanceDetails(custAddressTable, columnName, columnValue);

            if (objID != null)
                return objID.ToString();
            else
                return "";
        }
        public void UpdateCustomerDetails(string columnValue, string customerID)
        {
           
                string where = "pCustMstrID='" + customerID + "'";
                SqlHelper.ExecuteNonQuery(connectionString, updateSP,
                                             new SqlParameter("@tableName", customerTable),
                                             new SqlParameter("@columnNames", columnValue),
                                             new SqlParameter("@whereClause", where));
         
        }
        public void UpdateAddressDetails(string columnValue, string where)
        {
           
               // string where = "pCustomerAddressID='" + addressID + "'";
                SqlHelper.ExecuteNonQuery(connectionString, updateSP,
                                             new SqlParameter("@tableName", custAddressTable),
                                             new SqlParameter("@columnNames", columnValue),
                                             new SqlParameter("@whereClause", where));
             
        }
        public void UpdateCustomerDetails(string tableName, string columnValue, string where)
        {
             
                SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
                                             new SqlParameter("@tableName", tableName.Trim()),
                                             new SqlParameter("@columnNames", columnValue),
                                             new SqlParameter("@whereClause", where));
             
        }
        /// <summary>
        /// Get the table values from the database
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <param name="whereClause"></param>
        /// <returns></returns>
        public DataSet GetDataToDateset(string tableName, string columnName, string whereClause)
        {
            try
            {

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    return dsDetails;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }

        #region Code to insert data in the table

        /// <summary>
        /// Code to insert the detail in the table
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="ColumnName"></param>
        /// <param name="ColumnValue"></param>
        public object InsertMaintenanceDetails(string tableName, string ColumnName, string ColumnValue)
        {
          
                object objID = SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_INSERT",
                                              new SqlParameter("@tableName", tableName),
                                              new SqlParameter("@columnNames", ColumnName),
                                              new SqlParameter("@columnValues", ColumnValue));
                return objID;
          
        }

        /// <summary>
        /// Code to insert the vendor details
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="ColumnName"></param>
        /// <param name="ColumnValue"></param>
        public string InsertCustomerAddressDetails(string columnValue)
        {

            object objID = InsertMaintenanceDetails(customerTable, customerColumns + ",ChangeID,ChangeDt,EntryID,EntryDt", columnValue);

            if (objID != null)
                return objID.ToString();
            else
                return "";
        }

      
        #endregion

        /// <summary>
        /// Code to Bind the drop down
        /// </summary>
        /// <param name="ddlCurrent"></param>
        /// <param name="dataSource"></param>
        /// <param name="textField"></param>
        /// <param name="valueField"></param>
        /// <param name="defaultText"></param>
        public void BindDropDown(DropDownList ddlCurrent, DataTable dataSource, string textField, string valueField, string defaultText)
        {
            try
            {
                if (dataSource != null && dataSource.Rows.Count > 0)
                {
                    ddlCurrent.DataSource = dataSource;
                    ddlCurrent.DataTextField = textField;
                    ddlCurrent.DataValueField = valueField;
                    ddlCurrent.DataBind();

                    // Code to add default selected item
                    ddlCurrent.Items.Insert(0, new ListItem(defaultText, ""));
                }
                else
                    // Code to add default selected item
                    ddlCurrent.Items.Add(new ListItem("N/A", ""));
            }
            catch (Exception ex) { }
        }
       
        public DataSet GetTreeviewDetails(string billtoCustNumber)
        {
            try
            {
                DataSet dsDetail = new DataSet();
                DataTable dtSold = new DataTable();
                DataTable dtShip = new DataTable();
                string columnName = "CustNo +' - '+ CustName as 'Name',CustNo,pCustMstrID";

               string whereClause = " (fbilltoNo='" + billtoCustNumber + "' And CustCd='ST') or (fbilltoNo ='" + billtoCustNumber + "' and custno='" + billtoCustNumber + "' And CustCd='BTST')";                
                //string whereClause = " (fbilltoNo=" + billtoCustNumber + " And CustCd='ST')";                
               DataSet dsSoldTo = GetDataToDateset(customerTable + " (NOLOCK) ", columnName, whereClause);

                columnName = "fCustomerMasterID,Name1 as 'Name',pCustomerAddressID";
                whereClause = "(Type='DSHP' or Type='SHP') And fCustomerMasterID in (select pCustMstrID from customerMaster where (fbilltoNo=" + billtoCustNumber + " And CustCd='ST')or (fbilltoNo ='" + billtoCustNumber + "' and custno='" + billtoCustNumber + "' And CustCd='BTST'))";
                DataSet dsShipto = GetDataToDateset(custAddressTable + " (NOLOCK) ", columnName, whereClause);

                if (dsSoldTo != null && dsSoldTo.Tables[0].Rows.Count > 0)
                {
                    dtSold = dsSoldTo.Tables[0].DefaultView.ToTable("SoldTo");

                    if (dsShipto != null && dsShipto.Tables[0].Rows.Count > 0)
                        dtShip = dsShipto.Tables[0].DefaultView.ToTable("ShipTo");

                    dsDetail.Tables.Add(dtSold);
                    dsDetail.Tables.Add(dtShip);
                }

                return dsDetail;
            }
            catch (Exception ex) { return null; }
        }        

        public DataSet GetLocationDetails(string Id)
        {
            DataSet dsLocDetails = GetDataToDateset(custAddressTable + " (NOLOCK) ", CustomerAddressColumns.Replace("CustomerAddress.", "") + ",Type,fVendMstrID,fBuyFromAddrID,WebPageAddr,TransitDays,ProdType", "pVendAddrID=" + Id);

            if (dsLocDetails != null && dsLocDetails.Tables[0].Rows.Count > 0)
                return dsLocDetails;
            else
                return null;

        }

        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {

               
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='ARCT(W)' OR  SG.groupname='CUST(W)' OR  SG.groupname='SALES (W)' OR  SG.groupname='SALES (R)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }

        /// <summary>
        /// Function to delete the contact
        /// </summary>
        /// <param name="contactID"></param>
        public void DeleteContact(string contactID)
        {
            try
            {
                UpdateCustomerDetails(contactTable, "DeleteDt='" + DateTime.Now.ToShortDateString() + "'", "pCustContactsID=" + contactID);
            }
            catch (Exception ex) { }
        }

        public void FillCountry(DropDownList ddlCountry)
        {
            string tabelName = "CountryMaster (NOLOCK) ";
            string columnName = "CountryCd,Name";
            string where = "1=1 order by CountryCd,Name";
            DataSet dsCountry = GetDataToDateset(tabelName, columnName, where);
            if (dsCountry != null && dsCountry.Tables[0].Rows.Count > 0)
                BindDropDown(ddlCountry, dsCountry.Tables[0], "Name", "CountryCd", "--- Select Country ---");
            else
            {
                ddlCountry.Items.Insert(0, new ListItem("---N/A---", ""));
            }
        }

        public DataTable CustomerLock(string lockcustomer, string customerID)
        {
            try
            {
                string currentApplication = "CM";
                DataSet dsLock = SqlHelper.ExecuteDataset(connectionString, "pSoftLock",
                                              new SqlParameter("@resource", customerTable),
                                              new SqlParameter("@function", lockcustomer),
                                              new SqlParameter("@key", customerID),
                                              new SqlParameter("@uid", HttpContext.Current.Session["UserName"].ToString()),
                                              new SqlParameter("@curApplication", currentApplication)
                                              );

                if (dsLock != null && dsLock.Tables[0].Rows.Count > 0)
                    return dsLock.Tables[0];
                else
                    return null;

            }
            catch (Exception ex) { return null; }
        }

        /// <summary>
        /// Set the lock for the vendor
        /// </summary>
        /// <param name="idVendor"></param>
        public void SetLock(string customerID)
        {
            try
            {
                DataTable dtLock = new DataTable();
                HttpContext.Current.Session["Customer"] = customerID;
                dtLock = CustomerLock("Lock", HttpContext.Current.Session["Customer"].ToString());
                HttpContext.Current.Session["CustomerLock"] = dtLock.Rows[0][1].ToString().Trim();
            }
            catch (Exception ex)
            {
                HttpContext.Current.Session["CustomerLock"] = null;
                HttpContext.Current.Session["Customer"] = null;
            }
            finally {
            }
        }

        /// <summary>
        /// Function to release the vendor lock
        /// </summary>
        public void ReleaseLock()
        {
            try
            {
                if (HttpContext.Current.Session["CustomerLock"] != null && HttpContext.Current.Session["CustomerLock"].ToString().Trim() != "")                   
                        CustomerLock("Release", HttpContext.Current.Session["Customer"].ToString());
            }
            catch (Exception ex) { }
            finally
            {
                HttpContext.Current.Session["CustomerLock"] = null;
                HttpContext.Current.Session["Customer"] = null;
            }
        }

        public int GetSQLWarningRowCount()
        {
            int locName = (int)SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_Select",
                                                  new SqlParameter("@tableName", "SystemMaster (NOLOCK) "),
                                                  new SqlParameter("@columnNames", "SQLRowWarn"),
                                                  new SqlParameter("@whereClause", "SystemMasterID='0'"));
            return locName;
        }

        public string FormatPhoneFax(string formatString)
        {
            try
            {
                string formatNumber = formatString.Trim();
                switch (formatString.Trim().Length)
                {
                    case 10:
                        formatNumber = "(" + formatString.Substring(0, 3) + ")" + " " + formatString.Substring(3, 3) + "-" + formatString.Substring(6, 4);
                        break;
                    case 11:
                        formatNumber = formatString.Substring(0, 1) + "-" + formatString.Substring(1, 3) + "-" + formatString.Substring(4, 3) + "-" + formatString.Substring(7, 4);
                        break;
                }

                return formatNumber;
            }
            catch (Exception ex) { return formatString; }
        }

        public DataSet ExecuteERPSelectQuery(string tableName, string columnName, string whereCaluse)
        {
            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                                 new SqlParameter("@tableName", tableName),
                                                 new SqlParameter("@columnNames", columnName),
                                                 new SqlParameter("@whereClause", whereCaluse));
                return dsSelect;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        #region TaxExempt

        public DataSet SelectTaxExempt(string CustomerNumber)
        {
            try
            {
                spName = "[pSOESelectTaxExempt]";
                DataSet dsGetTaxExempt = SqlHelper.ExecuteDataset(connectionString, spName,
                                    new SqlParameter("@custNumber", CustomerNumber));

                return dsGetTaxExempt;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertTaxExempt(string _columnValue)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEInsert]",
                         new SqlParameter("@tableName", _TaxExemptTable),
                         new SqlParameter("@columnNames", "fCustMasterID, CustNo, ResaleCertNo, State, ExpirationDt,  EntryID, EntryDt"),
                         new SqlParameter("@columnValues", _columnValue));
            }
            catch (Exception ex)
            {

            }
        }

        public void UpdateTaxExempt(string _columnValue, string _whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                         new SqlParameter("@tableName", _TaxExemptTable),
                         new SqlParameter("@columnNames", _columnValue),
                         new SqlParameter("@whereClause", _whereClause));
            }
            catch (Exception ex)
            {
            }
        }

        public void DeleteTaxExempt(string _whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEDelete]",
                         new SqlParameter("@tableName", _TaxExemptTable),
                         new SqlParameter("@whereClause", _whereClause));
            }
            catch (Exception ex)
            {
            }
        }

        public DataTable GetTaxDetail(string TaxID)
        {
            try
            {
                _whereClause = "[pTaxExemptID]= " + TaxID;
                DataSet dsTaxDetail = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _TaxExemptTable + " (NOLOCK) "),
                                    new SqlParameter("@columnNames", "fCustMasterID, CustNo, ResaleCertNo, State, ExpirationDt,EntryID, EntryDt,ChangeID, ChangeDt"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsTaxDetail.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }

        public DataTable GetStates()
        {
            try
            {
                _tableName = "ListMaster  (NOLOCK) LM ,ListDetail  (NOLOCK) LD";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'FiftyStates' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// Function to update the new quote
        /// </summary>
        /// <param name="strTableName"></param>
        /// <param name="strColumnValue"></param>
        /// <param name="strWhere"></param>
        public DataSet GetCustomerSelect(string customer)
        {
            try
            {
                DataSet dsCustomer = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetCustSel]",
                                                 new SqlParameter("@customer", customer));
                return dsCustomer;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion

        #region Notes


        public DataTable GetNotesType()
        {
            try
            {
                _tableName = "ListMaster (NOLOCK) LM ,ListDetail (NOLOCK) LD";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'CustomerNotesType' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable SelectNotes(string Notestype, string CustNo)
        {
            try
            {
                //                SELECT     pCustomerNotesID, fCustomerMasterID, CustomerNo, Type, Notes, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, Type AS Expr1
                //FROM         CustomerNotes

                _tableName = "CustomerNotes (NOLOCK) ";
                _columnName = "CONVERT(varchar(10), EntryDt, 101) AS EntryDt ,Notes,EntryID ";
                _whereClause = "Type= '" + Notestype + "' And CustomerNo = '" + CustNo + "' order by EntryDt desc,  pCustomerNotesID desc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertCustNotes(string _columnValue)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEInsert]",
                         new SqlParameter("@tableName", "CustomerNotes"),
                         new SqlParameter("@columnNames", "fCustomerMasterID, CustomerNo, Type, Notes, EntryID, EntryDt"),
                         new SqlParameter("@columnValues", _columnValue));
            }
            catch (Exception ex)
            {

            }
        }


        #endregion
    }
}
