/********************************************************************************************
 * File	Name			:	Utility.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	04/12/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 04/12/2007		    Version 1		A.Nithyapriyadarshini		Created 
*********************************************************************************************/

#region Namespace

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
using PFC.Intranet.DataAccessLayer;

#endregion

namespace GER
{
    public class Utility
    {

        #region Developer Generated Code

        /// <summary>
        /// GetDataSet: Method used to get BOL Header information
        /// </summary>
        /// <param name="tableName"> DataType:String Required tableName </param>
        /// <param name="columnName">DataType:String Required columnName </param>
        /// <param name="condition">DataType:String Required condition</param>
        /// <returns>Return retrived data as DataTable </returns>

        public DataTable GetDataSet(string tableName, string columnName, string condition)
        {

            try
            {
                DataSet dsVendor = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@displayColumns", columnName),
                    new SqlParameter("@whereCondition", condition));

                if (dsVendor.Tables[0] != null)
                    return dsVendor.Tables[0];
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }

        /// <summary>
        /// BindListControl: Method used to bind BOL Header information in Combo
        /// </summary>
        /// <param name="ddlGER">Required ListControl</param>
        /// <param name="textField"> DataType:String Required textField </param>
        /// <param name="valueField">DataType:String Required valueField </param>
        /// <param name="dtDataSource">Required DataTable</param>
        /// <returns></returns>
        
        public void BindListControl(ListControl ddlGER, string textField, string valueField, DataTable dtDataSource)
        {
            try
            {
                ddlGER.DataSource = dtDataSource;
                ddlGER.DataTextField = textField;
                ddlGER.DataValueField = valueField;
                ddlGER.DataBind();
                ddlGER.Items.Insert(0, new ListItem("--- Select ---", "0"));

            }
            catch (Exception ex) { }
        }

        /// <summary>
        /// ValidatePFCItemNo: Method used to validate the PFCItemNo
        /// </summary>
        /// <param name="strPFCItem"> DataType:String Required PFCItemNo </param>
        /// <returns>Return retrived data as string </returns>
        
        public string ValidatePFCItemNo(string strPFCItem)
        {
            try
            {

                string valTxtBox = "false";
                DataTable dtItem = new DataTable();
                if (strPFCItem != "")
                {
                    DataSet dsItem = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "Porteous$Item"),
                    new SqlParameter("@displayColumns", "No_,Description"),
                    new SqlParameter("@whereCondition", "No_='" + strPFCItem + "'"));
                    dtItem = dsItem.Tables[0];
                    foreach (DataRow dr in dtItem.Rows)
                    {
                        if (strPFCItem == dr["No_"].ToString())
                        {
                            valTxtBox = "true";
                            break;
                        }

                    }

                }
                return valTxtBox;
            }
            catch (Exception ex)
            { return ""; }

        } 

        #endregion
               
    }

    
}
