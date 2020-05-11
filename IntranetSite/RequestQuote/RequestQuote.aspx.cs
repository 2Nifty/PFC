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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
public partial class ReqQuote : System.Web.UI.Page
{
    RequestQuote requestQuote = new RequestQuote();
    protected string SearchBarCaption = "--All--,Customer Name,Customer,User Name,RFQ ID #,Cust Ref #,RFQ Method,Date Submitted,Date Completed,PFS Sales Rep";
    protected string valueColumnNamesForSearchBar = "--All--,CustomerName,CustomerNumber,AdministratorEmailID,SessionID,CustRefNo,SystemName,QuotationDate,RFQCompleteDt,PFCSalesRep";
    private string columndatatype = "varchar,varchar,varchar,varchar,int,int,varchar,datetime,datetime,varchar";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFind.Enabled = false;
            lblMsg.Visible = false;
            dgRequestQuote.Visible = true;
            Pager1.Visible = true;
            BindDropDownLocation();

            if (Request.QueryString["BranchID"] != null && Request.QueryString["BranchID"].ToString() != "")
                SelectItem(ddlBranch, Request.QueryString["BranchID"].ToString());
            
            BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
            AddColumn(SearchBarCaption, valueColumnNamesForSearchBar, ',', columndatatype);

            
        }
    }
    
    protected void BindDropDownLocation()
    {
        
        string WhereCondition = "LocType='B'";
        string ColNames = "LocID+ ' - '+ LocName as LocName,LocID";
        string tableName = "LocMaster";
        DataTable dtLocation = requestQuote.GetLocation(WhereCondition, ColNames, tableName);
        ddlBranch.DataSource = dtLocation;
        ddlBranch.DataTextField = "LocName";
        ddlBranch.DataValueField = "LocID";
        ddlBranch.DataBind();
    }

    public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource, string defaultValue)
    {
        try
        {
            if (dtSource != null && dtSource.Rows.Count > 0)
            {
                lstControl.DataSource = dtSource;
                lstControl.DataTextField = textField;
                lstControl.DataValueField = valueField;
                lstControl.DataBind();
                lstControl.Items.Insert(0, new ListItem(defaultValue, ""));


            }
            else
            {
                if (lstControl.ID.IndexOf("lst") == -1)
                {
                    lstControl.Items.Clear();
                    lstControl.Items.Insert(0, new ListItem("N/A", ""));
                }

            }
        }
        catch (Exception ex) { throw ex; }
    }
    
    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
        {
            ddlControl.SelectedValue = value.Trim();
            for (int i = 0; i <= ddlControl.Items.Count - 1; i++)
            {
                if (ddlControl.Items[i].Value.Trim() == value.Trim())
                    ddlControl.Items[i].Selected = true;
            }
        }
        else
            ddlControl.ClearSelection();
    }
    
    protected void BindDatagrid(string where)
    {
        lblMsg.Visible = false;
        dgRequestQuote.Visible = true;
        Pager1.Visible = true;

        DataTable dtRequestQuote = requestQuote.GetRequestQuote(where);
        if (dtRequestQuote.Rows.Count > 0)
        {
            dtRequestQuote.DefaultView.Sort = (hidSort.Value == "") ? "SessionID desc" : hidSort.Value;
            dgRequestQuote.DataSource = dtRequestQuote.DefaultView.ToTable();

            if (dtRequestQuote.Rows.Count >=15)
            {
                Pager1.InitPager(dgRequestQuote,15);                
            }
            else
            {
                Pager1.InitPager(dgRequestQuote, dtRequestQuote.Rows.Count);
                Pager1.Visible = false;               
            }

        }
        else
        {

            lblMsg.Visible = true;
            dgRequestQuote.Visible = false;
            Pager1.Visible = false;
        }

        upnlQuote.Update();
    }
    
    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
        txtFind.Text = "";
        ddlSearch.SelectedIndex = 0;
    }
    
    protected void dgRequestQuote_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        dgRequestQuote.CurrentPageIndex = e.NewPageIndex;
        BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgRequestQuote.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
    }
    
    public void AddColumn(string columnName, string columnNameToDisplay, char seperator, string datatype)
    {
        ViewState["datatype"] = datatype;
        string[] columnNamesList = columnName.Split(seperator);
        string[] displayValuesList = columnNameToDisplay.Split(seperator);
        AddColumn(columnNamesList, displayValuesList);

    }

    public void AddColumn(string[] columnNamesList, string[] displayValuesList)
    {

        if (columnNamesList.Length == displayValuesList.Length)
        {
            for (int i = 0; i < columnNamesList.Length; i++)
            {
                ddlSearch.Items.Add(new ListItem(columnNamesList[i],displayValuesList[i]));
            }

        }
    }
    
    protected void GetSearchText()
    {
        if (ddlSearch.SelectedItem.Text == "-ALL-")
            BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
        else if (txtFind.Text == "")
            BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
        else
            GetQuery();

    }

    protected void GetQuery()
    {


        string where = ddlSearch.SelectedValue + " like '%" + txtFind.Text + "%' and SalesLocationCode='" + ddlBranch.SelectedValue + "'";
        BindDatagrid(where);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetSearchText();
    }
    
    protected void ddlSearch_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSearch.SelectedIndex == 0)
        {
            txtFind.Enabled = false;
            txtFind.Text = "";
            
        }
        else
            txtFind.Enabled = true;
        txtFind.Text = "";
        BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
    }
    
    protected void dgRequestQuote_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        BindDatagrid("SalesLocationCode='" + ddlBranch.SelectedValue + "'");
    }
    
    protected void dgRequestQuote_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item))
        {


            HyperLink lnkEdit = e.Item.FindControl("lnkEdit") as HyperLink;
            Label lblSalesRef = e.Item.FindControl("lblSalesRef") as Label;
             Label lblCustRef = e.Item.FindControl("lblCustRef") as Label;
            Label lblCompletedDate = e.Item.FindControl("lblCompletedDate") as Label;
            Label lblRFQ = e.Item.FindControl("lblRFQ") as Label;
            Label lblCust = e.Item.FindControl("lblCust") as Label;
            HiddenField hidQuoteNo = e.Item.FindControl("hidQuoteNo") as HiddenField;
            if (lblCompletedDate.Text == "")
            {
                lnkEdit.Text = "Edit";
                lnkEdit.NavigateUrl = "QuoteEdit.aspx?SalesRep=" + lblSalesRef.Text.ToString() + "&CustRefNo=" + lblCustRef.Text.ToString() + "&RFQID=" + lblRFQ.Text.ToString() + "&Status=Edit&CustNo=" + lblCust.Text.ToString();
                // lnkEdit.Attributes.Add("onclick", "javascript:window.location.href='QuoteEdit.aspx?SalesRep=" + lblSalesRef.Text.ToString()+ "&CustRefNo=" + lblCustRef.Text.ToString() + "&RFQID=" + lblRFQ.Text.ToString() + "&Status=Edit&CustNo=" + lblCust.Text.ToString() + "';");
            }
            else
            {
                lnkEdit.Text = "Closed";
                lnkEdit.NavigateUrl = "QuoteEdit.aspx?SalesRep=" + lblSalesRef.Text.ToString() + "&CustRefNo=" + lblCustRef.Text.ToString() + "&RFQID=" + lblRFQ.Text.ToString() + "&Status=Closed&CustNo=" + lblCust.Text.ToString() ;
                // lnkEdit.Attributes.Add("onclick", "javascript:window.location.href='QuoteEdit.aspx?SalesRep=" + lblSalesRef.Text.ToString() + "&CustRefNo=" + lblCustRef.Text.ToString() + "&RFQID=" + lblRFQ.Text.ToString() + "&Status=Closed&CustNo=" + lblCust.Text.ToString() + "';");
            }
        }
    }
}
