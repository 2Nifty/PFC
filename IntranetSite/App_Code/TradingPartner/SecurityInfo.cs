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
using System.Data.Sql;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for SecurityGroup
    /// </summary>
    public class SecurityInfo
    {

        string tableName = "";
        string columnName = "";
        string whereClause = "";

        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public DataTable GetGroups(string whereCondition)
        {
            try
            {

                //columnName = "SG.GroupName,SM.SecurityGroupApp as AppName,SG.pSecGroupId as GroupId";
                //tableName = "SecurityGroups SG inner join SecurityMembers SM on SG.pSecGroupId=SM.SecGroupId";
                //if (whereCondition != "")
                //    whereClause = whereCondition + " Order By SG.GroupName ";
                //else
                //    whereClause = "1=1";

                // DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                //                        new SqlParameter("@tableName", tableName),
                //                        new SqlParameter("@columnNames", columnName),
                //                        new SqlParameter("@whereClause", whereClause));

                //return dsDetails.Tables[0];
                columnName = "SG.GroupName,SG.SecurityGroupApp as AppName,SG.pSecGroupId as GroupId";
                tableName = "SecurityGroups SG ";
                if (whereCondition != "")
                    whereClause = "SG.DeleteDt is null and " + whereCondition + " Order By SG.GroupName ";
                else
                    whereClause = "SG.DeleteDt is null";

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                       new SqlParameter("@tableName", tableName),
                                       new SqlParameter("@columnNames", columnName),
                                       new SqlParameter("@whereClause", whereClause));

                return dsDetails.Tables[0];

            }
            catch (Exception ex)
            { throw ex; }
        }
        public DataTable CountUser(string whereCondition)
        {
            try
            {
                //tableName = "SecurityGroups SG inner join SecurityMembers SM on SG.pSecGroupId=SM.SecGroupId";
                //columnName = "SG.GroupName,SG.SecurityGroupApp,SG.pSecGroupID";
                //whereClause = "SG.DeleteDt is null " + whereCondition;

                //DataSet dsUser = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                //            new SqlParameter("@tableName", tableName),// "EmployeeMaster"),
                //            new SqlParameter("@columnNames", columnName),// "EmployeeName"),
                //            new SqlParameter("@whereClause", whereClause));

                //return dsUser.Tables[0];
                tableName = "SecurityGroups SG ";
                columnName = "SG.GroupName,SG.SecurityGroupApp,SG.pSecGroupID";
                whereClause = "SG.DeleteDt is null " + whereCondition;

                DataSet dsUser = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                            new SqlParameter("@tableName", tableName),// "EmployeeMaster"),
                            new SqlParameter("@columnNames", columnName),// "EmployeeName"),
                            new SqlParameter("@whereClause", whereClause));

                return dsUser.Tables[0];

            }

            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable GetGroupData(string GroupName,string Group,string ID)
        {
            try
            {
                tableName = "SecurityGroups";
                columnName = "pSecGroupID,GroupName,SecurityGroupApp,GroupDesc,Comments";
                if (Group == "GroupName")
                {
                    whereClause = "pSecGroupID='" + ID + "' and GroupName='" + GroupName + "' and DeleteDt is null";
                }
                else
                { whereClause = "pSecGroupID='"+ID+ "' and SecurityGroupApp='" + GroupName + "' and DeleteDt is null"; }

                DataSet dsEmployee = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                   new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause));
                return dsEmployee.Tables[0];

            }
            catch (Exception ex)
            { throw ex; }
        }
        public DataTable CheckGroupData(string GroupName)
        {
            try
            {
                tableName = "SecurityGroups";
                columnName = "pSecGroupID,GroupName,SecurityGroupApp,GroupDesc,Comments";
                whereClause = "GroupName not in('" + GroupName + "','" + GroupName + "') and DeleteDt is null";

                DataSet dsEmployee = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                   new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause));
                return dsEmployee.Tables[0];

            }
            catch (Exception ex)
            { throw ex; }
        }
        public DataTable GetBindData(string whereClause)
        {
            try
            {
                tableName = "ListDetail LD,ListMaster LM";
                columnName = "LD.ListValue,LD.ListDtlDesc";



                DataSet dsProgram = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsProgram.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
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
        public string InsertSecurityGroupData(string columnValue)
        {
            try
            {
                tableName = "SecurityGroups";
                columnName = "GroupName,SecurityGroupApp,Comments,GroupDesc,EntryID,EntryDt";

                object objUserId = (object)SqlHelper.ExecuteScalar(connectionString, "[pSOEInsert]",
                                       new SqlParameter("@tableName", tableName),
                                       new SqlParameter("@columnNames", columnName),
                                       new SqlParameter("@ColumnValues", columnValue)).ToString();

                return objUserId.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
                return null;
            }
        }
        public void UpdateSecurityGroupData(string columnValues, string GroupID)
        {
            try
            {
                whereClause = "pSecGroupID=" + GroupID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "SecurityGroups"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}