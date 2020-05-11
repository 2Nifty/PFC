#region namespaces

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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.InventoryReconsiliation;

#endregion

public partial class InventoryReconsiliation_InventoryReconsiliation : System.Web.UI.Page
{
    #region Global Variables
    string StrLocation;
    private DataSet dsReconsiliation = new DataSet();
    private DataTable dtTotal = new DataTable();
    private string keyColumn = "ItemNo";
    private string sortExpression = string.Empty;
    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    int pagesize = 18;
    protected InventoryReconsiliation InventoryReconsiliation = new InventoryReconsiliation();
    
    #endregion
  

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(InventoryReconsiliation_InventoryReconsiliation));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        hidFileName.Value = "InventoryReconciliation" + Session["SessionID"].ToString() + name + ".xls";
        StrLocation = Session["DefaultCompanyID"].ToString();

        if (!IsPostBack)
        {


            lblBranch.Text = "Branch: " + Session["DefaultBranchName"].ToString();
             BindDataGrid();
        }
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);

        dsReconsiliation = InventoryReconsiliation.GetRecByLocation(StrLocation, sortExpression);

        if (dsReconsiliation != null && dsReconsiliation.Tables[0].Rows.Count>0)
        {dtTotal = dsReconsiliation.Tables[0].DefaultView.ToTable();
        GetTotal();
        dsReconsiliation.Tables[0].DefaultView.Sort = (hidSort.Value == "") ? "ItemNo asc" : hidSort.Value; 
        dgReconsiliation.DataSource = dsReconsiliation.Tables[0];
        dgReconsiliation.DataBind();
        pnldgrid.Update();
        Pager1.InitPager(dgReconsiliation, pagesize);
        Pager1.Visible = true;
    }
        else
        
        Pager1.Visible = false;
    }

    private void GetTotal()
    {
        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
        drow["ItemNo"] = "Grand Total";
        drow["ItemDesc"] = "";
        drow["UOM"] = "";
        drow["Qty"] = Convert.ToDecimal(dsReconsiliation.Tables[0].Compute("sum(Qty)", "")).ToString();
        drow["BookedQty"] = Convert.ToDecimal(dsReconsiliation.Tables[0].Compute("sum(BookedQty)", "")).ToString();
        drow["Variance"] = 0;
        drow["SuperEquiv"] = "";
        drow["SuperEquivQty"] = Convert.ToDecimal(dsReconsiliation.Tables[0].Compute("sum(SuperEquivQty)", "")).ToString();
        dtTotal.Rows.Add(drow);
    }
    
    #endregion

    #region Write to Excel

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);
        dsReconsiliation = InventoryReconsiliation.GetRecByLocation(StrLocation, sortExpression);
        dtTotal = dsReconsiliation.Tables[0].DefaultView.ToTable();
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='8' style='color:blue'>Inventory Reconciliation Report</th></tr>";
        headerContent += "<tr><th colspan='4' align='left'>" + lblBranch.Text + "</th><th colspan='4' aligh='right' >Run By :" + Session["UserName"].ToString() + " Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th>Item</th><th>Description</th><th>UOM</th><th>WMS Qty</th><th>ERP Qty</th><th>Variance</th><th colspan=2 style='font-weight:bold;'><table border=1 style='font-weight:bold;'><tr><td colspan=2 align=center>Super Equivelant</td></tr><tr><td>Super UOM</td><td>Equivelant Qty</td></tr></table></th></tr>";
        if (dtTotal.Rows.Count > 0)
        {
            foreach (DataRow roiReader in dtTotal.Rows)
            {
                excelContent += "<tr><td>" + roiReader["ItemNo"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0.00}", roiReader["ItemDesc"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", roiReader["UOM"]) + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["Qty"]) + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["BookedQty"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", roiReader["Variance"]) + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["SuperEquiv"]) + "</td><td>" +
                     String.Format("{0:#,##0}", roiReader["SuperEquivQty"]) + "</td></tr>";
            }
            GetTotal();
            footerContent = "<tr style='font-weight:bold;'><td>" + dtTotal.Rows[0]["ItemNo"].ToString() + "</td><td>" +
                      String.Format("{0:#,##0.00}", dtTotal.Rows[0]["ItemDesc"]) + "</td><td>" +
                      String.Format("{0:#,##0.00}", dtTotal.Rows[0]["UOM"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["Qty"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["BookedQty"]) + "</td><td>" +
                      String.Format("{0:#,##0.00}", dtTotal.Rows[0]["Variance"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["SuperEquiv"]) + "</td><td>" +
                      String.Format("{0:#,##0}", dtTotal.Rows[0]["SuperEquivQty"]) + "</td>" +
                    "</tr></table>";
        }
        reportWriter.WriteLine(headerContent + excelContent + footerContent);
        reportWriter.Close();


        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\InventoryReconsiliation\\Common\\ExcelUploads"));

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

    #region Events
    protected void  dgReconsiliation_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {
          
            e.Item.Cells[6].ColumnSpan = 2;
            e.Item.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%' ><tr>" +
                                "<td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;' nowrap colspan=2>Super Equivelant</td></tr><tr>" +
                                "<td  class='GridHead splitBorders' style='cursor:hand;border-right:solid 1px #c9c6c6;' width='61px'><center><Div onclick=\"javascript:BindValue('SuperEquiv');\">&nbsp;UOM</div></center>" +
                                "</td><td  class='GridHead ' nowrap align='center' style='cursor:hand;padding-right: 0px;' ><Div onclick=\"javascript:BindValue('SuperEquivQty');\">&nbsp;Qty</div></td>" +
                                "</tr></table>";
                

            e.Item.Cells[7].Visible = false;
        }
        
        if (e.Item.ItemType == ListItemType.Footer)
        {
            
            e.Item.Cells[0].Text = dtTotal.Rows[0]["ItemNo"].ToString();
            e.Item.Cells[1].Text = dtTotal.Rows[0]["ItemDesc"].ToString();
            e.Item.Cells[2].Text = dtTotal.Rows[0]["UOM"].ToString();
            e.Item.Cells[3].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["Qty"]);
            e.Item.Cells[4].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["BookedQty"]);
            e.Item.Cells[5].Text = "";
            e.Item.Cells[6].Text = dtTotal.Rows[0]["SuperEquiv"].ToString();
            e.Item.Cells[7].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["SuperEquivQty"]);

        }
    }

    protected void dgReconsiliation_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgReconsiliation.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
        pnldgrid.Update(); 
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgReconsiliation.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
        pnldgrid.Update();
    }

    protected void dgReconsiliation_SortCommand(object source,DataGridSortCommandEventArgs e)
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
        pnldgrid.Update();
    }

    protected void btnSort_Click(object source, EventArgs e)
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
        BindDataGrid();
    }
    #endregion
}
