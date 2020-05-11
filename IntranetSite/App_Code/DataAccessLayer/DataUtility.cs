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

namespace PFC.Intranet.DataAccessLayer
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
                _columnName = "LD.ListValue, LD.ListDtlDesc as ListDesc";
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

        public string GetListDtlDesc(string listName, string listValue)
        {
            try
            {
                _tableName = "ListMaster (NoLock) LM, ListDetail (NoLock) LD";
                _columnName = "LD.ListDtlDesc";
                _whereClause = "LM.ListName = '" + listName + "' AND LD.ListValue = '" + listValue + "' AND LD.fListMasterID = LM.pListMasterID Order By SequenceNo ASC";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0].Rows[0]["ListDtlDesc"].ToString();
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #region LocList

        public void BindLocList(string defaultString, DropDownList ddlList, string whereClause)
        {
            DataTable dtList = GetLocList(whereClause);
            if (dtList != null)
            {
                ddlList.DataSource = dtList;
                ddlList.DataTextField = "Desc";
                ddlList.DataValueField = "ListValue";
                ddlList.DataBind();
            }
            ddlList.Items.Insert(0, new ListItem(defaultString, ""));
        }

        public DataTable GetLocList(string whereClause)
        {
            string tableName = "LocMaster (NoLock)";
            string columnName = "LocID as [ListValue], LocID + ' - ' + LocName as [Desc]";
            //string columnName = "LocID as [ListValue], LocID as [Desc]";

            DataSet dsListValue = new DataSet();
            dsListValue = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
            return dsListValue.Tables[0];
        }

        #endregion  //LocList

        #endregion  //DropDownList

    }
}