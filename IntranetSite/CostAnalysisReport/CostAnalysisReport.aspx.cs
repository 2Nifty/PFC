using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.IO;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Data.Sql;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using System.Text.RegularExpressions;

public partial class CostingAnalysisReport : System.Web.UI.Page
{
    # region Variable Declaration

    CostMetrics costMetrics = new CostMetrics();
    DataTable dtExcelData = new DataTable();
    DataTable dtCostData = new DataTable();
    GridView dv = new GridView();

    string sort = "";

    private DataTable dtGrandTotal;

    bool status = false;

    int pageCount = 17;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    string StartDate = "";
    string EndDate = "";
    string sortExpression = string.Empty;
    string showRestrictedVersion = "";
    string excelFilePath = "../Common/ExcelUploads/";

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CostingAnalysisReport));
        StartDate = Request.QueryString["StartDate"].ToString();
        EndDate = Request.QueryString["EndDate"].ToString();
        showRestrictedVersion = Request.QueryString["ReportVersion"].ToString().ToLower();

        if (!IsPostBack)
        {
            hidFileName.Value = "CostingAnalysisReport" + Session["SessionID"].ToString() + ".xls"; //Excel File
            Session["CostAnalysisData"] = null;

            lblStartDt.Text = StartDate;
            lblEndDt.Text = EndDate;           
            BindDataGrid();
        }
    }


    /// <summary>
    /// BindDataGrid :used to bind grid
    /// </summary
    private void BindDataGrid()
    {
        if (Session["CostAnalysisData"] == null || hidSort.Value != "") //Session variable
        {
            string _restrictInd = (showRestrictedVersion == "restricted" ? "1" : "0");  //If Indicator is 1 then name say its restricted and save it here _restrictInd
            dtCostData = costMetrics.GetCostMetricsData(StartDate, EndDate, _restrictInd);  //Get StartDate EndDate and _restrictInd from SP
            Session["CostAnalysisData"] = dtCostData;
        }

        if (hidSort.Value != "")    //Sathis Added to get the sort value when a header is clicked. 
        {
            dtCostData.DefaultView.Sort = hidSort.Value;            
        }

        gvCostMetrics.DataSource = dtCostData.DefaultView.ToTable();
        dtGrandTotal = dtCostData.DefaultView.ToTable();
        GetTotal();

        dtCostData = Session["CostAnalysisData"] as DataTable;
             
        if (dtCostData != null && dtCostData.Rows.Count > 0)
        {
            gvCostMetrics.DataSource = dtCostData.DefaultView.ToTable();
            pager.InitPager(gvCostMetrics, pageCount);
        }
        else
        {
            gvCostMetrics.Visible = false;
            lblStatus.Visible = true;
            pager.Visible = false;
        }

        if (showRestrictedVersion == "restricted")    
            lblRestrictedVer.Text = " Yes";
        else
            lblRestrictedVer.Text = " No";

        upnlGrid.Update();
        pnlResVer.Update();        
    }

    /// <summary>
    /// GetTotal :method used to get grand total
    /// </summary>
    public void GetTotal()
    {
        dtGrandTotal.Clear();

        if (status == false && dtCostData != null && dtCostData.Rows.Count > 0)
        {
            DataRow drow = dtGrandTotal.NewRow();
            drow["Branch"] = "Branch Total";
            drow["ExtSell"] = dtCostData.Compute("sum(ExtSell)", "");
            drow["RplCost"] = dtCostData.Compute("sum(RplCost)", "");
            drow["SmthAvg"] = dtCostData.Compute("sum(SmthAvg)", "");
            drow["AvgCost"] = dtCostData.Compute("sum(AvgCost)", "");

            //drow["GMRplPct"] = dtCostData.Compute("avg(GMRplPct)", "");
            //drow["GMSmthAvgPct"] = dtCostData.Compute("avg(GMSmthAvgPct)", "");
            //drow["GMAvgPct"] = dtCostData.Compute("avg(GMAvgPct)", "");

            drow["GMRplPct"] = dtCostData.Compute("100*((sum(ExtSell) - sum(RplCost))/sum(ExtSell))", "");  //did not work
            drow["GMSmthAvgPct"] = dtCostData.Compute("100*((sum(ExtSell) - sum(SmthAvg))/sum(ExtSell))", "");
            drow["GMAvgPct"] = dtCostData.Compute("100*((sum(ExtSell) - sum(AvgCost))/sum(ExtSell))", "");

            dtGrandTotal.Rows.Add(drow);
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvCostMetrics.PageIndex = pager.GotoPageNumber;

        BindDataGrid();     
    }

    protected void gvCostMetrics_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[1].ColumnSpan = 4;                                   //width here moves page headers
            e.Row.Cells[1].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'>" +
                                        "     <tr>" +
                                        "         <td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6; border-right:solid 0px #c9c6c6;' colspan=4 nowrap >" +
                                        "         <center>" +
                                        "             Extended $" +
                                        "         </center>" +
                                        "         </td>" +
                                        "     </tr>" +
                                        "     <tr>" +
                                        "         <td width='85' class='GridHead splitBorders' nowrap  align='center' nowrap style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "             <center>" +
                                        "                 <Div style='cursor:hand;' onclick=\"javascript:BindValue('ExtSell');\">Sales</div>" +
                                        "             </center>" +
                                        "         </td>" +
                                        "         <td width='85' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "             <center>" +
                                        "                 <Div style='cursor:hand;' onclick=\"javascript:BindValue('RplCost');\">Replacement</div>" +
                                        "             </center>" +
                                        "         </td>" +
                                        "         <td width='85' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "             <center>" +
                                        "                 <Div style='cursor:hand;' onclick=\"javascript:BindValue('SmthAvg');\">Smooth Avg</div>" +
                                        "             </center>" +
                                        "         </td>" +
                                        "         <td width='80' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "                 <Div style='cursor:hand;' onclick=\"javascript:BindValue('AvgCost');\">Average</div>" +
                                        "         </td>" +
                                        "     </tr>" +
                                        " </table>";

            e.Row.Cells[2].Visible = false;
            e.Row.Cells[3].Visible = false;
            e.Row.Cells[4].Visible = false;
            
            e.Row.Cells[6].ColumnSpan = 3;
            e.Row.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'>" +
                                  "          <tr>" +
                                  "              <td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap >" +
                                  "                  <center>" +
                                  "                     Gross Margin %" +
                                  "                  </center>" +
                                  "              </td>" +
                                  "          </tr>" +
                                  "          <tr>" +
                                  "              <td width='85' class='GridHead splitBorders' nowrap  align='center' style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                  "                  <center>" +
                                  "                      <Div style='cursor:hand;' onclick=\"javascript:BindValue('GMRplPct');\">Replacement</div>" +
                                  "                  </center>" +
                                  "              </td>" +
                                  "              <td width='85' class='GridHead splitBorders' nowrap align='center' style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                  "                  <center>" +
                                  "                      <Div style='cursor:hand;' onclick=\"javascript:BindValue('GMSmthAvgPct');\">Smooth Avg</div>" +
                                  "                  </center>" +
                                  "              </td>" +
                                  "              <td width='85' class='GridHead splitBorders' nowrap align='center' style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                  "                    <center>" +
                                  "                      <Div style='cursor:hand;' onclick=\"javascript:BindValue('GMAvgPct');\">Average</div>" +
                                  "                    </center>" +
                                  "              </td>" +
                                  "          </tr>" +
                                  "      </table>";
                       
            e.Row.Cells[7].Visible = false;
            e.Row.Cells[8].Visible = false;

        }
       
        if (e.Row.RowType == DataControlRowType.Footer)
        {          
            if (dtGrandTotal.Rows.Count > 0)
            {                                                                                       // did not work
                decimal GMRplPct = (Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) == 0) ? 0 : 100* ((Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) - Convert.ToDecimal(dtGrandTotal.Rows[0]["RplCost"])) / Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]));
                decimal GMSmthAvgPct = (Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) == 0) ? 0 : 100 * ((Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) - Convert.ToDecimal(dtGrandTotal.Rows[0]["SmthAvg"])) / Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]));
                decimal GMAvgPct = (Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) == 0) ? 0 : 100 *( (Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) - Convert.ToDecimal(dtGrandTotal.Rows[0]["AvgCost"])) / Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]));

                e.Row.Cells[0].Text = "Grand Total";

                e.Row.Cells[1].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"].ToString()));
                e.Row.Cells[2].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["RplCost"].ToString()));
                e.Row.Cells[3].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["SmthAvg"].ToString()));
                e.Row.Cells[4].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["AvgCost"].ToString()));

                e.Row.Cells[6].Text = string.Format("{0:#,##0.0}", GMRplPct);
                e.Row.Cells[7].Text = string.Format("{0:#,##0.0}", GMSmthAvgPct);
                e.Row.Cells[8].Text = string.Format("{0:#,##0.0}", GMAvgPct);    
            }
        }
        if (e.Row.Cells[1].Text == "" || e.Row.Cells[1].Text == "&nbsp;")
            e.Row.Visible = false;
    }

    protected void btnSort_Click(object sender, EventArgs e)
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

        hidSort.Value = hidSortExpression.Value + " " + hidSort.Attributes["sortType"].ToString();
        sort = "sort";
        BindDataGrid();
    }

    protected void gvCostMetrics_Sorting(object sender, GridViewSortEventArgs e)
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

    
    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
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
        string _restrictInd = (showRestrictedVersion == "restricted" ? "1" : "0");
        dtCostData = costMetrics.GetCostMetricsData(StartDate, EndDate, _restrictInd); 
        Session["CostAnalysisData"] = dtCostData;
              
        dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
              
        gvCostMetrics.DataSource = dtCostData.DefaultView.ToTable();
        dtGrandTotal = dtCostData.DefaultView.ToTable();
        GetTotal();

        dtCostData = Session["CostAnalysisData"] as DataTable;

        // Step 1: Create Report Header
        headerContent = "<table border='1' width='100%'>";
        headerContent += "<tr><th colspan='8' style='color:blue' align=left>Cost Analysis by Branch Report</th></tr>";
        headerContent += "<tr><td colspan='1'><b>Restricted: " + lblRestrictedVer.Text + "</></td> <td colspan='2'><b>Start Date: " + StartDate + "</b></td> <td colspan='2'><b>End Date: " + EndDate + "</b></td> <td colspan='3'><b>Run By: " + Session["UserName"].ToString() + "  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th width='90'> Branch </th><th colspan=4 >" +        //******width moves the headers

        "<table border='1' style='font-weight:bold' width='100%'>"+
        "<tr>"+
        "   <td colspan=4 nowrap >"+
        "       <center>"+
        "           Extended $"+
        "       </center>"+
        "   </td>"+
        "</tr>"+
        "<tr>"+
        "   <td width='60' nowrap align=>" +
        "      <center>" +
        "           Sales"+
        "      </center>"+
        "    </td>"+
        "    <td width='40' nowrap  align="+
        "      <center>" +
        "           Replacement"+
        "      </center>"+
        "    </td>"+
        "    <td width='75' nowrap align="+
        "      <center>" +
        "           Smooth Avg"+
        "      </center>"+
        "    </td>"+
        "    <td width='40' nowrap align="+
        "      <center>" +
        "           Average"+
        "      </center>"+
        "    </td>"+
        "</tr>"+
        " </table>"+
        "</th>"+       

        "<th colspan=3>" +
        "<table border='1' style='font-weight:bold'  width='100%'>"+
        "<tr>"+
        "   <td colspan=3 nowrap align=>" +
        "            <center>"+
        "                Gross Margin %"+
        "            </center>"+
        "        </td>"+
        "</tr>"+
        "<tr>"+
        "   <td width='40' nowrap align=>" +        //width moves the headers
        "           <center>"+
        "                Replacement"+
        "           </center>" +
        "   </td>"+
        "   <td width='75'  nowrap align="+
        "           <center>" +
        "               Smooth Avg"+
        "           </center>" +
        "   </td>"+
        "   <td width='40'  nowrap align="+
        "           <'center'>"+
        "                 Average"+
        "           </center>" +
        "   </td>"+
        "</tr>"+
        "</table>"+
        "</th>"+
        "</tr>";
                
        if (dtCostData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = false;    //if set to false it hides Header in excel dump   
            dv.ShowFooter = true;          
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);    //Binds data to excel output file

            for (int i = 0; i <= dtCostData.Columns.Count - 1; i++)     // does Excel print data format  
            {
                BoundField bfExcel = new BoundField();
                bfExcel.HeaderText = dtCostData.Columns[i].ColumnName;
                bfExcel.DataField = dtCostData.Columns[i].ColumnName;
                if (i == 0)
                {
                    if (i == 0)
                        bfExcel.HeaderText = "Branch";
                    else if (i == 1)
                        bfExcel.HeaderText = "Branch";

                    bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                    bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                }
                else
                {
                    //bfExcel.DataFormatString = "{0:#,##0.00}";
                    bfExcel.ItemStyle.Width = 78;
                    bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                    bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                }
                bfExcel.FooterStyle.Font.Bold = true;               //*******Bolds the grand total footer
                dv.Columns.Add(bfExcel);
            }

            //for (int i = 0; i <= dtCostData.Columns.Count - 1; i++)     // does Excel print data format  
            //{
            //    BoundField bfExcel = new BoundField();
            //    bfExcel.HeaderText = dtCostData.Columns[i].ColumnName;
            //    bfExcel.DataField = dtCostData.Columns[i].ColumnName;
            //    if (i == 0)
            //    {
            //        if (i == 0)
            //            bfExcel.HeaderText = "Branch";
            //        else if (i == 1)
            //            bfExcel.HeaderText = "Branch";
                   

            //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            //        bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            //    }
            //    if (i == 5)
            //    {
            //        if (i == 5)
            //            bfExcel.HeaderText = "GMRplPct";
            //        else if (i == 5)
            //            bfExcel.HeaderText = "GMRplPct";

            //        bfExcel.DataFormatString = "{0:#,##0.0}";
            //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            //        bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            //    }

            //     if (i == 6)
            //    {
            //        if (i == 6)
            //            bfExcel.HeaderText = "GMSmthAvgPct";
            //        else if (i == 6)
            //            bfExcel.HeaderText = "GMSmthAvgPct";

            //        bfExcel.DataFormatString = "{0:#,##0.0}";
            //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            //        bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            //    }

            //    if (i == 7)
            //    {
            //        if (i == 7)
            //            bfExcel.HeaderText = "GMAvgPct";
            //        else if (i == 7)
            //            bfExcel.HeaderText = "GMAvgPct";

            //        bfExcel.DataFormatString = "{0:#,##0.0}";
            //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            //        bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            //    }
            //    else
            //    {
            //         bfExcel.DataFormatString = "{0:#,##0.00}";
            //        bfExcel.ItemStyle.Width = 108;
            //        bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            //        bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            //    }
            //    bfExcel.FooterStyle.Font.Bold = true;               //*******Bolds the grand total footer
            //    dv.Columns.Add(bfExcel);
            //}

            dv.DataSource = dtCostData;
            dv.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            dv.RenderControl(htw);
            excelContent = sb.ToString();
        }
        else
        {
            excelContent = "<tr  ><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
        }

        return styleSheet + headerContent + excelContent;
    }

    //Binds Grand Total in Excel output file
    protected void dv_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            decimal GMRplPct = (Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) == 0) ? 0 : 100*((Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) - Convert.ToDecimal(dtGrandTotal.Rows[0]["RplCost"])) / Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]));
            decimal GMSmthAvgPct = (Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) == 0) ? 0 : 100*((Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) - Convert.ToDecimal(dtGrandTotal.Rows[0]["SmthAvg"])) / Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]));
            decimal GMAvgPct = (Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) == 0) ? 0 : 100*((Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]) - Convert.ToDecimal(dtGrandTotal.Rows[0]["AvgCost"])) / Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"]));
                        
            e.Row.Cells[0].Text = "Grand Total";

            e.Row.Cells[1].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ExtSell"].ToString()));
            e.Row.Cells[2].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["RplCost"].ToString()));
            e.Row.Cells[3].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["SmthAvg"].ToString()));
            e.Row.Cells[4].Text = string.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["AvgCost"].ToString()));

            e.Row.Cells[5].Text = string.Format("{0:#,##0.0}", GMRplPct);
            e.Row.Cells[6].Text = string.Format("{0:#,##0.0}", GMSmthAvgPct);
            e.Row.Cells[7].Text = string.Format("{0:#,##0.0}", GMAvgPct);    
        }
    }

    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string excelContent = GenerateExportData("Print");

        string pattern = @"\s*\r?\n\s*";
        excelContent = Regex.Replace(excelContent, pattern, "");
        excelContent = Regex.Replace(excelContent, "<tr><th", "<THEAD style='display:table-header-group;'><TR><th").Replace("</th></tr>", "</th></TR></THEAD>");
        excelContent = excelContent.Replace("BORDER-COLLAPSE: collapse;", "border-collapse:separate;").Replace("BORDER-LEFT: #c9c6c6 1px solid;", "BORDER-LEFT: #c9c6c6 0px solid;").Replace("BORDER-RIGHT: #c9c6c6 1px solid;", "BORDER-RIGHT: #c9c6c6 0px solid;");
        excelContent = excelContent.Replace("BORDER-TOP: #c9c6c6 1px solid;", "BORDER-TOP: #c9c6c6 0px solid;").Replace("BORDER-BOTTOM: #c9c6c6 1px solid;", "BORDER-BOTTOM: #c9c6c6 0px solid;");

        Session["PrintContent"] = excelContent;
        ScriptManager.RegisterClientScriptBlock(ibtnPrint, ibtnPrint.GetType(), "Print", "PrintReport();", true);
    }
              

    #region DeleteExcel

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath(excelFilePath));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }
         
    #endregion

}

