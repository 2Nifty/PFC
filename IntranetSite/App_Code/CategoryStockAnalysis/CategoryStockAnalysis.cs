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

/// <summary>
/// Summary description for CategoryStackAnalysis
/// </summary>
public class CategoryStockAnalysis
{
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    const string vCATSTKSUMMARY = "vCatStkSummary";
    const string CATSTKDETAIL = "CatStkDetail";
    const string LISTMASTER = "ListDetail INNER JOIN ListMaster ON ListDetail.fListMasterID = ListMaster.pListMasterID";

    public DataTable GetCategoryList()
    {
        try
        {
            string _columnName = "ListDetail.Listvalue as category ,ListDetail.Listvalue + ' - ' + ListDetail.ListDtlDesc as CategoryDesc";
            string _whereClause = "ListMaster.ListName = 'CategoryDesc' Order by Category Asc";

            DataSet dsCategory = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", LISTMASTER),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));
            return dsCategory.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetPlatingType()
    {
        try
        {
            string _columnName = "distinct platingNo";
            string _whereClause = "1=1 Order by platingNo Asc";
            DataSet dtCategory = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", vCATSTKSUMMARY),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));

            return dtCategory.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetBranchLevelStock(string categoryNumber, string platingNumber)
    {
        try
        {
            string _whereClause = string.Empty;
            if (platingNumber != "")
                _whereClause = "platingNo='" + platingNumber + "' and ";

            string _columnName = " (LocationCode +'-' + LocationName) as LocationName,LocationCode,sum(ItemCount) as ItemCount,sum(SKUCount) as SKUCount,sum(TotUse30) as Use30D,sum(AvailQty) as QtyOnHand," +
                                 "cast(isnull(sum(Rop_Calc),0) as decimal(25,1)) as ROP,cast(isnull(sum(ExtSoldWght),0) as decimal(25,0)) as UseLbs30D,cast(isnull(sum(AvailQtyWght),0) as decimal(25,0)) as QtyOnHandLbs,case when (isnull(sum(ExtSoldWght),0))=0 then 0 else cast(isnull(sum(AvailQtyWght),0)/isnull(sum(ExtSoldWght),0) as decimal(25,1)) end as MonthsOnHand";

            _whereClause += "category='" + categoryNumber + "' group by LocationCOde,LocationName order by LocationCode asc";

            DataSet dtCategory = new DataSet();
            SqlConnection conn = new SqlConnection(connectionString);
            SqlDataAdapter adp;
            SqlCommand Cmd = new SqlCommand();
            Cmd.CommandTimeout = 0;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Connection = conn;
            conn.Open();
            Cmd.CommandText = "UGEN_SP_Select";
            Cmd.Parameters.Add(new SqlParameter("@tableName", vCATSTKSUMMARY));
            Cmd.Parameters.Add(new SqlParameter("@columnNames", _columnName));
            Cmd.Parameters.Add(new SqlParameter("@whereClause", _whereClause));

            adp = new SqlDataAdapter(Cmd);
            adp.Fill(dtCategory);

            return dtCategory.Tables[0];
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public DataTable GetBranchAndCategoryLevelStock(string branchID, string categoryNumber, string platingNumber)
    {
        try
        {
            string _columnName = "ItemNo,Description,TotUse30,AvailQty,cast(isnull(Rop_Calc,0) as decimal(25,1)) as ROP," +
                                 "cast(isnull(ExtSoldWght,0) as decimal(25,0))  as UseLbs30D,cast(isnull(AvailQtyWght,0) as decimal(25,0)) as QtyOnHandLbs," +
                                 "cast(isnull(MonthsOH,0) as decimal(25,1)) as MonthsOnHand";

            string _whereClause = string.Empty;

            if (platingNumber != "")
                _whereClause = "category='" + categoryNumber + "' and platingNo='" + platingNumber + "' and LocationCode='" + branchID + "' order by ItemNo,PlatingNo";
            else
                _whereClause = "category='" + categoryNumber + "' and LocationCode='" + branchID + "' order by ItemNo,PlatingNo";

            DataSet dtCategory = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", CATSTKDETAIL),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));

            return dtCategory.Tables[0];
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public DataTable GetItemAndBranchLevelStock(string itemNumber)
    {
        try
        {
            string _columnName = " (LocationCode +'-' + LocationName) as LocationName,LocationCode,SalesVelCode,CatVelCode,cast(isnull(Rop_Calc,0) as decimal(25,1)) as ROP," +
                                 "TotUse30,cast(isnull(MonthsOH,0) as decimal(25,1)) as MonthsOnHand";

            string _whereClause = string.Empty;

            _whereClause = "ItemNo='" + itemNumber + "' order by Locationcode";

            DataSet dtCategory = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", CATSTKDETAIL),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));

            return dtCategory.Tables[0];
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

}
