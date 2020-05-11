
/********************************************************************************************
 * File	Name			:	ContactNotes.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	To display the customer notes
 * Created By			:	MaheshKumar.S
 * Created Date			:	11/14/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Mahesh      		Created 
 *********************************************************************************************/


using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;

public partial class CustomerActivitySheet_ContactNotes : System.Web.UI.Page
{
    #region Variable Declaration

    string strTable = "CAS_CustomerData";
    string strDisplayColumns = " CurYear, CurMonth, CustNo, CustName, CustAddress, CustCity, CustState, CustZip, CustPhone, CustFax, CustContact, Chain, Terms, DSO, " +
                      "InsideSls, SalesPerson, BuyGrp, SalesRep, HubSatellites,CustType, BranchNo, BranchDesc";
    string strNotesColumns = "case lower(NoteType) when 'cv' then 'Previous Visit Note' when 'os' then 'Last Outside Sales Rep  Notes' when 'is' then 'Last Inside Sales Rep  Notes'  end as NoteType,Note";
    string strNotesTable = "CAS_CustContactNote";
    DataTable dtCustomerData = new DataTable();
    DataTable dtContactNotes = new DataTable();

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.QueryString["PrintMode"] == null)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
        }
        // Call the function to fill the customer details
        FillCustomerDetails();

        // Call the function to fill the customer contact notes
        FilllNotes();
    }

    /// <summary>
    /// Function to fill the customer details
    /// </summary>
    public void FillCustomerDetails()
    {
        try
        {
            string strWhere = "curmonth=" + Request.QueryString["Month"].Trim() + " and " +
                              "curYear=" + Request.QueryString["Year"].Trim() + " and CustNo='" + Request.QueryString["CustNo"].Trim().Replace("||", "&") + "'";

            strTable = Request.QueryString["CASMode"] == null ? strTable : "CAS_ChainData";

            // Initailize the class customer activity sheet
            PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerData = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();

            // Get the data's in the datatable by calling the class function
            dtCustomerData = customerData.GetCustomerActivityDetail(strWhere, strDisplayColumns, strTable);

            // Bind the datagrid with datatables
            dgCas.DataSource = dtCustomerData;
            dgCas.DataBind();
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    /// <summary>
    /// Function to fill the customer contact notes
    /// </summary>
    public void FilllNotes()
    {
        try
        {
            string strWhere = "CustNo='" + Request.QueryString["CustNo"].Trim().Replace("||", "&") + "'";

            // Initailize the class customer activity sheet
            PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerData = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();

            // Get the data's in the datatable by calling the class function
            dtContactNotes = customerData.GetCustomerActivityDetail(strWhere, strNotesColumns, strNotesTable);

            // Get the datas in the datatable to bind the data in a single row
            DataTable dt = new DataTable();
            dt.Columns.Add("PreviousNote", typeof(string));
            dt.Columns.Add("LastOutRepNote", typeof(string));
            dt.Columns.Add("LastInRepNote", typeof(string));

            DataRow drow = dt.NewRow();
            if (dtContactNotes != null && dtContactNotes.Rows.Count != 0)
            {
                dtContactNotes.DefaultView.RowFilter = "NoteType='Previous Visit Note'";
                drow[0] = (dtContactNotes.DefaultView.ToTable().Rows.Count != 0) ? dtContactNotes.DefaultView.ToTable().Rows[0][0].ToString() : "";
                dtContactNotes.DefaultView.RowFilter = "NoteType='Last Outside Sales Rep  Notes'";
                drow[1] = (dtContactNotes.DefaultView.ToTable().Rows.Count != 0) ? dtContactNotes.DefaultView.ToTable().Rows[0][0].ToString() : "";
                dtContactNotes.DefaultView.RowFilter = "NoteType='Last Inside Sales Rep  Notes'";
                drow[2] = (dtContactNotes.DefaultView.ToTable().Rows.Count != 0) ? dtContactNotes.DefaultView.ToTable().Rows[0][0].ToString() : "";
            }
            else
            {
                drow[0] = "";
                drow[1] = "";
                drow[2] = "";
            }
            dt.Rows.Add(drow);

            // Code to bind the datatable in the datagrid
            dgContactNotes.DataSource = dt;
            dgContactNotes.DataBind();
        }
        catch (Exception ex) { }
    }
}
