using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
using PFC.Intranet.BusinessLogicLayer;

public partial class BillOfMaterials : System.Web.UI.Page
{
    #region Variable Declaration
    MaintenanceUtility MaintUtil = new MaintenanceUtility();

    private DataTable dtTablesData = new DataTable();
    private DataTable dtBOMDetail = new DataTable(); 

    MaintenanceUtility priorityCode = new MaintenanceUtility();
    string cnxERP = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    string _cmdText;

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";

    DataSet dsBOM = new DataSet();
    DataTable dtBOM = new DataTable();
    DataTable dtBOMItem = new DataTable();
    DataTable dtBOMChild = new DataTable();
    DataTable dtBOMUM = new DataTable();

    DataSet dsBOMDetail = new DataSet();

    SqlConnection cnERP = new SqlConnection(ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    string strSQL, sortExpression;

    FileInfo fnExcel;
    StreamWriter reportWriter;
    string PreviewURL, xlsFile, ExportFile, headerContent, excelContent, footerContent;

    private string Num0Format = "{0:####,###,##0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string DateFormat = "{0:MM/dd/yy} ";
    #endregion Variable Declaration

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(BillOfMaterials));

        if (!Page.IsPostBack)
        {
            ViewState["Mode"] = "Add";
            GetSecurity();
            if (hidSecurity.Value == "Full")
                lblReadOnly.Visible = false;
            else
            {
                lblReadOnly.Visible = true;
                ddlParentBillType.Enabled = false;
            }

            if (Request.QueryString["Mode"] != null && Request.QueryString["Mode"].ToString().ToLower() == "readonly")
            {
                lblReadOnly.Visible = true;
                ddlParentBillType.Enabled = false;
                ibtnDelete.Visible = false;
            }

            FillParentBillType();
            ClearItemInfo();
            smBOM.SetFocus(txtItemSearch);
            NewPreviewURL();

            if (!string.IsNullOrEmpty(Request.QueryString["ItemNo"]))
            {
                txtItemSearch.Text = Request.QueryString["ItemNo"].ToString().Trim();
                btnHidItemSearch_Click(btnHidItemSearch, EventArgs.Empty);
            }
        }
    }

    #region Item/BOM Find
    //This method fires after the user enters a complete item number in the search panel at the top
    protected void btnHidItemSearch_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        ScreenReset();

        #region Validate the parent item
        dtBOMItem = ValidItem(txtItemSearch.Text);
        if (dtBOMItem.Rows.Count > 0)
        {   //Valid Item Found
            #region Display ItemInfo
            hidBOMParent.Value = dtBOMItem.Rows[0]["ItemNo"].ToString();
            lblItemDesc.Text = dtBOMItem.Rows[0]["ItemDesc"].ToString();
            lblCatDesc.Text = dtBOMItem.Rows[0]["CatDesc"].ToString();
            lblPltTyp.Text = dtBOMItem.Rows[0]["PltTyp"].ToString();
            lblParentItem.Text = dtBOMItem.Rows[0]["ParentItem"].ToString();
            hidParentItem.Value = dtBOMItem.Rows[0]["ParentItem"].ToString();

            lbl100Wght.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["100Wght"]);
            lblNetWght.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["NetWght"]);
            lblGrossWght.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["GrossWght"]);
            lblStockInd.Text = dtBOMItem.Rows[0]["StockInd"].ToString();

            lblSellStk.Text = dtBOMItem.Rows[0]["SellStk"].ToString();
            lblSupEqv.Text = dtBOMItem.Rows[0]["SupEqv"].ToString();
            lblPriceUM.Text = dtBOMItem.Rows[0]["PriceUM"].ToString();
            lblCostUM.Text = dtBOMItem.Rows[0]["CostUM"].ToString();

            lblStdCost.Text = dtBOMItem.Rows[0]["StdCost"].ToString();
            lblListPrice.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["ListPrice"]);
            lblCFV.Text = dtBOMItem.Rows[0]["CFV"].ToString();
            lblCVC.Text = dtBOMItem.Rows[0]["CVC"].ToString();

            lblUPCCd.Text = dtBOMItem.Rows[0]["UPCCd"].ToString();
            lblTarrif.Text = dtBOMItem.Rows[0]["Tariff"].ToString();
            lblPPI.Text = dtBOMItem.Rows[0]["PPI"].ToString();
            lblCreateDt.Text = FormatScreenData(DateFormat, dtBOMItem.Rows[0]["CreateDt"]);

            lblWebEnabled.Text = dtBOMItem.Rows[0]["WebEnabled"].ToString();
            lblPkgGrp.Text = dtBOMItem.Rows[0]["PkgGrp"].ToString();
            lblLowProfile.Text = FormatScreenData(Num0Format, dtBOMItem.Rows[0]["LowProfile"]);
            lblPVC.Text = dtBOMItem.Rows[0]["PVC"].ToString();

            pnlItemInfo.Update();
            #endregion Display ItemInfo

            Session["dtBOMItem"] = dtBOMItem;

            dtBOM = GetBOM(txtItemSearch.Text);
            CheckBOM();
            smBOM.SetFocus(txtItemSearch);

        }
        else
        {   //No Valid Item found
            DispStatusMsg("Invalid Item. Please try again.", "fail");
            smBOM.SetFocus(txtItemSearch);
        }
        #endregion Validate the parent item

        NewPreviewURL();
    }
    #endregion Item/BOM Find

    //-------------------------------------------------------------------------------------------------//

    #region Item/BOM Add

    #region Validate the child item
    //This method fires after the user enters a complete item number in the detail panel at the bottom
    protected void btnHidItemInsert_Click(object sender, EventArgs e)   
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        DispStatusMsg("Now in " +  ViewState["Mode"].ToString().Trim() + " Mode ", "success");
        
        //Check for valid child item
        dtBOMChild = ValidItem(txtItemInsert.Text.ToString().Trim());
        if (dtBOMChild.Rows.Count > 0)
        {   //Valid Child Item Found
            hidBOMChild.Value = dtBOMChild.Rows[0]["ItemNo"].ToString();
            lblInsertItemDesc.Text = dtBOMChild.Rows[0]["ItemDesc"].ToString();
            Session["dtBOMChild"] = dtBOMChild;

                dtBOMUM = GetUM(txtItemInsert.Text.ToString().Trim());

            if (dtBOMUM.Rows.Count > 0)
            {   //Bind the UM ddl
                ddlUM.DataSource = dtBOMUM;
                ddlUM.DataValueField = dtBOMUM.Columns["ListValue"].ToString();
                ddlUM.DataTextField = dtBOMUM.Columns["ListDesc"].ToString();
                ddlUM.DataBind();
                MaintUtil.SetValueListControl(ddlUM, dtBOMChild.Rows[0]["SellStkUM"].ToString());
            }

            if (ViewState["Mode"] != null && ViewState["Mode"].ToString().ToLower() != "edit")
            {
                FillBOMBillType();

                if (hidBOMCreated.Value == "true")
                {
                    dtBOM = (DataTable)Session["dtBOM"];
                    MaintUtil.SetValueListControl(ddlBOMBillType, dtBOM.Rows[0]["BOMParentBillType"].ToString());
                    txtSeqNo.Text = hidNextSeqNo.Value.ToString();
                }
                else
                {
                    MaintUtil.SetValueListControl(ddlBOMBillType, ddlParentBillType.SelectedValue.ToString().Trim());
                    txtSeqNo.Text = hidNextSeqNo.Value.ToString();
                }
            }

           smBOM.SetFocus(txtQtyPer);
           
        }       

        else
        {   //No Valid Item found
            DispStatusMsg("Invalid Item. Please try again.", "fail");
            smBOM.SetFocus(txtItemInsert);
        }
                

        pnlBottom.Update();
              
    }
    #endregion Validate the child item

    #region Write the BOM
    protected void ibtnCreateBOM_Click(object sender, ImageClickEventArgs e)
    {
        ibtnCreateBOM.Visible = false;
        hidBOMCreated.Value = "false";

        divdatagrid.Visible = true;
        pnlBOMGrid.Update();

        tblBottom.Visible = true;
        smBOM.SetFocus(txtItemInsert);
        pnlBottom.Update();

        DispStatusMsg("Please add Child Items to the BOM", "fail");
    }
    
    //This method fires after the user presses <cr> in the detail panel at the bottom
    protected void btnHidWriteBOM_Click(object sender, EventArgs e)
    {
        int iBOMID, iItemID, iSeqNo;
        string iChildNo, iChildDesc, iBuildUM, iAltUM, iRemarks, iBillType;
        decimal iQtyPer;

       
        //If it is a brand new BOM, create the Header record
        if (hidBOMCreated.Value == "false")
        {
            CreateBOM();
            dtBOM = GetBOM(txtItemSearch.Text);
            CheckBOM();
            hidBOMCreated.Value = "true";
        }
               

        #region validate detail data
        //--> validate QtyPer & SeqNo

        dtBOMChild = (DataTable)Session["dtBOMChild"];
        dtBOM = (DataTable)Session["dtBOM"];
                
        iBOMID = Convert.ToInt32(dtBOM.Rows[0]["BOMID"].ToString());
        iItemID = Convert.ToInt32(dtBOMChild.Rows[0]["ItemID"].ToString()); //here new
        txtItemInsert.Text = hidBOMChild.Value; ///here
        iChildNo = txtItemInsert.Text.ToString().Trim();
        iChildDesc = dtBOMChild.Rows[0]["ItemDesc"].ToString();
        iQtyPer = Convert.ToDecimal(txtQtyPer.Text);
        iSeqNo = Convert.ToInt32(txtSeqNo.Text);
        iBuildUM = ddlUM.SelectedValue.ToString().Trim();
        // ??? iAltUM = dtBOMChild.Rows[0]["AltUM"];
        iRemarks = txtRemark.Text.ToString().Trim();
        iBillType = ddlBOMBillType.SelectedValue.ToString().Trim();
               
        #endregion validate detail data
                

        if (ViewState["Mode"] == null || ViewState["Mode"].ToString().ToUpper() == "ADD")
        {
           
            //SQLHelper method approved for INSERT by Charles on 7/25/11
            strSQL = "INSERT INTO BOMDetail (fBOMID, " +
                     "                       fItemID, " +
                     "                       ChildNo, " +
                     "                       ChildDesc, " +
                     "                       QtyPerAssembly, " +
                     "                       SeqNo, " +
                     "                       BuildUM, " +
                //               "                       AltUM, " +
                     "                       Remarks, " +
                     "                       BillType, " +
                     "                       EntryID, " +
                     "                       EntryDt " +
                     "                      ) " +
                     "            VALUES    ( " + iBOMID + ", " +
                     "                        " + iItemID + ", " +
                     "                       '" + iChildNo + "', " +
                     "                       '" + iChildDesc + "', " +
                     "                       '" + iQtyPer + "', " +
                     "                       '" + iSeqNo + "', " +
                     "                       '" + iBuildUM + "', " +
                //               "                       '" + iAltUM + "', " +
                     "                       '" + iRemarks + "', " +
                     "                       '" + iBillType + "', " +
                     "                       '" + Session["UserName"].ToString().Trim() + "', " +
                     "                       CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                     "                      )";
            SqlHelper.ExecuteDataset(cnERP, CommandType.Text, strSQL);
        }
        else if (ViewState["Mode"].ToString().ToUpper() == "EDIT")
        {
            strSQL = "UPDATE BOMDetail " +
                     "SET   fItemID ='" + iItemID + "'" + 
                     "       ,ChildNo ='" + iChildNo + "'" + 
                     "       ,ChildDesc='" + iChildDesc + "'" + 
                     "       ,QtyPerAssembly='" + iQtyPer + "'" + 
                     "       ,SeqNo='" + iSeqNo + "'" + 
                     "       ,BuildUM='" + iBuildUM + "'" + 
                     "       ,Remarks='" + iRemarks + "'" + 
                     "       ,BillType='" + iBillType + "'" +
                     "       ,ChangeID='" + Session["UserName"].ToString().Trim() + "'" + 
                     "       ,ChangeDt=" + "CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) "  +
                     "WHERE  pBomDetailId = " + hisPBomDetailId.Value;   

            SqlHelper.ExecuteNonQuery(cnERP, CommandType.Text, strSQL);
            
            ViewState["Mode"] = "Add";
        }            

        dtBOM = GetBOM(txtItemSearch.Text);
        CheckBOM();

        ClearInput();
        pnlBottom.Update();
    }
    #endregion Write the BOM

    #endregion Item/BOM Add

    //-------------------------------------------------------------------------------------------------//

    #region Item/BOM Delete
    //This method fires after the user presses the DELETE button and confirms the DELETE
    protected void btnHidDelBOM_Click(object sender, EventArgs e)
    {
        dtBOM = (DataTable)Session["dtBOM"];
        
        //SQLHelper method approved for DELETE by Charles on 7/25/11
        strSQL = "UPDATE BOM " +
                 "SET    ChangeId = '" + Session["UserName"].ToString().Trim() + "', " +
                 "       ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), " +
                 "       DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                 "WHERE  pBOMID = " + Convert.ToInt32(dtBOM.Rows[0]["BOMID"].ToString());
        SqlHelper.ExecuteDataset(cnERP, CommandType.Text, strSQL);

        strSQL = "UPDATE BOMDetail " +
                 "SET    ChangeId = '" + Session["UserName"].ToString().Trim() + "', " +
                 "       ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), " +
                 "       DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                 "WHERE  fBOMID = " + Convert.ToInt32(dtBOM.Rows[0]["BOMID"].ToString());
        SqlHelper.ExecuteDataset(cnERP, CommandType.Text, strSQL);

        ScreenReset();

        txtItemSearch.Text = string.Empty;
        smBOM.SetFocus(txtItemSearch);
        pnlInput.Update();
    }
    #endregion Item/BOM Delete

    //-------------------------------------------------------------------------------------------------//

    #region Data I/O & Verification
    protected DataTable ValidItem(string ItemNo)
    {
        //Check for valid item
        dsBOM = SqlHelper.ExecuteDataset(cnERP, "pBOMGetItem", new SqlParameter("@ItemNo", ItemNo),
                                                               new SqlParameter("@RecCtl", "ITEM"));

        return dsBOM.Tables[0];
    }

    protected DataTable GetBOM(string ItemNo)
    {
        //Read the BOM/BOMDetail
        dsBOM = SqlHelper.ExecuteDataset(cnERP, "pBOMGetItem", new SqlParameter("@ItemNo", ItemNo),
                                                               new SqlParameter("@RecCtl", "BOM"));

        return dsBOM.Tables[0];
    }
    
    protected DataTable GetUM(string ItemNo)
    {
        //Get the ItemUM
        dsBOM = SqlHelper.ExecuteDataset(cnERP, "pBOMGetItem", new SqlParameter("@ItemNo", ItemNo),
                                                               new SqlParameter("@RecCtl", "UM"));

        return dsBOM.Tables[0];
    }

    public void CreateBOM()
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        string iParentNo, iParentDesc, iParentUM, iBillType;

        dtBOMItem = (DataTable)Session["dtBOMItem"];

        txtItemSearch.Text = hidBOMParent.Value;
        iParentNo = txtItemSearch.Text.ToString().Trim();
        iParentDesc = dtBOMItem.Rows[0]["ItemDesc"].ToString();
        iParentUM = dtBOMItem.Rows[0]["SellStkUM"].ToString();
        iBillType = ddlParentBillType.SelectedValue.ToString().Trim();

        //SQLHelper method approved for INSERT by Charles on 7/25/11
        strSQL = "INSERT INTO BOM (ParentItemNo, " +
                 "                 ParentDesc, " +
                 "                 ParentUM, " +
                 "                 BillType, " +
                 "                 EntryID, " +
                 "                 EntryDt " +
                 "                ) " +
                 "      VALUES    ('" + iParentNo + "', " +
                 "                 '" + iParentDesc + "', " +
                 "                 '" + iParentUM + "', " +
                 "                 '" + iBillType + "', " +
                 "                 '" + Session["UserName"].ToString().Trim() + "', " +
                 "                 CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)" +
                 "                )";
        SqlHelper.ExecuteDataset(cnERP, CommandType.Text, strSQL);
    }

    private void CheckBOM()
    {
        if (dtBOM.Rows.Count > 0)
        {   //Valid BOM found
            MaintUtil.SetValueListControl(ddlParentBillType, dtBOM.Rows[0]["BOMParentBillType"].ToString());
            hidBOMCreated.Value = "true";
            if (hidSecurity.Value == "Full")
                ibtnDelete.Visible = true;
            else
                ibtnDelete.Visible = false;

            if (dtBOM.Rows[0]["BOMItemDesc"].ToString() == "No Child")
            {
                if (hidSecurity.Value == "Full")
                    DispStatusMsg("Please add Child Items to the BOM", "fail");
                else
                    DispStatusMsg("This BOM does not contain any Child Items", "fail");
            }
            else
            {
                sortExpression = ((hidSort.Value != "") ? hidSort.Value : "BOMSeqNo, BOMItem ASC");
                dtBOM.DefaultView.Sort = sortExpression;
                dgBOM.DataSource = dtBOM.DefaultView.ToTable();
                dgBOM.DataBind();

                if (lblReadOnly.Visible)
                {
                    dgBOM.Columns[0].Visible = false;
                    ibtnDelete.Visible = false;
                }

                lblMessage.Text = "";
                pnlStatus.Update();
            }
            divdatagrid.Visible = true;
            pnlBOMGrid.Update();

            if (hidSecurity.Value == "Full")
            {
                tblBottom.Visible = true;
                smBOM.SetFocus(txtItemInsert);
                hidNextSeqNo.Value = dtBOM.Rows[0]["NextSeqNo"].ToString();
            }
            else
            {
                tblBottom.Visible = false;
                smBOM.SetFocus(txtItemSearch);
            }
            pnlBottom.Update();

            Session["dtBOM"] = dtBOM;
        }
        else
        {   //No Valid BOM found
            if (hidSecurity.Value == "Full")
                ibtnCreateBOM.Visible = true;
            else
            {
                ibtnCreateBOM.Visible = false;
                smBOM.SetFocus(txtItemSearch);
                DispStatusMsg("No BOM found", "fail");
            }
        }
        pnlInput.Update();
    }
    #endregion Data I/O & Verification

    #region Export Grid Data
    protected void ibtnExport_Click(object sender, ImageClickEventArgs e)
    {
        xlsFile = "BOM" + Session["SessionID"] + ".xls";
        ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        fnExcel = new FileInfo(ExportFile);
        reportWriter = fnExcel.CreateText();

        headerContent = string.Empty;
        footerContent = string.Empty;
        excelContent = string.Empty;

        dtBOM = (DataTable)Session["dtBOM"];
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : "BOMSeqNo, BOMItem ASC");
        dtBOM.DefaultView.Sort = sortExpression;

        if (dtBOM != null && dtBOM.Rows.Count > 0)
        {
            //Headers
            headerContent = "<table border='1' width='100%'>";

            headerContent += "<tr><th colspan='8' style='color:blue' align=left><center><b>Run By: " + Session["UserName"].ToString() +
                                    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                    "Bill Of Materials for " + dtBOM.Rows[0]["BOMParent"].ToString() + 
                                    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                                    "Run Date: " + DateTime.Now.ToShortDateString() + "</b></center></th></tr>";

            headerContent += "<tr><td align=center><b><u>Parent Item No</u></b></td>" +
                                 "<td align=center><b><u>Item No</u></b></td>" +
                                 "<td align=center><b><u>Item Description</u></b></td>" +
                                 "<td align=center><b><u>Qty Per</u></b></td>" +
                                 "<td align=center><b><u>UM</u></b></td>" +
                                 "<td align=center><b><u>Remarks</u></b></td>" +
                                 "<td align=center><b><u>Seq No</u></b></td>" +
                                 "<td align=center><b><u>Bill Type</u></b></td></tr>";

            reportWriter.Write(headerContent);

            foreach (DataRow Row in dtBOM.DefaultView.ToTable().Rows)
            {
                //Detail line
                excelContent = "<tr><td align=center>" + Row["BOMParent"].ToString() + "</td>" +
                                   "<td align=center>" + Row["BOMItem"].ToString() + "</td>" +
                                   "<td align=left>" + Row["BOMItemDesc"].ToString() + "</td>" +
                                   "<td align=right>" + String.Format("{0:0.000}", Row["BOMQtyPer"]) + "</td>" +
                                   "<td align=left>" + Row["BOMUM"].ToString() + "</td>" +
                                   "<td align=left>" + Row["BOMRemarks"].ToString() + "</td>" +
                                   "<td align=right>" + String.Format("{0:0}", Row["BOMSeqNo"]) + "</td>" +
                                   "<td align=center>" + Row["BOMBillType"].ToString() + "</td></tr>";
                reportWriter.Write(excelContent);
            }
        }
        else
            return;

        reportWriter.Write("</table>");
        reportWriter.Close();

        //Downloding Process
        FileStream fileStream = File.Open(ExportFile, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }
    #endregion

    #region Utilities

    #region Clear Display
    public void ScreenReset()
    {
        ddlParentBillType.SelectedIndex = 0;
        ibtnCreateBOM.Visible = false;
        hidBOMCreated.Value = "false";
        ibtnDelete.Visible = false;
        hidNextSeqNo.Value = "100";

        ClearItemInfo();

        dgBOM.DataSource = null;
        dgBOM.DataBind();
        divdatagrid.Visible = false;
        pnlBOMGrid.Update();

        ClearInput();
        tblBottom.Visible = false;
        pnlBottom.Update();
    }

    public void ClearItemInfo()
    {
        hidBOMParent.Value = string.Empty;
        lblItemDesc.Text = string.Empty;
        lblCatDesc.Text = string.Empty;
        lblPltTyp.Text = string.Empty;
        lblParentItem.Text = string.Empty;
        hidParentItem.Value = string.Empty;

        lbl100Wght.Text = string.Empty;
        lblNetWght.Text = string.Empty;
        lblGrossWght.Text = string.Empty;
        lblStockInd.Text = string.Empty;

        lblSellStk.Text = string.Empty;
        lblSupEqv.Text = string.Empty;
        lblPriceUM.Text = string.Empty;
        lblCostUM.Text = string.Empty;

        lblStdCost.Text = string.Empty;
        lblListPrice.Text = string.Empty;
        lblCFV.Text = string.Empty;
        lblCVC.Text = string.Empty;

        lblUPCCd.Text = string.Empty;
        lblTarrif.Text = string.Empty;
        lblPPI.Text = string.Empty;
        lblCreateDt.Text = string.Empty;

        lblWebEnabled.Text = string.Empty;
        lblPkgGrp.Text = string.Empty;
        lblLowProfile.Text = string.Empty;
        lblPVC.Text = string.Empty;

        hidSort.Value = string.Empty;

        pnlItemInfo.Update();
    }

    public void ClearInput()
    {
        txtItemInsert.Text = string.Empty;
        lblInsertItemDesc.Text = string.Empty;
        txtQtyPer.Text = string.Empty;

        ddlUM.Items.Clear();

        txtRemark.Text = string.Empty;
        txtSeqNo.Text = string.Empty;

        ddlBOMBillType.Items.Clear();

        smBOM.SetFocus(txtItemInsert);
    }
    #endregion Clear Display

    #region DDLs
    private void FillParentBillType()
    {
        DataSet dsBillType = BillType();

        ddlParentBillType.DataSource = dsBillType.Tables[0];
        ddlParentBillType.DataValueField = dsBillType.Tables[0].Columns["Listvalue"].ToString();
        ddlParentBillType.DataTextField = dsBillType.Tables[0].Columns["ListDesc"].ToString();
        ddlParentBillType.DataBind();
        //ddlParentBillType.Items.Insert(0, new ListItem("--- Select ---", "SELECT"));
    }

    private void FillBOMBillType()
    {
        DataSet dsBillType = BillType();

        ddlBOMBillType.DataSource = dsBillType.Tables[0];
        ddlBOMBillType.DataValueField = dsBillType.Tables[0].Columns["ListValue"].ToString();
        ddlBOMBillType.DataTextField = dsBillType.Tables[0].Columns["ListDesc"].ToString();
        ddlBOMBillType.DataBind();
        //ddlBOMBillType.Items.Insert(0, new ListItem("--- Select ---", "SELECT"));
    }

    private DataSet BillType()
    {
        strSQL = "SELECT LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc, LD.ListValue " +
                 "FROM   ListMaster LM (NoLock) INNER JOIN " +
                 "       ListDetail LD (NoLock) " +
                 "ON     LM.pListMasterID = LD.fListMasterID " +
                 "WHERE  LM.ListName = 'BOMBillType' AND SequenceNo <> 99 order by SequenceNo asc";
        DataSet dsBillType = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, strSQL);
        return dsBillType;
    }
    #endregion DDLs

    private void GetSecurity()
    {
        hidSecurity.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.BillOfMaterials);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";
    }

    protected void dgBOM_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();

        dtBOM = (DataTable)Session["dtBOM"];
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : "BOMSeqNo, BOMItem ASC");
        dtBOM.DefaultView.Sort = sortExpression;
        dgBOM.DataSource = dtBOM.DefaultView.ToTable();
        dgBOM.DataBind();
    }

    private void NewPreviewURL()
    {
        PreviewURL = "MaintenanceApps/BillOfMaterialsPreview.aspx" +
                     "?ItemNo=" + txtItemSearch.Text.ToString() +
                     "&BillType=" + ddlParentBillType.SelectedItem.ToString().Trim() +
                     "&SortExp=" + hidSort.Value.ToString();
        PrintDialogue1.PageUrl = PreviewURL;
        //DispStatusMsg(PreviewURL, "fail");
        pnlExport.Update();
    }

    private void DispStatusMsg(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
        pnlStatus.Update();
    }

    protected string FormatScreenData(string FormatString, object FieldVal)
    {
        string FieldResult = "**";
        try
        {
            FieldResult = String.Format(FormatString, FieldVal);
        }
        catch (Exception ex)
        {
        }
        return FieldResult;
    }

    //This method fires after the user presses the CLOSE button
    protected void btnHidClose_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtItemSearch.Text))
        {
            //Search Item Number is not empty, clear the screen
            ScreenReset();
            txtItemSearch.Text = string.Empty;
            smBOM.SetFocus(txtItemSearch);
            pnlInput.Update();
        }

        Session["dtBOMItem"] = null;
        Session["dtBOMChild"] = null;
        Session["dtBOM"] = null;

        string strFile = "BOM" + Session["SessionID"];
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strFile))
                    fn.Delete();
            }
        }
        catch (Exception ex) { }
    }
    #endregion Utilities


    protected void dgBOM_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            dtBOMDetail = GetItemAliasEditRecords("pBomDetailId = '" + e.CommandArgument + "'");
            hisPBomDetailId.Value = e.CommandArgument.ToString();
          
            pnlBottom.Update();
            DisplayRecord();

            smBOM.SetFocus(txtItemInsert);
            DispStatusMsg("Now in " + e.CommandName.ToString().Trim() + " Mode ", "success");
        }
        if (e.CommandName == "Delete")
        {
            _cmdText = "DELETE " +
                       "FROM BOMDetail " +
                       "WHERE pBomDetailId = " + e.CommandArgument;
            SqlHelper.ExecuteReader(cnxERP, CommandType.Text, _cmdText);

            dtBOM = GetBOM(txtItemSearch.Text);
            CheckBOM();
            DispStatusMsg("Item Alias Record Deleted", "success");
        }

        //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

    }

    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";

        txtItemInsert.Text = dtBOMDetail.Rows[0]["ChildNo"].ToString().Trim();
        
        dtBOMUM = GetUM(txtItemInsert.Text.ToString().Trim());
        if (dtBOMUM.Rows.Count > 0)
        {   //Bind the UM ddl
            ddlUM.DataSource = dtBOMUM;
            ddlUM.DataValueField = dtBOMUM.Columns["ListValue"].ToString();
            ddlUM.DataTextField = dtBOMUM.Columns["ListDesc"].ToString();
            ddlUM.DataBind();
            MaintUtil.SetValueListControl(ddlUM, dtBOMDetail.Rows[0]["BuildUM"].ToString().Trim());
        }

        txtRemark.Text = dtBOMDetail.Rows[0]["Remarks"].ToString().Trim();

        txtQtyPer.Text = dtBOMDetail.Rows[0]["QtyPerAssembly"].ToString().Trim();
        txtSeqNo.Text = dtBOMDetail.Rows[0]["SeqNo"].ToString().Trim();
        lblInsertItemDesc.Text = dtBOMDetail.Rows[0]["ChildDesc"].ToString().Trim();


        DataSet dsBillType = BillType();

        ddlBOMBillType.DataSource = dsBillType.Tables[0];
        ddlBOMBillType.DataValueField = dsBillType.Tables[0].Columns["ListValue"].ToString();
        ddlBOMBillType.DataTextField = dsBillType.Tables[0].Columns["ListDesc"].ToString();
        ddlBOMBillType.DataBind();

        MaintUtil.SetValueListControl(ddlBOMBillType, dtBOMDetail.Rows[0]["BillType"].ToString().Trim());

        
        
    }


    #region Data Manipulation
    protected DataTable GetItemAliasEditRecords(string searchText)
    {
        try
        {
            string _whereClause = searchText;
            string _tableName = "BOMDetail";
            string _columnName = "*";

            dsBOMDetail = SqlHelper.ExecuteDataset(cnxERP, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsBOMDetail.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }
    #endregion 


}
