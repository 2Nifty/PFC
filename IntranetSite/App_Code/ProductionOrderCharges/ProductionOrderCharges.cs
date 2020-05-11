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

namespace PFC.IntranetSite
{
    /// <summary>
    /// Summary description for CarrierCode
    /// </summary>
    public class ProductionOrderCharge
    {
        //For Security Code
        string securityTable = "AvgCstProdOrderCharge";
        string connectionString = ConfigurationManager.AppSettings["ACConnectionString"].ToString();
        string whereClause = string.Empty;

        public ProductionOrderCharge()
        {
            //
            // TODO: Add constructor logic here
            //
        }


        public void UpdateProductionOrderCharges(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[ugen_sp_update]",
                             new SqlParameter("@tableName", securityTable),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void InsertProductionOrderCharges(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_insert]",
                             new SqlParameter("@tableName", securityTable),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }
        public void DeleteProductionOrderCharges(string ID)
        {
            try
            {
                whereClause = "pProdOrdChrgID ='" + ID + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Delete",
                                             new SqlParameter("@tableName", securityTable),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetProductionOrderCharges(string OrderNo)
        {
            string _whereClause = "ProductionOrderNo ='" + OrderNo + "'";
            string _columnName = "ProductionOrderNo ,ToAllocatebyWeight, ToAllocatebyPieces,EntryID,EntryDt,ChangeID,ChangeDt";
            DataSet dsOrder = new DataSet();
            dsOrder = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", securityTable),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsOrder.Tables[0];
        }

        public bool CheckProductionOrderChargesExist(string OrderNo)
        {
            string _whereClause = "ProductionOrderNo ='" + OrderNo + "'";
            DataSet dsLocationCode = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                        new SqlParameter("@tableName", securityTable),
                        new SqlParameter("@columnNames", "ProductionOrderNo"),
                        new SqlParameter("@whereClause", _whereClause));

            if (dsLocationCode.Tables[0].Rows.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
      
    }
}