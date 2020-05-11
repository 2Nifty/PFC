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
using PFC.WOE.DataAccessLayer;

/// <summary>
/// Summary description for SOCommentEntry
/// </summary>
/// 
namespace PFC.WOE.BusinessLogicLayer
{
    public class CommentEntry
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";
        
        public string HeaderIDColumn
        {
            get
            {
                if (HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower() == "poheader")
                    return "fPOHeaderID";
                else if (HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower() == "poheaderhist")
                    return "fPOHeaderHistID";
                else
                    return "fPOHeaderID";
            }
        }

        public string CommentTableName
        {
            get
            {
                if (HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower() == "poheader")
                    return "POComments";
                else if (HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower() == "poheaderhist")
                    return "POCommentsHist";
                else
                    return "POComments";
            }
        }

        public string CommentID
        {
            get
            {
                if (HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower() == "poheader")
                    return "pPOCommID";
                else if (HttpContext.Current.Session["POHeaderTableName"].ToString().ToLower() == "poheaderhist")
                    return "pPOCommHistID";
                else
                    return "pPOCommID";
            }
        }

        public string UpdateMessage
        {
            get { return "Data has been successfully updated"; }
        }

        public string AddMessage
        {
            get { return "Data has been successfully added"; }
        }

        public string DeleteMessage
        {
            get { return "Data has been successfully deleted"; }
        }

        #region CommentEntry

