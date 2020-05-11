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
using System.Threading;
using System.IO;
using System.Reflection;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.MnthlyPrchasingBdgt;

#endregion

public partial class MonthlyPurchasingFactorMaint : System.Web.UI.Page
{
    #region Global Variables

    private DataTable dtTotal = new DataTable();
    private DataSet dsPurchFactor = new DataSet();
    private string keyColumn = "GrpNoSort";
    private string sortExpression = string.Empty;
    private string checkCommand = string.Empty;
    protected string strStatus = string.Empty;
    int checkRecords = 20;
    int pagesize = 20;
    int begGroup;
    int endGroup;
    decimal newFactor;
    protected MnthlyPrchasingBdgt MnthlyPrchasingBdgtData = new MnthlyPrchasingBdgt();

    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(MonthlyPurchasingFactorMaint));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");

        hidFileName.Value = "MonthlyPurchasingFactor" + Session["SessionID"].ToString() + name + ".xls";
        strStatus = Request.QueryString["status"];
        lblMenuName.Text = "Monthly Purchasing Factor Maintenance";

        if (!IsPostBack)
        {
            BindDataGrid();
            BindDropDown(ddlBegGroup);
            BindDropDown(ddlEndGroup);
        }
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);
        dsPurchFactor = MnthlyPrchasingBdgtData.GetAllFactors();
        dtTotal = dsPurchFactor.Tables[0];
        dtTotal.DefaultView.Sort = sortExpression;
        dtTotal = dsPurchFactor.Tables[0].DefaultView.ToTable();
        if (dtTotal.Rows.Count > 0)
        {
            dgPurchFactor.DataSource = dtTotal;
            dgPurchFactor.DataBind();
            Pager1.InitPager(dgPurchFactor, pagesize);
            Pager1.Visible = true;

        }
        else
            Pager1.Visible = false;
        lblStatus.Text = "No Records Found";
        lblStatus.Visible = (dgPurchFactor.Items.Count < 1) ? true : false;
    }

    private void BindDropDown(DropDownList ddlFormFieldDtl)
    {
        try
        {
            dsPurchFactor = MnthlyPrchasingBdgtData.GetAllGroups();
            if (dsPurchFactor.Tables[0].Rows.Count > 0)
            {
                ddlFormFieldDtl.DataSource = dsPurchFactor.Tables[0];
                ddlFormFieldDtl.DataTextField = "GroupGlued";
                ddlFormFieldDtl.DataValueField = "GroupNo";
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

    protected void ibtnAdd_Click(object sender, ImageClickEventArgs e)
    {
        if (CheckInput("Add"))
        {
            dsPurchFactor = MnthlyPrchasingBdgtData.WorkFactors("AddRange", ddlBegGroup.Text, ddlEndGroup.Text, "", FactorTextBox.Text,
                Session["UserName"].ToString());
            lblCheckMessage.Text = "Records Added";
            BindDataGrid();
        }
    }

    protected void ibtnChange_Click(object sender, ImageClickEventArgs e)
    {
        if (CheckInput("Update"))
        {
            dsPurchFactor = MnthlyPrchasingBdgtData.WorkFactors("UpdateRange", ddlBegGroup.Text, ddlEndGroup.Text, "", FactorTextBox.Text,
                Session["UserName"].ToString());
            lblCheckMessage.Text = "Records Updated";
            BindDataGrid();
        }
    }

    protected void ibtnDelete_Click(object sender, ImageClickEventArgs e)
    {
        if (CheckInput("Delete"))
        {
            dsPurchFactor = MnthlyPrchasingBdgtData.WorkFactors("DeleteRange", ddlBegGroup.Text, ddlEndGroup.Text, "", FactorTextBox.Text,
                Session["UserName"].ToString());
            lblCheckMessage.Text = "Record Deleted";
            BindDataGrid();
        }
    }

    private bool CheckInput(string Action)
    {
        lblCheckMessage.Text = "";
        lblCheckMessage.ForeColor = System.Drawing.Color.Red;
        if (!int.TryParse(ddlBegGroup.Text, out begGroup))
        {
            lblCheckMessage.Text = "Beginning range is required and must be numeric";
            return false;
        }
        if (ddlEndGroup.Text.Trim().Length > 0)
        {
            if (!int.TryParse(ddlEndGroup.Text, out endGroup))
            {
                lblCheckMessage.Text = "Ending range must be numeric";
                return false;
            }
            else
            {
                if (begGroup > endGroup)
                {
                    lblCheckMessage.Text = "Ending range must larger than beginning range.";
                    return false;
                }

            }
        }
        if ((Action != "Delete") && (!decimal.TryParse(FactorTextBox.Text, out newFactor)))
        {
            lblCheckMessage.Text = "Factor is required and must be numeric";
            return false;
        }
        checkCommand = Action + "CheckRange";
        dsPurchFactor = MnthlyPrchasingBdgtData.WorkFactors(checkCommand, ddlBegGroup.Text, ddlEndGroup.Text, "", "", "");
        if ((dsPurchFactor == null) || (dsPurchFactor.Tables[0].Rows.Count == 0))
        {
            lblCheckMessage.Text = "There are no Groups/Factors in this range to " + Action;
            return false;
        }
        lblCheckMessage.ForeColor = System.Drawing.Color.Green;
        return true;
    }
    #endregion

    #region Event

    protected void dgPurchFactor_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgPurchFactor.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void dgPurchFactor_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgPurchFactor.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    } 

    #endregion     

    #region Write to Excel

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);
        dsPurchFactor = MnthlyPrchasingBdgtData.GetAllFactors(); 
        dtTotal = dsPurchFactor.Tables[0].DefaultView.ToTable();
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='3' style='color:blue'>" + lblMenuName.Text + "</th></tr>";
        headerContent += "<tr><th align=center>Group</th><th >Factor</th><th>Description</th></tr>";
        foreach (DataRow roiReader in dtTotal.Rows)
        {
            excelContent += "<tr><td align=center>" + roiReader["GroupNo"].ToString() + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["CPRFactor"]) + "</td><td style='width:400px;'>" +
                 roiReader["GrpDesc"].ToString() + "</td></tr>";

        }

        reportWriter.WriteLine(headerContent + excelContent);
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
        /*
        */
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\DayInventoryReport\\Common\\ExcelUploads"));

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
