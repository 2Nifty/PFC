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
using System.Web.UI.Design;
using System.Data.SqlClient;
using System.IO;

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class CVCAdderPage : System.Web.UI.Page
{
    MaintenanceUtility maintenanceUtils = new MaintenanceUtility();
    PFC.Intranet.MaintenanceApps.CVCAdder cvcAdder = new PFC.Intranet.MaintenanceApps.CVCAdder();
    DataTable dtCVCAdderData = new DataTable();
    GridView dv = new GridView();

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    int pageSize = 50;
    string excelFilePath = "../Common/ExcelUploads/";

    protected string CountrySecurity
    {
        get
        {
            return Session["CountrySecurity"].ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            ViewState["Operation"] = "";
            lblMessage.Text = "";
            btnSetAllEffDt.Attributes.Add("onclick", "return confirm('This process will set effecting date for all the CVC Adder records. Are you sure you want to continue?');");

            if (!Page.IsPostBack)
            {
                Session["CountrySecurity"] = null;
                lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
                Session["CountrySecurity"] = maintenanceUtils.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CVCAdder);
                
                
                hidFileName.Value = "CVCAdderReport" + Session["SessionID"].ToString() + ".xls";
                ViewState["Mode"] = "Add";

                // Fill Data Entry Drop Down
                BindDropDown(ddlCategory, "CategoryDesc");
                BindDropDown(ddlPlating, "PlatingCodes");
                BindDropDown(ddlCVCCode, "CVCCodes");
                                                                
                BindDataGrid();                
            }

            if (CountrySecurity == "")
                EnableQueryMode();
        }
        catch (Exception ex)
        {
            DisplaStatusMessage(ex.Message, "Fail");
        }

    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        //BindDataGrid();
        Clear();
        ViewState["Mode"] = "Add";
        DataSet dsResult = cvcAdder.GetCVCAdderTableData("getnextsat", "");
        dpEffectiveDt.SelectedDate = Convert.ToDateTime(dsResult.Tables[0].Rows[0]["DefaultDate"].ToString()).ToShortDateString();
        btnSave.Visible = (CountrySecurity != "") ? true : false;
        btnSetAllEffDt.Visible = (CountrySecurity != "") ? true : false;
        UpdatePanels();        
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
            if (cvcAdder.CheckDataExist(ddlCategory.SelectedValue,ddlPlating.SelectedValue,ddlCVCCode.SelectedValue,""))
            {
                string columnName = "Category,Plating,CVCCd,CorpAdder,PackageCaseAdder,"+
                                    "[1West],[2NW],[3Mtn],[4SW],[5Cntrl],[6SE],[7NE],EffectiveDt," +
                                    "EntryID,EntryDt";

                string columnValue = "'" + ddlCategory.SelectedItem.Value + "'," +
                                     "'" + ddlPlating.SelectedItem.Value + "'," +
                                     "'" + ddlCVCCode.SelectedItem.Value + "'," +
                                     "'" + txtCorpCurrent.Text + "'," +
                                     "'" + txtPkgCaseCurrent.Text + "'," +
                                     "'" + txtWestCurrent.Text + "'," +
                                     "'" + txtNWCurrent.Text + "'," +
                                     "'" + txtMTNCurrent.Text + "'," +
                                     "'" + txtSWCurrent.Text+ "'," +
                                     "'" + txtCNTRLCurrent.Text + "'," +
                                     "'" + txtSECurrent.Text + "'," +                                     
                                     "'" + txtNECurrent.Text + "'," +
                                     "'" + dpEffectiveDt.SelectedDate + "'," +
                                     "'" + Session["UserName"] + "'," +
                                     "'" + DateTime.Now.ToShortDateString() + "'";

                cvcAdder.InsertTables(columnName, columnValue);
                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;
                btnSetAllEffDt.Visible = false;
                btnCancel.Visible = false;
            }
            else
            {
                DisplaStatusMessage("CVC Adder Record Already Exists", "Fail");
                upnlGrid.Update();
                pnlProgress.Update();
                return;
            }
        }
        else
        {
            if (cvcAdder.CheckDataExist(ddlCategory.SelectedValue, ddlPlating.SelectedValue, ddlCVCCode.SelectedValue, hidPrimaryKey.Value))
            {

                string updateValue = "Category='" + ddlCategory.SelectedItem.Value + "'," +
                                     "Plating='" + ddlPlating.SelectedItem.Value + "'," +
                                     "CVCCd='" + ddlCVCCode.SelectedItem.Value + "'," +
                                     "CorpAdder='" + txtCorpCurrent.Text + "'," +
                                     "PackageCaseAdder='" + txtPkgCaseCurrent.Text + "'," +
                                     "[1West]='" + txtWestCurrent.Text + "'," +
                                     "[2NW]='" + txtNWCurrent.Text + "'," +
                                     "[3Mtn]='" + txtMTNCurrent.Text + "'," +
                                     "[4SW]='" + txtSWCurrent.Text + "'," +
                                     "[5Cntrl]='" + txtCNTRLCurrent.Text + "'," +
                                     "[6SE]='" + txtSECurrent.Text + "'," +
                                     "[7NE]='" + txtNECurrent.Text + "'," +
                                     "EffectiveDt='" + dpEffectiveDt.SelectedDate + "'," +
                                     "ChangeID='" + Session["UserName"].ToString() + "'," +
                                     "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                cvcAdder.UpdateTables(updateValue, "pCVCAddersID=" + hidPrimaryKey.Value.Trim());

                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;
                btnSetAllEffDt.Visible = false;
                btnCancel.Visible = false;
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
            }
            else
            {
                DisplaStatusMessage("CVC Adder Record Already Exists", "Fail");
                upnlGrid.Update();
                pnlProgress.Update();
                return;
            }
        }

        ViewState["Operation"] = "Save";
        Clear();
        BindDataGrid();
        UpdatePanels();
    }

    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = false;
        btnSetAllEffDt.Visible = false;
        btnCancel.Visible = false;
        ViewState["Mode"] = "Add";
        
        BindDataGrid();
        UpdatePanels();
    }

    protected void dgCountryCode_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            DataSet dsResult = cvcAdder.GetCVCAdderTableData("getcvcadder", e.CommandArgument.ToString());
            dtCVCAdderData = dsResult.Tables[0];
            DisplayRecord();
            
            btnSave.Visible = (CountrySecurity != "") ? true : false;
            btnSetAllEffDt.Visible = (CountrySecurity != "") ? true : false;

            btnCancel.Visible = true;
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            cvcAdder.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            Clear();
        }

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }
    
    protected void dgCountryCode_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        BindDataGrid();
    }

    protected void dgCountryCode_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item))
        {
            LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
            LinkButton lnkEdit = e.Item.FindControl("lnlEdit") as LinkButton;

            if (e.Item.Cells[19].Text != "&nbsp;" || CountrySecurity == "")
            {
                lnkDelete.Visible = false;

                if (e.Item.Cells[19].Text != "&nbsp;")
                    lnkEdit.Visible = false;
            }

        }
    }

    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";

        
        hidPrimaryKey.Value = dtCVCAdderData.Rows[0]["pCVCAddersID"].ToString().Trim();
        HighLightDropDown(ddlCategory, dtCVCAdderData.Rows[0]["Category"].ToString().Trim());
        HighLightDropDown(ddlPlating, dtCVCAdderData.Rows[0]["Plating"].ToString().Trim());
        HighLightDropDown(ddlCVCCode, dtCVCAdderData.Rows[0]["CVCCd"].ToString().Trim());
        dpEffectiveDt.SelectedDate = Convert.ToDateTime(dtCVCAdderData.Rows[0]["EffectiveDt"].ToString().Trim()).ToShortDateString();
        
        lblCorpPrevious.Text = txtCorpCurrent.Text = dtCVCAdderData.Rows[0]["CorpAdder"].ToString().Trim();         
        lblPkgCasePrevious.Text = txtPkgCaseCurrent.Text = dtCVCAdderData.Rows[0]["packagecaseadder"].ToString().Trim();
        lblWestPrevious.Text = txtWestCurrent.Text = dtCVCAdderData.Rows[0]["1West"].ToString().Trim();
        lblNWPrevious.Text = txtNWCurrent.Text = dtCVCAdderData.Rows[0]["2NW"].ToString().Trim();
        lblMTNPrevious.Text = txtMTNCurrent.Text = dtCVCAdderData.Rows[0]["3Mtn"].ToString().Trim();
        lblSWPrevious.Text = txtSWCurrent.Text = dtCVCAdderData.Rows[0]["4SW"].ToString().Trim();
        lblCNTRLPrevious.Text = txtCNTRLCurrent.Text = dtCVCAdderData.Rows[0]["5CNTRL"].ToString().Trim();
        lblSEPrevious.Text = txtSECurrent.Text = dtCVCAdderData.Rows[0]["6SE"].ToString().Trim();
        lblNEPrevious.Text = txtNECurrent.Text = dtCVCAdderData.Rows[0]["7NE"].ToString().Trim();         

        lblEntryID.Text = dtCVCAdderData.Rows[0]["EntryID"].ToString().Trim();        
        lblChangeID.Text = dtCVCAdderData.Rows[0]["ChangeID"].ToString().Trim();        
        lblChangeDate.Text = (dtCVCAdderData.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dtCVCAdderData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblEntryDate.Text = (dtCVCAdderData.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dtCVCAdderData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
       
    }

    private void BindDataGrid()
    {
        Clear();
        DataSet dsResult;

        if(txtSearchCategory.Text.Trim() == "" && txtSearchPlating.Text.Trim() == "")
            dsResult = cvcAdder.GetCVCAdderTableData("loadgridwithdelete", "");
        else
            dsResult = cvcAdder.GetCVCAdderTableData("searchbar", txtSearchCategory.Text,txtSearchPlating.Text);

        if (dsResult != null)
        {
            if(hidSort.Value != "")
                dsResult.Tables[0].DefaultView.Sort = hidSort.Value;

            if (chkShowDelete.Checked == false)
                dsResult.Tables[0].DefaultView.RowFilter = "DeleteDt is null";

            dgCVCAdder.PageSize = pageSize;
            dgCVCAdder.DataSource = dsResult.Tables[0].DefaultView.ToTable();
            Session["CVCAdderData"] = dsResult.Tables[0].DefaultView.ToTable();
            pager.InitPager(dgCVCAdder, pageSize);

            #region To increase page speed
            //dgCVCAdder.DataBind();

            //int totalNumberOfPages = 0;
            //int totalNoOfRec = dsResult.Tables[0].Rows.Count;

            //if (totalNoOfRec <= pageSize && totalNoOfRec > 0)
            //{
            //    totalNumberOfPages = 1;
            //}
            //else
            //{
            //    if (totalNoOfRec % pageSize == 0)
            //        totalNumberOfPages = totalNoOfRec / pageSize;
            //    else
            //        totalNumberOfPages = totalNoOfRec / pageSize + 1;
            //}

            //pager.InitPager(dgCVCAdder.CurrentPageIndex, totalNumberOfPages, 50, Novantus.Umbrella.UserControls.PagerStyle.ComboDisabled);
            #endregion
        }
        else
            DisplaStatusMessage("No Records Found", "Fail");

    }

    private void UpdatePanels()
    {
        upnlEntry.Update();               
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();
        upnlbtnsave.Update();        
    }

    private void DisableDropDowns()
    {
        ddlCategory.Enabled = false;
    }

    protected void Clear()
    {
        try
        {            
            btnSave.Visible = false;
            btnSetAllEffDt.Visible = false;
            btnCancel.Visible = false;

            ddlCategory.ClearSelection();
            ddlPlating.ClearSelection();
            ddlCVCCode.ClearSelection();
            dpEffectiveDt.SelectedDate = "";

            lblCorpPrevious.Text = txtCorpCurrent.Text = "";
            lblPkgCasePrevious.Text = txtPkgCaseCurrent.Text = "";
            lblWestPrevious.Text = txtWestCurrent.Text = "";
            lblNWPrevious.Text = txtNWCurrent.Text = "";
            lblMTNPrevious.Text = txtMTNCurrent.Text = "";
            lblSWPrevious.Text = txtSWCurrent.Text = "";
            lblSEPrevious.Text = txtSECurrent.Text = "";
            lblNEPrevious.Text = txtNECurrent.Text = "";
            lblCNTRLPrevious.Text = txtCNTRLCurrent.Text = "";  

            lblChangeID.Text =  lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";            
            upnlEntry.Update();            
        }
        catch (Exception ex) { }
    }
    
    private void HighLightDropDown(DropDownList ddlFrom, string comboValueText)
    {
        ddlFrom.ClearSelection();
        ddlFrom.SelectedValue = comboValueText;

        //for (int i = 0; i <= ddlFrom.Items.Count - 1; i++)
        //{
        //    if (ddlFrom.Items[i].Value.Trim() == comboValueText.Trim())
        //        ddlFrom.Items[i].Selected = true;
        //}
    }

    private void BindDropDown(DropDownList ddlFormFieldDtl, string listName)
    {
        try
        {
            string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='" + listName + "' Order by b.SequenceNo";
            string _tableName = "listmaster a,ListDetail b ";
            string _columnName = "b.ListValue as ListValue,b.ListValue +' - ' + b.ListDtlDesc as ListDtlDesc";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlFormFieldDtl.DataSource = dslist.Tables[0];
                ddlFormFieldDtl.DataTextField = "ListDtlDesc";
                ddlFormFieldDtl.DataValueField = "ListValue";
                ddlFormFieldDtl.DataBind();
            }

            ListItem item = new ListItem("     ---Select---     ", "");            
            ddlFormFieldDtl.Items.Insert(0, item);
            
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
        
    private void DisplaStatusMessage(string message, string messageType)
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
    }

    private void EnableQueryMode()
    {
        btnCancel.Visible = false;
        btnSave.Visible = false;
        btnSetAllEffDt.Visible = false;
        btnAdd.Visible = false;
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgCVCAdder.CurrentPageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        Clear();
        ViewState["Mode"] = "Add";        
        UpdatePanels();
    }

    protected void chkShowDelete_CheckedChanged(object sender, EventArgs e)
    {
        BindDataGrid();
        UpdatePanels();
    }

    #region Excel Export

    protected void btnExportExcel_Click(object sender, ImageClickEventArgs e)
    {
        string _excelData = GenerateExportData("Excel");

        FileInfo fnExcel = new FileInfo(Server.MapPath(excelFilePath + hidFileName.Value.ToString()));
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine(_excelData);
        reportWriter.Close();

        // Downloding Process
        FileStream fileStream = File.Open(Server.MapPath(excelFilePath + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        // Download Process
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath(excelFilePath + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    private string GenerateExportData(string dataFormat)
    {
        
        DataTable dtExcelData = Session["CVCAdderData"] as DataTable;

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        headerContent = "<table border='1' width='100%'>";
        headerContent += "<tr><th colspan='17' style='color:blue' align=left><center>CVC Addder Report</center></th></tr>";
        headerContent += "<tr><td colspan='17' align=right><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='17' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = true;
            dv.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            //if(dataFormat == "Print")
            //dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "Category";
            bfExcel.DataField = "Category";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Plating";
            bfExcel.DataField = "Plating";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "CVC";
            bfExcel.DataField = "CVCCd";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Std Cost";
            bfExcel.DataField = "STDCostAdder";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Pkg/Case";
            bfExcel.DataField = "PackageCaseAdder";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "West";
            bfExcel.DataField = "1West";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "NW";
            bfExcel.DataField = "2NW";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Mtn";
            bfExcel.DataField = "3Mtn";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "SW";
            bfExcel.DataField = "4SW";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "CNTRL";
            bfExcel.DataField = "5Cntrl";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "SE";
            bfExcel.DataField = "6SE";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "NE";
            bfExcel.DataField = "7NE";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Eff Date";
            bfExcel.DataField = "EffectiveDt";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Entry ID";
            bfExcel.DataField = "EntryID";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Entry Dt";
            bfExcel.DataField = "EntryDt";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Change ID";
            bfExcel.DataField = "ChangeID";
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Change Dt";
            bfExcel.DataField = "ChangeDt";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            dv.Columns.Add(bfExcel);

            dv.DataSource = dtExcelData;
            dv.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            dv.RenderControl(htw);
            excelContent = sb.ToString();

        }
        else
        {
            excelContent = "<tr  ><th width='100%' align ='center' colspan='17' > No records found</th></tr> </table>";
        }

        return styleSheet + headerContent + excelContent;
    }

    #endregion

    protected void btnSetAllEffDt_Click(object sender, ImageClickEventArgs e)
    {
        cvcAdder.UpdateTables("EffectiveDt='" + dpEffectiveDt.SelectedDate + "'", "DeleteDt is null ");
        DisplaStatusMessage(updateMessage, "Success");
        BindDataGrid();
        UpdatePanels();
    }

}



