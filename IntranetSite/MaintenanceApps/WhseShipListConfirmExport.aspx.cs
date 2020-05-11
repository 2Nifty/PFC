#region Namespace
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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using System.Text.RegularExpressions;
#endregion

namespace PFC.Intranet.ListMaintenance
{
    public partial class _WhseShipListConfirm : System.Web.UI.Page
    {
        #region  Valiable Declaration
        
        int pageSize = 19;
        string pListId = "";
        string listTypeValue = "";
        
        #endregion

        #region Constant Variables

        string updateMessage = "Data has been successfully updated.";
        string addMessage = "Data has been successfully added.";
        string deleteMessage = "Data has been successfully deleted.";
        string listMessage = "List Name already exist.";
        string itemMessage = "Item Name already exist.";        

        #endregion

        #region Page Load Event

        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(_WhseShipListConfirm));
            pListId = Request.QueryString["ListId"].ToString();
            listTypeValue = Request.QueryString["ListTypeValue"].ToString();
            
            if (!Page.IsPostBack)
            {

                BindDataGrid();
                
            }

        }

        #endregion

        #region Developer Methods

        private void BindDataGrid()
        {
            DataSet _dsShipListDetail = GetShipListData("GetGridLines", "", "", "", "", "", "", "", "", "", pListId, "", "", "", "", "", "");

            if (_dsShipListDetail != null)
            {
                if (Request.QueryString["Sort"].ToString() != "")
                    _dsShipListDetail.Tables[0].DefaultView.Sort = Request.QueryString["Sort"].ToString();
                
                Session["ListDetail"] = _dsShipListDetail.Tables[0].DefaultView.ToTable();
                
                string excelContent = GenerateExportData("Print");
                string pattern = @"\s*\r?\n\s*";
                excelContent = Regex.Replace(excelContent, pattern, "");
                excelContent = Regex.Replace(excelContent, "<tr><th", "<THEAD style='display:table-header-group;'><TR><th").Replace("</th></tr>", "</th></TR></THEAD>");
                excelContent = excelContent.Replace("BORDER-COLLAPSE: collapse;", "border-collapse:separate;").Replace("BORDER-LEFT: #c9c6c6 1px solid;", "BORDER-LEFT: #c9c6c6 0px solid;").Replace("BORDER-RIGHT: #c9c6c6 1px solid;", "BORDER-RIGHT: #c9c6c6 0px solid;");
                excelContent = excelContent.Replace("BORDER-TOP: #c9c6c6 1px solid;", "BORDER-TOP: #c9c6c6 0px solid;").Replace("BORDER-BOTTOM: #c9c6c6 1px solid;", "BORDER-BOTTOM: #c9c6c6 0px solid;");

                Response.Write(excelContent);
            }
 
        }

        #endregion

        #region DB Helper Methods

        private DataSet GetShipListData(string mode
                                        ,string palletNo
                                        ,string docNo
                                        ,string shipWght
                                        ,string custNo
                                        ,string custName
                                        ,string city
                                        ,string state
                                        ,string custPONo
                                        ,string pListDtlId
                                        ,string fListId
                                        ,string shipAddr1
                                        ,string shipAddr2
                                        ,string shipToZip
                                        ,string shipToCountry
                                        ,string shipToContact
                                        ,string shipToPhone)
        {
            DataSet dsShipData = SqlHelper.ExecuteDataset(Global.ShipLiveConnectionString, "[pWhseShippingListDetail]",
                                new SqlParameter("@mode", mode),
                                new SqlParameter("@pListId", pListDtlId),
                                new SqlParameter("@palletNo", palletNo),
                                new SqlParameter("@docNo", docNo),
                                new SqlParameter("@fShipListHeaderID", fListId),
                                new SqlParameter("@shipWght", shipWght),
                                new SqlParameter("@entryID", ""),
                                new SqlParameter("@custNo", custNo),
                                new SqlParameter("@custName", custName),
                                new SqlParameter("@city", city),
                                new SqlParameter("@state", state),
                                new SqlParameter("@custPONo", custPONo),
                                new SqlParameter("@finalDest", ""),
                                new SqlParameter("@shipAddr1", shipAddr1),
                                new SqlParameter("@shipAddr2", shipAddr2),
                                new SqlParameter("@shipToZip", shipToZip),
                                new SqlParameter("@shipCountry", shipToCountry),
                                new SqlParameter("@shipToContact", shipToContact),
                                new SqlParameter("@shipToPhone", shipToPhone));
            return dsShipData;

        }

        #endregion

        #region Print Methods



        string border;
        GridView dv = new GridView();
        DataTable dtExcelData = new DataTable();


        private string GenerateExportData(string dataFormat)
        {
            border = (dataFormat == "Print" ? "0" : "1");            
            dtExcelData = Session["ListDetail"] as DataTable;

            string styleSheet = "<style>.text { mso-number-format:\\@; } .barcode {font-size : 12pt; font-family : IDAutomationC39S; }</style>";
            string headerContent = string.Empty;
            string footerContent = string.Empty;
            string excelContent = string.Empty;

            headerContent = "<table border='0' width='800px'>";
            headerContent += "<tr><td  colspan='7' align='center'><span style='font-size : 12pt; font-family : IDAutomationC39S; '>*" + Request.QueryString["ListName"].ToString() + "*</span></td></tr>";  
            headerContent += "<tr><td  colspan='7' align='center' style='color:blue;font-family: Arial, Helvetica, sans-serif;font-size: 14px;	font-weight: bold;'><center>Shipping List</center></td></tr>";
            headerContent += "<tr><td  style='padding-left:40px'><b>List Name :" + Request.QueryString["ListName"].ToString() + "</b></td><td><b>Location:" + Request.QueryString["Location"].ToString() + "</b></td><td colspan='5'><b>Change ID: " + Request.QueryString["ChangeID"].ToString() + "</b></td></tr>";
            headerContent += "<tr><td style='padding-left:40px'><b>Entry ID:" + Request.QueryString["EntryID"].ToString() + "</b></td>" +
                                "<td><b>Entry Date: " + Request.QueryString["EntryDt"].ToString() + "</b></td>" +
                                "<td colspan='5'><b>Change Date: " + Request.QueryString["ChangeDt"].ToString() + "</></td></tr>";
            headerContent += "<tr><th colspan='7' style='color:blue' align=left></th></tr>";

            if (dtExcelData.Rows.Count > 0)
            {                
                dv.AutoGenerateColumns = false;
                dv.ShowHeader = true;
                dv.ShowFooter = true;
                dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);
                
                BoundField bfExcel = new BoundField();
                bfExcel.HeaderText = "Document No";
                bfExcel.DataField = "OrderNo";
                bfExcel.ItemStyle.Height = 25;
                bfExcel.FooterStyle.Height = 25;
                bfExcel.HeaderStyle.Height = 25;                
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Customer Name";
                bfExcel.DataField = "CustName";
                bfExcel.ItemStyle.Width = 150;
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Pallet No";
                bfExcel.DataField = "PalletNo";
                bfExcel.ItemStyle.Width = 80;
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Doc Lbs";
                bfExcel.DataField = "ShipWght";
                bfExcel.DataFormatString = "{0:#,##0.00}";
                bfExcel.ItemStyle.Width = 60;
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                bfExcel.FooterStyle.Font.Bold = true;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Entry ID";
                bfExcel.DataField = "EntryID";
                bfExcel.ItemStyle.Width = 80;
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Change ID";
                bfExcel.DataField = "ChangeID";
                bfExcel.ItemStyle.Width = 80;
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "PO #";
                bfExcel.DataField = "CustPONo";
                bfExcel.ItemStyle.Width = 170;
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Status";
                bfExcel.DataField = "StatusCd";
                bfExcel.ItemStyle.Width = 60;
                bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                dv.DataSource = dtExcelData;
                dv.DataBind();

                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                System.IO.StringWriter sw = new System.IO.StringWriter(sb);
                HtmlTextWriter htw = new HtmlTextWriter(sw);
                dv.RenderControl(htw);
                excelContent += "<table><tr><th colspan='7' style='padding-left:40px;padding-top:10px;' align=left>"; 
                excelContent += sb.ToString();
                excelContent += "</th></tr></table>"; 

            }
            else
            {
                excelContent = "<tr  ><th width='100%' align ='center' colspan='7' > No records found</th></tr> </table>";
            }

            return styleSheet + headerContent + excelContent;
        }
        
        protected void dv_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                DataTable dtListDetail = Session["ListDetail"] as DataTable;

                e.Row.Cells[3].Text = dtListDetail.Compute("Sum(ShipWght)", "").ToString();
                e.Row.Cells[2].Visible = false;
                e.Row.Cells[1].Visible = false;
                e.Row.Cells[0].ColumnSpan = 3;
                e.Row.Cells[0].Text = "Grand Total";
                e.Row.Cells[0].Font.Bold = true;                
            }
        }

        #endregion

    } // End Class

}// End Namespace
