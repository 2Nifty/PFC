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

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.VendorMaintenance
{
    public partial class VendorSearch : System.Web.UI.UserControl
    {
        string VEND = "VEND (W)";
        string VDAP = "VDAP";
        VendorDetailLayer vendorDetails = new VendorDetailLayer();

        protected void Page_Load(object sender, EventArgs e)
        {
            

            if (!IsPostBack)
            {
                if ((Session["SecurityCode"] != null && (Session["SecurityCode"].ToString().Trim() == VEND || Session["SecurityCode"].ToString().Trim() == VDAP)) || (Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
                    btnAdd.Visible = false;                
                else
                    btnAdd.Visible = true;
                

                btnUpdate.Visible = false;
                ibtnDelete.Visible = false;
            }
        }

        #region Property Bags

        public string VendorNumber
        {
            get
            {
                return txtVendor.Text.Trim();
            }
        }

        public string VendorID
        {
            get { return hidVendor.Value.Trim(); }
        }

        public string SearchMode
        {
            get
            {
                return hidSearchMode.Value.Trim();
            }
            set
            {
                hidSearchMode.Value = value;
            }
        }

        #endregion

        #region Events

        protected void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            btnAdd.Visible = false;
            btnUpdate.Visible = false;
            ibtnDelete.Visible = false;
            
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            
            if (txtVendor.Text == "")
               hidVendor.Value = "";
            else
            {
                hidVendor.Value = "";
                GetSearch();
                vendorDetails.ReleaseLock();
                vendorDetails.SetLock(hidVendor.Value.Trim());
                SetSecurity();
            }
        }

        protected void btnUpdate_Click(object sender, ImageClickEventArgs e)
        {
            GetSearch();
            hidSearchMode.Value = "Vendor";

            vendorDetails.ReleaseLock();
            vendorDetails.SetLock(hidVendor.Value.Trim());
        }

        protected void btnDelete_Click(object sender, ImageClickEventArgs e)
        {
            txtVendor.Text = "";
            btnUpdate.Visible = false;
            ibtnDelete.Visible = false;
        }

        public void SetSecurity()
        {
            if ((Session["SecurityCode"] != null && (Session["SecurityCode"].ToString().Trim() == VEND || Session["SecurityCode"].ToString().Trim() == VDAP)) || (Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
            {
                btnAdd.Visible = false;
                btnUpdate.Visible = false;
                ibtnDelete.Visible = false;
            }
            else
            {
                btnAdd.Visible = true;
                ibtnDelete.Visible = true;
                btnUpdate.Visible = true;
            }

        }

        public void GetSearch()
        {
            try
            {
                string vendValue = string.Empty;
                vendValue = ((hidSearchMode.Value.Trim() == "Alpha") ? vendorDetails.GetVendorNumber("Code ='" + txtVendor.Text.Trim() + "' And Deletedt is null") : vendorDetails.GetVendorNumber("VendNo ='" + txtVendor.Text.Trim() + "' And Deletedt is null"));

                if (vendValue.Trim() == "")
                {
                    vendValue = vendorDetails.GetVendorNumber(" pVendMstrID in (select fVendMstrID from VendorAddress where Code = '" + txtVendor.Text.Trim() + "' And Deletedt is null) And Deletedt is null");
                    hidSearchMode.Value = "Alpha";

                    if (vendValue.Trim() == "")
                    {
                        vendValue = vendorDetails.GetVendorNumber("VendNo='" + txtVendor.Text.Trim() + "' And Deletedt is null");
                        hidSearchMode.Value = "Vendor";
                    }
                }
                hidVendor.Value = vendValue.Trim();

                if (hidSearchMode.Value == "Alpha")
                {
                    DataSet dsVend = vendorDetails.GetDataToDateset("VendorAddress", "pVendAddrID,fVendMstrID,Type,isnull(fBuyFromAddrID,0) as fBuyFromAddrID", "Code='" + txtVendor.Text.Trim() + "' And Deletedt is null");
                    if (dsVend != null && dsVend.Tables[0].Rows.Count > 0)
                    {
                        hidType.Value = dsVend.Tables[0].Rows[0]["Type"].ToString().Trim();
                        hidVendor.Value = dsVend.Tables[0].Rows[0]["fVendMstrID"].ToString().Trim();
                        hidAddrID.Value = dsVend.Tables[0].Rows[0]["pVendAddrID"].ToString().Trim();
                        hidParentAddID.Value = dsVend.Tables[0].Rows[0]["fBuyFromAddrID"].ToString().Trim();
                    }
                }
                else
                    hidParentAddID.Value = "";
            }
            catch (Exception ex) { }
        }

        #endregion
} 
}
