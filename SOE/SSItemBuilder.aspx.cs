using System;
using System.Data;
using System.Data.SqlClient;
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
using PFC.SOE.DataAccessLayer;

public partial class SSItemBuilder : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    #region Variable declaration
    ItemBuilder itemBuilder = new ItemBuilder();
    Utility utilityFunction = new Utility();
    public event EventHandler ItemClick;
    public event EventHandler PackageChange;
    public event EventHandler Change;
    DataTable dtItem = new DataTable();
    #endregion


    #region Page load event handler
    /// <summary>
    /// Page load event handlers
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadMenu();
            OnItemClick(e);
            SSItemBuilderScriptManager.SetFocus("dgMenu");
        }
        ///Session["ItemFamily"] = hidItemValue.Value;
        Ajax.Utility.RegisterTypeForAjax(typeof(SSItemBuilder));
        //HideControl();
        //if (Session["ItemFamily"] != null)
        //{
        //    if (ViewState["ItemFamily"] == null)
        //    {
        //        LoadProductLine();
        //    }
        //    else if (ViewState["ItemFamily"].ToString() != Session["ItemFamily"].ToString())
        //    {
        //        LoadProductLine();
        //    }
        //}
        //else
        //{
        //    ddlProductLine.Visible = false;
        //    lblProductLine.Visible = false;
        //}
    }
    #endregion

    #region Developer Code
    /// <summary>
    /// Load Item family Menu
    /// </summary>
    private void LoadMenu()
    {
        try
        {
            DataTable dtItemFamily = itemBuilder.GetItemFamily();
            dgMenu.DataSource = dtItemFamily;
            dgMenu.DataBind();
            //if (dtItemFamily != null)
            //{
            //    if (dtItemFamily.Rows.Count > 0)
            //    {
            //        foreach (DataRow row in dtItemFamily.Rows)
            //        {
            //            MenuItem tabItem = new MenuItem((string)row["ChapterDesc"], (string)row["CHAPTER"]);
            //            tabItem.ToolTip = row["ChapterDesc"].ToString();
            //            //tabItem.NavigateUrl = "Javascript:GetItemFamily('" + (string)row["CHAPTER"] + "');";
            //            muItemFamily.Items.Add(tabItem);

            //        }
            //    }
            //}
        }
        catch (Exception ex)
        {
            throw;
        }

    }
    protected void MenuRowBound(Object sender, GridViewRowEventArgs e)
    {
        // set the mouse over styles
        GridViewRow row = e.Row;
        if (row.RowType == DataControlRowType.DataRow)
        {
            row.Cells[0].Attributes.Add("onmouseover", "javascript:this.className='leftMenuItemMo';");
            row.Cells[0].Attributes.Add("onmouseout", "javascript:this.className='leftMenuItem';");
            row.Cells[0].Attributes.Add("onclick", "javascript:this.className='leftMenuItemMo';");
        }
    }
    #endregion

    #region Event Handler
    /// <summary>
    /// Event HAndler
    /// </summary>
    /// <param name="e"></param>
    protected void OnItemClick(EventArgs e)
    {
        if (ItemClick != null)
        {
            ItemClick(this, e);

        }
    }
    /// <summary>
    /// Item family section event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void muItemFamily_MenuItemClick(object sender, MenuEventArgs e)
    {
        Session["ItemFamily"] = e.Item.Value;
        OnItemClick(e);
    }

    protected void dgMenu_Command(Object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ShowProductLines")
        {
            //ScriptManager.RegisterClientScriptBlock(ddlProductLine, ddlProductLine.GetType(), "Customer", "alert('" + e.CommandArgument.ToString() + "');", true);
            Session["ItemFamily"] = e.CommandArgument.ToString();
            LoadProductLine();
            ControlPanel.Update();
        }
    }
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
    //protected void Page_Load(object sender, EventArgs e)
    //{


    //    ///Session["ItemFamily"] = hidItemValue.Value;
    //    Ajax.Utility.RegisterTypeForAjax(typeof(ItemControl));
    //    HideControl();
    //    if (Session["ItemFamily"] != null)
    //    {
    //        if (ViewState["ItemFamily"] == null)
    //        {
    //            LoadProductLine();
    //        }
    //        else if (ViewState["ItemFamily"].ToString() != Session["ItemFamily"].ToString())
    //        {
    //            LoadProductLine();
    //        }
    //    }
    //    else
    //    {
    //        ddlProductLine.Visible = false;
    //        lblProductLine.Visible = false;
    //    }
    //}
    #endregion

    #region Developer Code
    protected void Chapter_Click(object sender, EventArgs e)
    {
        Session["ItemFamily"] = ChapterHidden.Value;
        LoadProductLine();
        ControlPanel.Update();
    }
    /// <summary>
    /// LoadProductLine : Method used to Load Item Product Line
    /// </summary>
    private void LoadProductLine()
    {

        if (Session["ItemFamily"] != null)
        {
            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            dtItem = itemBuilder.GetItemProductLine();

            // Call the function to bind the product line details
            utilityFunction.BindListControls(ddlProductLine, "PRODUCTLINEDESC", "PRODUCTLINE", dtItem);
            ddlProductLine.Items.Insert(0, new ListItem("-- Select Product Line --", ""));
            ViewState["ItemFamily"] = Session["ItemFamily"].ToString();
            ddlCategory.Items.Clear();
            ddlDiameter.Items.Clear();
            ddlLength.Items.Clear();
            //ddlPackage.Items.Clear();
            //ddlPlating.Items.Clear();
            if (Page.IsPostBack)
            {
                if (dtItem != null && ddlProductLine.Items.Count == 2)
                {
                    //lstProductLine.Visible = false;
                    ddlProductLine.Items[1].Selected = true;
                    ddlProductLine_SelectedIndexChanged(ddlProductLine, new EventArgs());
                    SSItemBuilderScriptManager.SetFocus("ddlCategory");
                }
                else
                {
                    SSItemBuilderScriptManager.SetFocus("ddlProductLine");
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
            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
            dtItem = itemBuilder.GetItemCatagory();
            // Call the function to bind the category details
            utilityFunction.BindListControls(ddlCategory, "Description", "Category", dtItem);
            hidProductLine.Value = "0";
            if (ddlCategory.Items.Count == 1)
            {
                ddlCategory_SelectedIndexChanged(ddlCategory, new EventArgs());
            }
            else
            {
                SSItemBuilderScriptManager.SetFocus("ddlCategory");
            }
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
        //if (ddlProductLine.SelectedValue != lstProductLine.SelectedValue)
        //    ddlProductLine.SelectedValue = lstProductLine.SelectedValue;

        //lstProductLine.Visible = false;
        ddlProductLine_SelectedIndexChanged(ddlProductLine, new EventArgs());
        #region Show Control
        ddlCategory.Visible = true;
        //lblCategory.Visible = true;
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
        BuiltItem.Text = ddlCategory.SelectedValue + "-"; 
        dtItem = itemBuilder.GetItemDiameter();

        utilityFunction.BindListControls(ddlDiameter, "DIAMETERDESC", "DIAMETERCODE", dtItem);
        hidDiameter.Value = ((ddlDiameter.Items.Count > 1) ? "1" : "0");

        if (ddlDiameter.Items.Count == 1)
        {
            ddlDiameter_SelectedIndexChanged(ddlDiameter, new EventArgs());
        }
        else
        {
            SSItemBuilderScriptManager.SetFocus("ddlDiameter");
        }

        #endregion
        OnChange(e);
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
        BuiltItem.Text = BuiltItem.Text.Substring(0, 6) + "-" + ddlDiameter.SelectedValue;
        dtItem = itemBuilder.GetItemLength();

        utilityFunction.BindListControls(ddlLength, "LENGTHDESC", "LENGTHCODE", dtItem);
        //hidLength.Value = ((lstLength.Items.Count > 1) ? "1" : "0");

        if (ddlLength.Items.Count == 1)
        {
            ddlLength_SelectedIndexChanged(ddlLength, new EventArgs());
            BuiltItem.Text += "00-";
        }
        else
        {
            SSItemBuilderScriptManager.SetFocus("ddlLength");
        }

        #endregion
        OnChange(e);
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
            GetItem(ddlCategory.SelectedValue);

            //dtItem = itemBuilder.GetItemPlating();

            #endregion

            //#region Code to bind the controls
            ////lstLength.Visible = false;
            //utilityFunction.BindListControls(ddlPlating, "PLATINGDESC", "PLATING", dtItem);
            //hidLength.Value = "0";
            ////hidPlating.Value = ((lstPlating.Items.Count > 1) ? "1" : "0");

            //if (ddlPlating.Items.Count == 1)
            //{
            //    ddlPlating_SelectedIndexChanged(ddlPlating, new EventArgs());
            //}
            //else
            //{
            //    SSItemBuilderScriptManager.SetFocus("ddlPlating");
            //}

            //#endregion
        }
        else
        {
            //ddlPlating.Items.Clear();
            //ddlPlating.Items.Insert(0, new ListItem("-- Select All --", ""));
        }

        OnChange(e);
    }

    ///// <summary>
    ///// Plating Selected Index Changed Event handler
    ///// </summary>
    ///// <param name="sender"></param>
    ///// <param name="e"></param>
    //protected void ddlPlating_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    //ScriptManager.RegisterClientScriptBlock(lstPlating, typeof(ListBox), "hide", "document.getElementById('hidShowHide').value = 'Hide';", true);

    //    #region Code to get the pareameter details

    //    itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
    //    itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
    //    itemBuilder.ItemCategory = ddlCategory.SelectedValue;
    //    itemBuilder.ItemDiameter = ddlDiameter.SelectedItem.Text;
    //    itemBuilder.ItemLength = (ddlLength.SelectedIndex != 0) ? ddlLength.SelectedItem.Text : "";
    //    itemBuilder.ItemPlating = ddlPlating.SelectedItem.Value;

    //    #endregion

    //    if (ddlPlating.SelectedItem.Text != "-- Select All --")
    //    {
    //        #region Code to bind the parameter details
    //        dtItem = itemBuilder.GetItemPackage();
    //        utilityFunction.BindListControls(ddlPackage, "PACKAGEDESC", "PACKAGEID", dtItem);
    //        hidPlating.Value = "0";
    //        if (ddlPackage.Items.Count == 1)
    //        {
    //            ddlPackage_SelectedIndexChanged(ddlPackage, new EventArgs());
    //        }
    //        else
    //        {
    //            SSItemBuilderScriptManager.SetFocus("ddlPlating");
    //        }
    //        #endregion
    //    }
    //    else
    //    {
    //        //lstPackage.Visible = true;
    //        ddlPackage.Items.Clear();
    //        ddlPackage.Items.Insert(0, new ListItem("-- Select All --", ""));
    //    }
    //    OnChange(e);
    //}

    ///// <summary>
    ///// Package Selected Index Changed Event handler
    ///// </summary>
    ///// <param name="sender"></param>
    ///// <param name="e"></param>
    //protected void ddlPackage_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
    //    itemBuilder.ItemProductLine = ddlProductLine.SelectedValue;
    //    itemBuilder.ItemCategory = ddlCategory.SelectedValue;
    //    itemBuilder.ItemDiameter = ddlDiameter.SelectedItem.Text;
    //    itemBuilder.ItemLength = (ddlLength.SelectedIndex != 0) ? ddlLength.SelectedItem.Text : "";
    //    itemBuilder.ItemPlating = ddlPlating.SelectedItem.Value;
    //    itemBuilder.ItemPackage = ddlPackage.SelectedItem.Value;

    //    dtItem = itemBuilder.GetItemNumber();
    //    ItemsGridView.DataSource = dtItem;
    //    ItemsGridView.DataBind();
    //    //if (Session["CustomerNumber"] != null)
    //    //{

    //    //    if (dtItem != null && dtItem.Rows.Count != 0 && dtItem.Rows.Count == 1)
    //    //    {
    //    //        ItemNumber = dtItem.Rows[0]["ItemNo"].ToString();
    //    //        hidResetFlag.Value = "Reset";
    //    //    }
    //    //}

    //    OnValueChange(e);
    //    OnChange(e);

    //}

    ///// <summary>
    ///// List Package Selected Index Changed Event handler
    ///// </summary>
    ///// <param name="sender"></param>
    ///// <param name="e"></param>
    //protected void lstPackage_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    //ddlPackage.SelectedValue = lstPackage.SelectedValue;
    //    ddlPackage_SelectedIndexChanged(ddlPackage, new EventArgs());
    //    #region Show Control
    //    //lstPackage.Visible = false;
    //    //ddlCategory.Visible = true;
    //    //ddlDiameter.Visible = true;
    //    //ddlLength.Visible = true;
    //    //ddlPackage.Visible = true;
    //    //ddlPlating.Visible = true;
    //    //lblCategory.Visible = true;
    //    //lblDiameter.Visible = true;
    //    //lblLength.Visible = true;
    //    //lblPackage.Visible = true;
    //    //lblPlating.Visible = true;
    //    #endregion
    //}

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
            //ddlCategory.Visible = false;
            //ddlDiameter.Visible = false;
            //ddlLength.Visible = false;
            //ddlPackage.Visible = false;
            //ddlPlating.Visible = false;
            //lblCategory.Visible = false;
            //lblDiameter.Visible = false;
            //lblLength.Visible = false;
            //lblPackage.Visible = false;
            //lblPlating.Visible = false;
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
            //ddlPackage.Items.Clear();
            //ddlPlating.Items.Clear();

            #endregion
        }
        catch (Exception ex)
        {

            throw;
        }

    }

    #endregion

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        // allow click to open stock status
        GridViewRow row = e.Row;
        if (row.RowType == DataControlRowType.DataRow)
        {
            // set the link command
            LinkButton SSLink = (LinkButton)row.Cells[0].Controls[1];
            SSLink.OnClientClick = "SetItemNumber('" +
                Server.HtmlDecode(SSLink.Text) + "');";
        }
    }

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
    public void GetItem(string Cat)
    {
        try
        {
            string Size = ddlDiameter.SelectedValue + ddlLength.SelectedValue;
            //string Var = ddlPackage.SelectedItem.Value + ddlPlating.SelectedItem.Value;
            if (Size.Length < 4)
            {
                Size += "__";
            }
            // get the items.
            string Var = "___";
            BuiltItem.Text = Cat + "-" + Size + "-" + Var;
            ds = SqlHelper.ExecuteDataset(connectionString, "pSSSearchItems",
                new SqlParameter("@SearchCat", Cat),
                new SqlParameter("@SearchSize", Size),
                new SqlParameter("@SearchVar", Var));
            if (ds.Tables.Count >= 1)
            {
                if (ds.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        ShowPageMessage("Item not found.", 2);
                    }
                }
                else
                {
                    dt = ds.Tables[1];
                    if (dt.Rows.Count == 0)
                    {
                        ShowPageMessage("No Items found.", 2);
                    }
                    else
                    {
                        ItemsGridView.DataSource = dt;
                        ItemsGridView.DataBind();
                        ItemsUpdatePanel.Update();
                        ShowPageMessage(dt.Rows.Count.ToString() + " Items found. Maximum is 500", 0);
                    }
                }
            }
        }
        catch (Exception ex)
        { //return ""; 
        }
    }

    protected void GetItemsClick(object sender, EventArgs e)
    {
        string Cat = ddlCategory.SelectedValue;
        if (Cat.Length == 0)
        {
            ShowPageMessage("You must select a category.", 2);
        }
        else
        {
            GetItem(Cat);
        }
    }

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
                //case "ddlPlating":
                //    ddlPlating_SelectedIndexChanged(ddlPlating, new EventArgs());
                //    break;

            }
        }
        catch (Exception ex) { }
    }

    #endregion

    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        MessageUpdatePanel.Update();
    }
    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        switch (MessageType)
        {
            case 1:
                MessageLabel.CssClass = "warn";
                break;
            case 2:
                MessageLabel.CssClass = "error";
                break;
            default:
                MessageLabel.CssClass = "success";
                break;
        }
        //MessageLabel.CssClass = "error";
        MessageLabel.Text = PageMessage;
        MessageUpdatePanel.Update();
    }

    
    
    
    
}
