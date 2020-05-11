using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.Threading;
using System.Reflection;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using PFC.Intranet;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.MaintenanceApps;
using Novantus.Umbrella.Utils;

public partial class ItemAliasMaint : System.Web.UI.Page
{
    string cnxERP = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    string _cmdText, strSQL;

    MaintenanceUtility MaintUtil = new MaintenanceUtility();
    PhysicalInventoryAdjustment verifyItem = new PhysicalInventoryAdjustment();
    
    DataSet dsItemAlias = new DataSet();
    DataTable dtItemAlias = new DataTable();
    DataTable dtItemNo;
    SqlDataReader drItemAlias;   
    
    #region PageLoad
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            smItemAlias.SetFocus(txtSearchCustNo);
            BindDropDown(ddlAliasType, "ItemAliasTypes");            
            Session["ItemAliasRecID"] = "";

            //Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");
            //Session["UserID"] = ((Session["UserID"] != null) ? Session["UserID"].ToString() : "01");
            //Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "intranet");

            lblItemNo.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
            upnlEdit.Update();
            UpdatePanels();
            
        }
    }

    //[TMD] you need to just call this method from whichever class file you stole it from = CVCAdder.aspx.cs
    private void BindDropDown(DropDownList ddlFormFieldDtl, string listName)
    {
        try
        {
            string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='" + listName + "' Order by b.SequenceNo";
            string _tableName = "listmaster a,ListDetail b ";
            string _columnName = "b.ListValue as ListValue,b.ListValue +' - ' + b.ListDtlDesc as ListDtlDesc";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(cnxERP, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlFormFieldDtl.DataSource = dslist.Tables[0];
                ddlFormFieldDtl.DataTextField = "ListDtlDesc";
                ddlFormFieldDtl.DataValueField = "ListValue";
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
    #endregion

    #region User Input
    protected void txtSearchItemNo_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtSearchItemNo.Text.ToString()))
            smItemAlias.SetFocus(txtSearchCustNo);
    }

    protected void txtItemNo_TextChanged(object sender, EventArgs e)
    {
        
    }

    protected void txtAliasItemNo_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtAliasItemNo.Text.ToString()))
            smItemAlias.SetFocus(txtAliasDesc);
    }

    protected void txtAliasDesc_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtAliasDesc.Text.ToString()))
            smItemAlias.SetFocus(txtAliasWhseNo);
    }

    protected void txtAliasWhseNo_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtAliasWhseNo.Text.ToString()))
            smItemAlias.SetFocus(txtUOM);
    }

    protected void txtUOM_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtUOM.Text.ToString()))
            smItemAlias.SetFocus(txtOrganizationNo);
    }

    protected void txtOrganizationNo_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtOrganizationNo.Text.ToString()))
            smItemAlias.SetFocus(txtOrganizationNo);
    }
    #endregion

    #region Button Events
    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        if (string.IsNullOrEmpty(txtSearchCustNo.Text.ToString()) && (hidEditMode.Value != "Add" ))
        {           
            lblMessage.Text = "You must enter a Customer Number.";
            pnlUpdate.Update();
            smItemAlias.SetFocus(txtSearchCustNo);
            return;
        }
        
        BindDataGrid();
        ClearControls();
    }         

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        hidEditMode.Value = "Add";
        
        ClearControls();
        smItemAlias.SetFocus(txtItemNo); //Brings the focus to txtItemNo                 
        btnSave.Visible = true;
        btnCancel.Visible = true;
        txtOrganizationNo.Enabled = false;                           
        txtOrganizationNo.Text = txtSearchCustNo.Text.ToString();
        
        pnlBtnBanner.Update();
        upnlEdit.Update();        
    }
              
    
    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlAliasType.SelectedIndex == 0)
            DisplayStatusMessage("You must select a valid Alias type ", "fail");
            
        smItemAlias.SetFocus(ddlAliasType);
        
        if (hidEditMode.Value == "Edit")
        {
            UpdateItemAlias();
            ClearControls();
            DisplayStatusMessage("Item Alias Edit Record Updated", "success");
        }
        else
        {
            InsertItemAlias();
            ClearControls();
            DisplayStatusMessage("Item Alias Add Record Updated", "success");
        }
        
        BindDataGrid();
        UpdatePanels();
        smItemAlias.SetFocus(txtSearchCustNo);

    }
    
    private void InsertItemAlias()
    {
                           
            //strSQL = "SELECT * FROM ItemAlias WITH (NOLOCK) WHERE OrganizationNo = '" + txtOrganizationNo.Text.Trim() + "' AND AliasItemNo = '" + txtAliasItemNo.Text.Trim() + "' AND ItemNo='" + txtItemNo.Text.Trim() + "'";
            //drItemAlias = SqlHelper.ExecuteReader(cnxERP, CommandType.Text, strSQL);

            //if (drItemAlias.HasRows)
            //{
            _cmdText = "INSERT INTO ItemAlias " +
                     "            (ItemNo, " +
                     "             AliasItemNo, " +
                     "             AliasDesc, " +
                     "             AliasWhseNo, " +
                     "             AliasType, " +
                     "             UOM, " +
                     "             OrganizationNo, " +
                     "             EntryID, " +
                     "             EntryDt) " +
                     "    VALUES  ('" + txtItemNo.Text.ToString() + "', " +
                     "             '" + txtAliasItemNo.Text.ToString() + "', " +
                     "             '" + txtAliasDesc.Text.ToString() + "', " +
                     "             '" + txtAliasWhseNo.Text.ToString() + "', " +
                     "             '" + ddlAliasType.SelectedValue.ToString() + "', " +
                     "             '" + txtUOM.Text.ToString() + "', " +
                     "             '" + txtOrganizationNo.Text.ToString() + "', " +
                     "             '" + Session["UserName"].ToString().Trim() + "', " +
                     "             GETDATE())";
            SqlHelper.ExecuteReader(cnxERP, CommandType.Text, _cmdText);
            DisplayStatusMessage("Record Added", "success");
                      
       }        

    private void UpdateItemAlias()
    {
        strSQL = "SELECT * FROM ItemAlias WITH (NOLOCK) WHERE OrganizationNo = '" + txtOrganizationNo.Text.Trim() + "' AND AliasItemNo = '" + txtAliasItemNo.Text.Trim() + "' AND ItemNo='" + txtItemNo.Text.Trim() + "' AND AliasType = '" + ddlAliasType.SelectedValue.ToString() + "'";
        drItemAlias = SqlHelper.ExecuteReader(cnxERP, CommandType.Text, strSQL);

        if (drItemAlias.HasRows)
        {
            //cnxERP.Close();
            DisplayStatusMessage("Already on file", "fail");
        }
        else
        {

            //UPDATE the record
            _cmdText = "UPDATE  ItemAlias " +
                       "SET     ItemNo = '" + txtItemNo.Text.ToString().Trim() + "', " +
                       "        AliasItemNo = '" + txtAliasItemNo.Text.ToString().Trim() + "', " +
                       "        AliasDesc = '" + txtAliasDesc.Text.ToString().Trim() + "', " +
                       "        AliasWhseNo = '" + txtAliasWhseNo.Text.ToString().Trim() + "', " +
                       "        AliasType = '" + ddlAliasType.SelectedValue.ToString() + "', " +
                       "        UOM = '" + txtUOM.Text.ToString().Trim() + "', " +
                       "        OrganizationNo = '" + txtOrganizationNo.Text.ToString().Trim() + "', " +
                       "        ChangeID ='" + Session["UserName"].ToString().Trim() + "', " +
                       "        ChangeDt ='" + DateTime.Now + "'" +
                       "WHERE   pItemAliasID = " + hidItemAliasID.Value;
            SqlHelper.ExecuteNonQuery(cnxERP, CommandType.Text, _cmdText);
            DisplayStatusMessage("Item Alias Record Updated", "success");
            smItemAlias.SetFocus(txtItemNo);
        }
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        btnCancel.Visible = false;
        btnSave.Visible = false;

        ClearControls();            
        UpdatePanels();       
    }
    #endregion
    
    #region dgItemAlias

    protected void dgItemAlias_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        hidItemAliasID.Value = e.CommandArgument.ToString().Trim();

        if (e.CommandName == "Edit")
        {
            EnableControls(); 
            txtOrganizationNo.Enabled = false;            
            dtItemAlias = GetItemAliasEditRecords("pItemAliasID = '" + e.CommandArgument + "'");
            DisplayRecord();
            pnlAliasGrid.Update();
            btnSave.Visible = true;
            btnCancel.Visible = true;
            smItemAlias.SetFocus(txtItemNo);
            //DisplayStatusMessage("Now in " + e.CommandName.ToString().Trim() +" Mode ", "success");
        }

        if (e.CommandName == "Delete")
        {   
            _cmdText = "DELETE " +
                       "FROM ItemAlias " +
                       "WHERE pItemAliasID = " + e.CommandArgument; 
            SqlHelper.ExecuteReader(cnxERP, CommandType.Text, _cmdText);

            pnlAliasGrid.Update();                        
            btnSearch_Click(dgItemAliasGrid, new ImageClickEventArgs(0, 0)); 
            DisplayStatusMessage("Item Alias Record Deleted", "success");                             
        }

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('divdatagrid').scrollTop='" + hidScrollTop.Value + "';", true);

        UpdatePanels(); 
    }

    protected void BindDataGrid()
    {
        if (txtSearchCustNo.Text.ToString() == (txtOrganizationNo.Text.ToString()))    // keeps both grids if customer is requested again
        {
            dsItemAlias = SqlHelper.ExecuteDataset(cnxERP, CommandType.StoredProcedure, "[pMaintItemAlias]"
                                                    , new SqlParameter("@ItemNo", txtSearchItemNo.Text)
                                                    , new SqlParameter("@OrganizationNo", txtSearchCustNo.Text)); //See stored procedure to for code to allow null by case of LIKE statement

            dgItemAliasGrid.DataSource = dsItemAlias.Tables[0].DefaultView.ToTable();             
        }
        else 
        {             
            dsItemAlias = SqlHelper.ExecuteDataset(cnxERP, CommandType.StoredProcedure, "[pMaintItemAlias]"
                                                    , new SqlParameter("@ItemNo", txtSearchItemNo.Text)
                                                    , new SqlParameter("@OrganizationNo", txtSearchCustNo.Text)); //See stored procedure to for code to allow null by case of LIKE statement

            dgItemAliasGrid.DataSource = dsItemAlias.Tables[0].DefaultView.ToTable(); 
            
            ClearControls();
        }

        Pager1.InitPager(dgItemAliasGrid, 14);        
        divAliasGrid.Visible = true;    //make div visible since it is set as false in page  (grid)         
        pnlAliasGrid.Update();          //Refresh panels when clicking, all the time !  
       
    }

    protected void dgItemAlias_SortCommand(object source, DataGridSortCommandEventArgs e)
    {

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgItemAliasGrid.CurrentPageIndex = Pager1.GotoPageNumber;

        BindDataGrid();
    }

    #endregion

    #region Data Manipulation
    //[TMD] - Which one of these are you going to use?
    //You are currently using GetItemAliasEditRecords instead of GetItemNoCustNoTableData
    protected DataTable GetItemAliasEditRecords(string searchText)
    {
        try
        {
            string _whereClause = searchText;
            string _tableName = "ItemAlias";
            string _columnName = "*";

            dsItemAlias = SqlHelper.ExecuteDataset(cnxERP, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsItemAlias.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }     

    private void DisplayRecord()
    {
        hidEditMode.Value = "Edit";
        hidPrimaryKey.Value = dtItemAlias.Rows[0]["pItemAliasID"].ToString().Trim();
        MaintUtil.SetValueListControl(ddlAliasType, dtItemAlias.Rows[0]["AliasType"].ToString().Trim());       
        txtItemNo.Text = dtItemAlias.Rows[0]["ItemNo"].ToString().Trim();
        txtAliasItemNo.Text = dtItemAlias.Rows[0]["AliasItemNo"].ToString().Trim();
        txtAliasDesc.Text = dtItemAlias.Rows[0]["AliasDesc"].ToString().Trim();
        txtAliasWhseNo.Text = dtItemAlias.Rows[0]["AliasWhseNo"].ToString().Trim();
        txtUOM.Text = dtItemAlias.Rows[0]["UOM"].ToString().Trim();
        txtOrganizationNo.Text = dtItemAlias.Rows[0]["OrganizationNo"].ToString().Trim();

        lblEntryID.Text = dtItemAlias.Rows[0]["EntryID"].ToString().Trim();
        lblEntryDate.Text = (dtItemAlias.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dtItemAlias.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblChangeID.Text = dtItemAlias.Rows[0]["ChangeID"].ToString().Trim();
        lblChangeDate.Text = (dtItemAlias.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dtItemAlias.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
    }
    #endregion

    #region App Utilities & Security
    private void UpdatePanels()
    {
        //[TMD] you can prob put all of your panel update here and just call this method
        upnlEdit.Update();
        pnlUpdate.Update();
        pnlAliasGrid.Update();
        pnlBtnBanner.Update();
        upnlTop.Update();
    }

    private void ClearControls()
    {
        txtItemNo.Text = "";
        txtAliasItemNo.Text = "";
        ddlAliasType.SelectedIndex = 1;
        txtAliasDesc.Text = "";
        ddlAliasType.Text = "";
        txtAliasWhseNo.Text = "";
        txtUOM.Text = "";
        txtOrganizationNo.Text = "";
        lblEntryID.Text = "";
        lblEntryDate.Text = "";
        lblChangeID.Text = "";
        lblChangeDate.Text = "";
    }

    private void DisplayStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
    }

    #endregion

    private void ValidateItemNo()
    {
        dtItemNo = verifyItem.GetItemInformation(txtItemNo.Text.ToString());
        if (dtItemNo != null && dtItemNo.Rows.Count > 0)
        {
            //lblCatDesc.Text = dtItemNo.Rows[0]["CatDesc"].ToString();
            smItemAlias.SetFocus(txtAliasItemNo);
        }
        else
        {
            DisplayStatusMessage("Item Is Not Valid", "fail");
            //txtItemNo = "";
            smItemAlias.SetFocus(txtItemNo);
        }
    }
   
    private void DisableControls()
    {
        txtItemNo.Enabled = false;
        txtAliasItemNo.Enabled = false;
        txtAliasDesc.Enabled = false;
        txtAliasWhseNo.Enabled = false;
        txtUOM.Enabled = false;
        txtOrganizationNo.Enabled = false;
        ddlAliasType.Enabled = false;
    }

    private void EnableControls()
    {
        txtItemNo.Enabled = true;
        txtAliasItemNo.Enabled = true;
        txtAliasDesc.Enabled = true;
        txtAliasWhseNo.Enabled = true;
        txtUOM.Enabled = true;
        txtOrganizationNo.Enabled = true;
        ddlAliasType.Enabled = true;
    }
        
    protected void btnHidSearch_Click(object sender, EventArgs e)
    {
        //ValidateItemNo();
        DataTable dtItemNo = verifyItem.GetItemInformation(txtItemNo.Text.ToString());
        if ((dtItemNo != null && dtItemNo.Rows.Count > 0))
        {
            txtAliasItemNo.Enabled = true;
            txtAliasDesc.Enabled = true;
            txtAliasWhseNo.Enabled = true;
            txtUOM.Enabled = true;
            txtOrganizationNo.Enabled = true;
            ddlAliasType.Enabled = true;
            lblMessage.Text = "";
            Utility.SetSelectedValuesInListControl(ddlAliasType, "C");
            smItemAlias.SetFocus(txtAliasItemNo);
        }
        else
        {
            DisplayStatusMessage("Please enter a valid PFC item #", "fail");

            txtAliasItemNo.Enabled = false;
            txtAliasDesc.Enabled = false;
            txtAliasWhseNo.Enabled = false;
            txtUOM.Enabled = false;
            txtOrganizationNo.Enabled = false;
            ddlAliasType.Enabled = false;

            smItemAlias.SetFocus(txtItemNo);
        }

        UpdatePanels(); 
    }
}

