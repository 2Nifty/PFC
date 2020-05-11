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
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.BusinessLogicLayer;

public partial class PrintUtilityHistory : System.Web.UI.Page
{
    int pageSize = 15;

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(PrintUtilityHistory));
        lblMessage.Text = "";

        if(!IsPostBack)
        {
            lblCreatedBy.Text = Session["UserName"].ToString();
            dpStartDt.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
            dpEndDate.SelectedDate = DateTime.Now.ToShortDateString();
            BindGrid();
        }
    }

    private void BindGrid()
    {

        DataTable dtResponse = GetRequests();
        if (dtResponse != null && dtResponse.Rows.Count > 0)
        {
            if (hidSort.Value != "")
                dtResponse.DefaultView.Sort = hidSort.Value;

            gvRequest.DataSource = dtResponse.DefaultView.ToTable();
            RequestQueuePager.InitPager(gvRequest, pageSize);
            //gvRequest.DataBind();
        }
        else 
        {
            gvRequest.DataSource = null;            
            gvRequest.DataBind();

            lblMessage.Text = "No Records Found";
        }
        pnlRequestGrid.Update();
        pnlMessage.Update();
    }
      
    protected void gvRequest_Sorting(object sender, GridViewSortEventArgs e)
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

        BindGrid();
    }

    private DataTable GetRequests()
    {
        try
        {
            DataSet dsResponse = SqlHelper.ExecuteDataset(Global.PFCUmbrellaConnectionString, "[pFindPostRequests]",
                                    new SqlParameter("@recordType", (ddlRecordType.SelectedValue.ToLower() == "all" ? "" : ddlRecordType.SelectedValue)),
                                    new SqlParameter ("@userName",Session["UserName"].ToString() ),
                                    new SqlParameter ("@startDt",dpStartDt.SelectedDate ),
                                    new SqlParameter ("@endDt",dpEndDate.SelectedDate ));
            if (dsResponse == null)
                return null;

            return dsResponse.Tables[0];
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void ibtnSearch_Click(object sender, ImageClickEventArgs e)
    {
        BindGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvRequest.PageIndex = RequestQueuePager.GotoPageNumber;
        BindGrid();
    }

    protected void gvRequest_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //e.Row.Cells[0].CssClass = "locked";
        //e.Row.Cells[1].CssClass = "locked";
        //e.Row.Cells[2].CssClass = "locked";
        //e.Row.Cells[3].CssClass = "locked";
        //e.Row.Cells[4].CssClass = "locked";

        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            HiddenField _hidProcessCd = e.Row.FindControl("hidProcessCd") as HiddenField;
            HiddenField _hidMultiDocPrint = e.Row.FindControl("hidMutiDocPrint") as HiddenField;
            HyperLink _hlnkViewDoc = e.Row.FindControl("hlnkViewDoc") as HyperLink;

            System.Drawing.Color cellColor = new System.Drawing.Color();

            // For Status Color
            if (_hidProcessCd.Value.ToUpper() == "F")
                cellColor = System.Drawing.Color.Red;
            else if (_hidProcessCd.Value.ToUpper() == "S")
                cellColor = System.Drawing.Color.Green;
            else 
                cellColor = System.Drawing.Color.Blue;

            e.Row.Cells[1].ForeColor = cellColor;

            // For Sent To Text
            if (e.Row.Cells[5].Text.Length > 40)
            {
                e.Row.Cells[5].ToolTip = e.Row.Cells[5].Text;
                e.Row.Cells[5].Text = e.Row.Cells[5].Text.Substring(0, 30) + "...";
            }

            // For Body Text
            if (e.Row.Cells[7].Text.Length > 40)
            {
                e.Row.Cells[7].ToolTip = e.Row.Cells[7].Text;
                e.Row.Cells[7].Text = e.Row.Cells[7].Text.Substring(0, 30) + "...";
            }
            
            // For Document Link
            if (_hidMultiDocPrint.Value.ToLower() == "true")
            {
                _hlnkViewDoc.Enabled = false;
                _hlnkViewDoc.ToolTip = "This feature is unavailable for multiple document printing.";
            }
            
        }
    }
}
