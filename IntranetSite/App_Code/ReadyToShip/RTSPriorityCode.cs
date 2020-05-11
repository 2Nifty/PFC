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


namespace PFC.Intranet.BusinessLogicLayer
{

    /// <summary>
    /// Summary description for RTSPriorityCode
    /// </summary>
    public class RTSPriorityCode
    {
        ReadyToShipUtility utilsRTS = new ReadyToShipUtility();

        public RTSPriorityCode()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public void UpdatePriority(string poNo, string itemNo,string detailID,string prevQty,string currQty)
        {
            try
            {
                string tableName = "[Porteous$Purchase Line]";
                string columnName = "Top 1 [PO Status Code]";
                string whereCaluse = "[Document No_] = '" + poNo + "'";

                #region Code to update the status code when G or M
                string statusCode = GetValue(tableName, columnName, whereCaluse);
                if (statusCode.ToString() != "")
                {
                    if (statusCode == "M" || statusCode == "G")
                    {
                        utilsRTS.UpdateQuantity("GERRTSDtl", "StatusCd='" + statusCode + "'", "PONo='" + poNo.Trim() + "'");
                        return;
                    }
                }

                #endregion

                #region Code to form the matrix table

                // Region code to form the priority matrix
                string poLeadingRight = GetValue(tableName, "left([Document No_],1)", whereCaluse);
                tableName = "AppPref";
                columnName = "AppOptionType,AppOptionTypeDesc,AppOptionNumber";
                whereCaluse = (poLeadingRight == "5") ? "ApplicationCd='RTS' and AppOptionType like 'P%'" : "ApplicationCd='RTS' and AppOptionType like 'R%'";
                DataSet dsMatrix = utilsRTS.GetDetails(tableName, columnName, whereCaluse);
                DataSet dsRop = utilsRTS.GetDetails("GERRTSHdr", "ROPCalc", "ItemNo='" + itemNo + "'");

                object objActionVal = utilsRTS.GetScalar("GERRTSDtl a,GERRTSHdr b", "a.ActionQty +" + prevQty + "+ b.AvailQty + b.Intransit + b.OWQty", "a.pGERRTSDtlID='" + detailID + "' and a.ItemNo= b.ItemNo and a.LocCd = b.LocCd");

                if (dsRop != null && dsRop.Tables[0].Rows.Count > 0 && objActionVal!=null)
                {
                    // Get the monthly rop value
                    decimal ropMonthly = Convert.ToDecimal(dsRop.Tables[0].Rows[0][0].ToString().Trim()) / 30;

                    if (dsMatrix != null && dsMatrix.Tables[0].Rows.Count > 0)
                    {
                        DataTable dtMatrix = dsMatrix.Tables[0];
                        dtMatrix.Columns.Add("MatrixValue");
                        dtMatrix.Columns.Add("StatusCode");

                        for (int i = 0; i < dtMatrix.Rows.Count; i++)
                        {
                            dtMatrix.Rows[i]["MatrixValue"] = Math.Round(Convert.ToDecimal(dtMatrix.Rows[i]["AppOptionNumber"].ToString().Trim()) * Convert.ToDecimal(ropMonthly), 0);
                            dtMatrix.Rows[i]["StatusCode"] = Convert.ToChar(65 + i);

                            if (ropMonthly <= Convert.ToDecimal(objActionVal.ToString().Trim()))
                            {
                                utilsRTS.UpdateQuantity("GERRTSDtl", "StatusCd='" + dtMatrix.Rows[i]["StatusCode"].ToString().Trim() + "'", "PONo='" + poNo.Trim() + "'");
                                return;
                            }
                        }
                        dtMatrix.AcceptChanges();

                    }
                    else
                        return;
                }
                #endregion
                
            }
            catch (Exception ex) { }

        }
        /// <summary>
        /// Get the values from the navision database
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnValue"></param>
        /// <param name="where"></param>
        /// <returns></returns>
        public string GetValue(string tableName, string columnValue, string where)
        {
            try
            {
                object objStatCd = SqlHelper.ExecuteScalar(ConfigurationManager.AppSettings["NVLiveConnectionString"], "DTQ_SP_SELECT",
                                                      new SqlParameter("@tableName", tableName),
                                                      new SqlParameter("@columnNames", columnValue),
                                                      new SqlParameter("@whereClause", where)).ToString();

                return objStatCd.ToString();

            }
            catch (Exception ex) { return ""; }
        }
    }
}