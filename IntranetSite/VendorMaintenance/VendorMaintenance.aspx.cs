
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
    public partial class VendorMaintenance : System.Web.UI.Page
    {
        VendorDetailLayer vendorDetails = new VendorDetailLayer();
        public string VendorMasterTable = "VendorMaster";
        string unAuthorizedPage = "~/Common/ErrorPage/unauthorizedpage.aspx";
        string VEND = "VEND (W)";
        string VDAP = "VDAP";
        string APVD = "APVD (W)";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string securityCode = vendorDetails.GetSecurityCode(Session["UserName"].ToString());
                if (securityCode == "" || !(securityCode == APVD || securityCode == VEND || securityCode == VDAP))
                    Response.Redirect(unAuthorizedPage, true);
                Session["SecurityCode"] = securityCode;
            }
            
             //Session["UserID"] = Session["UserName"].ToString();
            // Register AJAX
            Ajax.Utility.RegisterTypeForAjax(typeof(VendorMaintenance));
          
            if (!IsPostBack)
            {
                AddMode();
            }

            #region User control event handlers

            #region Search Vendor  Handler

            ImageButton btnAdd = ucSearchVendor.FindControl("btnAdd") as ImageButton;
            Button btnSearch = ucSearchVendor.FindControl("btnSearch") as Button;
            ImageButton btnDelete = ucSearchVendor.FindControl("ibtnDelete") as ImageButton;
            ImageButton btnVenEdit = ucSearchVendor.FindControl("btnUpdate") as ImageButton;
            btnDelete.Click += new ImageClickEventHandler(btnDelete_Click);
            btnAdd.Click += new ImageClickEventHandler(btnAdd_Click);
            //btnSearch.Click += new ImageClickEventHandler(btnSearch_Click); 
            btnSearch.Click+=new EventHandler(btnSearch_Click);
            btnVenEdit.Click+=new ImageClickEventHandler(btnVenEdit_Click);

            #endregion

            #region Location Navigator Handler

            Button btnBindDetails = ucLocationNavigator.FindControl("btnBindDetails") as Button;
            btnBindDetails.Click += new EventHandler(btnBindDetails_Click); 

            #endregion

            #region  VendorEntry Event handler
            ImageButton ibtnSave = ucVendorEntry.FindControl("ibtnSave") as ImageButton;
            ImageButton ibtnUpdate = ucVendorEntry.FindControl("ibtnUpdate") as ImageButton;

            ibtnSave.Click += new ImageClickEventHandler(ibtnSave_Click);
            ibtnUpdate.Click += new ImageClickEventHandler(ibtnUpdate_Click); 
            #endregion

            #region AddressEntry Event handler

            ImageButton btnEdit = ucAddressInfo.FindControl("btnEdit") as ImageButton;
            ImageButton ibtnDeleteAdd = ucAddressInfo.FindControl("ibtnDelete") as ImageButton;
            ImageButton btnClose = ucAddressInfo.FindControl("btnClose") as ImageButton;

            ImageButton ibtnUpdateAddr = ucAddressEntry.FindControl("ibtnUpdate") as ImageButton;
            ImageButton btnCloseEntry = ucAddressEntry.FindControl("btnClose") as ImageButton;
            ImageButton ibtnCancel = ucAddressEntry.FindControl("ibtnCancel") as ImageButton;

            btnEdit.Click += new ImageClickEventHandler(btnEdit_Click);
            btnClose.Click += new ImageClickEventHandler(btnClose_Click);
            ibtnDeleteAdd.Click += new ImageClickEventHandler(ibtnDeleteAdd_Click);
            ibtnUpdateAddr.Click += new ImageClickEventHandler(ibtnUpdateAddr_Click);            
            btnCloseEntry.Click+=new ImageClickEventHandler(btnCloseEntry_Click);
            ibtnCancel.Click+=new ImageClickEventHandler(ibtnCancel_Click);

            #endregion

            #endregion


            lblMessage.Visible =false;
            lblMessage.Text = "";
            pnlProgress.Update();

        }

        #region AJAX Methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="alphaCode"></param>
        /// <returns></returns>
        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string VendorDetails(string alphaCode)
        {
            try
            {
                string whereClause = "";
                string tableName = "VendorMaster";
                string columnName = "";

                try
                {
                    long vendCode = Convert.ToInt64(alphaCode);
                    whereClause = "VendNo like '%" + alphaCode + "%' and Deletedt is null";
                    columnName = "  Top 20 VendNo+' - '+Name as Name,pVendMstrID as VendID ";

                }
                catch (Exception ex)
                {
                    tableName = "VendorMaster A,VendorAddress B";
                    columnName = " Top 20  B.Code+' - '+A.Name as Name,A.pVendMstrID as VendID";
                    whereClause = " A.pVendMstrID=B.fVendMstrID And B.Code like '%" + alphaCode + "%'  and A.Deletedt is null  and B.Deletedt is null";
                }

                string detail = "";
                DataSet dsVendor = vendorDetails.GetDataToDateset(tableName, columnName, whereClause);
                if (dsVendor != null && dsVendor.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in dsVendor.Tables[0].Rows)
                        detail = detail + dr["Name"].ToString().Trim() + "~" + dr["VendID"].ToString().Trim() + "`";

                    return detail;
                }
                else
                    return "";

            }
            catch (Exception ex) { return ""; }
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string CheckLock(string lockValue,string search)
        {
            try
            {
                string vendValue = string.Empty;
                string vendNo = string.Empty;

                vendValue = ((search.Trim() == "Alpha") ? vendorDetails.GetVendorNumber("Code ='" + lockValue + "' and Deletedt is null") : vendorDetails.GetVendorNumber("VendNo ='" + lockValue + "' and Deletedt is null"));
                if (vendValue.Trim() == "")
                {
                    vendValue = vendorDetails.GetVendorNumber(" pVendMstrID in (select fVendMstrID from VendorAddress where Code = '" + lockValue + "') and Deletedt is null");
                    search = "Alpha";
                    if (vendValue.Trim() == "")
                    {
                        vendValue = vendorDetails.GetVendorNumber("VendNo='" + lockValue + "' and Deletedt is null");
                        search = "Vendor";
                    }
                }

                DataSet dsVenNo = new DataSet();
                if (search != "Vendor")
                {
                    dsVenNo = vendorDetails.GetDataToDateset("VendorMaster", "VendNo", "pVendMstrID=" + vendValue);
                    if (dsVenNo != null && dsVenNo.Tables[0].Rows.Count > 0)
                        vendNo = dsVenNo.Tables[0].Rows[0][0].ToString().Trim();
                }
                else
                    vendNo = lockValue;

                DataTable dtLock = vendorDetails.VendorLock("Lock",vendValue);
                if (dtLock != null && dtLock.Rows.Count > 0)
                    return dtLock.Rows[0][0].ToString().Trim() + "~" + dtLock.Rows[0][1].ToString().Trim()+"~"+vendNo;
                else
                    return "";
            }
            catch (Exception ex) { return ""; }
        }

        [Ajax.AjaxMethod()]
        public string CheckVendor(string vendNo)
        {
            try
            {
                DataSet dsVenNo = vendorDetails.GetDataToDateset("VendorMaster", "VendNo", "VendNo=" + vendNo +" and   Deletedt is null");
                if (dsVenNo != null && dsVenNo.Tables[0].Rows.Count > 0)
                    return dsVenNo.Tables[0].Rows[0][0].ToString().Trim();
                else
                    return "";
            }
            catch (Exception ex) { return ""; }
        }
        
        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public void ReleaseVendorLock()
        {
            vendorDetails.ReleaseLock();
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public void DeleteVendor(string vendorID)
        {
            string values= "deletedt='"+DateTime.Now.ToShortDateString() + "',Changedt= '"+DateTime.Now.ToShortDateString() +"',changeId='"+Session["UserName"].ToString() + "'";
            vendorDetails.UpdateVendorDetails("VendorMaster", values, "pvendmstrid=" + vendorID);
        }

        #endregion

        #region Button events

        #region Search Vendor Events

        protected void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                DataSet dsVendor = vendorDetails.GetDataToDateset("VendorMaster", "VendNo", "VendNo=" + ucSearchVendor.VendorNumber);
                
                ImageButton ibtnSave = ucVendorEntry.FindControl("ibtnSave") as ImageButton;
                ImageButton ibtnUpdate = ucVendorEntry.FindControl("ibtnUpdate") as ImageButton;

                ucVendorInfo.VendorNumber = ucLocationNavigator.VendorNumber = "";
                ucVendorInfo.Mode = ucLocationNavigator.Mode = "Add";
                ImageButton ibtnAdd = ucSearchVendor.FindControl("btnAdd") as ImageButton;

                AddMode();

                if (dsVendor != null && dsVendor.Tables[0].Rows.Count > 0)
                {
                    ibtnSave.Visible = true;
                    ibtnUpdate.Visible = false;
                    ucVendorEntry.VendorText = "";

                    ibtnAdd.Visible = true;
                    pnlAddressInformation.Update();
                    pnlSearchVendor.Update();
                }
                else
                {

                    ibtnSave.Visible = true;
                    //txtVendNo.Text = txtVendor.Text;
                    ucVendorEntry.VendorText = ucSearchVendor.VendorNumber;
                    lblMessage.Text = "";
                    lblMessage.Visible = false;
                    pnlProgress.Update();
                }

                pnlLocationDetails.Update();
                pnHeaderDetails.Update();
            }
            catch (Exception ex) { }
        }

        protected void btnDelete_Click(object sender, ImageClickEventArgs e)
        {
            try
            {

                TextBox txtVendor = ucSearchVendor.FindControl("txtVendor") as TextBox;
                TextBox txtVendNo = ucVendorEntry.FindControl("txtVendNo") as TextBox;
                DataSet dsVendor = vendorDetails.GetDataToDateset("VendorMaster", "VendNo", "VendNo=" + txtVendor.Text);
                ImageButton ibtnSave = ucVendorEntry.FindControl("ibtnSave") as ImageButton;
                ImageButton ibtnUpdate = ucVendorEntry.FindControl("ibtnUpdate") as ImageButton;

                ucVendorInfo.VendorNumber = ucLocationNavigator.VendorNumber = "";
                ucVendorInfo.Mode = ucLocationNavigator.Mode = "Add";
                ImageButton ibtnAdd = ucSearchVendor.FindControl("btnAdd") as ImageButton;

                AddMode();

                ibtnSave.Visible = true;
                txtVendNo.Text = txtVendor.Text;

                    lblMessage.Text = "";
                    lblMessage.Visible = false;
                    pnlProgress.Update();
               // }

                pnlLocationDetails.Update();
                pnHeaderDetails.Update();
            }
            catch (Exception ex) { }
        }

        protected void btnVenEdit_Click(object sender, ImageClickEventArgs e)
        {
            TextBox txtVendor = ucSearchVendor.FindControl("txtVendor") as TextBox; 
            HiddenField hidVendor = ucSearchVendor.FindControl("hidVendor") as HiddenField;
            DataSet dsVendor = vendorDetails.GetDataToDateset("VendorMaster", "VendNo,Name", "pvendmstrid=" + hidVendor.Value+" And DeleteDt is null");
              
            if (dsVendor != null && dsVendor.Tables[0].Rows.Count > 0)
                EditMode();
            else
            {
                lblMessage.Visible = true;
                lblMessage.Text = "Invalid vendor number!";
                pnlProgress.Update();
            }
            
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            EditMode();
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Hide", "javascript:if(document.getElementById('divSearch')!=null)document.getElementById('divSearch').style.display = 'none';", true);

        } 

        #endregion

        #region Location Navigator Events
       

        protected void btnBindDetails_Click(object sender, EventArgs e)
        {
            
            
            divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "");
            divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
            divVendorEntry.Style.Add(HtmlTextWriterStyle.Display, "none");

            HiddenField hidType = ucLocationNavigator.FindControl("hidType") as HiddenField;
            HiddenField hidBuyID = ucLocationNavigator.FindControl("hidBuy") as HiddenField;
            HiddenField hidShipID = ucLocationNavigator.FindControl("hidShip") as HiddenField;
            HiddenField hidMode = ucLocationNavigator.FindControl("hidMode") as HiddenField;
            HiddenField hidVendor = ucLocationNavigator.FindControl("hidVendor") as HiddenField;
            HiddenField hidVendorSch = ucLocationNavigator.FindControl("hidVendor") as HiddenField;

            if (hidType.Value == "BF")
            {
                ucVendorInfo.VendorNumber = hidVendor.Value;
                ucVendorInfo.Mode = "Edit";
            }
            else
                ucVendorInfo.ParentAddID = hidBuyID.Value.Trim();
            
            if (hidMode.Value.Trim() != "Add")
            {
                divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "none");
                divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "");
                ucAddressInfo.Type = hidType.Value;
                ucAddressInfo.ShipID = hidShipID.Value.Trim();
                ucAddressInfo.BuyID = hidBuyID.Value.Trim();
                ucAddressInfo.Vendor = hidVendorSch.Value;
                ucAddressInfo.Mode = hidMode.Value;
            }
            else
            {
                divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "");
                divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
                ucAddressEntry.Type = hidType.Value;
                ucAddressEntry.ShipID = hidShipID.Value.Trim();
                ucAddressEntry.BuyID = hidBuyID.Value.Trim();
                ucAddressEntry.Vendor = hidVendorSch.Value;
                ucAddressEntry.Mode = hidMode.Value;

                string locName = GetLocationName((hidType.Value.Trim() == "BF") ? hidBuyID.Value.Trim() : hidShipID.Value.Trim());
                if (locName != "")
                {
                    ucLocationNavigator.SelectNode = locName;
                    pnlLocationDetails.Update();
                }
            }
            pnlAddressInformation.Update();
            pnHeaderDetails.Update();

            
        } 

        #endregion

        #region Vendor Entry Events

        protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                ImageButton btnAdd = ucSearchVendor.FindControl("btnAdd") as ImageButton;
                pnlAddressInformation.Update();
                if (ucVendorEntry.VendorNumber.Trim() != "")
                {
                    HiddenField hidVendor = ucSearchVendor.FindControl("hidVendor") as HiddenField;
                    TextBox txtVendor = ucSearchVendor.FindControl("txtVendor") as TextBox;
                    TextBox txtVendNo = ucVendorEntry.FindControl("txtVendNo") as TextBox;
                   
                    ImageButton btnEdit = ucSearchVendor.FindControl("btnUpdate") as ImageButton;
                    ImageButton btnDelete = ucSearchVendor.FindControl("ibtnDelete") as ImageButton;

                    ImageButton btn = (ImageButton)sender;
                    btn.Visible = false;
                    btnEdit.Visible = true;
                    btnAdd.Visible = true;
                    btnDelete.Visible = true;
                    txtVendor.Text = txtVendNo.Text;
                    hidVendor.Value = ucVendorEntry.VendorNumber;
                    ucSearchVendor.SearchMode = "Vendor";
                    pnlSearchVendor.Update();
                    EditMode();

                    lblMessage.Visible = true;
                    lblMessage.Text = "Vendor information has been succesfully added";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    pnlProgress.Update();
                }
                else
                {
                    btnAdd.Visible = true;
                    lblMessage.Visible = true;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Vendor number already exists!";
                    pnlProgress.Update();
                    pnlSearchVendor.Update();
                }
            }
        }

        protected void ibtnUpdate_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                TextBox txtVendor = ucSearchVendor.FindControl("txtVendor") as TextBox;
                TextBox txtVendNo = ucVendorEntry.FindControl("txtVendNo") as TextBox;
                txtVendor.Text = txtVendNo.Text;
                pnlSearchVendor.Update();
                EditMode();

                lblMessage.Visible = true;
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Vendor information has been succesfully updated";
                pnlProgress.Update();
            }

        } 

        #endregion

        #region Address Enter Events

        protected void btnEdit_Click(object sender, ImageClickEventArgs e)
        {
            Label lblStatus = ucAddressEntry.FindControl("lblCodeStatus") as Label;
            if (lblStatus.Text == "")
            ShowAddressEntry();
        }

        protected void ibtnDeleteAdd_Click(object sender, ImageClickEventArgs e)
        {
            ucAddressEntry.Type = ucAddressInfo.Type;
           
            ucAddressEntry.BuyID = ucAddressInfo.Type == "BF" ? "0" : ucAddressInfo.BuyID;
            ucAddressEntry.ShipID = ucAddressInfo.Type == "SF" ? "0" : ucAddressInfo.ShipID;
            ucAddressEntry.Clear();
            ucAddressEntry.Mode = "Add";
            pnlAddressInformation.Update();
            string locName = "";
            if(ucAddressInfo.Type.Trim() =="SF")
                locName=GetLocationName(ucAddressInfo.BuyID.Trim());
            else
                 locName="Buy From";
         
            if (locName != "")
            {
                divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
                divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "");
                ucLocationNavigator.Mode = "Edit";
                ucLocationNavigator.SelectNode = locName;
                pnlLocationDetails.Update();
                pnlAddressInformation.Update();
            }

            
        }
        
        protected void ibtnUpdateAddr_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    Label lblStatus = ucAddressEntry.FindControl("lblCodeStatus") as Label;

                    if (lblStatus.Text == "")
                        ShowAddressInfo();

                    ucLocationNavigator.VendorNumber = ucSearchVendor.VendorID;
                    ucLocationNavigator.Mode = "Edit";

                    string locName = GetLocationName((ucAddressEntry.Type.Trim() == "BF") ? ucAddressEntry.BuyID.Trim() : ucAddressEntry.ShipID.Trim());
                    if (locName != "")
                        ucLocationNavigator.SelectNode = locName;

                    pnlLocationDetails.Update();
                }
                catch (Exception ex) { }
            }
        }

        public string GetLocationName(string id)
        {
            try
            {
                DataSet dsLocName = vendorDetails.GetDataToDateset("VendorAddress", "LocationName", "pVendAddrID=" +id );
                if (dsLocName != null && dsLocName.Tables[0].Rows.Count > 0)
                    return dsLocName.Tables[0].Rows[0][0].ToString().Trim();
                else
                    return "";
            }
            catch (Exception ex) { return ""; }
        }

        protected void btnClose_Click(object sender, ImageClickEventArgs e)
        {
            ShowAddressEntry();
        }

        protected void btnCloseEntry_Click(object sender, ImageClickEventArgs e)
        {
            ShowAddressInfo();
        }

        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            HiddenField hidMode = ucAddressEntry.FindControl("hidMode") as HiddenField;
            if (hidMode.Value.Trim() == "Add")
            {
                ucAddressEntry.Clear();
                pnlAddressInformation.Update();
            }
            else
            {
                ShowAddressInfo();
            }
        }
        #endregion
       
        #endregion

        #region Developer Methods

        public void AddMode()
        {
            try
            {
                //ucAddressEntry.Visible = false;
                //ucAddressInfo.Visible = false;
                //ucVendorEntry.Visible = true;

                divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "none");
                divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
                divVendorEntry.Style.Add(HtmlTextWriterStyle.Display, "");

                ucVendorInfo.Mode = ucVendorEntry.Mode = "Add";
                pnlAddressInformation.Update();
                
            }
            catch (Exception ex) { }
        }

        public void EditMode()
        {
            try
            {
                string search = "";
                
                divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "none");
                divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
                divVendorEntry.Style.Add(HtmlTextWriterStyle.Display, "");

                HiddenField hidVendor = ucSearchVendor.FindControl("hidVendor") as HiddenField;
                HiddenField hidType = ucSearchVendor.FindControl("hidType") as HiddenField;
                HiddenField hidAddrID = ucSearchVendor.FindControl("hidAddrID") as HiddenField;
                HiddenField hidSearchMode = ucSearchVendor.FindControl("hidSearchMode") as HiddenField;
                HiddenField hidParentAddID = ucSearchVendor.FindControl("hidParentAddID") as HiddenField;
                ucVendorEntry.ClearMode = "Clear";

                ucVendorInfo.VendorNumber=ucVendorEntry.VendorNumber = ucLocationNavigator.VendorNumber = "";
                ucVendorInfo.Mode = ucVendorEntry.Mode= ucLocationNavigator.Mode = "Add";
                search = hidSearchMode.Value.Trim();
                 if (hidVendor.Value != "")
                {
                    ucVendorInfo.VendorNumber = ucLocationNavigator.VendorNumber = hidVendor.Value;
                    ucVendorInfo.Mode = ucLocationNavigator.Mode = "Edit";
                    ucVendorInfo.ParentAddID = hidParentAddID.Value.Trim();
                    if (search.Trim() == "Alpha")
                    {
                        divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "none");
                        divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "");
                        divVendorEntry.Style.Add(HtmlTextWriterStyle.Display, "none");


                        ucAddressInfo.Type = hidType.Value.Trim();
                        ucAddressInfo.BuyID = ((hidType.Value.Trim() == "BF") ? hidAddrID.Value.Trim() : "");
                        ucAddressInfo.ShipID = ((hidType.Value.Trim() == "SF") ? hidAddrID.Value.Trim() : "");
                        ucAddressInfo.Vendor = hidVendor.Value;
                        ucAddressInfo.Mode = "Edit";

                        string locName = GetLocationName(hidAddrID.Value.Trim());
                        if (locName != "")
                            ucLocationNavigator.SelectNode = locName;
                    }
                    else if (search.Trim() == "Vendor")
                    {
                        ucVendorEntry.VendorNumber = hidVendor.Value;
                        ucVendorEntry.Mode = "Edit";
                    }

                    lblMessage.Text = "";
                    pnlProgress.Update();
                }
                else
                {
                    lblMessage.Text = "Invalid Search";
                    pnlProgress.Update();
                }
                pnlSearchVendor.Update();
                pnlLocationDetails.Update();
                pnHeaderDetails.Update();
                pnlAddressInformation.Update();
            }
            catch (Exception ex) { }
        }

        public void ShowAddressEntry()
        {
            try
            {
                divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "");
                divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
                divVendorEntry.Style.Add(HtmlTextWriterStyle.Display, "none");

                ucAddressEntry.Type = ucAddressInfo.Type;
                ucAddressEntry.Vendor = ucAddressInfo.Vendor;
                ucAddressEntry.ShipID = ucAddressInfo.ShipID;
                ucAddressEntry.BuyID = ucAddressInfo.BuyID;
                ucAddressEntry.Vendor = ucSearchVendor.VendorID;
                ucAddressEntry.Mode = "Edit";
                pnlAddressInformation.Update();
               
            }
            catch (Exception ex) { }
        }

        public void ShowAddressInfo()
        {
            divAddressEntry.Style.Add(HtmlTextWriterStyle.Display, "none");
            divAddressInfo.Style.Add(HtmlTextWriterStyle.Display, "");
            divVendorEntry.Style.Add(HtmlTextWriterStyle.Display, "none");

            ucAddressInfo.Type = ucAddressEntry.Type;
            ucAddressInfo.Vendor = ucAddressEntry.Vendor;
            ucAddressInfo.ShipID = ucAddressEntry.ShipID;
            ucAddressInfo.BuyID = ucAddressEntry.BuyID;
            ucAddressInfo.Vendor = ucSearchVendor.VendorID;
            ucAddressInfo.Mode = "Edit";
            pnlAddressInformation.Update();
           
        }

        #endregion
    } 
}
