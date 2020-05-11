//Name Space Decleration
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

namespace PFC.Intranet.MaintenanceApps
//namespace PFC.Intranet.BusinessLogicLayer
{
    public class RepMasterBl
    {
        string tableName = "";
        string columnName = "";
        string whereClause = "";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        #region RepMaster data I/O
        #region Bind TreeViews
        //
        //Get the data to bind for the 'All Reps' TreeView
        //
        public DataTable RepTree(string whereCondition)
        {
            try
            {
                //
                //The RepTree is currently bound by joining RepMaster with LocMaster to get LocMaster.LocName
                //When/if RepMaster.LocationName is populated, the join to LocMaster will not be needed
                //
                //columnName = "Rep.RepNo + ' - ' + isnull(Rep.RepName,'') + ' - ' + isnull(Rep.LocationName,'') AS RepNode, RepNo";
                //tableName = "RepMaster Rep (NoLock)";
                //

                
                //columnName = "Rep.RepNo + ' - ' + isnull(Rep.RepName,'') + ' - ' + isnull(Loc.LocName,'') AS RepNode, RepNo";
                //tableName = "RepMaster Rep (NoLock) INNER JOIN LocMaster Loc (NoLock) ON Rep.LocationNo = Loc.LocID";
                columnName = "Rep.RepNo + ' - ' + isnull(Rep.RepName,'') AS RepNode, RepNo";
                tableName = "RepMaster Rep (NoLock)";
                whereClause = whereCondition + " Order By Rep.RepNo";

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                return dsDetails.Tables[0];
            }
            catch (Exception ex)
            { throw ex; }
        }

        //
        //
        //
        public DataTable LocTree(string whereCondition)
        {
            try
            {
                //
                //The LocTree is currently bound by joining RepMaster with LocMaster to get LocMaster.LocName
                //When/if RepMaster.LocationName is populated, the join to LocMaster will not be needed
                //
                //columnName = "Rep.LocationNo + ' - ' + isnull(Rep.LocationName,'') AS LocNode, Rep.LocationNo, Rep.RepNo + ' - ' + isnull(Rep.RepName,'') + ' - ' + isnull(Rep.LocationName,'') AS RepNode, RepNo";
                //tableName = "RepMaster Rep (NoLock)";
                //


                //columnName = "Rep.LocationNo + ' - ' + isnull(Loc.LocName,'') AS LocNode, Rep.LocationNo, Rep.RepNo + ' - ' + isnull(Rep.RepName,'') + ' - ' + isnull(Loc.LocName,'') AS RepNode, RepNo";
                columnName = "Rep.LocationNo + ' - ' + isnull(Loc.LocName,'') AS LocNode, Rep.LocationNo, Rep.RepNo + ' - ' + isnull(Rep.RepName,'') AS RepNode, RepNo";
                tableName = "RepMaster Rep (NoLock) INNER JOIN LocMaster Loc (NoLock) ON Rep.LocationNo = Loc.LocID";
                whereClause = whereCondition + " Order By Rep.LocationNo, Rep.RepNo";

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                return dsDetails.Tables[0];
            }
            catch (Exception ex)
            { throw ex; }
        }
        #endregion

        //
        //SELECT data from RepMaster
        //
        public DataTable GetRep(string searchType, string searchValue)  //2 arguments
        {
            string  _repNo, _repName;
            
            if (searchType == "RepNo")
            {
                _repNo = "%" + searchValue + "%";
                _repName = "";
            }
            else
            {
                _repNo = "";
                _repName = "%" + searchValue + "%";
            }
            
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "pMaintRepMaster",
                                                    new SqlParameter("@Action", "GetLike"),
                                                    new SqlParameter("@pRepMasterID", 0),
                                                    new SqlParameter("@RepNo", _repNo),
                                                    new SqlParameter("@RepName", _repName),
                                                    new SqlParameter("@RepPhoneNo", ""),
                                                    new SqlParameter("@RepFaxNo", ""),
                                                    new SqlParameter("@RepEmail", ""),
                                                    new SqlParameter("@RepClass", ""),
                                                    new SqlParameter("@RepStatus", ""),
                                                    new SqlParameter("@RepCustNo", ""),
                                                    new SqlParameter("@RepVendNo", ""),
                                                    new SqlParameter("@RepEmpNo", ""),
                                                    new SqlParameter("@RepSSN", "0"),
                                                    new SqlParameter("@RepNotes", ""),
                                                    new SqlParameter("@ClerkNo", "0"),
                                                    new SqlParameter("@Contact", ""),
                                                    new SqlParameter("@SalesOrgNo", ""),
                                                    new SqlParameter("@LocationNo", ""),
                                                    new SqlParameter("@LocationName", ""),
                                                    new SqlParameter("@TerritoryNo", "0"),
                                                    new SqlParameter("@SalesRegionNo", "0"),
                                                    new SqlParameter("@ManagersNo", ""),
                                                    new SqlParameter("@DistCtrNo", "0"),
                                                    new SqlParameter("@CustSupportRepNo", "0"),
                                                    new SqlParameter("@StdCommissionPct", "0"),
                                                    new SqlParameter("@FromZipRange", ""),
                                                    new SqlParameter("@ToZipRange", ""),
                                                    new SqlParameter("@UserID", ""));
                return dsResult.Tables[0].DefaultView.ToTable();
            }
            catch (Exception ex)
            { throw ex; }
        }

        //
        //INSERT/UPDATE RepMaster Record
        //
        public DataTable SaveRep(string recId, string RepNo, string RepName, string RepPhoneNo, string RepFaxNo, string RepEmail, string RepClass, 
                                 string RepStatus, string RepCustNo, string RepVendNo, string RepEmpNo, string RepSSN, string RepNotes,
                                 string ClerkNo, string Contact, string SalesOrgNo, string LocationNo, string LocationName, string TerritoryNo,
                                 int SalesRegionNo, string ManagersNo, string DistCtrNo, string CustSupportRepNo, decimal StdCommissionPct,
                                 string FromZipRange, string ToZipRange, string UserID, string SaveMode)
        {
            try
            {

                DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "pMaintRepMaster",
                                    new SqlParameter("@Action", SaveMode),              //saveMode ('Add' or 'Update') will determine if we are Inserting or Updating the record
                                    new SqlParameter("@pRepMasterID", recId),
                                    new SqlParameter("@RepNo", RepNo),
                                    new SqlParameter("@RepName", RepName),
                                    new SqlParameter("@RepPhoneNo", RepPhoneNo),
                                    new SqlParameter("@RepFaxNo", RepFaxNo),
                                    new SqlParameter("@RepEmail", RepEmail),
                                    new SqlParameter("@RepClass", RepClass),
                                    new SqlParameter("@RepStatus", RepStatus),
                                    new SqlParameter("@RepCustNo", RepCustNo),
                                    new SqlParameter("@RepVendNo", RepVendNo),
                                    new SqlParameter("@RepEmpNo", RepEmpNo),
                                    new SqlParameter("@RepSSN", RepSSN),
                                    new SqlParameter("@RepNotes", RepNotes),
                                    new SqlParameter("@ClerkNo", ClerkNo),
                                    new SqlParameter("@Contact", Contact),
                                    new SqlParameter("@SalesOrgNo", SalesOrgNo),
                                    new SqlParameter("@LocationNo", LocationNo),
                                    new SqlParameter("@LocationName", LocationName),    //Currently we are not updating LocName (Outstanding)
                                    new SqlParameter("@TerritoryNo", TerritoryNo),
                                    new SqlParameter("@SalesRegionNo", SalesRegionNo),
                                    new SqlParameter("@ManagersNo", ManagersNo),
                                    new SqlParameter("@DistCtrNo", DistCtrNo),
                                    new SqlParameter("@CustSupportRepNo", CustSupportRepNo),
                                    new SqlParameter("@StdCommissionPct", StdCommissionPct),
                                    new SqlParameter("@FromZipRange", FromZipRange),
                                    new SqlParameter("@ToZipRange", ToZipRange),
                                    new SqlParameter("@UserID", UserID));

                return dsResult.Tables[0].DefaultView.ToTable();

            }
            catch (Exception ex)
            { throw ex; }
        }

        //
        //Check RepMaster for duplicate RepNo
        //
        public DataTable DupRep(string _repNo)
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "pMaintRepMaster",
                                                    new SqlParameter("@Action", "Dup"),
                                                    new SqlParameter("@pRepMasterID", 0),
                                                    new SqlParameter("@RepNo", _repNo),
                                                    new SqlParameter("@RepName", ""),
                                                    new SqlParameter("@RepPhoneNo", ""),
                                                    new SqlParameter("@RepFaxNo", ""),
                                                    new SqlParameter("@RepEmail", ""),
                                                    new SqlParameter("@RepClass", ""),
                                                    new SqlParameter("@RepStatus", ""),
                                                    new SqlParameter("@RepCustNo", ""),
                                                    new SqlParameter("@RepVendNo", ""),
                                                    new SqlParameter("@RepEmpNo", ""),
                                                    new SqlParameter("@RepSSN", "0"),
                                                    new SqlParameter("@RepNotes", ""),
                                                    new SqlParameter("@ClerkNo", "0"),
                                                    new SqlParameter("@Contact", ""),
                                                    new SqlParameter("@SalesOrgNo", ""),
                                                    new SqlParameter("@LocationNo", ""),
                                                    new SqlParameter("@LocationName", ""),
                                                    new SqlParameter("@TerritoryNo", "0"),
                                                    new SqlParameter("@SalesRegionNo", "0"),
                                                    new SqlParameter("@ManagersNo", ""),
                                                    new SqlParameter("@DistCtrNo", "0"),
                                                    new SqlParameter("@CustSupportRepNo", "0"),
                                                    new SqlParameter("@StdCommissionPct", "0"),
                                                    new SqlParameter("@FromZipRange", ""),
                                                    new SqlParameter("@ToZipRange", ""),
                                                    new SqlParameter("@UserID", ""));

                return dsResult.Tables[0].DefaultView.ToTable();
            }
            catch (Exception ex)
            { throw ex; }
        }

        //
        //Delete selected RepMaster record
        //
        public void DelRep(string _recId)
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "pMaintRepMaster",
                                                    new SqlParameter("@Action", "Delete"),
                                                    new SqlParameter("@pRepMasterID", _recId),
                                                    new SqlParameter("@RepNo", ""),
                                                    new SqlParameter("@RepName", ""),
                                                    new SqlParameter("@RepPhoneNo", ""),
                                                    new SqlParameter("@RepFaxNo", ""),
                                                    new SqlParameter("@RepEmail", ""),
                                                    new SqlParameter("@RepClass", ""),
                                                    new SqlParameter("@RepStatus", ""),
                                                    new SqlParameter("@RepCustNo", ""),
                                                    new SqlParameter("@RepVendNo", ""),
                                                    new SqlParameter("@RepEmpNo", ""),
                                                    new SqlParameter("@RepSSN", "0"),
                                                    new SqlParameter("@RepNotes", ""),
                                                    new SqlParameter("@ClerkNo", "0"),
                                                    new SqlParameter("@Contact", ""),
                                                    new SqlParameter("@SalesOrgNo", ""),
                                                    new SqlParameter("@LocationNo", ""),
                                                    new SqlParameter("@LocationName", ""),
                                                    new SqlParameter("@TerritoryNo", "0"),
                                                    new SqlParameter("@SalesRegionNo", "0"),
                                                    new SqlParameter("@ManagersNo", ""),
                                                    new SqlParameter("@DistCtrNo", "0"),
                                                    new SqlParameter("@CustSupportRepNo", "0"),
                                                    new SqlParameter("@StdCommissionPct", "0"),
                                                    new SqlParameter("@FromZipRange", ""),
                                                    new SqlParameter("@ToZipRange", ""),
                                                    new SqlParameter("@UserID", ""));

                return;
            }
            catch (Exception ex)
            { throw ex; }
        }
        #endregion

        #region Bind DropdownList
        //
        //Bind a ListControl using a specific WHERE statement
        //
        public void BindListControls(ListControl lstControl, string strTable, string textField, string valueField, string strWhere, string defaultValue, string columnName)
        {
            try
            {
                string column = (columnName != "") ? columnName + "," + valueField : textField + "," + valueField;
                DataTable dtSource = GetBindListData(strTable, column, strWhere);
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

        //
        //SELECT the data to be bound to the ListControl from BindListControls above
        //
        public DataTable GetBindListData(string tableName, string columnName, string whereClause)
        {
            try
            {

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

        //
        //SELECT the data to be bound to a ListControl based on a specific ListName (ListMaster/ListDetail)
        //
        public DataTable GetListDetails(string listName)
        {
            try
            {
                string _tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
                string _columnName = "LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc, LD.ListValue ";
                string _whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID order by SequenceNo asc";
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
        #endregion  
    }
}