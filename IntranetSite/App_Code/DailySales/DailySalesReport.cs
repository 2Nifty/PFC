#region Header
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
#endregion

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for DailySalesReport
    /// </summary>
    public class DailySalesReport
    {
        #region Local variables
        //ConnectionString
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();


        string whereClause = "";
        DataSet dsDetails = new DataSet();
        DataSet dsDate = new DataSet();
        private string startDate;
        private string endDate; 
        #endregion
        
        #region Properties

        /// <summary>
        /// StartDate Property bag
        /// </summary>
        public string StartDate
        {
            get
            {
                return startDate;
            }
            set { startDate = value; }
        }
        /// <summary>
        /// EndDate Property bag
        /// </summary>
        public string EndDate
        {
            get
            {
                return endDate;
            }
            set { endDate = value; }
        } 
        #endregion

        #region Constructor

        /// <summary>
        /// DailySalesReport Constructor
        /// </summary>
        public DailySalesReport()
        {
            //
            // TODO: Add constructor logic here
            //
        } 
        #endregion

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

                dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
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
        /// <summary>
        ///  Get the sales details from the database
        /// </summary>
        /// <param name="location"></param>
        /// <returns></returns>
        public DataTable GetSalesToDatetable(string location)
        {
            try
            {

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string spName = "[pDailySalesAnalysis]";

                    if(location.Trim() == "ALL")
                        spName = "[pDailySalesAnalysisALL]";

                    SqlDataAdapter adp;
                    SqlCommand Cmd = new SqlCommand();
                    Cmd.CommandTimeout = 0;
                    Cmd.CommandType = CommandType.StoredProcedure;
                    Cmd.Connection = conn;
                    conn.Open();
                    Cmd.CommandText = spName;
                    Cmd.Parameters.Add(new SqlParameter("@Location", location));
                    Cmd.Parameters.Add(new SqlParameter("@StartDate", Convert.ToDateTime(StartDate).ToShortDateString()));
                    Cmd.Parameters.Add(new SqlParameter("@EndDate", Convert.ToDateTime(EndDate).ToShortDateString()));
                   
                    adp = new SqlDataAdapter(Cmd);
                    adp.Fill(dsDetails);
                   
                }
               
                return dsDetails.Tables[0];
               
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// GetDateRange : Method used to get default date range
        /// </summary>
        public void GetDateRange()
        {
            try
            {

                dsDate = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                     new SqlParameter("@tableName", "DashboardRanges"),
                     new SqlParameter("@columnNames", "BegDate,EndDate"),
                     new SqlParameter("@whereClause", "DashboardParameter='CurrentDay'"));

                if (dsDate != null && dsDate.Tables[0].Rows.Count > 0)
                {
                    StartDate = dsDate.Tables[0].Rows[0][0].ToString();
                    EndDate = dsDate.Tables[0].Rows[0][1].ToString();
                }


            }
            catch (Exception ex) { }
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
        public void BindDropDown(DropDownList ddlCurrent, DataTable dataSource, string textField, string valueField, string defaultText)
        {
            try
            {
                if (dataSource != null && dataSource.Rows.Count > 0)
                {
                    ddlCurrent.DataSource = dataSource;
                    ddlCurrent.DataTextField = textField;
                    ddlCurrent.DataValueField = valueField;
                    ddlCurrent.DataBind();

                    // Code to add default selected item
                    ddlCurrent.Items.Insert(0, new ListItem(defaultText, ""));
                }
                else
                    // Code to add default selected item
                    ddlCurrent.Items.Add(new ListItem("N/A", ""));
            }
            catch (Exception ex) { }
        }

        #endregion

    }// End Class

}// End Namespace