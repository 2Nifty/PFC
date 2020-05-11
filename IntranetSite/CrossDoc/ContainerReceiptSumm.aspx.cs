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
using PFC.Intranet.DataAccessLayer;

public partial class ContainerRcptSumm : System.Web.UI.Page
{
    //string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    ContainerReceiptData ReceiptData = new ContainerReceiptData();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    GridViewRow row;
    LinkButton RcptLink;
    HiddenField HiddenContainer;
    String LPNNumber;
    String LocNumber;
    DateTime LPNDate;
    DateTime XDocDate;
    LinkButton ContainerLink;
    DataView dv = new DataView();

    protected void Page_Init(object sender, EventArgs e)
    {
        //Session["FooterTitle"] = null;
        if (!IsPostBack)
        {
            EndDate.TodaysDate = DateTime.Today;
            EndDate.SelectedDate = EndDate.TodaysDate;
            BegDate.TodaysDate = DateTime.Today.AddDays(-7);
            BegDate.SelectedDate = BegDate.TodaysDate;
            SortHidden.Value = "ContainerNo";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(ContainerRcptSumm));
        PageFooter2.FooterTitle = "Warehouse Container Receiving";
        if (!IsPostBack)
        {
            Session["LPNRcptData"] = null;
            Session["FilteredRcptData"] = null;
            SearchUpdatePanel.Visible = false;
            DetailGridPanel.Visible = false;
            BottomPanel.Visible = false;
            pnlPager.Visible = false;
        }
        else
        {
            //ScriptManager.RegisterClientScriptBlock(this, typeof(ContainerRcptSumm), "", "FixHeader();", true);
        }
    }

    protected void SearchSubmit_Click(object sender, EventArgs e)
    {
        string FindContainer = LPNBeg.Text.ToString().Trim();
        string FindBOL = BOLBeg.Text.ToString().Trim();
        string FindLoc = LocationDropDownList.SelectedValue.ToString().Trim();
        if (FindContainer.Length == 0)
        {
            FindContainer = "%";
        }
        if (FindBOL.Length == 0)
        {
            FindBOL = "%";
        }
        if (FindLoc.Length == 0)
        {
            FindLoc = "%";
        }
        GetData();
    }

