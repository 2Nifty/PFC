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
    string IMProcName = "pTempIMaint5";
    string UPCProcName = "pTempItemUPC2";
    DataSet dsItemMaint, dsNewUPC, dsParent;
    DataTable dtIM, dtUOM, dtUOMDivisor, dtCat, dtUPC, dtNewUPC, dtParent;
    string strSQL = string.Empty;
    string _uomMsg = string.Empty;

    //Session Variables to hold the Datatables
    //  Session["dtIM"]
    //  Session["dtUOM"]
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
        }
    }
    #endregion Page Load

    #region Find & Validate the Item Data
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    //This Method fires at the beginning of the CheckItem javascript to validate the itemNo
    //Primary Method to read & validate all of the data records and store the data in session variables
    //Tables[0] = ItemMaster
    //Tables[1] = ItemUOM
    //Tables[2] = ItemUPC
    //Tables[3] = CategoryDesc (from List)
    //Tables[4] = ItemUMDivisor (from List)
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
        if (dsItemMaint.Tables[3].Rows.Count > 0)
        {
            dtCat = dsItemMaint.Tables[3].DefaultView.ToTable();
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

            //Did we get a UPC records?
            if (dsItemMaint.Tables[2].Rows.Count > 0)
            {
                dtUPC = dsItemMaint.Tables[2].DefaultView.ToTable();
                Session["dtUPC"] = dtUPC;
            }

            //Did we get UOM Divisor records?
            //if (dsItemMaint.Tables[4].Rows.Count > 0)
            //{
                dtUOMDivisor = dsItemMaint.Tables[4].DefaultView.ToTable();
                Session["dtUOMDivisor"] = dtUOMDivisor;
            //}

            return "true";
        }
        else
        {
            //ItemFound = false
            if (dsItemMaint.Tables[3].Rows.Count > 0)
            {
                return "false"; //Item does not exist BUT the Category IS valid
            }
            else
            {
                return "nocat"; //Item does not exist AND the Category is NOT valid
            }
        }
    }

    //This Method fires at the beginning of the CheckItem javascript to validate the ParentItem (OnChange only)
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
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





    #region Soft Locks
    public void CheckLock(string _lockTable, string _lockID, string _lockApp)
    {
        DataTable _dtLock = new DataTable();
        _dtLock = MaintLock(_lockTable.ToString(), "Lock", _lockID.ToString(), _lockApp.ToString());
        hidLockStatus.Value = _dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        hidLockUser.Value = _dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
    }

    public void ReleaseLock(string _lockTable, string _lockID, string _lockApp)
    {
        //string _msg = "Sts: " + hidLockStatus.Value.ToString().Trim() + " - Table: " + _lockTable.ToString() + " - ID: " + _lockID.ToString() + " - App: " + _lockApp.ToString();
        //ScriptManager.RegisterClientScriptBlock(pnlBody, typeof(UpdatePanel), "Script", "alert('" + _msg.ToString() + "');", true);

        if (hidLockStatus.Value.ToString().Trim() == "SL")
        {
            //Release the current record
            MaintLock(_lockTable.ToString(), "Release", _lockID.ToString(), _lockApp.ToString());
        }
    }


    #region Commented Lock Code
    //[Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    //public void ReleaseLock()
    //{
    //    ReleaseLock("IMMItemMaster", Session["ItemID"].ToString(), "IMM", Session["IMMLockStatus"].ToString());
    //}

    //public DataTable SetLock(string _lockTable, string _lockID, string _lockApp)
    //{
    //    try
    //    {
    //        DataTable dtLock = new DataTable();
    //        dtLock = MaintLock(_lockTable.ToString(), "Lock", _lockID.ToString(), _lockApp.ToString());
    //        return dtLock.DefaultView.ToTable();
    //    }
    //    catch (Exception ex) { return null; }
    //}

    //public void ReleaseLock(string _lockTable, string _lockID, string _lockApp, string lockStatus)
    //{
    //    try
    //    {
    //        if (lockStatus.ToString() == "SL")
    //            MaintLock(_lockTable.ToString(), "Release", _lockID.ToString(), _lockApp.ToString());
    //    }
    //    catch (Exception ex) { }
    //}
    #endregion Commented Lock Code

    public DataTable MaintLock(string _lockTable, string lockFunction, string _lockID, string _lockApp)
    {
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





    //This Method fires [btnHidSubmitSource.click] at the end of the CheckItem javascript after the itemNo has been validated
    protected void btnHidSubmitSource_Click(object sender, EventArgs e)
    {
        if (hidMaintMode.Value.ToUpper() == "CLEAR")
        {
            hidMaintMode.Value = "";
            ClearPrompt();
            ClearDisplay();
        }
        DisplayStatusMessage("", "success");

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
            ClearDisplay();
            if (hidScreenMode.Value.ToUpper() == "OFF" && hidSecurity.Value != "1")
                ToggleScreen("ON");

            ReleaseLock("ItemMaster", hidItemID.Value.ToString().Trim(), "IMM");

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
                lblLockInfo.Text = "Sts: " + hidLockStatus.Value.ToString().Trim() + " - User: " + hidLockUser.Value.ToString().Trim();
                if (hidLockStatus.Value.ToString().Trim() == "L")
                {
                    hidMaintMode.Value = "LOCK";
                    ToggleScreen("OFF");
                    hidStsMsg.Value = "Record Locked By " + hidLockUser.Value.ToString().Trim();
                    DisplayStatusMessage(hidStsMsg.Value.ToString(), "fail");
                    //ScriptManager.RegisterClientScriptBlock(pnlCatGrid, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
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

            //TMD: [pend] Eventually, this will be dependent upon ddlDetails
            if (dtUOM != null)
                UOMDetails("ALL");  //We still want to execute UOMDetails even if there are no rows in dtUOM
            #endregion EDIT Mode
        }

        //ItemMaster Record NOT Found (INS)
        if (hidMaintMode.Value.ToUpper() == "INS")
        {
            #region INSERT Mode
            ClearDisplay();
            if (hidScreenMode.Value.ToUpper() == "OFF" && hidSecurity.Value != "1")
                ToggleScreen("ON");

            if (hidInsConf.Value.ToUpper().Trim() == "TRUE")
            {
                //INSERT the new item record to create the database defaults
                //Read the record back and display to the screen
                #region INSERT Mode = TRUE
                try
                {
                    dsItemMaint = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", txtSourceItem.Text.ToString().Trim()),
                                                                              new SqlParameter("@OrigID", ""),
                                                                              new SqlParameter("@SessID", Session["SessionID"].ToString().Trim()),
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

                #region ItemUPC Record (INS)
                if (dsItemMaint.Tables[2].Rows.Count > 0)
                {
                    dtUPC = dsItemMaint.Tables[2].DefaultView.ToTable();
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
                if (dsItemMaint.Tables[3].Rows.Count > 0)
                {
                    dtCat = dsItemMaint.Tables[3].DefaultView.ToTable();
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

                //TMD: [pend] Eventually, this will be dependent upon ddlDetails
                if (dtUOM != null)
                    UOMDetails("ALL");  //We still want to execute UOMDetails even if there are no rows in dtUOM

                DisplayStatusMessage("Database defaults created.", "fail");
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
                    try
                    {
                        dsItemMaint = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", txtDestItem.Text.ToString().Trim()),
                                                                                  new SqlParameter("@OrigID", hidItemID.Value.ToString().Trim()),
                                                                                  new SqlParameter("@SessID", Session["SessionID"].ToString().Trim()),
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
                        Session["dtUOM"] = dtUOM;
                        gvItemUOM_Bind();
                    }
                    else
                    {
                        ItemUOMError("");
                    }
                    #endregion ItemUM Record (COPY)

                    #region ItemUPC Record (COPY)
                    if (dsItemMaint.Tables[2].Rows.Count > 0)
                    {
                        dtUPC = dsItemMaint.Tables[2].DefaultView.ToTable();
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

                    if (dsItemMaint.Tables[3].Rows.Count > 0)
                    {
                        dtCat = dsItemMaint.Tables[3].DefaultView.ToTable();
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
                        txtSizeDesc.Text = string.Empty;
                    }
                    #endregion Check if SizeNo has changed

                    #region Clear screen data that does not move from source item
                    txtVar.Text = txtDestItem.Text.ToString().Substring(11, 3).Trim();
                    lblItemNo.Text = txtDestItem.Text.ToString().Trim();
                    txtLength.Text = string.Empty;
                    txtDiameter.Text = string.Empty;
                    txtItemDesc.Text = string.Empty;
                    lblUPCCd.Text = string.Empty;
                    txtAltDesc.Text = string.Empty;
                    txtAltDesc2.Text = string.Empty;
                    txtAltDesc3.Text = string.Empty;
                    txtAltSize.Text = string.Empty;
                    txtCustNo.Text = string.Empty;
                    txtRoutingNo.Text = string.Empty;
                    txtParent.Text = string.Empty;
                    lblBOMInd.Text = string.Empty;
                    ddlCFV.SelectedIndex = -1;
                    ddlPPICd.SelectedIndex = -1;
                    ddlHarmTaxCd.SelectedIndex = -1;
                    #endregion Clear screen data that does not move from source item

                    DisplayStatusMessage("Copy from item " + txtSourceItem.Text.ToString().Trim() + " to " + txtDestItem.Text.ToString().Trim(), "fail");
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
        lblUPCCd.Text = dtIM.Rows[0]["UPCCd"].ToString().Trim();
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
            ddlCFV.SelectedValue = dtIM.Rows[0]["CorpFixedVelocity"].ToString().Trim();
        }
        catch
        {
            ddlCFV.SelectedIndex = -1;
        }

        try
        {
            ddlPPICd.SelectedValue = dtIM.Rows[0]["PPICode"].ToString().Trim();
        }
        catch
        {
            ddlPPICd.SelectedIndex = -1;
        }

        try
        {
            ddlHarmTaxCd.SelectedValue = dtIM.Rows[0]["HarmonizingCd"].ToString().Trim();
        }
        catch
        {
            ddlHarmTaxCd.SelectedIndex = -1;
        }

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
        txt100Wgt.Text = String.Format("{0:0.000}", dtIM.Rows[0]["HundredWght"]);
        lblGrossWght.Text = String.Format("{0:0.000}", dtIM.Rows[0]["GrossWght"]);
        txtNetWght.Text = String.Format("{0:0.000}", dtIM.Rows[0]["NetWght"]);
        lblDensity.Text = String.Format("{0:0.00000}", Convert.ToDecimal(dtIM.Rows[0]["GrossWght"]) - Convert.ToDecimal(dtIM.Rows[0]["NetWght"]));

        try
        {
            ddlPCLBFT.SelectedValue = dtIM.Rows[0]["PCLBFTInd"].ToString().Trim();
        }
        catch
        {
            ddlPCLBFT.SelectedIndex = -1;
        }

        try
        {
            ddlBaseUOM.SelectedValue = dtIM.Rows[0]["BaseUOM"].ToString().Trim();
        }
        catch
        {
            ddlBaseUOM.SelectedIndex = -1;
        }

        lblBaseUOMQty.Text = String.Format("{0:0.0#####}", dtIM.Rows[0]["BaseUOMQty"]);
        lblPcsPerPT.Text = String.Format("{0:0.0#####}", dtIM.Rows[0]["PcsPerPallet"]);

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

        txtSuperUOMQty.Text = String.Format("{0:0.0#####}", dtIM.Rows[0]["SuperUOMQty"]);

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

    #region Item Details
    //Currently the only 'Item Details' we are dealing with is the ItemUM data (hard coded)
    //The plan is to drive ddlDetails from a list (InvItemDetails) which will determine which table/grid/div/panel to display
    //TMD: [YES] I believe the best plan of attack is to create individual tables/grids/divs/panels within pnlItemDetails

    #region ItemUM Details [tblItemUOM]
    private void UOMDetails(string _processCode)
    {
        _uomMsg = string.Empty;

        gvItemUOM_Bind();

        if (hidScreenMode.Value.ToUpper() != "OFF" && hidSecurity.Value != "1")
        {
            try
            {
                //Check the selected PC / LB / FT record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "PCLBFT")
                {
                    #region Edit PC / LB / FT
                    if (!string.IsNullOrEmpty(ddlPCLBFT.SelectedValue.ToString().Trim()))
                    {
                        //Bind the editable PC/LB/FT UOM record
                        string expr = "UOM = '" + ddlPCLBFT.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UpdStatus >= 0";
                        }
                        DataRow[] dr = dtUOM.Select(expr);

                        if (dr.Length > 0)
                        {
                            lblItemUOM.Text = dr[0]["UOM"].ToString().Trim();
                            txtDtlBaseQty.Text = String.Format("{0:0.0#####}", dr[0]["AltQty"]);
                            lblUOMQtyPer.Text = String.Format("{0:0.0#####}", dr[0]["QtyPer"]);
                            tblUOMEdit.Visible = true;
                            lblBaseUOMQty.Text = txtDtlBaseQty.Text;
                            //txtSuperUOMQty.Text = UpdateSuperUOM(_processCode.ToUpper(), Convert.ToDecimal(lblPcsPerPT.Text), Convert.ToDecimal(dr[0]["AltQty"]));
                            DisplayStatusMessage("", "success");
                        }
                        else
                        {
                            //INSERT the missing ItemUM record into the DataTable
                            if (hidScreenMode.Value.ToUpper() != "OFF" && hidSecurity.Value != "1")
                            {
                                InsertItemUM(ddlPCLBFT.SelectedValue.ToString().Trim(), 0, 0);
                                UOMDetails("PCLBFT");
                                _uomMsg = BuildDetailMessage(_uomMsg, ddlPCLBFT.SelectedValue.ToString().Trim() + " created");
                                if (_processCode.ToUpper() != "ALL")
                                {
                                    DetailStatusMessage(_uomMsg, "fail");
                                    return;
                                }
                            }
                        }
                    }
                    else
                    {
                        //No PC/LB/FT Selected
                        tblUOMEdit.Visible = false;
                        _uomMsg = BuildDetailMessage(_uomMsg, "No PC/LB/FT Selected");
                    }
                    #endregion Edit PC / LB / FT
                }

                //Check the selected Base UOM record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "BASE")
                {
                    #region Base UOM
                    if (!string.IsNullOrEmpty(ddlBaseUOM.SelectedValue.ToString().Trim()))
                    {
                        //Bind the selected Base UOM record
                        string expr = "UOM = '" + ddlBaseUOM.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UpdStatus >= 0";
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
                            _uomMsg = BuildDetailMessage(_uomMsg, ddlBaseUOM.SelectedValue.ToString().Trim() + " created");
                            if (_processCode.ToUpper() != "ALL")
                            {
                                DetailStatusMessage(_uomMsg, "fail");
                                return;
                            }
                        }
                    }
                    else
                    {
                        hidBaseQtyPer.Value = "1";
                        _uomMsg = BuildDetailMessage(_uomMsg, "No Base UOM Selected");
                    }
                    #endregion Base UOM
                }

                //Check the selected Super UOM record
                if (_processCode.ToUpper() == "ALL" || _processCode.ToUpper() == "SUPER")
                {
                    #region Super UOM
                    if (!string.IsNullOrEmpty(ddlSuperUOM.SelectedValue.ToString().Trim()))
                    {
                        //Bind the selected Super UOM record
                        string expr = "UOM = '" + ddlSuperUOM.SelectedValue.ToString().Trim() + "'";
                        if (hidMaintMode.Value.ToUpper() != "DEL")
                        {
                            //Filter out UOM records with DeleteDt set
                            expr += " AND UpdStatus >= 0";
                        }
                        DataRow[] dr = dtUOM.Select(expr);

                        if (dr.Length > 0)
                        {
                            //Super UOM found
                            if (_processCode.ToUpper() != "ALL")
                            {
                                txtSuperUOMQty.Text = String.Format("{0:0.0#####}", dr[0]["QtyPer"]);
                                lblPcsPerPT.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text) * Convert.ToDecimal(lblBaseUOMQty.Text));
                            }
                        }
                        else
                        {
                            //INSERT the missing ItemUM record into the DataTable
                            InsertItemUM(ddlSuperUOM.SelectedValue.ToString().Trim(), 0, Convert.ToDecimal(txtSuperUOMQty.Text));
                            UOMDetails("SUPER");
                            _uomMsg = BuildDetailMessage(_uomMsg, ddlSuperUOM.SelectedValue.ToString().Trim() + " created");
                            if (_processCode.ToUpper() != "ALL")
                            {
                                DetailStatusMessage(_uomMsg, "fail");
                                return;
                            }
                        }
                    }
                    else
                    {
                        _uomMsg = BuildDetailMessage(_uomMsg, "No Super UOM Selected");
                    }
                    #endregion Super UOM
                }
            }
            catch (Exception ex)
            {
                ItemUOMError(ex.Message);
            }
        }

        DetailStatusMessage(_uomMsg, "fail");
        pnlItemDetails.Update();
    }

    #region GridView ItemUM
    protected void gvItemUOM_Bind()
    {
        lblPCQty.Text = string.Empty;
        try
        {
            if (hidMaintMode.Value.ToUpper() != "DEL")
            {
                //Filter out UOM records with DeleteDt set
                dtUOM.DefaultView.RowFilter = "UpdStatus >= 0";
                gvItemUOM.DataSource = dtUOM.DefaultView.ToTable();
            }
            else
            {
                gvItemUOM.DataSource = dtUOM;
            }

            hidPieceQty.Value = "1";
            gvItemUOM.DataBind();
            gvItemUOM.Visible = true;
            tblItemUOM.Visible = true;
            divDtlStatus.Visible = true;
            //DetailStatusMessage("Item UOM detail data", "success");
        }
        catch (Exception ex)
        {
            ItemUOMError(ex.Message);
        }
    }

    protected void gvItemUOM_RowDataBound(object sender, GridViewRowEventArgs e)
    {
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

            if (e.Row.Cells[1].Text.ToString().Trim() == "PC" || e.Row.Cells[1].Text.ToString().Trim() == "LB")
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

    protected void gvItemUOM_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (hidDelUOM.Value == "true")
        {
            dtUOM = (DataTable)Session["dtUOM"];
            if (dtUOM != null && dtUOM.Rows.Count > 0)
            {
                foreach (DataRow dr in dtUOM.Rows)
                {
                    if (gvItemUOM.Rows[e.RowIndex].Cells[1].Text.ToString().Trim() == dr["UOM"].ToString().Trim())
                    {
                        dr["UpdStatus"] = -1; //-1=DELETE ItemUM
                    }
                }
            }
            gvItemUOM_Bind();
            Session["dtUOM"] = dtUOM;
        }
    }
    #endregion

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
        drNewUOM["AltQty"] = _altQty;
        drNewUOM["QtyPer"] = _qtyPer;
        drNewUOM["UOMDivisor"] = _divisor;
        drNewUOM["UpdStatus"] = 2; //2=INSERT new ItemUM
        dtUOM.Rows.Add(drNewUOM);
    }

    protected void UpdateItemUM(string _uom, decimal _altQty, decimal _qtyPer)
    {
        //Update the existing record in dtUOM
        foreach (DataRow dr in dtUOM.Rows)
        {
            if (dr["UOM"].ToString().Trim() == _uom)
            {
                dr["AltQty"] = _altQty;
                dr["QtyPer"] = _qtyPer;
                if (Convert.ToInt32(dr["UpdStatus"]) == 0)
                    dr["UpdStatus"] = 1; //1=UPDATE ItemUM
            }
        }
    }

    protected string UpdateSuperUOM(string _processCode, decimal _pcsPerPT, decimal _baseQty)
    {
        string _superUOM = "0.0";

        if (_baseQty != 0)
        {
            _superUOM = string.Format("{0:0.0#####}", _pcsPerPT / _baseQty);
        }

        if (_processCode.ToUpper() == "SUPER")
        {
            //Update the existing SuperUMQty in dtUOM
            foreach (DataRow dr in dtUOM.Rows)
            {
                if (dr["UOM"].ToString().Trim() == ddlSuperUOM.SelectedValue.ToString().Trim())
                {
                    dr["QtyPer"] = Convert.ToDecimal(_superUOM);
                    if (Convert.ToInt32(dr["UpdStatus"]) == 0)
                        dr["UpdStatus"] = 1; //1=UPDATE ItemUM
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
        gvItemUOM.Visible = false;
        tblItemUOM.Visible = false;
        divDtlStatus.Visible = false;
        DisplayStatusMessage("Item UOM detail data not found " + _exception, "fail");
    }
    #endregion UOMErrors
    
    #endregion ItemUM Details [tblItemUOM]

    #endregion Item Details

    #region Button & Change Events

    #region UPC Builder
    protected void btnPkgUPC_Click(object sender, ImageClickEventArgs e)
    {
        dtNewUPC = NewUPC("PKG");
        if (dtNewUPC != null && dtNewUPC.Rows.Count > 0)
        {
            lblUPCCd.Text = dtNewUPC.Rows[0]["UpcCd"].ToString().Trim();
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
            lblUPCCd.Text = dtNewUPC.Rows[0]["UpcCd"].ToString().Trim();
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
                                                                            new SqlParameter("@User", ""));
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

    #region ItemUOM Changes
    protected void txtDtlBaseQty_TextChanged(object sender, EventArgs e)
    {
        DisplayStatusMessage("", "success");
        
        dtUOM = (DataTable)Session["dtUOM"];

        if (string.IsNullOrEmpty(txtDtlBaseQty.Text))
        {
            txtDtlBaseQty.Text = "0.0";
            lblUOMQtyPer.Text = "0.0";
        }
        else
        {
            txtDtlBaseQty.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtDtlBaseQty.Text));
            lblUOMQtyPer.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(hidBaseQtyPer.Value) / Convert.ToDecimal(txtDtlBaseQty.Text));
        }
        lblBaseUOMQty.Text = txtDtlBaseQty.Text;
        //txtSuperUOMQty.Text = UpdateSuperUOM("SUPER", Convert.ToDecimal(lblPcsPerPT.Text), Convert.ToDecimal(txtDtlBaseQty.Text));

        //Update the existing record in dtUOM
        foreach (DataRow dr in dtUOM.Rows)
        {
            if (Convert.ToDecimal(dr["UOMDivisor"]) != 0)
            {
                dr["AltQty"] = Convert.ToDecimal(lblBaseUOMQty.Text) / Convert.ToDecimal(dr["UOMDivisor"]);
                dr["QtyPer"] = Convert.ToDecimal(dr["UOMDivisor"]) * Convert.ToDecimal(lblUOMQtyPer.Text);
                if (Convert.ToInt32(dr["UpdStatus"]) == 0)
                    dr["UpdStatus"] = 1; //1=UPDATE ItemUM
            }
        }

        UpdateItemUM(lblItemUOM.Text.ToString().Trim(), Convert.ToDecimal(txtDtlBaseQty.Text), Convert.ToDecimal(lblUOMQtyPer.Text));
        gvItemUOM_Bind();

        //Re-calc net & gross weight when the Base Qty changes
        if (lblItemUOM.Text.ToString().Trim() == "LB")
        {
            txtNetWght.Text = txtDtlBaseQty.Text.ToString().Trim();
            txt100Wgt.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text) * 100 / Convert.ToDecimal(hidPieceQty.Value));
        }
        else
        {
            txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtDtlBaseQty.Text) / 100 * Convert.ToDecimal(txt100Wgt.Text));
        }
        //txt100Wgt.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text) * 100 / Convert.ToDecimal(txtDtlBaseQty.Text));
        lblGrossWght.Text = CalcGross();
        PoundUOM();
        DetailStatusMessage(_uomMsg, "success");

        Session["dtUOM"] = dtUOM;
        pnlBody.Update();
    }
    
    protected void ddlPCLBFT_SelectedIndexChanged(object sender, EventArgs e)
    {
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("PCLBFT");
        Session["dtUOM"] = dtUOM;
    }

    protected void ddlBaseUOM_SelectedIndexChanged(object sender, EventArgs e)
    {
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("BASE");
        Session["dtUOM"] = dtUOM;
    }

    protected void ddlSuperUOM_SelectedIndexChanged(object sender, EventArgs e)
    {
        dtUOM = (DataTable)Session["dtUOM"];
        UOMDetails("Super");
        Session["dtUOM"] = dtUOM;
    }

    protected void txtSuperUOMQty_TextChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtSuperUOMQty.Text))
            txtSuperUOMQty.Text = "0.0";

        dtUOM = (DataTable)Session["dtUOM"];
        txtSuperUOMQty.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text));
        lblPcsPerPT.Text = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text) * Convert.ToDecimal(lblBaseUOMQty.Text));

        //Update the existing SuperUMQty in dtUOM
        foreach (DataRow dr in dtUOM.Rows)
        {
            if (dr["UOM"].ToString().Trim() == ddlSuperUOM.SelectedValue.ToString().Trim())
            {
                dr["QtyPer"] = String.Format("{0:0.0#####}", Convert.ToDecimal(txtSuperUOMQty.Text));
                if (Convert.ToInt32(dr["UpdStatus"]) == 0)
                    dr["UpdStatus"] = 1; //1=UPDATE ItemUM
            }
        }
        gvItemUOM_Bind();
        Session["dtUOM"] = dtUOM;
        pnlBody.Update();
    }
    #endregion ItemUOM Changes

    #region Weight
    protected void txt100Wgt_TextChanged(object sender, EventArgs e)
    {
        txt100Wgt.Text = String.Format("{0:0.000}", Convert.ToDecimal(txt100Wgt.Text));
        if (ddlPCLBFT.SelectedValue.ToString().Trim() == "LB")
        {
            txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(hidPieceQty.Value) / 100 * Convert.ToDecimal(txt100Wgt.Text));
            txtDtlBaseQty.Text = txtNetWght.Text.ToString().Trim();
        }
        else
        {
            txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtDtlBaseQty.Text) / 100 * Convert.ToDecimal(txt100Wgt.Text));
        }
        PoundUOM();
        lblGrossWght.Text = CalcGross();
        DetailStatusMessage(_uomMsg, "success");
    }

    protected void txtNetWght_TextChanged(object sender, EventArgs e)
    {
        txtNetWght.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text));
        PoundUOM();
        if (ddlPCLBFT.SelectedValue.ToString().Trim() == "LB")
        {
            txt100Wgt.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text) * 100 / Convert.ToDecimal(hidPieceQty.Value));
            txtDtlBaseQty.Text = txtNetWght.Text.ToString().Trim();
        }
        else
        {
            txt100Wgt.Text = String.Format("{0:0.000}", Convert.ToDecimal(txtNetWght.Text) * 100 / Convert.ToDecimal(txtDtlBaseQty.Text));
        }
        lblGrossWght.Text = CalcGross();
        DetailStatusMessage(_uomMsg, "success");
    }

    protected void txtRoutingNo_TextChanged(object sender, EventArgs e)
    {
        lblGrossWght.Text = CalcGross();
    }

    protected void PoundUOM()
    {
        dtUOM = (DataTable)Session["dtUOM"];
        string expr = "UOM = 'LB'";
        //Filter out UOM records with DeleteDt set
        expr += " AND UpdStatus >= 0";

        DataRow[] dr = dtUOM.Select(expr);

        if (dr.Length > 0)
        {
            UpdateItemUM("LB", Convert.ToDecimal(txtNetWght.Text), 1 / Convert.ToDecimal(txtNetWght.Text));
            //_uomMsg = BuildDetailMessage(_uomMsg, "'LB' record updated");
        }
        else
        {
            if (hidScreenMode.Value.ToUpper() != "OFF" && hidSecurity.Value != "1")
            {
                InsertItemUM("LB", Convert.ToDecimal(txtNetWght.Text), 1 / Convert.ToDecimal(txtNetWght.Text));
                _uomMsg = BuildDetailMessage(_uomMsg, "'LB' record created");
            }
        }

        gvItemUOM_Bind();
        Session["dtUOM"] = dtUOM;
        pnlBody.Update();
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

    #region Buttons
    protected void btnBuildDesc_Click(object sender, ImageClickEventArgs e)
    {
        BuildItemDesc();
    }

    protected void btnCopy_Click(object sender, ImageClickEventArgs e)
    {
        lblSourceItem.Text = "From Item No";
        txtSourceItem.Enabled = false;
        tblListParam.Visible = false;
        tblDestItem.Visible = true;
        txtDestItem.Enabled = true;

        ToggleScreen("OFF");
        btnCancel.Visible = true;

        smItemMaint.SetFocus(txtDestItem);
        UpdatePanels();

        hidMaintMode.Value = "COPY";
        hidInsConf.Value = "";
        DisplayStatusMessage("Please enter the 'To Item No' above","fail");
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        if (hidDelItem.Value.ToUpper() == "TRUE")
        {
            //DELETE the selected record - SET the DeleteDt
            //TMD: Move this to stored procedure and add comments for pending business rules (?)
            #region [SQL] DELETE ItemMaster
            strSQL = "UPDATE ItemMaster " +
                     "SET    DeleteID = '" + Session["UserName"].ToString().Trim() + "', DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                     "WHERE  pItemMasterID = " + hidItemID.Value;

            try
            {
                SqlHelper.ExecuteReader(cnERP, CommandType.Text, strSQL);
                cnERP.Close();
                ReleaseLock("ItemMaster", hidItemID.Value.ToString().Trim(), "IMM");
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
            //TMD: ???
            DisplayStatusMessage("Item was NOT Deleted", "fail");
        }

        smItemMaint.SetFocus(txtSourceItem);
        UpdatePanels();
    }

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
            #region UPDATE the current ItemMaster Record
            if (string.IsNullOrEmpty(txtItemDesc.Text))
                BuildItemDesc();

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

            _listPrice = txtListPrice.Text.ToString().Trim().Replace("$", "");

            #region [SQL] Update ItemMaster
            strSQL = "UPDATE    ItemMaster " +
                     "SET       ItemNo = '" + lblItemNo.Text.ToString().Trim() + "', " +
                     "          LengthDesc = '" + txtLength.Text.ToString().Trim() + "', " +
                     "          DiameterDesc = '" + txtDiameter.Text.ToString().Trim() + "', " +
                     "          CatDesc = '" + txtCatDesc.Text.ToString().Trim() + "', " +
                     "          ItemSize = '" + txtSizeDesc.Text.ToString().Trim() + "', " +
                     "          Finish = '" + ddlPlating.SelectedValue.ToString().Trim() + "', " +
                     "          ItemDesc = '" + txtItemDesc.Text.ToString().Trim() + "', " +
                     "          UPCCd = '" + lblUPCCd.Text.ToString().Trim() + "', " +
                     "          CategoryDescAlt1 = '" + txtAltDesc.Text.ToString().Trim() + "', " +
                     "          CategoryDescAlt2 = '" + txtAltDesc2.Text.ToString().Trim() + "', " +
                     "          CategoryDescAlt3 = '" + txtAltDesc3.Text.ToString().Trim() + "', " +
                     "          SizeDescAlt1 = '" + txtAltSize.Text.ToString().Trim() + "', " +
                     "          CustNo = '" + txtCustNo.Text.ToString().Trim() + "', " +
                     "          BoxSize = '" + txtRoutingNo.Text.ToString().Trim() + "', " +
                     "          ParentProdNo = '" + txtParent.Text.ToString().Trim() + "', " +
                     "          CorpFixedVelocity = '" + ddlCFV.SelectedValue.ToString().Trim() + "', " +
                     "          PPICode = '" + ddlPPICd.SelectedValue.ToString().Trim() + "', " +
                     "          TariffCd = '" + ddlHarmTaxCd.SelectedValue.ToString().Trim() + "', " +
                     "          WebEnabledInd = " + _webInd + ", " +
                     "          CertRequiredInd = " + _certInd + ", " +
                     "          HazMatInd = " + _hazInd + ", " +
                     "          QualityInd = " + _fqaInd + ", " +
                     "          PalPtnrInd = " + _ptInd + ", " +
                     "          ListPrice = '" + _listPrice + "', " +
                     "          HundredWght = '" + txt100Wgt.Text.ToString().Trim() + "', " +
                     "          GrossWght = '" + lblGrossWght.Text.ToString().Trim() + "', " +
                     "          Wght = '" + txtNetWght.Text.ToString().Trim() + "', " +
                     "          PCLBFTInd = '" + ddlPCLBFT.SelectedValue.ToString().Trim() + "', " +
                     "          SellStkUM = '" + ddlBaseUOM.SelectedValue.ToString().Trim() + "', " +
                     "          SellStkUMQty = '" + lblBaseUOMQty.Text.ToString().Trim() + "', " +
                     "          PcsPerPallet = '" + lblPcsPerPT.Text.ToString().Trim() + "', " +
                     "          SellUM = '" + ddlSellUOM.SelectedValue.ToString().Trim() + "', " +
                     "          CostPurUM = '" + ddlPurchUOM.SelectedValue.ToString().Trim() + "', " +
                     "          SuperUM = '" + ddlSuperUOM.SelectedValue.ToString().Trim() + "', " +
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
                //DisplayStatusMessage(ex.Message, "fail");
                return;
            }
            #endregion [SQL] Update ItemMaster

            smItemMaint.SetFocus(txtSourceItem);
            if (hidMaintMode.Value.ToString().ToUpper().Trim() == "INS" || hidMaintMode.Value.ToString().ToUpper().Trim() == "COPY")
            {
                if (hidMaintMode.Value.ToString().ToUpper().Trim() == "INS")
                {
                    DisplayStatusMessage("ITEM ADDED", "success");
                    hidMaintMode.Value = "EDIT";
                    txtSourceItem.Enabled = true;
                }
                else
                {
                    //The item has been successfully copied - put the screen in EDIT mode
                    hidMaintMode.Value = "EDIT";
                    DisplayStatusMessage(txtDestItem.Text.ToString().Trim() + " COPIED FROM " + txtSourceItem.Text.ToString().Trim(), "success");

                    lblSourceItem.Text = "Item No";
                    txtSourceItem.Enabled = true;
                    txtSourceItem.Text = lblItemNo.Text.ToString().Trim();
                    txtDestItem.Text = string.Empty;
                    tblDestItem.Visible = false;
                }
            }
            else
            {
                DisplayStatusMessage("ITEM SAVED", "success");
            }
            #endregion

            dtUOM = (DataTable)Session["dtUOM"];
            if (dtUOM != null && dtUOM.Rows.Count > 0)
            {
                #region UPDATE the ItemUM records
                foreach (DataRow dr in dtUOM.Rows)
                {
                    switch (Convert.ToInt32(dr["UpdStatus"]))
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
                            }
                            catch (Exception ex)
                            {
                                DisplayStatusMessage("ItemUM Save Error (DELETE) - " + dr["UOM"].ToString().Trim() + " - " + ex.Message, "fail");
                            }
                            #endregion [SQL] UPDATE ItemUM
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
                                dr["UpdStatus"] = "0";
                            }
                            catch (Exception ex)
                            {
                                DisplayStatusMessage("ItemUM Save Error (UPDATE) - " + dr["UOM"].ToString().Trim() + " - " + ex.Message, "fail");
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
                                dr["UpdStatus"] = "0";
                            }
                            catch (Exception ex)
                            {
                                DisplayStatusMessage("ItemUM Save Error (INSERT) - " + dr["UOM"].ToString().Trim() + " - " + ex.Message, "fail");
                            }
                            #endregion [SQL] INSERT ItemUM
                            break;
                    }
                }
                gvItemUOM_Bind();
                #endregion UPDATE the ItemUM records
            }

            if (lblUPCCd.Text.ToString().Trim() != hidUPCCd.Value.ToString().Trim())
            {
                #region UPDATE the ItemUPC record
                try
                {
                    dsNewUPC = SqlHelper.ExecuteDataset(cnERP, UPCProcName, new SqlParameter("@ItemNo", lblItemNo.Text.ToString().Trim()),
                                                                            new SqlParameter("@UPCCd", lblUPCCd.Text.ToString().Trim()),
                                                                            new SqlParameter("@UPCType", ""),
                                                                            new SqlParameter("@Mode", "SETNEW"),
                                                                            new SqlParameter("@User", Session["UserName"].ToString().Trim()));
                }
                catch (Exception ex)
                {
                    DisplayStatusMessage("ItemUPC UPDATE Error (SP) - " + ex.Message, "fail");
                    //DisplayStatusMessage(ex.Message, "fail");
                }

                if (dsNewUPC.Tables[0].Rows.Count > 0)
                {
                    dtUPC = dsNewUPC.Tables[0].DefaultView.ToTable();
                    Session["dtUPC"] = dtUPC;
                    hidUPCID.Value = dtUPC.Rows[0]["pItemUPCID"].ToString().Trim();
                    hidUPCCd.Value = dtUPC.Rows[0]["UPCCd"].ToString().Trim();
                    DisplayStatusMessage("UPC SAVED", "success");
                }
                else
                {
                    dtUPC = null;
                    Session["dtUPC"] = null;
                    hidUPCID.Value = string.Empty;
                    hidUPCCd.Value = string.Empty;
                    DisplayStatusMessage("ItemUPC UPDATE Error (No Records)", "fail");
                }
                #endregion UPDATE the ItemUPC record
            }

            tblListParam.Visible = true;
            CopyVisible("true");
            DeleteVisible("true");
            btnCancel.Visible = true;
            UpdatePanels();
        }
    }
    #endregion Buttons

    #endregion Button & Change Events

    #region Screen Utilities
    private void BindDDL()
    {
        string _tableName = "CatalogPlating";
        string _columnName = "[CODE] + ' - ' + [DESCR] as ListDesc, [CODE] as ListValue";
        string _whereClause = "1=1 ORDER BY [CODE]";
        ddlBind.ddlBindControl(ddlPlating, ddlBind.ddlTable(_tableName, _columnName, _whereClause), "ListValue", "ListDesc", " ", " ");
        //ddlBind.BindFromList("ItemPlateType", ddlPlating, " ", " ");

        ddlBind.BindFromList("CVCCodes", ddlCFV, " ", " ");
        ddlBind.BindFromList("ItemPPICd", ddlPPICd, " ", " ");
        ddlBind.BindDscFromTable("GERTARIFF", ddlHarmTaxCd, " ", " ");

        ddlBind.BindFromList("ItemCalcUOM", ddlPCLBFT, " ", " ");
        ddlBind.BindFromList("UMName", ddlBaseUOM, " ", " ");
        ddlBind.BindFromList("SellPurUOM", ddlSellUOM, " ", " ");
        ddlBind.BindFromList("SellPurUOM", ddlPurchUOM, " ", " ");
        ddlBind.BindFromList("SuperEquivUOM", ddlSuperUOM, " ", " ");

        //TMD: [pend] Item Details (InvItemDetails)
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
        txtSize.Text = string.Empty;
        txtVar.Text = string.Empty;
        lblItemNo.Text = string.Empty;
        txtLength.Text = string.Empty;
        txtDiameter.Text = string.Empty;
        txtCatDesc.Text = string.Empty;
        txtSizeDesc.Text = string.Empty;
        ddlPlating.SelectedIndex = -1;
        txtItemDesc.Text = string.Empty;
        lblUPCCd.Text = string.Empty;
        txtAltDesc.Text = string.Empty;
        txtAltDesc2.Text = string.Empty;
        txtAltDesc3.Text = string.Empty;
        txtAltSize.Text = string.Empty;
        txtCustNo.Text = string.Empty;
        txtRoutingNo.Text = string.Empty;
        txtParent.Text = string.Empty;
        lblBOMInd.Text = string.Empty;
        ddlCFV.SelectedIndex = -1;
        ddlPPICd.SelectedIndex = -1;
        ddlHarmTaxCd.SelectedIndex = -1;
        chkWebEnabled.Checked = false;
        chkCert.Checked = false;
        chkHazMat.Checked = false;
        chkFQA.Checked = false;
        chkPtPartner.Checked = false;
        txtListPrice.Text = string.Empty;
        txt100Wgt.Text = string.Empty;
        txtNetWght.Text = string.Empty;
        lblGrossWght.Text = string.Empty;
        ddlPCLBFT.SelectedIndex = -1;
        ddlBaseUOM.SelectedIndex = -1;
        lblBaseUOMQty.Text = string.Empty;
        lblPcsPerPT.Text = string.Empty;
        ddlSellUOM.SelectedIndex = -1;
        ddlPurchUOM.SelectedIndex = -1;
        ddlSuperUOM.SelectedIndex = -1;
        txtSuperUOMQty.Text = string.Empty;

        //UOM Details
        tblUOMEdit.Visible = false;
        gvItemUOM.Visible = false;
        tblItemUOM.Visible = false;
        divDtlStatus.Visible = false;

        btnCancel.Visible = false;

        //Work Fields
        lblPCQty.Text = "n,nnn,nnn";
        lblDensity.Text = "nnn.nnnnnn";
        lblLockInfo.Text = "~lock info~";
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
            txt100Wgt.Enabled = true;
            txtNetWght.Enabled = true;
            txtSuperUOMQty.Enabled = true;
            txtDtlBaseQty.Enabled = true;
            #endregion

            #region Dropdown Lists
            ddlPlating.Enabled = true;
            ddlCFV.Enabled = true;
            ddlPPICd.Enabled = true;
            ddlHarmTaxCd.Enabled = true;
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
            txt100Wgt.Enabled = false;
            txtNetWght.Enabled = false;
            txtSuperUOMQty.Enabled = false;
            txtDtlBaseQty.Enabled = false;
            #endregion

            #region Dropdown Lists
            ddlPlating.Enabled = false;
            ddlCFV.Enabled = false;
            ddlPPICd.Enabled = false;
            ddlHarmTaxCd.Enabled = false;
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
        if (_switch == "false" || hidSecurity.Value == "1" || hidScreenMode.Value.ToUpper() == "OFF")
            btnPkgUPC.Visible = false;
        else
            btnPkgUPC.Visible = true;
    }

    protected void BulkUPCVisible(string _switch)
    {
        if (_switch == "false" || hidSecurity.Value == "1" || hidScreenMode.Value.ToUpper() == "OFF")
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
            message = hidStsMsg.Value;
        }

        if (hidMaintMode.Value.ToUpper() == "INS" || hidMaintMode.Value.ToUpper() == "COPY")
        {
            messageType = "fail";
            message += " [You must click 'Save' to commit this record]";
        }

        if (hidSecurity.Value.ToString() == "1" || hidScreenMode.Value.ToUpper() == "OFF")
        {
            messageType = "fail";
            message = ((string.IsNullOrEmpty(message)) ? "Query Only (" + hidMaintMode.Value.ToString().Trim() + ")" : "Query Only (" + hidMaintMode.Value.ToString().Trim() + "): " + message);
        }
        else
        {
            if (!string.IsNullOrEmpty(hidMaintMode.Value.ToString()))
                message = ((string.IsNullOrEmpty(message)) ? hidMaintMode.Value.ToString().Trim() + " Mode" : hidMaintMode.Value.ToString().Trim() + " Mode: " + message);
        }

        if (messageType.ToLower() == "success")
        {
            lblStatus.ForeColor = System.Drawing.Color.Green;
            lblStatus.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblStatus.ForeColor = System.Drawing.Color.Red;
            lblStatus.Text = message;
        }
        else
        {
            lblStatus.ForeColor = System.Drawing.Color.Black;
            lblStatus.Text = message;
        }

        pnlStatus.Update();
    }

    private void DetailStatusMessage(string message, string messageType)
    {
        if (string.IsNullOrEmpty(message))
        {
            message = "Item UOM detail data";
            messageType = "success";
        }

        lblDtlStatus.Font.Italic = false;
        lblDtlStatus.Font.Bold = true;
        if (messageType.ToLower() == "success")
        {
            lblDtlStatus.ForeColor = System.Drawing.Color.Green;
            lblDtlStatus.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblDtlStatus.ForeColor = System.Drawing.Color.Red;
            lblDtlStatus.Text = message;
        }
        else
        {
            lblDtlStatus.ForeColor = System.Drawing.Color.Black;
            lblDtlStatus.Text = message;
        }

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

    //[Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    #region Close Session
    public void ClearSession()
    {
        //TMD: remove SoftLocks & check for (remove) uncommited records
        //The SessionID has been added to the temp EntryID for the uncommited
        //  records so we know exactly which records to remove

        //TMD: Add UserID to the DeleteId

        
        //Empty all Session Variables
        Session["dtIM"] = null;
        Session["dtUOM"] = null;
        Session["dtUOMDivisor"] = null;
        Session["dtUPC"] = null;
        Session["dtCat"] = null;
        Session["dtParent"] = null;
    }

    protected void btnHidClearSession_Click(object sender, EventArgs e)
    {
        ClearSession();

        ReleaseLock("ItemMaster", hidItemID.Value.ToString().Trim(), "IMM");

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

        //Clear temp SETUP records
        //TMD: We need to add the UserName to the temp records
        try
        {
            dsItemMaint = SqlHelper.ExecuteDataset(cnERP, IMProcName, new SqlParameter("@Item", ""),
                                                                      new SqlParameter("@OrigID", ""),
                                                                      new SqlParameter("@SessID", Session["SessionID"].ToString().Trim()),
                                                                      new SqlParameter("@Mode", "CLEAR"));
        }
        catch
        {
        }

        smItemMaint.SetFocus(txtSourceItem);
        ClearPrompt();
        ClearDisplay();
        lblStatus.Text = string.Empty;
        UpdatePanels();
    }
    #endregion Close Session



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