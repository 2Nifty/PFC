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

    //
    // menu object creation
    //
    //MenuGenerator menugenerator = new MenuGenerator();
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
            DataTable dtSource = getUtility.GetDataSet("GERHeader", "distinct VendNo,VendName", "1=1");

            //To fill the VendorNo in combo
            if (dtSource != null)
                getUtility.BindListControl(ddlOrder, "VendNo", "VendName", dtSource);

            dtSource = getUtility.GetDataSet("GERHeader", "distinct PFCLocCd+' - '+PFCLocName as PFCLocCd,PFCLocName", "1=1");

            // To fill the PFC Location Name in combo
            if (dtSource != null)
                getUtility.BindListControl(ddlLocation, "PFCLocCd", "PFCLocName", dtSource);

            dtSource = getUtility.GetDataSet("GERHeader", "distinct RcptTypeDesc", "1=1");

            // To fill the Receipt Type in combo
            if (dtSource != null)
                getUtility.BindListControl(ddlReceipt, "RcptTypeDesc", "RcptTypeDesc", dtSource);

            dtSource = getUtility.GetDataSet("GERHeader", "distinct PortofLading", "1=1");

            // To fill the Port of Lading in combo
            if (dtSource != null)
                getUtility.BindListControl(ddlPort, "PortofLading", "PortofLading", dtSource);


        }
        catch (Exception ex) { }
    }

    #endregion


}
