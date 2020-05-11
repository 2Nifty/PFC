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
    public partial class CustPriceMatrixPrompt : System.Web.UI.Page
    {
        CustPriceMatrix custPriceMatrix = new CustPriceMatrix();

        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {      
                //
                // Fill The Branches in the Combo
                //
                BindDropDowns();                
                
            }
        }

        public void BindDropDowns()
        {
            try
            {

                DataSet dsDDLData = custPriceMatrix.GetPriceMatrixDDLData();

                if (dsDDLData != null)
                {
                    custPriceMatrix.BindListControls(ddlTerritory, "TerritoryDesc", "TerritoryCd", dsDDLData.Tables[0], "");
                    custPriceMatrix.BindListControls(ddlOutsideRep, "RepName", "RepNo", dsDDLData.Tables[1], "");
                    custPriceMatrix.BindListControls(ddlInsideRep, "RepName", "RepNo", dsDDLData.Tables[2], "");
                    custPriceMatrix.BindListControls(ddlRegion, "LocSalesGrp", "LocSalesGrp", dsDDLData.Tables[3], "");
                    custPriceMatrix.BindListControls(ddlBuyGrp, "BuyGrpDesc", "BuyGrpCd", dsDDLData.Tables[4], "");

                }

                

            }
            catch (Exception ex) { }
        }


        protected void btnReport_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {                    
                string popupScript = "<script language='javascript'>ViewReport()</script>";
                Page.RegisterStartupScript("custpricematrix", popupScript);             
            }
        }
}
}
