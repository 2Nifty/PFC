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
using System.Collections.Specialized;

public partial class BillofMaterials: System.Web.UI.Page
{

    private string Num0Format = "{0:####,###,##0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string DateFormat = "{0:MM/dd/yy} ";

    SqlConnection cnERP = new SqlConnection(ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    string _cmdBOM;

    DataSet dsResult;
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();      
    string umbrellaConnectionString = ConfigurationManager.AppSettings["UmbrellaConnectionString"].ToString();
    MaintenanceUtility MaintUtil = new MaintenanceUtility();
          
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
   
    DataTable dtBOMData, dtUM;
       
    GridViewRow row;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
           
            Session["StockData"] = null;
            CalledBy.Value = "";
            ParentCall.Value = "0";

            BindBOMDDL();    

            if (Request.QueryString["UserName"] != null)
                Session["UserName"] = Request.QueryString["UserName"].ToString();            

            NameValueCollection coll = Request.QueryString;
            // Load NameValueCollection object.
            if (coll["ItemNo"] != null && coll["ItemNo"].ToString().Length > 0)
            {
                txtItemSearch.Text = coll["ItemNo"].ToString();
                GetItem(coll["ItemNo"].ToString());
            }
            else
            {
                ShowPageMessage("Enter an Item", 0);
                smBOM.FindControl("txtItemSearch").Focus();
            }
            if (coll["ParentCall"] != null)
            {
                ParentCall.Value = "1";
                CalledBy.Value = "SSParent";
            }
            else
            {
                ParentLabel.Font.Underline = true;
            }
        }
        else
        {
        }
    }


    protected void ItemButt_Click(object sender, EventArgs e)
    {
        try
        {
            // here we are checking for pfc part number with z-item processing
            ClearPageMessages();
            ClearItemData(true);
            // try to find the item.
            GetItem(txtItemSearch.Text);        
            ScriptManager.RegisterClientScriptBlock(txtItemSearch, txtItemSearch.GetType(), "resize", "SetHeight();", true);
        }
        catch (Exception ex1)
        {
            ShowPageMessage("Get Item Error " + ex1.Message + ", " + ex1.ToString(), 2);
        }
    }

    
    protected void GetItem(string ItemNo)
    {
       
        // get the BOM data
        ds = SqlHelper.ExecuteDataset(connectionString, "pBOMGetItem",
            new SqlParameter("@SearchItemNo", ItemNo),
            new SqlParameter("@UserName", Session["UserName"].ToString()));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ShowPageMessage("Invalid Item. Please try again.", 2);
                }
            }
            else
            {
                dt = ds.Tables[1];
                ItemDescLabel.Text = dt.Rows[0]["ItemDesc"].ToString();
                Wgt100Label.Text = FormatScreenData(Num2Format, dt.Rows[0]["HundredWght"]);
                QtyUOMLabel.Text = dt.Rows[0]["SellGlued"].ToString();
                StdCostLabel.Text = dt.Rows[0]["CostGlued"].ToString();
                UPCLabel.Text = dt.Rows[0]["UPC"].ToString();
                WebLabel.Text = dt.Rows[0]["WebEnabled"].ToString();
                CategoryLabel.Text = dt.Rows[0]["CatDesc"].ToString();
                NetWghtLabel.Text = FormatScreenData(Num2Format, dt.Rows[0]["NetWght"]);
                SuperEqLabel.Text = dt.Rows[0]["SuperGlued"].ToString();
                LowProfileLabel.Text = FormatScreenData(Num0Format, dt.Rows[0]["LowProfileQty"]);
                ListLabel.Text = FormatScreenData(Num2Format, dt.Rows[0]["ListPrice"]);
                HarmCodeLabel.Text = dt.Rows[0]["Tariff"].ToString();
                PackGroupLabel.Text = dt.Rows[0]["PackageGroup"].ToString();
                PlatingLabel.Text = dt.Rows[0]["Finish"].ToString();
                GrossWghtLabel.Text = FormatScreenData(Num2Format, dt.Rows[0]["GrossWght"]);
                PriceUMLabel.Text = dt.Rows[0]["PriceUM"].ToString();
                CFVLabel.Text = dt.Rows[0]["CorpFixedVelocity"].ToString();
                PPILabel.Text = dt.Rows[0]["PPI"].ToString();
                ParentLabel.Text = dt.Rows[0]["ParentProdNo"].ToString();
                ParentItemHidden.Value = dt.Rows[0]["ParentProdNo"].ToString();
                StockLabel.Text = dt.Rows[0]["StockInd"].ToString();
                CostUMLabel.Text = dt.Rows[0]["CostUM"].ToString();
                CatVelLabel.Text = dt.Rows[0]["CatVelocityCd"].ToString();
                CreatedLabel.Text = FormatScreenData(DateFormat, dt.Rows[0]["Created"]);
                PkgVelLabel.Text = dt.Rows[0]["PackageVelocity"].ToString();
                //if (int.Parse(dt.Rows[0]["ItemBOMExist"].ToString()) == 1)
                //{
                //    //GetBOMButt.Visible = true;
                //    //CreateBOMButt.Visible = False;
                //}
                Session["StockData"] = ds.Tables[2];

                GetBOM(ItemNo);

                BindPrintDialog();
            }
        }
        smBOM.SetFocus("txtItemSearch");
    }


    private void BindBOMGrid(DataTable StockData)
    {
        BOMGridView.DataSource = StockData;
        BOMGridView.DataBind();
        Session["StockData"] = StockData;

       // dsResult = BOMComponents(ItemNo); //adding pete
       // Session["dtBOMData"] = dsResult.Tables[0].DefaultView.ToTable(); //adding pete
    }


    //
    //Bind DropDownLists
    //
    private void BindBOMDDL()
    {
        MaintUtil.BindListControls(ddlBillType, "ListDesc", "ListValue", GetListDetails("BOMBillType"), "--- Select ---");
        MaintUtil.BindListControls(ddlBillType2, "ListDesc", "ListValue", GetListDetails("BOMBillType"), "--- Select ---");
        MaintUtil.BindListControls(ddlUM, "ListDesc", "ListValue", GetListDetails("UMName"), "--- Select ---");
    }

    
    //
    //SELECT the data to be bound to a ListControl based on a specific ListName (ListMaster/ListDetail)
    //
    public DataTable GetListDetails(string listName)
    {
        try
        {
            string _tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
            string _columnName = "LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc, LD.ListValue ";
            string _whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID order by SequenceNo asc";
            DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsType.Tables[0];

        }
        catch (Exception ex)
        {
            return null;
        }
    }

    
    protected void GetBOM (string ItemNo)
    {
        DataTable dtBOM = new DataTable();

        dtBOM = BOMComponents(ItemNo);
        //Session["dtBOMData"] = dsResult.Tables[0].DefaultView.ToTable(); //adding pete
        
        if (dtBOM.Rows.Count > 0)
        {
            BOMGridView.DataSource = dtBOM.DefaultView.ToTable();
            BOMGridView.DataBind();
        }
        else
        {
            ShowPageMessage("A BOM does not exist for this item, do you want to create one?", 2);
        }

        smBOM.SetFocus("txtItemSearch");
    }


    private DataTable BOMComponents(string _BOM)
    {
        try 
        {
            _cmdBOM = "SELECT   BOM.ParentItemNo, BOMD.ChildNo, BOMD.ChildDesc, BOMD.QtyPerAssembly, " +
                      "         BOMD.BuildUM, BOMD.Remarks, BOMD.SeqNo, BOMD.BillType " +
                      "FROM     BOM (NoLock) INNER JOIN BOMDetail BOMD (NoLock) ON BOM.pBOMID = BOMD.fBOMID " +
                      "WHERE    BOM.ParentItemNo  = '" + _BOM + "'";
            dsResult = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, _cmdBOM);
            return dsResult.Tables[0].DefaultView.ToTable();
        }
        catch (Exception ex)
        {
            return null;
        }
    }
       
    
    //
    //Formats per 100 Wght Header bar
    //
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


    public void BindPrintDialog()
    {
        pnlExport.Visible = true;
        PrintDialogue1.PageTitle = "Stock Status for " + txtItemSearch.Text;
        string SSURL = "StockStatusExport.aspx?ItemNo=" + txtItemSearch.Text;
        PrintDialogue1.PageTitle = "Stock Status " + txtItemSearch.Text;
        // we build a url according to what item they have entered. 
        PrintDialogue1.PageUrl = SSURL;
        pnlExport.Update();
        //ShowPageMessage(RecallURL, 0);
    }
             
 
    protected void ClearPageMessages()
    {
        lblErrorMessage.Text = "";
        MessageUpdatePanel.Update();
    }


    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        switch (MessageType)
        {
            case 1:
                lblErrorMessage.CssClass = "warn";
                break;
            case 2:
                lblErrorMessage.CssClass = "error";
                break;
            default:
                lblErrorMessage.CssClass = "success";
                break;
        }
        lblErrorMessage.Text = PageMessage;
        MessageUpdatePanel.Update();
    }


    protected void ClearItemData(bool NewItem)
    {
        // if NewItem is true, we are clearing after an item is entered
        BOMGridView.DataBind();
        DetailUpdatePanel.Update();
        ItemDescLabel.Text = "";
        Wgt100Label.Text = "";
        QtyUOMLabel.Text = "";
        StdCostLabel.Text = "";
        UPCLabel.Text = "";
        WebLabel.Text = "";
        CategoryLabel.Text = "";
        NetWghtLabel.Text = "";
        SuperEqLabel.Text = "";
        ListLabel.Text = "";
        HarmCodeLabel.Text = "";
        PackGroupLabel.Text = "";
        PlatingLabel.Text = "";
        GrossWghtLabel.Text = "";
        PriceUMLabel.Text = "";
        CFVLabel.Text = "";
        PPILabel.Text = "";
        ParentLabel.Text = "";
        StockLabel.Text = "";
        CostUMLabel.Text = "";
        CatVelLabel.Text = "";
        PkgVelLabel.Text = "";
        CreatedLabel.Text = "";
        SelectorUpdatePanel.Update();
        HeaderUpdatePanel.Update();
        //CategorySpecLabel.Text = "";
        MessageUpdatePanel.Update();
        // HeadImageUpdatePanel.Visible = false;
        // BodyImageUpdatePanel.Visible = false;
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    #region New Export Tod's
    protected void ibtnExcel_Click(object sender, ImageClickEventArgs e)
    {
        //DataTable dtTotExcel = new DataTable();

        String xlsFile = "BOMfile" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter reportWriter = fnExcel.CreateText();

        string headerContent = string.Empty;
        string excelContent = string.Empty;

        try
        {
            dtBOMData = (DataTable)Session["dtBOMData"];
        }
        catch (Exception ex)
        {
        }

        if (dtBOMData != null && dtBOMData.DefaultView.ToTable().Rows.Count > 0)
        {
            dtBOMData.DefaultView.Sort = "SeqNo ASC ";

            //Headers
            headerContent = "<table border='1' width='100%'>";
            headerContent += "<tr><th colspan='8' style='color:blue' align=left><center>Bill of Materials</center></th></tr>";
            headerContent += "<tr><th nowrap><center>ParentItemNo</center></th>" +
                                 "<th nowrap><center>ChildNo</center></th>" +
                                 "<th nowrap><center>ChildDesc</center></th>" +
                                 "<th nowrap><center>QtyPerAssembly</center></th>" +
                                 "<th nowrap><center>BuildUM</center></th>" +
                                 "<th nowrap><center>Remarks</center></th>" +
                                 "<th nowrap><center>SeqNo</center></th>" +
                                 "<th nowrap><center>BillType</center></th></tr>";
            reportWriter.Write(headerContent);

            foreach (DataRow Row in dtBOMData.DefaultView.ToTable().Rows)
            {
                //Detail line
                excelContent = "<tr><td align=left>" + Row["ParentItemNo"].ToString() + "</td>" +
                                   "<td align=center>" + Row["ChildNo"] + "</td>" +
                                   "<td align=center>" + Row["ChildDesc"] + "</td>" +
                                   "<td align=left style='mso-number-format:\\@;'>" + Row["QtyPerAssembly"] + "</td>" +
                                   "<td align=center>" + Row["BuildUM"] + "</td>" +
                                   "<td align=center>" + Row["Remarks"] + "</td>" +
                                   "<td align=center>" + Row["SeqNo"] + "</td>" +
                                   "<td align=center>" + Row["BillType"] + "</td></tr>";
                reportWriter.Write(excelContent);
            }

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
    }
    #endregion



}