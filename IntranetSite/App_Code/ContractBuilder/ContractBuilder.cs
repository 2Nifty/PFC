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

namespace PFC.Intranet.ContractBuilder
{
    /// <summary>
    /// Summary description for ContractBuilder
    /// </summary>
    public class ContractBuilder
    {
        //
        // Global Variables Declaration
        //
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

        private string curMonth;

        public string CurMonth
        {
            get { return curMonth; }
            set { curMonth = value; }
        }
        private string curYear;

        public string CurYear
        {
            get { return curYear; }
            set { curYear = value; }
        }

        public string GetCondition()
        {
            try
            {
                FiscalCalendar fiscalCalendar = new FiscalCalendar();
                DateTime dtCurrentMonth = DateTime.Now.AddMonths(-1);

                string currentFiscalMonth = dtCurrentMonth.Month.ToString();
                string currentFiscalYear = dtCurrentMonth.Year.ToString();

                //int lastFiscalMonth = dtCurrentMonth.Month - 1;
                //string PreviousYear = Convert.ToString(dtCurrentMonth.Year - 1);
                //string strCondition = "(( CurYear = '" + currentFiscalYear + "' AND CurMonth <= '" + currentFiscalMonth + "') or ( CurYear = '" + PreviousYear + "' AND CurMonth > '" + lastFiscalMonth + "'))";
                //return strCondition;

                string strCondition = "CurYear = '" + CurYear + "' AND CurMonth = '" + CurMonth + "'";
                return strCondition;
            }
            catch (Exception ex)
            {
                return "";
            }
        }
        public string GetDateCondition()
        {
            try
            {
                DateTime dtCurrentMonth = DateTime.Now.AddMonths(-1);
                DateTime dsMonth = new DateTime(Convert.ToInt32(CurYear), Convert.ToInt32(CurMonth), 1);
                string currentFiscalMonth = String.Format("{0:MMMM}", dsMonth);

                string strDateCondition = currentFiscalMonth + " " + CurYear;
                return strDateCondition;

            }
            catch (Exception ex)
            {
                return "";
            }
        }
        public DataTable GetSalesCategoryDetail(string customerID, string sortExpression)
        {
            try
            {
                string _tableName = "CAS_CategorySum";

                string _columnName = " CatGrpNo, ( cast(CatGrpNo as varchar)  + ' - '+ CatGrpDesc) AS CatGrpDesc," +
                                    "isnull(sum(Roll12Sales),0) as Roll12Sales," +
                                    "isnull(sum(Roll12Lbs),0) as Roll12Lbs," +
                                    "cast((isnull(avg(Roll12GMPct),0)) as Decimal(25,1)) as Roll12GMPct," +
                                    "cast((isnull(avg(Roll12GMLb),0)*100) as Decimal(25,1)) as Roll12GMLb," +
                                    "cast(avg(isnull(Roll12DollarLb,0)) as Decimal(25,2)) as Roll12DollarLb," +
                                    "isnull(sum(Roll12GM),0) as Roll12GM," +
                                    "cast(isnull(avg(Roll12GMPctCorpAvg),0) as decimal(15,1)) as Roll12GMPctCorpAvg," +
                                    "cast(isnull(avg(Roll12PctTotSalesCorpAvg),0) as decimal(15,1)) as Roll12PctTotSalesCorpAvg," +
                                    "cast(isnull(avg(Roll12DolPerLBCorpAvg),0) as decimal(15,2)) as Roll12DolPerLBCorpAvg," +
                                    "cast((isnull(avg(Roll12PctTotSales),0)) as decimal(15,2)) as Roll12PctTotSales,isnull(sum(Roll12Sales),0) as GTRoll12Sales,isnull(sum(Roll12Lbs),0) as GTRoll12Lbs,isnull(sum(Roll12GM),0) as GTRoll12GM,avg(CASE WHEN ISNULL(Roll12Lbs, 0)= 0 THEN 0 ELSE ISNULL(Roll12Sales, 0) / Roll12Lbs END )AS DLB,avg(CASE WHEN ISNULL(Roll12Sales, 0)= 0 THEN 0 ELSE ISNULL(Roll12GM, 0) / Roll12Sales END )AS GMPct";

                string _whereClause = "CAS_CategorySum.CatGrpNo<>'' and CustNo='" + customerID + "' and " + GetCondition() + " group by CatGrpNo,CatGrpDesc";
                DataSet dsSalesCategoryData = new DataSet();

                dsSalesCategoryData = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + sortExpression));
                return dsSalesCategoryData.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable GetItemCategoryDetail(string customerID, string salesDet, string sortExpression)
        {
            try
            {
                string _tableName = "CAS_CategoryPrefixSum";
                string _columnName = "replace(convert(varchar,cast((round(isnull(Roll12Sales,0),0)) as money),1),'.00','') as Roll12Sales," +
                                      "replace(convert(varchar,cast((round(isnull(Roll12Lbs,0) ,0)) as money),1),'.00','') as Roll12Lbs," +
                                      "cast((isnull(Roll12GMPct,0)) as Decimal(25,1)) as Roll12GMPct, " +
                                      "cast((isnull(Roll12GMLb,0)*100) as Decimal(25,1)) as Roll12GMLb, " +
                                      "cast(Roll12DollarLb as Decimal(25,2)) as Roll12DollarLb, " +
                                      "CategoryRank, BranchNo, CatPrefix, CatPrefixDesc, " +
                                      "replace(convert(varchar,cast((round(isnull(Roll12GM,0),0)) as money),1),'.00','') as Roll12GM," +
                                      "cast(isnull(Roll12GMPctCorpAvg,0) as decimal(15,1)) as Roll12GMPctCorpAvg," +
                                      "cast(isnull(Roll12PctTotSalesCorpAvg,0) as decimal(15,1)) as Roll12PctTotSalesCorpAvg," +
                                      "cast(isnull(Roll12DolPerLBCorpAvg,0) as decimal(15,2)) as Roll12DolPerLBCorpAvg," +
                                      "cast((isnull(Roll12PctTotSales,0)) as decimal(15,2)) as Roll12PctTotSales,isnull(Roll12Sales,0) as GTRoll12Sales,isnull(Roll12Lbs,0) as GTRoll12Lbs,isnull(Roll12GM,0) as GTRoll12GM";
                string _whereClause = "CustNo='" + customerID + "' and CatGrpNo='" + salesDet + "' and " + GetCondition();

                DataSet dsItemCategoryData = new DataSet();

                dsItemCategoryData = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + sortExpression));
                return dsItemCategoryData.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable GetContractBuilderHeader(string customerID, string categoryNumber)
        {
            try
            {
                DataSet dsContractBuilderHeader = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                                new SqlParameter("@tableName", "ContractBuilderMasterWorkArea"),
                                new SqlParameter("@displayColumns", "Top5ProdCat1,Top5ProdCat2,Top5ProdCat3,Top5ProdCat4,Top5ProdCat5,CatPctTotSales,isnull(CountCFVA,0) as CountCFVA,isnull(CountCFVB,0) as CountCFVB,isnull(CountCFVC,0) as CountCFVC,isnull(CountCFVD,0) as CountCFVD,isnull(CountCFVE,0) as CountCFVE,isnull(CountCFVF,0) as CountCFVF,isnull(CountCFVG,0) as CountCFVG,isnull(CountCFVH,0) as CountCFVH,isnull(CountCFVI,0) as CountCFVI,isnull(CountCFVJ,0) as CountCFVJ,isnull(CountCFVk,0) as CountCFVk"),
                                new SqlParameter("@whereCondition", "CustNo='" + customerID + "' and catno='" + categoryNumber + "'"));
                return dsContractBuilderHeader.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable GetContractBuilderHeader(string customerID)
        {
            try
            {
                DataSet dsContractBuilderHeader = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                                new SqlParameter("@tableName", "ContractBuilderMasterWorkArea"),
                                new SqlParameter("@displayColumns", "Top5ProdCat1,Top5ProdCat2,Top5ProdCat3,Top5ProdCat4,Top5ProdCat5,CatPctTotSales,CountCFVA,CountCFVB,CountCFVC,CountCFVD,CountCFVE,CountCFVF,CountCFVG,CountCFVH,CountCFVI,CountCFVJ,CountCFVk"),
                                new SqlParameter("@whereCondition", "CustNo='" + customerID + "'"));
                return dsContractBuilderHeader.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        private string GetFiscalPeriod()
        {
            string currentFiscalMonth = (DateTime.Now.Month - 1).ToString();
            return "";
        }
        public DataSet GetCategoryMaster(string category, string custNumber)
        {
            try
            {
                DataSet dsContract = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                    new SqlParameter("@tableName", "ContractBuilderDetailWorkArea"),
                    new SqlParameter("@displayColumns", "CategoryVariance,avg(CatVarPctTotSales) as CatVarPctTotSales"),
                    new SqlParameter("@whereCondition", "categoryvariance like '" + category + "%' and custno='" + custNumber + "' group by CategoryVariance"));

                return dsContract;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="categoryVariance"></param>
        /// <returns></returns>
        public DataSet GetCategoryDetail(string categoryVariance, string custNumber)
        {
            try
            {
                DataSet dsContract = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                         new SqlParameter("@tableName", "ContractBuilderDetailWorkArea"),
                         new SqlParameter("@displayColumns", "CategoryVariance,isnull(CatVarPctTotSales,0) as CatVarPctTotSales,CatVelocityCode,isnull(CVCSalesYTD,0) as CVCSalesYTD,isnull(CVCLbsYTD,0) as CVCLbsYTD,isnull(CVCProfitDolYTD,0) as CVCProfitDolYTD,LastModifiedDt,EffectiveDt,ExpirationDt,ProcessInd,ProcessDt,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,isnull(CVCSuggSellPerUOM,0) as CVCSuggSellPerUOM,isnull(CVCContractSellPerUOM,0) as CVCContractSellPerUOM,isnull(CVCReplCostPerUOM,0) as CVCReplCostPerUOM,isnull(CVCSuggSellPerAlt,0) as CVCSuggSellPerAlt,isnull(CVCContractSellPerAlt,0) as CVCContractSellPerAlt,isnull(CVCSuggSellYTD,0) as CVCSuggSellYTD,isnull(CVCContractSellYTD,0) as CVCContractSellYTD,isnull(CVCContractGM,0) as CVCContractGM ,isnull(CVCStdCostPerUOM,0) as CVCStdCostPerUOM ,isnull(CVCNetWghtUOM,0) as CVCNetWghtUOM,isnull(CVCAvgSellPerLb,0) as CVCAvgSellPerLb,isnull(CVCAvgGMPct,0) as CVCAvgGMPct,isnull(CVCProfitPerLb,0) as CVCProfitPerLb,isnull(CVCSuggGMPctAtStd,0) as CVCSuggGMPctAtStd,isnull(CVCSuggGMPctAtReplace,0) as CVCSuggGMPctAtReplace,isnull(CVCSuggSellPerLb,0) as CVCSuggSellPerLb,isnull(CVCSuggGMPctAtStd,0) as CVCSuggGMPctAtStd,isnull(CVCSuggProfitPerLb,0) as CVCSuggProfitPerLb,isnull(CVCSuggForecastDol,0) as CVCSuggForecastDol,isnull(CVCSuggForecastProfit,0) as  CVCSuggForecastProfit,isnull(CVCContractSellPerLb,0) as CVCContractSellPerLb,isnull(CVCContractGMPct,0) as CVCContractGMPct,isnull(CVCContractProfitPerLb,0) as CVCContractProfitPerLb,isnull(CVCContractForecstDol,0) as CVCContractForecstDol,isnull(CVCContractForecstProfit,0)  as CVCContractForecstProfit,CustNo,isnull(effectivedt,getdate()) as EffDate,CASE WHEN ISNULL(CVCNetWghtUOM, 0)= 0 THEN 0 ELSE ISNULL(CVCReplCostPerUOM, 0) / CVCNetWghtUOM END AS ReplaceCost,isnull(CVCContractGMPctAvg,0) as CVCContractGMatAvgCost"),
                         new SqlParameter("@whereCondition", "CategoryVariance='" + categoryVariance + "' and custno='" + custNumber + "' order by CVCSalesYTD desc"));

                return dsContract;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public void UpdateCategoryMaster(string columnValues, string categoryVariance, string categoryVelocityCode, string custNumber)
        {
            try
            {
                string whereCondition = (categoryVelocityCode != "") ? "CategoryVariance='" + categoryVariance + "' and CatVelocityCode ='" + categoryVelocityCode + "' and custno='" + custNumber + "'" : "CategoryVariance='" + categoryVariance + "' and custno='" + custNumber + "'";

                SqlHelper.ExecuteNonQuery(connectionString, "[ugen_sp_update]",
                             new SqlParameter("@tableName", "ContractBuilderDetailWorkArea"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void UpdateCategoryDetail(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[ugen_sp_update]",
                             new SqlParameter("@tableName", "ContractBuilderCustItem"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void UpdateCategoryDetail(string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[ugen_sp_update]",
                             new SqlParameter("@tableName", "ContractBuildermasterWorkArea"),
                             new SqlParameter("@columnNames", "Savedt='" + DateTime.Now.ToShortDateString() + "'"),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public DataSet GetCategoryVelocityDetail(string strWhere)
        {
            try
            {
                DataSet dsVelocity = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                        new SqlParameter("@tableName", "ContractBuilderCustItem"),
                        new SqlParameter("@displayColumns", "ItemNo,ItemDesc,UOM,isnull(NetWght,0) as NetWght,PkgGroup,CustNo,CustName,CustSalesLoc,Chain,Category,Variance,CatVelocityCd,CorpFixVelocity,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,SalesYTD,isnull(LbsYTD,0) as LbsYTD,isnull(AvgSellPerLb,0) as AvgSellPerLb,isnull(AvgGMPct,0) as AvgGMPct,isnull(ProfitPerLb,0) as ProfitPerLb,isnull(ProfitDolYTD,0) as ProfitDolYTD,isnull(StdCost,0) as StdCost,isnull(CVCReplCostPerUOM,0) as ReplacementCost,isnull(PctDiffStdvsRpl,0) as PctDiffStdvsRpl,isnull(SuggSellPerLb,0) as SuggSellPerLb,isnull(SuggGMPctAtReplace,0) as SuggGMPctAtReplace,isnull(SuggGMPctAtStd,0) as SuggGMPctAtStd,isnull(SuggProfitPerLb,0) as SuggProfitPerLb,isnull(SuggForecastDol,0) as SuggForecastDol,isnull(SuggForecastProfit,0) as SuggForecastProfit,isnull(ContractSellPerLb,0) as ContractSellPerLb,isnull(ContractGMPct,0) as ContractGMPct ,isnull(ContractProfitPerLb,0) as ContractProfitPerLb,isnull(ContractForecstDol,0) as ContractForecstDol,isnull(ContractForecstProfit,0) as ContractForecstProfit,isnull(CVCSuggSellPerUOM,0) as CVCSuggSellPerUOM,isnull(CVCContractSellPerUOM,0) as CVCContractSellPerUOM,isnull(CVCReplCostPerUOM,0) as CVCReplCostPerUOM,isnull(CVCSuggSellPerAlt,0) as CVCSuggSellPerAlt,isnull(CVCContractSellPerAlt,0) as CVCContractSellPerAlt,isnull(CVCSuggSellYTD,0) as CVCSuggSellYTD,isnull(CVCContractSellYTD,0) as CVCContractSellYTD,isnull(CVCContractGM,0) as CVCContractGM,isnull(CVCStdCostPerUOM,0) as CVCStdCostPerUOM,isnull(NetWght,0) as NetWght,CASE WHEN ISNULL(NetWght, 0)= 0 THEN 0 ELSE ISNULL(CVCReplCostPerUOM, 0) / NetWght END AS ReplaceCost,isnull(CVCSuggGMPctAtAvg,0) as SuggGMPctAtAvg,isnull(ContractSellPrice,0) as ContractSellPrice,isnull(ContractSellPricePerAlt,0) as ContractSellPricePerAlt"),
                        new SqlParameter("@whereCondition", strWhere));

                return dsVelocity;
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet GetCategoryVelocityDetail(string column, string strWhere)
        {
            try
            {
                DataSet dsVelocity = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                        new SqlParameter("@tableName", "ContractBuilderCustItem"),
                        new SqlParameter("@displayColumns", column),
                        new SqlParameter("@whereCondition", strWhere));

                return dsVelocity;
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet GetCategoryMasterValue(string column, string strWhere)
        {
            try
            {
                DataSet dsMaster = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                        new SqlParameter("@tableName", "ContractBuilderdetailWorkarea"),
                        new SqlParameter("@displayColumns", column),
                        new SqlParameter("@whereCondition", strWhere));

                return dsMaster;
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public string GetCategoryCount(string categoryVelocityCode, string categoryVariance, string custNumber)
        {
            try
            {
                string category = categoryVariance.Split(' ')[0].Split('-')[0];
                string variance = categoryVariance.Split(' ')[1].Split('-')[1];

                //string category = categoryVariance.Trim().Substring(0, 5);
                //string variance = categoryVariance.Trim().Substring(categoryVariance.Trim().Length - 3, 3);

                string categoryVelocityCount = (string)SqlHelper.ExecuteScalar(connectionString, "[ugen_sp_select]",
                        new SqlParameter("@tableName", "ContractBuilderCustItem"),
                        new SqlParameter("@displayColumns", "convert(Varchar(10),count(*)) as CategoryVelocityCode"),
                        new SqlParameter("@whereCondition", "CatVelocityCd='" + categoryVelocityCode.Trim() + "' and category='" + category + "' and variance='" + variance + "' and custno='" + custNumber + "' group by CatVelocityCd"));

                if (categoryVelocityCount == null)
                    categoryVelocityCount = "0";
                return categoryVelocityCount;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public string GetCatDescription(string category)
        {
            try
            {

                string categoryDesc = (string)SqlHelper.ExecuteScalar(connectionString, "[ugen_sp_select]",
                        new SqlParameter("@tableName", "CAS_CategoryPrefixSum"),
                        new SqlParameter("@displayColumns", "Top 1 CatPrefixDesc"),
                        new SqlParameter("@whereCondition", "CatPrefix='" + category + "'"));


                return categoryDesc;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public Boolean PopulateWorkAreaRecords(string customerNumber, string userName, string entryDate)
        {
            try
            {
                if (!IsTablehasRecords(customerNumber, "ContractBuilderMasterWorkArea"))
                {
                    SqlHelper.ExecuteNonQuery(connectionString, "[pCBMstrWorkArea]",
                                        new SqlParameter("@CustNo", customerNumber),
                                        new SqlParameter("@UserID", userName),
                                        new SqlParameter("@EntryDt", entryDate));
                }
                if (!IsTablehasRecords(customerNumber, "ContractBuilderDetailWorkArea"))
                {
                    SqlHelper.ExecuteNonQuery(connectionString, "[pCBDtlWorkArea]",
                                new SqlParameter("@CustNo", customerNumber),
                                new SqlParameter("@UserID", userName),
                                new SqlParameter("@EntryDt", entryDate));
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public Boolean IsTablehasRecords(string custNumber, string tableName)
        {
            try
            {
                DataSet dsRecord = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                           new SqlParameter("@tableName", tableName),
                           new SqlParameter("@displayColumns", "custno"),
                           new SqlParameter("@whereCondition", "custno='" + custNumber + "'"));

                if (dsRecord != null && dsRecord.Tables[0].Rows.Count > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                return false;
                throw;
            }
        }
        public void GetCustomerItem(string custNumber, string categoryVariance)
        {
            try
            {
                DataSet dsRecord = SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_select]",
                           new SqlParameter("@tableName", "ContractBuilderCustItem"),
                           new SqlParameter("@displayColumns", "custno"),
                           new SqlParameter("@whereCondition", "custno='" + custNumber + "' and Category='" + categoryVariance + "'"));

                if (dsRecord == null || dsRecord.Tables[0].Rows.Count == 0)
                {
                    SqlConnection conn = new SqlConnection(connectionString);
                    SqlCommand Cmd = new SqlCommand();
                    Cmd.CommandTimeout = 0;
                    Cmd.CommandType = CommandType.StoredProcedure;
                    Cmd.Connection = conn;
                    conn.Open();
                    Cmd.CommandText = "pCBCustItemBuild";
                    Cmd.Parameters.Add(new SqlParameter("@CustNo", custNumber));
                    Cmd.Parameters.Add(new SqlParameter("@CatVarNo", categoryVariance));
                    Cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
            }
        }
        public string GetCustomerName(string custNumber)
        {
            try
            {

                string customerName = (string)SqlHelper.ExecuteScalar(connectionString, "[ugen_sp_select]",
                        new SqlParameter("@tableName", "CAS_CustomerData"),
                        new SqlParameter("@displayColumns", "Top 1 CustName"),
                        new SqlParameter("@whereCondition", "Custno='" + custNumber + "'"));


                return customerName;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        #region Select function

        /// <summary>
        /// Get the table values from the database
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <param name="whereClause"></param>
        /// <returns></returns>
        public DataSet GetDataToDateset(string tableName, string columnName, string whereClause)
        {
            try
            {

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                     new SqlParameter("@tableName", tableName),
                     new SqlParameter("@columnNames", columnName),
                     new SqlParameter("@whereClause", whereClause));

                if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    return dsDetails;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }
        #endregion
        #region Bind Dropdown function
        /// <summary>
        /// Code to Bind the drop down control
        /// </summary>
        /// <param name="ddlCurrent">Type :Dropdown </param>
        /// <param name="dataSource">Data Source to assign to Dropdown</param>
        /// <param name="textField">Dropdown text field value</param>
        /// <param name="valueField">Dropdown value field value</param>
        /// <param name="defaultText">default selected value</param>
        public void BindDropDown(DropDownList ddlCurrent, DataTable dataSource, string textField, string valueField)
        {
            try
            {
                if (dataSource != null && dataSource.Rows.Count > 0)
                {
                    ddlCurrent.DataSource = dataSource;
                    ddlCurrent.DataTextField = textField;
                    ddlCurrent.DataValueField = valueField;
                    ddlCurrent.DataBind();
                }
                else
                    // Code to add default selected item
                    ddlCurrent.Items.Add(new ListItem("N/A", ""));
            }
            catch (Exception ex) { }
        }
        #endregion

        #region List Name Fill Method
        /// <summary>
        /// Used to Fill List name
        /// </summary>
        /// <param name="ddlListName">List Master Dropdown control</param>
        public void FillListMonth(DropDownList ddlListMonth)
        {
            try
            {
                DataSet dsListName = GetDataToDateset("(SELECT DISTINCT  ItemCostAnalysis.ACPeriod, CalendarTrans.ListDtlDesc, CalendarTrans.ListValue,CalendarTrans.SequenceNo FROM (SELECT ListMaster.ListName,ListDetail.ListValue,ListDetail.ListDtlDesc,ListDetail.SequenceNo FROM ListMaster INNER JOIN  ListDetail ON ListMaster.pListMasterID = ListDetail.fListMasterID WHERE (ListMaster.ListName = 'CalendarPeriod')) CalendarTrans INNER JOIN ItemCostAnalysis ON CalendarTrans.ListValue COLLATE SQL_Latin1_General_CP1_CI_AS = RIGHT(ItemCostAnalysis.ACPeriod, 2)) PeriodCombo", "ListDtlDesc + ' ' + LEFT(ACPeriod, 4) AS MonthText,ListValue +'~'+LEFT(ACPeriod, 4)  as ListValue", " ListValue <>'' ORDER BY LEFT(ACPeriod, 4), SequenceNo");
                if (dsListName != null && dsListName.Tables[0].Rows.Count > 0)
                    BindDropDown(ddlListMonth, dsListName.Tables[0], "MonthText", "ListValue");
            }
            catch (Exception ex)
            {

                throw;
            }

        }
        #endregion
    }
}

