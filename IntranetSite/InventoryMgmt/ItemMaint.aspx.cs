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
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class ItemMaint : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    ddlBind ddlBind = new ddlBind();
    MaintenanceUtility Security = new MaintenanceUtility();

    #region Variable Declarations
    string IMProcName = "pIMGetItem";
    string UPCProcName = "pIMGetUPC";
    string BrnProcName = "pIMBranchMaint";
    DataSet dsItemMaint, dsBranch, dsNewUPC, dsParent;
    DataTable dtIM, dtUOM, dtBranch, dtUOMDivisor, dtCat, dtUPC, dtNewUPC, dtParent;
    string strSQL = string.Empty;
    string _sessID = string.Empty;

    string _devDisp = "NO";    //Set this to "YES" to display development info tools; any other value, they are hidden

    //Session Variables to hold the Datatables
    //  Session["dtIM"]
    //  Session["dtUOM"]
    //  Session["dtBranch"]
    //  Session["dtUOMDivisor"]
    //  Session["dtCat"]
    //  Session["dtUPC"]
    //  Session["dtParent"]
    #endregion Variable Declarations

    #region Page Load
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(ItemMaint));
        
        if (!IsPostBack)
        {
            lblUserInfo.Text = Session["UserName"].ToString().Trim() + " - " + Session["SessionID"].ToString().Trim();
            smItemMaint.SetFocus(txtSourceItem);
            ClearPrompt();
            ClearDisplay();
            GetSecurity();
            BindDDL();

            if (_devDisp.ToUpper() == "YES")
            {
                tdWrkFld.Visible = true;
                //TMD: add field names as tooltip in DEV mode
                //lblUnitsPerBase.ToolTip = "SellStkUMQty";
            }
            else
            {
                tdWrkFld.Visible = false;
            }

            hidSOESiteURL.Value = ConfigurationSettings.AppSettings["SOESiteURL"].ToString();
            //Footer1.FooterTitle = "QAv7.0 -- " + Footer1.FooterTitle + " -- QAv7.0";
        }
    }
    #endregion Page Load

    //----------------------------------------------------------------------------------------------------//
    #region Find & Validate the Item Data
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    //This Method fires at the beginning of the CheckItem javascript to validate the itemNo
    //Primary Method to read & validate all of the data records and store the data in session variables
    //Tables[0] = ItemMaster
    //Tables[1] = ItemUOM
    //Tables[2] = ItemBranch
    //Tables[3] = ItemUPC
    //Tables[4] = CategoryDesc (from List)
    //Tables[5] = ItemUMDivisor (from List)
    #region Check Item No
    public string CheckItem(string itemNo)
    {
        ClearSession();

        try
        {
            dsItemMaint = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", itemNo.ToString().Trim()),
                                                                      new SqlParameter("@OrigID", ""),
                                                                      new SqlParameter("@SessID", ""),
                                                                      new SqlParameter("@Mode", "SELECT"));
        }
        catch
        {
            return "error";
        }

        //Did we get a Category record?
        if (dsItemMaint.Tables[4].Rows.Count > 0)
        {
            dtCat = dsItemMaint.Tables[4].DefaultView.ToTable();
            Session["dtCat"] = dtCat;
        }

        //Did we get an ItemMaster record?
        if (dsItemMaint.Tables[0].Rows.Count > 0)
        {
            //ItemFound = true
            dtIM = dsItemMaint.Tables[0].DefaultView.ToTable();
            Session["dtIM"] = dtIM;

            //Did we get any UOM records?
            //if (dsItemMaint.Tables[1].Rows.Count > 0)
            //{
                dtUOM = dsItemMaint.Tables[1].DefaultView.ToTable();
                Session["dtUOM"] = dtUOM;
            //}

            //Did we get any Branch records?
            //if (dsItemMaint.Tables[2].Rows.Count > 0)
            //{
                dtBranch = dsItemMaint.Tables[2].DefaultView.ToTable();
                Session["dtBranch"] = dtBranch;
            //}

            //Did we get a UPC records?
            if (dsItemMaint.Tables[3].Rows.Count > 0)
            {
                dtUPC = dsItemMaint.Tables[3].DefaultView.ToTable();
                Session["dtUPC"] = dtUPC;
            }

            //Did we get UOM Divisor records?
            //if (dsItemMaint.Tables[5].Rows.Count > 0)
            //{
                dtUOMDivisor = dsItemMaint.Tables[5].DefaultView.ToTable();
                Session["dtUOMDivisor"] = dtUOMDivisor;
            //}

            return "true";
        }
        else
        {
            //ItemFound = false
            if (dsItemMaint.Tables[4].Rows.Count > 0)
            {
                return "false"; //Item does not exist BUT the Category IS valid
            }
            else
            {
                return "nocat"; //Item does not exist AND the Category is NOT valid
            }
        }
    }
    #endregion Check Item No

    //This Method fires at the beginning of the CheckItem javascript to validate the ParentItem (OnChange only)
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    #region Check Parent Item No
    public string CheckParent(string itemNo)
    {

        try
        {
            dsParent = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", itemNo.ToString().Trim()),
                                                                   new SqlParameter("@OrigID", ""),
                                                                   new SqlParameter("@SessID", ""),
                                                                   new SqlParameter("@Mode", "PARENT"));
        }
        catch
        {
            return "false";
        }

        //Did we find the Parent record?
        dtParent = dsParent.Tables[0].DefaultView.ToTable();
        Session["dtParent"] = dtParent;
        if (dtParent.Rows.Count > 0)
        {
            //Yes we did
            return "true";
        }
        else
        {
            //No we didn't
            return "false";
        }
    }
    #endregion Check Parent Item No

    //This Method fires [btnHidSubmitSource.click] at the end of the CheckItem javascript after the itemNo has been validated
    protected void btnHidSubmitSource_Click(object sender, EventArgs e)
    {
        #region Clear the display
        if (hidMaintMode.Value.ToUpper() == "CLEAR")
        {
            hidMaintMode.Value = "";
            Release(hidItemID.Value.ToString().Trim(),lblItemNo.Text.ToString().Trim(),txtLblUPCCd.Text.ToString().Trim(),hidUPCCd.Value.ToString().Trim(),hidLockStatus.Value.ToString().Trim(),hidLockUser.Value.ToString().Trim());
            ClearPrompt();
            ClearDisplay();
        }
        DisplayStatusMessage("", "success");
        #endregion Clear the display

        #region Parent Item Changed
        if (hidInsConf.Value.ToUpper() == "NOPARENT")
        {
            //txtParent.Text = string.Empty;
            lblBOMInd.Text = string.Empty;
            smItemMaint.SetFocus(txtParent);
            pnlBody.Update();
            DisplayStatusMessage("Invalid Parent Item", "fail");
            return;
        }

        if (hidInsConf.Value.ToUpper() == "PARENT")
        {
            dtParent = (DataTable)Session["dtParent"];
            lblBOMInd.Text = dtParent.Rows[0]["BOMInd"].ToString().Trim();
            pnlBody.Update();
            return;
        }
        #endregion Parent Item Changed

        #region Process the specific Maintenance Mode [hidMaintMode]
        //ItemList
        if (hidMaintMode.Value.ToUpper() == "LIST")
        {
            //ItemNoParam comes from SSItemList
            //Stored procedure (IMProcName) has not yet been executed to return the specific item information
            //We know the item is valid because it came from the list (validation is bypassed)
            //This will set hidMaintMode to 'EDIT' or 'ERROR' and then fall through to process further.
            #region ItemList
            string _checkItem = CheckItem(txtSourceItem.Text.ToString().Trim());
            if (_checkItem.ToLower() == "error")
                hidMaintMode.Value = "ERROR";

            if (_checkItem.ToLower() == "true")
            {
                hidMaintMode.Value = "EDIT";
            }
            else
            {
                //Unknown error
                hidMaintMode.Value = "ERROR";
            }
            #endregion ItemList
        }

        //ItemMaster Record Found (EDIT)
        if (hidMaintMode.Value.ToUpper() == "EDIT")
        {
            #region EDIT Mode
            Release(hidItemID.Value.ToString().Trim(),lblItemNo.Text.ToString().Trim(),txtLblUPCCd.Text.ToString().Trim(),hidUPCCd.Value.ToString().Trim(),hidLockStatus.Value.ToString().Trim(),hidLockUser.Value.ToString().Trim());
            ClearDisplay();
            if (hidScreenMode.Value.ToUpper() == "OFF" && hidSecurity.Value != "1")
                ToggleScreen("ON");

            #region ItemMaster Record (EDIT)
            dtIM = (DataTable)Session["dtIM"];
            hidItemID.Value = dtIM.Rows[0]["ItemID"].ToString().Trim();
            hidItemNo.Value = dtIM.Rows[0]["ItemNo"].ToString().Trim();

            if (!string.IsNullOrEmpty(dtIM.Rows[0]["DeleteDt"].ToString().Trim()))
            {
                hidMaintMode.Value = "DEL";
                ToggleScreen("OFF");
                string _delMsg = "Record deleted by " +
                                 dtIM.Rows[0]["DeleteID"].ToString().Trim() +
                                 " on " +
                                 Convert.ToDateTime(dtIM.Rows[0]["DeleteDt"].ToString().Trim()).ToShortDateString() +
                                 " [Query Only]";
                hidStsMsg.Value = _delMsg.ToString();
                DisplayStatusMessage(hidStsMsg.Value.ToString(), "fail");
            }
            else
            {
                CheckLock("ItemMaster", hidItemID.Value.ToString().Trim(), "IMM");
                if (hidLockStatus.Value.ToString().Trim() == "L")
                {
                    hidMaintMode.Value = "LOCK";
                    ToggleScreen("OFF");
                    hidStsMsg.Value = "Record Locked By " + hidLockUser.Value.ToString().Trim();
                    DisplayStatusMessage(hidStsMsg.Value.ToString(), "fail");
                }
                else
                {
                    hidMaintMode.Value = "EDIT";
                    DisplayStatusMessage("", "success");
                }
            }
            #endregion ItemMaster Record (EDIT)

            #region ItemUM Record (EDIT)
            dtUOM = (DataTable)Session["dtUOM"];
            if (dtUOM == null || dtUOM.Rows.Count <= 0)
            {
                ItemUOMError("");
            }
            #endregion ItemUM Record (EDIT)

            #region ItemBranch Record (EDIT)
            dtBranch = (DataTable)Session["dtBranch"];
            if (dtBranch == null || dtBranch.Rows.Count <= 0)
            {
                tblItemBrn.Visible = false;
                DisplayStatusMessage("Item Branch detail data not found", "fail");
            }
            if (dtBranch != null) gvItemBrn_Bind();
            #endregion ItemUM Record (EDIT)

            #region ItemUPC Record (EDIT)
            if (Session["dtUPC"] != null)
            {
                dtUPC = (DataTable)Session["dtUPC"];
                hidUPCID.Value = dtUPC.Rows[0]["pItemUPCID"].ToString().Trim();
                hidUPCCd.Value = dtUPC.Rows[0]["UPCCd"].ToString().Trim();
            }
            else
            {
                dtUPC = null;
                hidUPCID.Value = string.Empty;
                hidUPCCd.Value = string.Empty;
            }
            #endregion ItemUPC Record (EDIT)

            #region CategoryDesc (from List)
            if (Session["dtCat"] != null)
            {
                dtCat = (DataTable)Session["dtCat"];
                hidCatNo.Value = dtCat.Rows[0]["Category"].ToString().Trim();
                hidCatDesc.Value = dtCat.Rows[0]["CategoryDesc"].ToString().Trim();
            }
            else
            {
                dtCat = null;
                hidCatNo.Value = string.Empty;
                hidCatDesc.Value = string.Empty;
            }
            #endregion CategoryDesc (from List)

            DisplayItem();

            if (dtUOM != null)
            {
                //tblItemUOM.Visible = true;
                //divDtlStatus.Visible = true;
                hidDtlUOMMsg.Value = string.Empty;
                lblDtlStatus.ForeColor = System.Drawing.Color.Green;
                UOMDetails("ALL");  //We still want to execute UOMDetails even if there are no rows in dtUOM
            }
            #endregion EDIT Mode
        }

        //ItemMaster Record NOT Found (INS)
        if (hidMaintMode.Value.ToUpper() == "INS")
        {
            #region INSERT Mode
            Release(hidItemID.Value.ToString().Trim(),lblItemNo.Text.ToString().Trim(),txtLblUPCCd.Text.ToString().Trim(),hidUPCCd.Value.ToString().Trim(),hidLockStatus.Value.ToString().Trim(),hidLockUser.Value.ToString().Trim());
            ClearDisplay();
            if (hidScreenMode.Value.ToUpper() == "OFF" && hidSecurity.Value != "1")
                ToggleScreen("ON");
 
            if (hidInsConf.Value.ToUpper().Trim() == "TRUE")
            {
                //INSERT the new item record to create the database defaults
                //Read the record back and display to the screen
                #region INSERT Mode = TRUE
                _sessID = Session["UserName"].ToString().Trim() + Session["SessionID"].ToString().Trim();
                try
                {
                    dsItemMaint = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", txtSourceItem.Text.ToString().Trim()),
                                                                              new SqlParameter("@OrigID", ""),
                                                                              new SqlParameter("@SessID", _sessID),
                                                                              new SqlParameter("@Mode", "INSERT"));
                }
                catch (Exception ex)
                {
                    DisplayStatusMessage("INSERT Error executing stored procedure (" + IMProcName + ") - " + ex.Message, "fail");
                    //DisplayStatusMessage(ex.Message, "fail");
                    return;
                }

                #region ItemMaster Record (INS)
                if (dsItemMaint.Tables[0].Rows.Count > 0)
                {
                    dtIM = dsItemMaint.Tables[0].DefaultView.ToTable();
                    Session["dtIM"] = dtIM;
                    hidItemID.Value = dtIM.Rows[0]["ItemID"].ToString().Trim();
                    hidItemNo.Value = dtIM.Rows[0]["ItemNo"].ToString().Trim();
                    CheckLock("ItemMaster", hidItemID.Value.ToString().Trim(), "IMM");
                }
                else
                {
                    dtIM = null;
                    Session["dtIM"] = null;
                    hidItemID.Value = string.Empty;
                    hidItemNo.Value = string.Empty;
                    DisplayStatusMessage("INSERT Error executing stored procedure (" + IMProcName + ")", "fail");
                    return;
                }
                #endregion ItemMaster Record (INS)

                #region ItemUM Record (INS)
                dtUOM = dsItemMaint.Tables[1].DefaultView.ToTable();
                Session["dtUOM"] = dtUOM;
                if (dtUOM == null || dtUOM.Rows.Count <= 0)
                {
                    ItemUOMError("");
                }
                #endregion ItemUM Record (INS)

                #region ItemBranch Record (INS)
                dtBranch = dsItemMaint.Tables[2].DefaultView.ToTable();
                Session["dtBranch"] = dtBranch;
                if (dtBranch == null || dtBranch.Rows.Count <= 0)
                {
                    tblItemBrn.Visible = false;
                    DisplayStatusMessage("Item Branch detail data not found", "fail");
                }
                if (dtBranch != null) gvItemBrn_Bind();
                #endregion ItemUM Record (INS)

                #region ItemUPC Record (INS)
                if (dsItemMaint.Tables[3].Rows.Count > 0)
                {
                    dtUPC = dsItemMaint.Tables[3].DefaultView.ToTable();
                    Session["dtUPC"] = dtUPC;
                    hidUPCID.Value = dtUPC.Rows[0]["pItemUPCID"].ToString().Trim();
                    hidUPCCd.Value = dtUPC.Rows[0]["UPCCd"].ToString().Trim();
                }
                else
                {
                    dtUPC = null;
                    Session["dtUPC"] = null;
                    hidUPCID.Value = string.Empty;
                    hidUPCCd.Value = string.Empty;
                }
                #endregion ItemUPC Record (INS)

                #region CategoryDesc (from List)
                if (dsItemMaint.Tables[4].Rows.Count > 0)
                {
                    dtCat = dsItemMaint.Tables[4].DefaultView.ToTable();
                    Session["dtCat"] = dtCat;
                    hidCatNo.Value = dtCat.Rows[0]["Category"].ToString().Trim();
                    hidCatDesc.Value = dtCat.Rows[0]["CategoryDesc"].ToString().Trim();
                }
                else
                {
                    //This should never occur because the CatNo is validated up front
                    dtCat = null;
                    Session["dtCat"] = null;
                    hidCatNo.Value = string.Empty;
                    hidCatDesc.Value = string.Empty;
                }
                #endregion CategoryDesc (from List)

                txtSourceItem.Enabled = false;
                tblListParam.Visible = false;
                CopyVisible("false");
                DeleteVisible("false");
                DisplayItem();
                if (ddlCFV.SelectedIndex <= 0)
                    ddlCFV.SelectedValue = "I";
                if (ddlPCLBFT.SelectedIndex <= 0)
                    ddlPCLBFT.SelectedValue = "PC";

                if (dtUOM != null)
                {
                    hidDtlUOMMsg.Value = string.Empty;
                    lblDtlStatus.ForeColor = System.Drawing.Color.Green;
                    UOMDetails("ALL");  //We still want to execute UOMDetails even if there are no rows in dtUOM
                }

                if (!string.IsNullOrEmpty(txtNetWght.Text))
                {
                    lblGrossWght.Text = CalcGross();
                    PoundUOM();
                    DetailStatusMessage(hidDtlUOMMsg.Value, "");
                }

                DisplayStatusMessage("Database defaults created.", "success");
                #endregion INSERT Mode = TRUE
            }
            else
            {
                ClearDisplay();
                lblStatus.Text = string.Empty;
                pnlStatus.Update();
            }
            #endregion INSERT Mode
        }

        //Copy Item
        if (hidMaintMode.Value.ToUpper() == "COPY")
        {
            #region COPY Mode
            switch (hidInsConf.Value.ToUpper().Trim())
            {
                case "TRUE":
                    //INSERT the new (DEST) item record to create the database defaults
                    //Read the record back but do not display to the screen (keep data from SOURCE Item)
                    #region COPY (INSERT) Mode = TRUE - Destination item does not exist
                    _sessID = Session["UserName"].ToString().Trim() + Session["SessionID"].ToString().Trim();
                    try
                    {
                        dsItemMaint = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", txtDestItem.Text.ToString().Trim()),
                                                                                  new SqlParameter("@OrigID", hidItemID.Value.ToString().Trim()),
                                                                                  new SqlParameter("@SessID", _sessID),
                                                                                  new SqlParameter("@Mode", "COPY"));
                    }
                    catch (Exception ex)
                    {
                        DisplayStatusMessage("COPY (INSERT) Error executing stored procedure (" + IMProcName + ") - " + ex.Message, "fail");
                        //DisplayStatusMessage(ex.Message, "fail");
                        return;
                    }

                    #region ItemMaster Record (COPY)
                    if (dsItemMaint.Tables[0].Rows.Count > 0)
                    {
                        dtIM = dsItemMaint.Tables[0].DefaultView.ToTable();
                        Session["dtIM"] = dtIM;
                        hidItemID.Value = dtIM.Rows[0]["ItemID"].ToString().Trim();
                        hidItemNo.Value = dtIM.Rows[0]["ItemNo"].ToString().Trim();
                        CheckLock("ItemMaster", hidItemID.Value.ToString().Trim(), "IMM");
                    }
                    else
                    {
                        dtIM = null;
                        Session["dtIM"] = null;
                        hidItemID.Value = string.Empty;
                        hidItemNo.Value = string.Empty;
                        DisplayStatusMessage("COPY (INSERT) Error executing stored procedure (" + IMProcName + ")", "fail");
                        return;
                    }
                    #endregion ItemMaster Record (COPY)

                    ToggleScreen("ON");
                    CopyVisible("false");
                    DeleteVisible("false");
                    txtDestItem.Enabled = false;

                    #region ItemUM Record (COPY)
                    if (dsItemMaint.Tables[1].Rows.Count > 0)
                    {
                        dtUOM = dsItemMaint.Tables[1].DefaultView.ToTable();
                        gvItemUOM_Bind();
                        Session["dtUOM"] = dtUOM;
                    }
                    else
                    {
                        ItemUOMError("");
                    }
                    #endregion ItemUM Record (COPY)

                    #region ItemBranch Record (COPY)
                    if (dsItemMaint.Tables[2].Rows.Count > 0)
                    {
                        dtBranch = dsItemMaint.Tables[2].DefaultView.ToTable();
                        gvItemBrn_Bind();
                        Session["dtBranch"] = dtBranch;
                    }
                    else
                    {
                        tblItemBrn.Visible = false;
                        DisplayStatusMessage("Item Branch detail data not found", "fail");
                    }
                    #endregion ItemUM Record (COPY)

                    #region ItemUPC Record (COPY)
                    if (dsItemMaint.Tables[3].Rows.Count > 0)
                    {
                        dtUPC = dsItemMaint.Tables[3].DefaultView.ToTable();
                        Session["dtUPC"] = dtUPC;
                        hidUPCID.Value = dtUPC.Rows[0]["pItemUPCID"].ToString().Trim();
                        hidUPCCd.Value = dtUPC.Rows[0]["UPCCd"].ToString().Trim();
                    }
                    else
                    {
                        dtUPC = null;
                        Session["dtUPC"] = null;
                        hidUPCID.Value = string.Empty;
                        hidUPCCd.Value = string.Empty;
                    }
                    #endregion ItemUPC Record (COPY)

                    #region Check if CatNo has changed
                    string sourceCat = txtSourceItem.Text.ToString().Substring(0, 5).Trim();
                    string sourceDesc = hidCatDesc.Value.ToString().Trim();
                    string destCat = string.Empty;
                    string destDesc = string.Empty;

                    if (dsItemMaint.Tables[4].Rows.Count > 0)
                    {
                        dtCat = dsItemMaint.Tables[4].DefaultView.ToTable();
                        Session["dtCat"] = dtCat;
                        hidCatNo.Value = dtCat.Rows[0]["Category"].ToString().Trim();
                        hidCatDesc.Value = dtCat.Rows[0]["CategoryDesc"].ToString().Trim();
                    }
                    else
                    {
                        //This should never occur because the CatNo is validated up front
                        dtCat = null;
                        Session["dtCat"] = null;
                        hidCatNo.Value = string.Empty;
                        hidCatDesc.Value = string.Empty;
                    }

                    destCat = txtDestItem.Text.ToString().Substring(0, 5).Trim();
                    destDesc = hidCatDesc.Value.ToString().Trim();

                    if (sourceCat != destCat)
                    {
                        txtCat.Text = destCat;
                        txtCatDesc.Text = destDesc;
                    }
                    #endregion Check if CatNo has changed

                    #region Check if SizeNo has changed
                    string sourceSize = txtSourceItem.Text.ToString().Substring(6, 4).Trim();
                    string destSize = txtDestItem.Text.ToString().Substring(6, 4).Trim();
                    if (sourceSize != destSize)
                    {
                        txtSize.Text = destSize;
                        //Bruce wants to bring the size over even when they are not equal
                        //txtSizeDesc.Text = string.Empty;
                    }
                    #endregion Check if SizeNo has changed

                    #region Clear screen data that does not move from source item
                    txtVar.Text = txtDestItem.Text.ToString().Substring(11, 3).Trim();
                    lblItemNo.Text = txtDestItem.Text.ToString().Trim();
                    txtItemDesc.Text = string.Empty;
                    txtLblUPCCd.Text = string.Empty;
                    txtParent.Text = string.Empty;
                    lblBOMInd.Text = string.Empty;
                    //ddlCFV.SelectedIndex = -1;
                    ddlCFV.SelectedValue = "I";
                    #endregion Clear screen data that does not move from source item

                    DisplayStatusMessage("Copy from item " + txtSourceItem.Text.ToString().Trim() + " to " + txtDestItem.Text.ToString().Trim(), "success");
                    #endregion COPY (INSERT) Mode = TRUE - Destination item does not exist
                    break;
                case "DUPREC":
                    //COPY (INSERT) Mode = DUPREC - Destination item already exists
                    smItemMaint.SetFocus(txtDestItem);
                    DisplayStatusMessage("'To Item No' already exists - PLEASE RE-ENTER", "fail");
                    return;
                    break;
                case "NOCAT":
                    //COPY (INSERT) Mode = NOCAT - Category not on file
                    smItemMaint.SetFocus(txtDestItem);
                    DisplayStatusMessage("'To Item No' category does not exist - PLEASE RE-ENTER", "fail");
                    return;
                    break;
                default:
                    //Unknown error
                    hidMaintMode.Value = "ERROR";
                    break;
            }
            #endregion COPY Mode
        }
        #endregion Process the specific Maintenance Mode [hidMaintMode]

        //Stored Procedure Error
        if (hidMaintMode.Value.ToUpper() == "ERROR")
        {
            DisplayStatusMessage("QUERY Error executing stored procedure (" + IMProcName + ")" , "fail");
            return;
        }

        smItemMaint.SetFocus(txtSourceItem);
        UpdatePanels();
    }
    #endregion Find & Validate the Item Data

    //----------------------------------------------------------------------------------------------------//
    #region Format & Display the Data
    protected void DisplayItem()
    {
        txtCat.Text = dtIM.Rows[0]["CatNo"].ToString().Trim();
        txtSize.Text = dtIM.Rows[0]["SizeNo"].ToString().Trim();
        txtVar.Text = dtIM.Rows[0]["VarNo"].ToString().Trim();

        lblItemNo.Text = dtIM.Rows[0]["ItemNo"].ToString().Trim();
        lblItemNo.ToolTip = "EntryID: " + dtIM.Rows[0]["EntryID"].ToString().Trim() + "\r\n";
        try
        {
            lblItemNo.ToolTip += "EntryDt: " + Convert.ToDateTime(dtIM.Rows[0]["EntryDt"].ToString().Trim()).ToShortDateString() + "\r\n";
        }
        catch
        {
            lblItemNo.ToolTip += "EntryDt: \r\n";
        }
        lblItemNo.ToolTip += "ChangeID: " + dtIM.Rows[0]["ChangeID"].ToString().Trim() + "\r\n";
        try
        {
            lblItemNo.ToolTip += "ChangeDt: " + Convert.ToDateTime(dtIM.Rows[0]["ChangeDt"].ToString().Trim()).ToShortDateString();
        }
        catch
        {
            lblItemNo.ToolTip += "ChangeDt: ";
        }

        txtLength.Text = dtIM.Rows[0]["LengthDesc"].ToString().Trim();
        txtDiameter.Text = dtIM.Rows[0]["DiameterDesc"].ToString().Trim();

        if (hidMaintMode.Value.ToString().ToUpper() == "EDIT")
            txtCatDesc.Text = dtIM.Rows[0]["CatDesc"].ToString().Trim();
        else
            txtCatDesc.Text = hidCatDesc.Value.ToString().Trim();

        txtSizeDesc.Text = dtIM.Rows[0]["SizeDesc"].ToString().Trim();

        try
        {
            ddlPlating.SelectedValue = dtIM.Rows[0]["Plating"].ToString().Trim();
        }
        catch
        {
            ddlPlating.SelectedIndex = -1;
        }

        txtItemDesc.Text = dtIM.Rows[0]["ItemDesc"].ToString().Trim();
        txtLblUPCCd.Text = dtIM.Rows[0]["UPCCd"].ToString().Trim();
        hidUPCCd.Value = txtLblUPCCd.Text.ToString().Trim();
        txtAltDesc.Text = dtIM.Rows[0]["AltDesc"].ToString().Trim();
        txtAltDesc2.Text = dtIM.Rows[0]["AltDesc2"].ToString().Trim();
        txtAltDesc3.Text = dtIM.Rows[0]["AltDesc3"].ToString().Trim();
        txtAltSize.Text = dtIM.Rows[0]["AltSize"].ToString().Trim();
        txtCustNo.Text = dtIM.Rows[0]["CustNo"].ToString().Trim();
        txtRoutingNo.Text = dtIM.Rows[0]["RoutingNo"].ToString().Trim();
        txtParent.Text = dtIM.Rows[0]["ParentProdNo"].ToString().Trim();
        lblBOMInd.Text = dtIM.Rows[0]["BOMInd"].ToString().Trim();

        try
        {
            ddlPriceGroup.SelectedValue = dtIM.Rows[0]["ItemPriceGroup"].ToString().Trim();
        }
        catch
        {
            ddlPriceGroup.SelectedIndex = -1;
        }

        try
        {
            ddlCFV.SelectedValue = dtIM.Rows[0]["CorpFixedVelocity"].ToString().Trim();
        }
        catch
        {
            ddlCFV.SelectedIndex = -1;
        }

        txtLblPPICd.Text = dtIM.Rows[0]["PPICode"].ToString().Trim();
        txtLblHarmTaxCd.Text = dtIM.Rows[0]["HarmonizingCd"].ToString().Trim();

        if (dtIM.Rows[0]["WebEnabledInd"].ToString().Trim() == "1")
            chkWebEnabled.Checked = true;
        else
            chkWebEnabled.Checked = false;

        if (dtIM.Rows[0]["CertRequiredInd"].ToString().Trim() == "1")
            chkCert.Checked = true;
        else
            chkCert.Checked = false;

        if (dtIM.Rows[0]["HazMatInd"].ToString().Trim() == "1")
            chkHazMat.Checked = true;
        else
            chkHazMat.Checked = false;

        if (dtIM.Rows[0]["FQAInd"].ToString().Trim() == "1")
            chkFQA.Checked = true;
        else
            chkFQA.Checked = false;

        if (dtIM.Rows[0]["PtPartner"].ToString().Trim() == "1")
            chkPtPartner.Checked = true;
        else
            chkPtPartner.Checked = false;

        txtListPrice.Text = String.Format("{0:c}", dtIM.Rows[0]["ListPrice"]);
        txt100Wght.Text = String.Format("{0:0.000}", dtIM.Rows[0]["HundredWght"]);
        lblGrossWght.Text = String.Format("{0:0.000}", dtIM.Rows[0]["GrossWght"]);
        txtNetWght.Text = String.Format("{0:0.000}", dtIM.Rows[0]["NetWght"]);
        //lblDensity.Text = String.Format("{0:0.00000}", Convert.ToDecimal(dtIM.Rows[0]["GrossWght"]) - Convert.ToDecimal(dtIM.Rows[0]["NetWght"]));

        try
        {
            ddlPCLBFT.SelectedValue = dtIM.Rows[0]["PCLBFTInd"].ToString().Trim();
        }
        catch
        {
            ddlPCLBFT.SelectedIndex = -1;
        }

        if (ddlPCLBFT.SelectedValue.ToString().ToUpper().Trim() == "LB")
        {
            txtDtlBaseQty.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
            txtDtlBaseQty.Attributes.Add("readonly", "readonly");
            txtDtlBaseQty.CssClass = "TextBoxLabel txtRight";
        }
        else
        {
            txtDtlBaseQty.BackColor = System.Drawing.Color.White;
            txtDtlBaseQty.Attributes.Remove("readonly");
            txtDtlBaseQty.CssClass = "FormCtrl2 txtRight";
        }

        try
        {
            ddlBaseUOM.SelectedValue = dtIM.Rows[0]["BaseUOM"].ToString().Trim();
        }
        catch
        {
            ddlBaseUOM.SelectedIndex = -1;
        }

        try
        {
            ddlSellUOM.SelectedValue = dtIM.Rows[0]["SellUOM"].ToString().Trim();
        }
        catch
        {
            ddlSellUOM.SelectedIndex = -1;
        }

        try
        {
            ddlPurchUOM.SelectedValue = dtIM.Rows[0]["PurchUOM"].ToString().Trim();
        }
        catch
        {
            ddlPurchUOM.SelectedIndex = -1;
        }

        try
        {
            ddlSuperUOM.SelectedValue = dtIM.Rows[0]["SuperUOM"].ToString().Trim();
        }
        catch
        {
            ddlSuperUOM.SelectedIndex = -1;
        }

        lblUnitsPerBaseLbl.Text = UnitsPerBaseLbl();
        lblUnitsPerBase.Text = String.Format("{0:0.0#####}", dtIM.Rows[0]["UnitsPerBase"]);
        lblUnitsPerSELbl.Text = UnitsPerSELbl();
        lblUnitsPerSE.Text = String.Format("{0:0.0#####}", dtIM.Rows[0]["UnitsPerSE"]);
        txtSuperUOMQty.Text = String.Format("{0:0.0#####}", dtIM.Rows[0]["SuperUOMQty"]);
        lblDensity.Text = Convert.ToString(Convert.ToDecimal(dtIM.Rows[0]["GrossWght"]) - Convert.ToDecimal(dtIM.Rows[0]["NetWght"]));
        ddlDetails.Enabled = true;
        ddlDetails.SelectedValue = "ItemUM";
        SwitchDetails(ddlDetails.SelectedValue.ToString().Trim());
        btnCancel.Visible = true;
    }

    protected void BuildItemDesc()
    {
        string catDesc = txtCatDesc.Text.ToString().Trim();
        string sizeDesc = txtSizeDesc.Text.ToString().Trim();
        string platDesc = ddlPlating.SelectedValue.ToString().Trim();

        if (txtCatDesc.Text.ToString().Trim().Length > 26)
            catDesc = txtCatDesc.Text.ToString().Substring(0, 26).Trim();
        else
            catDesc = txtCatDesc.Text.ToString().Trim();

        if (sizeDesc.ToString().Length > 20)
            sizeDesc = txtSizeDesc.Text.ToString().Substring(0, 20).Trim();
        else
            sizeDesc = txtSizeDesc.Text.ToString().Trim();

        if (platDesc.ToString().Length > 4)
            platDesc = ddlPlating.SelectedValue.ToString().Substring(0, 4).Trim();
        else
            platDesc = ddlPlating.SelectedValue.ToString().Trim();

        txtItemDesc.Text = sizeDesc.ToString().PadRight(20) + catDesc.ToString().PadRight(26) + platDesc;

        pnlBody.Update();
    }
    #endregion Format & Display the Data

    //----------------------------------------------------------------------------------------------------//
    #region Item Details

    #region ddlDetails
    protected void ddlDetails_SelectedIndexChanged(object sender, EventArgs e)
    {
        SwitchDetails(ddlDetails.SelectedValue.ToString().Trim());
    }

    protected void SwitchDetails(string _table)
    {
        tblItemUOM.Visible = false;
        tblItemBrn.Visible = false;
        tblBrnEdit.Visible = false;
        tblItemNotes.Visible = false;
        divDtlStatus.Visible = false;
        lblDtlStatus.ForeColor = System.Drawing.Color.Green;

        if (_table != ddlDetails.SelectedValue.ToString().Trim())
            ddlDetails.SelectedValue = _table;

        switch (_table)
        {
            case "ItemUM":
                tblItemUOM.Visible = true;
                divDtlStatus.Visible = true;
                DetailStatusMessage(hidDtlUOMMsg.Value.ToString().Trim(), "");
                break;
            case "ItemBranch":
                tblItemBrn.Visible = true;
                divDtlStatus.Visible = true;
                DetailStatusMessage(hidDtlBrnMsg.Value.ToString().Trim(), "");
                break;
            case "ItemNotes":
                tblItemNotes.Visible = true;
                divDtlStatus.Visible = true;
                DetailStatusMessage(hidDtlNotesMsg.Value.ToString().Trim(), "");
                break;
        }
        pnlItemDetails.Update();
    }
    #endregion ddlDetails

    #region ItemUM Details [tblItemUOM]

    #region UOM Details
    private void UOMDetails(string _processCode)
    {
        ddlDetails.SelectedValue = "ItemUM";
        SwitchDetails(ddlDetails.SelectedValue.ToString().Trim());

        //hidDtlUOMMsg.Value = string.Empty;
        //lblDtlStatus.ForeColor = System.Drawing.Color.Green;

        gvItemUOM_Bind();

        if (hidScreenMode.Value.ToUpper() != "OFF" && hidSecurity.Value != "1")
        {
            try
            {
                //Check the selected PC / LB / FT record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "PCLBFT")
                {
                    #region Edit PC / LB / FT
                    lblUnitsPerBaseLbl.Text = UnitsPerBaseLbl();
                    lblUnitsPerSELbl.Text = UnitsPerSELbl();
                    if (!string.IsNullOrEmpty(ddlPCLBFT.SelectedValue.ToString().Trim()))
                    {
                        //Bind the editable PC/LB/FT UOM record
                        string expr = "UOM = '" + ddlPCLBFT.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UOMUpdStatus >= 0";
                        }
                        DataRow[] dr = dtUOM.Select(expr);

                        if (dr.Length > 0)
                        {
                            lblItemUOM.Text = dr[0]["UOM"].ToString().Trim();
                            txtDtlBaseQty.Text = String.Format("{0:0.0#####}", dr[0]["AltQty"]);
                            lblUOMQtyPer.Text = String.Format("{0:0.0#####}", dr[0]["QtyPer"]);
                            tblUOMEdit.Visible = true;
                            lblUnitsPerBase.Text = txtDtlBaseQty.Text;
                            lblUnitsPerSE.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text) * Convert.ToDecimal(lblUnitsPerBase.Text));
                            //txtSuperUOMQty.Text = UpdateSuperUOM(_processCode.ToUpper(), Convert.ToDecimal(lblUnitsPerSE.Text), Convert.ToDecimal(dr[0]["AltQty"]));
                            DisplayStatusMessage("", "success");
                        }
                        else
                        {
                            //INSERT the missing ItemUM record into the DataTable
                            if (hidScreenMode.Value.ToUpper() != "OFF" && hidSecurity.Value != "1")
                            {
                                InsertItemUM(ddlPCLBFT.SelectedValue.ToString().Trim(), 1, 0);
                                UOMDetails("PCLBFT");
                                hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'" + ddlPCLBFT.SelectedValue.ToString().Trim() + "' created");
                                if (_processCode.ToUpper() != "ALL")
                                {
                                    DetailStatusMessage(hidDtlUOMMsg.Value, "");
                                    return;
                                }
                            }
                        }
                    }
                    else
                    {
                        //No PC/LB/FT Selected
                        tblUOMEdit.Visible = false;
                        lblDtlStatus.ForeColor = System.Drawing.Color.Red;
                        hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "No PC/LB/FT Selected");
                    }
                    #endregion Edit PC / LB / FT
                }

                //Check the selected Base UOM record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "BASE")
                {
                    #region Base UOM
                    lblUnitsPerBaseLbl.Text = UnitsPerBaseLbl();
                    if (!string.IsNullOrEmpty(ddlBaseUOM.SelectedValue.ToString().Trim()))
                    {
                        //Bind the selected Base UOM record
                        string expr = "UOM = '" + ddlBaseUOM.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UOMUpdStatus >= 0";
                        }
                        DataRow[] dr = dtUOM.Select(expr);

                        if (dr.Length > 0)
                        {
                            //Base UOM found
                            hidBaseQtyPer.Value = dr[0]["QtyPer"].ToString().Trim();
                            if (_processCode.ToUpper() != "ALL")
                            {
                                hidBaseQtyPer.Value = "1";
                                UpdateItemUM(ddlBaseUOM.SelectedValue.ToString().Trim(), 0, 1);
                                gvItemUOM_Bind();
                            }
                        }
                        else
                        {
                            //INSERT the missing ItemUM record into the DataTable
                            InsertItemUM(ddlBaseUOM.SelectedValue.ToString().Trim(), 0, 1);
                            UOMDetails("BASE");
                            hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'" + ddlBaseUOM.SelectedValue.ToString().Trim() + "' created");
                            if (_processCode.ToUpper() != "ALL")
                            {
                                DetailStatusMessage(hidDtlUOMMsg.Value, "");
                                return;
                            }
                        }
                    }
                    else
                    {
                        hidBaseQtyPer.Value = "1";
                        lblDtlStatus.ForeColor = System.Drawing.Color.Red;
                        hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "No Base UOM Selected");
                    }
                    #endregion Base UOM
                }

                //Check the selected Super UOM record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "SUPER")
                {
                    #region Super UOM
                    lblUnitsPerSELbl.Text = UnitsPerSELbl();
                    if (!string.IsNullOrEmpty(ddlSuperUOM.SelectedValue.ToString().Trim()))
                    {
                        //Bind the selected Super UOM record
                        string expr = "UOM = '" + ddlSuperUOM.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UOMUpdStatus >= 0";
                        }
                        DataRow[] dr = dtUOM.Select(expr);

                        if (dr.Length > 0)
                        {
                            //Super UOM found
                            if (_processCode.ToUpper() != "ALL")
                            {
                                txtSuperUOMQty.Text = String.Format("{0:0.0#####}", dr[0]["QtyPer"]);
                                lblUnitsPerSE.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text) * Convert.ToDecimal(lblUnitsPerBase.Text));
                            }
                        }
                        else
                        {
                            //INSERT the missing ItemUM record into the DataTable
                            InsertItemUM(ddlSuperUOM.SelectedValue.ToString().Trim(), 0, Convert.ToDecimal(txtSuperUOMQty.Text));
                            UOMDetails("SUPER");
                            hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'" + ddlSuperUOM.SelectedValue.ToString().Trim() + "' created");
                            if (_processCode.ToUpper() != "ALL")
                            {
                                DetailStatusMessage(hidDtlUOMMsg.Value, "");
                                return;
                            }
                        }
                    }
                    else
                    {
                        lblDtlStatus.ForeColor = System.Drawing.Color.Red;
                        hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "No Super UOM Selected");
                    }
                    #endregion Super UOM
                }

                //Check the selected Sell UOM record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "SELL")
                {
                    #region Sell UOM
                    if (!string.IsNullOrEmpty(ddlSellUOM.SelectedValue.ToString().Trim()))
                    {
                        //Bind the selected Sell UOM record
                        string expr = "UOM = '" + ddlSellUOM.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UOMUpdStatus >= 0";
                        }
                        DataRow[] dr = dtUOM.Select(expr);

                        if (dr.Length <= 0)
                        {
                            //INSERT the missing ItemUM record into the DataTable
                            InsertItemUM(ddlSellUOM.SelectedValue.ToString().Trim(), 0, 1);
                            UOMDetails("SELL");
                            hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'" + ddlSellUOM.SelectedValue.ToString().Trim() + "' created");
                            if (_processCode.ToUpper() != "ALL")
                            {
                                DetailStatusMessage(hidDtlUOMMsg.Value, "");
                                return;
                            }
                        }
                    }
                    #endregion Sell UOM
                }

                //Check the selected Purch UOM record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "PURCH")
                {
                    #region Purch UOM
                    if (!string.IsNullOrEmpty(ddlPurchUOM.SelectedValue.ToString().Trim()))
                    {
                        //Bind the selected Purch UOM record
                        string expr = "UOM = '" + ddlPurchUOM.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UOMUpdStatus >= 0";
                        }
                        DataRow[] dr = dtUOM.Select(expr);

                        if (dr.Length <= 0)
                        {
                            //INSERT the missing ItemUM record into the DataTable
                            InsertItemUM(ddlPurchUOM.SelectedValue.ToString().Trim(), 0, 1);
                            UOMDetails("PURCH");
                            hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'" + ddlPurchUOM.SelectedValue.ToString().Trim() + "' created");
                            if (_processCode.ToUpper() != "ALL")
                            {
                                DetailStatusMessage(hidDtlUOMMsg.Value, "");
                                return;
                            }
                        }
                    }
                    #endregion Purch UOM
                }
            }
            catch (Exception ex)
            {
                ItemUOMError(ex.Message);
            }
        }

        lblBaseQty.Text = hidBaseQtyPer.Value.ToString().Trim();

        DetailStatusMessage(hidDtlUOMMsg.Value, "");
        pnlItemDetails.Update();
    }
    #endregion UOM Details

    #region GridView ItemUM
    protected void gvItemUOM_Bind()
    {
        lblPCQty.Text = string.Empty;
        try
        {
            if (hidMaintMode.Value.ToUpper() != "DEL")
            {
                //Filter out UOM records with DeleteDt set
                dtUOM.DefaultView.RowFilter = "UOMUpdStatus >= 0";
                gvItemUOM.DataSource = dtUOM.DefaultView.ToTable();
            }
            else
            {
                gvItemUOM.DataSource = dtUOM;
            }

            hidPieceQty.Value = "1";
            gvItemUOM.DataBind();
            //tblItemUOM.Visible = true;
            //divDtlStatus.Visible = true;
            //DetailStatusMessage("Item UOM detail data", "success");
        }
        catch (Exception ex)
        {
            ItemUOMError(ex.Message);
        }
    }

    protected void gvItemUOM_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (_devDisp.ToUpper() == "YES")
        {
            e.Row.Cells[4].Visible = true;
            e.Row.Cells[5].Visible = true;
            e.Row.Cells[6].Visible = true;
        }
        else
        {
            e.Row.Cells[4].Visible = false;
            e.Row.Cells[5].Visible = false;
            e.Row.Cells[6].Visible = false;
        }
        
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LinkButton lnkDelete = e.Row.FindControl("lnkDelete") as LinkButton;

            if (e.Row.Cells[1].Text.ToString().Trim() == ddlPCLBFT.SelectedValue.ToString().Trim() ||
                e.Row.Cells[1].Text.ToString().Trim() == ddlBaseUOM.SelectedValue.ToString().Trim() ||
                e.Row.Cells[1].Text.ToString().Trim() == ddlSellUOM.SelectedValue.ToString().Trim() ||
                e.Row.Cells[1].Text.ToString().Trim() == ddlPurchUOM.SelectedValue.ToString().Trim() ||
                e.Row.Cells[1].Text.ToString().Trim() == ddlSuperUOM.SelectedValue.ToString().Trim())
                {
                    lnkDelete.Text = "";
                }

            if (e.Row.Cells[1].Text.ToString().Trim() == "PC" || e.Row.Cells[1].Text.ToString().ToUpper().Trim() == "LB")
            {
                if (e.Row.Cells[1].Text.ToString().Trim() == "PC")
                {
                    hidPieceQty.Value = e.Row.Cells[2].Text.ToString().Trim();
                    lblPCQty.Text = hidPieceQty.Value;
                }
                lnkDelete.Text = "";
            }
        }
    }

    protected void gvItemUOM_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString().ToUpper().Trim() == "DEL" && hidDelUOM.Value == "true")
        {
            dtUOM = (DataTable)Session["dtUOM"];
            if (dtUOM != null && dtUOM.Rows.Count > 0)
            {
                string _UOM = e.CommandArgument.ToString().Trim();
                foreach (DataRow dr in dtUOM.Rows)
                {
                    if (_UOM == dr["UOM"].ToString().Trim())
                    {
                        dr["UOMUpdStatus"] = -1; //-1=DELETE ItemUM
                    }
                }
            }
            gvItemUOM_Bind();
            Session["dtUOM"] = dtUOM;
        }
    }
    #endregion GridView ItemUM

    #region Update dtUOM data
    protected void InsertItemUM(string _uom, decimal _altQty, decimal _qtyPer)
    {
        //Find the Divisor for the new UOM
        decimal _divisor = 0;
        dtUOMDivisor = (DataTable)Session["dtUOMDivisor"];
        if (dtUOMDivisor != null && dtUOMDivisor.Rows.Count > 0)
        {
            foreach (DataRow dr in dtUOMDivisor.Rows)
            {
                if (dr["UOM"].ToString().Trim() == _uom.ToString().Trim())
                {
                    _divisor = Convert.ToDecimal(dr["Divisor"]);
                }
            }
        }
        
        //Add the missing ItemUM record into dtUOM
        DataRow drNewUOM;
        drNewUOM = dtUOM.NewRow();
        drNewUOM["ItemID"] = hidItemID.Value;
        drNewUOM["UOM"] = _uom;

        if (_uom.ToString().Trim() == "LB")
        {
            drNewUOM["AltQty"] = Convert.ToDecimal(txtNetWght.Text);
            drNewUOM["QtyPer"] = 1 / Convert.ToDecimal(txtNetWght.Text);
        }
        else
        {
            if (_divisor != 0)
            {
                drNewUOM["AltQty"] = Convert.ToDecimal(lblUnitsPerBase.Text) / _divisor;
                drNewUOM["QtyPer"] = _divisor * Convert.ToDecimal(lblUOMQtyPer.Text);
            }
            else
            {
                drNewUOM["AltQty"] = _altQty;
                drNewUOM["QtyPer"] = _qtyPer;
            }
        }

        drNewUOM["UOMDivisor"] = _divisor;
        drNewUOM["UOMUpdStatus"] = 2; //2=INSERT new ItemUM

        if (_uom == ddlBaseUOM.SelectedValue.ToString().Trim())
        {
            hidBaseQtyPer.Value = drNewUOM["QtyPer"].ToString().Trim();
        }

        dtUOM.Rows.Add(drNewUOM);
    }

    protected void UpdateItemUM(string _uom, decimal _altQty, decimal _qtyPer)
    {
        //Update the existing record in dtUOM
        foreach (DataRow dr in dtUOM.Rows)
        {
            if (dr["UOM"].ToString().Trim() == _uom)
            {
                if (_uom.ToString().Trim() == "LB")
                {
                    dr["AltQty"] = Convert.ToDecimal(txtNetWght.Text);
                    dr["QtyPer"] = 1 / Convert.ToDecimal(txtNetWght.Text);
                }
                else
                {
                    dr["AltQty"] = _altQty;
                    dr["QtyPer"] = _qtyPer;
                }
                
                if (Convert.ToInt32(dr["UOMUpdStatus"]) == 0)
                    dr["UOMUpdStatus"] = 1; //1=UPDATE ItemUM

                if (_uom == ddlBaseUOM.SelectedValue.ToString().Trim())
                {
                    hidBaseQtyPer.Value = dr["QtyPer"].ToString().Trim();
                }
            }
        }
    }

    protected string UpdateSuperUOM(string _processCode, decimal _UnitsPerSE, decimal _baseQty)
    {
        string _superUOM = "0.0";

        if (_baseQty != 0)
        {
            _superUOM = string.Format("{0:0.0#####}", _UnitsPerSE / _baseQty);
        }

        if (_processCode.ToUpper() == "SUPER")
        {
            //Update the existing SuperUMQty in dtUOM
            foreach (DataRow dr in dtUOM.Rows)
            {
                if (dr["UOM"].ToString().Trim() == ddlSuperUOM.SelectedValue.ToString().Trim())
                {
                    dr["QtyPer"] = Convert.ToDecimal(_superUOM);
                    if (Convert.ToInt32(dr["UOMUpdStatus"]) == 0)
                        dr["UOMUpdStatus"] = 1; //1=UPDATE ItemUM

                    if (dr["UOM"].ToString().Trim() == ddlBaseUOM.SelectedValue.ToString().Trim())
                    {
                        hidBaseQtyPer.Value = dr["QtyPer"].ToString().Trim();
                    }
                }
            }
        }
        return _superUOM;
    }
    #endregion Update dtUOM data

    #region UOMErrors
    protected string BuildDetailMessage(string _uomMsg, string _message)
    {

        if (_uomMsg.IndexOf(_message) < 0)
        {
            //Did not find the string
            if (!string.IsNullOrEmpty(_uomMsg))
            {
                _uomMsg += " | ";
            }
            _uomMsg += _message;
        }
        return _uomMsg;
    }

    protected void ItemUOMError(string _exception)
    {
        //dtUOM = null;
        tblUOMEdit.Visible = false;
        tblItemUOM.Visible = false;
        divDtlStatus.Visible = false;
        DisplayStatusMessage("Item UOM detail data not found " + _exception, "fail");
    }
    #endregion UOMErrors
    
    #endregion ItemUM Details [tblItemUOM]

    #region ItemBranch Details [tblItemBrn]

    #region GridView ItemBranch
    protected void gvItemBrn_Bind()
    {
        if (dtBranch != null)
        {
            gvItemBrn.DataSource = dtBranch;
            gvItemBrn.DataBind();
        }
    }
    
    protected void gvItemBrn_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (_devDisp.ToUpper() == "YES")
        {
            e.Row.Cells[7].Visible = true;
            e.Row.Cells[8].Visible = true;
            e.Row.Cells[9].Visible = true;
        }
        else
        {
            e.Row.Cells[7].Visible = false;
            e.Row.Cells[8].Visible = false;
            e.Row.Cells[9].Visible = false;
        }
        
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LinkButton _lnkEdit = e.Row.FindControl("lnkEdit") as LinkButton;
            _lnkEdit.OnClientClick = "";

            if (_lnkEdit.CommandName.ToString().ToUpper().Trim() == "INS")
            {
                _lnkEdit.OnClientClick = "javascript:if(confirm('Are you sure you want to INSERT this ItemBranch record?')==true){document.getElementById('hidInsBrn').value = 'true';} else {document.getElementById('hidInsBrn').value = 'false';}";
                e.Row.Cells[2].Style.Value = "font-style:italic; font-weight:normal; color:gray;";
                e.Row.Cells[3].Text = "";
                e.Row.Cells[4].Text = "";
                e.Row.Cells[5].Text = "";
                e.Row.Cells[6].Text = "";
            }
            else
            {
                e.Row.Cells[2].Style.Value = "font-style:normal; font-weight:500; color:black;";
            }
        }
    }

    protected void gvItemBrn_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        LinkButton _lnkBtn = (LinkButton)e.CommandSource;
        GridViewRow _gvRow = (GridViewRow)_lnkBtn.NamingContainer;
        int _index = _gvRow.RowIndex;
        string _brn = e.CommandArgument.ToString().Trim();
        tblBrnEdit.Visible = false;

        if (e.CommandName.ToString().ToUpper().Trim() == "INS" && hidInsBrn.Value == "true")
        {
            dtBranch = (DataTable)Session["dtBranch"];
            if (dtBranch != null && dtBranch.Rows.Count > 0)
            {
                foreach (DataRow dr in dtBranch.Rows)
                {
                    if (dr["Location"].ToString().Trim() == _brn)
                    {
                        dr["LocEdit"] = "Upd";
                        dr["LocStatus"] = dr["LocName"].ToString().Trim();
                        dr["StockInd"] = "No";
                        dr["SVC"] = "N";
                        dr["ROP"] = 0.0;
                        dr["Capacity"] = 0;
                        dr["BrnID"] = hidItemID.Value;
                        dr["BrnUpdStatus"] = 2; //2=INSERT ItemBranch
                    }
                }
            }
            Session["dtBranch"] = dtBranch;
            gvItemBrn_Bind();
        }

        if (e.CommandName.ToString().ToUpper().Trim() == "UPD")
        {
            lblItemBrn.Text = _brn;
            if (_gvRow.Cells[3].Text.ToString().ToUpper().Trim() == "YES")
                chkDtlStkInd.Checked = true;
            else
                chkDtlStkInd.Checked = false;
            ddlDtlSVC.SelectedValue = _gvRow.Cells[4].Text.ToString().Trim();
            txtDtlROP.Text = _gvRow.Cells[5].Text;
            txtDtlBinCap.Text = _gvRow.Cells[6].Text;
            tblBrnEdit.Visible = true;
        }
    }
    #endregion GridView ItemBranch

    #endregion ItemBranch Details [tblItemBrn]

    #endregion Item Details

    //----------------------------------------------------------------------------------------------------//
    #region Button & Change Events

    #region UPC Builder
    protected void btnPkgUPC_Click(object sender, ImageClickEventArgs e)
    {
        dtNewUPC = NewUPC("PKG");
        if (dtNewUPC != null && dtNewUPC.Rows.Count > 0)
        {
            txtLblUPCCd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
            txtLblUPCCd.Text = dtNewUPC.Rows[0]["UpcCd"].ToString().Trim();
            btnPkgUPC.Enabled = false;
            pnlBody.Update();
        }
        else
        {
            dtNewUPC = null;
            DisplayStatusMessage("PKG UPC Error", "fail");
        }
    }

    protected void btnBulkUPC_Click(object sender, ImageClickEventArgs e)
    {
        dtNewUPC = NewUPC("BULK");
        if (dtNewUPC != null && dtNewUPC.Rows.Count > 0)
        {
            txtLblUPCCd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
            txtLblUPCCd.Text = dtNewUPC.Rows[0]["UpcCd"].ToString().Trim();
            btnBulkUPC.Enabled = false;
            pnlBody.Update();
        }
        else
        {
            dtNewUPC = null;
            DisplayStatusMessage("BULK UPC Error", "fail");
        }
    }

    protected DataTable NewUPC(string upcType)
    {
        //DisplayStatusMessage(upcType.ToString().Trim() + " - " + lblItemNo.Text.ToString().Trim(), "success");
        try
        {
            dsNewUPC = SqlHelper.ExecuteDataset(cnERP, UPCProcName, new SqlParameter("@ItemNo", lblItemNo.Text.ToString().Trim()),
                                                                            new SqlParameter("@UPCCd", ""),
                                                                            new SqlParameter("@UPCType", upcType.ToString().Trim()),
                                                                            new SqlParameter("@Mode", "GETNEW"),
                                                                            new SqlParameter("@User", Session["UserName"].ToString().Trim()));
            return dsNewUPC.Tables[0].DefaultView.ToTable();
        }
        catch (Exception ex)
        {
            //DisplayStatusMessage(ex.Message, "fail");
            return null;
        }
    }
    #endregion UPC Builder

    #region Validate Customer
    protected void txtCustNo_TextChanged(object sender, EventArgs e)
    {
        DisplayStatusMessage("","success");
        
        string custNo = txtCustNo.Text;
        bool errorCtl = false;
        DataSet ds = null;

        bool textIsNumeric = true;
        try
        {
            int.Parse(custNo);
        }
        catch
        {
            textIsNumeric = false;
        }

        if (custNo != "" && !textIsNumeric)
        {
            //Open CustomerList form
            ScriptManager.RegisterClientScriptBlock(txtCustNo, txtCustNo.GetType(), "Customer", "CustLookup('" + Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(custNo)) + "');", true);
        }
        else
        {
            if (custNo != "")
            {
                #region [SQL] Validate The CustNo
                txtCustNo.Text = custNo.ToString().Trim().PadLeft(6, '0');

                strSQL = "SELECT CustNo, CustName " +
                         "FROM   CustomerMaster (NoLock) CM " +
                         "WHERE  CustNo = '" + txtCustNo.Text.ToString() + "'";
                try
                {
                    ds = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, strSQL);
                    cnERP.Close();
                }
                catch (Exception ex)
                {
                    errorCtl = true;
                    //DisplayStatusMessage(ex.Message, "fail");
                }

                if (ds == null || ds.Tables[0].DefaultView.ToTable().Rows.Count < 1 || errorCtl)
                {
                    //Bad Customer
                    DisplayStatusMessage("Customer Number " + txtCustNo.Text.ToString() + " not on file", "fail");
                    txtCustNo.Text = string.Empty;
                    smItemMaint.SetFocus(txtCustNo);
                }
                else
                {
                    //DisplayStatusMessage("Customer OK", "success");
                }
                #endregion
            }
        }
    }
    #endregion Validate Customer

    #region ItemUOM Events
    protected void txtDtlBaseQty_TextChanged(object sender, EventArgs e)
    {
        DisplayStatusMessage("", "success");
        txtDtlBaseQty.BackColor = System.Drawing.Color.White;
        //txtDtlBaseQty.CssClass = "FormCtrl2 txtRight";

        dtUOM = (DataTable)Session["dtUOM"];

        if (string.IsNullOrEmpty(txtDtlBaseQty.Text) || txtDtlBaseQty.Text == "0")
        {
            //txtDtlBaseQty.Text = "0.0";
            //lblUOMQtyPer.Text = "0.0";
            txtDtlBaseQty.Text = string.Empty;
            txtDtlBaseQty.BackColor = System.Drawing.Color.Yellow;
            DisplayStatusMessage("Base Qty can not be BLANK or ZERO", "fail");
            smItemMaint.SetFocus(txtDtlBaseQty);
            return;
        }
        else
        {
            txtDtlBaseQty.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtDtlBaseQty.Text));
            lblUOMQtyPer.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(hidBaseQtyPer.Value) / Convert.ToDecimal(txtDtlBaseQty.Text));
        }
        lblUnitsPerBase.Text = txtDtlBaseQty.Text;
        lblUnitsPerSE.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text) * Convert.ToDecimal(lblUnitsPerBase.Text));
        //txtSuperUOMQty.Text = UpdateSuperUOM("SUPER", Convert.ToDecimal(lblUnitsPerSE.Text), Convert.ToDecimal(txtDtlBaseQty.Text));

        RecalcUM();
        UpdateItemUM(lblItemUOM.Text.ToString().Trim(), Convert.ToDecimal(txtDtlBaseQty.Text), Convert.ToDecimal(lblUOMQtyPer.Text));
        gvItemUOM_Bind();
        Session["dtUOM"] = dtUOM;

        //Re-calc net & gross weight when the Base Qty changes
        txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtDtlBaseQty.Text) / 100 * Convert.ToDecimal(txt100Wght.Text));
        //txt100Wght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text) * 100 / Convert.ToDecimal(txtDtlBaseQty.Text));
        lblGrossWght.Text = CalcGross();
        PoundUOM();
        pnlBody.Update();
        DetailStatusMessage(hidDtlUOMMsg.Value, "");
    }

    #region UOM DropDowns
    protected void ddlPCLBFT_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidDtlUOMMsg.Value = string.Empty;
        lblDtlStatus.ForeColor = System.Drawing.Color.Green;

        lblUnitsPerBaseLbl.Text = UnitsPerBaseLbl();
        lblUnitsPerSELbl.Text = UnitsPerSELbl();

        if (ddlPCLBFT.SelectedValue.ToString().ToUpper().Trim() == "LB")
        {
            txtDtlBaseQty.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
            txtDtlBaseQty.Attributes.Add("readonly", "readonly");
            txtDtlBaseQty.CssClass = "TextBoxLabel txtRight";
        }
        else
        {
            txtDtlBaseQty.BackColor = System.Drawing.Color.White;
            txtDtlBaseQty.Attributes.Remove("readonly");
            txtDtlBaseQty.CssClass = "FormCtrl2 txtRight";
        }
        
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("PCLBFT");
        Session["dtUOM"] = dtUOM;
    }

    protected void ddlBaseUOM_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidDtlUOMMsg.Value = string.Empty;
        lblDtlStatus.ForeColor = System.Drawing.Color.Green;
        lblUnitsPerBaseLbl.Text = UnitsPerBaseLbl();
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("BASE");
        Session["dtUOM"] = dtUOM;
    }

    protected void ddlSellUOM_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidDtlUOMMsg.Value = string.Empty;
        lblDtlStatus.ForeColor = System.Drawing.Color.Green;
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("SELL");
        Session["dtUOM"] = dtUOM;
    }

    protected void ddlPurchUOM_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidDtlUOMMsg.Value = string.Empty;
        lblDtlStatus.ForeColor = System.Drawing.Color.Green;
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("PURCH");
        Session["dtUOM"] = dtUOM;
    }

    protected void ddlSuperUOM_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidDtlUOMMsg.Value = string.Empty;
        lblDtlStatus.ForeColor = System.Drawing.Color.Green;
        lblUnitsPerSELbl.Text = UnitsPerSELbl();
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("SUPER");
        Session["dtUOM"] = dtUOM;
    }
    #endregion UOM DropDowns

    protected void txtSuperUOMQty_TextChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtSuperUOMQty.Text))
            txtSuperUOMQty.Text = "0.0";

        dtUOM = (DataTable)Session["dtUOM"];
        txtSuperUOMQty.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text));
        lblUnitsPerSE.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text) * Convert.ToDecimal(lblUnitsPerBase.Text));

        //Update the existing SuperUMQty in dtUOM
        foreach (DataRow dr in dtUOM.Rows)
        {
            if (dr["UOM"].ToString().Trim() == ddlSuperUOM.SelectedValue.ToString().Trim())
            {
                dr["QtyPer"] = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text));
                if (Convert.ToInt32(dr["UOMUpdStatus"]) == 0)
                    dr["UOMUpdStatus"] = 1; //1=UPDATE ItemUM

                if (dr["UOM"].ToString().Trim() == ddlBaseUOM.SelectedValue.ToString().Trim())
                {
                    hidBaseQtyPer.Value = dr["QtyPer"].ToString().Trim();
                }
            }
        }
        gvItemUOM_Bind();
        Session["dtUOM"] = dtUOM;
        pnlBody.Update();
    }

    #region UM Calcs & Updates
    protected void PoundUOM()
    {
        dtUOM = (DataTable)Session["dtUOM"];
        string expr = "UOM = 'LB'";
        //Filter out UOM records with DeleteDt set
        expr += " AND UOMUpdStatus >= 0";

        DataRow[] dr = dtUOM.Select(expr);

        if (dr.Length > 0)
        {
            UpdateItemUM("LB", Convert.ToDecimal(txtNetWght.Text), Convert.ToDecimal(hidBaseQtyPer.Value) / Convert.ToDecimal(txtNetWght.Text));
            //hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'LB' record updated");
        }
        else
        {
            if (hidScreenMode.Value.ToUpper() != "OFF" && hidSecurity.Value != "1")
            {
                InsertItemUM("LB", Convert.ToDecimal(txtNetWght.Text), Convert.ToDecimal(hidBaseQtyPer.Value) / Convert.ToDecimal(txtNetWght.Text));
                hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'LB' created");
            }
        }
        gvItemUOM_Bind();
        Session["dtUOM"] = dtUOM;
        pnlBody.Update();
    }
    
    protected void CalcPieces()
    {
        decimal _pieceQty = Convert.ToDecimal(txtNetWght.Text) / Convert.ToDecimal(txt100Wght.Text) * 100;
        if (_pieceQty == 0) _pieceQty = 1;

        hidPieceQty.Value = _pieceQty.ToString();
        lblPCQty.Text = _pieceQty.ToString();

        #region Update PC record in ItemUM Details Grid
        //dtUOM = (DataTable)Session["dtUOM"];
        string expr = "UOM = 'PC'";
        //Filter out UOM records with DeleteDt set
        expr += " AND UOMUpdStatus >= 0";

        DataRow[] dr = dtUOM.Select(expr);

        if (dr.Length > 0)
        {
            UpdateItemUM("PC", _pieceQty, Convert.ToDecimal(hidBaseQtyPer.Value) / _pieceQty);
            //hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'PC' record updated");
        }
        else
        {
            if (hidScreenMode.Value.ToUpper() != "OFF" && hidSecurity.Value != "1")
            {
                InsertItemUM("PC", _pieceQty, Convert.ToDecimal(hidBaseQtyPer.Value) / _pieceQty);
                hidDtlUOMMsg.Value = BuildDetailMessage(hidDtlUOMMsg.Value, "'PC' created");
            }
        }
        gvItemUOM_Bind();
        #endregion Update PC record in ItemUM Details Grid

        if (ddlPCLBFT.SelectedValue.ToString().Trim() == "PC")
        {
            txtDtlBaseQty.Text = String.Format("{0:0.0#####}", _pieceQty);
            lblUOMQtyPer.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(hidBaseQtyPer.Value) / _pieceQty);
            RecalcUM();
        }

        //Session["dtUOM"] = dtUOM;
        pnlBody.Update();
    }

    protected string UnitsPerBaseLbl()
    {
        int _strPos = 0;
        string _unitDsc = string.Empty;
        string _baseVal = string.Empty;
        string _returnDsc = string.Empty;

        _strPos = Convert.ToInt32(ddlPCLBFT.SelectedItem.ToString().Trim().IndexOf("-")) + 1;
        _unitDsc = ddlPCLBFT.SelectedItem.ToString().Trim().Substring(_strPos);

        _baseVal = ddlBaseUOM.SelectedValue.ToString().Trim();

        if (!string.IsNullOrEmpty(_unitDsc))
            _returnDsc = _unitDsc + " / ";
        else
            _returnDsc = "Units" + " / ";

        if (!string.IsNullOrEmpty(_baseVal))
            _returnDsc += _baseVal;
        else
            _returnDsc += "Base";

        return (_returnDsc);
    }

    protected string UnitsPerSELbl()
    {
        int _strPos = 0;
        //string _unitVal = string.Empty;
        string _unitDsc = string.Empty;
        string _superVal = string.Empty;
        //string _superDsc = string.Empty;
        string _returnDsc = string.Empty;

        //_unitVal = ddlPCLBFT.SelectedValue.ToString().Trim();
        _strPos = Convert.ToInt32(ddlPCLBFT.SelectedItem.ToString().Trim().IndexOf("-")) + 1;
        _unitDsc = ddlPCLBFT.SelectedItem.ToString().Trim().Substring(_strPos);

        _superVal = ddlSuperUOM.SelectedValue.ToString().Trim();
        //_strPos = Convert.ToInt32(ddlSuperUOM.SelectedItem.ToString().Trim().IndexOf("-")) + 1;
        //_superDsc = ddlSuperUOM.SelectedItem.ToString().Trim().Substring(_strPos);

        if (!string.IsNullOrEmpty(_unitDsc))
            _returnDsc = _unitDsc + " / ";
        else
            _returnDsc = "Units" + " / ";

        if (!string.IsNullOrEmpty(_superVal))
            _returnDsc += _superVal;
        else
            _returnDsc += "SE";

        return (_returnDsc);
    }

    protected void RecalcUM()
    {
        //Update the existing record in dtUOM
        foreach (DataRow dr in dtUOM.Rows)
        {
            if (Convert.ToDecimal(dr["UOMDivisor"]) != 0)
            {
                dr["AltQty"] = Convert.ToDecimal(lblUnitsPerBase.Text) / Convert.ToDecimal(dr["UOMDivisor"]);
                dr["QtyPer"] = Convert.ToDecimal(dr["UOMDivisor"]) * Convert.ToDecimal(lblUOMQtyPer.Text);
                if (Convert.ToInt32(dr["UOMUpdStatus"]) == 0)
                    dr["UOMUpdStatus"] = 1; //1=UPDATE ItemUM

                if (dr["UOM"].ToString().Trim() == ddlBaseUOM.SelectedValue.ToString().Trim())
                {
                    hidBaseQtyPer.Value = dr["QtyPer"].ToString().Trim();
                }
            }
        }
    }
    #endregion UM Calcs & Updates
    
    #endregion ItemUOM Events

    #region ItemBranch Events
    protected void lnkHubIns_Click(object sender, EventArgs e)
    {
        if (hidInsHub.Value == "true")
        {
            hidDtlBrnMsg.Value = string.Empty;
            dtBranch = (DataTable)Session["dtBranch"];
            foreach (DataRow dr in dtBranch.Rows)
            {
                if (dr["BrnHubInd"].ToString().ToUpper().Trim() == "Y" && dr["LocEdit"].ToString().ToUpper().Trim() == "INS")
                {
                    hidDtlBrnMsg.Value = hidDtlBrnMsg.Value + (string.IsNullOrEmpty(hidDtlBrnMsg.Value) ? "Inserted: " : ", ") + dr["Location"].ToString().Trim();
                    lblDtlStatus.ForeColor = System.Drawing.Color.Green;
                    dr["LocEdit"] = "Upd";
                    dr["LocStatus"] = dr["LocName"].ToString().Trim();
                    dr["StockInd"] = "No";
                    dr["SVC"] = "N";
                    dr["ROP"] = 0.0;
                    dr["Capacity"] = 0;
                    dr["BrnID"] = hidItemID.Value;
                    dr["BrnUpdStatus"] = 2; //2=INSERT ItemBranch
                }
            }
            Session["dtBranch"] = dtBranch;
            gvItemBrn_Bind();
            if (string.IsNullOrEmpty(hidDtlBrnMsg.Value))
            {
                lblDtlStatus.ForeColor = System.Drawing.Color.Red;
                hidDtlBrnMsg.Value = "No Hubs Inserted";
            }
            DetailStatusMessage(hidDtlBrnMsg.Value.ToString().Trim(), "");
        }
    }
    
    protected void chkDtlStkInd_CheckedChanged(object sender, EventArgs e)
    {
        dtBranch = (DataTable)Session["dtBranch"];
        //Update the existing record in dtBranch
        foreach (DataRow dr in dtBranch.Rows)
        {
            if (dr["Location"].ToString().Trim() == lblItemBrn.Text.ToString().Trim())
            {
                if (chkDtlStkInd.Checked)
                    dr["StockInd"] = "Yes";
                else
                    dr["StockInd"] = "No";
                if (Convert.ToInt32(dr["BrnUpdStatus"]) == 0)
                    dr["BrnUpdStatus"] = 1; //1=UPDATE ItemBranch
            }
        }
        Session["dtBranch"] = dtBranch;
        gvItemBrn_Bind();
    }

    protected void ddlDtlSVC_SelectedIndexChanged(object sender, EventArgs e)
    {
        dtBranch = (DataTable)Session["dtBranch"];
        //Update the existing record in dtBranch
        foreach (DataRow dr in dtBranch.Rows)
        {
            if (dr["Location"].ToString().Trim() == lblItemBrn.Text.ToString().Trim())
            {
                dr["SVC"] = ddlDtlSVC.SelectedValue.ToString().Trim();
                if (Convert.ToInt32(dr["BrnUpdStatus"]) == 0)
                    dr["BrnUpdStatus"] = 1; //1=UPDATE ItemBranch
            }
        }
        Session["dtBranch"] = dtBranch;
        gvItemBrn_Bind();
    }

    protected void txtDtlROP_TextChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtDtlROP.Text))
            txtDtlROP.Text = "0.0";
        
        dtBranch = (DataTable)Session["dtBranch"];
        //Update the existing record in dtBranch
        foreach (DataRow dr in dtBranch.Rows)
        {
            if (dr["Location"].ToString().Trim() == lblItemBrn.Text.ToString().Trim())
            {
                dr["ROP"] = txtDtlROP.Text;
                if (Convert.ToInt32(dr["BrnUpdStatus"]) == 0)
                    dr["BrnUpdStatus"] = 1; //1=UPDATE ItemBranch
            }
        }
        Session["dtBranch"] = dtBranch;
        gvItemBrn_Bind();
    }

    protected void txtDtlBinCap_TextChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtDtlBinCap.Text))
            txtDtlBinCap.Text = "0";

        dtBranch = (DataTable)Session["dtBranch"];
        //Update the existing record in dtBranch
        foreach (DataRow dr in dtBranch.Rows)
        {
            if (dr["Location"].ToString().Trim() == lblItemBrn.Text.ToString().Trim())
            {
                dr["Capacity"] = txtDtlBinCap.Text;
                if (Convert.ToInt32(dr["BrnUpdStatus"]) == 0)
                    dr["BrnUpdStatus"] = 1; //1=UPDATE ItemBranch
            }
        }
        Session["dtBranch"] = dtBranch;
        gvItemBrn_Bind();
    }
    #endregion ItemBranch Events

    #region Weight
    protected void txt100Wght_TextChanged(object sender, EventArgs e)
    {
        DisplayStatusMessage("", "success");
        txt100Wght.BackColor = System.Drawing.Color.White;
        txtNetWght.BackColor = System.Drawing.Color.White;

        if (string.IsNullOrEmpty(txt100Wght.Text) || txt100Wght.Text == "0")
        {
            txt100Wght.Text = string.Empty;
            txt100Wght.BackColor = System.Drawing.Color.Yellow;
            DisplayStatusMessage("Wght / 100 Pcs can not be BLANK or ZERO", "fail");
            smItemMaint.SetFocus(txt100Wght);
            return;
        }

        if (string.IsNullOrEmpty(txtNetWght.Text) || txtNetWght.Text == "0")
        {
            txtNetWght.Text = string.Empty;
            txtNetWght.BackColor = System.Drawing.Color.Yellow;
            DisplayStatusMessage("Please enter the Net Wght", "fail");
            smItemMaint.SetFocus(txtNetWght);
            return;
        }

        dtUOM = (DataTable)Session["dtUOM"];
        txt100Wght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txt100Wght.Text));
        if (ddlPCLBFT.SelectedValue.ToString().ToUpper().Trim() == "LB")
        {
            //txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(hidPieceQty.Value) / 100 * Convert.ToDecimal(txt100Wght.Text));
            //txtDtlBaseQty.Text = txtNetWght.Text.ToString().Trim();
            CalcPieces();
        }
        else
        {
            txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtDtlBaseQty.Text) / 100 * Convert.ToDecimal(txt100Wght.Text));
        }
        Session["dtUOM"] = dtUOM;
        lblGrossWght.Text = CalcGross();
        PoundUOM();
        DetailStatusMessage(hidDtlUOMMsg.Value, "");
    }

    protected void txtNetWght_TextChanged(object sender, EventArgs e)
    {
        DisplayStatusMessage("", "success");
        txtNetWght.BackColor = System.Drawing.Color.White;
        txt100Wght.BackColor = System.Drawing.Color.White;

        if (string.IsNullOrEmpty(txtNetWght.Text) || txtNetWght.Text == "0")
        {
            txtNetWght.Text = string.Empty;
            txtNetWght.BackColor = System.Drawing.Color.Yellow;
            DisplayStatusMessage("Net Wght can not be BLANK or ZERO", "fail");
            smItemMaint.SetFocus(txtNetWght);
            return;
        }

        if (string.IsNullOrEmpty(txt100Wght.Text) || txt100Wght.Text == "0")
        {
            txt100Wght.Text = string.Empty;
            txt100Wght.BackColor = System.Drawing.Color.Yellow;
            DisplayStatusMessage("Please enter the Wght / 100 Pcs", "fail");
            smItemMaint.SetFocus(txt100Wght);
            return;
        }

        dtUOM = (DataTable)Session["dtUOM"];
        txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text));
        if (ddlPCLBFT.SelectedValue.ToString().ToUpper().Trim() == "LB")
        {
            //txt100Wght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text) * 100 / Convert.ToDecimal(hidPieceQty.Value));
            txtDtlBaseQty.Text = txtNetWght.Text.ToString().Trim();
            lblUOMQtyPer.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(hidBaseQtyPer.Value) / Convert.ToDecimal(txtNetWght.Text));
            lblUnitsPerBase.Text = txtDtlBaseQty.Text;
            lblUnitsPerSE.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text) * Convert.ToDecimal(lblUnitsPerBase.Text));
            CalcPieces();
            RecalcUM();
        }
        else
        {
            txt100Wght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text) * 100 / Convert.ToDecimal(txtDtlBaseQty.Text));
        }
        Session["dtUOM"] = dtUOM;
        lblGrossWght.Text = CalcGross();
        PoundUOM();
        DetailStatusMessage(hidDtlUOMMsg.Value, "");
    }

    protected void txtRoutingNo_TextChanged(object sender, EventArgs e)
    {
        lblGrossWght.Text = CalcGross();
    }

    protected string CalcGross()
    {
        //Gross Wght = Net Wght + Density Factor (Carton Routing Adder)

        DataSet ds = null;
        decimal _grossWght = Convert.ToDecimal(txtNetWght.Text);
        decimal _densityFactor = 0;

        //Find Carton Routing Adder
        strSQL = "SELECT IM.DensityFactor " +
                 "FROM   ItemMaster (NoLock) IM " +
                 "WHERE  IM.ItemStat = 'M' and rtrim(IM.ItemNo) = '" + txtRoutingNo.Text.ToString().Trim() + "'";
        try
        {
            ds = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, strSQL);
            cnERP.Close();
        }
        catch
        {
        }

        if (ds != null && ds.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            _densityFactor = Convert.ToDecimal(ds.Tables[0].DefaultView.ToTable().Rows[0]["DensityFactor"]);
        }

        _grossWght += _densityFactor;
        lblDensity.Text = String.Format("{0:0.000000}", _densityFactor);
        pnlWrkFld.Update();
        return String.Format("{0:0.000}", _grossWght);
    }
    #endregion Weight

    #region Button Events
    protected void btnBuildDesc_Click(object sender, ImageClickEventArgs e)
    {
        BuildItemDesc();
    }

    protected void btnCopy_Click(object sender, ImageClickEventArgs e)
    {
        if (hidCopyConf.Value.ToUpper() == "TRUE")
        {
            lblSourceItem.Text = "From Item No";
            txtSourceItem.Enabled = false;
            tblListParam.Visible = false;
            tblDestItem.Visible = true;
            txtDestItem.Enabled = true;

            Release(hidItemID.Value.ToString().Trim(), lblItemNo.Text.ToString().Trim(), txtLblUPCCd.Text.ToString().Trim(), hidUPCCd.Value.ToString().Trim(), hidLockStatus.Value.ToString().Trim(), hidLockUser.Value.ToString().Trim());
            ddlDetails.SelectedValue = "ItemUM";
            SwitchDetails(ddlDetails.SelectedValue.ToString().Trim());
            ToggleScreen("OFF");
            btnCancel.Visible = true;
            smItemMaint.SetFocus(txtDestItem);
            UpdatePanels();

            hidMaintMode.Value = "COPY";
            hidInsConf.Value = "";
            DisplayStatusMessage("Please enter the 'To Item No' above", "fail");
        }
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        if (hidDelItem.Value.ToUpper() == "TRUE")
        {
            //DELETE the selected record - SET the DeleteDt
            #region [SQL] DELETE ItemMaster
            //TMD:  [EMAIL] Possible pending business rules per Tom Jr
            //       Email  thread dated 02/20/12 - RE: Deleted Items/New Items: WO 2003 [Item Master Maintenance]
            strSQL = "UPDATE ItemMaster " +
                     "SET    DeleteID = '" + Session["UserName"].ToString().Trim() + "', DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                     "WHERE  pItemMasterID = " + hidItemID.Value;

            try
            {
                SqlHelper.ExecuteReader(cnERP, CommandType.Text, strSQL);
                cnERP.Close();
                Release(hidItemID.Value.ToString().Trim(),lblItemNo.Text.ToString().Trim(),txtLblUPCCd.Text.ToString().Trim(),hidUPCCd.Value.ToString().Trim(),hidLockStatus.Value.ToString().Trim(),hidLockUser.Value.ToString().Trim());
            }
            catch (Exception ex)
            {
                DisplayStatusMessage("ItemMaster DELETE Error - " + ex.Message, "fail");
                //DisplayStatusMessage(ex.Message, "fail");
                return;
            }
            #endregion [SQL] DELETE ItemMaster

            dtUOM = (DataTable)Session["dtUOM"];
            if (dtUOM != null && dtUOM.Rows.Count > 0)
            {
                #region [SQL] DELETE ItemUM
                strSQL = "UPDATE ItemUM " +
                         "SET    DeleteID = '" + Session["UserName"].ToString().Trim() + "', DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                         "WHERE  fItemMasterID = " + hidItemID.Value + " AND isnull(DeleteID,'') = ''";

                try
                {
                    SqlHelper.ExecuteReader(cnERP, CommandType.Text, strSQL);
                    cnERP.Close();
                }
                catch (Exception ex)
                {
                    DisplayStatusMessage("ItemUM DELETE Error - " + ex.Message, "fail");
                    //DisplayStatusMessage(ex.Message, "fail");
                    return;
                }
                #endregion [SQL] DELETE ItemUM
            }

            hidMaintMode.Value = "DEL";
            ToggleScreen("OFF");
            btnCancel.Visible = true;
            DisplayStatusMessage("ITEM DELETED", "success");
        }
        else
        {
            DisplayStatusMessage("Item was NOT Deleted", "fail");
        }

        smItemMaint.SetFocus(txtSourceItem);
        UpdatePanels();
    }
    
    //protected void btnHidSave_Click(object sender, EventArgs e)
    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        //TMD: Email sent to Charles 2/9/12
        //Can I execute my INSERT and UPDATE from the code behind like BOM Maint or does this require a stored procedure
        //If we use a stored procedure, we will have to pass every column to the procedure.
        //
        //Answer from Tom Jr: Do the update here but use a stored procedure for any data validation logic
        //(TMD: what validation logic??)

        DisplayStatusMessage("", "success");

        int _webInd, _certInd, _hazInd, _fqaInd, _ptInd;
        string _listPrice;

        if (hidMaintMode.Value.ToString().ToUpper().Trim() == "EDIT" || hidMaintMode.Value.ToString().ToUpper().Trim() == "INS" || hidMaintMode.Value.ToString().ToUpper().Trim() == "COPY")
        {
            hidStsMsg.Value = "| ";

            #region Toggle empty field hi-lights
            bool fieldsValid = true;

            if (string.IsNullOrEmpty(txtDtlBaseQty.Text))
            {
                ddlDetails.SelectedValue = "ItemUM";
                SwitchDetails(ddlDetails.SelectedValue.ToString().Trim());
                
                fieldsValid = false;
                smItemMaint.SetFocus(txtDtlBaseQty);
                txtDtlBaseQty.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                if (ddlPCLBFT.SelectedValue.ToString().ToUpper().Trim() == "LB")
                {
                    txtDtlBaseQty.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
                    txtDtlBaseQty.Attributes.Add("readonly", "readonly");
                    txtDtlBaseQty.CssClass = "TextBoxLabel txtRight";
                }
                else
                {
                    txtDtlBaseQty.BackColor = System.Drawing.Color.White;
                    txtDtlBaseQty.Attributes.Remove("readonly");
                    txtDtlBaseQty.CssClass = "FormCtrl2 txtRight";
                }
            }

            if (string.IsNullOrEmpty(txtCatDesc.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(txtCatDesc);
                txtCatDesc.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtCatDesc.BackColor = System.Drawing.Color.White;
            }

            if (string.IsNullOrEmpty(txtSizeDesc.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(txtSizeDesc);
                txtSizeDesc.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtSizeDesc.BackColor = System.Drawing.Color.White;
            }

            if (ddlPlating.SelectedIndex <= 0)
            {
                fieldsValid = false;
                smItemMaint.SetFocus(ddlPlating);
                ddlPlating.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                ddlPlating.BackColor = System.Drawing.Color.White;
            }

            if (string.IsNullOrEmpty(txtLblUPCCd.Text))
            {
                //fieldsValid = false;
                smItemMaint.SetFocus(btnBulkUPC);
                txtLblUPCCd.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtLblUPCCd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
            }

            if (string.IsNullOrEmpty(txtAltDesc.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(txtAltDesc);
                txtAltDesc.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtAltDesc.BackColor = System.Drawing.Color.White;
            }

            if (string.IsNullOrEmpty(txtAltSize.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(txtAltSize);
                txtAltSize.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtAltSize.BackColor = System.Drawing.Color.White;
            }

            if (ddlPriceGroup.SelectedIndex <= 0)
            {
                fieldsValid = false;
                smItemMaint.SetFocus(ddlPriceGroup);
                ddlPriceGroup.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                ddlPriceGroup.BackColor = System.Drawing.Color.White;
            }

            if (ddlCFV.SelectedIndex <= 0)
            {
                fieldsValid = false;
                smItemMaint.SetFocus(ddlCFV);
                ddlCFV.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                ddlCFV.BackColor = System.Drawing.Color.White;
            }

            if (string.IsNullOrEmpty(txtLblPPICd.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(lnkPPICd);
                txtLblPPICd.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtLblPPICd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
            }

            if (string.IsNullOrEmpty(txtLblHarmTaxCd.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(lnkHarmTaxCd);
                txtLblHarmTaxCd.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtLblHarmTaxCd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
            }

            if (string.IsNullOrEmpty(txt100Wght.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(txt100Wght);
                txt100Wght.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txt100Wght.BackColor = System.Drawing.Color.White;
            }

            if (string.IsNullOrEmpty(txtNetWght.Text))
            {
                fieldsValid = false;
                smItemMaint.SetFocus(txtNetWght);
                txtNetWght.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                txtNetWght.BackColor = System.Drawing.Color.White;
            }

            if (ddlPCLBFT.SelectedIndex <= 0)
            {
                fieldsValid = false;
                smItemMaint.SetFocus(ddlPCLBFT);
                ddlPCLBFT.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                ddlPCLBFT.BackColor = System.Drawing.Color.White;
            }

            if (ddlBaseUOM.SelectedIndex <= 0)
            {
                fieldsValid = false;
                smItemMaint.SetFocus(ddlBaseUOM);
                ddlBaseUOM.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                ddlBaseUOM.BackColor = System.Drawing.Color.White;
            }

            if (ddlSellUOM.SelectedIndex <= 0)
            {
                fieldsValid = false;
                smItemMaint.SetFocus(ddlSellUOM);
                ddlSellUOM.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                ddlSellUOM.BackColor = System.Drawing.Color.White;
            }

            if (ddlPurchUOM.SelectedIndex <= 0)
            {
                fieldsValid = false;
                smItemMaint.SetFocus(ddlPurchUOM);
                ddlPurchUOM.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                ddlPurchUOM.BackColor = System.Drawing.Color.White;
            }

            if (!fieldsValid)
            {
                DisplayStatusMessage("Hi-lighted fields can not be blank", "fail");
                UpdatePanels();
                return;
            }

            //Check the UPC Separately
            if (string.IsNullOrEmpty(txtLblUPCCd.Text))
            {
                smItemMaint.SetFocus(btnBulkUPC);
                DisplayStatusMessage("You must generate a valid UPC Code", "fail");
                return;
            }
            #endregion Toggle empty field hi-lights

            #region UPDATE the current ItemMaster Record
            if (string.IsNullOrEmpty(txtItemDesc.Text))
                BuildItemDesc();

            #region Remove single quote characters from description fields
            txtCatDesc.Text = txtCatDesc.Text.ToString().Trim().Replace("'", " ");
            txtSizeDesc.Text = txtSizeDesc.Text.ToString().Trim().Replace("'", " ");
            txtItemDesc.Text = txtItemDesc.Text.ToString().Trim().Replace("'", " ");
            txtAltDesc.Text = txtAltDesc.Text.ToString().Trim().Replace("'", " ");
            txtAltDesc2.Text = txtAltDesc2.Text.ToString().Trim().Replace("'", " ");
            txtAltDesc3.Text = txtAltDesc3.Text.ToString().Trim().Replace("'", " ");
            txtAltSize.Text = txtAltSize.Text.ToString().Trim().Replace("'", " ");
            txtDiameter.Text = txtDiameter.Text.ToString().Trim().Replace("'", " ");
            txtLength.Text = txtLength.Text.ToString().Trim().Replace("'", " ");
            #endregion Remove single quote characters from description fields

            #region Check Boxes
            if (chkWebEnabled.Checked)
                _webInd = 1;
            else
                _webInd = 0;

            if (chkCert.Checked)
                _certInd = 1;
            else
                _certInd = 0;

            if (chkHazMat.Checked)
                _hazInd = 1;
            else
                _hazInd = 0;

            if (chkFQA.Checked)
                _fqaInd = 1;
            else
                _fqaInd = 0;

            if (chkPtPartner.Checked)
                _ptInd = 1;
            else
                _ptInd = 0;
            #endregion Check Boxes

            if (string.IsNullOrEmpty(txtListPrice.Text))
                txtListPrice.Text = "0";
            _listPrice = txtListPrice.Text.ToString().Trim().Replace("$", "");

            if (string.IsNullOrEmpty(txt100Wght.Text))
                txt100Wght.Text = "0";

            if (string.IsNullOrEmpty(txtNetWght.Text))
                txtNetWght.Text = "0";

            if (string.IsNullOrEmpty(lblGrossWght.Text))
                lblGrossWght.Text = "0";

            if (string.IsNullOrEmpty(lblGrossWght.Text))
                lblGrossWght.Text = "0";

            if (string.IsNullOrEmpty(lblUnitsPerBase.Text))
                lblUnitsPerBase.Text = "0";

            if (string.IsNullOrEmpty(lblUnitsPerSE.Text))
                lblUnitsPerSE.Text = "0";

            if (string.IsNullOrEmpty(txtSuperUOMQty.Text))
                txtSuperUOMQty.Text = "0";

            #region [SQL] Update ItemMaster
            strSQL = "UPDATE    ItemMaster " +
                     "SET       ItemNo = '" + lblItemNo.Text.ToString().Trim() + "', " +
                     "          LengthDesc = '" + txtLength.Text.ToString().Trim() + "', " +
                     "          DiameterDesc = '" + txtDiameter.Text.ToString().Trim() + "', " +
                     "          CatDesc = '" + txtCatDesc.Text.ToString().Trim() + "', " +
                     "          ItemSize = '" + txtSizeDesc.Text.ToString().Trim() + "', " +
                     "          Finish = '" + ddlPlating.SelectedValue.ToString().Trim() + "', " +
                     "          ItemDesc = '" + txtItemDesc.Text.ToString().Trim() + "', " +
                     "          UPCCd = '" + txtLblUPCCd.Text.ToString().Trim() + "', " +
                     "          CategoryDescAlt1 = '" + txtAltDesc.Text.ToString().Trim() + "', " +
                     "          CategoryDescAlt2 = '" + txtAltDesc2.Text.ToString().Trim() + "', " +
                     "          CategoryDescAlt3 = '" + txtAltDesc3.Text.ToString().Trim() + "', " +
                     "          SizeDescAlt1 = '" + txtAltSize.Text.ToString().Trim() + "', " +
                     "          CustNo = '" + txtCustNo.Text.ToString().Trim() + "', " +
                     "          ItemPriceGroup = '" + ddlPriceGroup.SelectedValue.ToString().Trim() + "', " +
                     "          BoxSize = '" + txtRoutingNo.Text.ToString().Trim() + "', " +
                     "          ParentProdNo = '" + txtParent.Text.ToString().Trim() + "', " +
                     "          CorpFixedVelocity = '" + ddlCFV.SelectedValue.ToString().Trim() + "', " +
                     "          PPICode = '" + txtLblPPICd.Text.ToString().Trim() + "', " +
                     "          Tariff = '" + txtLblHarmTaxCd.Text.ToString().Trim() + "', " +
                     "          WebEnabledInd = " + _webInd + ", " +
                     "          CertRequiredInd = " + _certInd + ", " +
                     "          HazMatInd = " + _hazInd + ", " +
                     "          QualityInd = " + _fqaInd + ", " +
                     "          PalPtnrInd = " + _ptInd + ", " +
                     "          ListPrice = '" + _listPrice + "', " +
                     "          HundredWght = '" + txt100Wght.Text.ToString().Trim() + "', " +
                     "          GrossWght = '" + lblGrossWght.Text.ToString().Trim() + "', " +
                     "          Wght = '" + txtNetWght.Text.ToString().Trim() + "', " +
                     "          PCLBFTInd = '" + ddlPCLBFT.SelectedValue.ToString().Trim() + "', " +
                     "          SellStkUM = '" + ddlBaseUOM.SelectedValue.ToString().Trim() + "', " +
                     "          SellStkUMQty = '" + lblUnitsPerBase.Text.ToString().Trim() + "', " +
                     "          PcsPerPallet = '" + lblUnitsPerSE.Text.ToString().Trim() + "', " +
                     "          SellUM = '" + ddlSellUOM.SelectedValue.ToString().Trim() + "', " +
                     "          CostPurUM = '" + ddlPurchUOM.SelectedValue.ToString().Trim() + "', " +
                     "          SuperUM = '" + ddlSuperUOM.SelectedValue.ToString().Trim() + "', " +
                     "          SuperUMQty = '" + txtSuperUOMQty.Text.ToString().Trim() + "', " +
                     "          EntryID = CASE WHEN left(EntryID,7) = 'InsTemp' or left(EntryID,8) = 'CopyTemp' THEN '" + Session["UserName"].ToString().Trim() + "' ELSE EntryID END, " +
                     "          ChangeID = '" + Session["UserName"].ToString().Trim() + "', " +
                     "          ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), " +
                     "          DeleteID = CASE WHEN left(DeleteID,5) = 'SETUP' THEN null ELSE DeleteID END, " +
                     "          DeleteDt = CASE WHEN left(DeleteID,5) = 'SETUP' THEN null ELSE DeleteDt END " +
                     "WHERE     pItemMasterID = " + hidItemID.Value.ToString().Trim();
            try
            {
                SqlHelper.ExecuteReader(cnERP, CommandType.Text, strSQL);
                cnERP.Close();
            }
            catch (Exception ex)
            {
                DisplayStatusMessage("ItemMaster UPDATE Error - " + ex.Message, "fail");
                return;
            }
            hidStsMsg.Value += hidMaintMode.Value.ToString().ToLower().Trim() + lblItemNo.Text.ToString().Trim() + " | ";
            #endregion [SQL] Update ItemMaster

            #endregion UPDATE the current ItemMaster Record

            dtUOM = (DataTable)Session["dtUOM"];
            if (dtUOM != null && dtUOM.Rows.Count > 0)
            {
                #region UPDATE the ItemUM records
                foreach (DataRow dr in dtUOM.Rows)
                {
                    switch (Convert.ToInt32(dr["UOMUpdStatus"]))
                    {
                        case -1:
                            #region [SQL] DELETE ItemUM
                            strSQL = "UPDATE ItemUM " +
                                     "SET    DeleteID = '" + Session["UserName"].ToString().Trim() + "', DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                                     "WHERE  fItemMasterID = " + hidItemID.Value + " AND UM = '" + dr["UOM"].ToString().Trim() + "'";
                            try
                            {
                                SqlHelper.ExecuteReader(cnERP, CommandType.Text, strSQL);
                                cnERP.Close();
                                hidStsMsg.Value += "del" + dr["UOM"].ToString().ToUpper().Trim() + " | ";
                            }
                            catch (Exception ex)
                            {
                                DetailStatusMessage("ItemUM Save Error (DELETE) - " + dr["UOM"].ToString().Trim() + " - " + ex.Message, "fail");
                                hidStsMsg.Value += "err" + dr["UOM"].ToString().ToUpper().Trim() + " | ";
                            }
                            #endregion [SQL] DELETE ItemUM
                            break;
                        case 1:
                            #region [SQL] UPDATE ItemUM
                            strSQL = "UPDATE    ItemUM " +
                                     "SET       AltSellStkUMQty = " + dr["AltQty"] + ", " +
                                     "          QtyPerUM = " + dr["QtyPer"] + ", " +
                                     "          EntryID = CASE WHEN left(EntryID,7) = 'InsTemp' or left(EntryID,8) = 'CopyTemp' THEN '" + Session["UserName"].ToString().Trim() + "' ELSE EntryID END, " +
                                     "          ChangeID = '" + Session["UserName"].ToString().Trim() + "', " +
                                     "          ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), " +
                                     "          DeleteID = CASE WHEN left(DeleteID,5) = 'SETUP' THEN null ELSE DeleteID END, " +
                                     "          DeleteDt = CASE WHEN left(DeleteID,5) = 'SETUP' THEN null ELSE DeleteDt END " +
                                     "WHERE     fItemMasterID = " + hidItemID.Value.ToString().Trim() + " AND UM = '" + dr["UOM"].ToString().Trim() + "'";
                            try
                            {
                                SqlHelper.ExecuteReader(cnERP, CommandType.Text, strSQL);
                                cnERP.Close();
                                dr["UOMUpdStatus"] = "0";
                                hidStsMsg.Value += "upd" + dr["UOM"].ToString().ToUpper().Trim() + " | ";
                            }
                            catch (Exception ex)
                            {
                                DetailStatusMessage("ItemUM Save Error (UPDATE) - " + dr["UOM"].ToString().Trim() + " - " + ex.Message, "fail");
                                hidStsMsg.Value += "err" + dr["UOM"].ToString().ToUpper().Trim() + " | ";
                            }
                            #endregion [SQL] UPDATE ItemUM
                            break;
                        case 2:
                            #region [SQL] INSERT ItemUM
                            strSQL = "INSERT INTO   ItemUM " +
                                     "              (fItemMasterID, UM, AltSellStkUMQty, QtyPerUM, UnitsPerUnit, " +
                                     "               Weight, Volume, SequenceNo, EntryID, EntryDt, StatusCd) " +
                                     "VALUES        (" + hidItemID.Value + ", '" + dr["UOM"].ToString().Trim() + "', " + dr["AltQty"] + ", " + dr["QtyPer"] + ", 1, " +
                                                     "0, 0, 1, '" + Session["UserName"].ToString().Trim() + "', CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), 0)";
                            try
                            {
                                SqlHelper.ExecuteReader(cnERP, CommandType.Text, strSQL);
                                cnERP.Close();
                                dr["UOMUpdStatus"] = "0";
                                hidStsMsg.Value += "ins" + dr["UOM"].ToString().ToUpper().Trim() + " | ";
                            }
                            catch (Exception ex)
                            {
                                DetailStatusMessage("ItemUM Save Error (INSERT) - " + dr["UOM"].ToString().Trim() + " - " + ex.Message, "fail");
                                hidStsMsg.Value += "err" + dr["UOM"].ToString().ToUpper().Trim() + " | ";
                            }
                            #endregion [SQL] INSERT ItemUM
                            break;
                    }
                }
                gvItemUOM_Bind();
                #endregion UPDATE the ItemUM records
            }

            dtBranch = (DataTable)Session["dtBranch"];
            if (dtBranch != null && dtBranch.Rows.Count > 0)
            {
                #region UPDATE the ItemBranch records
                string _updMode;
                foreach (DataRow dr in dtBranch.Rows)
                {
                    _updMode = string.Empty;
                    switch (Convert.ToInt32(dr["BrnUpdStatus"]))
                    {
                        case -1:
                            #region [SQL] DELETE ItemBranch
                            //DELETE Mode not currently not allowed for ItemBranch
                            #endregion [SQL] DELETE ItemBranch
                            break;
                        case 1:
                            #region [SQL] UPDATE ItemBranch
                            //Set UPDATE Mode
                            _updMode = "UPDATE";
                            #endregion [SQL] UPDATE ItemBranch
                            break;
                        case 2:
                            #region [SQL] INSERT ItemBranch
                            //Set INSERT Mode
                            _updMode = "INSERT";
                            #endregion [SQL] INSERT ItemBranch
                            break;
                    }

                    if (!string.IsNullOrEmpty(_updMode))
                    {
                        try
                        {
                            dsBranch = SqlHelper.ExecuteDataset(cnERP, BrnProcName, new SqlParameter("@ItemID", hidItemID.Value.ToString().Trim()),
                                                                                    new SqlParameter("@LocID", dr["Location"].ToString().Trim()),
                                                                                    new SqlParameter("@StkInd", dr["StockInd"].ToString().ToUpper().Trim()),
                                                                                    new SqlParameter("@SVC", dr["SVC"].ToString().ToUpper().Trim()),
                                                                                    new SqlParameter("@ROP", dr["ROP"].ToString().Trim()),
                                                                                    new SqlParameter("@BinCap", dr["Capacity"].ToString().Trim()),
                                                                                    new SqlParameter("@User", Session["UserName"].ToString().Trim()),
                                                                                    new SqlParameter("@Mode", _updMode.ToString().ToUpper().Trim()));
                            dr["BrnUpdStatus"] = "0";
                            if (_updMode.ToString().ToUpper().Trim() == "UPDATE")
                                hidStsMsg.Value += "upd" + dr["Location"].ToString().Trim() + " | ";
                            else
                                hidStsMsg.Value += "ins" + dr["Location"].ToString().Trim() + " | ";
                        }
                        catch (Exception ex)
                        {
                            DetailStatusMessage("ItemBranch Save Error (" + _updMode.ToString().ToUpper().Trim() + ") - " + dr["Location"].ToString().Trim() + " - " + ex.Message, "fail");
                            hidStsMsg.Value += "err" + dr["Location"].ToString().Trim() + " | ";
                        }
                    }
                }
                gvItemBrn_Bind();
                #endregion UPDATE the ItemBranch records
            }

            if (!string.IsNullOrEmpty(txtLblUPCCd.Text) && txtLblUPCCd.Text.ToString().Trim() != hidUPCCd.Value.ToString().Trim())
            {
                //Synch (SAVE) the ItemUPC record
                #region UPDATE the ItemUPC record
                try
                {
                    dsNewUPC = SqlHelper.ExecuteDataset(cnERP, UPCProcName, new SqlParameter("@ItemNo", lblItemNo.Text.ToString().Trim()),
                                                                            new SqlParameter("@UPCCd", txtLblUPCCd.Text.ToString().Trim()),
                                                                            new SqlParameter("@UPCType", ""),
                                                                            new SqlParameter("@Mode", "SETNEW"),
                                                                            new SqlParameter("@User", Session["UserName"].ToString().Trim()));
                }
                catch (Exception ex)
                {
                    DetailStatusMessage("ItemUPC UPDATE Error (SP) - " + ex.Message, "fail");
                    //DisplayStatusMessage(ex.Message, "fail");
                }

                if (dsNewUPC.Tables[0].Rows.Count > 0)
                {
                    dtUPC = dsNewUPC.Tables[0].DefaultView.ToTable();
                    Session["dtUPC"] = dtUPC;
                    hidUPCID.Value = dtUPC.Rows[0]["pItemUPCID"].ToString().Trim();
                    hidUPCCd.Value = dtUPC.Rows[0]["UPCCd"].ToString().Trim();
                    hidStsMsg.Value += "updUPC | ";
                    //DisplayStatusMessage("UPC SAVED", "success");
                }
                else
                {
                    dtUPC = null;
                    Session["dtUPC"] = null;
                    hidUPCID.Value = string.Empty;
                    hidUPCCd.Value = string.Empty;
                    hidStsMsg.Value += "errUPC | ";
                    //DisplayStatusMessage("ItemUPC UPDATE Error (No Records)", "fail");
                }
                #endregion UPDATE the ItemUPC record
            }

            tblListParam.Visible = true;
            CopyVisible("true");
            DeleteVisible("true");
            btnCancel.Visible = true;
            smItemMaint.SetFocus(txtSourceItem);
            
            switch (hidMaintMode.Value.ToString().ToUpper().Trim())
            {
                case "INS":
                    //The item has been successfully INSERTED - put the screen in EDIT mode
                    hidMaintMode.Value = "EDIT";
                    DisplayStatusMessage("ITEM ADDED", "success");
                    txtSourceItem.Enabled = true;
                    break;
                case "COPY":
                    //The item has been successfully COPIED - put the screen in EDIT mode
                    hidMaintMode.Value = "EDIT";
                    DisplayStatusMessage(txtDestItem.Text.ToString().Trim() + " copied from " + txtSourceItem.Text.ToString().Trim(), "success");

                    lblSourceItem.Text = "Item No";
                    txtSourceItem.Enabled = true;
                    txtSourceItem.Text = lblItemNo.Text.ToString().Trim();
                    txtDestItem.Text = string.Empty;
                    tblDestItem.Visible = false;
                    break;
                default:
                    //EDIT Mode
                    DisplayStatusMessage("Item " + txtSourceItem.Text.ToString().Trim() + " saved", "success");
                    Release(hidItemID.Value.ToString().Trim(), lblItemNo.Text.ToString().Trim(), txtLblUPCCd.Text.ToString().Trim(), hidUPCCd.Value.ToString().Trim(), hidLockStatus.Value.ToString().Trim(), hidLockUser.Value.ToString().Trim());
                    ClearSession();
                    ClearPrompt();
                    ClearDisplay();
                    break;
            }

            UpdatePanels();
        }
    }
    #endregion Buttons Events

    #endregion Button & Change Events

    //----------------------------------------------------------------------------------------------------//
    #region Screen Utilities
    private void BindDDL()
    {
        string _tableName = "CatalogPlating";
        string _columnName = "[CODE] + ' - ' + [DESCR] as ListDesc, [CODE] as ListValue";
        string _whereClause = "1=1 ORDER BY [CODE]";
        ddlBind.ddlBindControl(ddlPlating, ddlBind.ddlTable(_tableName, _columnName, _whereClause), "ListValue", "ListDesc", " ", " ");
        //ddlBind.BindFromList("ItemPlateType", ddlPlating, " ", " ");
        ddlBind.BindFromList("ItemPriceGroup", ddlPriceGroup, " ", " ");
        ddlBind.BindFromList("CVCCodes", ddlCFV, " ", " ");
        ddlBind.BindFromList("ItemPPICd", lstPPICd, " ", " ");
        ddlBind.BindDscFromTable("GERTARIFF", lstHarmTaxCd, " ", " ");
        ddlBind.BindFromList("ItemCalcUOM", ddlPCLBFT, " ", " ");
        ddlBind.BindFromList("UMName", ddlBaseUOM, " ", " ");
        ddlBind.BindFromList("SellPurUOM", ddlSellUOM, " ", " ");
        ddlBind.BindFromList("SellPurUOM", ddlPurchUOM, " ", " ");
        ddlBind.BindFromList("SuperEquivUOM", ddlSuperUOM, " ", " ");
        ddlBind.BindDscFromList("ItemDetails", ddlDetails, "", "");
        //ddlBind.BindFromList("ItemDetails", ddlDetails, "", "");
        ddlBind.BindFromList("SVCCodes", ddlDtlSVC, "", "");
    }

    private void ClearPrompt()
    {
        lblSourceItem.Text = "Item No";
        txtSourceItem.Enabled = true;
        txtSourceItem.Text = string.Empty;

        txtDestItem.Text = string.Empty;
        tblDestItem.Visible = false;

        txtCatParam.Text = string.Empty;
        txtSizeParam.Text = string.Empty;
        txtVarParam.Text = string.Empty;
        tblListParam.Visible = true;
    }

    private void ClearDisplay()
    {
        ToggleScreen("OFF");
        txtCat.Text = string.Empty;
        txtCat.Attributes.Add("readonly", "readonly");
        txtSize.Text = string.Empty;
        txtSize.Attributes.Add("readonly", "readonly");
        txtVar.Text = string.Empty;
        txtVar.Attributes.Add("readonly", "readonly");
        lblItemNo.Text = string.Empty;
        txtLength.Text = string.Empty;
        txtDiameter.Text = string.Empty;
        txtCatDesc.Text = string.Empty;
        txtSizeDesc.Text = string.Empty;
        ddlPlating.SelectedIndex = -1;
        txtItemDesc.Text = string.Empty;
        txtLblUPCCd.Text = string.Empty;
        txtLblUPCCd.Attributes.Add("readonly", "readonly");
        txtAltDesc.Text = string.Empty;
        txtAltDesc2.Text = string.Empty;
        txtAltDesc3.Text = string.Empty;
        txtAltSize.Text = string.Empty;
        txtCustNo.Text = string.Empty;
        ddlPriceGroup.SelectedIndex = -1;
        txtRoutingNo.Text = string.Empty;
        txtParent.Text = string.Empty;
        lblBOMInd.Text = string.Empty;
        ddlCFV.SelectedIndex = -1;
        txtLblPPICd.Text = string.Empty;
        txtLblPPICd.Attributes.Add("readonly", "readonly");
        txtLblHarmTaxCd.Text = string.Empty;
        txtLblHarmTaxCd.Attributes.Add("readonly", "readonly");
        chkWebEnabled.Checked = false;
        chkCert.Checked = false;
        chkHazMat.Checked = false;
        chkFQA.Checked = false;
        chkPtPartner.Checked = false;
        txtListPrice.Text = string.Empty;
        txt100Wght.Text = string.Empty;
        txtNetWght.Text = string.Empty;
        lblGrossWght.Text = string.Empty;
        ddlPCLBFT.SelectedIndex = -1;
        ddlBaseUOM.SelectedIndex = -1;
        lblUnitsPerBaseLbl.Text = "Units / Base";
        lblUnitsPerBase.Text = string.Empty;
        lblUnitsPerSELbl.Text = "Units / SE";
        lblUnitsPerSE.Text = string.Empty;
        ddlSellUOM.SelectedIndex = -1;
        ddlPurchUOM.SelectedIndex = -1;
        ddlSuperUOM.SelectedIndex = -1;
        txtSuperUOMQty.Text = string.Empty;

        //Item Details
        ddlDetails.SelectedValue = "ItemUM";
        tblItemUOM.Visible = false;
        tblUOMEdit.Visible = false;
        tblItemBrn.Visible = false;
        tblBrnEdit.Visible = false;
        tblItemNotes.Visible = false;
        divDtlStatus.Visible = false;

        btnCancel.Visible = false;

        //Work Fields
        //lblUserInfo.Text = "~user info~";
        lblDensity.Text = "nnn.nnnnnn";
        lblPCQty.Text = "n,nnn,nnn";
        lblBaseQty.Text = "n,nnn,nnn";
        //lblLockInfo.Text = "~lock info~";
        
        ddlBaseUOM.BackColor = System.Drawing.Color.White;
        ddlPriceGroup.BackColor = System.Drawing.Color.White;
        ddlCFV.BackColor = System.Drawing.Color.White;
        txtLblPPICd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
        txtLblHarmTaxCd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
        ddlPCLBFT.BackColor = System.Drawing.Color.White;
        ddlPlating.BackColor = System.Drawing.Color.White;
        ddlPurchUOM.BackColor = System.Drawing.Color.White;
        ddlSellUOM.BackColor = System.Drawing.Color.White;
        txtLblUPCCd.BackColor = System.Drawing.ColorTranslator.FromHtml("#F9FDFE");
        txt100Wght.BackColor = System.Drawing.Color.White;
        txtAltDesc.BackColor = System.Drawing.Color.White;
        txtAltSize.BackColor = System.Drawing.Color.White;
        txtCatDesc.BackColor = System.Drawing.Color.White;
        //txtDtlBaseQty.BackColor = System.Drawing.Color.White;
        txtDtlBaseQty.CssClass = "FormCtrl2 txtRight";
        txtDtlBaseQty.Attributes.Remove("readonly");
        txtNetWght.BackColor = System.Drawing.Color.White;
        txtSizeDesc.BackColor = System.Drawing.Color.White;
    }

    private void ToggleScreen(string _switch)
    {
        if (_switch.ToUpper() == "ON")
        {
            //Toggle screen ON
            hidScreenMode.Value = "ON";

            gvItemUOM.Columns[0].Visible = true;

            #region Text Boxes
            txtLength.Enabled = true;
            txtDiameter.Enabled = true;
            txtCatDesc.Enabled = true;
            txtSizeDesc.Enabled = true;
            txtItemDesc.Enabled = true;
            txtAltDesc.Enabled = true;
            txtAltDesc2.Enabled = true;
            txtAltDesc3.Enabled = true;
            txtAltSize.Enabled = true;
            txtCustNo.Enabled = true;
            txtRoutingNo.Enabled = true;
            txtParent.Enabled = true;
            txtListPrice.Enabled = true;
            txt100Wght.Enabled = true;
            txtNetWght.Enabled = true;
            txtSuperUOMQty.Enabled = true;
            //txtDtlBaseQty.Enabled = true;
            if (ddlPCLBFT.SelectedValue.ToString().ToUpper().Trim() == "LB")
            {
                txtDtlBaseQty.Attributes.Remove("readonly");
            }
            else
            {
                txtDtlBaseQty.Enabled = true;
            }
            #endregion

            #region Dropdown Lists
            ddlDetails.Enabled = true;
            ddlPlating.Enabled = true;
            ddlPriceGroup.Enabled = true;
            ddlCFV.Enabled = true;
            lnkPPICd.Enabled = true;
            lnkHarmTaxCd.Enabled = true;
            ddlPCLBFT.Enabled = true;
            ddlBaseUOM.Enabled = true;
            ddlSellUOM.Enabled = true;
            ddlPurchUOM.Enabled = true;
            ddlSuperUOM.Enabled = true;
            #endregion

            #region Check Boxes
            chkWebEnabled.Enabled = true;
            chkCert.Enabled = true;
            chkHazMat.Enabled = true;
            chkFQA.Enabled = true;
            chkPtPartner.Enabled = true;
            #endregion

            #region Buttons
            BuildDescVisible("true");
            PkgUPCVisible("true");
            BulkUPCVisible("true");
            CopyVisible("true");
            DeleteVisible("true");
            SaveVisible("true");
            #endregion
        }
        else
        {
            //Toggle screen OFF
            hidScreenMode.Value = "OFF";

            gvItemUOM.Columns[0].Visible = false;

            #region Text Boxes
            txtLength.Enabled = false;
            txtDiameter.Enabled = false;
            txtCatDesc.Enabled = false;
            txtSizeDesc.Enabled = false;
            txtItemDesc.Enabled = false;
            txtAltDesc.Enabled = false;
            txtAltDesc2.Enabled = false;
            txtAltDesc3.Enabled = false;
            txtAltSize.Enabled = false;
            txtCustNo.Enabled = false;
            txtRoutingNo.Enabled = false;
            txtParent.Enabled = false;
            txtListPrice.Enabled = false;
            txt100Wght.Enabled = false;
            txtNetWght.Enabled = false;
            txtSuperUOMQty.Enabled = false;
            //txtDtlBaseQty.Enabled = false;
            if (ddlPCLBFT.SelectedValue.ToString().ToUpper().Trim() == "LB")
            {
                txtDtlBaseQty.Attributes.Add("readonly", "readonly");
            }
            else
            {
                txtDtlBaseQty.Enabled = false;
            }
            #endregion

            #region Dropdown Lists
            ddlDetails.Enabled = false;
            ddlPlating.Enabled = false;
            ddlPriceGroup.Enabled = false;
            ddlCFV.Enabled = false;
            lnkPPICd.Enabled = false;
            lnkHarmTaxCd.Enabled = false;
            ddlPCLBFT.Enabled = false;
            ddlBaseUOM.Enabled = false;
            ddlSellUOM.Enabled = false;
            ddlPurchUOM.Enabled = false;
            ddlSuperUOM.Enabled = false;
            #endregion

            #region Check Boxes
            chkWebEnabled.Enabled = false;
            chkCert.Enabled = false;
            chkHazMat.Enabled = false;
            chkFQA.Enabled = false;
            chkPtPartner.Enabled = false;
            #endregion

            #region Buttons
            BuildDescVisible("false");
            PkgUPCVisible("false");
            BulkUPCVisible("false");
            CopyVisible("false");
            DeleteVisible("false");
            SaveVisible("false");
            #endregion
        }

        pnlBody.Update();
    }

    #region Button Visibility Switches
    protected void DeleteVisible(string _switch)
    {
        if (_switch == "false" || hidSecurity.Value == "1" || hidScreenMode.Value.ToUpper() == "OFF")
            btnDelete.Visible = false;
        else
            btnDelete.Visible = true;
    }

    protected void SaveVisible(string _switch)
    {
        if (_switch == "false" || hidSecurity.Value == "1" || hidScreenMode.Value.ToUpper() == "OFF")
            btnSave.Visible = false;
        else
            btnSave.Visible = true;
    }

    protected void CopyVisible(string _switch)
    {
        if (_switch == "false" || hidSecurity.Value != "3" || hidScreenMode.Value.ToUpper() == "OFF")
            btnCopy.Visible = false;
        else
            btnCopy.Visible = true;
    }

    protected void BuildDescVisible(string _switch)
    {
        if (_switch == "false" || hidSecurity.Value == "1" || hidScreenMode.Value.ToUpper() == "OFF")
            btnBuildDesc.Visible = false;
        else
            btnBuildDesc.Visible = true;
    }

    protected void PkgUPCVisible(string _switch)
    {
        btnPkgUPC.Enabled = true;
        if (_switch == "false" || hidSecurity.Value == "1" || hidScreenMode.Value.ToUpper() == "OFF" || (hidMaintMode.Value.ToUpper() != "INS" && hidMaintMode.Value.ToUpper() != "COPY"))
            btnPkgUPC.Visible = false;
        else
            btnPkgUPC.Visible = true;
    }

    protected void BulkUPCVisible(string _switch)
    {
        btnBulkUPC.Enabled = true;
        if (_switch == "false" || hidSecurity.Value == "1" || hidScreenMode.Value.ToUpper() == "OFF" || (hidMaintMode.Value.ToUpper() != "INS" && hidMaintMode.Value.ToUpper() != "COPY"))
            btnBulkUPC.Visible = false;
        else
            btnBulkUPC.Visible = true;
    }
    #endregion Button Visibility Switches

    public void DisplayStatusMessage(string message, string messageType)
    {
        lblStatus.Font.Italic = false;
        lblStatus.Font.Bold = true;

        if ((hidMaintMode.Value.ToUpper() == "DEL" || hidMaintMode.Value.ToUpper() == "LOCK") && string.IsNullOrEmpty(message))
        {
            messageType = "fail";
            message = hidStsMsg.Value.ToString().Trim();
            hidStsMsg.Value = string.Empty;
        }

        if (hidMaintMode.Value.ToUpper() == "INS" || hidMaintMode.Value.ToUpper() == "COPY")
        {
            messageType = "fail";
            message += " [You must click 'Save' to commit this record]";
        }

        if (!string.IsNullOrEmpty(hidMaintMode.Value.ToString()))
        {
            if (hidSecurity.Value.ToString() == "1" || hidScreenMode.Value.ToUpper() == "OFF")
            {
                messageType = "fail";
                message = ((string.IsNullOrEmpty(message)) ? "Query Only (" + hidMaintMode.Value.ToString().Trim() + ")" : "Query Only (" + hidMaintMode.Value.ToString().Trim() + "): " + message);
            }
            else
            {
                message = ((string.IsNullOrEmpty(message)) ? hidMaintMode.Value.ToString().Trim() + " Mode" : hidMaintMode.Value.ToString().Trim() + " Mode: " + message);
            }
        }

        if (!string.IsNullOrEmpty(hidStsMsg.Value.ToString()) && _devDisp.ToUpper() == "YES")
        {
            message += " {" + hidStsMsg.Value.ToString().Trim() + "}";
        }
        hidStsMsg.Value = string.Empty;

        lblStatus.Text = message;
        if (messageType.ToLower() == "success")
            lblStatus.ForeColor = System.Drawing.Color.Green;

        if (messageType.ToLower() == "fail")
            lblStatus.ForeColor = System.Drawing.Color.Red;

        pnlStatus.Update();
    }

    private void DetailStatusMessage(string message, string messageType)
    {
        if (string.IsNullOrEmpty(message))
        {
            message = ddlDetails.SelectedValue.ToString().Trim() + " detail data";
            messageType = "success";
        }

        lblDtlStatus.Font.Italic = false;
        lblDtlStatus.Font.Bold = true;
        lblDtlStatus.Text = message;
        if (messageType.ToLower() == "success")
            lblDtlStatus.ForeColor = System.Drawing.Color.Green;

        if (messageType.ToLower() == "fail")
            lblDtlStatus.ForeColor = System.Drawing.Color.Red;

        pnlDtlStatus.Update();
    }

    private void UpdatePanels()
    {
        pnlPrompt.Update();
        pnlBody.Update();
        pnlWrkFld.Update();
        pnlButtons.Update();
    }
    #endregion Screen Utilities

    #region Close Session
    //[Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ClearSession()
    {
        //Empty all Session Variables
        Session["dtIM"] = null;
        Session["dtUOM"] = null;
        Session["dtUOMDivisor"] = null;
        Session["dtUPC"] = null;
        Session["dtCat"] = null;
        Session["dtParent"] = null;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ClearSetup()
    {
        ClearSession();

        //Clear temp SETUP records
        try
        {
            _sessID = Session["UserName"].ToString().Trim() + Session["SessionID"].ToString().Trim();
            dsItemMaint = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", ""),
                                                                      new SqlParameter("@OrigID", ""),
                                                                      new SqlParameter("@SessID", _sessID),
                                                                      new SqlParameter("@Mode", "CLEAR"));

            return "";
        }
        catch (Exception ex) { return ""; }
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string Release(string _itemID, string _itemNo, string _lblUPC, string _hidUPC, string _lockStatus, string _lockUser)
    {
        if (hidSecurity.Value.ToString().Trim() == "1")
            return "";
        
        //if (string.IsNullOrEmpty(_itemID)) _itemID = hidItemID.Value.ToString().Trim();
        //if (string.IsNullOrEmpty(_itemNo)) _itemNo = lblItemNo.Text.ToString().Trim();
        //if (string.IsNullOrEmpty(_lblUPC)) _lblUPC = txtLblUPCCd.Text.ToString().Trim();
        //if (string.IsNullOrEmpty(_hidUPC)) _hidUPC = hidUPCCd.Value.ToString().Trim();
        //if (string.IsNullOrEmpty(_lockStatus)) _lockStatus = hidLockStatus.Value.ToString().Trim();
        //if (string.IsNullOrEmpty(_lockUser)) _lockUser = hidLockUser.Value.ToString().Trim();

        ReleaseLock("ItemMaster", _itemID, "IMM", _lockStatus, _lockUser);

        //Synch the ItemUPC records releaseing any unassigned records
        if (!string.IsNullOrEmpty(_lblUPC) && _lblUPC != _hidUPC)
        {
            _lblUPC = _hidUPC;
            try
            {
                dsNewUPC = SqlHelper.ExecuteDataset(cnERP, UPCProcName, new SqlParameter("@ItemNo", _itemNo),
                                                                        new SqlParameter("@UPCCd", _lblUPC),
                                                                        new SqlParameter("@UPCType", ""),
                                                                        new SqlParameter("@Mode", "SETNEW"),
                                                                        new SqlParameter("@User", Session["UserName"].ToString().Trim()));
            }
            catch (Exception ex) { return ""; }
        }
        txtLblUPCCd.Text = _lblUPC;
        return "";
    }

    protected void btnHidClearSession_Click(object sender, EventArgs e)
    {
        Release(hidItemID.Value.ToString().Trim(),lblItemNo.Text.ToString().Trim(),txtLblUPCCd.Text.ToString().Trim(),hidUPCCd.Value.ToString().Trim(),hidLockStatus.Value.ToString().Trim(),hidLockUser.Value.ToString().Trim());
        ClearSetup();

        //Empty all Hidden Fields
        hidMaintMode.Value = string.Empty;
        hidScreenMode.Value = string.Empty;
        hidItemID.Value = string.Empty;
        hidItemNo.Value = string.Empty;
        hidCatNo.Value = string.Empty;
        hidCatDesc.Value = string.Empty;
        hidUPCID.Value = string.Empty;
        hidUPCCd.Value = string.Empty;
        hidBaseQtyPer.Value = "1";
        //hidPieceQty.Value = "1";
        hidDelItem.Value = string.Empty;
        hidDelUOM.Value = string.Empty;
        hidInsConf.Value = string.Empty;
        hidStsMsg.Value = string.Empty;

        //Empty all DataSets & DataTables
        dsItemMaint = null;
        dsNewUPC = null;
        dsParent = null;
        dtIM = null;
        dtUOM = null;
        dtUOMDivisor = null;
        dtCat = null;
        dtUPC = null;
        dtNewUPC = null;
        dtParent = null;

        smItemMaint.SetFocus(txtSourceItem);
        ClearPrompt();
        ClearDisplay();
        lblStatus.Text = string.Empty;
        pnlStatus.Update();
        UpdatePanels();
    }
    #endregion Close Session

    #region Soft Locks
    public void CheckLock(string _lockTable, string _lockID, string _lockApp)
    {
        if (hidSecurity.Value.ToString().Trim() == "1")
            return;

        DataTable _dtLock = new DataTable();
        _dtLock = MaintLock(_lockTable.ToString(), "Lock", _lockID.ToString(), _lockApp.ToString());
        hidLockStatus.Value = _dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        hidLockUser.Value = _dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
        lblLockInfo.Text = "ID=" + hidItemID.Value.ToString().Trim() + " | No=" + hidItemNo.Value.ToString().Trim() + " | Sts=" + hidLockStatus.Value.ToString().Trim() + " | User=" + hidLockUser.Value.ToString().Trim();
    }

    public void ReleaseLock(string _lockTable, string _lockID, string _lockApp, string _lockStatus, string _lockUser)
    {
        if (hidSecurity.Value.ToString().Trim() == "1")
            return;

        if (_lockStatus == "SL")
        {
            //Release the current record
            MaintLock(_lockTable.ToString(), "Release", _lockID.ToString(), _lockApp.ToString());
            lblLockInfo.Text = "ID=" + _lockID.ToString().Trim() + " | No=" + hidItemNo.Value.ToString().Trim() + " | Sts=Released | User:" + _lockUser.ToString().Trim();
        }
    }

    public DataTable MaintLock(string _lockTable, string lockFunction, string _lockID, string _lockApp)
    {
        if (hidSecurity.Value.ToString().Trim() == "1")
            return null;
        
        try
        {
            DataSet dsLock = SqlHelper.ExecuteDataset(cnERP, "pSoftLock",
                                          new SqlParameter("@resource", _lockTable),
                                          new SqlParameter("@function", lockFunction),
                                          new SqlParameter("@key", _lockID),
                                          new SqlParameter("@uid", Session["UserName"].ToString().Trim()),
                                          new SqlParameter("@curApplication", _lockApp));

            if (dsLock != null && dsLock.Tables[0].Rows.Count > 0)
                return dsLock.Tables[0];
            else
                return null;
        }
        catch (Exception ex)
        {
            DisplayStatusMessage(ex.Message, "fail");
            return null;
        }
    }
    #endregion Soft Locks

    #region Security
    private void GetSecurity()
    {
        //Level 1: Query Only - No Change or Copy
        //Level 2: Query & Change - No Copy
        //Level 3: Query, Change & Copy
        
        string chkSecurity = string.Empty;
        hidSecurity.Value = "none";

        chkSecurity = Security.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.ItemMaintenance3);
        if (chkSecurity != "")
        {
            hidSecurity.Value = "3";   //Query, Change & Copy
        }
        else
        {
            chkSecurity = Security.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.ItemMaintenance2);
            if (chkSecurity != "")
            {
                hidSecurity.Value = "2";   //Query & Change - No Copy
            }
            else
            {
                chkSecurity = Security.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.ItemMaintenance1);
                if (chkSecurity != "")
                {
                    hidSecurity.Value = "1";   //Query Only - No Change or Copy
                }
                else
                {
                    hidSecurity.Value = "none";
                }
            }
        }

        //hidSecurity.Value = "1";
        //DisplayStatusMessage("Security code = " + chkSecurity + " -- Level: " + hidSecurity.Value, "fail");

        switch (hidSecurity.Value.ToString())
        {
            case "none":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
                break;
            case "3":   //Query, Change & Copy
                break;
            case "2":   //Query & Change - No Copy
                break;
            case "1":   //Query Only - No Change or Copy
                DisplayStatusMessage("", "fail");
                ToggleScreen("OFF");
                break;
        }

        pnlBody.Update();
    }
    #endregion Security
}