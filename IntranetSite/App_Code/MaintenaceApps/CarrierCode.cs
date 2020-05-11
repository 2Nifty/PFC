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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.IntranetSite.MaintenanceApps
{
    /// <summary>
    /// Summary description for CarrierCode
    /// </summary>
    public class CarrierCode
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause = string.Empty;

        public CarrierCode()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public void UpdateCarrierCode(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "Car"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void InsertCarrierCode(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "[pSOEInsert]",
                             new SqlParameter("@tableName", "Car"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }

        public DataTable FillCarrierType()
        {

            DataSet dsCarrierType = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "ListMaster LM ,ListDetail LD"),
                                    new SqlParameter("@columnNames", "LM.pListMasterID, LM.ListName, LD.ListValue"),
                                    new SqlParameter("@whereClause", "LM.ListName = 'CarrierType' And LD.fListMasterID = LM.pListMasterID Order By SequenceNo"));

            return dsCarrierType.Tables[0];

        }

        public void DeleteCarrierCode(string ccID)
        {
            try
            {
                whereClause = "pCar ='" + ccID + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "Car"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool CheckCarrierCodeExist(string cCODE)
        {
            DataSet dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                        new SqlParameter("@tableName", "Car"),
                        new SqlParameter("@columnNames", "pCar"),
                        new SqlParameter("@whereClause", "Car_Code='" + cCODE + "'"));

            if (dsCarrierCode.Tables[0].Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public DataTable GetCarrierCode(string searchText)
        {
            string _whereClause = searchText;
            string _tableName = "CAR";
            string _columnName = "pCar,Car_Code,Dsc,Short_Dsc,Car_Type,Car_Min_Pro,Car_Max_Pro,Car_Co_ID,BOL_Copies,Car_Terminal,Chk_Digit_Type,Chk_Digit_Mod,SCAC_Code,Pro_No_Prefix,Service_Lvl,Pro_Odom,EDI_Type,Priority_Code,Vendor_ID,Vendor_No,GL_App,AP_App,AR_App,SO_App,PO_App,IM_App,WM_App,WO_App,MM_App,SM_App,Entry_ID,Entry_Date,Change_ID,Change_Date";

            DataSet dsCarrierCode = new DataSet();
            dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsCarrierCode.Tables[0];
        }
        
        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='CAR (W)')"));

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