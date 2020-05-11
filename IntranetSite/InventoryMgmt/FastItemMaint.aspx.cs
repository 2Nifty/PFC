using System;
using System.IO;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Data.SqlClient;
using System.Data.OleDb;
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


public partial class FastItemMaint : System.Web.UI.Page
{
    ddlBind ddlBind = new ddlBind();

    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    DataSet dsItem;
    string _procGet = "pIMGetFastMaint";
    string _procUpd = "pIMUpdFastMaint";
    String _xlsRoot = "IMFastMaint";

    MaintenanceUtility Security = new MaintenanceUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetSecurity();

            ddlBind.BindDscFromList("IMFastFields", ddlFastFields, "SELECT", " -- Select Field -- ");

            txtStrCat.Text = string.Empty;
            txtEndCat.Text = string.Empty;
            txtCatList.Text = string.Empty;

            txtStrSize.Text = string.Empty;
            txtEndSize.Text = string.Empty;
            txtSizeList.Text = string.Empty;

            txtStrVar.Text = string.Empty;
            txtEndVar.Text = string.Empty;
            txtVarList.Text = string.Empty;

            ddlBind.BindDscFromTable("GERTARIFF", ddlStrHarmCd, "ALL", "ALL");
            ddlBind.BindDscFromTable("GERTARIFF", ddlEndHarmCd, " ", " ");
            txtHarmCdList.Text = string.Empty;

            ddlBind.BindFromList("ItemPPICd", ddlStrPPI, "ALL", "ALL");
            ddlBind.BindFromList("ItemPPICd", ddlEndPPI, " ", " ");
            txtPPIList.Text = string.Empty;

