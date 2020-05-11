#region Namespaces
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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;
#endregion

public partial class ReadyToShip_RTSShipSummary : System.Web.UI.Page
{
    #region Variable declaration
    ReadyToShipUtility detRTS = new ReadyToShipUtility();
    DataSet dsDetail = new DataSet();
    DataTable dtLocation = new DataTable();
    DataTable dt;
    string holdLocation = "90";
    // added by slater
    SortedList DateBag = new SortedList();
    #endregion

    #region Page load Event handler
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(ReadyToShip_RTSShipSummary));
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        lblFlag.Text = "";
        upLabel.Update();
        if (!IsPostBack)
        {
            FillVendor();
            //BindGrid();
            lblFlag.Text = "";
        }
    }
    #endregion

    #region Developer methods
    /// <summary>
    /// 
    /// </summary>
    public void FillVendor()
    {
        try
        {            
            string tableName = "gerrtsdtl";
            string columnValue = "distinct vendno + ' - ' + portoflading as VendNo";
            string whereclause = "1=1";

            DataSet dsVendor = detRTS.GetDetails(tableName, columnValue, whereclause);


            if (dsVendor.Tables[0] != null && dsVendor.Tables[0].Rows.Count > 0)
            {
                ddlVendor.DataSource = dsVendor.Tables[0];                
                ddlVendor.DataTextField = "VendNo";
                ddlVendor.DataValueField = "VendNo";
                ddlVendor.DataBind();

                BindGrid();
            }
        }
        catch (Exception ex) { }
    }
    /// <summary>
    /// 
    /// </summary>
    public void BindGrid()
    {
        try
        {
            lblVendor.Text = detRTS.GetVendorDescription(ddlVendor.SelectedValue.Split('-')[0].ToString().Trim());
            lblPounds.Text = detRTS.PoundNotProcessed(ddlVendor.SelectedValue.Split('-')[0].ToString().Trim(), ddlVendor.SelectedValue.Split('-')[1].ToString().Trim());
            // Get the detail of  all the data
            dsDetail = detRTS.GetDetails("GERRTSDtl", "sum(grosswght*qty) as 'Lbs',GERRTSStatCd as 'Code',LocCd as 'Location',PortOfLading", "VendNo='" + ddlVendor.SelectedValue.Split('-')[0].ToString().Trim() + "' and portoflading='" + ddlVendor.SelectedValue.Split('-')[1].ToString().Trim() + "' group by GERRTSStatCd,LocCd,PortOfLading");

            // Get distinct Location from the table
            dtLocation = detRTS.GetDetails("GERRTSDtl a,LocMaster b", "Distinct  b.shortcode as 'Location',a.loccd as LocCode", "a.loccd=b.LocID and a.VendNo='" + ddlVendor.SelectedValue.Split('-')[0].ToString().Trim() + "' and a.portoflading='" + ddlVendor.SelectedValue.Split('-')[1].ToString().Trim() + "'").Tables[0];

            // Get the distinct code
            DataTable dtCode = detRTS.GetDetails("GERRTSDtl", "Distinct GERRTSStatCd as 'Code'", "VendNo='" + ddlVendor.SelectedValue.Split('-')[0].ToString().Trim() + "' and portoflading='" + ddlVendor.SelectedValue.Split('-')[1].ToString().Trim() + "'").Tables[0];

            dt = new DataTable();

            // Add columns to the datatable to add port of lading as column
            dt.Columns.Add("Actions By Priority Code", typeof(string));
            dt.Columns.Add("Total", typeof(long));
            foreach (DataRow dr in dtLocation.Rows)
                dt.Columns.Add(dr["Location"].ToString().Trim(), typeof(long));

            dt.Columns.Add("HOLD", typeof(long));

            // Code to bind the total weight 
            DataTable dtData = dsDetail.Tables[0].Copy();
            foreach (DataRow drow in dtCode.Rows)
            {
                DataRow drNew = dt.NewRow();
                drNew["Actions By Priority Code"] = drow["Code"].ToString().Trim();
                object corpValue = detRTS.GetScalar("GERRTSDtl", "sum(grosswght*qty) as 'Lbs' ", "VendNo='" + ddlVendor.SelectedValue.Split('-')[0].ToString().Trim() + "' and portoflading='" + ddlVendor.SelectedValue.Split('-')[1].ToString().Trim() + "' and GERRTSStatCd ='" + drow["Code"].ToString().Trim() + "' group by GERRTSStatCd");

                drNew["Total"] = Convert.ToInt64(corpValue == null ? "0" : corpValue);
                for (int i = 1; i < dt.Columns.Count-1; i++)
                {
                    DataRow[] drSlt = dtLocation.Select("Location='" + dt.Columns[i].ColumnName.ToString().Trim() + "'");

                    if (drSlt.Length > 0)
                    {
                        string shrtCode = drSlt[0][1].ToString();
                        dtData.DefaultView.RowFilter = "Code='" + drow["Code"].ToString().Trim() + "' and Location='" + shrtCode + "'";
                        DataTable dtLocSum = dtData.DefaultView.ToTable();

                        if (dtLocSum != null && dtLocSum.Rows.Count > 0)
                            drNew[i] = dtLocSum.Compute("sum(Lbs)", "");
                        else
                            drNew[i] =  0;
                    }
                }
                dtData.DefaultView.RowFilter = "Code='" + drow["Code"].ToString().Trim() + "' and Location='" + holdLocation + "'";
                DataTable dtHoldLocSum = dtData.DefaultView.ToTable();
                if (dtHoldLocSum != null && dtHoldLocSum.Rows.Count > 0)
                    drNew[dt.Columns.Count - 1] = dtHoldLocSum.Compute("sum(Lbs)", "");
                else
                    drNew[dt.Columns.Count - 1] = 0;
                
                // Add datarow to the datatable
                dt.Rows.Add(drNew);
            }

            if (dt.Rows.Count > 0)
            {
                dgShipSummary.DataSource = dt;
                dgShipSummary.DataBind();
                dgShipSummary.Visible = true;
                lblStatus.Text = "";
                // added by Slater for automated PO updates
                AddReceiptDates(dt, dtLocation);
            }
            else
            {
                dgShipSummary.Visible = false;
                lblStatus.Text = "No Record Found";
            }


        }
        catch (Exception ex) {
            lblStatus.Text = ex.ToString();
        }
    }

    public void AddReceiptDates(DataTable RTSData, DataTable RTSLocs)
    {
        // set the row cell visibility
        for (int i = 2; i < ReceiptDatesTable.Rows[0].Cells.Count - 1; i++)
        {
            TableCell ReceiptDateCell = ReceiptDatesTable.Rows[0].Cells[i];
            TextBox RecDateTextBox = (TextBox)ReceiptDateCell.Controls[0];
            HiddenField CellLoc = (HiddenField)ReceiptDateCell.Controls[1];
            // set the cell visible
            if (i < RTSData.Columns.Count - 1)
            {
                ReceiptDateCell.Visible = true;
                CellLoc.Value = RTSLocs.Rows[i - 2]["LocCode"].ToString();
                if (Session["DateBag"] != null)
                {
                    DateBag = (SortedList)Session["DateBag"];
                    if (DateBag.ContainsKey(CellLoc.Value.ToString()))
                    {
                        RecDateTextBox.Text = (string)DateBag.GetByIndex(DateBag.IndexOfKey(CellLoc.Value.ToString()));
                    }
                    else
                    {
                        RecDateTextBox.Text = "";
                    }
                }
            }
            else
            {
                ReceiptDateCell.Visible = false;
                CellLoc.Value = null;
                RecDateTextBox.Text = "";
            }
        }
    }
    #endregion

    #region Event Handlers
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlVendor_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            BindGrid();
        }
        catch (Exception ex) { }
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void dgShipSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        // e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Left;
        e.Item.Cells[0].Width = Unit.Pixel(100);
        e.Item.Cells[0].CssClass += " Left5pxPadd";
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            e.Item.Cells[0].Font.Bold = true;
            e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Left;
              for (int i = 1; i < e.Item.Cells.Count; i++)
              {
                  e.Item.Cells[i].Text = string.Format("{0:#,##0}", Convert.ToDecimal(e.Item.Cells[i].Text));
                  e.Item.Cells[i].Width = Unit.Pixel(60);
              }
        }

        //if (e.Item.ItemType == ListItemType.Footer)
        //{
        //    e.Item.Cells[0].Text = "Total";

        //    for (int i = 1; i < dt.Columns.Count; i++)
        //    {
        //        e.Item.Cells[i].Text = dt.Compute("Sum(" + dt.Columns[i].ColumnName.Trim() + ")", "").ToString();
        //        e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
        //        for (int count = 1; count < e.Item.Cells.Count; count++)
        //        {
        //            string value=(e.Item.Cells[count].Text =="" || e.Item.Cells[count].Text =="&nbsp;")? "0" : e.Item.Cells[count].Text;
        //            e.Item.Cells[count].Text = string.Format("{0:#,##0}", Convert.ToDecimal(value));
        //        }
        //    }
        //}

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Total";

            for (int i = 1; i < dt.Columns.Count; i++)
            {

                e.Item.Cells[i].Text = "<div style='color:#cc0000;cursor:hand;' onmouseup='SetVisible();' oncontextmenu=\"Javascript:return false;\" id=div" + i.ToString() + "Pounds onmousedown=\"ShowToolTip(event,'" + dt.Columns[i].ColumnName.Trim() + "',this.id);\">" + string.Format("{0:#,##0}", Convert.ToDecimal(dt.Compute("Sum(" + dt.Columns[i].ColumnName.Trim() + ")", "").ToString())) + "</div>";
                e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
            }
        }
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAccept_Click(object sender, ImageClickEventArgs e)
    {
        if (dgShipSummary.Visible)
        {
            // Added by slater for auto PO updates.
            // for each receipt date, make the update data.
            bool DatesOK = true;
            lblFlag.Text = "";
            TableRow tr = (TableRow)ReceiptDatesTable.Rows[0];
            DataSet ds = new DataSet();
            foreach (TableCell tc in tr.Cells)
            {
                if (tc.Controls.Count > 0)
                {
                    HiddenField CellLoc = (HiddenField)tc.Controls[1];
                    if (CellLoc.Value.ToString().Trim().Length > 0)
                    {
                        // we got something
                        TextBox RecDateTextBox = (TextBox)tc.Controls[0];
                        DateTime RecDate = new DateTime();
                        if (!DateTime.TryParse(RecDateTextBox.Text, out RecDate))
                        {
                            DatesOK = false;
                            lblFlag.Text += " " + CellLoc.Value.ToString();
                        }
                    }
                }
            }
            // if the dates are ok, do the updates
            if (DatesOK)
            {
                if (Session["DateBag"] != null)
                {
                    DateBag = (SortedList)Session["DateBag"];
                }
                foreach (TableCell tc in tr.Cells)
                {
                    if (tc.Controls.Count > 0)
                    {
                        HiddenField CellLoc = (HiddenField)tc.Controls[1];
                        if (CellLoc.Value.ToString().Trim().Length > 0)
                        {
                            // we got something
                            TextBox RecDateTextBox = (TextBox)tc.Controls[0];
                            DateTime RecDate = new DateTime();
                            if (DateTime.TryParse(RecDateTextBox.Text, out RecDate))
                            {
                                ds = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pGERRTSCreatePOUpdates",
                                    new SqlParameter("@Vendor", ddlVendor.SelectedValue.Split('-')[0].ToString().Trim()),
                                    new SqlParameter("@Portoflading", ddlVendor.SelectedValue.Split('-')[1].ToString().Trim()),
                                    new SqlParameter("@PFCLoc", CellLoc.Value.ToString()),
                                    new SqlParameter("@ReceiptDate", RecDate.ToString()),
                                    new SqlParameter("@EntryID", Session["UserName"].ToString()));
                                // add the date to the bag
                                if (DateBag.ContainsKey(CellLoc.Value.ToString()))
                                {
                                    DateBag.Remove(CellLoc.Value.ToString());
                                }
                                DateBag.Add(CellLoc.Value.ToString(), RecDate.ToString("MM/dd/yy"));
                            }
                        }
                    }
                    Session["DateBag"] = DateBag;
                }
                detRTS.UpdateSummaryDetail(ddlVendor.SelectedValue.Split('-')[0].ToString().Trim(), ddlVendor.SelectedValue.Split('-')[1].ToString().Trim());
                lblFlag.Text = "Data has processed successfully";
                upLabel.Update();
            }
            else
            {
                lblFlag.Text = "Invalid Date in Column for Locations " + lblFlag.Text;

            }
        }
    }

    protected void lnkHold_Click(object sender, EventArgs e)
    {
        try
        {
            string tableName = "GERRTSDtl";
            string columnValue = "Hold='Y'";
            string whereCaluse = "VendNo='" + ddlVendor.SelectedValue.Split('-')[0].ToString().Trim() + "' AND PortofLading='" + ddlVendor.SelectedValue.Split('-')[1].ToString().Trim() + "'";
            if (hidHold.Value.Trim() == "HOLD")
                whereCaluse = whereCaluse + " And PoNo in (Select PONo From GERRTS Where QtyRemaining>0) AND LocCd="+holdLocation;
            else if(hidHold.Value.Trim()!="Total")
                whereCaluse = whereCaluse + " And PoNo in (Select PONo From GERRTS Where QtyRemaining>0 AND LocCd=(Select Top 1 Locid From LocMaster where ShortCode='" + hidHold.Value + "') )";
            else 
                whereCaluse = whereCaluse + " And PoNo in (Select PONo From GERRTS Where QtyRemaining>0)";
                        
            detRTS.UpdateQuantity(tableName, columnValue, whereCaluse);
            lblFlag.Text = "Purchase order(s) has been successfully holded";
            upLabel.Update();
        }
        catch (Exception ex) { }
    }
    #endregion

}
