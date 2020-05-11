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
    public partial class BookingReportPrompt : System.Web.UI.Page
    {
        ddlBind _ddlBind = new ddlBind();
        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            if (!IsPostBack)
            {   
                // Fill The Branches in the Combo
                BindRegions();                                               
            }
        }

        private void BindRegions()
        {
            DataTable dtRegion = PFCDBHelper.ExecuteERPSelectQuery("Select distinct LocSalesGrp From LocMaster (NOLOCK) where isnull(LocSalesGrp,'') <> ''");
            if (dtRegion != null && dtRegion.Rows.Count > 0)
            {
                _ddlBind.ddlBindControl(ddlRegion, dtRegion, "LocSalesGrp", "LocSalesGrp", "ALL", "ALL");
                BindSalesPerson();
            }

        }

        public void BindSalesPerson()
        {
            try
            {
                string _region = (ddlRegion.SelectedValue.ToUpper() == "ALL" ? "LocSalesGrp" : "'" + ddlRegion.SelectedValue + "'");
                string _erpQuery = "Select distinct RepNo,RepName " +
                                    "from   RepMaster (NOLOCK) " +
                                    "Where  (RepStatus='A' OR  RepStatus='N' OR RepStatus='P') " +
                                            "AND (RepClass='I') AND SalesOrgNo in (Select LocId From LocMaster (NOLOCK) Where LocSalesGrp=" + _region + ")  Order By RepName ";
                    
                DataTable dtSalesRep = PFCDBHelper.ExecuteERPSelectQuery(_erpQuery);

                _ddlBind.ddlBindControl(ddlSalesPerson, dtSalesRep, "RepNo", "RepName", "ALL", "ALL");
                
            }
            catch (Exception ex) { }
        }

        protected void ddlRegion_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindSalesPerson();
        }
}
}
