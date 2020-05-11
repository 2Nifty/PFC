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
    public class PhysicalInventoryAdjustment
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string reportConnectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        string RBConnectionString = ConfigurationManager.AppSettings["PFCRBConnectionString"].ToString();
        string customerSortExpression = "";

        public DataSet GetInventoryData(string brnachID)
        {

            try
            {
                // Code to execute the stored procedure
                DataSet dsData = new DataSet();
                SqlConnection conn = new SqlConnection(RBConnectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "[pPhyInvAdjust]";
                Cmd.Parameters.Add(new SqlParameter("@SalesBranch", brnachID));             
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsData);              

                return dsData;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
       
        public DataTable GetERPBranches()
        {
            try
            {

                string _tableName = "LocMaster (NOLOCK)";
                string _columnName = "LOCID as Code,LOCID + ' - ' + [LocName] as Name";
                string _whereClause = "ShipMethCd='ERP' order by  LOCID asc ";

                DataSet dsType = SqlHelper.ExecuteDataset(ERPConnectionString, "UGEN_Sp_Select",
                 new SqlParameter("@tableName", _tableName),
                 new SqlParameter("@columnNames", _columnName),
                 new SqlParameter("@whereClause", _whereClause));

                return dsType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetItemInformation(string itemNo)
        {
            // get the data.
            DataSet dsitemDetail = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOEGetItemAlias]",
                        new SqlParameter("@SearchItemNo", itemNo),
                        new SqlParameter("@Organization", ""),
                        new SqlParameter("@PrimaryBranch", ""),
                        new SqlParameter("@SearchType", "PFC"));

            if (dsitemDetail.Tables.Count >= 1)
            {
                if (dsitemDetail.Tables.Count == 1)
                {
                    if (dsitemDetail.Tables[0].Rows.Count > 0)
                    {
                        return null;
                    }
                }
                else
                {
                    return dsitemDetail.Tables[1];
                }
            }

            return null;
        }

        public void SubmitChanges(DataTable dtNewChanges)
        {
            SqlBulkCopy sqlBC = new SqlBulkCopy(RBConnectionString);
            try
            {               
                sqlBC.DestinationTableName = "PhysicalInventoryERPAdj";
                sqlBC.WriteToServer(dtNewChanges);
                sqlBC.Close();

                SqlHelper.ExecuteNonQuery(RBConnectionString, "[pPhyInvCreateCARec]");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                sqlBC.Close();
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
                    
                    if(defaultValue != "")
                        lstControl.Items.Insert(0, new ListItem(defaultValue, ""));
                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("ALL", ""));
                    }

                }
            }
            catch (Exception ex) { throw ex; }
        }

        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU"),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='Admin (W)' OR SG.groupname='PhyAdj (W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
    }

}