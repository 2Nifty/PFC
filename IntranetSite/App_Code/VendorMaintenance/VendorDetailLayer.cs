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
    /// <summary>
    /// Summary description for VendorDetailLayer
    /// </summary>
    public class VendorDetailLayer
    {
        string vendorMasterTable = "VendorMaster";
        string vendorAddressTable = "VendorAddress";

        string vendorMasterColumns = "VendNo,VendorMaster.Code,Name,[1099Cd],TermsCd,FedTaxID ,CurrencyCd";
        string vendorAddressColumns = "LocationName,Line1,Line2,City,State,PostCd,Country,PhoneNo,FAXPhoneNo,Email,VendorAddress.EntryID,VendorAddress.EntryDt,VendorAddress.ChangeID,VendorAddress.ChangeDt,VendorAddress.Code";


        string contactColumn = "[fVendAddrID],[Name],[JobTitle],[Phone],[PhoneExt],[FaxNo],[MobilePhone],[EmailAddr],[Department],[EntryID],[EntryDt],[ChangeID],[ChangeDt]";
        string contactTable = "VendorContact";
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";

        //ConnectionString
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public VendorDetailLayer()
        {
            //
            // TODO: Add constructor logic here
            //
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
        public object InsertVendorMaintenanceDetails(string tableName, string ColumnName, string ColumnValue)
        {
            try
            {

                object objID = SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_INSERT",
                                              new SqlParameter("@tableName", tableName),
                                              new SqlParameter("@columnNames", ColumnName),
                                              new SqlParameter("@columnValues", ColumnValue));
                return objID;
            }
            catch (Exception ex) { return null; }
        }

        /// <summary>
        /// Code to insert the vendor details
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="ColumnName"></param>
        /// <param name="ColumnValue"></param>
        public string InsertVendorAddressDetails(string columnValue)
        {

            object objID = InsertVendorMaintenanceDetails(vendorMasterTable, vendorMasterColumns + ",ChangeID,ChangeDt,EntryID,EntryDt", columnValue);

            if (objID != null)
                return objID.ToString();
            else
                return "";
        }

        /// <summary>
        /// Code to insert the pay to details in the table
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="ColumnName"></param>
        /// <param name="ColumnValue"></param>
        public string InsertPayToDetails(string columnValue)
        {
            object objID = InsertVendorMaintenanceDetails(vendorAddressTable, vendorAddressColumns + ",Type,fVendMstrID", columnValue);

            if (objID != null)
            {
                string id = objID.ToString();
                return objID.ToString();
            }
            else
                return "";
        }

        ///// <summary>
        ///// Code to insert the buyfrom detail
        ///// </summary>
        ///// <param name="tableName"></param>
        ///// <param name="ColumnName"></param>
        ///// <param name="ColumnValue"></param>
        //public string  InsertBuyFromDetails(string tableName, string ColumnName, string ColumnValue) { }

        ///// <summary>
        ///// Code to inser the ship from details
        ///// </summary>
        ///// <param name="tableName"></param>
        ///// <param name="ColumnName"></param>
        ///// <param name="ColumnValue"></param>
        //public string InsertShipFromDetails(string tableName, string ColumnName, string ColumnValue) { }

        /// <summary>
        /// Code to insert the contact detail in the table
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="ColumnName"></param>
        /// <param name="ColumnValue"></param>
        public string InsertContactDetails(string columnValue)
        {
            object objID = InsertVendorMaintenanceDetails(contactTable, contactColumn, columnValue);

            if (objID != null)
                return objID.ToString();
            else
                return "";
        }

        public string InsertLocationDetails(string columnValue)
        {
            object objID = InsertVendorMaintenanceDetails(vendorAddressTable, vendorAddressColumns + ",Type,fVendMstrID,fBuyFromAddrID,WebPageAddr,TransitDays,ProdType", columnValue);

            if (objID != null)
            {
                string id = objID.ToString();
                return objID.ToString();
            }
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

        public string GetVendorNumber(string whereClause)
        {
            try
            {
                object objVendNo = (object)SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", vendorMasterTable),
                    new SqlParameter("@columnNames", "pVendMstrID"),
                    new SqlParameter("@whereClause", whereClause));

                if (objVendNo != null)
                    return objVendNo.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }

        public DataSet GetVendorHeaderDetails(string vendNo)
        {
            try
            {
                string tableName = vendorMasterTable + " ," + vendorAddressTable;
                string columnName = vendorMasterColumns + "," + vendorAddressColumns + ",pVendAddrID";
                string whereClause = " VendorMaster.pVendMstrID=" + vendNo + " And VendorMaster.pVendMstrID=VendorAddress.fVendMstrID And VendorAddress.Type='PT'";
                DataSet dsHeaderDetails = GetDataToDateset(tableName, columnName, whereClause);
                return dsHeaderDetails;
            }
            catch (Exception ex) { return null; }
        }

        public DataSet GetTreeviewDetails(string vendorNo)
        {
            try
            {
                DataSet dsDetail = new DataSet();
                DataTable dtBuy = new DataTable();
                DataTable dtShip = new DataTable();
                string columnName = "pVendAddrID as ID,LocationName,fBuyFromAddrID";

                string whereClause = " fVendMstrID=" + vendorNo + " And Type='BF' and deletedt is null";
                DataSet dsBuyFrom = GetDataToDateset(vendorAddressTable, columnName, whereClause);

                whereClause = " fVendMstrID=" + vendorNo + " And Type='SF' and deletedt is null";
                DataSet dsShipFrom = GetDataToDateset(vendorAddressTable, columnName, whereClause);

                if (dsBuyFrom != null && dsBuyFrom.Tables[0].Rows.Count > 0)
                {
                    dtBuy = dsBuyFrom.Tables[0].DefaultView.ToTable("BuyFrom");

                    if (dsShipFrom != null && dsShipFrom.Tables[0].Rows.Count > 0)
                        dtShip = dsShipFrom.Tables[0].DefaultView.ToTable("ShipFrom");

                    dsDetail.Tables.Add(dtBuy);
                    dsDetail.Tables.Add(dtShip);
                }

                return dsDetail;
            }
            catch (Exception ex) { return null; }
        }



        public DataSet GetContactDetails(string vendAddressID)
        {
            DataSet dsContact = GetDataToDateset(contactTable, contactColumn + ",pVendContractID", "fVendAddrID=" + vendAddressID + " And isnull(DeleteDt,'')=''");
            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                return dsContact;
            else
                return null;
        }

        public DataSet GetVendorContact(string contactID)
        {
            DataSet dsContact = GetDataToDateset(contactTable, contactColumn, "pVendContractID=" + contactID);
            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                return dsContact;
            else
                return null;
        }

        public void UpdateVendorDetails(string tableName, string columnValue, string where)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
                                             new SqlParameter("@tableName", tableName.Trim()),
                                             new SqlParameter("@columnNames", columnValue),
                                             new SqlParameter("@whereClause", where));
            }
            catch (Exception ex) { }
        }

        public DataSet GetAddressInformation(string whereClause)
        {
            try
            {
                DataSet dsHeaderDetails = GetDataToDateset(vendorAddressTable, vendorAddressColumns.Replace("VendorAddress.", "") + ",pVendAddrID,fBuyFromAddrID,Type,WebPageAddr,TransitDays,ProdType", whereClause);
                return dsHeaderDetails;
            }
            catch (Exception ex) { return null; }
        }

        public DataSet GetLocationDetails(string Id)
        {
            DataSet dsLocDetails = GetDataToDateset(vendorAddressTable, vendorAddressColumns.Replace("VendorAddress.", "") + ",Type,fVendMstrID,fBuyFromAddrID,WebPageAddr,TransitDays,ProdType", "pVendAddrID=" + Id);

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

                string VEND = "VEND (W)";
                string VDAP = "VDAP";
                string APVD = "APVD (W)";
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "'AND (SG.groupname='" + VEND + "' OR  SG.groupname='" + VDAP + "' OR  SG.groupname='" + APVD + "')"));

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
                UpdateVendorDetails(contactTable, "DeleteDt='" + DateTime.Now.ToShortDateString() + "'", "pVendContractID=" + contactID);
            }
            catch (Exception ex) { }
        }


        public void FillCountry(DropDownList ddlCountry)
        {
            string tabelName = "CountryMaster";
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

        public DataTable VendorLock(string lockVend, string idVendor)
        {
            try
            {
                string currentApplication = "VM";
                DataSet dsLock = SqlHelper.ExecuteDataset(connectionString, "pSoftLock",
                                              new SqlParameter("@resource", vendorMasterTable),
                                              new SqlParameter("@function", lockVend),
                                              new SqlParameter("@key", idVendor),
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
        public void SetLock(string idVendor)
        {
            try
            {
                DataTable dtLock = new DataTable();
                HttpContext.Current.Session["Vendor"] = idVendor;
                dtLock = VendorLock("Lock", HttpContext.Current.Session["Vendor"].ToString());
                HttpContext.Current.Session["Lock"] = dtLock.Rows[0][1].ToString().Trim();
            }
            catch (Exception ex)
            {
                HttpContext.Current.Session["Lock"] = null;
                HttpContext.Current.Session["Vendor"] = null;
            }
            finally { }
        }


        /// <summary>
        /// Function to release the vendor lock
        /// </summary>
        public void ReleaseLock()
        {
            try
            {
                if (HttpContext.Current.Session["Lock"] != null && HttpContext.Current.Session["Lock"].ToString().Trim() != "")
                    // if (HttpContext.Current.Session["Lock"].ToString().Trim() == "SL")
                    VendorLock("Release", HttpContext.Current.Session["Vendor"].ToString());
            }
            catch (Exception ex) { }
            finally
            {
                HttpContext.Current.Session["Lock"] = null;
                HttpContext.Current.Session["Vendor"] = null;
            }
        }

        public void FilProductType(DropDownList ddlProductType)
        {
            string tabelName = "Listdetail";
            string columnName = "ListValue,ListDtlDesc";
            string where = "fListMasterID in (select pListMasterID from listmaster where Listname='VendorProdType') order by sequenceno";
            DataSet dsProductType = GetDataToDateset(tabelName, columnName, where);
            if (dsProductType != null && dsProductType.Tables[0].Rows.Count > 0)
                BindDropDown(ddlProductType, dsProductType.Tables[0], "ListDtlDesc", "ListValue", "- Select Product Type -");
            else
            {
                ddlProductType.Items.Add(new ListItem("---N/A---", ""));
            }

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

    }
}