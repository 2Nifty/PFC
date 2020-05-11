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
using System.Web.UI.Design;
using System.Data.SqlClient;

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;


public partial class Fiscal : System.Web.UI.Page
{
    FiscalPeriod fiscalPeriod;
    MaintenanceUtility maintenanceUtils ;
    private DataTable dtTablesData = new DataTable();

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string addMessage = "Data has been successfully added";
    string connectionString = "";

    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
    protected string FiscalSecurity
    {
        get
        {
            return Session["FiscalSecurity"].ToString();
        }
    }
     
    public string Mode
    {
        get { return ViewState["Mode"].ToString(); }
        set { ViewState["Mode"] = value; }
    }


    #region Event Handler
 
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
            
            fiscalPeriod = new FiscalPeriod();
            maintenanceUtils = new MaintenanceUtility();
            lblMessage.Text = "";

            if (!Page.IsPostBack)
            {
               // lblCurrentDate.Text = DateTime.Now.ToShortDateString();              
                Session["FiscalSecurity"] = maintenanceUtils.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.FiscalPeriod);
                Mode = "Add";
                BindDataGrid();
            }

            if (FiscalSecurity == "")
                EnableQueryMode();
            //btnSave.Visible = false;
        }
        catch (Exception ex)
        {
            DisplaStatusMessage(ex.Message, "Fail");
        }

    }
    /// <summary>
    /// Cancel the entry area
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        ClearControl();
    }
    /// <summary>
    /// Add mode is enabled
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();
        ClearControl();
        Mode = "Add";
        btnSave.Visible = (FiscalSecurity != "") ? true : false;
        UpdatePanels();
    }
    /// <summary>
    /// Update entry area in Database
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        bool status=true;
        if (tdpMonth.EndDate.Trim() != "" && tdpMonth.EndDate.Trim() != "")
          {
            if (Convert.ToDateTime(tdpMonth.StartDate.Trim()) > Convert.ToDateTime(tdpMonth.EndDate.Trim()))               
                status =false;
          }



          if (status)
          {

              string payRollPost = (chkSelection.Items[0].Selected == true ? "1" : "0");
              string reclassvariance = (chkSelection.Items[1].Selected == true ? "1" : "0");
              string fGLMonthEnd = (chkSelection.Items[2].Selected == true ? "1" : "0");
              string fGLYearEnd = (chkSelection.Items[3].Selected == true ? "1" : "0");
              tdpMonth.StartDate = (tdpMonth.StartDate != "") ? tdpMonth.StartDate.Trim() : null;

              string columnName = "";
              string columnValue = "";
              if (Mode.ToString() == "Add")
              {


                  columnName = "FiscalPeriod,FiscalYear,FiscalPeriodStart,FiscalPeriodEnd,StatusCd,Notes," +
                                    "PayRollPostedInd, ReconciledVariancePostedInd,GLMonthendClosedInd,GLYearendClosedInd," +
                                    "EntryID,EntryDt";


                  columnValue = "'" + txtPeriod.Text.Trim() + "'," +
                                      "'" + txtYear.Text.Trim() + "'," +
                                      "'" + tdpMonth.StartDate.Trim() + "'," +
                                      "'" + tdpMonth.EndDate.Trim() + "', " +
                                      "'" + txtStatus.Text.Trim() + "'," +
                                      "'" + txtNotes.Text.Trim() + "'," +
                                      "'" + payRollPost + " '," +
                                      "'" + reclassvariance + " '," +
                                      "'" + fGLMonthEnd + " ', " +
                                      "'" + fGLYearEnd + "', " +
                                      "'" + Session["UserName"] + "'," +
                                      "'" + DateTime.Now.ToShortDateString() + " '";
                  //}
                  //else
                  //{
                  //     columnName = "FiscalPeriod,FiscalYear,StatusCd,Notes," +
                  //                      "PayRollPostedInd, ReconciledVariancePostedInd,GLMonthendClosedInd,GLYearendClosedInd," +
                  //                      "EntryID,EntryDt";

                  //    columnValue = "'" + txtPeriod.Text.Trim() + "'," +
                  //                        "'" + txtYear.Text.Trim() + "'," +

                  //                        "'" + txtStatus.Text.Trim() + "'," +
                  //                        "'" + txtNotes.Text.Trim() + "'," +
                  //                        "'" + payRollPost + " '," +
                  //                        "'" + reclassvariance + " '," +
                  //                        "'" + fGLMonthEnd + " ', " +
                  //                        "'" + fGLYearEnd + "', " +
                  //                        "'" + Session["UserName"] + "'," +
                  //                        "'" + DateTime.Now.ToShortDateString() + " '";


                  //}
                  fiscalPeriod.InsertTables(columnName, columnValue);
                  BindDataGrid();
                  DisplaStatusMessage(addMessage, "Success");
                  ClearControl();
                  btnSave.Visible = true;
                  //btnDelete.Visible = false;
              }
              //else
              //{
              //    DisplaStatusMessage("GL Record Already Exists", "Fail");
              //    //upnlGrid.Update();
              //    pnlProgress.Update();
              //    return;
              //}

              else
              {
                  //string whereClause ="";
                  // string updateValue ="";
                  // if (tdpMonth.StartDate != "" && tdpMonth.EndDate != "")
                  // {

                  string whereClause = "pFYPeriodID='" + ViewState["PeriodID"].ToString() + "'";


                  string updateValue = "FiscalPeriod='" + txtPeriod.Text.Trim() + "'," +
                                       "FiscalYear='" + txtYear.Text.Trim() + "'," +
                                       "FiscalPeriodStart='" + tdpMonth.StartDate.Trim() + "'," +
                                       "FiscalPeriodEnd='" + tdpMonth.EndDate.Trim() + "'," +
                                       "Notes='" + txtNotes.Text.Trim() + "'," +
                                       "StatusCd='" + txtStatus.Text.Trim() + "'," +
                                       "PayRollPostedInd='" + payRollPost + "'," +
                                       "ReconciledVariancePostedInd='" + reclassvariance + "'," +
                                       "GLMonthendClosedInd='" + fGLMonthEnd + "'," +
                                       "GLYearendClosedInd='" + fGLYearEnd + "'," +
                                       "ChangeID='" + Session["UserName"].ToString() + "'," +
                                       "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                  //}
                  //else 
                  //{
                  //    whereClause = "pFYPeriodID='" + ViewState["PeriodID"].ToString() + "'";


                  //    updateValue = "FiscalPeriod='" + txtPeriod.Text.Trim() + "'," +
                  //                         "FiscalYear='" + txtYear.Text.Trim() + "'," +
                  //                         "Notes='" + txtNotes.Text.Trim() + "'," +
                  //                         "StatusCd='" + txtStatus.Text.Trim() + "'," +
                  //                         "PayRollPostedInd='" + payRollPost + "'," +
                  //                         "ReconciledVariancePostedInd='" + reclassvariance + "'," +
                  //                         "GLMonthendClosedInd='" + fGLMonthEnd + "'," +
                  //                         "GLYearendClosedInd='" + fGLYearEnd + "'," +
                  //                         "ChangeID='" + Session["UserName"].ToString() + "'," +
                  //                         "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                  //}
                  fiscalPeriod.UpdateTables(updateValue, whereClause);

                  DisplaStatusMessage(updateMessage, "Success");
                  btnSave.Visible = false;
                  //btnAdd.Visible = false;
                  // btnDelete.Visible = false;
                  Mode = "Add";
                  ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

              }
              //    else
              //    {
              //        DisplaStatusMessage("GL Record Already Exists", "Fail");
              //        upnlGrid.Update();
              //        pnlProgress.Update();
              //        return;
              //    }



              ViewState["Operation"] = "Save";
              ClearControl();
              BindDataGrid();
              UpdatePanels();
          }
          else
              ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Validate", "alert('Invalid Date Range');", true);
    }

    /// <summary>
    /// Datagrid item command ilke Edit,Delete even handler
    /// </summary>
    /// <param name="source"></param>
    /// <param name="e"></param>
    protected void dgFiscalPeriod_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
           // HiddenField hidPeriodID = e.CommandArgument;
           // dtTablesData = fiscalPeriod.GetFiscalPeriods("CurrentDt = '" + e.CommandArgument + "'");
            dtTablesData = fiscalPeriod.GetFiscalPeriods("pFYPeriodID='" + e.CommandArgument.ToString() + "'");
            ViewState ["PeriodID"]=e.CommandArgument.ToString();
            FillControls();            
            btnSave.Visible = (FiscalSecurity != "") ? true : false;
        }
        if (e.CommandName == "Delete")
        {
            fiscalPeriod.DeleteData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            ClearControl();
        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }
    /// <summary>
    /// Datagrid sort event handler
    /// </summary>
    /// <param name="source"></param>
    /// <param name="e"></param>
    protected void dgFiscalPeriod_SortCommand(object source, DataGridSortCommandEventArgs e)
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
    /// <summary>
    /// dgFiscalPeriod :Item data bound event handlers
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void dgFiscalPeriod_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item) && FiscalSecurity == "")
        {
            LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
            lnkDelete.Visible = false;
        }
        if (e.Item.Cells[3].Text == "01/01/1900")
            e.Item.Cells[3].Text = "";
        if (e.Item.Cells[4].Text == "01/01/1900")
            e.Item.Cells[4].Text = "";
    }
    /// <summary>
    /// check box Select all event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
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
    #endregion

    #region Developer Method

    /// <summary>
    /// Datagrid bind method
    /// </summary>
    private void BindDataGrid()
    {
       
        dtTablesData = fiscalPeriod.GetFiscalPeriods("1=1");

        if (dtTablesData != null)
        {
            dtTablesData.DefaultView.Sort = (hidSort.Value == "") ? "pFYPeriodID desc" : hidSort.Value;
            dgFiscalPeriod.DataSource = dtTablesData.DefaultView.ToTable();
            dgFiscalPeriod.DataBind();
        }
        
        else
            DisplaStatusMessage("No Records Found", "Fail");

    }
    /// <summary>
    /// Common method to update panels
    /// </summary>
    private void UpdatePanels()
    {

        upnlEntry.Update();
        upnlAdd.Update();
        upGrid.Update();
        pnlProgress.Update();
        upnlbtnsave.Update();
    }
    /// <summary>
    /// Fill all entry area with data in edit mode
    /// </summary>
    private void FillControls()
    {
        if (dtTablesData!=null && dtTablesData.Rows.Count>0)
        {
            Mode = "Edit";

           
            txtYear.Text = dtTablesData.Rows[0]["Year"].ToString();
            txtPeriod.Text = dtTablesData.Rows[0]["Period"].ToString();
            txtStatus.Text = dtTablesData.Rows[0]["StatusCd"].ToString();
            txtNotes.Text = dtTablesData.Rows[0]["Notes"].ToString();
            //tdpMonth.StartDate = String.Format("{0:MM/dd/yyyy}", dtTablesData.Rows[0]["PeriodStart"]);
            //tdpMonth.EndDate = String.Format("{0:MM/dd/yyyy}", dtTablesData.Rows[0]["PeriodEnd"]);
            
            if (dtTablesData.Rows[0]["PeriodStart"].ToString() == "01/01/1900" || dtTablesData.Rows[0]["PeriodStart"].ToString() == "")
            {
                tdpMonth.StartDate = "";
            }
            else
            {
                tdpMonth.StartDate = String.Format("{0:MM/dd/yyyy}", dtTablesData.Rows[0]["PeriodStart"]);
            }

            if (dtTablesData.Rows[0]["PeriodEnd"].ToString() == "01/01/1900" || dtTablesData.Rows[0]["PeriodEnd"].ToString() == "")
            {
                tdpMonth.EndDate = "";
            }
            else
            {
                tdpMonth.EndDate = dtTablesData.Rows[0]["PeriodEnd"].ToString();
            }

            chkSelection.Items[0].Selected = (dtTablesData.Rows[0]["PayrollPostedInd"].ToString().Trim() == "1");
            chkSelection.Items[1].Selected = (dtTablesData.Rows[0]["RCLVarPostedInd"].ToString().Trim() == "1");
            chkSelection.Items[2].Selected = (dtTablesData.Rows[0]["GLMEClosedInd"].ToString().Trim() == "1");
            chkSelection.Items[3].Selected = (dtTablesData.Rows[0]["GLYEClosedInd"].ToString().Trim() == "1");
            chkSelectAll.Checked = (chkSelection.Items[0].Selected && chkSelection.Items[1].Selected && chkSelection.Items[2].Selected && chkSelection.Items[3].Selected);
        }                                    
    }                                    
    /// <summary>
    /// Clear all controls in entry area
    /// </summary>
    protected void ClearControl()
    {
        try
        {
          

            txtPeriod.Text=txtStatus.Text=txtYear.Text= txtNotes.Text = "";
            tdpMonth.EndDate= tdpMonth.StartDate = "";
            chkSelectAll.Checked = false;
            chkSelectAll_CheckedChanged(chkSelectAll, new EventArgs());
            upnlEntry.Update();
        }
        catch (Exception ex) { }
    }
    /// <summary>
    /// Display error message in common lable
    /// </summary>
    /// <param name="message"></param>
    /// <param name="messageType"></param>
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
        btnSave.Visible = false;
        btnAdd.Visible = false;
    } 
    #endregion 
}



