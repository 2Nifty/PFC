using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net;
using System.Text;
using System.IO;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using System.Data.SqlClient;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for BackOrderReport
    /// </summary>
    public class BackOrderReport
    {
        string PFCERPconnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"]; 
        //string PFCERPconnectionString = "workstation id=PFCDEVDB;packet size=4096;user id=pfcnormal;data source=PFCDEVDB;persist security info=True;initial catalog=PERP;password=pfcnormal";
        string securityTable = "SecurityMembers (NOLOCK)  sm LEFT OUTER JOIN SecurityUsers (NOLOCK) su on sm.SecUserID = su.pSecUserID LEFT OUTER JOIN SecurityGroups (NOLOCK)  sg on sm.SecGroupID = sg.pSecGroupID";

        public DataSet GetItemNo(string itemNo, string where)
        {
            //
            // Declare the variables
            //
            string _tableName = "ItemAlias";
            string _columnNames = "ItemNo";
            string _whereClause = where;

            //
            // To get the Active Field value of the current session
            //

            DataSet dsUserName = (DataSet)SqlHelper.ExecuteDataset(PFCERPconnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
            return dsUserName;

        }

        public DataTable GetExecutiveBranchItemSummary(string _whereClause)
        {
            string _tableName = @"SODetailRel LEFT OUTER JOIN
			                        SOHeaderRel ON SODetailRel.fSOHeaderRelID = SOHeaderRel.pSOHeaderRelID";

            string _columnNames = @"SODetailRel.ItemNo, 
                                    SODetailRel.ItemDsc, 
                                    SOHeaderRel.OrderLoc,
                                    SOHeaderRel.ShipLoc, 
                                    Sum(cast(QtyOrdered as decimal(18,0))) as QtyOrdered";

            string _groupBy = " GROUP BY ItemNo,ItemDsc,OrderLoc,ShipLoc";

            DataSet dsUserName = (DataSet)SqlHelper.ExecuteDataset(PFCERPconnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause + _groupBy));
            return dsUserName.Tables[0];

        }

        public DataTable GetExecutiveBranchItemDetail(string _whereClause)
        {
            string _tableName = "SOHeaderRel Inner join SODetailRel on SOHeaderRel.pSOHeaderRelID = SODetailRel.fSOHeaderRelID";
            string _columnNames = @"SODetailRel.pSODetailRelID,
                                    SOHeaderRel.OrderLoc,
                                    SOHeaderRel.ShipLoc,                                    
                                    SODetailRel.RqstdShipDt,
                                    SOHeaderRel.OrderType,
                                    SODetailRel.ItemNo,
                                    SODetailRel.ItemDsc,
                                    SOHeaderRel.SellToCustNo,
                                    SOHeaderRel.SellToCustName,
                                    SOHeaderRel.OrderNo,
                                    SOHeaderRel.SalesRepNo,
                                    cast(SODetailRel.QtyOrdered as decimal(18,0)) as QtyOrdered,
                                    SODetailRel.NetUnitPrice,
                                    SODetailRel.UnitCost,
                                    SODetailRel.ExtendedPrice,
                                    SODetailRel.ExtendedCost,
                                    SODetailRel.ExtendedNetWght,
                                    SODetailRel.ExtendedGrossWght,
                                    SODetailRel.BinLoc,
                                    CASE SODetailRel.NetUnitPrice WHEN 0 THEN 0.0 ELSE CAST(((SODetailRel.NetUnitPrice  - SODetailRel.UnitCost3) / SODetailRel.NetUnitPrice *100)as decimal(18,1)) END as RepCost,
		                            CASE SODetailRel.NetUnitPrice WHEN 0 THEN 0.0 ELSE CAST(((SODetailRel.NetUnitPrice  - SODetailRel.UnitCost) / SODetailRel.NetUnitPrice *100) as decimal(18,1)) END as AvgCost ";

            DataSet dsUserName = (DataSet)SqlHelper.ExecuteDataset(PFCERPconnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
            return dsUserName.Tables[0];

        }

        public DataTable GetAvaliableQty(string itemNumber, string locCode)
        {
            try
            {
                string spName = "[pBackOrdRptGetItemQty]";
                DataSet dsAvaiqty = SqlHelper.ExecuteDataset(PFCERPconnectionString, spName,
                                            new SqlParameter("@ItemNo", itemNumber),                                            
                                            new SqlParameter("@locCode", locCode));
                                            //new SqlParameter("@ItemNoRange", ItemNumber2)

                return dsAvaiqty.Tables[0];
            }
            catch (Exception ex)
            {

                throw ex;
            }
           
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
        public string  GetLocation(string strLocCode)
        {
            //
            // Declare the variables
            //
            string _tableName = "LocMaster";
            string _columnNames = "LocName";
            string _whereClause = "LocID='" + strLocCode + "'";
            string _result = "";
            //
            // To get the Active Field value of the current session
            //

            DataSet dsUserName = (DataSet)SqlHelper.ExecuteDataset(PFCERPconnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
            _result = dsUserName.Tables[0].Rows[0]["LocName"].ToString();
            return _result;

        }
        public string GetApplicationSecurity(string strAppType,string SecUserID)
        {
            try
            {

                string result = "";
                DataSet dsSecuritycode = SqlHelper.ExecuteDataset(PFCERPconnectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", "SecurityMembers (NOLOCK) sm LEFT OUTER JOIN SecurityGroups (NOLOCK) sg.pSecGroupID=sm.SecGroupID"),
                    new SqlParameter("@columnNames", "Distinct sg.pSecGroupID, sm.pSecMembersID"),
                    new SqlParameter("@whereClause", "sg.SecGroupName =	CASE WHEN ('"+strAppType+"' = 'BORpts') THEN 'BORpts (W)' WHEN (apptypeparam = 'CustMstr') THEN 'Cust(W)'	END	AND sm.SecUserID=("+SecUserID+")"));

                if (dsSecuritycode.Tables[0].Rows.Count >= 0)
                {
                    string strDeleteDt = dsSecuritycode.Tables[0].Rows[0]["pSecGroupID"].ToString();
                    if (strDeleteDt =="")
                        result = "";
                    else
                        result = dsSecuritycode.Tables[0].Rows[0]["pSecGroupID"].ToString();
                    
                }
                   
                else
                    result = "";
                return result;

            }
            catch (Exception Ex) { return ""; }
        }
        public DataTable GetSecurityCode(string userName)
        {
            try
            {


                DataSet dsSecuritycode = SqlHelper.ExecuteDataset(PFCERPconnectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "Distinct su.DeleteDt,su.pSecUserID, sg.pSecGroupID, sm.pSecMembersID"),
                    new SqlParameter("@whereClause", "su.UserName='" + userName + "' AND sg.groupname='Reports (W)'"));

                
               return dsSecuritycode.Tables[0];
                

            }
            catch (Exception Ex) 
            {
                throw Ex;
            }

        }
    }

}
