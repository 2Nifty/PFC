using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace PFC.WOE.DataAccessLayer
{
    public class DataUtility
    {
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        #region TableIO

        public DataTable GetTableData(string tableName, string columnName, string whereClause)
        {
            try
            {
                DataSet dsData = new DataSet();
                dsData = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsData.Tables[0];
            }
            catch (Exception ex)
            { throw ex; }
        }

        public void UpdateTableData(string tableName, string columnName, string whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", tableName),
                             new SqlParameter("@columnNames", columnName),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            { throw ex; }
        }

        #endregion

        #region DropDownList

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

                    if(defaultValue != "")
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

        public DataTable GetListDetails(string listName)
        {
            try
            {
                _tableName = "ListMaster (NoLock) LM, ListDetail (NoLock) LD";
                _columnName = "LD.ListValue, LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc";
                _whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID Order By SequenceNo ASC";
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

        public void SetListControlValue(DropDownList ddlControl, string value)
        {
            ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
            if (lItem != null)
                ddlControl.SelectedValue = value;
        }

        //public string GetListDtlDesc(string listName, string listValue)
        //{
        //    try
        //    {
        //        _tableName = "ListMaster (NoLock) LM, ListDetail (NoLock) LD";
        //        _columnName = "LD.ListDtlDesc";
        //        _whereClause = "LM.ListName = '" + listName + "' AND LD.ListValue = '" + listValue + "' AND LD.fListMasterID = LM.pListMasterID Order By SequenceNo ASC";
        //        DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
        //                            new SqlParameter("@tableName", _tableName),
        //                            new SqlParameter("@columnNames", _columnName),
        //                            new SqlParameter("@whereClause", _whereClause));
        //        return dsType.Tables[0].Rows[0]["ListDtlDesc"].ToString();
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        #region DropDownList(Tables table)

        public void BindListFromTables(string defaultString, ListControl ddlList, string whereClause)
        {
            DataTable dtList = GetListFromTables(whereClause);
            if (dtList != null)
            {
                ddlList.DataSource = dtList;
                ddlList.DataTextField = "Desc";
                ddlList.DataValueField = "ListValue";
                ddlList.DataBind();
            }

            if (defaultString != "")
                ddlList.Items.Insert(0, new ListItem(defaultString, ""));
        }

        public DataTable GetListFromTables(string whereClause)
        {
            string tableName = "Tables (NoLock)";
            string columnName = "TableCd as [ListValue], TableCd + ' - ' + ShortDsc as [Desc]";

            DataSet dsListValue = new DataSet();
            dsListValue = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
            return dsListValue.Tables[0];
        }

        //public string GetShortDscFromTables(string tableCode, string whereClause)
        //{
        //    try
        //    {
        //        _tableName = "Tables (NoLock)";
        //        _columnName = "ShortDsc";
        //        _whereClause = whereClause + " AND TableCd = '" + tableCode + "'";
        //        DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
        //                            new SqlParameter("@tableName", _tableName),
        //                            new SqlParameter("@columnNames", _columnName),
        //                            new SqlParameter("@whereClause", _whereClause));
        //        return dsType.Tables[0].Rows[0]["ShortDsc"].ToString();
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        #endregion  //DropDownList(Tables table)

        #region LocList

        public void BindLocList(string defaultString, ListControl ddlList, string whereClause)
        {
            DataTable dtList = GetLocList(whereClause);
            if (dtList != null)
            {
                ddlList.DataSource = dtList;
                ddlList.DataTextField = "Desc";
                ddlList.DataValueField = "ListValue";
                ddlList.DataBind();
            }
            if (defaultString != "")
                ddlList.Items.Insert(0, new ListItem(defaultString, ""));
        }

        public DataTable GetLocList(string whereClause)
        {
            //string whereClause = "MaintainIMQtyInd='Y' AND LocType='M' ORDER BY LocID";
            //string whereClause = "LocType='M' ORDER BY LocID";
            string tableName = "LocMaster (NoLock)";
            //string columnName = "LocID as [ListValue], LocID as [Desc]";
            string columnName = "LocID as [ListValue], LocID + ' - ' + LocName as [Desc]";

            DataSet dsListValue = new DataSet();
            dsListValue = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
            return dsListValue.Tables[0];
        }

        #endregion  //LocList

        #region WorkSheetUserList

        public void BindWorkSheetUserList(string defaultString, ListControl ddlList)
        {
            DataTable dtList = GetWorksheetIDs();
            if (dtList != null)
            {
                ddlList.DataSource = dtList;
                ddlList.DataTextField = "EntryID";
                ddlList.DataValueField = "EntryID";
                ddlList.DataBind();
            }
            if (defaultString != "")
                ddlList.Items.Insert(0, new ListItem(defaultString, ""));
        }

        private DataTable GetWorksheetIDs()
        {
            try
            {
                // Local variable declaration
                string _tableName = "WOWorkSheet";
                string _columnName = "EntryID";
                string _whereClause = "1=1 group by EntryID";
                DataSet dsListValue = new DataSet();
                dsListValue = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));
                return dsListValue.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        #endregion  //WorkSheetUserList

        public DataTable GetUsers()
        {
            try
            {
                _tableName = "SecurityUsers";
                _columnName = "UserName as Code,UserName as Name";
                _whereClause = "1=1 Order By UserName";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
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

        public DataTable GetRoutes()
        {
            try
            {
                _tableName = "ItemMaster";
                _columnName = "ItemNo as Code,ItemNo as Name";
                _whereClause = " ItemMaster.ItemStat = 'M' group by ItemNo ";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
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

        #endregion  //DropDownList

    }
}