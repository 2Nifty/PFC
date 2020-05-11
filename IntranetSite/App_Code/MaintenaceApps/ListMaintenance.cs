#region Header
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
#endregion

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for ListMaintenance
    /// </summary>
    public class ListMaintenanceLayer
    {
        #region  Variable declaration
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";

        //ConnectionString
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        // Table Name 
        string dtllistTable = "ListDetail";
        string mstrlistTable = "ListMaster";
        // Column Name
        string dtlColumnsWID = "[pListDetailID],[ListValue],[ListDtlDesc],[SequenceNo],case [GLAccountNo] WHEN '0' THEN NULL ELSE GLAccountNo END as GLAccountNo,[EntryID],[EntryDt],[ChangeID],[ChangeDt]";
        string dtlColumnsWOID = "[fListMasterID],[ListValue],[ListDtlDesc],[SequenceNo],[GLAccountNo],[EntryID],[EntryDt],[ChangeID],[ChangeDt]";
        string mstrColumns = "[ListName],[ListDesc],[Comments],[SystemRequiredInd],[UserOptionInd],[ListStatusCd],[EntryID],[EntryDt],[ChangeID],[ChangeDt]";

        string whereClause = "";
        DataSet dsDetails = new DataSet(); 
        #endregion

        #region Constructor
        /// <summary>
        /// Constructor 
        /// </summary>
        public ListMaintenanceLayer()
        {
            //
            // TODO: Add constructor logic here
            //
        } 
        #endregion

        #region Select function

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

                dsDetails = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
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
        #endregion

        #region Bind Dropdown function
        /// <summary>
        /// Code to Bind the drop down control
        /// </summary>
        /// <param name="ddlCurrent">Type :Dropdown </param>
        /// <param name="dataSource">Data Source to assign to Dropdown</param>
        /// <param name="textField">Dropdown text field value</param>
        /// <param name="valueField">Dropdown value field value</param>
        /// <param name="defaultText">default selected value</param>
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

        #endregion

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
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='LIST (W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        } 
        #endregion

        #region List Name Fill Method 
        /// <summary>
        /// Used to Fill List name
        /// </summary>
        /// <param name="ddlListName">List Master Dropdown control</param>
        public void FillListName(DropDownList ddlListName)
        {

            string columnName = "ListName +' - '+  ListDesc as ListValue,pListMasterID as ID";
            string where = "1=1 order by ListName";
            DataSet dsListName = GetDataToDateset(mstrlistTable, columnName, where);
            if (dsListName != null && dsListName.Tables[0].Rows.Count > 0)
                BindDropDown(ddlListName, dsListName.Tables[0], "ListValue", "ID", "--- Select ListName ----");
            else
            {
                ddlListName.Items.Add(new ListItem("---N/A---", ""));
            }

        } 
        #endregion

        #region GL Account Fill Method
        /// <summary>
        /// Used to Fill GL Account
        /// </summary>
        /// <param name="ddlListName">List Master Dropdown control</param>
        public void FillGLAccount(DropDownList ddlGLAccount)
        {

            string columnName = "AccountNo +' - '+  AccountDescription as AccountDesc,AccountNo as AccountNo";
            string where = "1=1 order by AccountNo";
            DataSet dsGLAccount = GetDataToDateset("GLAcctMaster", columnName, where);
            if (dsGLAccount != null && dsGLAccount.Tables[0].Rows.Count > 0)
            {
                ddlGLAccount.DataSource = dsGLAccount.Tables[0];
                ddlGLAccount.DataTextField = "AccountDesc";
                ddlGLAccount.DataValueField = "AccountNo";
                ddlGLAccount.DataBind();

                ListItem item = new ListItem("--- Select GL Account ----","0");
                ddlGLAccount.Items.Insert(0,item);                
            }
            else
            {
                ddlGLAccount.Items.Add(new ListItem("---N/A---", "0"));
            }

        }
        #endregion

        #region List Master Get/Insert/Update/Delete function
        /// <summary>
        /// Used to get List master record based on listmaster Id
        /// </summary>
        /// <param name="listID">list Master ID</param>
        /// <returns>Dataset - Table [] with [ListName],[ListDesc],[Comments],[SystemRequiredInd],[UserOptionInd],[ListStatusCd],[EntryID],[EntryDt],[ChangeID],[ChangeDt] </returns>
        public DataSet GetMasterRecord(string listID)
        {
            try
            {
                whereClause = "pListMasterID =" + listID;
                dsDetails = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", mstrlistTable),
                    new SqlParameter("@columnNames", mstrColumns),
                    new SqlParameter("@whereClause", whereClause));

                if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    return dsDetails;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// Code to insert List master
        /// </summary>       
        /// <param name="ColumnValue">Column Values -[ListName],[ListDesc],[Comments],[SystemRequiredInd],[UserOptionInd],[ListStatusCd],[EntryID],[EntryDt],[ChangeID],[ChangeDt]</param>
        public object InsertListMaster(string ColumnValues)
        {
            try
            {
                object objID = SqlHelper.ExecuteScalar(connectionString, "pSOEINSERT",
                                              new SqlParameter("@tableName", mstrlistTable),
                                              new SqlParameter("@columnNames", mstrColumns),
                                              new SqlParameter("@columnValues", ColumnValues));
                return objID;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// Code to update List master
        /// </summary>
        /// <param name="columnValues">Column Values -[ListDesc],[Comments],[SystemRequiredInd],[UserOptionInd],[ListStatusCd],[ChangeID],[ChangeDt]</param>
        /// <param name="listID">list Master ID</param>
        public void UpdateListMaster(string columnValues, string listID)
        {
            try
            {
                whereClause = "pListMasterID =" + listID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                                             new SqlParameter("@tableName", mstrlistTable),
                                             new SqlParameter("@columnNames", columnValues),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex) { }
        }
        /// <summary>
        /// Code to delete List Master
        /// </summary>
        /// <param name="listID">list Master ID</param>
        public void DeleteListMaster(string listID)
        {
            try
            {
                whereClause = "pListMasterID =" + listID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", mstrlistTable),
                                             new SqlParameter("@whereClause", whereClause));
                whereClause = "fListMasterID =" + listID;
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                           new SqlParameter("@tableName", dtllistTable),
                                           new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
            }

        } 
        #endregion

        #region  List detail Get/Insert/Update/Delete function

        /// <summary>
        /// sed to get List detail record based on listmaster Id
        /// </summary>
        /// <param name="listID">list Master ID</param>
        /// <returns>Dataset - Table [] with [pListDetailID],[ListValue],[ListDtlDesc],[SequenceNo],[GLAccountNo],[EntryID],[EntryDt],[ChangeID],[ChangeDt] </returns>
        public DataSet GetDetailRecord(string listID)
        {
            try
            {
                whereClause = "fListMasterID =" + listID;
                dsDetails = new DataSet();
                dsDetails = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", dtllistTable),
                    new SqlParameter("@columnNames", dtlColumnsWID),
                    new SqlParameter("@whereClause", whereClause));

               // if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    return dsDetails;
               // else
                  //  return null;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// Code to insert List detail
        /// </summary>       
        /// <param name="ColumnValue">columnvalues :[fListMasterID],[ListValue],[ListDtlDesc],[SequenceNo],[GLAccountNo],[EntryID],[EntryDt],[ChangeID],[ChangeDt] </param>
        public object InsertListDetails(string ColumnValues)
        {
            try
            {
                object objID = SqlHelper.ExecuteScalar(connectionString, "pSOEINSERT",
                                              new SqlParameter("@tableName", dtllistTable),
                                              new SqlParameter("@columnNames", dtlColumnsWOID),
                                              new SqlParameter("@columnValues", ColumnValues));
                return objID;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// Code to update List detail
        /// </summary>
        /// <param name="columnValues">columnvalues :[ListValue],[ListDtlDesc],[SequenceNo],[GLAccountNo],[ChangeID],[ChangeDt] </param>
        /// <param name="itemID">list detail ID</param>
        public void UpdateListDetail(string columnValues, string itemID)
        {
            try
            {
                whereClause = "pListDetailID =" + itemID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                                             new SqlParameter("@tableName", dtllistTable),
                                             new SqlParameter("@columnNames", columnValues),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex) { }
        }
        /// <summary>
        /// Code to delete List detail
        /// </summary>
        /// <param name="itemID">list detail ID</param>
        public void DeleteListDetail(string itemID)
        {
            try
            {
                whereClause = "pListDetailID =" + itemID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", dtllistTable),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
            }

        } 
        #endregion

    }//End Class   

}//End Namespace