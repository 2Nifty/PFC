using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;
 

namespace PFC.Intranet.MaintenanceApps
{
    /// <summary>
    /// Summary description for MaintenanceUtility
    /// </summary>
    public class OrgStandardComment 
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";        
        string connection = PFC.Intranet.MaintenanceApps.MaintenanceUtility.GetConnectionString();
        string whereClause = string.Empty;
        
        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connection, "pSOEUpdate",
                             new SqlParameter("@tableName", "[OrganizationStandardComments]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       

        public void InsertTables(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connection, "pSOEInsert",
                             new SqlParameter("@tableName", "[OrganizationStandardComments]"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteTablesData(string primaryKey)
        {
            try
            {
                whereClause = "pOrgStdCommentsID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connection, "pSOEDelete",
                                             new SqlParameter("@tableName", "[OrganizationStandardComments]"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetTablesData(string searchText,string tableName,string number)
        {
            try
            {
                string _whereClause = "";
                string _tableName = "";
                string _columnName = "";
                if (tableName == "cust")
                {
                    _whereClause = searchText;
                    _tableName = "CustomerMaster INNER JOIN OrganizationStandardComments AS OrganizationStandardComments_1 ON CustomerMaster.CustNo = OrganizationStandardComments_1.AlphaOrganizationNo";
                    _columnName = "isnull(CustomerMaster.CustName,'') as Name, OrganizationStandardComments_1.OrganizationNo, OrganizationStandardComments_1.TableName,OrganizationStandardComments_1.Comments, OrganizationStandardComments_1.EntryID, OrganizationStandardComments_1.EntryDt,OrganizationStandardComments_1.ChangeID, OrganizationStandardComments_1.ChangeDt, OrganizationStandardComments_1.EmailAppInd,OrganizationStandardComments_1.SOAppInd, OrganizationStandardComments_1.POAppInd, OrganizationStandardComments_1.LineNumber,OrganizationStandardComments_1.AlphaOrganizationNo, OrganizationStandardComments_1.pOrgStdCommentsID as pTableID";

                    
                }
                else
                {
                    _whereClause = searchText;
                    _tableName = "OrganizationStandardComments as OrganizationStandardComments_1 INNER JOIN VendorMaster ON OrganizationStandardComments_1.OrganizationNo =VendorMaster.VendNo";
                     _columnName = "isnull(VendorMaster.Name,'') as Name, OrganizationStandardComments_1.OrganizationNo, OrganizationStandardComments_1.TableName,OrganizationStandardComments_1.Comments, OrganizationStandardComments_1.EntryID, OrganizationStandardComments_1.EntryDt,OrganizationStandardComments_1.ChangeID, OrganizationStandardComments_1.ChangeDt, OrganizationStandardComments_1.EmailAppInd,OrganizationStandardComments_1.SOAppInd, OrganizationStandardComments_1.POAppInd, OrganizationStandardComments_1.LineNumber,OrganizationStandardComments_1.AlphaOrganizationNo, OrganizationStandardComments_1.pOrgStdCommentsID as pTableID";

                }
                DataSet dsCarrierCode = new DataSet();
                dsCarrierCode = SqlHelper.ExecuteDataset(connection, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCarrierCode.Tables[0];
            }
            catch (Exception ex)
            { 
                return null;
            }
        }

        public DataSet GetData(string searchText,string type)
        {
            try
            {
                if (type == "Cust")
                {
                   

                    string _whereClause = "CustName like '" + searchText + "'";
                    string _tableName = " CustomerAddress RIGHT OUTER JOIN CustomerMaster ON CustomerAddress.fCustomerMasterID = CustomerMaster.pCustMstrID";
                    string _columnName = "CustomerAddress.fCustomerMasterID, CustomerAddress.Type, CustomerAddress.AddrLine1, dbo.CustomerAddress.City,CustomerAddress.State, CustomerAddress.PostCd, CustomerAddress.Country, CustomerAddress.PhoneNo, CustomerAddress.Email,CustomerAddress.EntryID,CustomerAddress.EntryDt, CustomerAddress.ChangeID,CustomerAddress.ChangeDt, CustomerMaster.pCustMstrID, CustomerMaster.CustNo, CustomerMaster.CustName";

                    DataSet dsCarrierCode = new DataSet();
                    dsCarrierCode = SqlHelper.ExecuteDataset(connection, "pSOESelect",
                                        new SqlParameter("@tableName", _tableName),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));
                    return dsCarrierCode;
                }
                else
                {
                   
                    string _whereClause = "Name like '" + searchText + "'";
                    string _tableName = "VendorAddress RIGHT OUTER JOIN VendorMaster ON VendorAddress.fVendMstrID = VendorMaster.pVendMstrID";
                    string _columnName=" VendorAddress.Type, VendorAddress.fVendMstrID, VendorAddress.Line1 as AddrLine1 , dbo.VendorAddress.State, VendorAddress.City,VendorAddress.PostCd, VendorAddress.Country, VendorAddress.PhoneNo, VendorAddress.Email, VendorAddress.EntryID,VendorAddress.EntryDt, VendorAddress.ChangeID, VendorAddress.ChangeDt, VendorMaster.pVendMstrID, VendorMaster.VendNo as custno,VendorMaster.Name as CustName";
                    //string _columnName = "Line1 as AddrLine1,City,State,PhoneNo,PostCd,Country,Name as CustName,vendNo as CustNo,Email";

                    DataSet dsCarrierCode = new DataSet();
                    dsCarrierCode = SqlHelper.ExecuteDataset(connection, "pSOESelect",
                                        new SqlParameter("@tableName", _tableName),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));
                    return dsCarrierCode;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCustomerSelect(string customer)
        {

            try
            {
                DataSet dsCustomer = SqlHelper.ExecuteDataset(connection, "[VW_CustomerMaster]",
                                                 new SqlParameter("@CustName", customer));
                //DataSet dsCustomer = SqlHelper.ExecuteDataset(connection, "pSOESelect",
                //                    new SqlParameter("@tableName", VW_CustomerMaster),
                //                    new SqlParameter("@columnNames", _columnName),
                //                    new SqlParameter("@whereClause", _whereClause));
                return dsCustomer;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public bool CheckVendorORCistomerNumberValid(string number, string type)
        {
            string tableName,columnValue,where;

            if (type.Trim().ToLower() == "cust")
            {
                tableName = "CustomerAddress RIGHT OUTER JOIN CustomerMaster ON CustomerAddress.fCustomerMasterID = CustomerMaster.pCustMstrID";
                columnValue = "CustomerAddress.fCustomerMasterID, CustomerAddress.Type, CustomerAddress.AddrLine1, dbo.CustomerAddress.City,CustomerAddress.State, CustomerAddress.PostCd, CustomerAddress.Country, CustomerAddress.PhoneNo, CustomerAddress.Email,CustomerAddress.EntryID,CustomerAddress.EntryDt, CustomerAddress.ChangeID,CustomerAddress.ChangeDt, CustomerMaster.pCustMstrID, CustomerMaster.CustNo, CustomerMaster.CustName";
                where = "CustNo='" + number + "'";
            }
            else
            {
                tableName = "VendorAddress RIGHT OUTER JOIN VendorMaster ON VendorAddress.fVendMstrID = VendorMaster.pVendMstrID";
                columnValue = " VendorAddress.Type, VendorAddress.fVendMstrID, VendorAddress.Line1 as AddrLine1 , dbo.VendorAddress.State, VendorAddress.City,VendorAddress.PostCd, VendorAddress.Country, VendorAddress.PhoneNo, VendorAddress.Email, VendorAddress.EntryID,VendorAddress.EntryDt, VendorAddress.ChangeID, VendorAddress.ChangeDt, VendorMaster.pVendMstrID, VendorMaster.VendNo as custno,VendorMaster.Name as CustName";
                where = "vendNo='" + number + "'";
            }
            DataSet dsResult = SqlHelper.ExecuteDataset(connection, "pSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnValue),
                                new SqlParameter("@whereClause", where));           

            if (dsResult.Tables[0] != null && dsResult.Tables[0].Rows.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public string CheckAlphaOrgNo(string type, string number)
        {
            string tableName, columnValue, where;
            if (type.ToLower() == "cust")
            {
                tableName = "CustomerMaster";
                columnValue = "CustNo";
                where = "CustNo='" + number + "'";
            }
            else
            {
                tableName = "VendorMaster";
                columnValue = "Code";
                where = "VendNo='" + number + "'";
            }
            object objSecurityCode = (object)SqlHelper.ExecuteScalar(connection, "pSOESelect",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnValue),
                    new SqlParameter("@whereClause", where));

            if (objSecurityCode != null)
                return objSecurityCode.ToString().Trim();
            else
                return "";



        }
                            
        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName, MaintenaceTable moduleType)
        {
            try
            {
                
                #region Create where clause based on module type

                string whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='OrgComm (W)')";
                
                #endregion

                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connection, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + whereClause));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
        #endregion
    }

}