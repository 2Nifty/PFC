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
    public partial class _WhseShipListMaintenance : System.Web.UI.Page
    {
        #region  Valiable Declaration

        int pageSize = 15;
        string[] selectedListId = new string[10000];
        MaintenanceUtility maintenanceUtility = new MaintenanceUtility();

        #endregion

        #region Constant Variables
        
        string updateMessage = "Data has been successfully updated.";
        string addMessage = "Data has been successfully added.";
        string deleteMessage = "Data has been successfully deleted.";
        string listMessage = "List Name already exist.";
        string itemMessage = "Item Name already exist.";
        
        #endregion

        #region Page Load Event

        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(_WhseShipListMaintenance));
            lblListMsg.Visible = false;
            BindMessage("", false);            
            if (!Page.IsPostBack)
            {
                BindDropDowns();
                Session["ListDetailIDSelected"] = "";
                Session["ShipListSecurity"] = maintenanceUtility.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.ShipListMaintAccess);
                
                if (Session["ShipListSecurity"].ToString() == "")
                {
                    lblBtnHeader.Text += " [Query Only]";
                }
                SetDefaults();
            }

        }

        #endregion

        #region Event Handlers

        protected void ibtnAddList_Click(object sender, ImageClickEventArgs e)
        {
            string _listName = Session["BranchId"].ToString() + "-" + txtNewListName.Text + "-" + DateTime.Now.ToShortDateString();
            if (_listName.Length > 21)
            {
                BindMessage("Shipping List Name more than 21 characters, please re-enter with less characters.", true);
                return;
            }

            DataSet _dsShipListData = GetShipListData("add", _listName, Session["BranchId"].ToString(), Session["UserName"].ToString(), "O", "", "", "");
            BindDataGrid(_dsShipListData);
        }

        protected void ibtnSearchList_Click(object sender, ImageClickEventArgs e)
        {
            Session["ListDetailIDSelected"] = "";
            tblTotal.Visible = false;
            DataSet _dsShipListData = GetShipListData("search", txtSearchListName.Text, ddlLocation.SelectedValue, ddlUserId.SelectedValue, ddlListType.SelectedValue, dpStartDt.SelectedDate, dpEndDt.SelectedDate, "");
            BindDataGrid(_dsShipListData);
        }

        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            SetDefaults();
        }

        protected void ibtnCalculate_Click(object sender, ImageClickEventArgs e)
        {
            if (Session["ListDetailIDSelected"] != null && Session["ListDetailIDSelected"].ToString().Trim() != "")
            {
                DataSet _dsShipListData = GetShipListData("getsummary", Session["ListDetailIDSelected"].ToString(), "", "", "", "", "", "");
                lblTotalPalletCnt.Text = _dsShipListData.Tables[0].Rows[0]["PalletCnt"].ToString();
                lblTotalWght.Text = _dsShipListData.Tables[0].Rows[0]["TotalWght"].ToString();
                lblOrderTotal.Text = _dsShipListData.Tables[0].Rows[0]["OrderCnt"].ToString();
                tblTotal.Visible = true;
            }
            else
            {
                tblTotal.Visible = false;
                BindMessage("Please select list name to calculate total.", true);
            }

            pnlTotal.Update();

        }

        protected void btnDeleteGridLine_Click(object sender, EventArgs e)
        {
            DataSet _dsShipListData = GetShipListData("DeleteList", "", "", Session["UserName"].ToString(), "", "", "", hidRowID.Value);

            ibtnSearchList_Click(ibtnCancel, new ImageClickEventArgs(0, 0));
            pnlTotal.Update();
        }

        protected void btnCloseList_Click(object sender, EventArgs e)
        {
            DataSet _dsShipListData = GetShipListData("CloseList", "", "", Session["UserName"].ToString(), "", "", "", hidRowID.Value);

            ibtnSearchList_Click(ibtnCancel, new ImageClickEventArgs(0, 0));
            pnlTotal.Update();
        }

        protected void btnReopenList_Click(object sender, EventArgs e)
        {
            DataSet _dsShipListData = GetShipListData("ReopenList", "", "", Session["UserName"].ToString(), "", "", "", hidRowID.Value);

            ibtnSearchList_Click(ibtnCancel, new ImageClickEventArgs(0, 0));
            pnlTotal.Update();
        }        


        protected void dgListItem_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField _hidpListId = e.Item.FindControl("pShipListId") as HiddenField;
                CheckBox _chkSelect = e.Item.FindControl("chkSelect") as CheckBox;
                HyperLink hplButton = e.Item.FindControl("hplListName") as HyperLink;
                HyperLink _hplConfirmList = e.Item.FindControl("hplConfirmList") as HyperLink;
                //HtmlGenericControl _divToolTips = e.Item.FindControl("divDelete") as HtmlGenericControl;
                LinkButton _lnkListType = e.Item.FindControl("lnkListType") as LinkButton;

                hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'Quote', 'height=610,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
                _hplConfirmList.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'Confirm', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

                if (Session["ShipListSecurity"].ToString() == "" || ddlListType.SelectedValue == "D")
                {
                    _lnkListType.Font.Underline = false;
                    if(ddlListType.SelectedValue == "D")
                        _lnkListType.ForeColor = System.Drawing.Color.Red;
                }
                else
                    _lnkListType.Attributes.Add("onmousedown", "javascript:ShowGridtooltip('" + divDelete.ClientID + "','" + _lnkListType.ClientID + "');document.getElementById('hidRowID').value='" + _hidpListId.Value + "';");
                
                // Restore check mark
                foreach (string listId in selectedListId)
                {
                    if (listId == _hidpListId.Value)
                    {
                        _chkSelect.Checked = true;
                        break;
                    }
                }
            }
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

            DataSet _dsShipListData = GetShipListData("search", txtSearchListName.Text, ddlLocation.SelectedValue, ddlUserId.SelectedValue, ddlListType.SelectedValue, dpStartDt.SelectedDate, dpEndDt.SelectedDate, "");
            BindDataGrid(_dsShipListData);
        }

        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dgListItem.CurrentPageIndex = pager.GotoPageNumber;
            DataSet _dsListItem = ViewState["GridData"] as DataSet;
            BindDataGrid(_dsListItem);
        }
              
        #endregion

        #region Developer Methods

        private void BindDataGrid(DataSet dsShipListData)
        {
            if (dsShipListData != null)
            {
                ViewState["GridData"] = dsShipListData; // Used in paging control

                if (hidSort.Value != "")
                    dsShipListData.Tables[0].DefaultView.Sort = hidSort.Value;

                // Create Array variable that contains user selected list id's
                selectedListId = Session["ListDetailIDSelected"].ToString().Split(',');

                dgListItem.DataSource = dsShipListData.Tables[0].DefaultView.ToTable();
                pager.InitPager(dgListItem, pageSize);


                if (dsShipListData.Tables[0].Rows.Count == 0)
                    BindMessage("No records found.", true);

                pnlGrid.Update();
                pnlTotal.Update();
            }
 
        }

        private void BindMessage(string message, bool errorFlag)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = (errorFlag) ? System.Drawing.Color.Red : System.Drawing.Color.Green;
            pnlProgress.Update();
        }

        private void SetDefaults()
        {
            dpStartDt.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
            dpEndDt.SelectedDate = DateTime.Now.ToShortDateString();
            ddlUserId.SelectedValue = Session["UserName"].ToString();
            ddlLocation.SelectedValue = Session["BranchId"].ToString();            
            tblTotal.Visible = false;

            if(Session["ShipListSecurity"].ToString() == "")
                ibtnAddList.Visible =false;

            ibtnSearchList_Click(ibtnCancel, new ImageClickEventArgs(0, 0));
        }

        #endregion

        #region Ajax Methods

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public bool StoreDetailIDInSession(string plistDetailId, bool chkSelectStatus)
        {
            // if the quoteid is already in the session remove it first
            if (Session["ListDetailIDSelected"] != null)
            {
                Session["ListDetailIDSelected"] = Session["ListDetailIDSelected"].ToString().Replace("," + plistDetailId, "");
            }

            if (chkSelectStatus)
            {
                // Store the value in session to retore value after paging
                Session["ListDetailIDSelected"] += "," + plistDetailId;
            }

            return true;
        }

        #endregion

        #region DB Helper Methods

        private void BindDropDowns()
        {
            DataSet dsDLLData = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pWhseShipListFrm]",
                                new SqlParameter("@source", "getdropdowns"),
                                new SqlParameter("@searchFilter", ""));

            if (dsDLLData != null)
            {
                ddlBind _ddlBind = new ddlBind();
                _ddlBind.ddlBindControl(ddlLocation, dsDLLData.Tables[0], "LocID", "Name", "", "");
                ddlLocation.Items.Insert(0, new ListItem("ALL", ""));

                _ddlBind.ddlBindControl(ddlUserId, dsDLLData.Tables[1], "UserId", "Name", "", "");
                ddlUserId.Items.Insert(0, new ListItem("ALL", ""));
            }

        }

        private DataSet GetShipListData(string mode, string listName, string locCd, string entryId,string listType, string startDt, string endDt, string pListHdrId)
        {
            DataSet dsShipData = SqlHelper.ExecuteDataset(Global.ShipLiveConnectionString, "[pWhseGetShippingList]",
                                new SqlParameter("@mode", mode),
                                new SqlParameter("@listName", listName),
                                new SqlParameter("@locCd", locCd),
                                new SqlParameter("@entryId", entryId),
                                new SqlParameter("@listType", listType),
                                new SqlParameter("@startDt", startDt),
                                new SqlParameter("@endDt", endDt),
                                new SqlParameter("@plistHdrId", pListHdrId));
            return dsShipData;

        }

        #endregion

    } // End Class

}// End Namespace
