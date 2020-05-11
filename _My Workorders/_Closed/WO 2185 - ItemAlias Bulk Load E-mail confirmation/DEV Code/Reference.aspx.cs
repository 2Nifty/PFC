using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.IO;
using System.Text;
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

public partial class ItemBuilderBuilder : System.Web.UI.Page
{
    #region Variable Declarations

   //string custNumber = "";
    string sessionCustomerNo = "";   
    string inpFile;
    DataTable dtItemValidation = new DataTable();
    string PFCQuoteconnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"];   
    DataSet ds = new DataSet();
    SqlConnection PFCERPConnectionString;
    DataTable dtCustomerInformation = new DataTable();   
    DataTable dsRecord = new DataTable();
    ItemBuilder itembuilder = new ItemBuilder();
    MailSystem mail = new MailSystem();

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(ItemBuilderBuilder));
        lblFileMessage.Text = "";
        if (Request.QueryString["UserName"] != null)
        {
            Session["CustNo"] = Request.QueryString["CustomerNumber"].ToString();
            Session["UserName"] = Request.QueryString["UserName"].ToString();
            string chkDCUser = Session["UserName"].ToString().Trim();
            if (chkDCUser == "DC")
            {
                Header1.Visible = false;
                btnUpload.Visible = true;
                btnCancel.Visible = true;
                btnVerify.Visible = false;
                btnClose.Visible = false;
            }
            else
            {
                Header1.Visible = true;
                btnUpload.Visible = false;
                btnCancel.Visible = false;
                btnVerify.Visible = true;
                btnClose.Visible = true;
                rdoExcel.Enabled = true;
                rdoText.Enabled = true;
                rdoRealTime.Enabled = true;
                rdoBatch.Enabled = true;

                //2010-Apr-20 - Remove "Realtime" option
                rdoRealTime.Checked = false;
                rdoRealTime.Enabled = false;
                rdoRealTime.Visible = false;
                rdoText.Checked = false;
                rdoText.Enabled = false;
                rdoText.Visible = false;
                rdoBatch.Checked = true;
                rdoExcel.Checked = true;
            }
        }

        if (rdoBatch.Checked == true)
        {
            rdoText.Checked = false;
            rdoExcel.Checked = true;
            rdoText.Enabled = false;
        }
        else
        {
            rdoText.Enabled = true;
        }

        btnVerify.Attributes.Add("OnClick", "javascript:return SubmitForm()");
        PFCERPConnectionString = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"]);
        uplXRefFile.Enabled = true;       
        
        string customerNo = Session["CustNo"].ToString();
        if (customerNo != "000000")
        {
            dtCustomerInformation = itembuilder.GetCustomerID(customerNo);
            lblCustomerName.Text = dtCustomerInformation.Rows[0]["Name1"].ToString();
            lblAddress.Text = dtCustomerInformation.Rows[0]["AddrLine1"].ToString();
            lblCity.Text = dtCustomerInformation.Rows[0]["City"].ToString();
            lblState.Text = dtCustomerInformation.Rows[0]["State"].ToString();
            lblPostCd.Text = dtCustomerInformation.Rows[0]["PostCd"].ToString();
        }
        else
        {
            lblCustomerName.Text = "Customer #000000";
            lblAddress.Text = "Generic Cross Reference Item Entry";
            lblCity.Text = "";
            lblState.Text = "";
            lblPostCd.Text = "";
        }
    }    

    protected void lnkFirsPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = 0;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    protected void lnlPreviousPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = dgCrossReference.CurrentPageIndex - 1;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    protected void lnkLastPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = dgCrossReference.PageCount - 1;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    protected void ddlFilterPage_SelectedIndexChanged(object sender, EventArgs e)
    {
        dgCrossReference.CurrentPageIndex = Convert.ToInt32(ddlFilterPage.SelectedItem.Value);
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        EnableLinksFilter();
    }

    protected void lnkNextPage_Command(object sender, CommandEventArgs e)
    {
        dgCrossReference.CurrentPageIndex = dgCrossReference.CurrentPageIndex + 1;
        dgCrossReference.DataSource = (DataTable)ViewState["DT"];
        dgCrossReference.DataBind();
        ddlFilterPage.SelectedIndex = dgCrossReference.CurrentPageIndex;
        EnableLinksFilter();
    }

    void EnableLinksFilter()
    {
        lnkFirsPage.Enabled = true;
        lnkLastPage.Enabled = true;
        lnlPreviousPage.Enabled = true;
        lnkNextPage.Enabled = true;

        if (dgCrossReference.CurrentPageIndex == 0)
        {
            lnkFirsPage.Enabled = false;
            lnlPreviousPage.Enabled = false;
        }

        if (dgCrossReference.CurrentPageIndex == dgCrossReference.PageCount - 1)
        {
            lnkLastPage.Enabled = false;
            lnkNextPage.Enabled = false;
        }
    }  

    public static DataSet ConvertTextFileToDataset(string File, string TableName, string delimiter)
    {
        StreamReader s = new StreamReader(File);
        string pfcItem1stRow = "";
        string custItem1stRow = "";
        string whseNo1stRow = "";
        string desc1stRow = "";
        bool headerAdded = false;

        try
        {
            //The DataSet to Return
            DataSet result = new DataSet();

            //Open the file in a stream reader.           
            //Split the first line into the columns
            string[] columns = new string[4];
            string[] readrFirstLine = s.ReadLine().Split(delimiter.ToCharArray());

            columns[0] = readrFirstLine[0];
            columns[1] = readrFirstLine[1];
            if (readrFirstLine.Length == 2)
                columns[2] = "";
            else
                columns[2] = readrFirstLine[2];

            if (readrFirstLine.Length == 3)
                columns[3] = "";
            else
                columns[3] = readrFirstLine[3];

            //string[] columns = s.ReadLine().Split(delimiter.ToCharArray());

            if (columns[0].Contains("-"))
            {
                pfcItem1stRow = columns[0];
                custItem1stRow = columns[1];
                whseNo1stRow = columns[2];
                desc1stRow = columns[3];
                headerAdded = true;
            }

            columns[0] = "Item";
            columns[1] = "XRef";
            columns[2] = "AliasWhseNo";
            columns[3] = "AliasDesc";
            
            //Add the new DataTable to the RecordSet
            result.Tables.Add(TableName);            

            //Cycle the columns, adding those that don't exist yet and sequencing the ones that do.
            foreach (string col in columns)
            {
                if (col != "")
                {
                    bool added = false;
                    string next = "";
                    int i = 0;
                    while (!added)
                    {
                        //Build the column name and remove any unwanted characters.
                        string columnname = col + next;
                        columnname = columnname.Replace("#", "");
                        columnname = columnname.Replace("'", "");
                        columnname = columnname.Replace("&", "");

                        //See if the column already exists
                        if (!result.Tables[TableName].Columns.Contains(columnname))
                        {
                            //if it doesn't then we add it here and mark it as added
                            result.Tables[TableName].Columns.Add(columnname);
                            added = true;
                        }
                        else
                        {
                            //if it did exist then we increment the sequencer and try again.
                            i++;
                            next = "_" + i.ToString();
                        }
                    }
                }
            }

            //Read the rest of the data in the file.        
            string AllData = s.ReadToEnd();

            //Split off each row at the Carriage Return/Line Feed
            //Default line ending in most windows exports.  
            //You may have to edit this to match your particular file.
            //This will work for Excel, Access, etc. default exports.
            string[] rows = AllData.Split("\r\n".ToCharArray());

            //Now add each row to the DataSet        
            foreach (string r in rows)
            {
                //Split the row at the delimiter.
                string[] items = r.Split(delimiter.ToCharArray());

                //Only when PFC Item number is not empty add it to grid
                if (items[0].ToString() != "")
                    result.Tables[TableName].Rows.Add(items);
            }

            s.Dispose();

            if (headerAdded)
            {
                DataRow firstRow = result.Tables[TableName].NewRow();
                firstRow[0] = pfcItem1stRow;
                firstRow[1] = custItem1stRow;
                firstRow[2] = whseNo1stRow;
                firstRow[3] = desc1stRow;
                result.Tables[TableName].Rows.InsertAt(firstRow, 0);
            }
            
            result.Tables[TableName].Columns[0].Unique = true;
            
            //Return the imported data.        
            return result;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            s.Dispose();
        }
    }

    protected void txtXRef_TextChanged(object sender, EventArgs e)
    {
        lblErrorMsg.Text = "";
        
        TextBox txtXref = sender as TextBox;
        DataGridItem dgItem = txtXref.Parent.Parent as DataGridItem;
        Label lblItem = dgItem.FindControl("lblItem") as Label;
        string pfcItemNumber = lblItem.Text;
        string Xref = txtXref.Text;
        DataTable dtNew = new DataTable();
        dtNew = (DataTable)ViewState["DT"];
        DataRow[] UpdateRow = dtNew.Select("Item='" + pfcItemNumber + "'");
        if (UpdateRow != null)
        {
            try
            {
                for (int i = 0; i < dtNew.Rows.Count; i++)
                {
                    if (Xref == dtNew.Rows[i]["XRef"].ToString())
                    {
                        lblErrorMsg.Text = "Customer Item Number does not allow duplicate information.";
                        lblErrorMsg.Visible = true;
                        lblErrorMsg.ForeColor = System.Drawing.Color.Red;
                        //tblPager.Visible = false;
                        txtXref.Text = dtNew.Rows[i]["XRef"].ToString();                        
                        dgCrossReference.DataSource = dtNew;
                        dgCrossReference.CurrentPageIndex = 0;
                        ddlFilterPage.Items.Clear();
                        dgCrossReference.DataBind();
                        for (int intcount = 0; intcount < dgCrossReference.PageCount; intcount++)
                        {
                            ListItem LI = new ListItem();
                            LI.Value = Convert.ToString(intcount);
                            LI.Text = Convert.ToString(intcount + 1) + " of " + dgCrossReference.PageCount.ToString();
                            ddlFilterPage.Items.Add(LI);
                        }

                        EnableLinksFilter();
                        dgCrossReference.DataBind();
                        ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                        scriptManager.SetFocus(txtXref);
                        return;
                    }
                }
                UpdateRow[0]["Item"] = pfcItemNumber;
                UpdateRow[0]["XRef"] = Xref;
                ((DataTable)ViewState["DT"]).Rows.Add(UpdateRow);
                DataTable dt = (DataTable)ViewState["DT"];

                int RowIndex = dt.Rows.Count;
                RowIndex = RowIndex - 1;
                ((DataRow)(dt.Rows[RowIndex])).Delete();
                dt.AcceptChanges();  
            }
            catch (Exception )
            {
                DataTable dt = (DataTable)ViewState["DT"];
            }
        }

        int selectedRow = dgItem.ItemIndex;

        if (dgItem.ItemIndex != dgCrossReference.Items.Count -1)
        {
            DataGridItem dgNextRow = dgCrossReference.Items[selectedRow + 1] as DataGridItem;
            if (dgNextRow != null)
            {
                TextBox txtNextXRef = dgNextRow.FindControl("txtXRef") as TextBox;
                ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                scriptManager.SetFocus(txtNextXRef);
            }
        }
    }

    protected void txtDesc_TextChanged(object sender, EventArgs e)
    {
        lblErrorMsg.Text = "";

        TextBox txtDesc = sender as TextBox;
        DataGridItem dgItem = txtDesc.Parent.Parent as DataGridItem;
        Label lblItem = dgItem.FindControl("lblItem") as Label;
        string pfcItemNumber = lblItem.Text;
        string Desc = txtDesc.Text;
        DataTable dtNew = new DataTable();
        dtNew = (DataTable)ViewState["DT"];
        DataRow[] UpdateRow = dtNew.Select("Item='" + pfcItemNumber + "'");
        if (UpdateRow != null)
        {
            try
            {
                UpdateRow[0]["Item"] = pfcItemNumber;
                UpdateRow[0]["AliasDesc"] = Desc;
                ((DataTable)ViewState["DT"]).Rows.Add(UpdateRow);
                DataTable dt = (DataTable)ViewState["DT"];

                int RowIndex = dt.Rows.Count;
                RowIndex = RowIndex - 1;
                ((DataRow)(dt.Rows[RowIndex])).Delete();
                dt.AcceptChanges();
            }
            catch (Exception)
            {
                DataTable dt = (DataTable)ViewState["DT"];
            }
        }

        int selectedRow = dgItem.ItemIndex;

        if (dgItem.ItemIndex != dgCrossReference.Items.Count - 1)
        {
            DataGridItem dgNextRow = dgCrossReference.Items[selectedRow + 1] as DataGridItem;
            if (dgNextRow != null)
            {
                TextBox txtNextXRef = dgNextRow.FindControl("txtXRef") as TextBox;
                ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                scriptManager.SetFocus(txtNextXRef);
            }
        }
    }

    protected void btnVerify_Click(object sender, EventArgs e)
    {
        try
        {
            if (uplXRefFile.HasFile)
            {
                sessionCustomerNo = Session["CustNo"].ToString();
                Server.MapPath(".");
                uplXRefFile.SaveAs(@Server.MapPath(".") + "/Export/" + uplXRefFile.FileName);
                inpFile = Server.MapPath(".") + "/Export/" + uplXRefFile.FileName;

                #region Reading Excel/Txt file into DataTable

                if (rdoExcel.Checked == true)
                {
                    String strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;"
                                        + "Data Source=" + inpFile + ";"
                                        + "Extended Properties='Excel 8.0;HDR=No;IMEX=1'";
                    //String strExcelConn = "Provider=Microsoft.ACE.OLEDB.12.0;"
                    //                    + "Data Source=" + inpFile + ";"
                    //                    + "Extended Properties='Excel 12.0;HDR=No;IMEX=1'";
                    OleDbConnection connExcel = new OleDbConnection(strExcelConn);
                    OleDbCommand cmdExcel = new OleDbCommand();
                    cmdExcel.Connection = connExcel;
                    connExcel.Open();
                    DataTable dtExcelSchema;
                    dtExcelSchema = connExcel.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    connExcel.Close();
                    string sheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                    OleDbDataAdapter da = new OleDbDataAdapter();
                    string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                    cmdExcel.CommandText = "SELECT * From [" + SheetName + "]";
                    da.SelectCommand = cmdExcel;
                    da.Fill(ds);                                    

                    //Convert Xref column to String datatype
                    DataTable newDataTable = ds.Tables[0].Clone();
                    foreach (DataColumn dc in newDataTable.Columns)
                    {
                        dc.DataType = typeof(string);
                    }
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        newDataTable.ImportRow(dr);
                    }

                    //If Excel contains only two or 3 columns then add the Whse & Desc columns
                    if (newDataTable.Columns.Count == 2)
                        newDataTable.Columns.Add("AliasWhseNo");

                    if (newDataTable.Columns.Count == 3)
                        newDataTable.Columns.Add("AliasDesc");

                    if (!newDataTable.Rows[0][0].ToString().Contains("-"))
                        newDataTable.Rows.RemoveAt(0);

                    newDataTable.Columns[0].ColumnName = "Item";
                    newDataTable.Columns[1].ColumnName = "XRef";
                    newDataTable.Columns[2].ColumnName = "AliasWhseNo";
                    newDataTable.Columns[3].ColumnName = "AliasDesc";

                    if (newDataTable.Columns.Count == 10)
                    {
                        newDataTable.Columns[4].ColumnName = "AliasType";
                        newDataTable.Columns[5].ColumnName = "UOM";
                        newDataTable.Columns[6].ColumnName = "CustBinLoc";
                        newDataTable.Columns[7].ColumnName = "CustClassCd";
                        newDataTable.Columns[8].ColumnName = "CustomerUPC";
                        newDataTable.Columns[9].ColumnName = "OrganizationNo";
                    }

                    //switch (newDataTable.Columns.Count)
                    //{
                    //    case 4 :
                    //        newDataTable.Columns[0].ColumnName = "Item";
                    //        newDataTable.Columns[1].ColumnName = "XRef";
                    //        newDataTable.Columns[2].ColumnName = "AliasWhseNo";
                    //        newDataTable.Columns[3].ColumnName = "AliasDesc";
                    //    break;
                    //    case 10 :
                    //        newDataTable.Columns[0].ColumnName = "Item";
                    //        newDataTable.Columns[1].ColumnName = "XRef";
                    //        newDataTable.Columns[2].ColumnName = "AliasWhseNo";
                    //        newDataTable.Columns[3].ColumnName = "AliasDesc";
                    //        newDataTable.Columns[4].ColumnName = "AliasType";
                    //        newDataTable.Columns[5].ColumnName = "UOM";
                    //        newDataTable.Columns[6].ColumnName = "CustBinLoc";
                    //        newDataTable.Columns[7].ColumnName = "CustClassCd";
                    //        newDataTable.Columns[8].ColumnName = "CustomerUPC";
                    //        newDataTable.Columns[9].ColumnName = "OrganizationNo";
                    //    break;
                    //    default :
                    //        lblFileMessage.Text = "File Has Invalid Column Layout.";
                    //        lblFileMessage.Visible = true;
                    //        lblFileMessage.ForeColor = System.Drawing.Color.Red;
                    //        tblPager.Visible = false;
                    //        return;
                    //    break;
                    //}

                    //Remove empty row from data table
                    newDataTable.DefaultView.RowFilter = "Item<>'' AND XRef <>''";

                    ds.Tables.Clear();
                    ds.Tables.Add(newDataTable.DefaultView.ToTable());                   
                }
                else
                {
                    ds = ConvertTextFileToDataset(inpFile, "UploadFile", "\t");
                }

                #endregion

                if (rdoRealTime.Checked == true)
                {
                    //Check PFC item number contains unique record
                    try
                    {
                        ds.Tables[0].Columns[0].Unique = true;
                    }
                    catch (Exception exe)
                    {
                        lblFileMessage.Text = "PFC Item # contains duplicate rows.";
                        lblFileMessage.Visible = true;
                        lblFileMessage.ForeColor = System.Drawing.Color.Red;
                        tblPager.Visible = false;
                        return;
                    }

                    //Check Xref Field contains unique values
                    try
                    {
                        ds.Tables[0].Columns[1].Unique = true;
                    }
                    catch (Exception exe)
                    {
                        lblFileMessage.Text = "XRef field contains duplicate rows.";
                        lblFileMessage.Visible = true;
                        lblFileMessage.ForeColor = System.Drawing.Color.Red;
                        tblPager.Visible = false;
                        return;
                    }

                    //Check All the PFC Item numbers are valid
                    string ItemNo = "";
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                        ItemNo += ",'" + ds.Tables[0].Rows[i]["Item"].ToString() + "'";
                    ItemNo = ItemNo.Remove(0, 1);
                    dtItemValidation = itembuilder.CheckItemValidation(ItemNo);
                    if (ds.Tables[0].Rows.Count != dtItemValidation.Rows.Count)
                    {
                        lblFileMessage.Text = "PFC Item # contains Invalid data.";
                        lblFileMessage.Visible = true;
                        lblFileMessage.ForeColor = System.Drawing.Color.Red;
                        tblPager.Visible = false;
                        return;
                    } 
                }

                dgCrossReference.DataSource = ds.Tables[0].DefaultView;
                ViewState["DT"] = ds.Tables[0];
                dgCrossReference.CurrentPageIndex = 0;
                ddlFilterPage.Items.Clear();
                dgCrossReference.DataBind();

                for (int intcount = 0; intcount < dgCrossReference.PageCount; intcount++)
                {
                    ListItem LI = new ListItem();
                    LI.Value = Convert.ToString(intcount);
                    LI.Text = Convert.ToString(intcount + 1) + " of " + dgCrossReference.PageCount.ToString();
                    ddlFilterPage.Items.Add(LI);
                }

                EnableLinksFilter();

                lblUpdateMessage.Visible = false;
                btnUpload.Visible = true;
                btnCancel.Visible = true;
                btnVerify.Visible = false;
                btnClose.Visible = false;
                lblFileMessage.Text = "Upload File Successfully Verified";
                lblFileMessage.ForeColor = System.Drawing.Color.Green;
                dgCrossReference.Visible = true;
                tblPager.Visible = true;

                rdoExcel.Enabled = false;
                rdoText.Enabled = false;
                rdoRealTime.Enabled = false;
                rdoBatch.Enabled = false;
                uplXRefFile.Enabled = false;
            }
            else
            {
                lblFileMessage.Text = "Invalid File Path.";
                lblFileMessage.Visible = true;
                lblFileMessage.ForeColor = System.Drawing.Color.Red;
                tblPager.Visible = false;
            }
        }
        catch (Exception ex)
        {
            //lblFileMessage.Text = "PFC Item # contains duplicate rows.";
            lblFileMessage.Text = "Error Processing File.";
            lblFileMessage.Visible = true;
            lblFileMessage.ForeColor = System.Drawing.Color.Red;
            tblPager.Visible = false;
            return;
        }
        finally
        {
            //Once file information read to the Grid, delete the file uploaded
            FileInfo fileInfo = new FileInfo(inpFile);
            if (fileInfo.Exists)
                fileInfo.Delete(); 
        }
    }  

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        DataTable dtInsert = (DataTable)ViewState["DT"];

        if (rdoRealTime.Checked == true)
        {
            try
            {
                if (dtInsert.Rows.Count > 0)
                    dtInsert.Columns["XRef"].Unique = true;
            }
            catch (Exception ex)
            {
                lblFileMessage.Text = "X-Ref # contains duplicate rows.";
                lblFileMessage.Visible = true;
                lblFileMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }
        }

        if (rdoBatch.Checked == true)
        {
            //delete all records for this cust from queue table
            itembuilder.DeleteCrossReferenceQueue(Session["CustNo"].ToString());
        }

        for (int i = 0; i < dtInsert.Rows.Count; i++)
        {
            string columnNames = "";
            string columnValues = "";

            string updXRef, updWhseNo, updDesc, updUOM, updBinLoc, updClassCd, updUPC;

            updXRef = dtInsert.Rows[i]["XRef"].ToString();
            if (updXRef.Length > 30) updXRef = updXRef.ToString().Substring(0,30);

            updWhseNo = dtInsert.Rows[i]["AliasWhseNo"].ToString();
            if (updWhseNo.Length > 20) updWhseNo = updWhseNo.ToString().Substring(0,20);

            updDesc = dtInsert.Rows[i]["AliasDesc"].ToString();
            if (updDesc.Length > 50) updDesc = updDesc.ToString().Substring(0,50);

            if (dtInsert.Columns.Count == 10)
            {
                updUOM = dtInsert.Rows[i]["UOM"].ToString();
                if (updUOM.Length > 10) updUOM = updUOM.ToString().Substring(0, 10);

                updBinLoc = dtInsert.Rows[i]["CustBinLoc"].ToString();
                if (updBinLoc.Length > 15) updBinLoc = updBinLoc.ToString().Substring(0, 15);

                updClassCd = dtInsert.Rows[i]["CustClassCd"].ToString();
                if (updClassCd.Length > 3) updClassCd = updClassCd.ToString().Substring(0, 3);

                updUPC = dtInsert.Rows[i]["CustomerUPC"].ToString();
                if (updUPC.Length > 12) updUPC = updUPC.ToString().Substring(0, 12);
                
                columnNames = "ItemNo, AliasItemNo, AliasWhseNo, AliasDesc, AliasType, UOM, CustBinLoc, CustClassCd, CustomerUPC, OrganizationNo, EntryID, EntryDt";
                columnValues = "'" + dtInsert.Rows[i]["Item"].ToString() + "', " +
                                      "'" + updXRef.ToString().Replace("'", "''") + "', " +
                                      "'" + updWhseNo.ToString().Replace("'", "''") + "', " +
                                      "'" + updDesc.ToString().Replace("'", "''") + "', " +
                                      //"'" + dtInsert.Rows[i]["AliasType"].ToString() + "', " +
                                      "'C', " +
                                      "'" + updUOM.ToString().Replace("'", "''") + "', " +
                                      "'" + updBinLoc.ToString().Replace("'", "''") + "', " +
                                      "'" + updClassCd.ToString().Replace("'", "''") + "', " +
                                      "'" + updUPC.ToString().Replace("'", "''") + "', " +
                                      "'" + Session["CustNo"].ToString() + "', " +
                                      "'" + Session["UserName"].ToString() + "', " +
                                      "'" + DateTime.Now + "'";
            }
            else
            {
                columnNames = "ItemNo, AliasItemNo, AliasWhseNo, AliasDesc, AliasType, OrganizationNo, EntryID, EntryDt";
                columnValues = "'" + dtInsert.Rows[i]["Item"].ToString() + "', " +
                                      "'" + updXRef.ToString().Replace("'", "''") + "', " +
                                      "'" + updWhseNo.ToString().Replace("'", "''") + "', " +
                                      "'" + updDesc.ToString().Replace("'", "''") + "', " +
                                      "'C', " +
                                      "'" + Session["CustNo"].ToString() + "', " +
                                      "'" + Session["UserName"].ToString() + "', " +
                                      "'" + DateTime.Now + "'";
            }

            string tableName = "";
            if (rdoBatch.Checked == true)
            {
                tableName = "[ItemAliasUploadQueue]";
            }
            else
            {
                tableName = "[ItemAlias]";
                itembuilder.DeleteCrossReferenceNumber(dtInsert.Rows[i]["Item"].ToString(), updXRef.ToString().Replace("'", "''"), Session["CustNo"].ToString());
            }
            
            itembuilder.InsertAlias(tableName, columnNames, columnValues);
        }

        ResetDisplay();

        string _mailFrom = Session["SalesPersonEmail"].ToString();
        string _mailTo = Session["SalesPersonEmail"].ToString();
        string _mailTo = "it_ops@porteousfastener.com; " + Session["SalesPersonEmail"].ToString();
        string _mailSubj;
        string _mailBody;
        string _AliasCount = itembuilder.ItemAliasCount(Session["CustNo"].ToString());

        if (rdoBatch.Checked == true)
        {
            _mailSubj = "Cross Reference Builder: ItemAlias update for Cust #" + Session["CustNo"].ToString() + " added to nightly processing queue";
            _mailBody = "Cust No: <b>" + Session["CustNo"].ToString() + "</b><br>";
            _mailBody += "Submitted by: <b>" + Session["UserName"].ToString() + "</b><br>";
            _mailBody += "Existing record count: <b>" + _AliasCount + "</b><br>";
            _mailBody += "Uploaded record count: <b>" + dtInsert.Rows.Count.ToString() + "</b><br>";
            _mailBody += "Queue table: <b>ItemAliasUploadQueue" + "</b><br>";
            _mailBody += "Production table: <b>ItemAlias" + "</b><br>";
            _mailBody += "Backup table: <b>ItemAliasDeletes" + "</b><br>";
            _mailBody += "Exceptions table: <b>tItemAliasUploadExceptions" + "</b><br>";
            _mailBody += "DTS: <b>WO1665_ProcessItemAliasUploadQueue.dts" + "</b><br><br>";
            _mailBody += "An ItemAlias update has been sent to the nightly processing queue.  <b>This data will be processed tonight.</b>" + "<br><br>";
            _mailBody += "<b>WARNING:</b> All existing Cross Reference records (ItemAlias) for the specified CustNo ";
            _mailBody += "will be saved in the Backup table and then DELETED from the PRODUCTION table ";
            _mailBody += "prior to being reloaded from the Queue table.";
            ScriptManager.RegisterClientScriptBlock(btnUpload, btnUpload.GetType(), "Insert", "alert('Batch file successfully queued for processing')", true);
        }
        else
        {
            _mailSubj = "Cross Reference Builder: Cust #" + Session["CustNo"].ToString() + ": ItemAlias UPDATED";
            _mailBody = "Cust No: <b>" + Session["CustNo"].ToString() + "</b><br>";
            ScriptManager.RegisterClientScriptBlock(btnUpload, btnUpload.GetType(), "Insert", "alert('Cross reference file loaded successfully')", true);
        }

        mail.SendMail(_mailFrom, _mailTo, _mailSubj, _mailBody);
    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        String delFile = "ItemAlias(" + Session["CustNo"].ToString() + ")" + Session["SessionID"];
        DeleteExcel(delFile);
        ScriptManager.RegisterClientScriptBlock(btnClose, btnClose.GetType(), "close", "window.close();", true);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetDisplay();
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        ResetDisplay();

        string strSQL = "SELECT ItemNo AS Item, AliasItemNo AS XRef, AliasWhseNo, AliasDesc, AliasType, UOM, CustBinLoc, CustClassCd, CustomerUPC, OrganizationNo ";
        strSQL += "FROM ItemAlias (NoLock) WHERE AliasType = 'C' AND OrganizationNo = '" + Session["CustNo"].ToString() + "' AND (DeleteDt = '' OR DeleteDt is null) ";
        strSQL += "ORDER BY ItemNo, AliasItemNo";
        string strIns = "INSERT INTO ItemAliasWS (Item, XRef, AliasWhseNo, AliasDesc, AliasType, UOM, CustBinLoc, CustClassCd, CustomerUPC, OrganizationNo) ";
        DataSet dsExport = SqlHelper.ExecuteDataset(PFCERPConnectionString, CommandType.Text, strSQL);

        //char tab = '\t';

        String delFile = "ItemAlias(" + Session["CustNo"].ToString() + ")" + Session["SessionID"];
        DeleteExcel(delFile);

        String xlsFile = "ItemAlias(" + Session["CustNo"].ToString() + ")" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//ItemBuilder//Common//Excel//") + xlsFile;

        //StreamWriter swExcel = new StreamWriter(ExportFile, false);

        //swExcel.WriteLine("Item" + tab + "XRef" + tab + "AliasWhseNo" + tab + "AliasDesc" + tab + "AliasType" + tab +
        //                  "UOM" + tab + "CustBinLoc" + tab + "CustClassCd" + tab + "CustomerUPC" + tab + "OrganizationNo");

        //foreach (DataRow Row in dsExport.Tables[0].Rows)
        //    swExcel.WriteLine(Row["Item"].ToString() + tab + Row["XRef"].ToString() + tab + Row["AliasWhseNo"].ToString() + tab +
        //                      Row["AliasDesc"].ToString() + tab + Row["AliasType"].ToString() + tab + Row["UOM"].ToString() + tab +
        //                      Row["CustBinLoc"].ToString() + tab + Row["CustClassCd"].ToString() + tab + Row["CustomerUPC"].ToString() + tab + 
        //                      Row["OrganizationNo"].ToString());
        //swExcel.Close();


        ////http://support.microsoft.com/kb/316934
        OleDbConnection xlsConn = new OleDbConnection();
        xlsConn.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ExportFile + ";Extended Properties='Excel 8.0;HDR=Yes'";
        xlsConn.Open();
        OleDbCommand xlsCreate = new OleDbCommand();
        xlsCreate.CommandText = "CREATE TABLE [ItemAliasWS] ([Item] string, [XRef] string, [AliasWhseNo] string, [AliasDesc] string, [AliasType] string, [UOM] string, [CustBinLoc] string, [CustClassCd] string, [CustomerUPC] string, [OrganizationNo] string)";
        xlsCreate.Connection = xlsConn;
        xlsCreate.ExecuteNonQuery();

        foreach (DataRow Row in dsExport.Tables[0].Rows)
        {
            xlsCreate.CommandText = strIns + "VALUES ('" + Row["Item"].ToString() + "', '" +
                                                           Row["XRef"].ToString().Replace("'", "''") + "', '" +
                                                           Row["AliasWhseNo"].ToString().Replace("'", "''") + "', '" +
                                                           Row["AliasDesc"].ToString().Replace("'", "''") + "', '" +
                                                           Row["AliasType"].ToString() + "', '" +
                                                           Row["UOM"].ToString().Replace("'", "''") + "', '" +
                                                           Row["CustBinLoc"].ToString().Replace("'", "''") + "', '" +
                                                           Row["CustClassCd"].ToString().Replace("'", "''") + "', '" +
                                                           Row["CustomerUPC"].ToString().Replace("'", "''") + "', '" +
                                                           Row["OrganizationNo"].ToString() + "')";
            xlsCreate.ExecuteNonQuery();
        }

        xlsConn.Close();

        //Response.Redirect("ExcelExport.aspx?Filename=../ItemBuilder/Common/Excel/" + xlsFile, true);
        string URL = "ExcelExport.aspx?Filename=../ItemBuilder/Common/Excel/" + xlsFile;
        string script = "window.open('" + URL + "' ,'export','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	";
        ScriptManager.RegisterClientScriptBlock(btnExport, btnExport.GetType(), "export", script, true);
    }

    //[Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//ItemBuilder//Common//Excel//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }

    protected void btnHelp_Click(object sender, EventArgs e)
    {
        tblPager.Visible = false;
    }

    protected void ResetDisplay()
    {
        rdoExcel.Enabled = true;
        if (rdoBatch.Checked != true) rdoText.Enabled = true;
        rdoRealTime.Enabled = true;
        rdoBatch.Enabled = true;

        //2010-Apr-20 - Remove "Realtime" option
        rdoRealTime.Checked = false;
        rdoRealTime.Enabled = false;
        rdoRealTime.Visible = false;
        rdoText.Checked = false;
        rdoText.Enabled = false;
        rdoText.Visible = false;
        rdoBatch.Checked = true;
        rdoExcel.Checked = true;


        uplXRefFile.Enabled = true;

        dgCrossReference.DataSource = null;
        dgCrossReference.DataBind();
        btnVerify.Visible = true;
        btnClose.Visible = true;
        btnUpload.Visible = false;
        btnCancel.Visible = false;
        tblPager.Visible = false;
        lblFileMessage.Text = "";
        lblErrorMsg.Text = "";
    }

    #region Distinct Class
    private static DataTable SelectDistinct(DataTable SourceTable, params string[] FieldNames)
    {
        object[] lastValues;
        DataTable newTable;
        DataRow[] orderedRows;

        if (FieldNames == null || FieldNames.Length == 0)
            throw new ArgumentNullException("FieldNames");

        lastValues = new object[FieldNames.Length];
        newTable = new DataTable();

        foreach (string fieldName in FieldNames)
            newTable.Columns.Add(fieldName, SourceTable.Columns[fieldName].DataType);

        orderedRows = SourceTable.Select("", string.Join(", ", FieldNames));

        foreach (DataRow row in orderedRows)
        {
            if (!fieldValuesAreEqual(lastValues, row, FieldNames))
            {
                newTable.Rows.Add(createRowClone(row, newTable.NewRow(), FieldNames));

                setLastValues(lastValues, row, FieldNames);
            }
        }

        return newTable;
    }

    private static bool fieldValuesAreEqual(object[] lastValues, DataRow currentRow, string[] fieldNames)
    {
        bool areEqual = true;

        for (int i = 0; i < fieldNames.Length; i++)
        {
            if (lastValues[i] == null || !lastValues[i].Equals(currentRow[fieldNames[i]]))
            {
                areEqual = false;
                break;
            }
        }

        return areEqual;
    }

    private static DataRow createRowClone(DataRow sourceRow, DataRow newRow, string[] fieldNames)
    {
        foreach (string field in fieldNames)
            newRow[field] = sourceRow[field];

        return newRow;
    }

    private static void setLastValues(object[] lastValues, DataRow sourceRow, string[] fieldNames)
    {
        for (int i = 0; i < fieldNames.Length; i++)
            lastValues[i] = sourceRow[fieldNames[i]];
    } 


    #endregion
}
