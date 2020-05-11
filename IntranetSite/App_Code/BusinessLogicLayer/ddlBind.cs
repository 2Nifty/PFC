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
//using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Public class file used to support common maintenance and reporting dropdowns
    /// </summary>
    public class ddlBind
    {
        #region Property Bag

        // Declare listValue property of type string:
        string _defaultValue = "ALL";
        public string DefaultValue
        {
            get
            {
                return _defaultValue;
            }
            set
            {
                _defaultValue = value;
            }
        }

        // Declare listDesc property of type string:
        string _defaultDesc = "---- All ----";
        public string DefaultDesc
        {
            get
            {
                return _defaultDesc;
            }
            set
            {
                _defaultDesc = value;
            }
        }

        #endregion

        #region variable declaration

        string cnERP = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string tableName = "";
        string columnName = "";
        string whereClause = "";

        #endregion

        #region Bind DropDownLists

        //Build DropDownList values from any ListMaster/ListDetail (ListValue - ListDtlDesc)
        public void BindFromList(string listName, ListControl ctlName, string defValue, string defDesc)
        {
            tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
            columnName = "LD.ListValue, LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc ";
            whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID ORDER BY ListValue ASC";

            ddlBindControl(ctlName, ddlTable(tableName, columnName, whereClause), "ListValue", "ListDesc", defValue, defDesc);
        }

        //Build DropDownList values from any ListMaster/ListDetail (ListDtlDesc)
        public void BindDscFromList(string listName, ListControl ctlName, string defValue, string defDesc)
        {
            tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
            columnName = "LD.ListValue, LD.ListDtlDesc as ListDesc ";
            whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID ORDER BY ListDtlDesc ASC";

            ddlBindControl(ctlName, ddlTable(tableName, columnName, whereClause), "ListValue", "ListDesc", defValue, defDesc);
        }

        //Build DropDownList values from any ListMaster/ListDetail (ListValue)
        public void BindValueFromList(string listName, ListControl ctlName, string defValue, string defDesc)
        {
            tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
            columnName = "LD.ListValue, LD.ListValue as ListDesc ";
            whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID ORDER BY ListValue ASC";

            ddlBindControl(ctlName, ddlTable(tableName, columnName, whereClause), "ListValue", "ListDesc", defValue, defDesc);
        }

        //Build DropDownList values from any [Tables] table type (TableCd + ShortDsc)
        public void BindFromTable(string tblType, ListControl ctlName, string defValue, string defDesc)
        {
            tableName = "[Tables] (NOLOCK) ";
            columnName = "TableCd + ' - ' + ShortDsc as ListDesc, TableCd as ListValue";
            whereClause = " TableType='" + tblType + "' ORDER BY TableCd ASC";

            ddlBindControl(ctlName, ddlTable(tableName, columnName, whereClause), "ListValue", "ListDesc", defValue, defDesc);
        }

        //Build DropDownList values from any [Tables] table type (Dsc)
        public void BindDscFromTable(string tblType, ListControl ctlName, string defValue, string defDesc)
        {
            tableName = "[Tables] (NOLOCK) ";
            columnName = "Dsc + ' - ' + ShortDsc as ListDesc, Dsc as ListValue";
            whereClause = " TableType='" + tblType + "' ORDER BY Dsc ASC";

            ddlBindControl(ctlName, ddlTable(tableName, columnName, whereClause), "ListValue", "ListDesc", defValue, defDesc);
        }

        //Build Location DropDownList from Session["BranchComboValues"]
        public void BindLoc_BranchComboValues(DropDownList ddlLoc)
        {
            try
            {
                ddlLoc.DataSource = System.Web.HttpContext.Current.Session["BranchComboValues"] as DataSet;
                ddlLoc.DataTextField = "Name";
                ddlLoc.DataValueField = "Branch";
                ddlLoc.DataBind();

                //Defaults for the BranchCombovalues should be set by the calling program
                //ddlLoc.Items.Insert(0, new ListItem("ALL", System.Web.HttpContext.Current.Session["BranchIDForALL"].ToString() + " "));
            }
            catch (Exception ex)
            {

            }
        }

        //Bind DropDownList
        public void ddlBindControl(ListControl ctlName, DataTable dtList, string valueField, string descField, string defValue, string defDesc)
        {
            try
            {
                if (dtList != null && dtList.Rows.Count > 0)
                {
                    ctlName.DataSource = dtList;
                    ctlName.DataTextField = descField;
                    ctlName.DataValueField = valueField;
                    ctlName.DataBind();

                    if (defValue.ToString().ToUpper() == "ALL" && defDesc.ToString().ToUpper() == "ALL")
                    {
                        defDesc = _defaultDesc;
                        defValue = _defaultValue;
                    }

                    if (defDesc.Length > 0)
                        ctlName.Items.Insert(0, new ListItem(defDesc, defValue));
                }
                else
                {
                    if (ctlName.ID.IndexOf("lst") == -1)
                    {
                        ctlName.Items.Clear();
                        ctlName.Items.Insert(0, new ListItem("N/A", ""));
                    }

                }
            }
            catch (Exception ex) { }
        }

        #endregion

        #region Data Table Utility

        public DataTable ddlTable(string _tableName, string _columnName, string _whereClause)
        {
            try
            {
                DataSet dsType = SqlHelper.ExecuteDataset(cnERP, "UGEN_SP_Select",
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

        #endregion
    }
}