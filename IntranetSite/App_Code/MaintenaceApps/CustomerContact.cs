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

namespace PFC.Intranet.MaintenanceApps
{
    public class CustomerContact
    {
        //For Security Code
        string securityTable = "SecurityGroups SG (NoLock), dbo.SecurityMembers SM (NoLock), dbo.SecurityUsers SU (NoLock)";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause = string.Empty;

        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='CustContact (W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";
            }
            catch (Exception Ex) { return ""; }
        }
        #endregion

        public DataTable SuggestCustomerNames(string customerNumber)
        {
            try
            {
                string _whereClause = "(CustName like '%" + customerNumber + "%' or CustNo like '%" + customerNumber + "%')";

                DataSet dtCustomerMaster = new DataSet();
                dtCustomerMaster = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "CustomerMaster (NoLock)"),
                                    new SqlParameter("@columnNames", "Top 20 CustNo + ' - ' + CustName as Name, CustNo as CustNo"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dtCustomerMaster.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetCustomerMasterInformation(string customerNumber)
        {
            try
            {
                bool isNumber;
                int intNum;
                string _whereClause = string.Empty;

                isNumber = Int32.TryParse(customerNumber, out intNum);

                string custType = "";

                if (isNumber)
                {
                    custType = (string)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                                   new SqlParameter("@tableName", "CustomerMaster (NoLock)"),
                                   new SqlParameter("@columnNames", "CustCd"),
                                   new SqlParameter("@whereClause", "CustNo='" + customerNumber + "'"));
                    _whereClause = " (Cust.CustNo='" + customerNumber + "')";
                }
                else
                {
                    custType = (string)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                                   new SqlParameter("@tableName", "CustomerMaster (NoLock)"),
                                   new SqlParameter("@columnNames", "CustCd"),
                                   new SqlParameter("@whereClause", "CustName='" + customerNumber + "'"));
                    _whereClause = " (Cust.CustName='" + customerNumber + "')";
                }

                _whereClause += " and Addr.Type in ('','P')";

                DataSet dtCustomerMaster = new DataSet();
                dtCustomerMaster = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "CustomerMaster Cust (NoLock) LEFT OUTER JOIN CustomerAddress Addr (NoLock) ON Cust.pCustMstrID = Addr.fCustomerMasterID"),
                                    new SqlParameter("@columnNames", "Cust.CustName, Addr.pCustomerAddressID, Addr.AddrLine1, Addr.City, Addr.State, Addr.PostCd, Addr.Country, Cust.CustType, Cust.BuyGroup, Cust.PriceCd, Cust.CreditInd"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dtCustomerMaster.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable GetCustomerContact(string customerNumber, string dataColumn)
        {
            try
            {
                string _whereClause = dataColumn + "='" + customerNumber + "'";
                DataSet dtCustomerContact = new DataSet();
                dtCustomerContact = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "CustomerContact (NoLock)"),
                                    new SqlParameter("@columnNames", "pCustContactsID, Name, ContactType, JobTitle, Phone, MobilePhone, FaxNo, EmailAddr, Department, PhoneExt, AllowMarketingEmailInd, Entrydt, EntryID, ChangeID, ChangeDt"),
                                    new SqlParameter("@whereClause", _whereClause + " order by Name"));

                return dtCustomerContact.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertTables(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "pSOEInsert",
                             new SqlParameter("@tableName", "CustomerContact"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }

        public void UpdateCustomerContact(string tableName, string columnValue, string where)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                                             new SqlParameter("@tableName", tableName.Trim()),
                                             new SqlParameter("@columnNames", columnValue),
                                             new SqlParameter("@whereClause", where));
            }
            catch (Exception ex) { }
        }

        public void BindCustomerType(DropDownList ddlCusttype)
        {
            string _whereClause = "LM.pListMasterID = LD.fListMasterID and LM.ListName = 'ContactType'Order by LD.SequenceNo";
            string _tableName = "ListMaster LM (NoLock), ListDetail LD (NoLock) ";
            string _columnName = "LD.ListValue as ListValue, LD.ListDtlDesc as ListDtlDesc";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlCusttype.DataSource = dslist.Tables[0];
                ddlCusttype.DataTextField = "ListDtlDesc";
                ddlCusttype.DataValueField = "ListValue";
                ddlCusttype.DataBind();
            }

            ListItem item = new ListItem("     ---Select---     ", "");
            ddlCusttype.Items.Insert(0, item);
        }

        public void BindPriceCd(DropDownList ddlPriceCd)
        {
            string _whereClause = "LM.ListName = 'CustPriceCd' Order by SequenceNo ";
            string _tableName = "ListDetail LD (NoLock) INNER JOIN  ListMaster LM (NoLock) ON LD.fListMasterID = LM.pListMasterID ";
            string _columnName = " Rtrim(LD.ListValue) as Value, LD.ListValue + ' - ' + LD.ListDtlDesc as ListDetail";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlPriceCd.DataSource = dslist.Tables[0];
                ddlPriceCd.DataTextField = "ListDetail";
                ddlPriceCd.DataValueField = "Value";
                ddlPriceCd.DataBind();
            }

            ListItem item = new ListItem("     --- Select ---     ", "");
            ddlPriceCd.Items.Insert(0, item);
        }

        public void BindBuyingGroup(DropDownList ddlBuyingGroup)
        {
            string _whereClause = "LM.ListName = 'BuyGrp' Order by SequenceNo ";
            string _tableName = "ListDetail LD (NoLock) INNER JOIN  ListMaster LM (NoLock) ON LD.fListMasterID = LM.pListMasterID ";
            string _columnName = " Rtrim(LD.ListValue) as Value, LD.ListValue + ' - ' + LD.ListDtlDesc as ListDetail";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlBuyingGroup.DataSource = dslist.Tables[0];
                ddlBuyingGroup.DataTextField = "ListDetail";
                ddlBuyingGroup.DataValueField = "Value";
                ddlBuyingGroup.DataBind();
            }

            ListItem item = new ListItem("     --- Select ---     ", "");
            ddlBuyingGroup.Items.Insert(0, item);
        }

        public void BindCustType(DropDownList ddlCustomerType)
        {
            string _whereClause = "LM.ListName = 'CustType' Order by SequenceNo";
            string _tableName = "ListDetail LD (NoLock) INNER JOIN  ListMaster LM (NoLock) ON LD.fListMasterID = LM.pListMasterID ";
            string _columnName = " LD.ListValue as Value, LD.ListValue + ' - ' + LD.ListDtlDesc as ListValues";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlCustomerType.DataSource = dslist.Tables[0];
                ddlCustomerType.DataTextField = "ListValues";
                ddlCustomerType.DataValueField = "Value";
                ddlCustomerType.DataBind();
            }

            ListItem item = new ListItem("     --- Select ---     ", "");
            ddlCustomerType.Items.Insert(0, item);
        }

        //public void BindCustomerCustType(DropDownList ddlCustomerType,string custNo)
        //{
        //    string _whereClause = "CustNo='" + custNo + "'";
        //    string _tableName = "CustomerMaster";
        //    string _columnName = "*";

        //    DataSet dslist = new DataSet();
        //    dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
        //                        new SqlParameter("@tableName", _tableName),
        //                        new SqlParameter("@columnNames", _columnName),
        //                        new SqlParameter("@whereClause", _whereClause));
        //    if (dslist.Tables[0].Rows.Count > 0)
        //    {
        //        ddlCustomerType.DataSource = dslist.Tables[0];
        //        ddlCustomerType.DataTextField = "CustType";
        //        ddlCustomerType.DataValueField = "CustType";
        //        ddlCustomerType.DataBind();
        //    }
        //    else
        //    {
        //        ListItem item = new ListItem("     ---NA---     ", "");
        //        ddlCustomerType.Items.Insert(0, item);
        //    }
           
        //}

        //public void BindCustomerBuyingGroup(DropDownList ddlBuyingGroup,string custN0)
        //{
        //    string _whereClause = "CustNo='"+custN0+"'";
        //    string _tableName = "CustomerMaster";
        //    string _columnName = "*";

        //    DataSet dslist = new DataSet();
        //    dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
        //                        new SqlParameter("@tableName", _tableName),
        //                        new SqlParameter("@columnNames", _columnName),
        //                        new SqlParameter("@whereClause", _whereClause));
        //    if (dslist.Tables[0].Rows.Count > 0)
        //    {
        //        if (dslist.Tables[0].Rows[0]["BuyGroup"].ToString().ToLower() != null && dslist.Tables[0].Rows[0]["BuyGroup"].ToString().ToLower() != "")
        //        {
        //            ddlBuyingGroup.DataSource = dslist.Tables[0];
        //            ddlBuyingGroup.DataTextField = "BuyGroup";
        //            ddlBuyingGroup.DataValueField = "BuyGroup";
        //            ddlBuyingGroup.DataBind();
        //        }
        //        else
        //        {
        //            ddlBuyingGroup.Items.Clear();
        //            ddlBuyingGroup.Items.Insert(0, new ListItem("N/A", ""));
        //        }
        //    }
        //    else
        //    {
        //        ddlBuyingGroup.Items.Clear();
        //        ddlBuyingGroup.Items.Insert(0, new ListItem("N/A", ""));
                
        //    }

        //}

        public void DeleteCustomerContact(string custContactID)
        {
            try
            {
                whereClause = "pCustContactsID =" + custContactID;
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "CustomerContact"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
            }

        }

        public DataTable GetContacttype(string cntType)
        {
            try
            {
                string _whereClause = "LM.pListMasterID = LD.fListMasterID and LM.ListName = 'ContactType' and LD.ListValue ='" + cntType + "' Order by LD.SequenceNo";
                string _tableName = "ListMaster LM (NoLock), ListDetail LD (NoLock) ";
                string _columnName = "LD.ListValue as ListValue, LD.ListDtlDesc as ListDtlDesc";

                DataSet dslist = new DataSet();
                dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));

                return dslist.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
