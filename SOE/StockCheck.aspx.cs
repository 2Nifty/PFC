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
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.Enums;



public partial class StockCheck : System.Web.UI.Page
{
    Utility utility = new Utility();
    CustomerStockCheck check = new CustomerStockCheck();

    string invalidMessage = "Invalid Item Number";
    string noRecordMessage = "No Records Found";
    string queryMessage = "Query Completed Successfully";

    string itemNo = "";
    string loc = "";
    string chkLocation = "";
    string whereClause = "";
    protected void Page_Load(object sender, EventArgs e)
    {
         // Register AJAX
         Ajax.Utility.RegisterTypeForAjax(typeof(StockCheck));

        if (!IsPostBack)
        {
            txtItemNumber.Text = Request.QueryString["ItemNumber"].ToString();
            ddlLocation.SelectedValue = Request.QueryString["ShipLoc"].ToString();
            BindLocations();

            whereClause = "ItemNo='" + txtItemNumber.Text + "' and Location='" + ddlLocation.SelectedItem.Value.ToString() + "' group by ItemNo,Location,CurPeriodNo";
            ViewState["whereClause"] = whereClause.ToString();
            ddlLocation.SelectedIndex = -1;
            ListItem lstItem = ddlLocation.Items.FindByValue(Request.QueryString["ShipLoc"].ToString().Trim()) as ListItem;
            if (lstItem != null)
                lstItem.Selected = true;
            BindLabels();
           
        }
       
        upnlLocationGrid.Update();
        upnlStockGrid.Update();
        upnlVendor.Update();
        upnlStock.Update();
       
    }
    private void BindLocations()
    {
        utility.BindListControls(ddlLocation, "Name", "Code", check.GetLocationName(), "-- Select Location --");
    }

    private void BindStockGrid( string whereClause)
    {
        //itemNo = txtItemNumber.Text.ToString();
        //loc = ddlLocation.SelectedItem.Value.ToString();

        DataTable dtStock = check.GetStockGrid(whereClause );
        if (dtStock != null && dtStock.Rows.Count > 0)
        {
            dtStock.DefaultView.Sort = (hidSortStockGrid.Value == "") ? "Location desc " : hidSortStockGrid.Value;
           
            gvStock.DataSource = dtStock;
            gvStock.DataBind();
        }

    }

    private void BindLocationGrid()
    {
        chkSelection.Items.Clear();
        itemNo = txtItemNumber.Text.ToString();
        int count = 0;
        DataTable dtLoc = check.GetLocationGrid(itemNo);

        if (dtLoc != null && dtLoc.Rows.Count > 0)
        {
            count = dtLoc.Rows.Count;
                  
        for (int i = 0; i < count; i++)
        {
            ListItem lst = new ListItem();
            //lst.Value = i.ToString();
            //lst.Text = "Item" + i.ToString();
            chkSelection.Items.Add(lst);//CheckBox Id

        }
        chkSelection.DataSource = dtLoc;
        chkSelection.DataTextField = "Location";
        chkSelection.DataValueField = "LocID";
        chkSelection.DataBind();

        }
        
        //ListItem lstItem = ddlLocation.Items.FindByValue(Request.QueryString["ShipLoc"].ToString().Trim()) as ListItem;
            
        foreach (ListItem item in ((CheckBoxList)Form.FindControl("chkSelection")).Items)
        {
            if (ddlLocation.SelectedValue.Trim()==item.Value.Trim())
            {
                item.Selected = true;
            }
        }
        upnlLocationGrid.Update();

    }
    private void BindLabels()
    {
        itemNo = txtItemNumber.Text.ToString();
        loc = ddlLocation.SelectedItem.Value.ToString();

        DataTable dtStock = check.GetStock(itemNo, loc);
        if (dtStock != null && dtStock.Rows.Count > 0)
        {
            //Item Master Labels
          lblItem.Text= dtStock.Rows[0]["ItemNo"].ToString();
          lblDesc.Text = dtStock.Rows[0]["ItemDesc"].ToString();
           lblVendor.Text = ""; 
            
            // Velocity Labels
            lblMoAvGSales.Text = "";
            lblReplaceCost.Text = "";
            lblCat.Text = "";
            lblCurUsage.Text = "";
            lblDD.Text = "";
            lblCorp.Text = "";
            lblLastMoUsage.Text = "";
            lblLT.Text = "";
            lblSales.Text = "";
            lblBuyer.Text = "";

            //ItemBranch Labels

            lblSellUM.Text = dtStock.Rows[0]["SellUM"].ToString();
            lblCostUM.Text = dtStock.Rows[0]["CostUOM"].ToString();
            lblOAQ.Text = dtStock.Rows[0]["OAQ"].ToString();
            lblEDQ.Text = dtStock.Rows[0]["EOQ"].ToString();
            lblPrice.Text = "";
            lblStdCost.Text = dtStock.Rows[0]["StdCost"].ToString();
            lblMstrCtrn.Text = "";
            lblMOQ.Text = dtStock.Rows[0]["MOQ"].ToString();
            lblOPQ.Text = dtStock.Rows[0]["OPQ"].ToString();
            lblSellBasis.Text = dtStock.Rows[0]["SellBasis"].ToString();
            lblCostBasis.Text = dtStock.Rows[0]["CostBasis"].ToString();
            lblOPQ.Text = dtStock.Rows[0]["OPQ"].ToString();
            lblBrkPt.Text = dtStock.Rows[0]["Breakpoint"].ToString();
            lblPlanner.Text = dtStock.Rows[0]["Planner"].ToString();
            lblORRevDt.Text = dtStock.Rows[0]["ORRevDt"].ToString();

            BindLocationGrid();
            BindStockGrid(ViewState["whereClause"].ToString());

            if (IsPostBack)
            {
                txtItemNumber.Text = "";
               // ddlLocation.ClearSelection();
                utility.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
                upMessage.Update();
            }
          
            PrintDialogue1.CustomerNo = txtItemNumber.Text;
            PrintDialogue1.PageTitle = "Customer Stock Check for  " + txtItemNumber.Text;
            string TempUrl = "StockCheckExport.aspx?ItemNo=" + txtItemNumber.Text + "&ShipLoc=" + ddlLocation.SelectedValue.ToString();
            PrintDialogue1.PageUrl = Server.UrlEncode(TempUrl);

            utility.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
            upMessage.Update();
        }

        else
        {
            utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
            upMessage.Update();
            ClearControl();
        }
        upnlLocationGrid.Update();
        upnlStockGrid.Update();
        upnlVendor.Update();
        upnlStock.Update();
    }

