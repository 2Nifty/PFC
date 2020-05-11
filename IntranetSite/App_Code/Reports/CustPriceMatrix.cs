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

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for InvoiceRegisterRep
    /// </summary>
    public class CustPriceMatrix
    {
        string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public DataSet GetPriceMatrixDDLData()
        {
            try 
	        {
                DataSet dsType = SqlHelper.ExecuteDataset(erpConnectionString, "[pFillCustPriceMatrixDDL]");
                return dsType;
	        }
	        catch (Exception ex)
	        {	
		        return null ;
	        }
        }


        public DataSet GetPriceMatrixReportData(string territory, string outsideRep, string insideRep,string region,string buyGroup)
        {
            DataSet dsReportData = new DataSet();
            SqlConnection conn = new SqlConnection(erpConnectionString);
            SqlDataAdapter adp;
            SqlCommand Cmd = new SqlCommand();

            try
            {
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "pCustPriceMatrixRpt";
                Cmd.Parameters.Add(new SqlParameter("@FilterValue1", territory));
                Cmd.Parameters.Add(new SqlParameter("@FilterValue2", outsideRep));
                Cmd.Parameters.Add(new SqlParameter("@FilterValue3", insideRep));
                Cmd.Parameters.Add(new SqlParameter("@FilterValue4", region));
                Cmd.Parameters.Add(new SqlParameter("@FilterValue5", buyGroup));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsReportData);

                return dsReportData;
            }
            catch (Exception ex)
            {
                return null;
            }
            finally
            {
                conn.Close();
            }
        }

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
                    
                    //if(defaultValue != "")
                        lstControl.Items.Insert(0, new ListItem(defaultValue, ""));
                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("", ""));
                    }

                }
            }
            catch (Exception ex) { throw ex; }
        }
    }

}