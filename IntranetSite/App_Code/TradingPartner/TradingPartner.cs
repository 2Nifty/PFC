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
using System.Data.Sql;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for SecurityGroup
    /// </summary>
    public class TradingPartner
    {

        string tableName = "";
        string columnName = "";
        string whereClause = "";

        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        public DataTable GetLocationView(string whereCondition)
        {
            try
            {
                if(whereCondition =="")
                    whereCondition = "1=1";

                columnName = "TP.AssignedVendorNo,TP. LocationCustomerNo ,LM.LocName, CM.CustNo, CM.CustName, LM.LocID, TP.pEDITradingPartnerID ";
                tableName = "LocMaster AS LM INNER JOIN CustomerMaster AS CM ON LM.LocID = CM.ShipLocation INNER JOIN EDITradingPartner AS TP ON TP.fCustomerMasterID = CM.pCustMstrID";
               

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                       new SqlParameter("@tableName", tableName),
                                       new SqlParameter("@columnNames", columnName),
                                       new SqlParameter("@whereClause", whereCondition));

                return dsDetails.Tables[0];

            }
            catch (Exception ex)
            { throw ex; }
        }
        public DataTable CheckCustomerNo(string CustNo)
        {
            try
            {

                columnName = "CustNo";
                tableName = "CustomerMaster";

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                       new SqlParameter("@tableName", tableName),
                                       new SqlParameter("@columnNames", columnName),
                                       new SqlParameter("@whereClause", "CustNo='"+CustNo+"'"));

                return dsDetails.Tables[0];


            }
            catch (Exception ex)
            { throw ex; }
        }
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
            catch (Exception ex) { throw ex; }
        }
        public DataTable GetBindCodeData(string whereClause)
        {
            try
            {
                tableName = "ListMaster LM ,ListDetail LD";
                columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue";



                DataSet dsProgram = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsProgram.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable GetBindTypeData(string whereClause)
        {
            try
            {
                tableName = "ListMaster LM ,ListDetail LD";
                columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue";



                DataSet dsProgram = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsProgram.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable getTrading(string TradingID)
        {

            tableName = "EDITradingPartner";
            columnName = "LocationCustomerNo,CustomerEDIEmailAddress,AssignedVendorNo,TradingPartnerCd,EDIType,"+
                          "EntryID,ChangeID,convert(char(10),EntryDt,101) as EntryDt,  convert(char(10),ChangeDt,101) as ChangeDt";

            whereClause = "pEDITradingPartnerID='" + TradingID + "'";

            DataSet dsTrading = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                               new SqlParameter("@tableName", tableName),
                               new SqlParameter("@columnNames", columnName),
                               new SqlParameter("@whereClause", whereClause));
            return dsTrading.Tables[0];
        }
        public DataTable CustInformation(string CustNo)
        {

            tableName = "CustomerAddress CA inner join CustomerMaster CM on CA.fCustomerMasterID =CM.pCustMstrID";
            columnName = "CA.city,CA.state,CA.country,CA.phoneno,CA.addrline1,CM.CustName ";

            whereClause = "CustNo='" + CustNo + "'";

            DataSet dsTrading = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                               new SqlParameter("@tableName", tableName),
                               new SqlParameter("@columnNames", columnName),
                               new SqlParameter("@whereClause", whereClause));
            return dsTrading.Tables[0];
        }
        public string InsertTradingInformation(string columnValue)
        {
            try
            {
                tableName = "EDITradingPartner";
                columnName = "LocationCustomerNo,EDIType,TradingPartnerCd,CustomerEDIEmailAddress,AssignedVendorNo,fCustomerMasterID,EntryID,EntryDt";

                object objUserId = (object)SqlHelper.ExecuteScalar(connectionString, "[pSOEInsert]",
                                       new SqlParameter("@tableName", tableName),
                                       new SqlParameter("@columnNames", columnName),
                                       new SqlParameter("@ColumnValues", columnValue)).ToString();

                return objUserId.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
                return null;
            }
        }
        public void UpdateTradingInformation(string columnValues, string ID)
        {
            try
            {
                whereClause = "pEDITradingPartnerID=" + ID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "EDITradingPartner"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable CheckTradingCustNo(string CustNo)
        {
           
                tableName = "EDITradingPartner";
                columnName = "*";
                whereClause = "LocationCustomerNo='" + CustNo + "'";
              

                DataSet dsEmployee = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                   new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause));
                return dsEmployee.Tables[0];

          
        }
        public DataTable GetCustMasterID(string CustNo)
        {

            tableName = "CustomerMaster";
            columnName = "*";
            whereClause = "CustNo='" + CustNo + "'";


            DataSet dsEmployee = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                               new SqlParameter("@tableName", tableName),
                               new SqlParameter("@columnNames", columnName),
                               new SqlParameter("@whereClause", whereClause));
            return dsEmployee.Tables[0];


        }
        public void DeleteTradingInforamtion(string TradingID)
        {
            try
            {
                // Set delete delete dt for old data
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                          new SqlParameter("@tableName", "EDITradingPartner"),
                                          new SqlParameter("@whereClause", "pEDITradingPartnerID=" + TradingID));
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public string GetSecurityCode(string userName)
        {
            try
            {

                string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
                #region Create where clause based on module type

                string whereClause = "' AND (SG.groupname='EDITrd (W)' OR SG.groupname='Maintenance (W)')"; ;

                #endregion

                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                new SqlParameter("@tableName", securityTable),
                new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID and SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + whereClause));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }

        public void DisplayMessage(MessageType messageType, string messageText, Label lblMessage)
        {
            switch (messageType)
            {
                case MessageType.Success:
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case MessageType.Failure:
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;
                case MessageType.None:

                    break;

            }

            lblMessage.Text = messageText;
            lblMessage.Visible = true;
        }

    }
}
       
        
     
       
   