        #region Not related to POComments
        public DataTable GetCommentType()
        {
            try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'SOCommentType' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
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

        public DataTable GetForm()
        {
            try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'FormType' And LD.fListMasterID = LM.pListMasterID order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
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
                
        public DataTable GetStdComment()
        {
            try
            {
                _tableName = "StandardComments";
                _columnName = "StdCommentsCd + ' - '+Comments as Comments,(CommentLocOnDoc +'`'+ DocumentType+'`'+ StdCommentsCd) as TypeForm";
                _whereClause = "WOAppInd='Y' order by StdCommentsCd";
                DataSet dsCommentType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCommentType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable EmptyStdComment()
        {
            try
            {
                _tableName = "StandardComments";
                _columnName = "StdCommentsCd + ' - '+Comments as Comments,(CommentLocOnDoc +'`'+ DocumentType) as TypeForm";
                _whereClause = "WOAppInd='Y'";
                DataSet dsCommentType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return null;
            }
            catch (Exception ex)
            {
                
                 return null;
            }
        }

        public DataTable GetVendorComment(string vendorNo)
        {
            try
            {
                _tableName = "OrganizationStandardComments";
                _columnName = "Comments,Comments as TypeForm ";
                _whereClause = "WOAppInd='Y' and organizationNo='" + vendorNo+ "'";
                DataSet dsCommentType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCommentType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable EmptyVendorComment(string vendorNo)
        {
            try
            {
                _tableName = "OrganizationStandardComments";
                _columnName = "Comments,Comments as TypeForm ";
                _whereClause = "POAppInd='Y' and organizationNo='" + vendorNo + "'";
                DataSet dsCommentType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return null;
            }
            catch (Exception ex)
            {
                return null;
               
            }
        }

        public DataTable CheckStdComment(string comment)
        {
            try
            {
                _tableName = "StandardComments";
                _columnName = "*";
                _whereClause = "Comments='"+comment+"'";
                DataSet dsCommentType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCommentType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable CheckVendorComment(string vendorcomment)
        {
            try
            {
                _tableName = "OrganizationStandardComments";
                _columnName = "*";
                _whereClause = "Comments='" + vendorcomment + "'";
                DataSet dsCommentType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCommentType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion

        public DataTable GetSoComment(string whereClause)
        {
            try
            {

                _columnName = CommentID + " as pSOCommID," + HeaderIDColumn + " as fSOHeaderID,Type,case isnull(CommLineNo,0) when 0 then 0 else CommLineNo/10 end as CommLineNo,CommText,FormsCd,CommLineSeqNo,EntryID,convert(char(10),EntryDt,101) as EntryDt,ChangeID,convert(char(10),ChangeDt,101) as ChangeDt,convert(char(10),DeleteDt,101) as DeleteDt";

                DataSet dsComment = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", CommentTableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsComment.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertSOExpense(string columnValue)
        {
                     
            try
            {
               
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEInsert]",
                                    new SqlParameter("@tableName", CommentTableName),
                                    new SqlParameter("@columnNames", HeaderIDColumn + ",[Type],CommLineNo,CommLineSeqNo,FormsCd,CommText,EntryID,EntryDt"),
                                    new SqlParameter("@ColumnValues", columnValue));
               

                
            }
            catch (Exception ex)
            {

            }
            
        }

        public void UpdateSOComment(string columnValue, string commentID)
        {
            try
            {
                _whereClause = CommentID + "=" + commentID;
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEUpdate]",
                                    new SqlParameter ("@tableName",CommentTableName),
                                    new SqlParameter("@ColumnValues", columnValue),
                                    new SqlParameter("@WhereClause", _whereClause));
            }
            catch (Exception ex)
            {
            }
        }

        public DataTable GetSoCommentDetail(string commentID)
        {
            try
            {
                _whereClause = CommentID+"= " + commentID ;
                DataSet dsComment = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", CommentTableName),
                                    new SqlParameter("@columnNames", CommentID + " as pSOCommID,[Type],[CommText],[CommLineSeqNo],case isnull(CommLineNo,0) when 0 then 0 else CommLineNo/10 end as CommLineNo,[FormsCd]"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsComment.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }

        public string GetLineNo(string soNumber)
        {
            try
            {
                _tableName = "SOComments";
                _columnName = " count(Type) as Line";
                _whereClause = "CommType='CL-Comment Line' and fSOHeaderID='" + soNumber+"'";
                string CommentsCount = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CommentsCount;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public string GetSeqNo(string soNumber,string commType)
        {  
            try
            {
                _tableName = CommentTableName;
                _columnName = " count(Type) as Seq";
                _whereClause = HeaderIDColumn+"='" + soNumber + "' and Type='" + commType + "'";
                string CommentsCount1 = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CommentsCount1;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public string GetSeqNo(string soNumber, string commType,string lineNo)
        {
            try
            {
                _tableName = CommentTableName;
                _columnName = " count(Type) as Seq";
                _whereClause = HeaderIDColumn + "='" + soNumber + "' and Type='" + commType + "' and CommLineNo=" + lineNo;
                string CommentsCount1 = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CommentsCount1;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataTable GetCommentPrint(string tableName,string _whereClause)
        {
            try
            {
                _columnName = "Type,isnull(CommLineNo,0) as 'Line No',CommText as 'Comment',FormsCd as 'Form',CommLineSeqNo as 'Sequence No',EntryID as 'Entry ID',convert(char(10),EntryDt,101) as 'Entry Date',ChangeID as 'Change ID',convert(char(10),ChangeDt,101) as 'Change Date',convert(char(10),DeleteDt,101) as 'Delete Date'";

                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsSalesOrderDetails.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }

        public string GetSOItemInformation(string soNumber,string lineNo)
        {
            try
            {
                string _whereClause = HeaderIDColumn + "=" + soNumber + " And LineNumber=" + lineNo;
                string itemDesc = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                        new SqlParameter("@tableName", HttpContext.Current.Session["DetailTableName"].ToString()),
                                        new SqlParameter("@columnNames", "ItemNo"),
                                        new SqlParameter("@whereClause", _whereClause)).ToString();

                return itemDesc;
            }
            catch (Exception ex)
            {

                throw ex;
            }
            
        }

        public string GetPOOrderNo(string PONumber)
        {
            try
            {
                string _whereClause ="POOrderNo ='"+PONumber+"'";
                string pOrderNo = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                        new SqlParameter("@tableName", "POHeader"),
                                        new SqlParameter("@columnNames", "*"),
                                        new SqlParameter("@whereClause", _whereClause)).ToString();

                string fOrderNo = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                        new SqlParameter("@tableName", "PODetail"),
                                        new SqlParameter("@columnNames", "count(*)"),
                                        new SqlParameter("@whereClause", "fPOHeaderID='"+pOrderNo+"'")).ToString();

                return fOrderNo;
            }
            catch (Exception ex)
            {
                return "";
                throw ex;
            }

        }

        public string GetIdentityFromHistoryTable(string soNumber)
        {            
            string pSOHeaderHistID = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", HttpContext.Current.Session["OrderTableName"].ToString()),
                                    new SqlParameter("@columnNames", "pSOHeaderHistID"),
                                    new SqlParameter("@whereClause", "OrderNo=" + soNumber)).ToString();

            return pSOHeaderHistID;

        }

        public DataTable GetLineCount(string orderID)
        {
            try
            {
                DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                         new SqlParameter("@tableName", "POdetail"),
                                         new SqlParameter("@columnNames", " max(POLineNo)"),
                                         new SqlParameter("@whereClause", "[fPOHeaderID]=" + orderID));

                return dtTable.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
                throw;
            }
        }

        public DataTable BindGrid(string POOrderNo)
        {
            try
            {
                string tablename = "[PODetail],itemmaster";
                string columnnmae = "[pPODetailID],[PODetail].[fPOHeaderID],[POOrderNo],[POLineNo],[VendorItemNo],[PODetail].[ItemNo],[QtyOrdered],itemmaster.ItemDesc,ReceivingLocation";
                string where = "itemmaster.ItemNo = [PODetail].[ItemNo] and [fPOHeaderID]=(select [pPOHeaderID] from Poheader where POOrderNo='"+POOrderNo+"')";
                DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                         new SqlParameter("@tableName",tablename ),
                                         new SqlParameter("@columnNames",columnnmae),
                                         new SqlParameter("@whereClause",where));

                return dtTable.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
                throw;
            }
        }

        public DataTable BindTop(string POOrderNo)
        {
            try
            {
                string tablename = "Pocomments";
                string columnnmae = "*";
                string where = "fPOHeaderID ='"+POOrderNo+"' and type='CT' and deletedt is null";
                DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                         new SqlParameter("@tableName", tablename),
                                         new SqlParameter("@columnNames", columnnmae),
                                         new SqlParameter("@whereClause", where));

                return dtTable.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
                throw;
            }
        }

        public DataTable BindBottom(string POOrderNo)
        {
            try
            {
                string tablename = "Pocomments";
                string columnnmae = "*";
                string where = "fPOHeaderID ='" + POOrderNo + "' and type='CB' and deletedt is null";
                DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                         new SqlParameter("@tableName", tablename),
                                         new SqlParameter("@columnNames", columnnmae),
                                         new SqlParameter("@whereClause", where));

                return dtTable.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
                throw;
            }
        }

        public DataTable BindComments(string POOrderNo,string lineNo)
        {
            try
            {
                string tablename = "Pocomments";
                string columnnmae = "*";
                string where = "fPOHeaderID ='"+POOrderNo+"' and type='LC' and commlineno='"+lineNo+"' and deletedt is null";
                DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                         new SqlParameter("@tableName", tablename),
                                         new SqlParameter("@columnNames", columnnmae),
                                         new SqlParameter("@whereClause", where));

                return dtTable.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
                throw;
            }
        }
        #endregion
    }
    
}