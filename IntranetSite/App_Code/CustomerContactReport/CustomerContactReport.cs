
using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

public class CustomerContactReport
{
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    string erpconnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    public void BindListValue(string listName, System.Web.UI.WebControls.DropDownList ddlControl)
    {
        try
        {
         

            string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='"+listName+"' Order by b.SequenceNo";
            string _tableName = "listmaster a,ListDetail b ";
            string _columnName = "b.ListValue as ListValue,b.ListDtlDesc as ListDtlDesc";

            DataSet dsResult = SqlHelper.ExecuteDataset(erpconnectionString, "pSOESelect",
                                        new SqlParameter("@tableName", _tableName),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));

             if (listName == "ContactType")
            {
                // Remove AP & APM from table
                dsResult.Tables[0].DefaultView.RowFilter = "ListValue not in ('AP','APM') ";
            }

            ddlControl.DataSource = dsResult.Tables[0].DefaultView;
            ddlControl.DataTextField = "ListDtlDesc";
            ddlControl.DataValueField = "ListValue";
            ddlControl.DataBind();
             
        }
        catch (Exception ex)
        {
             
        }
    }  

    public DataTable GetContactReport(string branch, string CustType, string ContactType, string BG, string filterDt)
    {
        try
        {
           string  spName = "[pCustomerContactReport]";
            DataSet dsReport = SqlHelper.ExecuteDataset(erpconnectionString, spName,
                                new SqlParameter("@Branch", branch),
                                new SqlParameter("@CustType", CustType),
                                new SqlParameter("@ContactType", ContactType),
                                new SqlParameter("@BGroup", BG),
                                new SqlParameter("@entryDt", filterDt)
                                );

            return dsReport.Tables[0]; 
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public void GetCustomerBuyingGroup(DropDownList ddlBuying)
    {
        string _whereClause = "(ListMaster.ListName = 'BuyGrp') Order by SequenceNo ";
        string _tableName = "ListDetail INNER JOIN  ListMaster ON ListDetail.fListMasterID = ListMaster.pListMasterID  ";
        string _columnName = " Rtrim(ListDetail.ListValue) as Value ,ListDetail.ListDtlDesc as ListDetail";

        DataSet dslist = new DataSet();
        dslist = SqlHelper.ExecuteDataset(erpconnectionString, "pSOESelect",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));
        if (dslist.Tables[0].Rows.Count > 0)
        {
            ddlBuying.DataSource = dslist.Tables[0];
            ddlBuying.DataTextField = "ListDetail";
            ddlBuying.DataValueField = "Value";
            ddlBuying.DataBind();
        }
        ListItem item = new ListItem("ALL", "");
        ddlBuying.Items.Insert(0, item);
    }
}
