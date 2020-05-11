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


namespace PFC.Intranet.ROISalesReport
{
    /// <summary>
    /// Summary description for ROISalesReport
    /// </summary>
    public class ROISalesReport
    {
        //
        // Global Variables Declaration
        //
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

        public string GetDateCondition()
        {
            try
            {
                DateTime dtCurrentMonth = DateTime.Now.AddMonths(-1);
                string currentFiscalMonth = String.Format("{0:MMMM}", dtCurrentMonth);
                string currentFiscalYear = dtCurrentMonth.Year.ToString();
                string strDateCondition = currentFiscalMonth + " " + currentFiscalYear;
                return strDateCondition;

            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public string GetDate(string strMonth)
        {
            try
            {
                DateTime dtCurrentMonth = Convert.ToDateTime(strMonth + "/1" + "/2007");
                string selectedMonth = String.Format("{0:MMMM}", dtCurrentMonth);
                return selectedMonth;

            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public DataSet GetSalesByCategory(string sortExpression, string month, string year)
        {
            try
            {
                DataSet dsSalesCategoryData = new DataSet();
                
                string _catSumTable = "CAS_CategorySum";
                string _sumCol = "CatGrpNo,convert(varchar,CatGrpNo) + ' - '+ CatGrpDesc as CatGroup,SUM(ISNULL(Roll12Sales,0)) as Roll12Sales," +
                                "CASE WHEN SUM(ISNULL(Roll12Lbs, 0))= 0 THEN 0 ELSE SUM(ISNULL(Roll12Sales, 0)) / SUM(Roll12Lbs) END AS SalesLbs," +
                                "CASE WHEN SUM(ISNULL(Roll12Lbs, 0))= 0 THEN 0 ELSE SUM(ISNULL(Roll12GM, 0)) / SUM(Roll12Lbs) END AS GMLbs," +
                                "Min(ISNULL(Roll12PctTotSalesCorpAvg,0)) as Roll12PctTotSalesCorpAvg," +
                                "Min(ISNULL(Roll12GMPctCorpAvg,0)) as Roll12GMPctCorpAvg";
                string where = "CatGrpNo<>'' and recType = 'customer' and curmonth=" + month + " and curYear=" + year +
                             " group by CatGrpDesc,CurYear,CurMonth,CatGrpNo";

                DataSet dsCategoryData = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _catSumTable),
                                    new SqlParameter("@columnNames", _sumCol),
                                    new SqlParameter("@whereClause", where));
                DataTable dtCategory = dsCategoryData.Tables[0].Copy();
                dtCategory.Columns.Add("AvgCostSales", typeof(decimal));
                dtCategory.Columns.Add("ExtAvgCost", typeof(decimal));
                dtCategory.Columns.Add("ROI", typeof(decimal));
                dtCategory.Columns.Add("Roll12GMSum", typeof(decimal));
                dtCategory.Columns.Add("OHCost", typeof(decimal));
                dtCategory.Columns.Add("AppOptionNumber", typeof(decimal));

                string _timePhaseTable = "SumItem";
                string _timePhaseCol = "isnull(sum(ExtAvgCost),0) ,CatGrpNo";
                string whereClause = " 1=1 Group by CatGrpNo";

                DataSet dsTimephase = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _timePhaseTable),
                                    new SqlParameter("@columnNames", _timePhaseCol),
                                    new SqlParameter("@whereClause", whereClause));

                DataSet dsROI = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", "(SELECT CATGM.CatGrpNo, CATGM.Roll12GM, SUM(SumItem.ExtAvgCost) AS ExtCost FROM (SELECT CurYear, CurMonth, CatGrpNo, RecType, SUM(Roll12GM) AS Roll12GM FROM CAS_CategorySum GROUP BY CurYear, CurMonth, CatGrpNo, RecType HAVING (CurYear = " + year + ") AND (CurMonth =" + month + ") AND RecType = 'Customer') CATGM INNER JOIN SumItem ON CATGM.CatGrpNo = SumItem.CatGrpNo GROUP BY CATGM.CatGrpNo, CATGM.Roll12GM) tmp CROSS JOIN AppPref"),
                                    new SqlParameter("@columnNmes", "tmp.CatGrpNo, CASE WHEN ISNULL(tmp.ExtCost, 0)=0 THEN 0 ELSE tmp.Roll12GM / tmp.ExtCost * AppPref.AppOptionNumber END AS ROIIndex, tmp.Roll12GM as Roll12GMSum, tmp.ExtCost AS OHCost, AppPref.AppOptionNumber as AppOptionNumber"),
                                    new SqlParameter("@whereClause", "(AppPref.ApplicationCd = 'IM') AND AppPref.AppOptionType = 'ROIIndex' AND (AppPref.AppOptionValue = '1')"));
                
                foreach (DataRow dr in dtCategory.Rows)
                {
                    dsTimephase.Tables[0].DefaultView.RowFilter = "CatGrpNo=" + dr["CatGrpNo"].ToString().Trim();
                    dsROI.Tables[0].DefaultView.RowFilter = "CatGrpNo=" + dr["CatGrpNo"].ToString().Trim();
                    decimal extCost = Convert.ToDecimal((dsTimephase.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsTimephase.Tables[0].DefaultView.ToTable().Rows[0][0].ToString().Trim() : "0");
                    decimal rollSales = Convert.ToDecimal((dr["Roll12Sales"] != null) ? dr["Roll12Sales"].ToString().Trim() : "0");
                    decimal roi = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["ROIIndex"].ToString().Trim() : "0");

                    // Added for Roll12GMSum
                    decimal dAppOptionNumber = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["AppOptionNumber"].ToString().Trim() : "0");
                    decimal dRoll12GMSum = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["Roll12GMSum"].ToString().Trim() : "0");
                    decimal dOHCost = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["OHCost"].ToString().Trim() : "0");
                    dr["Roll12GMSum"] = dRoll12GMSum;
                    dr["OHCost"] = dOHCost;
                    dr["AppOptionNumber"] = dAppOptionNumber;


