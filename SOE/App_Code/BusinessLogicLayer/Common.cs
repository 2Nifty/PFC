using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;

namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for Common
    /// </summary>
    public class Common
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '')  and SU.UserName='" + userName + "' AND (SG.groupname='SOE(W)' OR  SG.groupname='ENTRY(W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }

        public bool IsAdminUser(string userName)
        {
            string adminSecurityCode = "SOE(W)";
            string userSecurityCode = GetSecurityCode(userName);

            return (adminSecurityCode == userSecurityCode.Trim());
                 
        }

        public DataTable GetUserList()
        {
            try
            {

                string _tableName = "SecurityUsers";
               string _columnName = "UserName as Code,MSADUserName as Name";
               string _whereClause = "MSADUserName<>'' Order BY UserName";
               DataSet dsType = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
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
        public string GetUserLoc(string userName)
        {
            try
            {

                string _tableName = "SecurityUsers";
                string _columnName = "OELoc";
                string _whereClause = "Username='" + userName + "'";
                string strLoc = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                     new SqlParameter("@tableName", _tableName),
                                     new SqlParameter("@columnNames", _columnName),
                                     new SqlParameter("@whereClause", _whereClause)).ToString();
                return strLoc;
            }
            catch (Exception ex)
            {
                return "";
            }
        }
        public string GetShowAllUser(string userName)
        {
            try
            {

                string _tableName = "SecurityUsers";
                string _columnName = "ShowAllUsersInd";
                string _whereClause = "Username='" + userName + "'";
                string strLoc = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                     new SqlParameter("@tableName", _tableName),
                                     new SqlParameter("@columnNames", _columnName),
                                     new SqlParameter("@whereClause", _whereClause)).ToString();
                return strLoc.ToUpper().Trim();
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetPFCLocations()
        {
            try
            {
                DataSet dsLocation = System.Web.HttpContext.Current.Session["BranchComboValues"] as DataSet;

                return dsLocation.Tables[0];
            }
            catch (Exception ex)
            {
                throw null;
            }


        }

        public DataTable FillDropDownFromListMaster(string listName)
        {
            try
            {
                string _tableName = "ListMaster LM ,ListDetail LD";
                string _columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                string _whereClause = "LM.ListName = '" + listName + "' And LD.fListMasterID = LM.pListMasterID order by ListValue";
                DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsResult.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #region Method to fill session variables

        public void LoadSessionVariables(string userID)
        {
            try
            {
                // Local variable declaration
                string _tableName = " UCOR_UserSetup";
                string _columnName = "CompanyID,UserName,Interface,DefaultCompanyID";
                string _whereClause = "[UserID]='" + userID + "'";

                DataSet userInterface = SqlHelper.ExecuteDataset(Global.PFCUmbrellaConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (userInterface.Tables[0].Rows.Count > 0)
                {
                    HttpContext.Current.Session["BranchID"] = GetPFCBranchCode(userInterface.Tables[0].Rows[0]["CompanyID"].ToString());
                    HttpContext.Current.Session["InterfaceID"] = userInterface.Tables[0].Rows[0]["Interface"].ToString();
                    HttpContext.Current.Session["DefaultBranchID"] = GetPFCBranchCode(userInterface.Tables[0].Rows[0]["DefaultCompanyID"].ToString());
                }

                FillBranchesAndChainSession(userID);

                // Load LocMaster to Session variable
                DataSet dsLocMaster = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", "LocMaster"),
                                                new SqlParameter("@columnNames", "LocID,LocType,LocName,LocAdress1,LocAdress2,LocCity,LocState,LocPostCode,LocCountry,LocPhone,LocFax,LocEmail,ShipMethCd,ReqPOInd"),
                                                new SqlParameter("@whereCondition", " 1=1 "));
                HttpContext.Current.Session["LocMaster"] = dsLocMaster.Tables[0];


                // Load Security Information
                string emailAdrress = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", "SecurityUsers"),
                                                new SqlParameter("@columnNames", "EmailAddress"),
                                                new SqlParameter("@whereCondition", " MSADUserName='" + HttpContext.Current.Session["UserName"] + "' and DeleteDt is null")).ToString();
                HttpContext.Current.Session["SalesPersonEmail"] = emailAdrress;
            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        /// Function used to store branch values in session variables
        /// </summary>
        /// <param name="userID"></param>
        public void FillBranchesAndChainSession(string userID)
        {
            try
            {
                string authCompanyID = GetAuthorizedBranchID(userID);
                string authBranchID = string.Empty;

                DataSet dsAuthorizedBranch = (DataSet)SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOESelect]",
                                        new SqlParameter("@TableName", "LocMaster"),
                                        new SqlParameter("@columnNames", "rtrim(LocID) as Branch,LocID+' - '+LocName as Name"),
                                        new SqlParameter("@whereClause", "LocID in (" + authCompanyID + ") order by LocID"));


                DataSet dsUnAuthorizedBranch = (DataSet)SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOESelect]",
                                        new SqlParameter("@TableName", "LocMaster"),
                                        new SqlParameter("@columnNames", "rtrim(LocID) as Branch,LocID+' - '+LocName as Name"),
                                        new SqlParameter("@whereClause", "LocID not in (" + authCompanyID + ") order by LocID"));


                #region Get "--All--" drop down option value
                authCompanyID = "";
                //
                // Get Authorized Branches ID
                //
                for (int i = 0; i < dsAuthorizedBranch.Tables[0].Rows.Count; i++)
                {
                    string brnID = string.Empty;
                    if (dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Length == 1)
                        brnID = "0" + dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();
                    else
                        brnID = dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();

                    authCompanyID += ",'" + brnID.Trim() + "'";
                    authBranchID += "," + dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Trim();
                }
                authCompanyID = authCompanyID.Remove(0, 1);
                authBranchID = authBranchID.Remove(0, 1);
                System.Web.HttpContext.Current.Session["BranchComboValues"] = dsAuthorizedBranch;
                System.Web.HttpContext.Current.Session["BranchIDForALL"] = authBranchID;
                System.Web.HttpContext.Current.Session["AuthorizedBranch"] = authCompanyID;

                #endregion

                #region UnAuthorized and Total Branches
                // Get UnAuthorized Branch values
                string unAuthorizedBranch = string.Empty;
                System.Web.HttpContext.Current.Session["UnAuthorizedBranch"] = "0";
                System.Web.HttpContext.Current.Session["UnAuthorizedBranchTotal"] = "0";
                System.Web.HttpContext.Current.Session["AuthorizedBranchTotal"] = dsAuthorizedBranch.Tables[0].Rows.Count;
                for (int i = 0; i < dsUnAuthorizedBranch.Tables[0].Rows.Count; i++)
                {
                    string brnID = string.Empty;
                    if (dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Length == 1)
                        brnID = "0" + dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();
                    else
                        brnID = dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();

                    unAuthorizedBranch += ",'" + brnID.Trim() + "'";

                }
                if (unAuthorizedBranch != "")
                    unAuthorizedBranch = unAuthorizedBranch.Remove(0, 1);

                System.Web.HttpContext.Current.Session["UnAuthorizedBranch"] = unAuthorizedBranch;

                // Get Total Branches

                System.Web.HttpContext.Current.Session["UnAuthorizedBranchTotal"] = dsUnAuthorizedBranch.Tables[0].Rows.Count;

                #endregion

            }
            catch (Exception ex)
            {

            }
        }

        public string GetAuthorizedBranchID(string userID)
        {
            string authCompanyID = "";
            string authBranchID = "";
            try
            {
                DataSet dsAuthBranch = (DataSet)SqlHelper.ExecuteDataset(Global.PFCUmbrellaConnectionString, "[UGEN_SP_Select]",
                                               new SqlParameter("@TableName", "UCOR_UserAuthorizedCompanies a,UCOR_CompanyProfile b"),
                                               new SqlParameter("@columnNames", "a.AuthCompanyID as CompanyID,b.code as AuthCompanyID"),
                                               new SqlParameter("@whereClause", "a.UserID='" + userID + "' and  a.AuthCompanyID =b.CompanyID"));

                for (int i = 0; i < dsAuthBranch.Tables[0].Rows.Count; i++)
                {
                    string brnID = string.Empty;
                    if (dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString().Length == 1)
                        brnID = "0" + dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString();
                    else
                        brnID = dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString();
                    authCompanyID += ",'" + brnID.Trim() + "'";
                    authBranchID += "," + dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString().Trim();
                }
                authCompanyID = authCompanyID.Remove(0, 1);
                authBranchID = authBranchID.Remove(0, 1);
                System.Web.HttpContext.Current.Session["AuthorizedBranch"] = authCompanyID;
                return authBranchID;
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        private string GetPFCBranchCode(string branchId)
        {
            try
            {
                // Local variable declaration
                string _tableName = "UCOR_CompanyProfile";
                string _columnName = "Code";
                string _whereClause = "Companyid=" + branchId;

                string branch = SqlHelper.ExecuteScalar(Global.PFCUmbrellaConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause)).ToString();


                // Check whether any value has returned
                if (branch.ToString().Length == 1)
                    return "0" + branch;
                else
                    return branch;


            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        #endregion       

        #region Method to Get Customer Informations

        public DataSet  GetCustomerDefaultInformation(string customerNumber)
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOECustomerDetails",
                              new SqlParameter("@custNo", customerNumber));
                return dsResult;

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion


        /// <summary>
        /// retruns branch name by branchID
        /// </summary>
        /// <param name="branchId"></param>
        /// <returns></returns>
        public string GetBranchName(string branchId)
        {

            try
            {
                string branch = branchId.Trim();
                if (branchId.Trim().Length == 1)
                {
                    branch = "0" + branchId.ToString();
                }

                string _tableName = "LocMaster";
                string _columnName = "LocName";
                string _whereClause = "LocID='" + branch + "'";
                string branchLongName = string.Empty;

                branchLongName = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return branchLongName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #region Methods to fill common dropdowns

        public DataTable GetSOEOrderTypes()
        {
            try
            {
                string _tableName = " listmaster,listdetail ";
                string _columnName = "ListValue as Code,ListValue +' - '+ListDtlDesc as Name ";
                string _whereClause = " listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='SOEOrderTypes' order by listdetail.ListValue ";
                
                DataSet dsCustomer = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCustomer.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion

        public string GetSalesPersonEmailID(string WINADName)
        {
            // Load Security Information
            string emailAdrress = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "[UGEN_SP_Select]",
                                            new SqlParameter("@tableName", "SecurityUsers"),
                                            new SqlParameter("@columnNames", "EmailAddress"),
                                            new SqlParameter("@whereCondition", " MSADUserName='" + WINADName + "' and DeleteDt is null")).ToString();
            return emailAdrress;
        }
    }
}