            txtStrDt.Text = string.Empty;
            txtEndDt.Text = string.Empty;
        }
    }

    #region Excel Export
    protected void btnExport_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlFastFields.SelectedIndex <= 0)
        {
            DisplayStatusMessage("Please select a field for Fast Item Maintenance", "fail");
            smFastIM.SetFocus(ddlFastFields);
            return;
        }
        
        GetDataSet();

        if (dsItem.Tables[0] != null && dsItem.Tables[0].DefaultView.ToTable().Rows.Count > 0)
        {
            String xlsFile = _xlsRoot + "Export" + Session["SessionID"].ToString().Trim() + Session["UserName"].ToString().Trim() + "_" + ddlFastFields.SelectedValue.ToString().Trim() + ".xls";
            String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;
            DelExcel("..//Common//ExcelUploads//", xlsFile);

            // http://support.microsoft.com/kb/316934
            OleDbConnection xlsConn = new OleDbConnection();
            xlsConn.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ExportFile + ";Extended Properties='Excel 8.0;HDR=Yes'";
            xlsConn.Open();
            OleDbCommand xlsCreate = new OleDbCommand();
            xlsCreate.CommandText = "CREATE TABLE [" + ddlFastFields.SelectedValue.ToString().Trim() + "]" +
                                    " ([Item] string, [Orig: " + ddlFastFields.SelectedItem.ToString().Trim() + "] string, [Mod: " + ddlFastFields.SelectedItem.ToString().Trim() + "] string)";
            xlsCreate.Connection = xlsConn;
            xlsCreate.ExecuteNonQuery();

            string strIns = "INSERT INTO [" + ddlFastFields.SelectedValue.ToString().Trim() + "]" +
                            " (Item, [Orig: " + ddlFastFields.SelectedItem.ToString().Trim() + "], [Mod: " + ddlFastFields.SelectedItem.ToString().Trim() + "]) ";

            //strIns += "VALUES ('" + dsItem.Tables[0].Rows[0]["ItemNo"].ToString() + "', '" + dsItem.Tables[0].Rows[0][ddlFastFields.SelectedValue.ToString().Trim()] + "', ' '";
            //DisplayInfoMessage(strIns,"success");

            foreach (DataRow Row in dsItem.Tables[0].Rows)
            {
                xlsCreate.CommandText = strIns + "VALUES ('" + Row["ItemNo"].ToString() + "', '" + Row[ddlFastFields.SelectedValue.ToString().Trim()] + "', ' ')";
                xlsCreate.ExecuteNonQuery();
            }

            xlsConn.Close();

            string URL = "ExcelExport.aspx?Filename=../Common/ExcelUploads/" + xlsFile;
            string script = "window.open('" + URL + "' ,'export','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	";
            ScriptManager.RegisterClientScriptBlock(btnExport, btnExport.GetType(), "export", script, true);
        }
    }

    protected void GetDataSet()
    {
        string  _StrCat, _EndCat, _CatList,
                _StrSize, _EndSize, _SizeList,
                _StrVar, _EndVar, _VarList,
                _StrHarmCd, _EndHarmCd, _HarmCdList,
                _StrPPI, _EndPPI, _PPIList,
                _StrDt, _EndDt, _DtControl;

        #region Build Category param
        if (chkCatList.Checked)
        {   //Set strCat & endCat to '~' and parse the catList
            _StrCat = "~";
            _EndCat = "~";
            _CatList = txtCatList.Text.ToString().Trim().Replace("'", "").Replace("\"", "");
        }
        else
        {   //Set the catList to '~' and parse strCat & endCat
            _CatList = "~";
            _StrCat = txtStrCat.Text.ToString().Trim();
            if (string.IsNullOrEmpty(_StrCat))
            {   //ALL categories selected
                _StrCat = "00000";
                _EndCat = "99999";
            }
            else
            {   //IF endCat is blank, make it equal strCat
                _EndCat = txtEndCat.Text.ToString().Trim();
                if (string.IsNullOrEmpty(_EndCat) || string.Compare(_StrCat, _EndCat) > 0)
                    _EndCat = _StrCat;
            }
        }
        #endregion

        #region Build Size param
        if (chkSizeList.Checked)
        {   //Set strSize & endSize to '~' and parse the SizeList
            _StrSize = "~";
            _EndSize = "~";
            _SizeList = txtSizeList.Text.ToString().Trim().Replace("'", "").Replace("\"", "");
        }
        else
        {   //Set the SizeList to '~' and parse strSize & endSize
            _SizeList = "~";
            _StrSize = txtStrSize.Text.ToString().Trim();
            if (string.IsNullOrEmpty(_StrSize))
            {   //ALL Sizes selected
                _StrSize = "0000";
                _EndSize = "9999";
            }
            else
            {   //IF endSize is blank, make it equal strSize
                _EndSize = txtEndSize.Text.ToString().Trim();
                if (string.IsNullOrEmpty(_EndSize) || string.Compare(_StrSize, _EndSize) > 0)
                    _EndSize = _StrSize;
            }
        }
        #endregion

        #region Build Variance param
        if (chkVarList.Checked)
        {   //Set strVar & endVar to '~' and parse the VarList
            _StrVar = "~";
            _EndVar = "~";
            _VarList = txtVarList.Text.ToString().Trim().Replace("'", "").Replace("\"", "");
        }
        else
        {   //Set the VarList to '~' and parse strVar & endVar
            _VarList = "~";
            _StrVar = txtStrVar.Text.ToString().Trim();
            if (string.IsNullOrEmpty(_StrVar))
            {   //ALL Variances selected
                _StrVar = "000";
                _EndVar = "999";
            }
            else
            {   //IF endVar is blank, make it equal strVar
                _EndVar = txtEndVar.Text.ToString().Trim();
                if (string.IsNullOrEmpty(_EndVar) || string.Compare(_StrVar, _EndVar) > 0)
                    _EndVar = _StrVar;
            }
        }
        #endregion

        #region Build Harmonizing Code param
        if (chkHarmCdList.Checked)
        {   //Set strHarmCd & endHarmCd to '~' and parse the HarmCdList
            _StrHarmCd = "~";
            _EndHarmCd = "~";
            _HarmCdList = txtHarmCdList.Text.ToString().Trim().Replace("'", "").Replace("\"", "");
        }
        else
        {   //Set the HarmCdList to '~' and parse strHarmCd & endHarmCd
            _HarmCdList = "~";
            _StrHarmCd = ddlStrHarmCd.SelectedValue.ToString().Trim();
            if (_StrHarmCd.ToUpper() == "ALL" || string.IsNullOrEmpty(_StrHarmCd))
            {   //ALL Harmonizing Codes selected
                _StrHarmCd = "";
                _EndHarmCd = "z";
            }
            else
            {   //IF endHarmCd is blank, make it equal strHarmCd
                _EndHarmCd = ddlEndHarmCd.SelectedValue.ToString().Trim();
                if (string.IsNullOrEmpty(_EndHarmCd) || string.Compare(_StrHarmCd, _EndHarmCd) > 0)
                    _EndHarmCd = _StrHarmCd;
            }
        }
        #endregion

        #region Build PPI Code param
        if (chkPPIList.Checked)
        {   //Set strPPI & endPPI to '~' and parse the PPIList
            _StrPPI = "~";
            _EndPPI = "~";
            _PPIList = txtPPIList.Text.ToString().Trim().Replace("'", "").Replace("\"", "");
        }
        else
        {   //Set the PPIList to '~' and parse strPPI & endPPI
            _PPIList = "~";
            _StrPPI = ddlStrPPI.SelectedValue.ToString().Trim();
            if (_StrPPI.ToUpper() == "ALL" || string.IsNullOrEmpty(_StrPPI))
            {   //ALL PPI Codes selected
                _StrPPI = "";
                _EndPPI = "z";
            }
            else
            {   //IF endPPI is blank, make it equal strPPI
                _EndPPI = ddlEndPPI.SelectedValue.ToString().Trim();
                if (string.IsNullOrEmpty(_EndPPI) || string.Compare(_StrPPI, _EndPPI) > 0)
                    _EndPPI = _StrPPI;
            }
        }
        #endregion

        #region Build Date param
        _DtControl = "AFTER";
        _DtControl = rdoDateCtl.SelectedValue.ToString().Trim();

        _StrDt = txtStrDt.Text.ToString().Trim();
        _EndDt = txtEndDt.Text.ToString().Trim();
        if (string.IsNullOrEmpty(_StrDt) && string.IsNullOrEmpty(_EndDt))
        {
            _StrDt = "1970-01-01";
            _EndDt = "2120-12-31";
        }
        else
        {
            if (_DtControl == "AFTER")
            {   //AFTER: On or after Start Date
                if (string.IsNullOrEmpty(_StrDt))
                    _StrDt = "1970-01-01";
                _EndDt = "2120-12-31";
            }
            if (_DtControl == "BEFORE")
            {   //BEFORE: On or before End Date
                if (string.IsNullOrEmpty(_EndDt))
                    _EndDt = "2120-12-31";
                _StrDt = "1970-01-01";
            }
            if (_DtControl == "BETWEEN")
            {   //BETWEEN: Between Start & End Date
                if (string.IsNullOrEmpty(_StrDt))
                    _StrDt = "1970-01-01";

                if (string.IsNullOrEmpty(_EndDt))
                    _EndDt = "2120-12-31";
            }
        }
        //Validate _EndDt is greater than/equal to _StrDt
        if (string.Compare(_StrDt, _EndDt) > 0)
        {
            _EndDt = _StrDt;
        }
        #endregion

        //DisplayStatusMessage(_StrCat + " | " + _EndCat + " | " + _CatList + " | " +
        //                     _StrSize + " | " + _EndSize + " | " + _SizeList + " | " +
        //                     _StrVar + " | " + _EndVar + " | " + _VarList + " | " +
        //                     _StrHarmCd + " | " + _EndHarmCd + " | " + _HarmCdList + " | " +
        //                     _StrPPI + " | " + _EndPPI + " | " + _PPIList + " | " +
        //                     _StrDt + " | " + _EndDt + " | " + _DtControl, "success");

        #region Call SP to get Dataset
        try
        {
            dsItem = SqlHelper.ExecuteDataset(cnERP, _procGet,
                                                    new SqlParameter("@StrCat", _StrCat),
                                                    new SqlParameter("@EndCat", _EndCat),
                                                    new SqlParameter("@CatList", _CatList),
                                                    new SqlParameter("@StrSize", _StrSize),
                                                    new SqlParameter("@EndSize", _EndSize),
                                                    new SqlParameter("@SizeList", _SizeList),
                                                    new SqlParameter("@StrVar", _StrVar),
                                                    new SqlParameter("@EndVar", _EndVar),
                                                    new SqlParameter("@VarList", _VarList),
                                                    new SqlParameter("@StrHarmCd", _StrHarmCd),
                                                    new SqlParameter("@EndHarmCd", _EndHarmCd),
                                                    new SqlParameter("@HarmCdList", _HarmCdList),
                                                    new SqlParameter("@StrPPI", _StrPPI),
                                                    new SqlParameter("@EndPPI", _EndPPI),
                                                    new SqlParameter("@PPIList", _PPIList),
                                                    new SqlParameter("@StrDt", _StrDt),
                                                    new SqlParameter("@EndDt", _EndDt),
                                                    new SqlParameter("@DtParam", _DtControl));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (" + _procGet + ")", "fail");
            //DisplayStatusMessage(ex.ToString(), "fail");
            return;
        }
        #endregion

        //DisplayStatusMessage(dsItem.Tables[0].Rows.Count.ToString().Trim(), "success");
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string DelExcel(string xlsPath, string xlsFile)
    {
        //Delete the excel file(s)
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(xlsFile))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }
    #endregion Excel Export

    #region Submit Excel Upload
    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        string inpFile = string.Empty;
        string _fieldName = string.Empty;
        string _date = string.Empty;
        string _tempTable = string.Empty;
        string _cols = string.Empty;
        string _where = string.Empty;
        string _strSQL = string.Empty;
        try
        {
            if (uplXLS.HasFile)
            {
                dsItem = new DataSet();
                inpFile = @"\\pfcfiles\ItemFastMaint\" + _xlsRoot + "Import" + Session["SessionID"].ToString().Trim() + Session["UserName"].ToString().Trim() + ".xls";
                uplXLS.SaveAs(inpFile);
                lblXLSFile.Text = uplXLS.FileName.ToString().Trim();
                lblNewFile.Text = inpFile.ToString().Trim();

                #region Load file to DataSet
                string strExcelCnx = "Provider=Microsoft.ACE.OLEDB.12.0;"
                                    + "Data Source=" + inpFile + ";"
                                    + "Extended Properties='Excel 12.0;HDR=Yes;IMEX=1'";
                OleDbConnection cnxExcel = new OleDbConnection(strExcelCnx);
                OleDbCommand cmdExcel = new OleDbCommand();
                cmdExcel.Connection = cnxExcel;
                cnxExcel.Open();
                DataTable dtExcelSchema;
                dtExcelSchema = cnxExcel.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                cnxExcel.Close();
                OleDbDataAdapter da = new OleDbDataAdapter();
                string _sheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                cmdExcel.CommandText = "SELECT * From [" + _sheetName + "]";
                da.SelectCommand = cmdExcel;
                da.Fill(dsItem);
                #endregion Load file to DataSet

                //Put the Excel data into temp table
                _fieldName  = _sheetName.ToString().Trim().Replace("$", "");
                _date       = "_" + DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString().PadLeft(2, '0') + DateTime.Now.Day.ToString().PadLeft(2, '0') + "_";
                _tempTable  = "t" + _date + _xlsRoot + "Update" + Session["SessionID"].ToString().Trim() + Session["UserName"].ToString().Trim() + "_" + _fieldName;
                _cols       = "[" + dsItem.Tables[0].DefaultView.ToTable().Columns[0].ColumnName.ToString().Trim() + "] as ItemNo, " +
                              "[" + dsItem.Tables[0].DefaultView.ToTable().Columns[1].ColumnName.ToString().Trim() + "] as Orig_" + _fieldName + ", " +
                              "[" + dsItem.Tables[0].DefaultView.ToTable().Columns[2].ColumnName.ToString().Trim() + "] as " + _fieldName;
                _where      = "1=1";

                lblFastField.Text = _fieldName;
                lblTempTable.Text = _tempTable;

                //Create the temp table
                _strSQL = "CREATE TABLE [dbo]." + _tempTable + " ([ItemNo] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, [Orig_" + _fieldName + "] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, [" + _fieldName + "] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL) ON [PRIMARY]";
                //DisplayInfoMessage(_strSQL, "success");
                dsItem = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, _strSQL);

                //Load the temp table
                _strSQL = "INSERT INTO " + _tempTable + " SELECT * FROM OpenRowSet('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=" + inpFile + ";IMEX=1', 'SELECT " + _cols + " FROM [" + _sheetName + "] WHERE " + _where + "')";
                //DisplayInfoMessage(_strSQL, "success");
                dsItem = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, _strSQL);
            }
            else
            {
                DisplayStatusMessage("Invalid File Path", "fail");
            }
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error Processing File", "fail");
            DisplayStatusMessage(ex.Message.ToString(), "fail");
            return;
        }
        finally
        {
            //Once file information is read to the table, delete the file
            FileInfo fileInfo = new FileInfo(inpFile);
            if (fileInfo.Exists)
                fileInfo.Delete();
        }

        #region Call SP to UPDATE data
        try
        {
            dsItem = SqlHelper.ExecuteDataset(cnERP, _procUpd,
                                                    new SqlParameter("@TableName", _tempTable),
                                                    new SqlParameter("@FieldName", _fieldName),
                                                    new SqlParameter("@UserID", Session["UserName"].ToString()));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("Error executing stored procedure (" + _procUpd + ")", "fail");
            DisplayStatusMessage(ex.ToString(), "fail");
            return;
        }

        DisplayStatusMessage("SUBMITTED FOR PROCESSING", "success");
        #endregion Call SP to UPDATE data
    }
    #endregion Submit Excel Upload

    #region Toggle Param List Check Boxes
    //if CHECKED
    //     then CLEAR & DISABLE Start & End
    //          ENABLE List
    //     else CLEAR & DISABLE List
    //          ENABLE Start & End

    protected void chkCatList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkCatList.Checked)
        {
            txtStrCat.Text = string.Empty;
            txtStrCat.Enabled = false;
            txtEndCat.Text = string.Empty;
            txtEndCat.Enabled = false;
            txtCatList.Enabled = true;
        }
        else
        {
            txtCatList.Text = string.Empty;
            txtCatList.Enabled = false;
            txtStrCat.Enabled = true;
            txtEndCat.Enabled = true;
        }
        pnlCat.Update();
    }

    protected void chkSizeList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSizeList.Checked)
        {
            txtStrSize.Text = string.Empty;
            txtStrSize.Enabled = false;
            txtEndSize.Text = string.Empty;
            txtEndSize.Enabled = false;
            txtSizeList.Enabled = true;
        }
        else
        {
            txtSizeList.Text = string.Empty;
            txtSizeList.Enabled = false;
            txtStrSize.Enabled = true;
            txtEndSize.Enabled = true;
        }
        pnlSize.Update();
    }

    protected void chkVarList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkVarList.Checked)
        {
            txtStrVar.Text = string.Empty;
            txtStrVar.Enabled = false;
            txtEndVar.Text = string.Empty;
            txtEndVar.Enabled = false;
            txtVarList.Enabled = true;
        }
        else
        {
            txtVarList.Text = string.Empty;
            txtVarList.Enabled = false;
            txtStrVar.Enabled = true;
            txtEndVar.Enabled = true;
        }
        pnlVar.Update();
    }

    protected void chkHarmCdList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkHarmCdList.Checked)
        {
            ddlStrHarmCd.SelectedIndex = 0;
            ddlStrHarmCd.Enabled = false;
            ddlEndHarmCd.SelectedIndex = 0;
            ddlEndHarmCd.Enabled = false;
            txtHarmCdList.Enabled = true;
        }
        else
        {
            txtHarmCdList.Text = string.Empty;
            txtHarmCdList.Enabled = false;
            ddlStrHarmCd.Enabled = true;
            ddlEndHarmCd.Enabled = true;
        }
        pnlHarmCd.Update();
    }

    protected void chkPPIList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkPPIList.Checked)
        {
            ddlStrPPI.SelectedIndex = 0;
            ddlStrPPI.Enabled = false;
            ddlEndPPI.SelectedIndex = 0;
            ddlEndPPI.Enabled = false;
            txtPPIList.Enabled = true;
        }
        else
        {
            txtPPIList.Text = string.Empty;
            txtPPIList.Enabled = false;
            ddlStrPPI.Enabled = true;
            ddlEndPPI.Enabled = true;
        }
        pnlPPI.Update();
    }

    protected void rdoMode_SelectedIndexChanged(object sender, EventArgs e)
    {
        DisplayInfoMessage("", "success");
        if (rdoMode.SelectedIndex == 0)
        {
            pnlBottom.Visible = true;
            DisplayStatusMessage("Mode: DOWNLOAD", "success");
            btnExport.Visible = true;
            btnSubmit.Visible = false;
            pnlUpload.Visible = false;
            pnlDownload.Visible = true;
            lblFastFields.Visible = true;
            ddlFastFields.Visible = true;
        }
        else
        {
            pnlBottom.Visible = true;
            DisplayStatusMessage("Mode: UPLOAD", "success");
            btnExport.Visible = false;
            btnSubmit.Visible = true;
            pnlUpload.Visible = true;
            pnlDownload.Visible = false;
            lblFastFields.Visible = false;
            ddlFastFields.Visible = false;
        }
        pnlStatus.Update();
    }
    #endregion Toggle Param List Check Boxes

    #region Dates

    #region StartDt
    protected void ibtnStartDt_Click(object sender, ImageClickEventArgs e)
    {
        if (cldStartDt.Visible == false)
            cldStartDt.Visible = true;
        else
            cldStartDt.Visible = false;
        pnlStartPick.Update();
    }

    protected void txtStrDt_TextChanged(object sender, EventArgs e)
    {
        lblStatus.Text = string.Empty;
        pnlStatus.Update();
        try
        {
            if (!ValidateDate(Convert.ToDateTime(txtStrDt.Text)))
            {
                cldStartDt.SelectedDate = DateTime.Now;
                txtStrDt.Text = string.Empty;
                smFastIM.SetFocus(txtStrDt);
                lblStatus.Text = "Invalid Start date";
                pnlStatus.Update();
            }
            else
            {
                txtStrDt.Text = Convert.ToDateTime(txtStrDt.Text).ToShortDateString();
                pnlStartDt.Update();
                smFastIM.SetFocus(txtEndDt);
            }

            if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
            {
                txtStrDt.Text = string.Empty;
                smFastIM.SetFocus(txtStrDt);
                lblStatus.Text = "Start date must be less than or equal to End date (1)";
                pnlStatus.Update();
            }
        }
        catch (Exception ex)
        {
            txtStrDt.Text = string.Empty;
            smFastIM.SetFocus(txtStrDt);
            lblStatus.Text = "Invalid Start date (ex)";
            pnlStatus.Update();
        }
    }

    protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
    {
        lblStatus.Text = string.Empty;
        pnlStatus.Update();
        if (ValidateDate(cldStartDt.SelectedDate))
        {
            txtStrDt.Text = cldStartDt.SelectedDate.ToShortDateString();
            pnlStartDt.Update();
            pnlStartPick.Update();
            smFastIM.SetFocus(txtEndDt);
        }
        else
        {
            txtStrDt.Text = string.Empty;
            smFastIM.SetFocus(txtStrDt);
            cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
        }

        if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
        {
            txtStrDt.Text = string.Empty;
            smFastIM.SetFocus(txtStrDt);
            lblStatus.Text = "Start date must be less than or equal to End date (2)";
            pnlStatus.Update();
        }
    }
    #endregion StartDt

    #region EndDt
    protected void ibtnEndDt_Click(object sender, ImageClickEventArgs e)
    {
        if (cldEndDt.Visible == false)
            cldEndDt.Visible = true;
        else
            cldEndDt.Visible = false;
        pnlEndPick.Update();
    }

    protected void txtEndDt_TextChanged(object sender, EventArgs e)
    {
        lblStatus.Text = string.Empty;
        pnlStatus.Update();
        try
        {
            if (!ValidateDate(Convert.ToDateTime(txtEndDt.Text)))
            {
                cldEndDt.SelectedDate = DateTime.Now;
                txtEndDt.Text = string.Empty;
                smFastIM.SetFocus(txtEndDt);
                lblStatus.Text = "Invalid End date";
                pnlStatus.Update();
            }
            else
            {
                txtEndDt.Text = Convert.ToDateTime(txtEndDt.Text).ToShortDateString();
                pnlEndDt.Update();
            }

            if (txtStrDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
            {
                txtEndDt.Text = string.Empty;
                smFastIM.SetFocus(txtEndDt);
                lblStatus.Text = "End date must be greater than or equal to Start date (1)";
                pnlStatus.Update();
            }
        }
        catch (Exception ex)
        {
            txtEndDt.Text = string.Empty;
            smFastIM.SetFocus(txtEndDt);
            lblStatus.Text = "Invalid End date (ex)";
            pnlStatus.Update();
        }
    }

    protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
    {
        lblStatus.Text = string.Empty;
        pnlStatus.Update();
        if (ValidateDate(cldEndDt.SelectedDate))
        {
            txtEndDt.Text = cldEndDt.SelectedDate.ToShortDateString();
            pnlEndDt.Update();
            pnlEndPick.Update();
        }
        else
        {
            txtEndDt.Text = string.Empty;
            smFastIM.SetFocus(txtEndDt);
            cldEndDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
        }
        if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
        {
            txtEndDt.Text = string.Empty;
            smFastIM.SetFocus(txtEndDt);
            lblStatus.Text = "End date must be greater than or equal to Start date (2)";
            pnlStatus.Update();
        }
    }
    #endregion EndDt

    private bool ValidateDate(DateTime date)
    {
        if (DateTime.Compare(DateTime.Now, date) == -1)
        {
            lblStatus.Text = "Date must be less than or equal current date";
            pnlStatus.Update();
            return false;
        }
        else
            return true;
    }

    #endregion

    private void DisplayStatusMessage(string message, string messageType)
    {
        lblStatus.Visible = true;
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

    private void DisplayInfoMessage(string message, string messageType)
    {
        lblInfo.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblInfo.ForeColor = System.Drawing.Color.Green;
            lblInfo.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblInfo.ForeColor = System.Drawing.Color.Red;
            lblInfo.Text = message;
        }
        else
        {
            lblInfo.ForeColor = System.Drawing.Color.Black;
            lblInfo.Text = message;
        }

        pnlInfo.Update();
    }

    protected void GetSecurity()
    {
        string _Security = string.Empty;
        _Security = Security.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.IMFastMaint);

        if (_Security.ToString() == "")
        {
            _Security = "None";
            Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
        }
        else
        {
            _Security = "Full";
        }
    }
}
