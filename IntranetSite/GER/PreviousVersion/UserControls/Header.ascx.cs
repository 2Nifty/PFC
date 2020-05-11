/********************************************************************************************
 * File	Name			:	Header.ascx.cs
 * File Type			:	C#
 * Project Name			:	Goods En Route
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	04/12/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 04/12/2007		    Version 1		A.Nithyapriyadarshini		Created 
  *********************************************************************************************/

#region Name Space
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
using System.Threading;
using System.IO;
using System.Reflection;
using Microsoft.Web.UI;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using System.Drawing;
using GER;
#endregion

public partial class Common_UserControls_Header : System.Web.UI.UserControl
{


    public string refNo
    {
        get
        {
            return txtRefNo.Text;
        }
        
    }

    public string headerValues
    {
        get
        {
            string portofLading = (ddlPort.SelectedItem.Value == "0" ? "" : ddlPort.SelectedItem.Value);
            return txtRefNo.Text + "~" + txtBOLDt.Text + "~" + ddlOrder.SelectedItem.Text 
                        + "~" + ddlOrder.SelectedItem.Value + "~" + ddlReceipt.SelectedItem.Text + "~" 
                        + txtVesselName.Text + "~" + ddlLocation.SelectedItem.Text.Split('-')[0].Trim() + "~" 
                        + ddlLocation.SelectedItem.Text.Split('-')[1].Trim() + "~" + portofLading + "~"
                        + txtBrokerIAmt.Text.Replace(",", "") + "~" + txtBOLCount.Text.Replace(",", "") + "~"
                        + txtCustomsEntryNo.Text + "~" + txtPortOfEntry.Text + "~" + txtCustomsDate.Text + "~"
                        + Session["UserID"];
        }

    }

    public string SetBOLHeaderValues
    {
        set
        {
            try
            {

                ddlOrder.SelectedValue = value.Split('~')[1].ToString();
                lblVendName.Text = value.Split('~')[1].ToString();
                ddlLocation.SelectedValue = value.Split('~')[3].ToString().Trim();
                lblBranch.Text = value.Split('~')[3].ToString();
                txtRefNo.Text = value.Split('~')[4].ToString();
                ddlPort.SelectedValue = value.Split('~')[5].ToString();
                txtBOLDt.Text = value.Split('~')[6].ToString();
                txtVesselName.Text = value.Split('~')[7].ToString();
                txtBrokerIAmt.Text = value.Split('~')[8].ToString();
                ddlReceipt.SelectedValue = value.Split('~')[9].ToString();
                lblProcDt.Text = value.Split('~')[10].ToString();
                txtBOLCount.Text = value.Split('~')[11].ToString();
                txtCustomsEntryNo.Text = value.Split('~')[12].ToString();
                txtPortOfEntry.Text = value.Split('~')[13].ToString();
                txtCustomsDate.Text = value.Split('~')[14].ToString();
            }
            catch (Exception ex)
            {
               
            }
        }
    }
    DataSet dsTabNames = new DataSet();
    Utility getUtility = new Utility();

    #region Auto generated event
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
            BindCombo();
    }
    #endregion

    #region Developer generated code

    private void BindCombo()
    {
        try
        {

            //
            //To fill the VendorNo in combo
            //
            DataTable dtSource = new DataTable();
            if (Session["HeaderVendorData"] == null)
            {
                //dtSource = getUtility.GetDataSet("VendorMaster", "VendNo,VendName", "1=1");
                //Session["HeaderVendorData"] = dtSource;
                DataSet dsVendor = new DataSet();
                try
                {
                    dsVendor = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVLiveConnectionString"].ToString(), "[UGEN_SP_Select]",
                        new SqlParameter("@tableName", "[Porteous$Vendor]"),
                        new SqlParameter("@displayColumns", "No_,Name"),
                        new SqlParameter("@whereCondition", "1=1"));
                                        
                }
                catch (Exception ex) {  }
                if (dsVendor.Tables[0]!= null)
                {
                    dtSource = dsVendor.Tables[0];
                    Session["HeaderVendorData"] = dtSource;
                }

            }
            else
            {
                dtSource = (DataTable)Session["HeaderVendorData"];
            }
            getUtility.BindListControl(ddlOrder, "No_", "Name", dtSource);

            //
            // To fill the PFC Location Name in combo
            //
            if (Session["HeaderLocationData"] == null)
            {
                dtSource = getUtility.GetDataSet("KPIBranches", "Branch+' - '+BranchName as Branch,BranchName", "ExcludefromKPI<>'1' order by Branch");
                Session["HeaderLocationData"] = dtSource;
            }
            else
            {
                dtSource = (DataTable)Session["HeaderLocationData"];
            }
            getUtility.BindListControl(ddlLocation, "Branch", "BranchName", dtSource);

            //
            // To fill the Receipt Type in combo
            //
            if (Session["HeaderRcptData"] == null)
            {
                dtSource = getUtility.GetDataSet("Tables", "DISTINCT Dsc", "(TableType = 'GERREC')");
                Session["HeaderRcptData"] = dtSource;
            }
            else
            {
                dtSource = (DataTable)Session["HeaderRcptData"];
            }
            getUtility.BindListControl(ddlReceipt, "Dsc", "Dsc", dtSource);



            //
            // To fill the Port of Lading in combo
            //
            if (Session["HeaderPortofLadingData"] == null)
            {
                dtSource = getUtility.GetDataSet("Tables", "DISTINCT Dsc as PortofLading", "(TableType = 'GERPORT')");
                Session["HeaderPortofLadingData"] = dtSource;
            }
            else
            {
                dtSource = (DataTable)Session["HeaderPortofLadingData"];
            }
            getUtility.BindListControl(ddlPort, "PortofLading", "PortofLading", dtSource);

        }
        catch (Exception ex) { }
    }

   
    #endregion


}
