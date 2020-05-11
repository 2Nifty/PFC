
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


namespace PFC.Intranet.InventoryReconsiliation
{
    /// <summary>
    /// Summary description for ROISalesReport
    /// </summary>
    public class InventoryReconsiliation
    {
        //
        // Global Variables Declaration
        //
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        
        public DataSet GetRecByLocation(string Location, string sortExpression)
        {
            try
            {
                string _tableName = "SumItemWMS";
                // string _columnName = "CAS_CategorySum.CatGrpNo,convert(varchar,CAS_CategorySum.CatGrpNo) + ' - '+ CAS_CategorySum.CatGrpDesc as CatGroup,TimePhase.ExtAvgCost,CAS_CategorySum.Roll12Sales ,(TimePhase.ExtAvgCost / CAS_CategorySum.Roll12Sales) as AvgCostSales,CAS_CategorySum.Roll12Sales/ CAS_CategorySum.Roll12Lbs as SalesLbs,Roll12GM / CAS_CategorySum.Roll12Lbs as GMLbs,'' as pctCorp,'' as pctCorpGM,'' as ROI";
                string _columnName = "ItemNo,ItemDesc,UOM,Location,isnull(Qty,0) as Qty,BookedQty,Qty-BookedQty as Variance,SuperEquiv,SuperEquivQty";
                string _whereClause = "Location='"+Location+"' and Qty-BookedQty <> 0";
                DataSet dsSalesCategoryPrefix = new DataSet();

                dsSalesCategoryPrefix = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + sortExpression));
                return dsSalesCategoryPrefix;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetBranchName()
        {
            
            try
            {
                string branch = HttpContext.Current.Session["BranchID"].ToString().Trim();
                if (HttpContext.Current.Session["BranchID"].ToString().Trim().Length == 1)
                {
                    branch = "0" + HttpContext.Current.Session["BranchID"].ToString();
                }

                string _tableName = "KPIBranches";                
                string _columnName = "Branch + ' - ' + BranchName";
                string _whereClause = "Branch='" + branch + "'";
                string branchLongName = string.Empty;

                branchLongName = SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_Select",
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
		
	public string GetBranchName(string branchId)
        {

            try
            {
                string branch = branchId.Trim();
                if (branchId.Trim().Length == 1)
                {
                    branch = "0" + branchId.ToString();
                }

                string _tableName = "KPIBranches";
                string _columnName = "Branch + ' - ' + BranchName";
                string _whereClause = "Branch='" + branch + "'";
                string branchLongName = string.Empty;

                branchLongName = SqlHelper.ExecuteScalar(connectionString, "UGEN_SP_Select",
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
    }
}