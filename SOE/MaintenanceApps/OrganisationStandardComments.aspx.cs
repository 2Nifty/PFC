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

using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class StandardComments : System.Web.UI.Page
{
    int count;
    OrgStandardComment standardComment;
    MaintenanceUtility utility ;
    private DataTable dtTablesData = new DataTable();

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string code = "";
    string connectionString = "";
    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
    protected string CommentSecurity
    {
        get
        {
            return Session["CommentSecurity"].ToString();            
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        standardComment = new OrgStandardComment();
        utility = new MaintenanceUtility();
        connectionString = PFC.Intranet.MaintenanceApps.MaintenanceUtility.GetConnectionString();
        ViewState["Operation"] = "";
        lblMessage.Text = "";
        lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
        //Session["UserName"] = "intranet";
    
        if (!Page.IsPostBack)
        {
            txtCustNo.Text = Request.QueryString["CustNumber"].ToString().Trim();
            code = txtCustNo.Text.ToString();
            Session["CommentSecurity"] = null;
            Session["CommentSecurity"] = utility.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.OrganisationComments);
          
            ViewState["Mode"] = "Add";
            btncheck();
            GetSearch();

        }
        code = txtCustNo.Text.ToString();

        if (CommentSecurity == "")
            EnableQueryMode();
     }
    
    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
       
        btnNext.Visible = (CommentSecurity == "") ? true : false;
        btnSave.Visible = (CommentSecurity == "") ? true : false;
        btnCancel.Visible = (CommentSecurity == "") ? true : false; 
        BindDataGrid();
        Clear();
        tdComment.Visible = true;
        upnlchkSelectAll.Visible = true;
        ViewState["Mode"] = "Add";
        btncheck1();
        tblDataEntry.Visible = true;
        //txtCustNo.Focus();
        UpdatePanels();
      //  ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "FocusControl", "document.getElementById('txtCode').focus();", true);
    }

    protected void btncheck()
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
            btnNext.Visible = false;
        }

        if (ViewState["Mode"].ToString() == "Edit")
        {
            btnNext.Visible = true;
            btnAdd.Visible = true;            
        }
        UpdatePanels();
        upnlButtons.Update();
       
    }

    protected void btncheck1()
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
            //btnDelete.Visible = false;
            btnNext.Visible = true;
            btnSave.Visible = true;
            btnCancel.Visible = true;
        }

        if (ViewState["Mode"].ToString() == "Edit")
        {
           // btnDelete.Visible = (CommentSecurity != "") ? true : false;

        }

        upnlButtons.Update();
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
        upnlchkSelectAll.Update();

    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        string CustNumber = txtCustNo.Text.Trim();
        string AlphaOrgNo = standardComment.CheckAlphaOrgNo("Cust",CustNumber);
        if (txtComment.Text== "")
        {
            ScriptManager.RegisterClientScriptBlock(btnSave, btnSave.GetType(), "required", "alert(' *  Marked fields are mandatory')", true);
        }
        else
        {
            try
            {
                if (ViewState["Mode"].ToString() == "Add")
                {
                    string columnName = "TableName,OrganizationNo,AlphaOrganizationNo,Comments,LineNumber,SOAppInd,POAppInd,EmailAppInd,EntryID,EntryDt";

                    string columnValue = "'Cust'," +
                                           "'" + CustNumber.Trim().Replace("'", "''") + "'," +                                          
                                           "'" + AlphaOrgNo.Trim().Replace("'", "''") + "'," +
                                           "'" + txtComment.Text.Trim().Replace("'", "''") + "'," +
                                           "'" + txtLine.Text.Trim().Replace("'", "''") + "'," +
                                           "'" + ((chkSelection.Items[0].Selected == true) ? "Y" : "") + "'," +
                                           "'" + ((chkSelection.Items[1].Selected == true) ? "Y" : "") + "'," +
                                           "'" + ((chkSelection.Items[2].Selected == true) ? "Y" : "") + "'," +
                                           "'" + Session["UserName"] + "'," +
                                           "'" + DateTime.Now.ToShortDateString() + "'";

                    standardComment.InsertTables(columnName, columnValue);
                    DisplaStatusMessage(updateMessage, "Success");
                }
                else
                {
                    string pOrgStdCommentID = hidpOrgStdComID.Value;
                    string updateValue = "Comments='" + txtComment.Text.Trim().Replace("'", "''") + "'," +
                                            "LineNumber='" + txtLine.Text.Trim().Replace("'", "''") + "'," +
                                            "SOAppInd='" + ((chkSelection.Items[0].Selected == true) ? "Y" : "") + "'," +
                                            "POAppInd='" + ((chkSelection.Items[1].Selected == true) ? "Y" : "") + "'," +
                                            "EmailAppInd='" + ((chkSelection.Items[2].Selected == true) ? "Y" : "") + "'," +
                                            "ChangeID='" + Session["UserName"].ToString() + "'," +
                                            "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                    standardComment.UpdateTables(updateValue, "pOrgStdCommentsID=" + pOrgStdCommentID.Trim());
                    DisplaStatusMessage(updateMessage, "Success");
                }

                tblOrgStdCOmments.Visible = true;
                btnAdd.Visible = true;
                tblDataEntry.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                btnNext.Visible = false;

                Clear();
                BindDataGrid();

            }
            catch (Exception ex)
            {
                DisplaStatusMessage(ex.Message, "Fail");
            }
            UpdatePanels();
        }
        
    }    

    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    { 
        GetSearch(); 
    }
    private void GetSearch()
    {
        ClearForm();
        btnAdd.Visible = false;
        //hidPrimaryKey.Value = "";
        string strCustNo = txtCustNo.Text;
        hidPrimaryKey.Value = txtCustNo.Text;
        string custType = "Cust";
        int strCnt = 0;
        if ((strCustNo != "") && (strCustNo.Contains("%") == true))
        {
            if (custType == "Cust")
            {
                if (isNumeric(strCustNo.Remove(strCustNo.Length - 1, 1), System.Globalization.NumberStyles.Integer) == false)
                    strCnt = Convert.ToInt16(cntCustName(strCustNo, custType));
                else
                    strCnt = Convert.ToInt16(cntCustNo(strCustNo, custType));

                int maxRowCount = utility.GetSQLWarningRowCount();


                if (strCnt < maxRowCount)
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Customer", "LoadCustomer('" + Server.UrlEncode(PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo)) + "','" + custType + "');", true);
                else
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Customer", "alert('Maximum row exceeds for this search.please enter additional data.');", true);
            }
            else
            {
                if (isNumeric(strCustNo.Remove(strCustNo.Length - 1, 1), System.Globalization.NumberStyles.Integer) == false)
                    strCnt = Convert.ToInt16(cntCustName(strCustNo, custType));
                else
                    strCnt = Convert.ToInt16(cntCustNo(strCustNo, custType));

                if (strCnt < 25)
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Vendor", "LoadCustomer('" + strCustNo + "','" + custType + "');", true);
                else
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Vendor", "alert('Entered value is too small to retrieve the customer info.please enter additional characters');", true);
            }
        }
        else
        {
            ViewState["Mode"] = "Add";
            btncheck();
            ClearForm();

            if (hidPrimaryKey.Value != "")
            {
                BindLable();
            }
            else
            {
                lbltype.Text = "";
                lblName.Text = "";
                lblAddress.Text = "";
                lblCityInfo.Text = "";
                lblCountry.Text = "";
                lblPhone.Text = "";
                tblDataEntry.Visible = false;
            }

            hidPrimaryKey.Value = strCustNo;
            UpdatePanels();
        }

    }
    private void BindLable()
    {
        string Code = code;  
        if (standardComment.CheckVendorORCistomerNumberValid(Code, "Cust"))
        {
            SetCustomerAndVendorInformation(Code, "Cust");
            BindDataGrid();
            btnAdd.Visible = (CommentSecurity != "") ? true : false;
        }
        else
        {
            DisplaStatusMessage("Invaild Customer Number", "Fail");
        }
    }

    protected void dgCountryCode_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            hidpOrgStdComID.Value = e.CommandArgument.ToString();
            string tableName = e.Item.Cells[1].Text.ToString();
            dtTablesData = standardComment.GetTablesData("pOrgStdCommentsID = '" + e.CommandArgument + "'",tableName.ToLower(),lbltype.Text);
            DisplayRecord();

            tblDataEntry.Visible = true;
            tdComment.Visible = true;

           
            btncheck();
            btnSave.Visible = (CommentSecurity != "") ? true : false;
            btnNext.Visible = (CommentSecurity != "") ? true : false;
            btnCancel.Visible = (CommentSecurity != "") ? true : false;
            btnAdd.Visible = (CommentSecurity != "") ? true : false;
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            standardComment.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            Clear();
            ViewState["Mode"] = "Add";
        }

        upnlbtnSearch.Update();
        upnlchkSelectAll.Update();
        upnlButtons.Update();
        upnlEntry.Update();
    }

    protected void dgCountryCode_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        standardComment.DeleteTablesData(hidPrimaryKey.Value);
        Clear();
        DisplaStatusMessage(deleteMessage, "success");
        ViewState["Operation"] = "Delete";
        BindDataGrid();

        btnSave.Visible = false;
        //btnDelete.Visible = false;
        UpdatePanels();
    }
    
    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";

        btncheck();
        hidPrimaryKey.Value = dtTablesData.Rows[0]["pTableID"].ToString().Trim();
        txtComment.Text = dtTablesData.Rows[0]["Comments"].ToString().Trim();
        txtLine.Text = dtTablesData.Rows[0]["LineNumber"].ToString().Trim();
        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();       
        lblEntryDate.Text = (dtTablesData.Rows[0]["EntryDt"].ToString() != "" ? Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString() : "");
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        string custNo = dtTablesData.Rows[0]["AlphaOrganizationNo"].ToString().Trim();
        string custName =dtTablesData.Rows[0]["Name"].ToString().Trim();
        string type = dtTablesData.Rows[0]["TableName"].ToString().Trim();
        lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString() != "" ? Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString() : "");
       
        SetCustomerAndVendorInformation(custNo, type);

        if (dtTablesData.Rows[0]["SOAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[0].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[0].Selected = false;

        }

        if (dtTablesData.Rows[0]["POAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[1].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[1].Selected = false;
        }

        if (dtTablesData.Rows[0]["EmailAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[2].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[2].Selected = false;
        }
    }

    public void SetCustomerAndVendorInformation(string number,string tableType)
    {
        if (number != "" && tableType != "")
        {
            DataSet dslist = new DataSet();
            DataTable dtlist = new DataTable();
            string tableName = "";
            string columnValue = "";
            string where = "";
            if (tableType.Trim().ToLower() == "cust")
            {
                tableName = "CustomerAddress RIGHT OUTER JOIN CustomerMaster ON CustomerAddress.fCustomerMasterID = CustomerMaster.pCustMstrID";
                columnValue = "CustomerAddress.fCustomerMasterID, CustomerAddress.Type, CustomerAddress.AddrLine1, dbo.CustomerAddress.City,CustomerAddress.State, CustomerAddress.PostCd, CustomerAddress.Country, CustomerAddress.PhoneNo, CustomerAddress.Email,CustomerAddress.EntryID,CustomerAddress.EntryDt, CustomerAddress.ChangeID,CustomerAddress.ChangeDt, CustomerMaster.pCustMstrID, CustomerMaster.CustNo, CustomerMaster.CustName";
                where = "CustNo='" + number + "'";
            }
            else
            {
                tableName = "VendorAddress RIGHT OUTER JOIN VendorMaster ON VendorAddress.fVendMstrID = VendorMaster.pVendMstrID";
                columnValue = " VendorAddress.Type, VendorAddress.fVendMstrID, VendorAddress.Line1 as AddrLine1 , dbo.VendorAddress.State, VendorAddress.City,VendorAddress.PostCd, VendorAddress.Country, VendorAddress.PhoneNo, VendorAddress.Email, VendorAddress.EntryID,VendorAddress.EntryDt, VendorAddress.ChangeID, VendorAddress.ChangeDt, VendorMaster.pVendMstrID, VendorMaster.VendNo as custno,VendorMaster.Name as CustName";
                where = "vendNo='" + number + "'";
            }
            dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnValue),
                                new SqlParameter("@whereClause", where));
            dtlist = dslist.Tables[0];
            if (dtlist.Rows.Count > 0)
            {
                lbltype.Text = "Type: " + number;
                lblName.Text = dtlist.Rows[0]["CustName"].ToString().Trim();
                lblAddress.Text = dtlist.Rows[0]["AddrLine1"].ToString().Trim();
                lblCityInfo.Text = dtlist.Rows[0]["City"].ToString().Trim() + ", " + dtlist.Rows[0]["State"].ToString().Trim() + " " + dtlist.Rows[0]["PostCd"].ToString().Trim();
                lblPhone.Text = "Phone: " + utility.FormatPhoneNumber(dtlist.Rows[0]["PhoneNo"].ToString().Trim()); ;
                lblCountry.Text = dtlist.Rows[0]["Country"].ToString().Trim();

                tblOrgStdCOmments.Visible = true;
                btnAdd.Visible = true;
                tblDataEntry.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
            }
            else
            {
                lbltype.Text = "";
                lblName.Text = "";
                lblAddress.Text = "";
                lblCityInfo.Text = "";
                lblCountry.Text = "";
                lblPhone.Text = "";

                tblOrgStdCOmments.Visible = false;
                tblDataEntry.Visible = false;
                btnAdd.Visible = false;
            }
        }
    }

    private void BindDataGrid()
    {
        string type="Cust".ToLower();
        string code = txtCustNo.Text;
        string searchText = "";

        if (type != "" && code == "")
        {
            searchText = "TableName='" + type + "'";
        }
        else
        {
            searchText = "TableName='" + type + "' and AlphaOrganizationNo='" + code + "'";
        }
        dtTablesData = standardComment.GetTablesData(searchText,type,lbltype.Text);

        if (dtTablesData != null)
        {
            dtTablesData.DefaultView.Sort = (hidSort.Value == "") ? "pTableID desc" : hidSort.Value;
            dgCountryCode.DataSource = dtTablesData.DefaultView.ToTable();
            dgCountryCode.DataBind();
            upnlGrid.Update();            
            if (dtTablesData.Rows.Count == 0)
            {
                DisplaStatusMessage("No Records Found", "Fail");
            }
        }
        else
            DisplaStatusMessage("No Records Found", "Fail");

    }

    private void UpdatePanels()
    {
        upnlOrgSttComments.Update();
        upnlbtnSearch.Update();
        upnlEntry.Update();
        upnlchkSelectAll.Update();        
        upnlGrid.Update();
        pnlProgress.Update();
        upnlButtons.Update();
    }
    
    protected void Clear()
    {
        try
        {
            foreach (ListItem li in chkSelection.Items)
            {
                li.Selected = false;
            }
           
            btnDelete.Visible = false;
            chkSelectAll.Checked = false;

            //txtCode.Focus();
            lblChangeID.Text = lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            txtComment.Text =txtLine.Text = "";
           
            upnlEntry.Update();
            upnlchkSelectAll.Update();
        }
        catch (Exception ex) { }
    }

    protected void ClearForm()
    {
        tblOrgStdCOmments.Visible = false;
    }

    private void DisplaStatusMessage(string message, string messageType)
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
    /// <summary>
    ///  used to disable control for security mode
    /// </summary>
    private void EnableQueryMode()
    {
        //btnDelete.Visible = false;
        btnSave.Visible = false;
        btnAdd.Visible = false;
    }
    /// <summary>
    /// dgCountryCode :Item data bound event handlers
    /// </summary>
    protected void dgCountryCode_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item) && CommentSecurity == "")
        {           
            LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
            lnkDelete.Visible = false;
        }
    }

    

    public bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
    {
        Double result;
        return Double.TryParse(val, NumberStyle,
            System.Globalization.CultureInfo.CurrentCulture, out result);
    }
       
    public string cntCustNo(string custNo,string type)
    {
        if (type == "Cust")
        {
            DataTable dtCustomer = new DataTable();
            string tableName = "CustomerMaster";
            string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
            string whereClause = "CustNo Like '" + custNo.Trim().Replace("%", "") + "%'";
            //DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);
            DataSet dsCustomer = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                               new SqlParameter("@tableName", tableName),
                               new SqlParameter("@columnNames", columnName),
                               new SqlParameter("@whereClause", whereClause));
            if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
            {
                dtCustomer = dsCustomer.Tables[0];
                return dtCustomer.Rows[0]["totalcount"].ToString();
            }
            else
                return "0";
        }
        else
        {
            DataTable dtCustomer = new DataTable();
            string tableName = "VendorMaster";
            string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
            string whereClause = "VendNo Like '" + custNo.Trim().Replace("%", "") + "%'";
            //DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);
            DataSet dsCustomer = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                               new SqlParameter("@tableName", tableName),
                               new SqlParameter("@columnNames", columnName),
                               new SqlParameter("@whereClause", whereClause));
            if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
            {
                dtCustomer = dsCustomer.Tables[0];
                return dtCustomer.Rows[0]["totalcount"].ToString();
            }
            else
                return "0";
        }
    }

    public string cntCustName(string custNo,string type)
    {
        if (type == "Cust")
        {
            DataTable dtCustomer = new DataTable();
            string tableName = "CustomerMaster";
            string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
            string whereClause = "CustName Like '" + custNo.Trim().Replace("%", "") + "%'";
            //DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);
            DataSet dsCustomer = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
            if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
            {
                dtCustomer = dsCustomer.Tables[0];
                return dtCustomer.Rows[0]["totalcount"].ToString();
            }
            else
                return "0";
        }
        else
        {
            DataTable dtCustomer = new DataTable();
            string tableName = "VendorMaster";
            string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
            string whereClause = "Name Like '" + custNo.Trim().Replace("%", "") + "%'";
           //DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);
            DataSet dsCustomer = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
            if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
            {
                dtCustomer = dsCustomer.Tables[0];
                return dtCustomer.Rows[0]["totalcount"].ToString();
            }
            else
                return "0";
        }
    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        string custNo = txtCustNo.Text.Trim();
        string AlphaOrgNo = standardComment.CheckAlphaOrgNo("Cust".ToLower(), custNo);
        if(txtComment.Text=="")
        {
            ScriptManager.RegisterClientScriptBlock(btnNext, btnNext.GetType(), "Required", "alert(' *  Marked fields are mandatory')", true);
        }
        else
        {
        if (ViewState["Mode"].ToString() == "Add")
        {
            string columnName = "TableName,OrganizationNo,AlphaOrganizationNo,Comments,LineNumber,SOAppInd,POAppInd,EmailAppInd,EntryID,EntryDt";

            string columnValue = "'" + "Cust".Trim().Replace("'", "''") + "'," +
                                   "'" + custNo.Trim().Replace("'", "''") + "'," +                                  
                                   "'" + AlphaOrgNo.Trim().Replace("'", "''") + "'," +
                                   "'" + txtComment.Text.Trim().Replace("'", "''") + "'," +
                                   "'" + txtLine.Text.Trim().Replace("'", "''") + "'," +
                                   "'" + ((chkSelection.Items[0].Selected == true) ? "Y" : "") + "'," +
                                   "'" + ((chkSelection.Items[1].Selected == true) ? "Y" : "") + "'," +
                                   "'" + ((chkSelection.Items[2].Selected == true) ? "Y" : "") + "'," +                                  
                                   "'" + Session["UserName"] + "'," +
                                   "'" + DateTime.Now.ToShortDateString() + "'";

            standardComment.InsertTables(columnName, columnValue);
            DisplaStatusMessage(updateMessage, "Success");
            btnSave.Visible = true;
            btnDelete.Visible = false;
            btnNext.Visible = true;
            txtComment.Text = "";
            txtLine.Text = "";                
            chkSelection.Items[0].Selected = false;
            chkSelection.Items[1].Selected = false;
            chkSelection.Items[2].Selected = false;

            Clear();
            BindDataGrid();
            UpdatePanels();
        }
        else
        {
            string updateValue =

                                "Comments='" + txtComment.Text.Trim().Replace("'", "''") + "'," +
                                "LineNumber='" + txtLine.Text.Trim().Replace("'", "''") + "'," +
                                "SOAppInd='" + ((chkSelection.Items[0].Selected == true) ? "Y" : "") + "'," +
                                "POAppInd='" + ((chkSelection.Items[1].Selected == true) ? "Y" : "") + "'," +
                                "EmailAppInd='" + ((chkSelection.Items[2].Selected == true) ? "Y" : "") + "'," +
                                "ChangeID='" + Session["UserName"].ToString() + "'," +
                                "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

            standardComment.UpdateTables(updateValue, "pOrgStdCommentsID=" + hidPrimaryKey.Value.Trim());

            btnAdd_Click(btnNext, new ImageClickEventArgs(0,0));
            DisplaStatusMessage(updateMessage, "Success");            
        }
        ScriptManager.RegisterClientScriptBlock(btnNext,btnNext.GetType(),"focus","document.getElementById('txtComment').selected;document.getElementById('txtComment').focus();",true );
        
    }
    }
    
    

  

    protected void btnCancel_Click1(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = true;
        UpdatePanels();
        Clear();
        ViewState["Mode"] = "Add";
    }
    
}



