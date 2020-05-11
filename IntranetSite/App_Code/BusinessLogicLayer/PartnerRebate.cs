using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;


namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for PartnerRebate
    /// </summary>

    public enum MessageType
    {
        Success,
        Failure,
        None
    }
    public class PartnerRebate
    {

        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";

        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string reportConnection = ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ToString();
       
        public DataTable GetProgram()
        {
            try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                //_columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'PreferPartnerRebate' And LD.fListMasterID = LM.pListMasterID ";


                DataSet dsProgram = SqlHelper.ExecuteDataset(reportConnection, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsProgram.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetChainName(string chain)
        {
            try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'CustChainName' And LD.fListMasterID = LM.pListMasterID AND LD.ListValue='" + chain + "'";


                string chainName = SqlHelper.ExecuteScalar(reportConnection, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return chainName;
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public DataTable GetCustomerNo()
        {
            try
              {
                _tableName = "CustomerMaster";
                _columnName = "distinct CustNo,CustName";
                _whereClause = "CustNo <> ''";

                DataSet dsCust = SqlHelper.ExecuteDataset(reportConnection, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsCust.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataTable GetChainNo()
        {
            try
            {
                _tableName = "CustomerMaster";
                _columnName = "distinct ChainCd,ChainCd";
                _whereClause = "ChainCd <>'' and ChainCd not like '%[0-9]%' Order by Chaincd ";

                DataSet dsCust = SqlHelper.ExecuteDataset(reportConnection, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsCust.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataTable GetData(string whereClause)
        {
            try
            {
                _tableName =    " ListDetail INNER JOIN " +
                                " ListMaster ON ListDetail.fListMasterID = ListMaster.pListMasterID RIGHT OUTER JOIN " +
                                " SalesPrograms ON ListDetail.ListValue = SalesPrograms.Category";
                _columnName =   "ListDetail.ListDtlDesc as Description, SalesPrograms.ProgramName, SalesPrograms.CustNoChainCd, SalesPrograms.Category," +
                                "SalesPrograms.SalesHistory, SalesPrograms.SalesBaseline, SalesPrograms.SalesGoal, SalesPrograms.RebatePct,SalesPrograms.pSalesProgramId as SalesID";

                DataSet dsRebate = SqlHelper.ExecuteDataset(reportConnection, "UGEN_SP_Select",
                                   new SqlParameter("@tableName", _tableName),
                                   new SqlParameter("@columnNames", _columnName),
                                   new SqlParameter("@whereClause", "(ListMaster.ListName = 'CategoryDesc') and "+ whereClause));
                return dsRebate.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetCategory()
        { 
             try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "LD.ListdtlDesc as Description,LD.ListValue as Category ";
                _whereClause = "LM.ListName = 'CategoryDesc' And LD.fListMasterID = LM.pListMasterID ";

                DataSet dsProgram = SqlHelper.ExecuteDataset(reportConnection, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsProgram.Tables[0];
               
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public string GetValue(string category)
        {
            try
            {
                string sValue="";

                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(LD.ListValue+'-'+LD.ListdtlDesc) as Description ";
                _whereClause = "LM.ListName = 'CategoryDesc' And LD.fListMasterID = LM.pListMasterID  "+
                                "and LD.ListValue ='"+category +"'";

                DataSet dsProgram = SqlHelper.ExecuteDataset(reportConnection, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                if (dsProgram.Tables[0] != null && dsProgram.Tables[0].Rows.Count > 0)
                {
                    sValue = dsProgram.Tables[0].Rows[0]["Description"].ToString();
                }
                return sValue;
            }
            catch (Exception ex)
            {
                return null;
            }

            
        }

        public string GetSalesHist(string Category)
        {
            try
            {
                string  strSales = "";
                DataSet dsSales = SqlHelper.ExecuteDataset(reportConnection, "pRebateSalesHist",
                                  new SqlParameter("@Category", Category));

                if (dsSales != null && dsSales.Tables[0].Rows.Count > 0)
                {
                    strSales = dsSales.Tables[0].Rows[0]["History"].ToString().Trim();
                }
                return strSales;

            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public void UpdateValue(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(reportConnection, "[ugen_sp_update]",
                             new SqlParameter("@tableName", "SalesPrograms"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }
        public object InsertTables(string columnNames, string columnValues)
        {
            try
            {
                object insertID = (object)SqlHelper.ExecuteScalar(reportConnection, "[UGen_sp_insert]",
                             new SqlParameter("@tableName", "SalesPrograms"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
                return insertID;
            }
            catch (Exception ex)
            {
                return null;
                throw ex;
            }
        }
        public void DeleteTables(string where)
        {
            try
            {
                 SqlHelper.ExecuteNonQuery (reportConnection, "[UGen_sp_delete]",
                             new SqlParameter("@tableName", "SalesPrograms"),
                             new SqlParameter("@whereClause", where));
               
            }
            catch (Exception ex)
            {
               
                throw ex;
            }
        }

        //public string GetId()
        //{
        //    string id="";
        //    try
        //    {
        //        _tableName = "SalesPrograms";
        //        _columnName = "top 1 pSalesProgramId";
        //        _whereClause = "1=1 order by pSalesProgramId desc";
        //        DataSet dsRebate = SqlHelper.ExecuteDataset(reportConnection, "UGEN_SP_Select",
        //                           new SqlParameter("@tableName", _tableName),
        //                           new SqlParameter("@columnNames", _columnName),
        //                           new SqlParameter("@whereClause", _whereClause));
        //        if (dsRebate.Tables[0].Rows.Count > 0 && dsRebate.Tables[0] != null)
        //        {
        //            id = dsRebate.Tables[0].Rows[0]["pSalesProgramId"].ToString(); 
        //        }
        //        return id;

        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(reportConnection, "[UGen_sp_update]",
                             new SqlParameter("@tableName", "[SalesPrograms]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="lstControl"></param>
        /// <param name="textField"></param>
        /// <param name="valueField"></param>
        /// <param name="dtSource"></param>
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
        /// <summary>
        /// Public method to set selected value in dropdown controls
        /// </summary>
        /// <param name="lstControl"></param>
        /// <param name="selectedValue"></param>
        public void HighlightDropdownValue(DropDownList lstControl, string selectedValue)
        {
            foreach (ListItem item in lstControl.Items)
            {
                if (item.Value.ToLower().Trim() == selectedValue.Trim().ToLower())
                    item.Selected = true;
            }
        }

        public void DisplayMessage(MessageType messageType, string messageText, Label lblMessage)
        {
            switch (messageType)
            {
                case MessageType.Success:
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case MessageType.Failure:
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;
                case MessageType.None :
                   
                    break;

            }

            lblMessage.Text = messageText;
            lblMessage.Visible = true;
        }

    }
}