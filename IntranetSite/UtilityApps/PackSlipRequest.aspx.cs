/********************************************************************************************
 * File	Name			:	BookingReportPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Booking Report Prompt 
 * Created By			:	Sathish
 * Created Date			:	03/02/2010
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 03/02/2010		    Version 1		Sathish      		Created 
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
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.BusinessLogicLayer;
using System.Threading;

namespace PFC.Intranet
{
    public partial class PackSlipPrompt : System.Web.UI.Page
    {
        ddlBind _ddlBind = new ddlBind();

        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(PackSlipPrompt));

            lblError.Text = "";
            lblError.ForeColor = System.Drawing.Color.Red;
            scmPostBack.SetFocus(txtOrderNo);

            if(!Page.IsPostBack)
                BindPrinterDropDown();
        }
        
        protected void btnPostPckSlip_Click(object sender, EventArgs e)
        {
            if (txtOrderNo.Text.Trim() != "")
            {
                string resultString = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pUTL_PostPackSlipReq"
                                        , new SqlParameter("@PackSlip", txtOrderNo.Text.Trim())
                                        , new SqlParameter("@packSlipPrinter", ddlPrinterName.SelectedValue)
                                        , new SqlParameter("@requiredCerts", chkCertsRequired.Checked)).ToString();

                lblError.Text = resultString;
                if(lblError.Text.ToLower().Contains("successfully"))
                    lblError.ForeColor = System.Drawing.Color.Green;

                txtOrderNo.Text = "";
                txtOrderNo.Focus();
                scmPostBack.SetFocus(txtOrderNo);
                pnlStatus.Update();
            }
        }

        private void BindPrinterDropDown()
        {
            try
            {                
                DataSet dsPrinterName = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", " PrinterList "),
                                    new SqlParameter("@columnNames", "PrinterPath,PrinterNetworkAddress"),
                                    new SqlParameter("@whereClause", "1=1"));
                _ddlBind.ddlBindControl(ddlPrinterName, dsPrinterName.Tables[0], "PrinterNetworkAddress", "PrinterPath", "", "------ Select Printer ------");

                // Get user default printer 
                object userDefaultPrinter  = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                            new SqlParameter("@tableName", "SecurityUsers"),
                                            new SqlParameter("@columnNames", "isnull(DefaultPackSlipPrinter,'') as DefaultPackSlipPrinter"),
                                            new SqlParameter("@whereClause", "UserName='" + Session["UserName"].ToString() + "'"));

                if (userDefaultPrinter != null)
                {
                    ddlPrinterName.SelectedValue = userDefaultPrinter.ToString().Trim();
                }

                
            }
            catch (Exception exe)
            {

            }
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public void UpdateUserDefaultPrinter(string printerName)
        {
            string updateSCmd = " Update SecurityUsers " +
                                " Set DefaultPackSlipPrinter='" + printerName + "'" +
                                " Where UserName='" + Session["UserName"].ToString() + "'";

            PFCDBHelper.ExecuteERPUpdateQuery(updateSCmd);
           
        }
}
}
