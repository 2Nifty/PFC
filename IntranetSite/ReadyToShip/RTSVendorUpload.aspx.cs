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

public partial class RTSVendorUpload : System.Web.UI.Page 
{
    PFC.Intranet.BusinessLogicLayer.GERRTS gerrts = new PFC.Intranet.BusinessLogicLayer.GERRTS();
    Utility getUtility = new Utility();
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();


    #region Auto generated event
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindCombo();
            SetDefaultDir();
            ShowExcelLink.PostBackUrl = "file:" + DefaultDirLabel.Text + "AllData.xls";
            ShowExcelLink.Text = "Display Last " + DefaultDirLabel.Text + "AllData.xls";
            FillFileGrid();
            ValidationPanelTop.Visible = false;
            ValidationPanelBottom.Visible = false;
            ValidationButtonPanel.Visible = false;
            VendorDDL.Focus();
        }
    }
    #endregion

    #region Developer generated code
    private void ProcessVendorFile(string VendorFileName)
    {
        //
        //send the file trough the parsing engine and get back a dataset
        //
        ClearPageMessages();
        if (VendorDDL.SelectedItem.Text.Substring(0, 2) != "--")
        {
            FileProcessed.Text = VendorFileName;
            ValidationPanelTop.Visible = true;
            ValidationPanelBottom.Visible = true;
            ValidationButtonPanel.Visible = true;
            FilePanel.Visible = false;
            string UserName = Session["UserName"].ToString();
            BadLinesGridView.DataSource = gerrts.ParseEngine(VendorFileName, VendorDDL.SelectedItem.Text, PalletPartnerCheckBox.Checked, UserName);
            BadLinesGridView.DataBind();
            //GERRTSSqlData.SelectCommand = "SELECT * FROM GERRTS WHERE (StatusCd >= '01' and VendNo = '" + VendorDDL.SelectedItem.Text + "') ORDER BY pGERRTSID";
            GERRTSSqlData.Select(DataSourceSelectArguments.Empty);
            ValidationGridView.DataBind();
            //MainUpdatePanel.Update();
            //VendorFilesGridUpdatePanel.Visible = false;
            //VendorFilesGridUpdatePanel.Update();
            //ValidationUpdatePanel.Update();
            //lblSuccessMessage.Text = "Processed " + VendorFileName;
        }
        else
        {
            lblErrorMessage.Text = "You must select the Vendor for the file you a processing.";
            VendorDDL.Focus();
            //VendorFilesGridUpdatePanel.Update();
        }
    }

   public void ValidationGridRowBound(Object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // set status
            int StatCol = 2;
            switch (e.Row.Cells[StatCol].Text)
            {
                case "01":
                    e.Row.Cells[StatCol].Text = "OK";
                    break;
                case "11":
                case "12":
                case "13":
                    e.Row.Cells[StatCol].Text = "Warn";
                    e.Row.Cells[StatCol].ForeColor = Color.Firebrick;
                    break;
                default:
                    e.Row.Cells[StatCol].Text = "BAD";
                    e.Row.Cells[StatCol].ForeColor = Color.Red;
                    break;
            }
            //if (e.Row.Cells[StatCol].Text == "01")
            //{
            //    e.Row.Cells[StatCol].Text = "OK";
            //}
            //else
            //{
            //    e.Row.Cells[StatCol].Text = "BAD";
            //    e.Row.Cells[StatCol].ForeColor = Color.Red;
            //}
        }

    }

    private void BindCombo()
    {
        //try
        //{
            //
            //To fill the VendorNo in combo
            //
            DataTable dtSource = new DataTable();
            if (Session["RTSVendorData"] == null)
            {
                DataSet dsVendor = new DataSet();
                dtSource = gerrts.VendorRTSDDL();
                Session["RTSVendorData"] = dtSource;
            }
            else
            {
                dtSource = (DataTable)Session["RTSVendorData"];
            }
            DataView dvSource = new DataView(dtSource);
            dvSource.Sort = "ShortCode";
            getUtility.BindListControl(VendorDDL, "ShortCode", "ShortCode", dvSource.ToTable());
            getUtility.BindListControl(VendorUpd, "ShortCode", "ShortCode", dvSource.ToTable());
            //}
        //catch (Exception ex) { }
    }

    private void SetDefaultDir()
    {
        //
        //To fill the default directory for vendor files
        //
        DefaultDirLabel.Text = gerrts.GetAppPref("DIR");
    }

    private void FillFileGrid()
    {
        DataTable dtFiles = new DataTable();
        dtFiles.Columns.Add("Ready For Review", typeof(String));
        dtFiles.Columns.Add("Date Modified", typeof(String));
        string targetDirectory = DefaultDirLabel.Text;
        // Process the list of files found in the directory.
        string[] fileEntries = Directory.GetFiles(targetDirectory);
        foreach (string fileName in fileEntries)
        {
            AddFileInfoToTable(fileName, dtFiles);
        }
        VendorFilesGridView.DataSource = dtFiles;
        VendorFilesGridView.DataBind();
        Session["VendorFiles"] = dtFiles;
    }

    private void AddFileInfoToTable(string ExcelFile, DataTable GridTable)
    {
        FileInfo fi = new FileInfo(ExcelFile);
        GridTable.Rows.Add(new Object[] { fi.Name, fi.LastWriteTime.ToLongDateString() + " " + fi.LastWriteTime.ToLongTimeString() });
    }

    protected void UpdateFromGrid(object sender, GridViewEditEventArgs e)
    {
        GridViewRow row = VendorFilesGridView.Rows[e.NewEditIndex];
        string FileToProcess = DefaultDirLabel.Text + row.Cells[1].Text;
        ProcessVendorFile(FileToProcess);
    }

    protected void SortStepGrid(object sender, GridViewSortEventArgs e)
    {
        DataView dv = new DataView((DataTable)Session["VendorFiles"]);
        dv.Sort = e.SortExpression;
        VendorFilesGridView.DataSource = dv;
        VendorFilesGridView.DataBind();
    }

    protected void OKButton_Click(object sender, ImageClickEventArgs e)
    {
        // The 'Include local directory path when uploading files to server' must be enabled
        // in the Internet Explorer security miscellaneous settings for this to work.
        if (SingleFileName.Value.Length > 0)
        {
            ProcessVendorFile(SingleFileName.Value);
        }
        else
        {
            // Notify the user that a file was not uploaded.
            lblErrorMessage.Text = "You did not specify a file to upload.";
        }
    }

    protected void DeleteVendorDataButton_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        if (VendorDDL.SelectedItem.Text.Substring(0, 2) != "--")
        {
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_Delete]",
                         new SqlParameter("@tableName", "GERRTS"),
                         new SqlParameter("@whereClause", " VendNo = '" + VendorDDL.SelectedItem.Text + "'"));
            lblSuccessMessage.Text = "All RTS data for " + VendorDDL.SelectedItem.Text + " has been deleted";
        }
        else
        {
            lblErrorMessage.Text = "You must select the Vendor for data deletion.";
            VendorDDL.Focus();
        }

    }
 
    protected void ExcelExportButton_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        DataSet dsRTSData = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
        new SqlParameter("@tableName", "GERRTS"),
        new SqlParameter("@displayColumns", "*"),
        new SqlParameter("@whereCondition", "1=1"));
        using (StreamWriter sw = new StreamWriter("//PFCDEV/LIB/RTS/AllData.xls"))
        {
            foreach (DataColumn column in dsRTSData.Tables[0].Columns)
            {
                sw.Write(column.ColumnName);
                sw.Write("\t");
            }
            sw.WriteLine();
            foreach (DataRow row in dsRTSData.Tables[0].Rows)
            {
                foreach (DataColumn column in dsRTSData.Tables[0].Columns)
                {
                    sw.Write(row[column]);
                    sw.Write("\t");
                }
                sw.WriteLine();
            }
        }
        lblSuccessMessage.Text = "Excel data exported.";
        Response.Redirect("file://PFCDEV/LIB/RTS/AllData.xls");
    }

    protected void ClearPageMessages()
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
    }

    protected void ValidationAcceptButton_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        string WhereClause = "";
        int OKCount = 0;
        foreach (GridViewRow row in ValidationGridView.Rows)
        {
            if (row.Cells[2].Text.ToString() == "OK" || row.Cells[2].Text.ToString() == "Warn")
            {
                WhereClause = "(StatusCd = '00') and VendNo = '" + VendorDDL.SelectedItem.Text + "' ";
                WhereClause += " and PONo = '" + row.Cells[5].Text.ToString() + "' ";
                WhereClause += " and ItemNo = '" + row.Cells[6].Text.ToString() + "'";
                SqlHelper.ExecuteDataset(connectionString, "[pVMI_Delete]",
                    new SqlParameter("@tableName", "GERRTS"),
                    new SqlParameter("@whereClause", WhereClause));
                OKCount ++ ;
            }
        }
        gerrts.LoadVendorData(VendorDDL.SelectedItem.Text);
        ValidationPanelTop.Visible = false;
        ValidationEditPanel.Visible = false;
        ValidationPanelBottom.Visible = false;
        ValidationButtonPanel.Visible = false;
        FilePanel.Visible = true;
        lblSuccessMessage.Text = "Vendor data added for " + VendorDDL.SelectedItem.Text + ". " + OKCount.ToString() + " records.";
        //lblSuccessMessage.Text = WhereClause;
    }

    protected void ValidationAddButton_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        HiddenGERID.Value = "";
        VendorUpd.SelectedValue = VendorDDL.SelectedItem.Text;
        //LocUpd.SelectedValue = "";
        POUpd.Text = "";
        ItemUpd.Text = "";
        PortUpd.Text = "";
        QtyUpd.Text = "";
        PalletsUpd.Text = "";
        CodeUpd.Text = "";
        WeightUpd.Text = "";
        ValidationEditPanel.Visible = true;
        ValidationPanelBottom.Height = 200;
        EditErrorLabel.Text = "";
        EditSuccessLabel.Text = "Accept will save your changes. Done will close this panel (without saving your changes).";
        //GERRTSSqlData.FilterExpression = " pGERRTSID >= " + HiddenGERID.Value + "-3 and pGERRTSID <= " + HiddenGERID.Value + "+3";
        UpdFunction.Value = "Add";
    }

    public void GridDeletedHandler(Object sender, GridViewDeletedEventArgs e)
    {
        FilterValidationRecords();
    }

    public void GridEditHandler(Object sender, GridViewSelectEventArgs e)
    {
        GridViewRow row = ValidationGridView.Rows[e.NewSelectedIndex];
        HiddenGERID.Value = row.Cells[14].Text;
        //DataBoundLiteralControl VendUpdLiteral = (DataBoundLiteralControl)row.Cells[3].Controls[0];
        //VendorUpd.SelectedValue = VendUpdLiteral.Text.Trim();
        try
        {
            VendorUpd.SelectedValue = row.Cells[4].Text;
        }
        catch (Exception ex) { }
        try
        {
            LocUpd.DataBind();
            LocUpd.SelectedValue = row.Cells[12].Text.ToString();
        }
        catch (Exception ex)
        {
            LocUpd.SelectedValue = null;
        }
        POUpd.Text = Server.HtmlDecode(row.Cells[5].Text).Trim();
        ItemUpd.Text = Server.HtmlDecode(row.Cells[6].Text).Trim();
        PortUpd.Text = Server.HtmlDecode(row.Cells[11].Text).Trim();
        QtyUpd.Text = Server.HtmlDecode(row.Cells[8].Text).Trim();
        PalletsUpd.Text = Server.HtmlDecode(row.Cells[7].Text).Trim();
        CodeUpd.Text = Server.HtmlDecode(row.Cells[10].Text).Trim();
        WeightUpd.Text = Server.HtmlDecode(row.Cells[9].Text).Trim();
        MfgPlantUpd.Text = Server.HtmlDecode(row.Cells[13].Text).Trim();
        ValidationEditPanel.Visible = true;
        ValidationPanelBottom.Height = 200;
        EditErrorLabel.Text = "";
        EditSuccessLabel.Text = "Accept will save your changes. Done will close this panel (without saving your changes).";
        UpdFunction.Value = "Edit";
        GERRTSSqlData.FilterExpression = " pGERRTSID >= " + HiddenGERID.Value + "-3 and pGERRTSID <= " + HiddenGERID.Value + "+3";
    }

    public void OrigSet(object sender, EventArgs e)
    {
        FilterValidationRecords();
    }

    public void FilterValidationRecords()
    {
        if (OrigRadioButton1.Checked)
        {
            GERRTSSqlData.FilterExpression = " StatusCd >= '01'";
            ValidationAcceptButton.Visible = true;
        }
        if (OrigRadioButton2.Checked)
        {
            GERRTSSqlData.FilterExpression = " StatusCd <= '09'";
            ValidationAcceptButton.Visible = true;
        }
        if (OrigRadioButton3.Checked)
        {
            GERRTSSqlData.FilterExpression = " StatusCd > '09' and StatusCd < '20'";
            ValidationAcceptButton.Visible = true;
        }
        if (OrigRadioButton4.Checked)
        {
            GERRTSSqlData.FilterExpression = " StatusCd >= '20'";
            ValidationAcceptButton.Visible = false;
        }
        ValidationGridView.DataBind();
    }
    
    public void SaveButt_Click(object sender, EventArgs e)
    {
        if (UpdFunction.Value == "Add")
        {
            string columnValues = "'" + VendorUpd.SelectedValue.ToString() + "'";
            columnValues += ",'" + ItemUpd.Text + "'";
            columnValues += ",'" + POUpd.Text.Replace(",", "") + "'";
            columnValues += ",'" + PortUpd.Text.Replace(",", "") + "'";
            columnValues += ", " + QtyUpd.Text.Replace(",", "") + " ";
            columnValues += ", " + PalletsUpd.Text.Replace(",", "") + " ";
            columnValues += ", " + WeightUpd.Text.Replace(",", "") + " ";
            columnValues += ", '" + gerrts.RTSPalPtnrValue + "'";
            columnValues += ", '" + LocUpd.SelectedValue + "'";
            columnValues += ", '" + MfgPlantUpd.Text + "'";
            columnValues += ", '" + HttpContext.Current.User.Identity.Name + "'";
            columnValues += ", '" + DateTime.Now.ToString() + "'";
            columnValues += ", '01'";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pVMI_Insert",
              new SqlParameter("@tableName", "GERRTS"),
              new SqlParameter("@columnNames", "VendNo, ItemNo, PONo, PortofLading, Qty, PalletCnt, GrossWght, GERRTSStatCd, LocCd, MfgPlant, EntryID, EntryDt, StatusCd"),
              new SqlParameter("@columnValues", columnValues));

        }
        else
        {
            string[] Cols = new string[] { VendorUpd.SelectedValue.ToString(), POUpd.Text, ItemUpd.Text, PalletsUpd.Text.Replace(",", ""), 
            QtyUpd.Text.Replace(",", ""), WeightUpd.Text.Replace(",", ""), PortUpd.Text.Replace(",", ""), MfgPlantUpd.Text};
            gerrts.RTSVendorNo = VendorDDL.SelectedItem.Text;
            string[] LineResults = gerrts.ValidateInputColumns(Cols, PalletPartnerCheckBox.Checked);
            string columnValues = "VendNo = '" + VendorUpd.SelectedValue + "'";
            columnValues += ", ItemNo = '" + ItemUpd.Text + "'";
            columnValues += ", PONo = '" + POUpd.Text.Replace(",", "") + "' ";
            columnValues += ", PortofLading = '" + PortUpd.Text.Replace(",", "") + "' ";
            columnValues += ", Qty = " + QtyUpd.Text.Replace(",", "") + " ";
            columnValues += ", PalletCnt = " + PalletsUpd.Text.Replace(",", "") + " ";
            columnValues += ", GrossWght = " + WeightUpd.Text.Replace(",", "") + " ";
            columnValues += ", GERRTSStatCd = '" + gerrts.RTSPalPtnrValue + "' ";
            columnValues += ", LocCd = '" + LocUpd.SelectedValue + "'";
            columnValues += ", MfgPlant = '" + MfgPlantUpd.Text + "'";
            columnValues += ", StatusCd = '" + LineResults[0] + "'";
            CodeUpd.Text = gerrts.RTSPalPtnrValue;
            if (LineResults[0] == "01")
            {
                EditErrorLabel.Text = "";
                EditSuccessLabel.Text = "Verified OK and Record Saved.";
            }
            else
            {
                EditErrorLabel.Text = LineResults[1];
                EditSuccessLabel.Text = "Record Saved.";
            }
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pVMI_Update",
              new SqlParameter("@tableName", "GERRTS"),
              new SqlParameter("@columnNames", columnValues),
              new SqlParameter("@whereClause", "pGERRTSID=" + HiddenGERID.Value + ""));
        }
        GERRTSSqlData.FilterExpression = " pGERRTSID >= " + HiddenGERID.Value + "-3 and pGERRTSID <= " + HiddenGERID.Value + "+3";
        ValidationGridView.DataBind();
    }
    public void DoneButt_Click(object sender, EventArgs e)
    {
        ValidationEditPanel.Visible = false;
        ValidationPanelBottom.Height = 450;
        FilterValidationRecords();
    }

    public void ValidationDoneButt_Click(object sender, EventArgs e)
    {
        ValidationPanelBottom.Height = 450;
        ValidationPanelTop.Visible = false;
        ValidationEditPanel.Visible = false;
        ValidationPanelBottom.Visible = false;
        ValidationButtonPanel.Visible = false;
        FilePanel.Visible = true;
    }

    #endregion
}