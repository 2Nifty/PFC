#region Namespaces
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
using PFC.SOE;
using PFC.SOE.BusinessLogicLayer;
#endregion


    public partial class ItemControl : System.Web.UI.UserControl
    {
        #region Variable declaration

        public event EventHandler PackageChange;
        public event EventHandler Change;
        ItemBuilder itemBuilder = new ItemBuilder();
        DataTable dtItem = new DataTable();
        Utility utilityFunction = new Utility();

        #endregion

        #region Property Bag
        private string strItem = string.Empty;
        /// <summary>
        /// PFC ItemNumber 
        /// </summary>
        public string ItemNumber
        {
            get { return strItem; }
            set { strItem = value; }
        } 
        #endregion

        #region HAndlers

        /// <summary>
        /// Onvalue Change Event Handler
        /// </summary>
        /// <param name="e"></param>
        protected void OnValueChange(EventArgs e)
        {
            if (PackageChange != null)
            {
                PackageChange(this, e);
            }
        }
        /// <summary>
        /// onchange event handler
        /// </summary>
        /// <param name="e">EventArgs</param>
        protected void OnChange(EventArgs e)
        {
            if (Change != null)
            {
                Change(this, e);
            }
        }

        #endregion

        #region pageLoad
        /// <summary>
        /// PageLoad event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {


            ///Session["ItemFamily"] = hidItemValue.Value;
            Ajax.Utility.RegisterTypeForAjax(typeof(ItemControl));
            HideControl();
            if (Session["ItemFamily"] != null)
            {                
                if (ViewState["ItemFamily"] == null)
                {                    
                    LoadProductLine();                   
                }
                else if (ViewState["ItemFamily"].ToString() != Session["ItemFamily"].ToString())
                {
                    LoadProductLine();
                }
            }
            else
            {
                ddlProductLine.Visible = false;
                lblProductLine.Visible = false;
            }
        }
        private void HideControl()
        {
            #region Hide Controls

            ddlCategory.Visible = false;
            ddlDiameter.Visible = false;
            ddlLength.Visible = false;
            ddlPackage.Visible = false;
            ddlPlating.Visible = false;
            lblCategory.Visible = false;
            lblDiameter.Visible = false;
            lblLength.Visible = false;
            lblPackage.Visible = false;
            lblPlating.Visible = false;
            #endregion         
            lstCategory.Visible = false;
            lstDiameter.Visible = false;
            lstLength.Visible = false;
            lstPackage.Visible = false;
            lstPlating.Visible = false;
            
        }
        #endregion

        #region Developer Code

        /// <summary>
        /// LoadProductLine : Method used to Load Item Product Line
        /// </summary>
        private void LoadProductLine()
        {
            
            HideControl();
            if (Session["ItemFamily"] != null)
            {
                itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
                dtItem = itemBuilder.GetItemProductLine();

                // Call the function to bind the product line details
                utilityFunction.BindListControls(ddlProductLine, "PRODUCTLINEDESC", "PRODUCTLINE", dtItem);
                utilityFunction.BindListControls(lstProductLine, "PRODUCTLINEDESC", "PRODUCTLINE", dtItem);
                ddlProductLine.Items.Insert(0, new ListItem("-- Select Product Line --", ""));
                lstProductLine.Height = Unit.Pixel((lstProductLine.Items.Count * 17 > 100) ? (int)(lstProductLine.Items.Count * 15) : lstProductLine.Items.Count * 17);

                // Code updated by mahesh on 06/07/2007
                hidProductLine.Value = "1";
                
                lstProductLine.Visible = true;
                ddlProductLine.Visible = true;
                lblProductLine.Visible = true;
                ViewState["ItemFamily"] = Session["ItemFamily"].ToString();

                if (Page.IsPostBack)
                {
                    if (dtItem != null && lstProductLine.Items.Count == 1)
                    {
                        lstProductLine.Visible = false;
                        ddlProductLine.Items[1].Selected = true;
                        ddlProductLine_SelectedIndexChanged(ddlProductLine, new EventArgs());
                    } 
                }
               
            }
        }
        /// <summary>
        /// UpdateValue :method used to update value
        /// </summary>
        public void UpdateValue()
        {
            LoadProductLine();
        } 

        #endregion

        #region Event Handler

        /// <summary>
        /// ProductLine Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlProductLine_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["ItemLength"] = null;
            Session["ItemDiameter"] = null;

            if (ddlProductLine.SelectedIndex != 0)
            {

                #region Code to get the pareameter detail

                itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
                itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
                dtItem = itemBuilder.GetItemCatagory();

                #endregion

                #region Code to bind the controls

                // Call the function to bind the category details
                utilityFunction.BindListControls(ddlCategory, "Description", "Category", dtItem);
                utilityFunction.BindListControls(lstCategory, "Description", "Category", dtItem);
               
                lstProductLine.Visible = false;
                lstCategory.Visible = ((lstCategory.Items.Count > 1) ? true : false);

                // Code updated by mahesh on 06/07/2007
                hidProductLine.Value = "0";
                hidCategory.Value = ((lstCategory.Items.Count > 1) ? "1" :"0");
                lstCategory.Height = Unit.Pixel((lstCategory.Items.Count * 17 > 100) ? (int)(lstCategory.Items.Count * 15) : lstCategory.Items.Count * 17);
                
                if(lstCategory.Items.Count==1)
                    ddlCategory_SelectedIndexChanged(ddlCategory, new EventArgs());

                #endregion

                #region Show Control
                ddlCategory.Visible = true;
                lblCategory.Visible = true;
                #endregion

                OnChange(e);
            }
        }

        /// <summary>
        /// List ProductLine Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lstProductLine_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(ddlProductLine.SelectedValue != lstProductLine.SelectedValue)
               ddlProductLine.SelectedValue = lstProductLine.SelectedValue;

            lstProductLine.Visible = false;
            ddlProductLine_SelectedIndexChanged(ddlProductLine, new EventArgs());
            #region Show Control
            ddlCategory.Visible = true;
            lblCategory.Visible = true;
            #endregion

        }

        /// <summary>
        /// Category Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["ItemLength"] = null;
            Session["ItemDiameter"] = null;

            #region Code to get the pareameter details

            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
            itemBuilder.ItemCategory = ddlCategory.SelectedValue;
            dtItem = itemBuilder.GetItemDiameter();

            #endregion

            #region Code to bind the controls


            utilityFunction.BindListControls(ddlDiameter, "DIAMETERDESC", "DIAMETERCODE", dtItem);
            utilityFunction.BindListControls(lstDiameter, "DIAMETERDESC", "DIAMETERCODE", dtItem);
            lstDiameter.Visible = ((lstDiameter.Items.Count > 1) ? true : false);
            lstDiameter.Height = Unit.Pixel((lstDiameter.Items.Count * 17 > 100) ? (int)(lstDiameter.Items.Count * 15) : lstDiameter.Items.Count * 17);

            // Code updated by mahesh on 06/07/2007
            hidCategory.Value = "0";
            hidDiameter.Value = ((ddlDiameter.Items.Count>1)?"1":"0");
            
            if(ddlDiameter.Items.Count==1)
                ddlDiameter_SelectedIndexChanged(ddlDiameter, new EventArgs());

            #endregion

            #region Show Control
                ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            #endregion

            OnChange(e);
        }

        /// <summary>
        /// List Category Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lstCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(ddlCategory.SelectedValue != lstCategory.SelectedValue)
                ddlCategory.SelectedValue = lstCategory.SelectedValue;

            lstCategory.Visible = false;
            ddlCategory_SelectedIndexChanged(ddlCategory, new EventArgs());

            #region Show Control
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            #endregion
        }

        /// <summary>
        /// Diameter Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlDiameter_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["ItemLength"] = null;        
            Session["ItemDiameter"] = ddlDiameter.SelectedItem.Text;

            #region Code to get the pareameter details

            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
            itemBuilder.ItemCategory = ddlCategory.SelectedValue;
            itemBuilder.ItemDiameter = ddlDiameter.SelectedItem.Text;
            dtItem = itemBuilder.GetItemLength();

            #endregion

            #region Code to bind the controls

            BindLengthControls(ddlLength, "LENGTHDESC", "LENGTHCODE", dtItem);
            BindLengthControls(lstLength, "LENGTHDESC", "LENGTHCODE", dtItem);
            lstLength.Visible = ((lstLength.Items.Count > 1) ? true : false);
            
            hidDiameter.Value = "0";
            hidLength.Value = ((lstLength.Items.Count > 1) ?"1":"0");

            if(lstLength.Items.Count==1)
                ddlLength_SelectedIndexChanged(ddlLength, new EventArgs());

            #endregion

            #region Show Control
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            #endregion

            OnChange(e);
        }

        /// <summary>
        /// List Diameter Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lstDiameter_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(ddlDiameter.SelectedValue != lstDiameter.SelectedValue)
                 ddlDiameter.SelectedValue = lstDiameter.SelectedValue;
            
            lstDiameter.Visible = false;
            
            // Call the change event
            ddlDiameter_SelectedIndexChanged(ddlDiameter, new EventArgs());
            
            #region Show Control
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            #endregion

        }

        /// <summary>
        /// Length Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlLength_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["ItemLength"] = (ddlLength.SelectedIndex != 0) ? ddlLength.SelectedItem.Text : "";
            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();

            if (ddlLength.SelectedItem.Text != "-- Select All --")
            {
                #region Code to get the parameter details

                itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
                itemBuilder.ItemCategory = ddlCategory.SelectedValue;
                itemBuilder.ItemDiameter = ddlDiameter.SelectedItem.Text;
                itemBuilder.ItemLength = (ddlLength.SelectedIndex != 0) ? ddlLength.SelectedItem.Text : "";
                dtItem = itemBuilder.GetItemPlating();

                #endregion

                #region Code to bind the controls
                lstLength.Visible = false;
                utilityFunction.BindListControls(ddlPlating, "PLATINGDESC", "PLATING", dtItem);
                utilityFunction.BindListControls(lstPlating, "PLATINGDESC", "PLATING", dtItem);

                lstPlating.Visible =((lstPlating.Items.Count>1)? true:false);
                lstPlating.Height = Unit.Pixel((lstPlating.Items.Count * 17 > 100) ? (int)(lstPlating.Items.Count * 15) : lstPlating.Items.Count * 17);

                hidLength.Value = "0";
                hidPlating.Value = ((lstPlating.Items.Count>1)?"1":"0");

                if(lstPlating.Items.Count==1)
                    ddlPlating_SelectedIndexChanged(ddlPlating, new EventArgs());

                #endregion
            }
            else
            {
                ddlPlating.Items.Clear();
                ddlPlating.Items.Insert(0, new ListItem("-- Select All --", ""));
            }

            #region Show Control
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            ddlPlating.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            lblPlating.Visible = true;
            #endregion
            OnChange(e);
        }

        /// <summary>
        /// List Length Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lstLength_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlLength.SelectedValue = lstLength.SelectedValue;
            lstLength.Visible = false;
            ddlLength_SelectedIndexChanged(ddlLength, new EventArgs());
            #region Show Control
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            ddlPlating.Visible = true;
            lstCategory.Visible = false;
            lstDiameter.Visible = false;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            lblPlating.Visible = true;
            #endregion
            OnChange(e);
        }

        /// <summary>
        /// Plating Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlPlating_SelectedIndexChanged(object sender, EventArgs e)
        {
            ScriptManager.RegisterClientScriptBlock(lstPlating, typeof(ListBox), "hide", "document.getElementById('hidShowHide').value = 'Hide';", true);

            #region Code to get the pareameter details

            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
            itemBuilder.ItemCategory = ddlCategory.SelectedValue;
            itemBuilder.ItemDiameter = ddlDiameter.SelectedItem.Text;
            itemBuilder.ItemLength = (ddlLength.SelectedIndex != 0) ? ddlLength.SelectedItem.Text : "";
            itemBuilder.ItemPlating = ddlPlating.SelectedItem.Value;

            #endregion

            if (ddlPlating.SelectedItem.Text != "-- Select All --")
            {
                #region Code to bind the parameter details
                lstLength.Visible = false;
                dtItem = itemBuilder.GetAppPakage();
                utilityFunction.BindListControls(ddlPackage, "AppOptionValue", "AppOptionNumber", dtItem);
                utilityFunction.BindListControls(lstPackage, "AppOptionValue", "AppOptionNumber", dtItem);
                lstPackage.Height = Unit.Pixel((lstPackage.Items.Count * 17 > 100) ? (int)(lstPackage.Items.Count * 15) : lstPackage.Items.Count * 17);
                hidPlating.Value = "0";
                lstPackage.Visible = ((lstPackage.Items.Count > 1) ? true : false);

                if(lstPackage.Items.Count==1)
                    ddlPackage_SelectedIndexChanged(ddlPackage, new EventArgs());

                #endregion
            }
            else
            {
                //lstPackage.Visible = true;
                ddlPackage.Items.Clear();
                ddlPackage.Items.Insert(0, new ListItem("-- Select All --", ""));
            }

            #region Show Control
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            ddlPackage.Visible = true;
            ddlPlating.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            lblPackage.Visible = true;
            lblPlating.Visible = true;
            #endregion

            OnChange(e);
        }

        /// <summary>
        /// List Plating Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lstPlating_SelectedIndexChanged(object sender, EventArgs e)
        {
             ScriptManager.RegisterClientScriptBlock(lstPlating, typeof(ListBox), "hide", "document.getElementById('hidShowHide').value = 'Hide';", true);
            ddlPlating.SelectedValue = lstPlating.SelectedValue;
            lstPlating.Visible = false;
            ddlPlating_SelectedIndexChanged(ddlPlating, new EventArgs());
            #region Show Control
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            ddlPackage.Visible = true;
            ddlPlating.Visible = true;
            lstCategory.Visible = false;
            lstDiameter.Visible = false;
            lstLength.Visible = false;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            lblPackage.Visible = true;
            lblPlating.Visible = true;
            #endregion
            OnChange(e);
        }

        /// <summary>
        /// Package Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlPackage_SelectedIndexChanged(object sender, EventArgs e)
        {
            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
            itemBuilder.ItemCategory = ddlCategory.SelectedValue;
            itemBuilder.ItemDiameter = ddlDiameter.SelectedItem.Text;
            itemBuilder.ItemLength = (ddlLength.SelectedIndex != 0) ? ddlLength.SelectedItem.Text : "";
            itemBuilder.ItemPlating = ddlPlating.SelectedItem.Value;
            itemBuilder.ItemPackage = ddlPackage.SelectedItem.Value;

            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            ddlPackage.Visible = true;
            ddlPlating.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            lblPackage.Visible = true;
            lblPlating.Visible = true;

            if (Session["CustomerNumber"] != null)
            {
                dtItem = itemBuilder.GetItemNumber();

                if (dtItem != null && dtItem.Rows.Count != 0 && dtItem.Rows.Count == 1)
                {
                    ItemNumber = dtItem.Rows[0]["ItemNo"].ToString();
                    hidResetFlag.Value = "Reset";
                }
            }
          
            OnValueChange(e);
            OnChange(e);
            
        }

        /// <summary>
        /// List Package Selected Index Changed Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lstPackage_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPackage.SelectedValue = lstPackage.SelectedValue;           
            ddlPackage_SelectedIndexChanged(ddlPackage, new EventArgs());
            #region Show Control
            lstPackage.Visible = false;
            ddlCategory.Visible = true;
            ddlDiameter.Visible = true;
            ddlLength.Visible = true;
            ddlPackage.Visible = true;
            ddlPlating.Visible = true;
            lblCategory.Visible = true;
            lblDiameter.Visible = true;
            lblLength.Visible = true;
            lblPackage.Visible = true;
            lblPlating.Visible = true;
            #endregion
        }

        /// <summary>
        ///Reset Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void ibtnReset_Click(object sender, EventArgs e)
        {

            try
            {

                #region Control Hide
                ddlCategory.Visible = false;
                ddlDiameter.Visible = false;
                ddlLength.Visible = false;
                ddlPackage.Visible = false;
                ddlPlating.Visible = false;
                lblCategory.Visible = false;
                lblDiameter.Visible = false;
                lblLength.Visible = false;
                lblPackage.Visible = false;
                lblPlating.Visible = false;
                if (hidResetFlag.Value.Trim() == "Reset")
                {
                    try
                    {
                        ddlProductLine.SelectedIndex = 0;
                    }
                    catch (Exception ex)
                    {
                    }
                    hidResetFlag.Value = "";
                    return;
                }
                #endregion

                #region Clear control 
                Session["ItemLength"] = null;
                Session["ItemDiameter"] = null;
                ddlCategory.Items.Clear();
                ddlDiameter.Items.Clear();
                ddlLength.Items.Clear();
                ddlPackage.Items.Clear();
                ddlPlating.Items.Clear();
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Resize", "SetGridHeight('Common')", true);
                #endregion
            }
            catch (Exception ex)
            {
                
                throw;
            }

        } 

        #endregion

        #region Ajax Method
        /// <summary>
        /// GetItem :Used to get Item detail based on Item detail
        /// </summary>
        /// <param name="strItemFamily">strItemFamily</param>
        /// <param name="strProductLine">strProductLine</param>
        /// <param name="strItemCatagory">strProductLine</param>
        /// <param name="strDiameter">strProductLine</param>
        /// <param name="strLength">strProductLine</param>
        /// <param name="strPlating">strProductLine</param>
        /// <param name="strPackage">strProductLine</param>
        /// <returns></returns>
        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string GetItem(string strItemFamily, string strProductLine, string strItemCatagory, string strDiameter, string strLength, string strPlating, string strPackage)
        {

            try
            {
                itemBuilder.ItemFamily = strItemFamily;
                itemBuilder.ItemProductLine = strProductLine;
                itemBuilder.ItemCategory = strItemCatagory;
                itemBuilder.ItemDiameter = strDiameter;
                itemBuilder.ItemLength = strLength;
                itemBuilder.ItemPlating = strPlating;
                itemBuilder.ItemPackage = strPackage;
                DataTable itemDetail = itemBuilder.GetItemNumber();
                if (itemDetail != null && itemDetail.Rows.Count != 0)
                {
                    return itemDetail.Rows[0][0].ToString();
                }
                return "";

            }
            catch (Exception ex)
            { return ""; }
        }

        #endregion     

        #region Code updated by mahesh on 06/07/2007

        protected void btnClick_Click(object sender, EventArgs e)
        {
            try
            {
                switch (hidControlName.Value.Split('`')[0].Split('_')[1].Trim())
                {
                    case "ddlProductLine":
                        ddlProductLine_SelectedIndexChanged(ddlProductLine, new EventArgs());
                        break;
                    case "ddlCategory":
                        ddlCategory_SelectedIndexChanged(ddlCategory, new EventArgs());
                        break;
                    case "ddlLength":
                        ddlLength_SelectedIndexChanged(ddlLength, new EventArgs());
                        break;
                    case "ddlDiameter":
                        ddlDiameter_SelectedIndexChanged(ddlDiameter, new EventArgs());
                        break;
                    case "ddlPlating":
                        ddlPlating_SelectedIndexChanged(ddlPlating, new EventArgs());
                        break;
                }
               // ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Resize", "ItembuilderHeight();", true);
            }
            catch (Exception ex) { }
        }

        #endregion

        public void BindLengthControls(ListControl lstControl, string textField, string valueField, DataTable dtSource)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();


                }
                else
                {
                    lstControl.Items.Clear();
                    lstControl.Items.Insert(0, new ListItem("N/A", ""));

                }
            }
            catch (Exception ex) { }
        }
    } //End Class

