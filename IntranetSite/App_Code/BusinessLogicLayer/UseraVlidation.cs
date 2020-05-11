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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;

/// <summary>
/// Summary description for UserVlidation
/// </summary>
namespace PFC.Intranet
{
    public class UserValidation
    {

        private const string TBLAPPSESSIONLOG = "UCOR_Appsessionlog"; 
        private const string TBLUSERSETUP = "UCOR_UserSetup";
        public const string SP_GENERALSELECT = "UGEN_SP_Select";
        private const string TBLPOSTMESSAGE = "UMSG_PostMessage";
        public UserValidation()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        /// <summary>
        /// Public Method ValidateUser is used to validate by _userName
        /// </summary>
        /// <param name="_userName"></param>
        /// <returns></returns>
        public DataSet ValidateUser(string _userName)
        {
            try
            {
				
                // Local variable declaration
                string _tableName = "UCOR_UserSetup a,UCOR_CompanyBranch b ,UCOR_CompanyDepartment c,Ucor_UserType d";
                string _columnName = "d.description as 'UserType',a.UserName,a.UserID,a.MaxSensitivity,a.CompanyID,a.Picture,a.[Name],a.[DefaultCompanyID] as DefaultCompanyID,b.[Name] as BranchName,c.[Name] as  Department ";
                string _whereClause = "a.[Interface] = '" + Global.IntranetInterfaceID.ToString() + "' and a.[UserName]='" + _userName + "'and b.BranchID=a.Branch and c.DepartmentID=a.Department and a.UserType=d.TypeID";

                DataSet UserInfo = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));

                // Check whether any value has returned
                if (UserInfo.Tables[0].Rows.Count > 0)
                    return UserInfo;
                else
                    return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
           
        }
        public string GetBranchCode(string branchId)
        {
            try
            {
                // Local variable declaration
                string _tableName = "UCOR_CompanyProfile";
                string _columnName = "Code";
                string _whereClause = "Companyid=" + branchId;

                string branch = SqlHelper.ExecuteScalar(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause)).ToString();


                // Check whether any value has returned
                if (branch.ToString().Length == 0)
                    return "0" + branch;
                else
                    return branch;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public string GetUserEmail(string userName)
        {
            string emailAddress = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", "SecurityUsers (NoLock)"),
                                                new SqlParameter("@columnNames", "EmailAddress"),
                                                new SqlParameter("@whereCondition", " MSADUserName='" + userName + "' and DeleteDt is null")).ToString();
            return emailAddress;
        }
        
        /// <summary>
        /// Public Method ValidateUser is used to validate user
        /// </summary>
        /// <returns></returns>
        public DataSet ValidateUser()
        {
            string _userName = System.Configuration.ConfigurationManager.AppSettings["DefaultUser"].ToString();
            try
            {
                // Local variable declaration
                string _tableName = "UCOR_UserSetup a,UCOR_CompanyBranch b ,UCOR_CompanyDepartment c,Ucor_UserType d";
                string _columnName = "d.description as 'UserType',a.UserName,a.UserID,a.MaxSensitivity,a.CompanyID,a.Picture,a.[Name],a.[DefaultCompanyID] as DefaultCompanyID,b.[Name] as BranchName,c.[Name] as  Department ";
                string _whereClause = "a.[Interface] = '" + Global.IntranetInterfaceID.ToString() + "' and a.[UserName]='" + _userName + "'and b.BranchID=a.Branch and c.DepartmentID=a.Department and a.UserType=d.TypeID";

                DataSet UserInfo = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (UserInfo.Tables[0].Rows.Count > 0)
                    return UserInfo;
                else
                    return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        /// <summary>
        /// Public Method ValidateUser is used to validate by _userName and Password
        /// </summary>
        /// <param name="_userName"></param>
        /// <param name="_password"></param>
        /// <returns></returns>
        public DataSet ValidateUser(string _userName,string _password)
        {
            try
            {
                // Local variable declaration
                string _tableName = " UCOR_UserSetup a,UCOR_CompanyBranch b ,UCOR_CompanyDepartment c,Ucor_UserType d";
                string _columnName = "d.description as 'UserType',a.UserName,a.UserID,a.MaxSensitivity,a.CompanyID,a.Picture,a.[Name],a.[DefaultCompanyID] as DefaultCompanyID,b.[Name] as BranchName,c.[Name] as  Department,d.description ";
                string _whereClause = "a.[Interface] = '" + Global.IntranetInterfaceID.ToString() + "' and a.[UserName]='" + _userName + "' and a.Password='" + Cryptor.Encrypt(_password) + "' and b.BranchID=a.Branch and c.DepartmentID=a.Department and a.UserType=d.TypeID";

                DataSet UserInfo = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (UserInfo.Tables[0].Rows.Count > 0)
                    return UserInfo;
                else
                    return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
                
    }
}