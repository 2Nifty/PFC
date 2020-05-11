
/********************************************************************************************
 * File	Name			:	BranchItemSalesAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvaldtl Table - Branchwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2006		    Version 1		Senthilkumar		Excel Report Added 
 * 08/19/2006		    Version 2		Senthilkumar 		Store Procedure Name Changed
 * 09/20/2006           Version 3		Mahesh      		Implemented Ajax To Delete Excel Files on Page Unload & Comments Added
 *********************************************************************************************/
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
using System.Reflection;
using System.IO;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.Utility;

public partial class BranchItemShippingSalesAnalysis : System.Web.UI.Page
{
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    Utility utility = new Utility();

    System.Data.DataTable dt = new System.Data.DataTable();
    DataSet dsItemInfo = new DataSet();

    string strMonth = string.Empty;
    string strMonthName = string.Empty;
    string strYear = string.Empty;
    string strBranch = string.Empty;
    string strCatFrom = string.Empty;
    string strCatTo = string.Empty;
    int pagesize = 17;
    string strVarianceFrom = string.Empty;
    string strVarianceTo = string.Empty;
    string strSalesRep = string.Empty;
    string strAgent = string.Empty;
    System.IO.FileStream fStream;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            utility.CheckBrowserCompatibility(Request, dgAnalysis, ref pagesize);

            #region Get QueryString Values

            strMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
            strMonthName = (Request.QueryString["MonthName"] != null) ? Request.QueryString["MonthName"].ToString().Trim() : "";
            strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
            strBranch = (Request.QueryString["Branch"] != "0") ? Request.QueryString["Branch"].ToString().Trim() : "";
            strAgent = (Request.QueryString["Agent"] != "0") ? Request.QueryString["Agent"].ToString().Trim() : "";
            strCatFrom = (Request.QueryString["CategoryFrom"] != null) ? Request.QueryString["CategoryFrom"].ToString().Trim() : "";
            strCatTo = (Request.QueryString["CategoryTo"] != null) ? Request.QueryString["CategoryTo"].ToString().Trim() : "";
            strVarianceFrom = (Request.QueryString["VarianceFrom"] != null) ? Request.QueryString["VarianceFrom"].ToString().Trim() : "";
            strVarianceTo = (Request.QueryString["VarianceTo"] != null) ? Request.QueryString["VarianceTo"].ToString().Trim() : "";
            strSalesRep = (Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString().Trim() != "All") ? Request.QueryString["SalesRep"].ToString().Trim().Replace("|","'") : "") : "";

            #endregion

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(BranchItemShippingSalesAnalysis));

            string name = DateTime.Now.ToString().Replace("/", "");
            name = name.Replace(" ", "");
            name = name.Replace(":", "");
            ViewState["ExcelFileName"] = "BranchItemSalesAnalysis" + Session["SessionID"].ToString() + name + ".xls";

            #region To Display Period And Version Radio Button Modified By Mahesh

            if (Request.QueryString["Period"] != null)
            {
                rdoDate1.Checked = (Request.QueryString["Period"].ToString().Trim() == "ytd") ? false : true;
                rdoDate2.Checked = (Request.QueryString["Period"].ToString().Trim() == "ytd") ? true : false;
                spnPeriod.Visible = false;
            }


            if (Request.QueryString["Version"] != null)
            {
                rdoReportVersion1.Checked = (Request.QueryString["Version"].ToString().Trim() == "short") ? false : true;
                rdoReportVersion2.Checked = (Request.QueryString["Version"].ToString().Trim() == "long") ? false :true;
                spnVersion.Visible = false;
            }

            #endregion

            if (!IsPostBack)
                ItemDataDisplay();

        }
        catch (Exception ex){ }
    }
    
    // To Display Item in the DataGrid When First Time Page Load
    public void ItemDataDisplay()
    {
        GetItemData();
        ChangerFormat();
    }
    
    public void GetItemData()
    {
        try
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString());
            SqlDataAdapter adp;
            SqlCommand Cmd = new SqlCommand();

            if (!strBranch.Contains(","))
            {
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "PFC_RPT_SP_BranchItemShippingSalesAnalysis";
                Cmd.Parameters.Add(new SqlParameter("@PeriodMonth", strMonth));
                Cmd.Parameters.Add(new SqlParameter("@PeriodYear", strYear));
                Cmd.Parameters.Add(new SqlParameter("@Branch", strBranch));
                Cmd.Parameters.Add(new SqlParameter("@ShippingAgent", strAgent));
                Cmd.Parameters.Add(new SqlParameter("@CatFrom", strCatFrom));
                Cmd.Parameters.Add(new SqlParameter("@CatTo", strCatTo));
                Cmd.Parameters.Add(new SqlParameter("@VarianceFrom", strVarianceFrom));
                Cmd.Parameters.Add(new SqlParameter("@VarianceTo", strVarianceTo));
                Cmd.Parameters.Add(new SqlParameter("@SalesRep", strSalesRep.Replace("'","''")));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsItemInfo);
            }
            else
            {
               
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "PFC_RPT_SP_BranchItemShippingSalesAnalysis_all";
                Cmd.Parameters.Add(new SqlParameter("@PeriodMonth", strMonth));
                Cmd.Parameters.Add(new SqlParameter("@PeriodYear", strYear));
                Cmd.Parameters.Add(new SqlParameter("@SBranch", strBranch));

                Cmd.Parameters.Add(new SqlParameter("@NSBranch", Session["UnAuthorizedBranch"].ToString()));
                Cmd.Parameters.Add(new SqlParameter("@TSBranch", Session["AuthorizedBranchTotal"].ToString()));
                Cmd.Parameters.Add(new SqlParameter("@TNSBranch", Session["UnAuthorizedBranchTotal"].ToString()));
                Cmd.Parameters.Add(new SqlParameter("@ShippingAgent", strAgent));
                Cmd.Parameters.Add(new SqlParameter("@CatFrom", strCatFrom));
                Cmd.Parameters.Add(new SqlParameter("@CatTo", strCatTo));
                Cmd.Parameters.Add(new SqlParameter("@VarianceFrom", strVarianceFrom));
                Cmd.Parameters.Add(new SqlParameter("@VarianceTo", strVarianceTo));
                Cmd.Parameters.Add(new SqlParameter("@SalesRep", strSalesRep.Replace("'", "''")));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsItemInfo);

            }

            dt.Clear();
            dt = dsItemInfo.Tables[0];
            dt.DefaultView.Sort = "Item" + " " + "asc";
            Session["BranchItem"] = dt;

            // Footer table
            if (dsItemInfo.Tables[1] != null)
            {
                Session["dtGrandTotal"] = dsItemInfo.Tables[1];
            }

            ViewState["SortField"] = "Item";
            ViewState["SortMode"] = "asc";
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message.ToString());

        }
    }

    // Event to Change the page of the datagrid
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
        ChangerFormat();
    }
    
    protected void btnPrint_Click(Object sender, System.EventArgs e)
    {
        if (rdoReportVersion1.Checked == true && rdoDate1.Checked == true)
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('long','ytd')</script>");
        if (rdoReportVersion1.Checked == true && rdoDate2.Checked == true)
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('long','mtd')</script>");
        if (rdoReportVersion2.Checked == true && rdoDate1.Checked == true)
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('short','ytd')</script>");
        if (rdoReportVersion2.Checked == true && rdoDate2.Checked == true)
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('short','mtd')</script>");
        ChangerFormat();
    }
    
    #region DataGrid Functionalities
    public void BindDataGridHeader()
    {
        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        dgAnalysis.Columns[0].HeaderText = "Ship Agent";
        dgAnalysis.Columns[1].HeaderText = "Item";
        dgAnalysis.Columns[2].HeaderText = "Item Desc";
        dgAnalysis.Columns[3].HeaderText = "UOM";
        dgAnalysis.Columns[4].HeaderText = strYearDis + " Qty";
        dgAnalysis.Columns[5].HeaderText = strYearDis + " Sales $";
        dgAnalysis.Columns[6].HeaderText = strYearDis + " GM $";
        dgAnalysis.Columns[7].HeaderText = " GM %";
        dgAnalysis.Columns[8].HeaderText = strYearDis + " SellWgt";
        dgAnalysis.Columns[9].HeaderText = " $/Lb";
        dgAnalysis.Columns[10].HeaderText = strYearDis + " Ord";

        dgAnalysis.Columns[11].HeaderText = "YTD" + strYearDis + " Qty";
        dgAnalysis.Columns[12].HeaderText = "YTD" + strPreYearDis + " Qty";
        dgAnalysis.Columns[13].HeaderText = "YTD" + strYearDis + " Sales $";
        dgAnalysis.Columns[14].HeaderText = "YTD" + strPreYearDis + " Sales $";
        dgAnalysis.Columns[15].HeaderText = "YTD" + strYearDis + " GM$";
        dgAnalysis.Columns[16].HeaderText = "YTD" + strPreYearDis + " GM$";
        dgAnalysis.Columns[17].HeaderText = "YTD" + strYearDis + " GM%";
        dgAnalysis.Columns[18].HeaderText = "YTD" + strPreYearDis + " GM%";
        dgAnalysis.Columns[19].HeaderText = "YTD" + strYearDis + " SellWgt";
        dgAnalysis.Columns[20].HeaderText = "YTD" + strPreYearDis + " SellWgt";
        dgAnalysis.Columns[21].HeaderText = "YTD" + strYearDis + " $/Lb";
        dgAnalysis.Columns[22].HeaderText = "YTD" + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[23].HeaderText = "YTD" + strYearDis + " Ord";
        dgAnalysis.Columns[24].HeaderText = "YTD" + strPreYearDis + " Ord";

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        
    }
    public void BindDataToGrid()
    {
        try
        {
            ExcelExport();
            BindDataGridHeader();
            System.Data.DataTable dt = (System.Data.DataTable)Session["BranchItem"];
            dt.DefaultView.Sort = hidSort.Value;
            Session["BranchItem"] = dt.DefaultView.ToTable();
            dgAnalysis.DataSource = dt.DefaultView.ToTable();
            if (dt.Rows.Count > 0)
            {
                Pager1.InitPager(dgAnalysis, pagesize);

                DropDownList ddl = Pager1.FindControl("ddlPages") as DropDownList;
                if (ddl.SelectedItem.Value.ToString() == ddl.Items.Count.ToString())
                {
                    dgAnalysis.ShowFooter = true;
                }
                else
                    dgAnalysis.ShowFooter = false;

                if (dgAnalysis.Items.Count <= 0)
                {
                    dgAnalysis.Visible = false;
                    
                    btnPrint.Visible = false;
                    tblPager.Visible = false;
                    lblStatus.Visible = true;
                }
                else
                {
                    dgAnalysis.Visible = true;
                    
                    btnPrint.Visible = true;
                    tblPager.Visible = true;
                    lblStatus.Visible = false;


                }
                
            }
            else
            {
                dgAnalysis.Visible = false;
                btnPrint.Visible = false;
                tblPager.Visible = false;
                lblStatus.Visible = true;

            }

        }
        catch (Exception ex)
        {
            Response.Write(ex.Message.ToString());

        }
    }
    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        e.Item.Cells[0].Width = 100;
        e.Item.Cells[1].Width = 150;
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            //string url = string.Empty;
            //url = "BranchCustomerSalesAnalysis.aspx?BranchName=" + Request.QueryString["BranchName"] + "~Item=" + e.Item.Cells[0].Text + "~MonthName=" + Request.QueryString["MonthName"] + "~Month=" + Request.QueryString["Month"] + "~Year=" + Request.QueryString["Year"] + "~Branch=" + Request.QueryString["Branch"] + "~SalesRep=" + strSalesRep + "~Version=" + ((rdoReportVersion1.Checked) ? "long" : "short") + "~Period=" + ((rdoDate1.Checked) ? "mtd" : "ytd");
            //url = "ProgressBar.aspx?destPage=" + url;
            //HyperLink hplButton = new HyperLink();
            //hplButton.Text = e.Item.Cells[0].Text;
            //hplButton.NavigateUrl = url;
            ////height=700,width=1020,scrollbars=no,status=no,top='((screen.height/2) - (760/2))',left='((screen.width/2) - (1020/2))',resizable=YES
            //hplButton.Attributes.Add("onclick", "DocumentSales=window.open(this.href, 'DocumentSales', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); return false;");
            //e.Item.Cells[0].Controls.Add(hplButton);
            //e.Item.Cells[0].CssClass = "GridItemLink";
        }
        else if (e.Item.ItemType == ListItemType.Footer && Session["dtGrandTotal"] != null)
        {

            System.Data.DataTable dtFooter = Session["dtGrandTotal"] as System.Data.DataTable;

            DataRow dr = dtFooter.Rows[0];

            e.Item.Cells[0].Text = "Total";
            //e.Item.Cells[3].Text = CMQty.ToString();
            //e.Item.Cells[3].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[4].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_InvQty"].ToString() != "" ? dr["CM_InvQty"].ToString() : "0")));
            e.Item.Cells[4].HorizontalAlign = HorizontalAlign.Right;

            e.Item.Cells[5].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_sales"].ToString() != "" ? dr["CM_sales"].ToString() : "0")));
            e.Item.Cells[5].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[6].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_GM$"].ToString() != "" ? dr["CM_GM$"].ToString() : "0")));
            e.Item.Cells[6].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[7].Text = string.Format("{0:0.0}", Convert.ToDouble((dr["CM_GMPer"].ToString() != "" ? dr["CM_GMPer"].ToString() : "0")));
            e.Item.Cells[7].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[8].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_SellWgt"].ToString() != "" ? dr["CM_SellWgt"].ToString() : "0")));
            e.Item.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[9].Text = string.Format("{0:0.00}", Convert.ToDouble((dr["CM_lb"].ToString() != "" ? dr["CM_lb"].ToString() : "0")));
            e.Item.Cells[9].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[10].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CM_order"].ToString() != "" ? dr["CM_order"].ToString() : "0")));
            e.Item.Cells[10].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[11].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_InvQty"].ToString() != "" ? dr["CY_InvQty"].ToString() : "0")));
            e.Item.Cells[11].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[12].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_InvQty"].ToString() != "" ? dr["PY_InvQty"].ToString() : "0")));
            e.Item.Cells[12].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[13].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_Sales"].ToString() != "" ? dr["CY_Sales"].ToString() : "0")));
            e.Item.Cells[13].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[14].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_Sales"].ToString() != "" ? dr["PY_Sales"].ToString() : "0")));
            e.Item.Cells[14].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[15].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_GM$"].ToString() != "" ? dr["CY_GM$"].ToString() : "0")));
            e.Item.Cells[15].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[16].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_GM$"].ToString() != "" ? dr["PY_GM$"].ToString() : "0")));
            e.Item.Cells[16].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[17].Text = string.Format("{0:0.0}", Convert.ToDouble((dr["CY_GMPer"].ToString() != "" ? dr["CY_GMPer"].ToString() : "0")));
            e.Item.Cells[17].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[18].Text = string.Format("{0:0.0}", Convert.ToDouble((dr["PY_GMPer"].ToString() != "" ? dr["PY_GMPer"].ToString() : "0")));
            e.Item.Cells[18].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[19].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_Sellwgt"].ToString() != "" ? dr["CY_Sellwgt"].ToString() : "0")));
            e.Item.Cells[19].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[20].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_Sellwgt"].ToString() != "" ? dr["PY_Sellwgt"].ToString() : "0")));
            e.Item.Cells[20].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[21].Text = string.Format("{0:0.00}", Convert.ToDouble((dr["CY_lb"].ToString() != "" ? dr["CY_lb"].ToString() : "0")));
            e.Item.Cells[21].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[22].Text = string.Format("{0:0.00}", Convert.ToDouble((dr["PY_lb"].ToString() != "" ? dr["PY_lb"].ToString() : "0")));
            e.Item.Cells[22].HorizontalAlign = HorizontalAlign.Right;

            e.Item.Cells[23].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["CY_Order"].ToString() != "" ? dr["CY_Order"].ToString() : "0")));
            e.Item.Cells[23].HorizontalAlign = HorizontalAlign.Right;
            e.Item.Cells[24].Text = string.Format("{0:#,0}", Convert.ToDouble((dr["PY_Order"].ToString() != "" ? dr["PY_Order"].ToString() : "0")));
            e.Item.Cells[24].HorizontalAlign = HorizontalAlign.Right;
        }
        e.Item.Cells[0].Width = 75;
        e.Item.Cells[1].Width = 100;
        e.Item.Cells[2].Width = 230;
        e.Item.Cells[0].CssClass = "locked";
        e.Item.Cells[1].CssClass = "locked";
        e.Item.Cells[2].CssClass = "locked";
    }
    protected void dgAnalysis_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        ChangerFormat();
        
    }
    protected void dgAnalysis_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgAnalysis.CurrentPageIndex = e.NewPageIndex;
        ChangerFormat();
    }
    #endregion
    
    #region Web Form Designer generated code
    override protected void OnInit(EventArgs e)
    {
        //
        // CODEGEN: This call is required by the ASP.NET Web Form Designer.
        //
        InitializeComponent();
        base.OnInit(e);
    }

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.Pager1.BubbleClick += new EventHandler(this.Pager_PageChanged);
    }
    #endregion

    #region Generate Excel Report

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
    }

    protected void  ExcelExport()
    {
        try
        {
                       
            string createdFileName =string.Empty;

            if (File.Exists(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString())))
                File.Delete(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString()));

            if(rdoDate2.Checked && rdoReportVersion1.Checked)
                 CreateExcelForYTDLongVersion(ViewState["ExcelFileName"].ToString());
            else if(rdoDate2.Checked && rdoReportVersion2.Checked)
                CreateExcelForYTDShortVersion(ViewState["ExcelFileName"].ToString());
            else if(rdoDate1.Checked && rdoReportVersion2.Checked)
                 CreateExcelForMTDShortVersion(ViewState["ExcelFileName"].ToString());
            else if (rdoDate1.Checked && rdoReportVersion1.Checked)
                 CreateExcelForMTDLongVersion(ViewState["ExcelFileName"].ToString());

        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void CreateExcelForYTDLongVersion(string fileName)
    {

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                    Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName ));


        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=25><font size=15px color=blue><b>Branch Item Sales Analysis Report</b></font></th></tr>");
        reportWriter.WriteLine("<tr><td colspan=25></td></tr>");

        reportWriter.WriteLine("<tr>" +
                "<th>" + "Period :</th><th colspan=3>" + strMonthName + " " + strYear + "</th>" +
                "<th>Branch :</th><th>" + strBranch + "</th>" +
                "<th>Agent :</th><th>" + strAgent + "</th>" +
                "<th>Category :</th><th colspan=3>" + ((strCatFrom == "" && strCatTo == "") ? "All" : strCatFrom + " - " + strCatTo) + "</th>" +
                "<th>Variance :</th><th colspan=3>" + ((strVarianceFrom == "" && strVarianceTo == "") ? "All" : strVarianceFrom + " - " + strVarianceTo) + "</th>" +
                "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"]!=null)?((Request.QueryString["SalesRep"].ToString()!="")?Request.QueryString["SalesRep"].ToString().Replace("|","'"):"All"):"All") + "</th>" +
                "<th>Run By :</th><th colspan=2>" + Session["UserName"].ToString() + "</th>" +
                "<th>Run Date :</th><th colspan=3>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=24></td></tr>");
        System.Data.DataTable dt1 = (System.Data.DataTable)Session["BranchItem"];
        dt1.DefaultView.Sort = hidSort.Value;
        string headerline = "<th>Agent</th><th>Item</th><th width=400px>Item Desc</th><th>UOM</th>";
        headerline = headerline + "<th>" + strYearDis + " Qty" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " Sales $" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " GM $" + "</th>";
        headerline = headerline + "<th>" + " GM %" + "</th>" ;
        headerline = headerline + "<th>" + strYearDis + " SellWgt" + "</th>";
        headerline = headerline + "<th>" + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " Ord" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " Qty" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " Qty" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " Sales $" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " Sales $" + "</th>" ;
        headerline = headerline + "<th>" + "YTD" + strYearDis + " GM$" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " GM$" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " GM%" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " GM%" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " SellWgt" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " SellWgt" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " Ord" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " Ord" + "</th></tr>";
        reportWriter.WriteLine(headerline);

        foreach (DataRow drow in dt1.DefaultView.ToTable().Rows)
        {
            string lineContent = string.Empty;
            for (int i = 0; i <= 24; i++)
            {
                lineContent += "<td>"+((i <= 3 || i == 7 || i == 9 || i == 17 || i == 18 || i == 21 || i == 22) ? 
                    ((drow[i].ToString()!="")?drow[i].ToString():"0"): 
                    ((drow[i].ToString() != "0") ?((drow[i].ToString() != "")? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])):"0") : "0"))+ "</td>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
        }
        System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtGrandTotal"];
        foreach (DataRow drow in dtTotal.Rows)
        {

            string lineContent = string.Empty;
            lineContent = "<th colspan=4 align=right>Grand Total</th>";
            for (int i = 0; i <= 20; i++)
            {
                lineContent += ((i == 5 || i == 7 || i == 15 || i == 16 || i == 19 || i == 20) ? "<th align=right>" + drow[i].ToString() + "</th>" :
                    "<th  align=right>" + ((drow[i].ToString() != "0") ? ((drow[i].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])) : "0") : "0")) + "</th>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
        }
        reportWriter.WriteLine("</table>");
        reportWriter.Close();
       
    }

    private void CreateExcelForYTDShortVersion(string fileName)
    {

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                    Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName ));

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=19><font size=15px color=blue><b>Branch Item Sales Analysis Report</b></font></th></tr>");
        reportWriter.WriteLine("<tr><td colspan=19></td></tr>");

        reportWriter.WriteLine("<tr>" +
                                "<th>" + "Period :</th><th colspan=1>" + strMonthName + " " + strYear + "</th>" +
                                "<th>Branch :</th><th>" + strBranch + "</th>" +
                                "<th>Agent :</th><th>" + strAgent + "</th>" +
                                "<th>Category :</th><th colspan=2>" + ((strCatFrom == "" && strCatTo == "") ? "All" : strCatFrom + " - " + strCatTo) + "</th>" +
                                "<th>Variance :</th><th colspan=2>" + ((strVarianceFrom == "" && strVarianceTo == "") ? "All" : strVarianceFrom + " - " + strVarianceTo) + "</th>" +
                                "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") : "All") + "</th>" +
                                "<th>Run By :</th><th colspan=2>" + Session["UserName"].ToString() + "</th>" +
                                "<th>Run Date :</th><th colspan=2>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=18></td></tr>");
        System.Data.DataTable dt1 = (System.Data.DataTable)Session["BranchItem"];
        dt1.DefaultView.Sort = hidSort.Value;
        string headerline = "<th>Agent</th><th>Item</th><th>Item Desc</th><th>UOM</th>";
        headerline = headerline + "<th>" + strYearDis + " Qty" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " Sales $" + "</th>";
        headerline = headerline + "<th>" + " GM %" + "</th>";
        headerline = headerline + "<th>" + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " Ord" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " Qty" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " Qty" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " Sales $" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " Sales $" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " GM%" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " GM%" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strYearDis + " Ord" + "</th>";
        headerline = headerline + "<th>" + "YTD" + strPreYearDis + " Ord" + "</th></tr>";
        reportWriter.WriteLine(headerline);

        foreach (DataRow drow in dt1.DefaultView.ToTable().Rows)
        {
            string lineContent = string.Empty;
            for (int i = 0; i <= 24; i++)
            {
                if (i != 6 && i != 8 && i != 15 && i != 16 && i != 19 && i != 20)
                    lineContent += "<td>"+((i <= 3 || i == 7 || i == 9 || i == 17 || i == 18 || i == 21 || i == 22) ?drow[i].ToString():
                        ((drow[i].ToString() != "0") ? ((drow[i].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])) : "0") : "0")) + "</td>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
        }
        System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtGrandTotal"];
        foreach (DataRow drow in dtTotal.Rows)
        {

            string lineContent = string.Empty;
            lineContent = "<th colspan=4 align=right>Grand Total</th>";
            for (int i = 0; i <= 20; i++)
            {
                if (i != 2 && i != 4 && i != 11 && i != 12 && i != 15 && i != 16)
                lineContent += ((i == 3 || i == 5 || i == 13 || i == 14 || i == 17 || i == 18) ? "<th align=right>" + drow[i].ToString() + "</th>" :
                    "<th  align=right>" + ((drow[i].ToString() != "0") ? ((drow[i].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])) : "0") : "0")) + "</th>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
            
        }
        reportWriter.WriteLine("</table>");
        reportWriter.Close();
       
    }

    private void CreateExcelForMTDShortVersion(string fileName)
    {

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName ));


        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=8><font size=15px color=blue><b>Branch Item Sales Analysis Report</b></font></th></tr>");
        reportWriter.WriteLine("<tr><td colspan=8></td></tr>");

        reportWriter.WriteLine("<tr>" +
                                "<th>" + "Period :</th><th colspan=1>" + strMonthName + " " + strYear + "</th>" +
                                "<th>Branch :</th><th>" + strBranch + "</th>" +
                                "<th>Category :</th><th colspan=1>" + ((strCatFrom == "" && strCatTo == "") ? "All" : strCatFrom + " - " + strCatTo) + "</th>" +
                                "<th>Variance :</th><th colspan=1>" + ((strVarianceFrom == "" && strVarianceTo == "") ? "All" : strVarianceFrom + " - " + strVarianceTo) + "</th></tr>" );


        reportWriter.WriteLine("<tr>" + "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") : "All") + "</th>" +
                                "<th>Run By :</th><th colspan=1>" + Session["UserName"].ToString() + "</th>" +
                                "<th>Run Date :</th><th colspan=1>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=8></td></tr>");
        System.Data.DataTable dt1 = (System.Data.DataTable)Session["BranchItem"];
        dt1.DefaultView.Sort = hidSort.Value;
        string headerline = "<th>Item</th><th>Item Desc</th><th>UOM</th>";
        headerline = headerline + "<th >" + strYearDis + " Qty" + "</th>";
        headerline = headerline + "<th >" + strYearDis + " Sales $" + "</th>";
        headerline = headerline + "<th>" + " GM %" + "</th>";
        headerline = headerline + "<th >" + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " Ord" + "</th>";

        reportWriter.WriteLine(headerline);

        foreach (DataRow drow in dt1.DefaultView.ToTable().Rows)
        {
            string lineContent = string.Empty;
            for (int i = 0; i <= 24; i++)
            {
                if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 7 || i == 9 || i == 10)
                    lineContent += "<td>" + ((i <= 3 || i == 7 || i == 9) ? ((drow[i].ToString() != "") ? drow[i].ToString() : "0") :
                        ((drow[i].ToString() != "0") ? ((drow[i].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])) : "0") : "0")) + "</td>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
        }
        System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtGrandTotal"];
        foreach (DataRow drow in dtTotal.Rows)
        {
            string lineContent = string.Empty;
            lineContent = "<th colspan=4 align=right>Grand Total</th>";
            for (int i = 0; i <= 20; i++)
            {
                if (i == 0 || i == 1 || i == 3 || i == 5 || i == 6)
                    lineContent += ((i == 3 || i == 5 ) ? "<th align=right>" + drow[i].ToString() + "</th>" :
                        "<th  align=right>" + ((drow[i].ToString() != "0") ? ((drow[i].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])) : "0") : "0")) + "</th>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
        }
        reportWriter.WriteLine("</table>");
        reportWriter.Close();
        
    }

    private void CreateExcelForMTDLongVersion(string fileName)
    {

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName ));

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=10><font size=15px color=blue><b>Branch Item Sales Analysis Report</b></font></th></tr>");
        reportWriter.WriteLine("<tr><td colspan=10></td></tr>");

        reportWriter.WriteLine("<tr>" +
                                "<th>" + "Period :</th><th colspan=1>" + strMonthName + " " + strYear + "</th>" +
                                "<th>Branch :</th><th>" + strBranch + "</th>" +
                                "<th>Category :</th><th colspan=1>" + ((strCatFrom == "" && strCatTo == "") ? "All" : strCatFrom + " - " + strCatTo) + "</th>" +
                                "<th>Variance :</th><th colspan=1>" + ((strVarianceFrom == "" && strVarianceTo == "") ? "All" : strVarianceFrom + " - " + strVarianceTo) + "</th>"+
                                "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") : "All") + "</th></tr>");
        
        reportWriter.WriteLine("<tr>" +"<th>Run By :</th><th colspan=1>" + Session["UserName"].ToString() + "</th><th>Run Date :</th><th colspan=1>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=10></td></tr>");
        System.Data.DataTable dt1 = (System.Data.DataTable)Session["BranchItem"];
        dt1.DefaultView.Sort = hidSort.Value;
        string headerline = "<th>Item</th><th>Item Desc</th><th>UOM</th>";
        headerline = headerline + "<th >" + strYearDis + " Qty" + "</th>";
        headerline = headerline + "<th >" + strYearDis + " Sales $" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " GM $" + "</th>";
        headerline = headerline + "<th>" + " GM %" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " SellWgt" + "</th>";
        headerline = headerline + "<th >" + " $/Lb" + "</th>";
        headerline = headerline + "<th>" + strYearDis + " Ord" + "</th>";

        reportWriter.WriteLine(headerline);

        foreach (DataRow drow in dt1.DefaultView.ToTable().Rows)
        {
            string lineContent = string.Empty;
            for (int i = 0; i <= 24; i++)
            {
                if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 7 || i == 8 || i == 9 || i == 10)
                    lineContent += "<td>" + ((i <= 3 || i == 7 || i == 9) ? ((drow[i].ToString() != "") ? drow[i].ToString() : "0") :
                        ((drow[i].ToString() != "0") ? ((drow[i].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])) : "0") : "0")) + "</td>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
        }
        System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtGrandTotal"];
        foreach (DataRow drow in dtTotal.Rows)
        {
            string lineContent = string.Empty;
            lineContent = "<th colspan=4 align=right>Grand Total</th>";
            for (int i = 0; i <= 20; i++)
            {
                if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 7)
                    lineContent += ((i == 4 || i == 6) ? "<th align=right>" + drow[i].ToString() + "</th>" :
                        "<th  align=right>" + ((drow[i].ToString() != "0") ? ((drow[i].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[i])) : "0") : "0")) + "</th>";
            }
            reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
        }
        reportWriter.WriteLine("</table>");
        reportWriter.Close();
    }

    #endregion

    # region MTD & YTD Option  With Short &  Long Version 
    protected void rdoReportVersion1_CheckedChanged(Object sender, System.EventArgs e)
    {
        ChangerFormat();
    }
    protected void rdoReportVersion2_CheckedChanged(Object sender, System.EventArgs e)
    {
        ChangerFormat();
    }
    protected void rdoDate1_CheckedChanged(object sender, EventArgs e)
    {
        ChangerFormat();
    }
    protected void rdoDate2_CheckedChanged(object sender, EventArgs e)
    {
        ChangerFormat();
    }

    public void ChangerFormat()
    {
        #region To Display The Columns According To The Version Selected

        bool version= (((rdoReportVersion1.Checked && rdoDate1.Checked) ||(rdoReportVersion1.Checked && rdoDate2.Checked) ) ? true : false);
        dgAnalysis.Columns[5].Visible  = version;
        dgAnalysis.Columns[7].Visible  = version;

        dgAnalysis.Columns[14].Visible = ((rdoReportVersion1.Checked && rdoDate2.Checked) ? true : false);
        dgAnalysis.Columns[15].Visible = ((rdoReportVersion1.Checked && rdoDate2.Checked) ? true : false);
        dgAnalysis.Columns[18].Visible = ((rdoReportVersion1.Checked && rdoDate2.Checked) ? true : false);
        dgAnalysis.Columns[19].Visible = ((rdoReportVersion1.Checked && rdoDate2.Checked) ? true : false);

        #endregion

        #region To Display The Columns According To The Period Selected

        bool Period = ((rdoDate2.Checked) ? true : false);
        dgAnalysis.Columns[10].Visible =Period;
        dgAnalysis.Columns[11].Visible =Period;
        dgAnalysis.Columns[12].Visible =Period;
        dgAnalysis.Columns[13].Visible =Period;
        dgAnalysis.Columns[16].Visible =Period;
        dgAnalysis.Columns[17].Visible =Period;
        dgAnalysis.Columns[20].Visible =Period;
        dgAnalysis.Columns[21].Visible =Period;
        dgAnalysis.Columns[22].Visible =Period;
        dgAnalysis.Columns[23].Visible = Period;

        #endregion
        //dgAnalysis.Width = (rdoDate1.Checked) ? 1000 : 1800;
        dgAnalysis.Width = (rdoReportVersion1.Checked && rdoDate2.Checked)
                                    ? 1800 :
                                    ((rdoReportVersion2.Checked && rdoDate2.Checked) ? 1300 : 
                                    (rdoReportVersion1.Checked && rdoDate1.Checked) ?800:650);

        BindDataToGrid();
        
    }
    
    #endregion

    #region Ajax Function To Delete The Excel Files

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\Common\\ExcelUploads"));

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
