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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
#endregion

namespace PFC.Intranet.ListMaintenance
{
    public partial class _CustPriceRanking : System.Web.UI.Page
    {
        #region  Valiable Declaration
                      
        MaintenanceUtility maintenanceUtility = new MaintenanceUtility();
        ddlBind _ddlBind = new ddlBind();

        int pageSize = 15;  
        string updateMessage = "Data has been successfully updated.";
        string addMessage = "Data has been successfully added.";
        string deleteMessage = "Data has been successfully deleted.";
        string Mode = "Full";

        #endregion

        #region Page Load Event

        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(_CustPriceRanking));
            lblListMsg.Visible = false;
            BindMessage("", false);
            if (Request.QueryString["Mode"] != null)
                Mode = Request.QueryString["Mode"].ToString().ToUpper();

            if (!Page.IsPostBack)
            {
                BindDropDowns();
                tblAddContract.Visible = false;
                if (Request.QueryString["CustNo"] != null)
                {
                    txtCustNo.Text = Request.QueryString["CustNo"].ToString();
                    txtCustNo.ReadOnly = true;
                    txtCustNo.Enabled = false;
                    btnSearchCust_Click(btnSearchCust, new EventArgs());
                }
            }

            if (Mode == "READONLY")
            {
                ibtnAddList.Visible = false;
            }

        }

        #endregion

        #region Event Handlers

        protected void btnSearchCust_Click(object sender, EventArgs e)
        {
            DataSet dsCustData = GetCustPriceRankData("loadcustomerdetail", txtCustNo.Text, "", "0", "", "");

            if (dsCustData != null && dsCustData.Tables[0].Rows.Count > 0)
            {
                lblCustNo.Text = dsCustData.Tables[0].Rows[0]["CustNo"].ToString();
                lblCustName.Text = dsCustData.Tables[0].Rows[0]["CustName"].ToString();
                lblAddress1.Text = dsCustData.Tables[0].Rows[0]["AddrLine1"].ToString();
                lblAddress2.Text = dsCustData.Tables[0].Rows[0]["AddrLine2"].ToString();
                lblCity.Text = dsCustData.Tables[0].Rows[0]["City"].ToString() + ", " +
                                dsCustData.Tables[0].Rows[0]["State"].ToString() + " " +
                                dsCustData.Tables[0].Rows[0]["PostCd"].ToString() + " " +
                                dsCustData.Tables[0].Rows[0]["Country"].ToString();
                lblPhone.Text = dsCustData.Tables[0].Rows[0]["PhoneNo"].ToString();
                lblFaxNo.Text = dsCustData.Tables[0].Rows[0]["FaxPhoneNo"].ToString();

                BindDataGrid(dsCustData.Tables[1]);
            }
            else
            {
                ClearControls();
                BindMessage("Invalid customer number.", true);
            }

            pnlGrid.Update();
            pnlSearchList.Update();

        }

        protected void chkShowDeleted_CheckedChanged(object sender, EventArgs e)
        {
            DataSet dsCustData = GetCustPriceRankData("loadcustomerdetail", txtCustNo.Text, "", "0", "", "");

            if (dsCustData != null)
                BindDataGrid(dsCustData.Tables[1]);
        }

        protected void ibtnAddList_Click(object sender, ImageClickEventArgs e)
        {
            tblAddContract.Visible = true;
            ddlRanking.Items.Clear();
            ddlContractCd.ClearSelection();

            DataSet dsMaxRank = GetCustPriceRankData("findMaxRank", txtCustNo.Text, "", "0", "", "");
            if (dsMaxRank != null && dsMaxRank.Tables[0].Rows.Count > 0)
            {
                int maxRank = Convert.ToInt32(dsMaxRank.Tables[0].Rows[0]["MaxRank"].ToString());
                for (int i = 1; i <= maxRank; i++)
                {
                    ddlRanking.Items.Add(i.ToString());
                }

                ddlRanking.SelectedValue = maxRank.ToString();

            }
            else
            {
                ddlRanking.Items.Clear();
                ddlRanking.Items.Insert(0, new ListItem("N/A", ""));
            }

            pnlSearchList.Update();
        }
               
        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            tblAddContract.Visible = false;
        }

        protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (ddlContractCd.SelectedIndex != 0)
            {
                DataSet dsCustRankData = GetCustPriceRankData("AddContract", txtCustNo.Text, ddlContractCd.SelectedValue, ddlRanking.SelectedValue, Session["UserName"].ToString(), "");
                if (dsCustRankData != null &&
                    dsCustRankData.Tables[0].Rows.Count > 0 &&
                    dsCustRankData.Tables[0].Rows[0]["ErrorMsg"].ToString() == "")
                {
                    BindDataGrid(dsCustRankData.Tables[2]);
                    ibtnAddList_Click(ibtnSave, new ImageClickEventArgs(0, 0));
                    BindMessage(addMessage, false);
                }
                else if (dsCustRankData != null &&
                    dsCustRankData.Tables[0].Rows.Count > 0 &&
                    dsCustRankData.Tables[0].Rows[0]["ErrorMsg"].ToString() != "")
                {
                    BindMessage(dsCustRankData.Tables[0].Rows[0]["ErrorMsg"].ToString(), true);
                }
            }
            else
            {
                BindMessage("Invalid customer contract code.", true);
            }
            
        }
                
        protected void dgListItem_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField _hidContractCd = e.Item.FindControl("hidPreviuosContractCd") as HiddenField;
                DropDownList _ddlContractCd = e.Item.FindControl("ddlGridContractCd") as DropDownList;
                DataTable _dtCustContract = Session["CustContract"] as DataTable;

                _ddlBind.ddlBindControl(_ddlContractCd, _dtCustContract, "ListValue", "ListDispDesc", "", "");
                _ddlContractCd.Items.Insert(0, new ListItem("--- Select ---", ""));

                try
                {
                    _ddlContractCd.SelectedValue = _hidContractCd.Value;
                }
                catch (Exception ex)
                {
                }
                
                if (Mode == "READONLY")
                {
                    _ddlContractCd.Enabled = false;
                    dgListItem.Columns[0].Visible = false;
                }
            }
        }

        protected void dgListItem_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                DataSet dsCustRankData = GetCustPriceRankData("deletecontract", "", "", "0", Session["UserName"].ToString(), e.CommandArgument.ToString().Trim());
                BindDataGrid(dsCustRankData.Tables[1]);

                BindMessage(deleteMessage, false);
            }

            pnlSearchList.Update();
        }

        protected void dgItem_SortCommand(object source, DataGridSortCommandEventArgs e)
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

            DataSet dsCustData = GetCustPriceRankData("loadcustomerdetail", txtCustNo.Text, "", "0", "", "");
            if (dsCustData != null && dsCustData.Tables.Count > 1)
            {
                BindDataGrid(dsCustData.Tables[1]);
            }
                        
        }

        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dgListItem.CurrentPageIndex = pager.GotoPageNumber;
            DataSet dsCustData = GetCustPriceRankData("loadcustomerdetail", txtCustNo.Text, "", "0", "", "");
            
            if(dsCustData != null)
                BindDataGrid(dsCustData.Tables[1]);
        }
              
        #endregion

        #region Developer Methods

        private void BindDataGrid(DataTable dtCustPriceRank)
        {
            if (dtCustPriceRank != null)
            { 
                if (hidSort.Value != "")
                    dtCustPriceRank.DefaultView.Sort = hidSort.Value;

                if (!chkShowDeleted.Checked)
                {
                    dtCustPriceRank.DefaultView.RowFilter = "isnull(DeleteDt,'') = ''";
                }

                dgListItem.DataSource = dtCustPriceRank.DefaultView.ToTable();
                pager.InitPager(dgListItem, pageSize);
                
                if (dtCustPriceRank.Rows.Count == 0)
                    BindMessage("No records found.", true);                              
            }

            pnlGrid.Update();   
        }

        private void BindDropDowns()
        {
            DataSet dsDLLData = GetCustPriceRankData("getcontracts", "", "", "0", "", "");

            if (dsDLLData != null)
            {
                _ddlBind.ddlBindControl(ddlContractCd, dsDLLData.Tables[0], "ListValue", "ListDispDesc", "", "");
                ddlContractCd.Items.Insert(0, new ListItem("--- Select ---", ""));
                Session["CustContract"] = dsDLLData.Tables[0];

                ddlRanking.Items.Clear();
                ddlRanking.Items.Insert(0, new ListItem("N/A", ""));
            }

        }

        private void ClearControls()
        {
            lblCustNo.Text = lblCustName.Text = lblAddress1.Text = lblAddress2.Text = "";
            lblCity.Text = lblPhone.Text = lblFaxNo.Text = "";
            dgListItem.DataSource = null;
            dgListItem.DataBind();
            tblAddContract.Visible = false;
        }

        private void BindMessage(string message, bool errorFlag)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = (errorFlag) ? System.Drawing.Color.Red : System.Drawing.Color.Green;
            pnlProgress.Update();
        }

        #endregion

        #region Ajax Methods

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string[] UpdateCustContractCd(string pCustPriceRankId, string contractCd, string custNo)
        {
            string[] result = new string[10];

            try
            {
                DataSet dsRankData = GetCustPriceRankData("UpdateContract", custNo, contractCd, "0", Session["UserName"].ToString(), pCustPriceRankId);

                if (dsRankData != null)
                {
                    result[0] = dsRankData.Tables[0].Rows[0]["ErrorMsg"].ToString();
                    result[1] = Session["UserName"].ToString();
                    result[2] = DateTime.Now.ToShortDateString();
                    return result;
                }

                result[0] = "Failed to update customer contract code.";
                return result;
            }
            catch (Exception ex)
            {
                result[0] = ex.Message;
                return result;
            }
        }

        #endregion

        #region DB Helper Methods
        
        private DataSet GetCustPriceRankData(string mode, string custNo, string contractCd, string ranking, string entryId, string pCustPriceRankId)
        {
            DataSet dsRankingData = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pCustPriceRankingFrm]",
                                new SqlParameter("@source", mode),
                                new SqlParameter("@custNo", custNo),
                                new SqlParameter("@contractCd", contractCd),
                                new SqlParameter("@ranking", ranking),
                                new SqlParameter("@entryId", entryId),
                                new SqlParameter("@pCustPriceRankingID", pCustPriceRankId));
            return dsRankingData;

        }

        #endregion

       
} // End Class

}// End Namespace
