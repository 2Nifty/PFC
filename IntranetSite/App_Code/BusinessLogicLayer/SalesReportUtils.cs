using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI.WebControls;

using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for SalesReportUtils
    /// </summary>
    public class SalesReportUtils
    {
        /// <summary>
        /// public method GetALLBranches is used to fill authorized branches 
        /// in DropDownList ddlBranch
        /// </summary>
        /// <param name="ddlBranch">DropDownList control ID</param>
        /// <param name="userID">string userID</param>
        public void GetALLBranches(DropDownList ddlBranch,string userID)
        {
            try
            {
                ddlBranch.DataSource = System.Web.HttpContext.Current.Session["BranchComboValues"] as DataSet;
                ddlBranch.DataTextField = "Name";
                ddlBranch.DataValueField = "Branch";
                ddlBranch.DataBind();
                ddlBranch.Items.Insert(0, new ListItem("ALL", System.Web.HttpContext.Current.Session["BranchIDForALL"].ToString() + " "));
            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        /// public method GetAuthorizedBranches is used to fill authorized branches 
        /// in DropDownList ddlBranch
        /// </summary>
        /// <param name="ddlBranch">DropDownList control ID</param>
        /// <param name="userID">string userID</param>
        //public void GetAuthorizedBranches(DropDownList ddlBranch, string userID)
        //{

        //    try
        //    {
        //        string authCompanyID = GetAuthorizedBranchID(userID);             

        //        DataSet dsBranch = (DataSet)SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
        //                                new SqlParameter("@TableName", "KPIBranches"),
        //                                new SqlParameter("@columnNames", "rtrim(Branch) as Branch,Branch+' - '+BranchName as Name"),
        //                                new SqlParameter("@whereClause", "Branch in (" + authCompanyID + ") and ExcludefromKPI<>'1' order by Branch"));

        //        ddlBranch.DataSource = dsBranch;
        //        ddlBranch.DataTextField = "Name";
        //        ddlBranch.DataValueField = "Branch";
        //        ddlBranch.DataBind();               
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}
        /// <summary>
        /// public method GetAuthorizedBranches is used to fill authorized branches 
        /// in DropDownList ddlBranch
        /// </summary>
        /// <param name="ddlBranch">DropDownList control ID</param>
        /// <param name="userID">string userID</param>
        public void GetAuthorizedBranches(DropDownList ddlBranch, string userID)
        {
            try
            {
                DataSet ds =System.Web.HttpContext.Current.Session["BranchComboValues"] as DataSet;
                ddlBranch.DataSource = ds ;
                ddlBranch.DataTextField = "Name";
                ddlBranch.DataValueField = "Branch";
                ddlBranch.DataBind();
            }
            catch (Exception ex)
            {
			// HttpContext.Current.Response.Write(ex.Message);
            }
        }
        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="userID"></param>
        ///// <returns></returns>
        //public string GetAuthorizedBranchID(string userID)
        //{
        //    string authCompanyID = "";
        //    string authBranchID="";
        //    try
        //    {
        //        DataSet dsAuthBranch = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, "[UGEN_SP_Select]",
        //                                       new SqlParameter("@TableName", "UCOR_UserAuthorizedCompanies"),
        //                                       new SqlParameter("@columnNames", "AuthCompanyID"),
        //                                       new SqlParameter("@whereClause", "UserID='" + userID + "'"));

        //        for (int i = 0; i < dsAuthBranch.Tables[0].Rows.Count; i++)
        //        {
        //            string brnID = string.Empty;
        //            if (dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString().Length == 1)
        //                brnID = "0" + dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString();
        //            else
        //                brnID = dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString();   
        //            authCompanyID += ",'" + brnID.Trim() +"'";
        //            authBranchID += "," + dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString().Trim();
        //        }
        //        authCompanyID = authCompanyID.Remove(0, 1);
        //        authBranchID = authBranchID.Remove(0, 1);
        //        System.Web.HttpContext.Current.Session["AuthorizedBranch"] = authCompanyID;
        //        return authBranchID;
        //    }
        //    catch (Exception ex)
        //    {
        //        return "";
        //    }
        //}
        public string GetAuthorizedBranchID(string userID)
        {
            string authCompanyID = "";
            string authBranchID = "";
            try
            {
                DataSet dsAuthBranch = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, "[UGEN_SP_Select]",
                                               new SqlParameter("@TableName", "UCOR_UserAuthorizedCompanies a,UCOR_CompanyProfile b"),
                                               new SqlParameter("@columnNames", "a.AuthCompanyID as CompanyID,b.code as AuthCompanyID"),
                                               new SqlParameter("@whereClause", "a.UserID='" + userID + "' and  a.AuthCompanyID =b.CompanyID"));

                for (int i = 0; i < dsAuthBranch.Tables[0].Rows.Count; i++)
                {
                    string brnID = string.Empty;
                    if (dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString().Length == 1)
                        brnID = "0" + dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString();
                    else
                        brnID = dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString();
                    authCompanyID += ",'" + brnID.Trim() + "'";
                    authBranchID += "," + dsAuthBranch.Tables[0].Rows[i]["AuthCompanyID"].ToString().Trim();
                }
                authCompanyID = authCompanyID.Remove(0, 1);
                authBranchID = authBranchID.Remove(0, 1);
                System.Web.HttpContext.Current.Session["AuthorizedBranch"] = authCompanyID;
                return authBranchID;
            }
            catch (Exception ex)
            {
                return "";
            }
        }
        public void GetALLReps(DropDownList ddlRep,string conValue)
        {
		try
            {
                string condition = (conValue != "0") ? "SalesLoc in(" + conValue.Trim() + ")" : "";
                //string condition ="1=1";
                DataSet dsChain = (DataSet)SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
                                        new SqlParameter("@TableName", "CuvnalSalesReps"),
                                        new SqlParameter("@columnNames", "CustRep"),
                                        new SqlParameter("@whereClause", condition + ((condition != "") ? " and isnull(CustRep,'')<>''" : "isnull(CustRep,'')<>''")));

               ddlRep.DataSource = dsChain.Tables[0].DefaultView.ToTable(true,"CustRep");
               // ddlRep.DataSource = dsChain;
                ddlRep.DataTextField = "CustRep";
                ddlRep.DataValueField = "CustRep";
                ddlRep.DataBind();
                ddlRep.Items.Insert(0, new ListItem("All", "0"));
            }
            catch (Exception ex)
            {

            }
        }

        public void GetChainName(DropDownList ddlChain)
        {
		SqlConnection sqlConnection = new SqlConnection();
            SqlCommand sqlCommand = new SqlCommand();
            sqlConnection.ConnectionString = Global.ReportsConnectionString;

            try
            {
                sqlConnection.Open();
                sqlCommand.CommandText = "Select Code from VMI_Chain where isnumeric(code) =0  and isnull(code,'')<>'' ORDER BY Code";
                sqlCommand.Connection = sqlConnection;
                SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();
                ddlChain.DataSource = sqlDataReader;
                ddlChain.DataTextField = "Code";
                ddlChain.DataValueField = "Code";
                ddlChain.DataBind();
                ddlChain.Items.Insert(0, new ListItem("All", "0"));

            }
            catch (Exception e)
            {

            }
            finally
            {
                sqlConnection.Close();
            }

        }
        ///// <summary>
        ///// Function used to store branch values in session variables
        ///// </summary>
        ///// <param name="userID"></param>
        //public void FillBranchesAndChainSession(string userID)
        //{
        //    try
        //    {
        //        string authCompanyID = GetAuthorizedBranchID(userID);
        //        string authBranchID = string.Empty;

        //        DataSet dsAuthorizedBranch = (DataSet)SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
        //                                new SqlParameter("@TableName", "KPIBranches"),
        //                                new SqlParameter("@columnNames", "rtrim(Branch) as Branch,Branch+'-'+BranchName as Name"),
        //                                new SqlParameter("@whereClause", "Branch in (" + authCompanyID + ") and ExcludefromKPI<>'1' order by Branch"));


        //        DataSet dsUnAuthorizedBranch = (DataSet)SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
        //                                new SqlParameter("@TableName", "KPIBranches"),
        //                                new SqlParameter("@columnNames", "rtrim(Branch) as Branch,Branch+'-'+BranchName as Name"),
        //                                new SqlParameter("@whereClause", "Branch not in (" + authCompanyID + ") and ExcludefromKPI<>'1' order by Branch"));


        //        #region Get "--All--" drop down option value
        //        authCompanyID = "";
        //        //
        //        // Get Authorized Branches ID
        //        //
        //        for (int i = 0; i < dsAuthorizedBranch.Tables[0].Rows.Count; i++)
        //        {
        //            string brnID = string.Empty;
        //            if (dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Length == 1)
        //                brnID = "0" + dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();
        //            else
        //                brnID = dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();

        //            authCompanyID += ",'" + brnID.Trim() + "'";
        //            authBranchID += "," + dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Trim();
        //        }
        //        authCompanyID = authCompanyID.Remove(0, 1);
        //        authBranchID = authBranchID.Remove(0, 1);
        //        System.Web.HttpContext.Current.Session["BranchComboValues"] = dsAuthorizedBranch;
        //        System.Web.HttpContext.Current.Session["BranchIDForALL"] = authBranchID;
        //        System.Web.HttpContext.Current.Session["AuthorizedBranch"] = authCompanyID;

        //        #endregion

        //        #region UnAuthorized and Total Branches
        //        // Get UnAuthorized Branch values
        //        string unAuthorizedBranch = string.Empty;
        //        System.Web.HttpContext.Current.Session["UnAuthorizedBranch"] = "0";
        //        System.Web.HttpContext.Current.Session["UnAuthorizedBranchTotal"] = "0";
        //        System.Web.HttpContext.Current.Session["AuthorizedBranchTotal"] = dsAuthorizedBranch.Tables[0].Rows.Count;
        //        for (int i = 0; i < dsUnAuthorizedBranch.Tables[0].Rows.Count; i++)
        //        {
        //            string brnID = string.Empty;
        //            if (dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Length == 1)
        //                brnID = "0" + dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();
        //            else
        //                brnID = dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();

        //            unAuthorizedBranch += ",'" + brnID.Trim() + "'";

        //        }
        //        unAuthorizedBranch = unAuthorizedBranch.Remove(0, 1);

        //        System.Web.HttpContext.Current.Session["UnAuthorizedBranch"] = unAuthorizedBranch;

        //        // Get Total Branches

        //        System.Web.HttpContext.Current.Session["UnAuthorizedBranchTotal"] = dsUnAuthorizedBranch.Tables[0].Rows.Count;

        //        #endregion


        //        System.Web.HttpContext.Current.Session["ChainData"] = (DataSet)SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
        //                                   new SqlParameter("@TableName", "CuvnalDtl"),
        //                                   new SqlParameter("@columnNames", "Distinct Chain"),
        //                                   new SqlParameter("@whereClause", "isnull(chain,'') <>'' order by chain asc"));


        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}

        /// <summary>
        /// Function used to store branch values in session variables
        /// </summary>
        /// <param name="userID"></param>
        public void FillBranchesAndChainSession(string userID)
        {
            try
            {
                string authCompanyID = GetAuthorizedBranchID(userID);
                string authBranchID = string.Empty;

                DataSet dsAuthorizedBranch = (DataSet)SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[UGEN_SP_Select]",
                                       new SqlParameter("@TableName", "LocMaster"),
                                       new SqlParameter("@columnNames", "rtrim(LocID) as Branch,LocID+' - '+LocName as Name"),
                                       new SqlParameter("@whereClause", "LocID in (" + authCompanyID + ") order by LocID"));


                DataSet dsUnAuthorizedBranch = (DataSet)SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[UGEN_SP_Select]",
                                        new SqlParameter("@TableName", "LocMaster"),
                                        new SqlParameter("@columnNames", "rtrim(LocID) as Branch,LocID+' - '+LocName as Name"),
                                        new SqlParameter("@whereClause", "LocID not in (" + authCompanyID + ") order by LocID"));

                #region Get "--All--" drop down option value
                authCompanyID = "";
                //
                // Get Authorized Branches ID
                //
                for (int i = 0; i < dsAuthorizedBranch.Tables[0].Rows.Count; i++)
                {
                    string brnID = string.Empty;
                    if (dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Length == 1)
                        brnID = "0" + dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();
                    else
                        brnID = dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();

                    authCompanyID += ",'" + brnID.Trim() + "'";
                    authBranchID += "," + dsAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Trim();
                }
                authCompanyID = authCompanyID.Remove(0, 1);
                authBranchID = authBranchID.Remove(0, 1);
			
                System.Web.HttpContext.Current.Session["BranchComboValues"] = dsAuthorizedBranch;
                System.Web.HttpContext.Current.Session["BranchIDForALL"] = authBranchID;
                System.Web.HttpContext.Current.Session["AuthorizedBranch"] = authCompanyID;

                #endregion

                #region UnAuthorized and Total Branches
                // Get UnAuthorized Branch values
                string unAuthorizedBranch = string.Empty;
                System.Web.HttpContext.Current.Session["UnAuthorizedBranch"] = "0";
                System.Web.HttpContext.Current.Session["UnAuthorizedBranchTotal"] = "0";
                System.Web.HttpContext.Current.Session["AuthorizedBranchTotal"] = dsAuthorizedBranch.Tables[0].Rows.Count;
                for (int i = 0; i < dsUnAuthorizedBranch.Tables[0].Rows.Count; i++)
                {
                    string brnID = string.Empty;
                    if (dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString().Length == 1)
                        brnID = "0" + dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();
                    else
                        brnID = dsUnAuthorizedBranch.Tables[0].Rows[i]["Branch"].ToString();

                    unAuthorizedBranch += ",'" + brnID.Trim() + "'";

                }
                if (unAuthorizedBranch != "")
                    unAuthorizedBranch = unAuthorizedBranch.Remove(0, 1);

                System.Web.HttpContext.Current.Session["UnAuthorizedBranch"] = unAuthorizedBranch;

                // Get Total Branches

                System.Web.HttpContext.Current.Session["UnAuthorizedBranchTotal"] = dsUnAuthorizedBranch.Tables[0].Rows.Count;

                #endregion

                System.Web.HttpContext.Current.Session["ChainData"] = (DataSet)SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                           new SqlParameter("@TableName", "VMI_Chain"),
                                           new SqlParameter("@columnNames", "Code, Name"),
                                           new SqlParameter("@whereClause", "1=1 ORDER BY Code"));

            }
            catch (Exception ex)
            {

            }
        }


        #region Common Branch Related methods
        /// <summary>
        /// Get All the branches without any security level
        /// </summary>
        /// <returns></returns>
        public DataSet GetBranch()
        {
            try
            {

                string _tableName = "LocMaster";
                string _columnName = "LocID as Branch,LocID +' - '+LocName as BranchName";
                string _whereClause = "1=1 order by LocID";
                DataSet dsBranch = new DataSet();

                dsBranch = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsBranch;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// Returns Users Default Branch Name
        /// </summary>
        /// <returns></returns>
        public string GetBranchName()
        {

            try
            {
                string branch = HttpContext.Current.Session["BranchID"].ToString().Trim();
                if (HttpContext.Current.Session["BranchID"].ToString().Trim().Length == 1)
                {
                    branch = "0" + HttpContext.Current.Session["BranchID"].ToString();
                }

                string _tableName = "LocMaster";
                string _columnName = "LocID + ' - ' + LocName";
                string _whereClause = "LocID='" + branch + "'";
                string branchLongName = string.Empty;

                branchLongName = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return branchLongName;
            }
            catch (Exception ex)
            {
                HttpContext.Current.Response.Write(ex.Message);
                HttpContext.Current.Response.End();
                return null;
            }
        }
        /// <summary>
        /// retruns branch name by branchID
        /// </summary>
        /// <param name="branchId"></param>
        /// <returns></returns>
        public string GetBranchName(string branchId)
        {

            try
            {
                string branch = branchId.Trim();
                if (branchId.Trim().Length == 1)
                {
                    branch = "0" + branchId.ToString();
                }

                string _tableName = "LocMaster";
                string _columnName = "LocID + ' - ' + LocName";
                string _whereClause = "LocID='" + branch + "'";
                string branchLongName = string.Empty;

                branchLongName = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return branchLongName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion
    }
}
