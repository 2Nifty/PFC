/********************************************************************************************
 * File	Name			:	WODocNoPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	WorkOrder Entry
 * Module Description	:	WO Printing
 * Created By			:	Slater
 * Created Date			:	02/10/2011
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 002/10/2011		    Version 1		Slater      		Created 
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
using System.Data.SqlClient;
//using PFC.WOE.DataAccessLayer;
//using PFC.WOE.BusinessLogicLayer;
using System.Threading;

namespace PFC.WOE
{
    public partial class WOPrintingPrompt : System.Web.UI.Page
    {
        //SalesReportUtils salesReportUtils = new SalesReportUtils();
        //InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();
        string opt = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            if (!IsPostBack)
            {

            }
        }

    }
}