                    dr["AvgCostSales"] = ((extCost > 0 && rollSales > 0) ? (extCost / rollSales)*12 : 0);
                    dr["ExtAvgCost"] = extCost;
                    dr["ROI"] = roi;

                }
                dsSalesCategoryData.Tables.Add(dtCategory);
                dsSalesCategoryData.Tables[0].DefaultView.Sort = sortExpression;
                return dsSalesCategoryData;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetSalesByCategoryPrefix(string CategoryGroupNo, string sortExpression, string MonthWhere, string YearWhere)
        {
            try
            {
                DataSet dsSalesCategoryPrefix = new DataSet();

                string _catSumTable = "CAS_CategoryPrefixSum";
                string _sumCol = "CatGrpNo,CatPrefix,CatPrefix+'-'+CatPrefixDesc as CatPrefixDes,SUM(ISNULL(Roll12Sales,0)) as Roll12Sales," +
                                "CASE WHEN SUM(ISNULL(Roll12Lbs, 0))= 0 THEN 0 ELSE SUM(ISNULL(Roll12Sales, 0)) / sum(Roll12Lbs) END AS DLB," +
                                "CASE WHEN SUM(ISNULL(Roll12Lbs, 0))= 0 THEN 0 ELSE SUM(ISNULL(Roll12GM, 0)) / SUM(Roll12Lbs) END AS GMLB," +
                                "Min(ISNULL(Roll12PctTotSalesCorpAvg,0)) as Roll12PctTotSalesCorpAvg," +
                                "MIN(ISNULL(Roll12GMPctCorpAvg,0)) as Roll12GMPctCorpAvg";

                string where = "curmonth=" + MonthWhere + " and recType = 'customer' and CatGrpNo = " + CategoryGroupNo + "and curyear=" + YearWhere + " group by CatGrpNo,CatPrefix,CatPrefixDesc order by CatPrefix";

                DataSet dsCategoryData = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _catSumTable),
                                    new SqlParameter("@columnNames", _sumCol),
                                    new SqlParameter("@whereClause", where));
                DataTable dtCategory = dsCategoryData.Tables[0].Copy();
                dtCategory.Columns.Add("MOH", typeof(decimal));
                dtCategory.Columns.Add("ExtAvgCost", typeof(decimal));
                dtCategory.Columns.Add("ROI", typeof(decimal));
                dtCategory.Columns.Add("Roll12GMSum", typeof(decimal));
                dtCategory.Columns.Add("OHCost", typeof(decimal));
                dtCategory.Columns.Add("AppOptionNumber", typeof(decimal));

                string _timePhaseTable = "SumItem";
                string _timePhaseCol = "isnull(sum(ExtAvgCost),0) ,CatGrpNo,CatPrefix";
                string whereClause = " SumItem.CatGrpNo=" + CategoryGroupNo + " Group by CatGrpNo,CatPrefix order by CatPrefix";

                DataSet dsTimephase = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _timePhaseTable),
                                    new SqlParameter("@columnNames", _timePhaseCol),
                                    new SqlParameter("@whereClause", whereClause));

                DataSet dsROI =new DataSet(); //SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                   //new SqlParameter("@tableName", " (SELECT CATGM.CatPrefix,CATGM.CatGrpNo, CATGM.Roll12GM, SUM(SumItem.ExtAvgCost) AS ExtCost FROM (SELECT CatPrefix,CurYear, CurMonth, CatGrpNo, RecType, SUM(Roll12GM) AS Roll12GM FROM CAS_CategoryPrefixSum GROUP BY CurYear, CurMonth, CatGrpNo, RecType , CatPrefix HAVING (CurYear = " + YearWhere + ") AND (CurMonth =" + MonthWhere + ") AND RecType = 'Customer') CATGM INNER JOIN SumItem ON CATGM.CatGrpNo = SumItem.CatGrpNo and CATGM.CatPrefix=SumItem.CatPrefix GROUP BY CATGM.CatGrpNo, CATGM.CatPrefix, CATGM.Roll12GM) tmp CROSS JOIN AppPref "),
                                   //new SqlParameter("@columnNames", " tmp.CatGrpNo,tmp.CatPrefix, case when tmp.ExtCost = 0 then 0 else (tmp.Roll12GM / tmp.ExtCost) * AppPref.AppOptionNumber end AS ROIIndex, tmp.Roll12GM as Roll12GMSum, tmp.ExtCost AS OHCost, AppPref.AppOptionNumber as AppOptionNumber"),
                                   //new SqlParameter("@whereClause", " (AppPref.ApplicationCd = 'IM') AND AppPref.AppOptionType = 'ROIIndex' AND (AppPref.AppOptionValue = '1') AND (tmp.CatGrpNo = '" + CategoryGroupNo + "') order by tmp.CatPrefix"));

                using (SqlConnection cn = new SqlConnection(connectionString))
                {
                    cn.Open();
                    string sql = "select " + " tmp.CatGrpNo,tmp.CatPrefix, case when tmp.ExtCost = 0 then 0 else (tmp.Roll12GM / tmp.ExtCost) * AppPref.AppOptionNumber end AS ROIIndex, tmp.Roll12GM as Roll12GMSum, tmp.ExtCost AS OHCost, AppPref.AppOptionNumber as AppOptionNumber " +
                                " From " + " (SELECT CATGM.CatPrefix,CATGM.CatGrpNo, CATGM.Roll12GM, SUM(SumItem.ExtAvgCost) AS ExtCost FROM (SELECT CatPrefix,CurYear, CurMonth, CatGrpNo, RecType, SUM(Roll12GM) AS Roll12GM FROM CAS_CategoryPrefixSum GROUP BY CurYear, CurMonth, CatGrpNo, RecType , CatPrefix HAVING (CurYear = " + YearWhere + ") AND (CurMonth =" + MonthWhere + ") AND RecType = 'Customer') CATGM INNER JOIN SumItem ON CATGM.CatGrpNo = SumItem.CatGrpNo and CATGM.CatPrefix=SumItem.CatPrefix GROUP BY CATGM.CatGrpNo, CATGM.CatPrefix, CATGM.Roll12GM) tmp CROSS JOIN AppPref " + " where " +
                                " (AppPref.ApplicationCd = 'IM') AND AppPref.AppOptionType = 'ROIIndex' AND (AppPref.AppOptionValue = '1') AND (tmp.CatGrpNo = '" + CategoryGroupNo + "') order by tmp.CatPrefix";
                    SqlCommand cmd = new SqlCommand(sql,cn);
                    SqlDataAdapter dapResult = new SqlDataAdapter(cmd);
                    dapResult.Fill(dsROI);
                }

                int _RoiCount = 0;
                foreach (DataRow dr in dtCategory.Rows)
                {                    
                    dsTimephase.Tables[0].DefaultView.RowFilter = "CatPrefix=" + dr["CatPrefix"].ToString().Trim();
                    dsROI.Tables[0].DefaultView.RowFilter = (dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ?"CatGrpNo=" + dr["CatGrpNo"].ToString().Trim() + " and CatPrefix=" + dr["CatPrefix"].ToString().Trim():"";                    
                    decimal extCost = Convert.ToDecimal((dsTimephase.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsTimephase.Tables[0].DefaultView.ToTable().Rows[0][0].ToString().Trim() : "0");
                    decimal rollSales = Convert.ToDecimal((dr["Roll12Sales"] != null) ? dr["Roll12Sales"].ToString().Trim() : "0");
                    decimal roi = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["ROIIndex"].ToString().Trim() : "0");
                    
                    // Added for Roll12GMSum
                    decimal dAppOptionNumber = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["AppOptionNumber"].ToString().Trim() : "0");
                    decimal dRoll12GMSum = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["Roll12GMSum"].ToString().Trim() : "0");
                    decimal dOHCost = Convert.ToDecimal((dsROI.Tables[0].DefaultView.ToTable().Rows.Count > 0) ? dsROI.Tables[0].DefaultView.ToTable().Rows[0]["OHCost"].ToString().Trim() : "0");
                    dr["Roll12GMSum"] = dRoll12GMSum;
                    dr["OHCost"] = dOHCost;
                    dr["AppOptionNumber"] = dAppOptionNumber;

                    dr["MOH"] = ((extCost > 0 && rollSales > 0) ? (extCost / rollSales)*12 : 0);
                    dr["ExtAvgCost"] = extCost;
                    dr["ROI"] = roi;
                    _RoiCount++;
                }
                dsSalesCategoryPrefix.Tables.Add(dtCategory);
                dsSalesCategoryPrefix.Tables[0].DefaultView.Sort = sortExpression;
                return dsSalesCategoryPrefix;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetSalesByCategory(string sortExpression)
        {
            try
            {
                string _tableName = "CAS_CategorySum,SumItem";
                string _columnName = "distinct CAS_CategorySum.CatGrpNo,convert(varchar,CAS_CategorySum.CatGrpNo) + ' - '+ CAS_CategorySum.CatGrpDesc as CatGroup,ISNULL(SumItem.ExtAvgCost,0) as ExtAvgCost,ISNULL(CAS_CategorySum.Roll12Sales,0) as Roll12Sales,CASE WHEN ISNULL(CAS_CategorySum.Roll12Sales, 0)= 0 THEN 0 ELSE ISNULL(SumItem.ExtAvgCost, 0) / CAS_CategorySum.Roll12Sales END AS AvgCostSales,CASE WHEN ISNULL(CAS_CategorySum.Roll12Lbs, 0)= 0 THEN 0 ELSE ISNULL(CAS_CategorySum.Roll12Sales, 0) / CAS_CategorySum.Roll12Lbs END AS SalesLbs,CASE WHEN ISNULL(CAS_CategorySum.Roll12Lbs, 0)= 0 THEN 0 ELSE ISNULL(CAS_CategorySum.Roll12GM, 0) / CAS_CategorySum.Roll12Lbs END AS GMLbs,'0.0' as pctCorp,'0.0' as pctCorpGM,'' as ROI ";
                string _whereClause = "CAS_CategorySum.CatGrpNo<>'' and CAS_CategorySum.recType = 'customer' and CAS_CategorySum.CatGrpNo = SumItem.CatGrpNo group by CAS_CategorySum.CatGrpDesc,SumItem.CatGrpNo,SumItem.ExtAvgCost,CAS_CategorySum.CurYear,CAS_CategorySum.CurMonth,CAS_CategorySum.CatGrpNo, Roll12Sales,CAS_CategorySum.Roll12Lbs,CAS_CategorySum.Roll12GM";
                DataSet dsSalesCategoryData = new DataSet();

                dsSalesCategoryData = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + sortExpression));
                return dsSalesCategoryData;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetSalesByCategoryPrefix(string CategoryGroupNo, string sortExpression)
        {
            try
            {
                string _tableName = "CAS_CategoryPrefixSum,SumItem";
                // string _columnName = "CAS_CategoryPrefixSum.CatPrefix+'-'+CAS_CategoryPrefixSum.CatPrefixDesc as CatPrefix,TimePhase.ExtAvgCost,CAS_CategoryPrefixSum.Roll12Sales,TimePhase.ExtAvgCost/CAS_CategoryPrefixSum.Roll12Sales as MOH,CAS_CategoryPrefixSum.Roll12Sales/ CAS_CategoryPrefixSum.Roll12Lbs as DLB,CAS_CategoryPrefixSum.Roll12GM / CAS_CategoryPrefixSum.Roll12Lbs as GMLB,CAS_CategoryPrefixSum.Roll12Lbs ,CAS_CategoryPrefixSum.Roll12Lbs ,CAS_CategoryPrefixSum.Roll12Lbs";
                string _columnName = "CAS_CategoryPrefixSum.CatPrefix+'-'+CAS_CategoryPrefixSum.CatPrefixDesc as CatPrefix,ISNULL(SumItem.ExtAvgCost,0) as ExtAvgCost,ISNULL(CAS_CategoryPrefixSum.Roll12Sales,0) as Roll12Sales,CASE WHEN ISNULL(CAS_CategoryPrefixSum.Roll12Sales, 0)= 0 THEN 0 ELSE ISNULL(SumItem.ExtAvgCost, 0) / CAS_CategoryPrefixSum.Roll12Sales END AS MOH,CASE WHEN ISNULL(CAS_CategoryPrefixSum.Roll12Lbs, 0)= 0 THEN 0 ELSE ISNULL(CAS_CategoryPrefixSum.Roll12Sales, 0) / CAS_CategoryPrefixSum.Roll12Lbs END AS DLB,CASE WHEN ISNULL(CAS_CategoryPrefixSum.Roll12Lbs, 0)= 0 THEN 0 ELSE ISNULL(CAS_CategoryPrefixSum.Roll12GM, 0) / CAS_CategoryPrefixSum.Roll12Lbs END AS GMLB,'0.0' as pctCorp,'0.0' as pctCorpGM,'' as ROI ";
                string _whereClause = "SumItem.CatGrpNo=" + CategoryGroupNo + " and CAS_CategorySum.recType = 'customer' and CAS_CategoryPrefixSum.catPrefix=SumItem.CatPrefix group by CAS_CategoryPrefixSum.CurYear,CAS_CategoryPrefixSum.CurMonth,CAS_CategoryPrefixSum.CatPrefix,CAS_CategoryPrefixSum.CatPrefixDesc,CAS_CategoryPrefixSum.Roll12Sales,CAS_CategoryPrefixSum.Roll12Lbs,CAS_CategoryPrefixSum.Roll12GM,SumItem.CatGrpNo,SumItem.ExtAvgCost";
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
    }
}