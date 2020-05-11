using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class RBReceiptsLPDetail : System.Web.UI.Page
{
    string RBConnectionString = ConfigurationManager.ConnectionStrings["PFCRBConnectionString"].ToString();
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string SessionTableName = "LPNDetail";
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    GridViewRow row;
    LinkButton LPNLink;
    bool LineError;
    private string NumFieldFormat = "{0:#########0.000}, ";
    private string IntFieldFormat = "{0:#########0}, ";
    private string StringFieldFormat = "'{0}', ";
    private string DateFieldFormat = "'{0:MM/dd/yy}', ";

    #region Insert Columns
    private string DetailColumnNames = "ItemNo, Location, BinLocation, AdjustedQty, ContainerNo, BOLNo, " +
        "ReasonName, EntryDt, EntryID";
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LocLabel.Text = Request.QueryString["Loc"].ToString();
            LPNLabel.Text = Request.QueryString["LPNumber"].ToString();
            Session["FooterTitle"] = "ERP Warehouse Receiving";
            GetLPNData();
        }
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(RBReceiptsLPDetail));
    }

    protected void GetLPNData()
    {
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWHSLPNDetail",
                      new SqlParameter("@Branch", LocLabel.Text.Substring(0,2)),
                      new SqlParameter("@LPN", LPNLabel.Text.Trim()));
            if (ds.Tables.Count == 1)
            {
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    DataColumn column = new DataColumn();
                    column.DataType = Type.GetType("System.Boolean");
                    column.ColumnName = "Adjust";
                    column.Caption = "Select";
                    column.ReadOnly = false;
                    column.Unique = false;
                    column.DefaultValue = false;
                    dt.Columns.Add(column);
                    DataColumn column2 = new DataColumn();
                    column2.DataType = Type.GetType("System.String");
                    column2.ColumnName = "AdjustDesc";
                    //column.Caption = "Select";
                    column2.ReadOnly = false;
                    column2.Unique = false;
                    column2.DefaultValue = "None";
                    dt.Columns.Add(column2);
                    DataColumn column3 = new DataColumn();
                    column3.DataType = Type.GetType("System.Int16");
                    column3.ColumnName = "AdjustQty";
                    column3.Caption = "AdjustQty";
                    column3.ReadOnly = false;
                    column3.Unique = false;
                    column3.DefaultValue = 0;
                    dt.Columns.Add(column3);
                    LPNGridView.DataSource = dt;
                    LPNGridView.DataBind();
                    Session[SessionTableName] = dt;
                }
                else
                {
                    lblErrorMessage.Text = "No data for LPN " + LPNLabel.Text;
                    MessageUpdatePanel.Update();
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pWHSLPNDetail Error " + e3.Message + ", " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void AdjustSubmit_Click(object sender, EventArgs e)
    {
        DataTable tempDt = (DataTable)Session[SessionTableName];
        DataRow[] LPNRows =
           tempDt.Select("Adjust");
        int AdjustmentCount = 0;
        if (LPNRows.Length == 0)
        {
            lblErrorMessage.Text = "Check the check box to the left of the Item number to make that adjustment. ";
            MessageUpdatePanel.Update();
        }
        else
        {
            try
            {
                foreach (DataRow LPNRow in LPNRows)
                {
                    if ((bool)LPNRow["Adjust"])
                    {
                        //lblErrorMessage.Text = LPNRow["ToRcvQty"].ToString() + ":" + LPNRow["AdjustQty"].ToString() + ":" + LPNRow["AdjustDesc"].ToString();
                        if (int.Parse(LPNRow["ToRcvQty"].ToString(), NumberStyles.Number)!= 0)
                        {
                            try
                            {
                                // move the qty in RB.
                                ds = SqlHelper.ExecuteDataset(RBConnectionString, "pWHSLPNAccept",
                                    new SqlParameter("@Branch", LocLabel.Text.Substring(0, 2)),
                                    new SqlParameter("@Bin", LPNRow["Bin"].ToString()),
                                    new SqlParameter("@LPN", LPNLabel.Text.Trim()),
                                    new SqlParameter("@Item", LPNRow["ItemNo"].ToString()),
                                    new SqlParameter("@Action", "Move"),
                                    new SqlParameter("@Qty", LPNRow["ToRcvQty"].ToString()),
                                    new SqlParameter("@AdjustDesc", "ERPReceipt"));
                                AdjustmentCount++;
                            }
                            catch (SqlException ex1)
                            {
                                LineError = true;
                                lblErrorMessage.Text = "Error pWHSLPNAccept for receiving " + ex1.Message + ", " + ex1.Number.ToString() + ", " + ex1.LineNumber.ToString();
                                MessageUpdatePanel.Update();
                            }
                        }
                        if ((int.Parse(LPNRow["AdjustQty"].ToString(), NumberStyles.Number) != 0) && (LPNRow["AdjustDesc"].ToString().Trim() != "None"))
                        {
                            // adjust the qty in RB.
                            try
                            {
                                ds = SqlHelper.ExecuteDataset(RBConnectionString, "pWHSLPNAccept",
                                    new SqlParameter("@Branch", LocLabel.Text.Substring(0, 2)),
                                    new SqlParameter("@Bin", LPNRow["Bin"].ToString()),
                                    new SqlParameter("@LPN", LPNLabel.Text.Trim()),
                                    new SqlParameter("@Item", LPNRow["ItemNo"].ToString()),
                                    new SqlParameter("@Action", "Adjust"),
                                    new SqlParameter("@Qty", LPNRow["AdjustQty"].ToString()),
                                    new SqlParameter("@AdjustDesc", LPNRow["AdjustDesc"].ToString()));
                                AdjustmentCount++;
                            }
                            catch (SqlException ex1)
                            {
                                LineError = true;
                                lblErrorMessage.Text = "Error pWHSLPNAccept for adjusment " + ex1.Message + ", " + ex1.Number.ToString() + ", " + ex1.LineNumber.ToString();
                                MessageUpdatePanel.Update();
                            }

                            // now add the InventoryAdjustment record
                            string colValues = FormatLineColumn(1, 1, LPNRow["ItemNo"].ToString()); //ItemNo
                            colValues += FormatLineColumn(2, 1, LocLabel.Text.Substring(0, 2)); //Location
                            colValues += FormatLineColumn(3, 1, LPNRow["Bin"].ToString()); //BinLocation
                            colValues += FormatLineColumn(4, 2, LPNRow["AdjustQty"].ToString()); //AdjustedQty
                            colValues += FormatLineColumn(5, 1, LPNRow["ContainerNo"].ToString()); //ContainerNo
                            colValues += FormatLineColumn(6, 1, LPNRow["BOLNo"].ToString()); //BOLNo
                            colValues += FormatLineColumn(7, 1, LPNRow["AdjustDesc"].ToString().Substring(0, Math.Min(LPNRow["AdjustDesc"].ToString().Length, 30))); //ReasonName
                            colValues += FormatLineColumn(8, 4, DateTime.Now.ToShortDateString()); //EntryDt
                            colValues += FormatLineColumn(9, 1, Session["UserName"].ToString()).Replace(",", ""); //EntryID
                            // add all the values into a new line
                            try
                            {
                                ds = SqlHelper.ExecuteDataset(ERPConnectionString, "UGEN_SP_Insert",
                                      new SqlParameter("@tableName", "InventoryAdjustment"),
                                      new SqlParameter("@columnNames", DetailColumnNames),
                                      new SqlParameter("@columnValues", colValues));
                            }
                            catch (SqlException ex1)
                            {
                                LineError = true;
                                lblSuccessMessage.Text = colValues;
                                lblErrorMessage.Text = "Error adding line to InventoryAdjustment. " + ex1.Message + ", " + ex1.Number.ToString() + ", " + ex1.LineNumber.ToString();
                                MessageUpdatePanel.Update();
                            }

                            /*
                            SELECT pInventoryAdjustmentID
                                  ,ItemNo
                                  ,TransactionType
                                  ,Location
                                  ,TransactionDocument
                                  ,DocumentLineNo
                                  ,BinLocation
                                  ,ReferenceNo
                                  ,ReferenceDt
                                  ,TransactionDt
                                  ,ReceievedQty
                                  ,ReceievedUM
                                  ,ReceivedUnitCost
                                  ,AdjustedQty
                                  ,AdjustedUM
                                  ,AdjustedUnitCost
                                  ,ASN
                                  ,POOrderNo
                                  ,ContainerNo
                                  ,BOLNo
                                  ,OldLPN
                                  ,NewLPN
                                  ,ReasonCd
                                  ,ApplicationSource
                                  ,EntryID
                                  ,EntryDt
                                  ,ChangeID
                                  ,ChangeDt
                                  ,StatusCd
                                  ,ReasonName
                                  ,ReferenceNoLineNo
                                  ,ReferenceNoType
                                  ,ReferenceNo2
                                  ,ReferenceNo2LineNo
                                  ,ReferenceNo2Type
                                  ,ReferenceNo3
                                  ,ReferenceNo3LineNo
                                  ,ReferenceNo3Type
                                  ,ParentDocumentNo
                                  ,ParentDocumentLineNo
                                  ,ParentDocumentType
                                  ,VendorCustReferenceNo
                                  ,NetUnitWght
                                  ,GrossUnitWght
                                  ,ExtReceviedUnitCost
                                  ,ExtAdjustedUnitCost
                                  ,ExtNetWght
                                  ,ExtGrossWght
                                  ,FromLocation
                                  ,FromLocationName
                                  ,fDocumentID
                                  ,TransactionUM
                                  ,ToLocation
                                  ,ToLocationName
                                  ,IntransitLocation
                                  ,IntransitLocationName
                              FROM InventoryAdjustment*/
                        }
                    }
                }
                lblSuccessMessage.Text = AdjustmentCount.ToString() + " adjustment(s) made.";
                MessageUpdatePanel.Update();
                LPNGridView.DataBind();
                DetailGridUpdatePanel.Update();
            }
            catch (Exception e3)
            {
                lblErrorMessage.Text = "pWHSLPNAccept Error " + e3.Message + ", " + e3.ToString();
                MessageUpdatePanel.Update();
            }
        }
    }

    protected string FormatLineColumn(int FieldNo, int FormatType, string FieldVal)
    {
        // FormatType 1=string, 2=int, 3=dec, 4=date
        string FieldResult = "";
        if (LineError)
        {
            return FieldResult;
        }
        switch (FormatType)
        {
            case 1:
                try
                {
                    FieldResult = String.Format(StringFieldFormat, FieldVal.Replace("'", "''").Trim());
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 2:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = "0";
                    }
                    FieldResult = String.Format(IntFieldFormat, int.Parse(FieldVal, NumberStyles.Number));
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 3:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = "0";
                    }
                    FieldResult = String.Format(NumFieldFormat, decimal.Parse(FieldVal, NumberStyles.Number));
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 4:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = DateTime.Now.ToShortDateString();
                    }
                    FieldResult = String.Format(DateFieldFormat, DateTime.Parse(FieldVal));
                }
                catch (Exception ex)
                {
                    //LineError = true;
                }
                break;
        }
        if (LineError)
        {
            lblErrorMessage.Text = "Error on field " + FieldNo.ToString() + " Val=" + FieldVal;
            MessageUpdatePanel.Update();
        }
        return FieldResult;
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            // show availability link if QOH less than requested
            row = e.Row;
            if (row.RowType == DataControlRowType.DataRow)
            {
                // line formatting
                //LPNLink = (LinkButton)row.Cells[0].Controls[1];
                //string LinkCommand = "";
                //LinkCommand = "return OpenDetail('";
                //LinkCommand += LPNLink.Text + "');";
                //LPNLink.OnClientClick = LinkCommand;
                //LineSelector = (CheckBox)row.Cells[0].Controls[1];
                //QuoteID = (HiddenField)row.Cells[0].Controls[3];
                //ReqQtyBox = (TextBox)row.Cells[5].Controls[1];
                //ReqQtyLabel = (Label)row.Cells[5].Controls[3];
                //QOHLink = (LinkButton)row.Cells[7].Controls[3];
                //QOHLabel = (Label)row.Cells[7].Controls[1];
                //LocLabel = (Label)row.Cells[8].Controls[1];
                //ItemLabel = (Label)row.Cells[3].Controls[1];
                //GridDeleteFlag = (HiddenField)row.Cells[0].Controls[5];
                //GridMakeDate = (HiddenField)row.Cells[0].Controls[7];
                //GridMakeBy = (HiddenField)row.Cells[0].Controls[9];
                //// format comment lines
                //if (row.Cells[2].Text == "COMMENT")
                //{
                //    LineSelector.Enabled = false;
                //    LineSelector.ToolTip = "This Line is a Quote Comment and Can Not Be Made into an Order";
                //    //row.Cells[3].Visible = false;
                //    row.Cells[4].ColumnSpan = 13;
                //    row.Cells[4].Text = row.Cells[17].Text;
                //    row.Cells[4].Width = new Unit(row.Cells[4].Width.Value + row.Cells[5].Width.Value +
                //        row.Cells[6].Width.Value + row.Cells[7].Width.Value +
                //        row.Cells[8].Width.Value + row.Cells[9].Width.Value + row.Cells[10].Width.Value +
                //        row.Cells[11].Width.Value + row.Cells[12].Width.Value + row.Cells[13].Width.Value +
                //        row.Cells[14].Width.Value + row.Cells[15].Width.Value + row.Cells[16].Width.Value, UnitType.Pixel);
                //    row.Cells[5].Visible = false;
                //    row.Cells[6].Visible = false;
                //    row.Cells[7].Visible = false;
                //    row.Cells[8].Visible = false;
                //    row.Cells[9].Visible = false;
                //    row.Cells[10].Visible = false;
                //    row.Cells[11].Visible = false;
                //    row.Cells[12].Visible = false;
                //    row.Cells[13].Visible = false;
                //    row.Cells[14].Visible = false;
                //    row.Cells[15].Visible = false;
                //    row.Cells[16].Visible = false;
                //    //row.Cells[4].Attributes.Add("oncontextmenu", "javascript:window.event.returnValue=false;");
                //    //row.Cells[4].Attributes.Add("onMouseDown", "delLine(this, '" + QuoteID.Value.Trim() + "');");
                //}
                //// line deleted processing
                //if (GridDeleteFlag.Value == "True")
                //{
                //    row.Cells[0].CssClass = "quoteLineDeleted";
                //    LineSelector.Enabled = false;
                //    LineSelector.ToolTip = "This Line is Deleted and Can Not Be Made into an Order";
                //    QOHLink.Visible = false;
                //    ReqQtyBox.Visible = false;
                //}
                //else
                //{
                //    ReqQtyLabel.Visible = false;
                //    // line delete set up
                //    row.Cells[3].Attributes.Add("oncontextmenu", "javascript:window.event.returnValue=false;");
                //    ItemLabel.Attributes.Add("onMouseDown", "delLine(this, '" + QuoteID.Value.Trim() + "');");
                //    //row.Cells[3].Attributes.Add("onMouseOut", "delLineHide();");
                //    //// Carrier processing
                //    //HiddenField CarCode = (HiddenField)row.Cells[12].Controls[3];
                //    //DropDownList CarDrop = (DropDownList)row.Cells[12].Controls[1];
                //    //CarDrop.SelectedValue = CarCode.Value.ToString();
                //    //// Freight processing
                //    //HiddenField FrtCode = (HiddenField)row.Cells[13].Controls[3];
                //    //DropDownList FrtDrop = (DropDownList)row.Cells[13].Controls[1];
                //    //FrtDrop.SelectedValue = FrtCode.Value.ToString();
                //    // handle QOH link to bring up branch availability if QOH is short
                //    int ReqQty = int.Parse(Server.HtmlDecode(ReqQtyBox.Text.Replace(",", "")));
                //    int QOH = int.Parse(QOHLabel.Text.Replace(",", ""));
                //    string LinkCommand = "";
                //    LinkCommand = "return ShowAvailability('";
                //    LinkCommand += Server.HtmlDecode(row.Cells[1].Text) + "', '";
                //    LinkCommand += Server.HtmlDecode(ItemLabel.Text) + "', '";
                //    LinkCommand += Server.HtmlDecode(LocLabel.Text) + "', '";
                //    LinkCommand += Server.HtmlDecode(ReqQtyBox.Text.Replace(",", "")) + "', '";
                //    LinkCommand += Server.HtmlDecode(QOHLabel.Text.Replace(",", "")) + "');";
                //    QOHLink.OnClientClick = LinkCommand;
                //    if (QOH < ReqQty)
                //    {
                //        QOHLabel.CssClass = "noDisplay";
                //        //QOHLink.OnClientClick = "alert(" + LinkCommand + ");";
                //    }
                //    else
                //    {
                //        QOHLink.CssClass = "noDisplay";
                //    }
                //    // Make order processing
                //    if (GridMakeBy.Value.Trim().Length > 0)
                //    {
                //        row.Cells[0].CssClass = "quoteLineOrderMade";
                //        LineSelector.ToolTip = "An order was Made from this Line by " + GridMakeBy.Value.Trim() + " on " + GridMakeDate.Value;
                //    }
                //}
            }
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "FillGrid Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView 
            string LineFilter;
            DataView dv = new DataView((DataTable)Session[SessionTableName]);
            dv.Sort = e.SortExpression;
            LPNGridView.DataSource = dv;
            LPNGridView.DataBind();
            DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
            DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "Sort Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void DetailGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        //DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
        LPNGridView.DataSource = (DataTable)Session[SessionTableName];
        LPNGridView.PageIndex = e.NewPageIndex;
        LPNGridView.DataBind();
        DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
        DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SetLineCheckBoxData(string Item, string NewState )
    {
        string status = Item;
        // update the table in the session variable to show that the line is selected or not.
        DataTable tempDt = (DataTable)Session[SessionTableName];
        DataRow[] LPNRow =
           tempDt.Select("ItemNo = '" + Item + "'");
        status += " was " + LPNRow[0]["Adjust"].ToString();
        if (NewState.ToUpper() == "TRUE")
        {
            LPNRow[0]["Adjust"] = true;
            status += " made true";
        }
        else
        {
            LPNRow[0]["Adjust"] = false;
            status += " made false";
        }
        Session[SessionTableName] = tempDt;
        return status;
    }
    
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SetAllCheckBoxData(string NewState)
    {
        string status = NewState;
        // update the table in the session variable to show that all the lines are selected or not.
        DataTable tempDt = (DataTable)Session[SessionTableName];
        foreach (DataRow LPNRow in tempDt.Rows)
        {
            if (NewState.ToUpper() == "TRUE")
            {
                LPNRow["Adjust"] = true;
                LPNRow["ToRcvQty"] = int.Parse(LPNRow["OrigQty"].ToString(), NumberStyles.Number)
                - (int.Parse(LPNRow["RcvdQty"].ToString(), NumberStyles.Number) + int.Parse(LPNRow["AdjustQty"].ToString(), NumberStyles.Number));
            }
            else
            {
                LPNRow["Adjust"] = false;
            }
        }
        Session[SessionTableName] = tempDt;
        return status;
    }
    
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdAdjust(string Item, string NewAdjustName, string NewAdjustCode)
    {
        string status = Item;
        // update the table in the session variable to show that the line is selected or not.
        DataTable tempDt = (DataTable)Session[SessionTableName];
        DataRow[] LPNRow =
           tempDt.Select("ItemNo = '" + Item + "'");
        status += " was " + LPNRow[0]["AdjustDesc"].ToString();
        LPNRow[0]["AdjustDesc"] = NewAdjustName;
        status += ". Adjust Reason set to " + NewAdjustName;
        Session[SessionTableName] = tempDt;
        return status;

    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdRcvQty(string Item, string NewRcvQty)
    {
        string status = Item;
        // update the table in the session variable to show that the line is selected or not.
        DataTable tempDt = (DataTable)Session[SessionTableName];
        DataRow[] LPNRow =
           tempDt.Select("ItemNo = '" + Item + "'");
        status += " was " + LPNRow[0]["ToRcvQty"].ToString();
        LPNRow[0]["ToRcvQty"] = NewRcvQty;
        status += ". Receive Qty set to " + NewRcvQty;
        Session[SessionTableName] = tempDt;
        return status;

    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdAdjQty(string Item, string NewAdjQty)
    {
        string status = Item;
        // update the table in the session variable to show that the line is selected or not.
        DataTable tempDt = (DataTable)Session[SessionTableName];
        DataRow[] LPNRow =
           tempDt.Select("ItemNo = '" + Item + "'");
        status += " was " + LPNRow[0]["AdjustQty"].ToString();
        LPNRow[0]["AdjustQty"] = NewAdjQty;
        status += ". Adjust Qty set to " + NewAdjQty;
        Session[SessionTableName] = tempDt;
        return status;

    }

}