    protected void FindSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            lblErrorMessage.Text = "";
            MessageUpdatePanel.Update();
            string GridFilter = "";
            if (txtContainer.Text.ToString().Trim().Length > 0)
            {
                GridFilter = "LPNNo = '" + txtContainer.Text.ToString().Trim() + "'";
            }
            if (txtToLoc.Text.ToString().Trim().Length > 0)
            {
                if (GridFilter.Length > 0) GridFilter += " and ";
                GridFilter += "ToLocation = '" + txtToLoc.Text.ToString().Trim() + "'";
            }
            if (txtLPNDate.Text.ToString().Trim().Length > 0)
            {
                if (DateTime.TryParse(txtLPNDate.Text, out LPNDate))
                {
                    if (GridFilter.Length > 0) GridFilter += " and ";
                    GridFilter += "DateCreate = '" + txtLPNDate.Text.ToString().Trim() + "'";
                }
                else
                {
                    lblErrorMessage.Text = "LPN Date is invalid";
                    MessageUpdatePanel.Update();
                    return;
                }
            }
            if (txtStatus.Text.ToString().Trim().Length > 0)
            {
                if (GridFilter.Length > 0) GridFilter += " and ";
                GridFilter += "RcptStatus = '" + txtStatus.Text.ToString().Trim() + "'";
            }
            if (Session["LPNRcptData"] != null)
            {
                dv = new DataView((DataTable)Session["LPNRcptData"], GridFilter, SortHidden.Value, DataViewRowState.CurrentRows);
                dt = dv.ToTable();
                if ((dt != null) && (dt.Rows.Count > 0))
                {
                    RePage(dt);
                    Session["FilteredRcptData"] = dt;
                    BindPageDetails();
                }
                else
                {
                    lblErrorMessage.Text = "No Records Found.";
                    MessageUpdatePanel.Update();
                }
            }
            else
            {
                lblErrorMessage.Text = "No Records to Process.";
                MessageUpdatePanel.Update();
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "FindSubmit_Click Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void RefreshSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            lblErrorMessage.Text = "";
            MessageUpdatePanel.Update();
            string FindContainer = LPNBeg.Text.ToString().Trim();
            string FindBOL = BOLBeg.Text.ToString().Trim();
            string FindLoc = LocationDropDownList.SelectedValue.ToString().Trim();
            string GridFilter = "";
            if (FindContainer.Length == 0)
            {
                FindContainer = "%";
            }
            if (FindBOL.Length == 0)
            {
                FindBOL = "%";
            }
            if (FindLoc.Length == 0)
            {
                FindLoc = "%";
            }
            GetData();
            if (txtContainer.Text.ToString().Trim().Length > 0)
            {
                GridFilter = "LPNNo = '" + txtContainer.Text.ToString().Trim() + "'";
            }
            if (txtToLoc.Text.ToString().Trim().Length > 0)
            {
                if (GridFilter.Length > 0) GridFilter += " and ";
                GridFilter += "ToLocation = '" + txtToLoc.Text.ToString().Trim() + "'";
            }
            if (txtLPNDate.Text.ToString().Trim().Length > 0)
            {
                if (DateTime.TryParse(txtLPNDate.Text, out LPNDate))
                {
                    if (GridFilter.Length > 0) GridFilter += " and ";
                    GridFilter += "DateCreate = '" + txtLPNDate.Text.ToString().Trim() + "'";
                }
                else
                {
                    lblErrorMessage.Text = "LPN Date is invalid";
                    MessageUpdatePanel.Update();
                    return;
                }
            }
            if (txtStatus.Text.ToString().Trim().Length > 0)
            {
                if (GridFilter.Length > 0) GridFilter += " and ";
                GridFilter += "RcptStatus = '" + txtStatus.Text.ToString().Trim() + "'";
            }
            if (GridFilter.Length > 0)
            {
                dv = new DataView((DataTable)Session["LPNRcptData"], GridFilter, SortHidden.Value, DataViewRowState.CurrentRows);
                dt = dv.ToTable();
                if ((dt != null) && (dt.Rows.Count > 0))
                {
                    RePage(dt);
                    Session["FilteredRcptData"] = dt;
                    BindPageDetails();
                }
                else
                {
                    lblErrorMessage.Text = "No Records Found.";
                    MessageUpdatePanel.Update();
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "RefreshSubmit_Click Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void GridClose_Click(object sender, EventArgs e)
    {
        SelectorUpdatePanel.Visible = true;
        SearchUpdatePanel.Visible = false;
        DetailGridPanel.Visible = false;
        BottomPanel.Visible = false;
        pnlPager.Visible = false;
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "", "SetHeight();", true);
    }

    protected void GetData()
    {
        Session["FilteredRcptData"] = null;
        try
        {
            dt = null;
            lblErrorMessage.Text = "";
            MessageUpdatePanel.Update();
            // get the data.
            dt = CheckError(ReceiptData.SearchUnprocessed(LocationDropDownList.SelectedItem.Value.ToString().Trim()
                , LPNBeg.Text.ToString().Trim()
                , ""
                , BOLBeg.Text.ToString().Trim()
                , ""
                , BegDate.SelectedDate.ToShortDateString()
                , EndDate.SelectedDate.ToShortDateString()
            ));
            Session["LPNRcptData"] = dt;
            if ((dt != null) && (dt.Rows.Count > 0))
            {
                dt.Columns.Add("PageNo");
                RePage(dt);
                BindPageDetails();
                FindSubmit.Visible = true;
            }
            else
            {
                //lblErrorMessage.Text = "Error " + _ToLoc + ":" + _BegContainer + ":" + _EndContainer + ":"
                //     + _BegBOL + ":" + _EndBOL + ":"
                //     + BegDate.SelectedDate.ToShortDateString() + ":" + EndDate.SelectedDate.ToShortDateString();
                lblErrorMessage.Text = "No Records Found..";
                MessageUpdatePanel.Update();
                FindSubmit.Visible = false;
                XDocGridView.DataBind();
            }
            SearchUpdatePanel.Update();
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pContainerCrossDocForm Error " + e3.Message + ", " + e3.ToString();
            MessageUpdatePanel.Update();
        }
        DetailUpdatePanel.Update();
        SelectorUpdatePanel.Visible = false;
        SearchUpdatePanel.Visible = true;
        DetailGridPanel.Visible = true;
        pnlPager.Visible = true;
        BottomPanel.Visible = true;
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            // set the detail link
            row = e.Row;
            if (row.RowType == DataControlRowType.DataRow)
            {
                RcptLink = (LinkButton)row.Cells[1].Controls[1];
                // line formatting
                if ((row.Cells[5].Text.ToString().Trim() != "&nbsp;") && (row.Cells[5].Text.ToString().Trim() != Session["UserName"].ToString().Trim()))
                {
                    RcptLink.Enabled = false;
                }
                else
                {
                    // check in cross dock exists
                    HiddenContainer = (HiddenField)row.Cells[1].Controls[3];
                    LPNNumber = row.Cells[0].Text;
                    LocNumber = row.Cells[2].Text;
                    if (HiddenContainer.Value == "")
                    {
                        RcptLink.Text = "Receive LPN";
                    }
                    else
                    {
                        RcptLink.Text = "View Cross Dock";
                    }
                    string LinkCommand = "";
                    LinkCommand = "return ConfirmReceipt(this,'";
                    LinkCommand += LPNNumber + "','";
                    LinkCommand += LocNumber + "','";
                    LinkCommand += HiddenContainer.Value + "','";
                    LinkCommand += Server.UrlEncode("RBReceiving/RBReceiveReport.aspx?UserName=" + Session["UserName"].ToString() +
                        "&Branch=" + LocNumber + "&Container=" + LPNNumber) + "');";
                    ;
                    RcptLink.OnClientClick = LinkCommand;
                }
            }
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "DetailRowBound Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView 
            if (Session["FilteredRcptData"] == null)
            {
                dv = new DataView((DataTable)Session["LPNRcptData"]);
            }
            else
            {
                dv = new DataView((DataTable)Session["FilteredRcptData"]);
            }
            SortHidden.Value = e.SortExpression;
            dv.Sort = e.SortExpression;
            dt = dv.ToTable();
            RePage(dt);
            if (Session["FilteredRcptData"] == null)
            {
                Session["LPNRcptData"] = dt;
            }
            else
            {
                Session["FilteredRcptData"] = dt;
            }
            BindPageDetails();
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "Sort Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void DetailGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        XDocGridView.DataSource = (DataTable)Session["LPNRcptData"];
        XDocGridView.PageIndex = e.NewPageIndex;
        XDocGridView.DataBind();
        DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
        DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
    }

    #region Pager Functionality
    protected void ibtnFirst_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = 0;
        BindPageDetails();
    }

    protected void ibtnPrevious_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlPages.SelectedIndex == 0)
        { }
        else
        {
            ddlPages.SelectedIndex = ddlPages.SelectedIndex - 1;
            BindPageDetails();
        }
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlPages.SelectedIndex == ddlPages.Items.Count - 1)
        { }
        else
        {
            ddlPages.SelectedIndex = ddlPages.SelectedIndex + 1;
            BindPageDetails();
        }
    }

    protected void btnLast_Click(object sender, ImageClickEventArgs e)
    {
        ddlPages.SelectedIndex = ddlPages.Items.Count - 1;
        BindPageDetails();
    }

    protected void btnGo_Click(object sender, ImageClickEventArgs e)
    {
        if (Convert.ToInt32(txtGotoPage.Text.Trim()) >= 1 && Convert.ToInt32(txtGotoPage.Text.Trim()) <= ddlPages.Items.Count)
        {
            ddlPages.SelectedIndex = Convert.ToInt32(txtGotoPage.Text.Trim()) - 1;
            BindPageDetails();
        }
        else
        {
            lblErrorMessage.ForeColor = System.Drawing.Color.FromName("#CC0000");
            lblErrorMessage.Text = "Invalid Page #";
            MessageUpdatePanel.Update();
        }

        ScriptManager.RegisterClientScriptBlock(btnGo, typeof(Button), "", "SetHeight();", true);
    }

    protected void ddlPages_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindPageDetails();
        ScriptManager.RegisterClientScriptBlock(ddlPages, typeof(ListBox), "", "SetHeight();", true);
    }

    public void RePage(DataTable GridData)
    {
        DataTable dtPage = new DataTable();
        dtPage.Columns.Add("Id");
        dtPage.Columns.Add("PageNo");
        int PageNo = 1;
        for (int i = 0; i < GridData.Rows.Count; i++)
        {
            if (i % 22 == 0)
            {
                DataRow PagerRow = dtPage.NewRow();
                PagerRow["Id"] = (i + 1).ToString();
                PagerRow["PageNo"] = PageNo.ToString();
                dtPage.Rows.Add(PagerRow);
                PageNo++;
            }
            GridData.Rows[i]["PageNo"] = (PageNo - 1).ToString();
        }
        GridData.AcceptChanges();
        ddlPages.DataSource = dtPage;
        ddlPages.DataTextField = "PageNo";
        ddlPages.DataValueField = "Id";
        ddlPages.DataBind();
        ddlPages.SelectedIndex = 0;
    }

    public void BindPageDetails()
    {
        try
        {
            lblCurrentPageRecCount.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
            lblTotalNoOfRec.Text = " " + ddlPages.Items.Count.ToString();
            lblCurrentPage.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
            lblTotalPage.Text = " " + ddlPages.Items.Count.ToString();
            lblCurrentTotalRec.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
            pnlPager.Update();
            // see if page has been filtered
            if (Session["FilteredRcptData"] == null)
            {
                dv = new DataView((DataTable)Session["LPNRcptData"], "PageNo = " + (ddlPages.SelectedIndex + 1).ToString(),
                    SortHidden.Value, DataViewRowState.CurrentRows);
            }
            else
            {
                dv = new DataView((DataTable)Session["FilteredRcptData"], "PageNo = " + (ddlPages.SelectedIndex + 1).ToString(),
                   SortHidden.Value, DataViewRowState.CurrentRows);
            }
            XDocGridView.DataSource = dv;
            XDocGridView.DataBind();
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "BindPageDetails Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }
    #endregion

    public DataTable CheckError(DataTable NewData)
    {
        if ((NewData != null) && (NewData.Columns.Contains("ErrorType")))
        {
            lblErrorMessage.Text = NewData.Rows[0]["ErrorText"].ToString();
            MessageUpdatePanel.Update();
            return null;
        }
        else
        {
            return NewData;
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdDate(string LPN)
    {
        string status = LPN;
        try
        {
            // update the table in the session variable to show that the line is selected or not.
            DataTable dt = ReceiptData.UpdateLPNAudit(LPN, Session["UserName"].ToString());

            if (dt.Columns.Contains("ErrorType"))
            {
                status = "--Error -- " + dt.Rows[0]["ErrorText"].ToString();
            }
            else
            {
                DataTable tempDt = (DataTable)Session["LPNRcptData"];
                DataRow[] LPNRow = tempDt.Select("LPNNo = '" + LPN + "'");
                status = "OK";
                LPNRow[0]["RcptStatus"] = "Processed";
                Session["LPNRcptData"] = tempDt;
            }
        }
        catch (Exception e2)
        {
            status = "-- Error -- " + e2.ToString();
        }
        return status;
    }

}
