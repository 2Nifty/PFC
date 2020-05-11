using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Data.SqlClient;
using PFC.WOE.DataAccessLayer;

namespace PFC.WOE.BusinessLogicLayer
{
    public enum FormStatus
    {
        WOOpened,
        WOClosed,
        WOnReadOnlyMode
    }

    public class WOEntry
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        #region WOE Main Screen Methods

        public bool CheckWONumberAndInitiateSessionVariables(string woNumber)
        {
            DataSet dsWOData = GetWOEData("checkwoavailability", woNumber);
            if (dsWOData != null && dsWOData.Tables.Count >0 && dsWOData.Tables[0].Rows.Count > 0)
            {
                HttpContext.Current.Session["POHeaderTableName"] = dsWOData.Tables[0].Rows[0]["HeaderTableName"];
                HttpContext.Current.Session["PODetailTableName"] = dsWOData.Tables[0].Rows[0]["DetailTableName"];
                HttpContext.Current.Session["WOCompTableName"] = dsWOData.Tables[0].Rows[0]["WOCompTableName"];
                HttpContext.Current.Session["POHeaderColumnName"] = dsWOData.Tables[0].Rows[0]["POHeaderColumnName"];
                HttpContext.Current.Session["POHeaderID"] = dsWOData.Tables[0].Rows[0]["POHeaderID"];
                return true;
            }

            return false;
        }
        