    private void ClearControl()
    {
        lblItem.Text = lblDesc.Text = lblVendor.Text = ""; 
        lblMoAvGSales.Text= lblReplaceCost.Text = "";
        lblCat.Text= lblCurUsage.Text= lblDD.Text= lblCorp.Text = "";
        lblLastMoUsage.Text= lblLT.Text= lblSales.Text= lblBuyer.Text = "";
        lblSellUM.Text =lblCostUM.Text = lblOAQ.Text=lblEDQ.Text = "";
        lblPrice.Text =lblStdCost.Text =lblMstrCtrn.Text =lblMOQ.Text = "";
        lblOPQ.Text =lblSellBasis.Text=lblCostBasis.Text= lblOPQ.Text ="";
        lblBrkPt.Text = lblPlanner.Text = lblORRevDt.Text = "";

        foreach (ListItem li in chkSelection.Items)
        {
            li.Selected = false;
        }
        gvStock.DataSource = "";
        gvStock.DataBind();
        chkSelection.Items.Clear();

    }
     [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetPFCItemNumbers(string itemNo)
    {
        try
        {
            //DataTable dtItemNo = new DataTable();
            string tableName = "ItemMaster";
            string columnName = "Top 100 ItemNo"; //Contract No,Form Dist,
            string whereClause = "ItemNo Like '" + itemNo.Trim() + "'";
            //string whereClause = "ItemNo Like '00050%'";
            string detail = "";

            
            
            DataSet dsItemNumber = check.ExecuteSelectQuery(tableName, columnName, whereClause);

            if (dsItemNumber != null && dsItemNumber.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in dsItemNumber.Tables[0].Rows)
                    detail = detail + "`" + dr["ItemNo"].ToString().Trim() ;

                if (detail != "")
                    detail = detail.Remove(0, 1);

                return detail;
            }
            else

                return "";            

        }
        catch (Exception ex)
        {
            return "";
        }
    }
    protected void GetItemLabelValues()
    {
        string iNo = (hidItemNumber.Value == "" ? txtItemNumber.Text.Trim().ToString() : hidItemNumber.Value);

        whereClause = "ItemNo='" + iNo + "' and Location='" + ddlLocation.SelectedItem.Value.ToString() + "' group by ItemNo,Location,CurPeriodNo";
        ViewState["whereClause"] = whereClause.ToString();
        if (iNo != "")
        {
            DataTable dtItemNo = check.ValidateItemNumber(iNo);
            if (dtItemNo != null && dtItemNo.Rows.Count > 0)
            {
                BindLabels();
                
            }
            else
            {
                ClearControl();
                utility.DisplayMessage(MessageType.Failure, invalidMessage, lblMessage);
                upMessage.Update();
            }
        }
        else
        {
            ClearControl();
            utility.DisplayMessage(MessageType.Failure, invalidMessage, lblMessage);
            upMessage.Update();
        }
        upnlLocationGrid.Update();
        upnlStockGrid.Update();
        upnlVendor.Update();
        upnlStock.Update();
       


    }

    protected void btnLoadItem_Click(object sender, EventArgs e)
    {
       // ClearControl();
        GetItemLabelValues();
       // txtItemNumber.Text = "";
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelectAll.Checked == true)
            foreach (ListItem li in chkSelection.Items)
            {
                li.Selected = true;
               
            }
        else
            foreach (ListItem li in chkSelection.Items)
            {
                li.Selected = false;
            }
        BindGrid();
        upnlStockGrid.Update();
        upnlLocationGrid.Update();

    }
  
    protected void chkSelection_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid(); 
    }
    private void BindGrid()
    {
       
        foreach (ListItem item in ((CheckBoxList)Form.FindControl("chkSelection")).Items)
        {
            if (item.Selected)
            {
            
             chkLocation += item.Value + ",";

            }
        }
        if (chkLocation.Length > 0)
        {
            string loc = chkLocation.Remove(chkLocation.Length - 2);

            whereClause = "ItemNo='" + lblItem.Text + "' and Location in (" + loc + ") group by ItemNo,Location,CurPeriodNo";
            ViewState["whereClause"] = whereClause.ToString();
            BindStockGrid(whereClause);
        }
        else 
        {
            gvStock.DataSource = "";
            gvStock.DataBind();

        }

    }
    protected void gvStock_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (hidSortStockGrid.Attributes["sortType"] != null)
        {
            if (hidSortStockGrid.Attributes["sortType"].ToString() == "ASC")
                hidSortStockGrid.Attributes["sortType"] = "DESC";
            else
                hidSortStockGrid.Attributes["sortType"] = "ASC";
        }
        else
            hidSortStockGrid.Attributes.Add("sortType", "ASC");

        hidSortStockGrid.Value = e.SortExpression + " " + hidSortStockGrid.Attributes["sortType"].ToString();
        BindStockGrid(ViewState["whereClause"].ToString());

    }
}