        public DataSet GetWOEData(string requestSource, string searchFilter)
        {
            DataSet dsResult = new DataSet();
            dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOEntryFrm]",
                                new SqlParameter("@source", requestSource),
                                new SqlParameter("@searchFilter", searchFilter),
                                new SqlParameter("@POHeaderTableName", HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower()));

            return dsResult;
        }

        public DataSet GetContactData(string requestSource, string searchFilter)
        {
            DataSet dsResult = new DataSet();
            dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOGetContactDetail]",
                                new SqlParameter("@source", requestSource),
                                new SqlParameter("@searchFilter", searchFilter));

            return dsResult;
        }

        public DataTable InsertWOHeader(string locCode, string entryId)
        {
            try
            {
                DataSet dsWOHeader = new DataSet();
                dsWOHeader = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOCreateNo]",
                                    new SqlParameter("@locCode", locCode),
                                    new SqlParameter("@entryId", entryId));
                if (dsWOHeader != null)
                    return dsWOHeader.Tables[0];

                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string InsertPODetail(string itemNo, string poHeaderId, string entryId)
        {
            try
            {
                string pSODetailId = "0";
                object result = SqlHelper.ExecuteScalar(ERPConnectionString, "[pWOCreateWODetail]",
                                    new SqlParameter("@itemNo", itemNo),
                                    new SqlParameter("@poHeaderId", poHeaderId),
                                    new SqlParameter("@entryId", entryId));
                if(result!= null)
                    pSODetailId = result.ToString();

                return pSODetailId;
            }
            catch (Exception ex)
            {
                return "0";
            }
        }

        public void ReExtendWOLines(string pPOHeaderID,int qtyToMfg, string entryId)
        {
            try
            {                
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pWOReExtendWOCompLines]",
                                    new SqlParameter("@fPoHeaderId", pPOHeaderID),
                                    new SqlParameter("@qtyToMfg", qtyToMfg),
                                    new SqlParameter("@entryId", entryId));                
            }
            catch (Exception ex)
            {               
            }
        }

        public DataTable UpdateWOGridLines(string fieldType, string fieldValue,string woCompId, string entryId)
        {
            try
            {
                DataSet dsWOLine = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOUpdateWOCompGridLine]",
                                    new SqlParameter("@fieldType", fieldType),
                                    new SqlParameter("@fieldValue", fieldValue),
                                    new SqlParameter("@pWoCompId", woCompId),
                                    new SqlParameter("@entryId", entryId));
                if (dsWOLine != null)
                    return dsWOLine.Tables[0];

                return null;

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetItemDetail(string itemNo, string locCode)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOGetItemDetail]",
                                    new SqlParameter("@itemNo", itemNo),
                                    new SqlParameter("@locCode", locCode));
                if (dsResult != null)
                    return dsResult.Tables[0];

                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public Boolean CheckItem(string itemNo)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOEntryFrm]",
                                    new SqlParameter("@source", "checkItem"),
                                    new SqlParameter("@searchFilter", itemNo),
                                    new SqlParameter("@POHeaderTableName", ""));
                if ((dsResult != null) && (dsResult.Tables[0].Rows.Count > 0))
                    return true;

                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public String CheckItemStr(string itemNo)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOEntryFrm]",
                                    new SqlParameter("@source", "checkItem"),
                                    new SqlParameter("@searchFilter", itemNo),
                                    new SqlParameter("@POHeaderTableName", ""));
                if ((dsResult != null) && (dsResult.Tables[0].Rows.Count > 0))
                    return true.ToString();

                return false.ToString();
            }
            catch (Exception ex)
            {
                return ex.ToString();
            }
        }

        public Boolean CheckBOM(string itemNo)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOEntryFrm]",
                                    new SqlParameter("@source", "checkBOM"),
                                    new SqlParameter("@searchFilter", itemNo),
                                    new SqlParameter("@POHeaderTableName", ""));
                if ((dsResult != null) && (dsResult.Tables[0].Rows.Count > 0))
                    return true;

                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public Boolean GetUOM(string itemNo, string UOM)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOEntryFrm]",
                                    new SqlParameter("@source", "GetUOM"),
                                    new SqlParameter("@searchFilter", itemNo + "," + UOM),
                                    new SqlParameter("@POHeaderTableName", HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower()));
                if ((dsResult != null) && (dsResult.Tables[0].Rows.Count > 0))
                    return true;

                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public string GetWOPickStatus(DataTable dtWOHeader)
        {
            if (dtWOHeader.Rows[0]["HoldDt"].ToString() != "") // For HW & HI orders
            {
                if (dtWOHeader.Rows[0]["HoldReason"].ToString().Trim() == "HW")
                {
                    return "On Hold";
                }
                if (dtWOHeader.Rows[0]["HoldReason"].ToString().Trim() == "HI")
                {
                    if (dtWOHeader.Rows[0]["ConfirmShipDt"].ToString() != "")
                        return "Shipped";
                    else if (dtWOHeader.Rows[0]["PickCompDt"].ToString() != "")
                        return "Picked";
                    else if (dtWOHeader.Rows[0]["PickDt"].ToString() != "")
                        return "Picking";
                    else if (dtWOHeader.Rows[0]["RlsWhseDt"].ToString() != "")
                        return "Warehouse";
                    else
                        return "Pending";
                }
            }
            else
            {
                if (dtWOHeader.Rows[0]["AllocDt"].ToString() == "")
                {
                    return "";
                }
                if (dtWOHeader.Rows[0]["AllocDt"].ToString() != "" && dtWOHeader.Rows[0]["MakeOrderDt"].ToString() != "")
                {
                    if (dtWOHeader.Rows[0]["ConfirmShipDt"].ToString() != "")
                        return "Shipped";
                    else if (dtWOHeader.Rows[0]["PickCompDt"].ToString() != "")
                        return "Picked";
                    else if (dtWOHeader.Rows[0]["PickDt"].ToString() != "")
                        return "Picking";
                    else if (dtWOHeader.Rows[0]["RlsWhseDt"].ToString() != "")
                        return "Warehouse";
                    else
                        return "Pending";
                }
                return "";
            }
            return "";
        }

        public string GetWOStatus(DataTable dtWOHeader)
        {

            if (dtWOHeader.Rows[0]["DeleteDt"].ToString() != "")
                return "Deleted";
            else if (dtWOHeader.Rows[0]["makeOrderDt"].ToString() != "" &&
                    dtWOHeader.Rows[0]["AllocReleaseDt"].ToString() != "" &&
                    dtWOHeader.Rows[0]["AllocationDt"].ToString() == "")
                return "Allocating";
            else if (dtWOHeader.Rows[0]["makeOrderDt"].ToString() != "" &&
                    dtWOHeader.Rows[0]["CompleteDt"].ToString() == "" &&
                    dtWOHeader.Rows[0]["AllocationDt"].ToString() != "")
                return "Allocated";
            else if (dtWOHeader.Rows[0]["CompleteDt"].ToString() != "")
                return "Complete";
            else if (dtWOHeader.Rows[0]["makeOrderDt"].ToString() == "")
                return "Entry";
            else
                return "";               
            
        }

        public void RunMakeOrderProcess(string pPoHeaderID)
        {
            try
            {   
                SqlHelper.ExecuteNonQuery(  ERPConnectionString, "[pWOMakeOrder]",
                                            new SqlParameter("@pPOHeaderID", pPoHeaderID),
                                            new SqlParameter("@entryId", HttpContext.Current.Session["UserName"].ToString()));                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string RunReleaseOrderProcess(string pPoHeaderID)
        {
            SqlParameter StatParam = new SqlParameter();
            StatParam.ParameterName = "@RelStatus";
            StatParam.Value = "Unknown";
            StatParam.SqlDbType = SqlDbType.VarChar;
            StatParam.Size = 50;
            StatParam.Direction = ParameterDirection.Output;
            try
            {
                // SQLHelper cannot be used because the output parameter fails to initialize if the stored procedure
                // produces a result set
                using (SqlConnection connection = new SqlConnection(ERPConnectionString))
                {
                    SqlCommand command = new SqlCommand("[pWOReleaseOrder]", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Connection.Open();
                    command.Parameters.Add(new SqlParameter("@pPOHeaderID", pPoHeaderID));
                    command.Parameters.Add(new SqlParameter("@entryId", HttpContext.Current.Session["UserName"].ToString()));
                    command.Parameters.Add(StatParam);
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return StatParam.Value.ToString();
        }

        public void DeleteWorkOrder(string pPOHeaderID)
        {
             try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pWODeleteOrder]",
                                            new SqlParameter("@pPOHeaderID", pPOHeaderID),
                                            new SqlParameter("@entryId", HttpContext.Current.Session["UserName"].ToString()));
            }
            catch (Exception ex)
            {
                throw ex;
            }
            
        }

        public DataTable CheckWipOverReceipt(string pPODetailID, decimal RecptQty)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOCheckOverReceipt]",
                   new SqlParameter("@pPOHeaderID", pPODetailID),
                   new SqlParameter("@RecptQty", RecptQty));
                if (dsResult != null)
                    return dsResult.Tables[0];
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void ReceiveWO(string pPODetailID, decimal RecptQty, string RecptType, string InsufficientWipInd)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pWOReceiveOrder]",
                                            new SqlParameter("@pPODetailID", pPODetailID),
                                            new SqlParameter("@RecptQty", RecptQty),
                                            new SqlParameter("@RecptType", RecptType),
                                            new SqlParameter("@entryId", HttpContext.Current.Session["UserName"].ToString()),
                                            new SqlParameter("@InsufficientWipInd", InsufficientWipInd));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetSubPOs(string WONumber)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "pWOEntryFrm",
                    new SqlParameter("@source", "GetSubPOs"),
                    new SqlParameter("@searchFilter", WONumber),
                    new SqlParameter("@POHeaderTableName", HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower()));
                if (dsResult != null)
                    return dsResult.Tables[0];

                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertTableData(string tableName, string columnName, string columnValue)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEInsert]",
                                        new SqlParameter("@tableName", tableName),
                                        new SqlParameter("@columnNames", columnName),
                                        new SqlParameter("@columnValues", columnValue));
            }
            catch (Exception ex)
            {                
                throw ex;
            }
        }

        public string FormatPhoneNumber(string phoneNumber)
        {
            string result = phoneNumber;

            if (phoneNumber != "")
            {
                try
                {
                    result = string.Format("{0:(###) ###-####}", Convert.ToInt64(phoneNumber.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")));
                }
                catch (Exception ex)
                {
                }
            }

            return result;

        }

        public bool IsInteger(string theValue)
        {
            try
            {
                Convert.ToInt32(theValue);
                return true;
            }
            catch
            {
                return false;
            }
        }

        #endregion

        #region Pack BY Address Methods

        public DataSet GetPackByAddressData(string source, string searchFilter)
        {
            DataSet dsResult = new DataSet();
            dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pWOPackByAddress]",
                                new SqlParameter("@source", source),
                                new SqlParameter("@searchFilter", searchFilter),
                                new SqlParameter("@POHeaderTableName", HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower()));

            return dsResult;
        }

        #endregion
    }
}