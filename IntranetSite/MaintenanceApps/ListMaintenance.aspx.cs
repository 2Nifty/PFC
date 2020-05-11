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
using PFC.Intranet.BusinessLogicLayer;
#endregion

namespace PFC.Intranet.ListMaintenance
{
    public partial class _ListMaintenance : System.Web.UI.Page
    {
        #region  Valiable Declaration
        ListMaintenanceLayer listMaintenance = new ListMaintenanceLayer();
        DataSet dsListMaster = new DataSet();
        DataSet dsListDetail = new DataSet();
        #endregion

        #region Constant Variables
        string updateMessage = "Data has been successfully updated.";
        string addMessage = "Data has been successfully added.";
        string deleteMessage = "Data has been successfully deleted.";
        string listMessage = "List Name already exist.";
        string itemMessage = "Item Name already exist.";
        string glAccountMessage = "Select GL Account";

        string dtllistTable = "ListDetail";
        string mstrlistTable = "ListMaster";
        #endregion

        #region Properties
        /// <summary>
        /// MasterMode Read/Write Property : Add/Edit Mode for ListMaster
        /// </summary>
        public string MasterMode
        {
            get { return hidMstrMode.Value; }
            set
            {
                hidMstrMode.Value = value;
                pnlHidValue.Update();
            }
        }
        /// <summary>
        /// DetailMode Read/Write Property : Add/Edit Mode for ListDetail
        /// </summary>
        public string DetailMode
        {
            get { return hidDtlMode.Value; }
            set
            {
                hidDtlMode.Value = value;
                tblDetailEntry.Visible = true;
                pnlListDetail.Update();
                pnlHidValue.Update();
            }
        }
        /// <summary>
        /// UserName ReadOnly Property : Get current User name
        /// </summary>
        public string UserName
        {
            get
            {
                return Session["UserName"].ToString();
            }
        }
        /// <summary>
        /// ShortDateTime ReadOnly Property : Get current short date
        /// </summary>
        public string ShortDateTime
        {
            get
            {
                return DateTime.Now.ToShortDateString().Trim();
            }
        }
        /// <summary>
        /// ListMasterID ReadOnly Property : Get current List Master ID
        /// </summary>
        public string ListMasterID
        {
            get
            {
                return ddlListSelection.SelectedValue;
            }
        }
        /// <summary>
        /// DetailMode Read/Write Property : Set/Get current List detail ID
        /// </summary>
        public string ListDetailID
        {
            set
            {
                hidDetailID.Value = value;
            }
            get
            {
                return hidDetailID.Value;
                pnlHidValue.Update();
            }

        }
        /// <summary>
        /// ListSecurity ReadOnly Property : Get current user's security Code
        /// </summary>
        protected string ListSecurity
        {
            get
            {
                return Session["ListSecurity"].ToString();
            }
        }
        #endregion

        #region Page Load Event

        /// <summary>
        /// Listmaintenance :Page Load event handlers
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            lblListMsg.Visible = false;
            BindMessage("", false);
            lnkListMaster.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
            if (!Page.IsPostBack)
            {
                Session["ListSecurity"] = listMaintenance.GetSecurityCode(Session["UserName"].ToString());
                SetTabIndex();
                BindMasterSearch("");
                AllowDetailAccess(false);
                MasterMode = "Add";
                listMaintenance.FillGLAccount(ddlGLAccount);
            }

        }
        #endregion

        #region List Search
        /// <summary>
        /// ddlListSelection onchange event handler - to fill List details
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">EventArgs</param>
        protected void ddlListSelection_SelectedIndexChanged(object sender, EventArgs e)
        {

            MasterMode = "Edit";
            DetailMode = "Add";

            AllowDetailAccess(true);
            BindMasterValues();
            ClearDetailEntry();
            BindDetailValues();
            if (ListSecurity == "")
                ibtnListSave.Visible = false;

            ScriptManager.RegisterClientScriptBlock(txtListDesc, txtListDesc.GetType(), "DescFocus", "document.getElementById('" + txtListDesc.ClientID + "').select();document.getElementById('" + txtListDesc.ClientID + "').focus();", true);

        }
        #endregion

        #region List Master Handlers
        /// <summary>
        /// ListMaster Save event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnListSave_Click(object sender, ImageClickEventArgs e)
        {

            string columnValues = " ";
            if (MasterMode == "Add")
            {
                DataSet dsMaster = listMaintenance.GetDataToDateset(mstrlistTable, "ListName", "ListName='" + txtListName.Text.Trim().Replace("'", "''") + "'");
                if (dsMaster == null || dsMaster.Tables[0].Rows.Count == 0)
                {
                    columnValues = "'" + txtListName.Text.Trim().Replace("'", "''") + "'," +
                                                "'" + txtListDesc.Text.Trim().Replace("'", "''") + "'," +
                                                "'" + txtListComments.Text.Trim().Trim().Replace("'", "''") + "'," +
                                                "'" + ((chkListType.Items[0].Selected) ? "Y" : "N") + "'," +
                                                "'" + ((chkListType.Items[1].Selected) ? "Y" : "N") + "'," +
                                                "'" + ((chkListType.Items[2].Selected) ? "Y" : "N") + "'," +
                                                "'" + UserName + "'," +
                                                "'" + ShortDateTime + "'," +
                                                "'" + UserName + "'," +
                                                "'" + ShortDateTime + "'";
                    object listMasterID = listMaintenance.InsertListMaster(columnValues);
                    if (listMasterID != null && listMasterID.ToString() != "")
                    {
                        BindMasterSearch(listMasterID.ToString());
                        AllowDetailAccess(true);
                        BindMessage(addMessage, false);
                    }
                }
                else
                {
                    BindMessage(listMessage, true);
                }
            }
            else if (MasterMode == "Edit")
            {
                columnValues = "ListDesc='" + txtListDesc.Text.Trim().Replace("'", "''") + "'," +
                               "Comments='" + txtListComments.Text.Trim().Replace("'", "''") + "'," +
                               "[SystemRequiredInd]='" + ((chkListType.Items[0].Selected) ? "Y" : "N") + "'," +
                               "UserOptionInd='" + ((chkListType.Items[1].Selected) ? "Y" : "N") + "'," +
                               "ListStatusCd='" + ((chkListType.Items[2].Selected) ? "Y" : "N") + "'," +
                               "ChangeID='" + UserName + "'," +
                               "ChangeDt='" + ShortDateTime + "'";

                listMaintenance.UpdateListMaster(columnValues, ListMasterID);
                BindMasterSearch(ListMasterID);
                BindMessage(updateMessage, false);
            }
            DetailMode = "Add";
        }
        /// <summary>
        /// ListMaster Add event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnListAdd_Click(object sender, ImageClickEventArgs e)
        {
            ClearValuesforAddMode();
            ibtnListSave.Visible = true;
        }
        /// <summary>
        /// ListMaster delete event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnListDelete_Click(object sender, ImageClickEventArgs e)
        {
            if (ddlListSelection.SelectedIndex > 0)
            {
                listMaintenance.DeleteListMaster(ListMasterID);
                BindMasterSearch("");
                ClearValuesforAddMode();
                BindMessage(deleteMessage, false);
            }
        }
        #endregion

        #region List Detail Handlers
        /// <summary>
        /// List detail Add handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">ImageClickEventArgs</param>
        protected void ibtnItemAdd_Click(object sender, ImageClickEventArgs e)
        {
            ClearDetailEntry();
            DetailMode = "Add";
            lblListMsg.Visible = (dgItem.Items.Count > 0) ? false : true;
        }
        /// <summary>
        /// List detail close handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">ImageClickEventArgs</param>
        protected void ibtnItemClose_Click(object sender, ImageClickEventArgs e)
        {
            tblDetailEntry.Visible = false;
        }
        /// <summary>
        /// List detail save handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">ImageClickEventArgs</param>
        protected void ibtnItemSave_Click(object sender, ImageClickEventArgs e)
        {

            string columnValues = " ";
            if (DetailMode == "Add")
            {
                DataSet dsDetail = listMaintenance.GetDataToDateset(dtllistTable, "ListValue", "ListValue='" + txtItem.Text.Trim().Replace("'", "''") + "' and fListMasterID=" + ListMasterID);
                if (dsDetail == null || dsDetail.Tables[0].Rows.Count == 0)
                {
                    columnValues = "'" + ListMasterID + "'," +
                                     "'" + txtItem.Text.Trim().Replace("'", "''") + "'," +
                                     "'" + txtItemDesc.Text.Trim().Replace("'", "''") + "'," +
                                     "'" + txtSequence.Text.Trim().Trim().Replace("'", "''") + "'," +
                                     "'" + ddlGLAccount.SelectedValue + "'," +
                                     "'" + UserName + "'," +
                                     "'" + ShortDateTime + "'," +
                                     "'" + UserName + "'," +
                                     "'" + ShortDateTime + "'";

                    object listDetailID = listMaintenance.InsertListDetails(columnValues);
                    if (listDetailID != null && listDetailID.ToString() != "")
                    {
                        BindDetailValues();
                        BindMessage(addMessage, false);
                        ClearDetailEntry();
                        DetailMode = "Add";
                    }
                }
                else
                    BindMessage(itemMessage, true);
            }
            else if (DetailMode == "Edit")
            {
                DataSet dsDetail = listMaintenance.GetDataToDateset(dtllistTable, "ListValue", "ListValue='" + txtItem.Text.Trim().Replace("'", "''") + "' and fListMasterID=" + ListMasterID + " and pListDetailID <>" + ListDetailID);
                if (dsDetail == null || dsDetail.Tables[0].Rows.Count == 0)
                {
                    columnValues = "ListValue='" + txtItem.Text.Trim().Replace("'", "''") + "'," +
                                   "ListDtlDesc='" + txtItemDesc.Text.Trim().Replace("'", "''") + "'," +
                                   "SequenceNo='" + txtSequence.Text.Trim().Replace("'", "''") + "'," +
                                   "GLAccountNo='" + ddlGLAccount.SelectedValue + "'," +
                                   "ChangeID='" + UserName + "'," +
                                   "ChangeDt='" + ShortDateTime + "'";

                    listMaintenance.UpdateListDetail(columnValues, ListDetailID);
                    BindDetailValues();
                    ClearDetailEntry();
                    DetailMode = "Add";
                    BindMessage(updateMessage, false);
                }
                else
                    BindMessage(itemMessage, true);
            }



        }
        /// <summary>
        /// List detail edit/delete handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">DataGridCommandEventArgs</param>
        protected void dgItem_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                DetailMode = "Edit";

                ListDetailID = e.CommandArgument.ToString().Trim();

                txtItem.Text = (e.Item.Cells[1].Text == "&nbsp;") ? "" : e.Item.Cells[1].Text;
                txtItemDesc.Text = (e.Item.Cells[2].Text == "&nbsp;") ? "" : e.Item.Cells[2].Text;
                txtSequence.Text = (e.Item.Cells[3].Text == "&nbsp;") ? "" : e.Item.Cells[3].Text;
                ddlGLAccount.SelectedValue = (e.Item.Cells[4].Text == "&nbsp;") ? "0" : e.Item.Cells[4].Text;

            }
            else if (e.CommandName == "Delete")
            {
                DetailMode = "Add";
                listMaintenance.DeleteListDetail(e.CommandArgument.ToString().Trim());
                BindDetailValues();
                ClearDetailEntry();
                BindMessage(deleteMessage, false);
            }
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

        }
        /// <summary>
        /// List detail sort command handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">DataGridSortCommandEventArgs</param>
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
            BindDetailValues();

        }
        /// <summary>
        /// List detail databound handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">DataGridItemEventArgs</param>
        protected void dgItem_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (ListSecurity == "")
                e.Item.Cells[0].Visible = false;
        }
        #endregion

        #region Bind Methods
        /// <summary>
        /// BindMasterValues : used to bind master fields
        /// </summary>
        private void BindMasterValues()
        {
            dsListMaster = listMaintenance.GetMasterRecord(ddlListSelection.SelectedValue.Trim());

            if (dsListMaster != null && dsListMaster.Tables[0].Rows.Count > 0)
            {
                ibtnListSave.Visible = true;
                txtListName.Text = dsListMaster.Tables[0].Rows[0]["ListName"].ToString();
                txtListDesc.Text = dsListMaster.Tables[0].Rows[0]["ListDesc"].ToString();
                txtListComments.Text = dsListMaster.Tables[0].Rows[0]["Comments"].ToString();

                lblChangeDate.Text =(dsListMaster.Tables[0].Rows[0]["ChangeDt"].ToString()=="")?"":Convert.ToDateTime(dsListMaster.Tables[0].Rows[0]["ChangeDt"].ToString()).ToShortDateString();
                lblChangeID.Text = dsListMaster.Tables[0].Rows[0]["ChangeID"].ToString();
                lblEntryDate.Text = (dsListMaster.Tables[0].Rows[0]["EntryDt"].ToString()=="")?"":Convert.ToDateTime(dsListMaster.Tables[0].Rows[0]["EntryDt"].ToString()).ToShortDateString();
                lblEntryID.Text = dsListMaster.Tables[0].Rows[0]["EntryID"].ToString();

                chkListType.Items[0].Selected = (dsListMaster.Tables[0].Rows[0]["SystemRequiredInd"].ToString().Trim() == "Y") ? true : false;
                chkListType.Items[1].Selected = (dsListMaster.Tables[0].Rows[0]["UserOptionInd"].ToString().Trim() == "Y") ? true : false;
                chkListType.Items[2].Selected = (dsListMaster.Tables[0].Rows[0]["ListStatusCd"].ToString().Trim() == "Y") ? true : false;
                txtListName.Enabled = false;
            }
            else
            {
                ClearValuesforAddMode();

            }


            pnlListMaster.Update();


        }
        /// <summary>
        /// BindDetailValues : used to bind List detail fields
        /// </summary>
        private void BindDetailValues()
        {
            dsListDetail = listMaintenance.GetDetailRecord("'" + ddlListSelection.SelectedValue.Trim() + "'");
            dsListDetail.Tables[0].DefaultView.Sort = (hidSort.Value == "") ? "ListValue asc" : hidSort.Value;
            dgItem.DataSource = dsListDetail.Tables[0].DefaultView.ToTable();
            dgItem.DataBind();
            dgItem.Visible = true;
            if (dsListDetail != null && dsListDetail.Tables[0].Rows.Count > 0)
                lblListMsg.Visible = false;
            else
                lblListMsg.Visible = true;

            pnlListDetail.Update();
        }
        /// <summary>
        /// BindMasterSearch : used to bind  List name based on ID fields
        /// </summary>
        /// <param name="listMasterID">List master id</param>
        private void BindMasterSearch(string listMasterID)
        {
            listMaintenance.FillListName(ddlListSelection);

            ddlListSelection.SelectedValue = listMasterID.Trim();
            if (listMasterID != "")
                ddlListSelection_SelectedIndexChanged(ddlListSelection, new EventArgs());
            pnlSearchList.Update();
        }
        /// <summary>
        /// BindMessage :Used to fill confirmation message
        /// </summary>
        /// <param name="message">Message</param>
        /// <param name="errorFlag">error Flag</param>
        private void BindMessage(string message, bool errorFlag)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = (errorFlag) ? System.Drawing.Color.Red : System.Drawing.Color.Green;
            pnlProgress.Update();
        }
        #endregion

        #region Control - Clear methods
        /// <summary>
        /// ClearValuesforAddMode : Used to clear All controls to add new list
        /// </summary>
        private void ClearValuesforAddMode()
        {
            ddlListSelection.SelectedIndex = 0;
            ibtnListSave.Visible = false;
            pnlSearchList.Update();

            txtListName.Enabled = true;
            MasterMode = "Add";
            AllowDetailAccess(false);
            ClearMasterControls();
            ClearDetailControls();
        }
        /// <summary>
        /// ClearMasterControls :Used to clear List master controls
        /// </summary>
        private void ClearMasterControls()
        {
            lblChangeDate.Text = lblChangeID.Text = lblEntryDate.Text = lblEntryID.Text = txtListComments.Text = txtListDesc.Text = txtListName.Text = "";
            chkListType.Items[0].Selected = chkListType.Items[1].Selected = chkListType.Items[2].Selected = false;
            pnlListMaster.Update();
        }
        /// <summary>
        /// ClearDetailControls :Used to clear List detail controls
        /// </summary>
        private void ClearDetailControls()
        {
            ClearDetailEntry();
            dgItem.Visible = false;
            pnlListDetail.Update();
        }
        /// <summary>
        /// ClearDetailEntry :Used to clear List detail entry controls
        /// </summary>
        private void ClearDetailEntry()
        {
            txtItem.Text = txtItemDesc.Text = txtSequence.Text = "";
            ddlGLAccount.SelectedIndex = 0;
        }
        #endregion

        #region Allow user to Access
        /// <summary>
        /// AllowDetailAccess : used to enable controls based on user security code
        /// </summary>
        /// <param name="enableMode"></param>
        private void AllowDetailAccess(bool enableMode)
        {

            enableMode = (ListSecurity == "") ? false : enableMode;

            ibtnListDelete.Visible = ibtnItemAdd.Visible = ibtnItemSave.Visible = enableMode;
            pnlListDetail.Update();

            if (ListSecurity == "")
            {
                ibtnListAdd.Visible = ibtnListDelete.Visible = ibtnListSave.Visible = false;
                tblDetailEntry.Visible = false;
            }
        }
        #endregion

        private void SetTabIndex()
        {
            Page.RegisterStartupScript("SetInitialFocus", "<script>document.getElementById('" + txtListName.ClientID + "').focus();</script>");

            txtListName.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
            "{if ((event.which == 9) || (event.keyCode == 9) || (event.which == 13) || (event.keyCode == 13)) " +
            "{document.getElementById('" + txtListDesc.ClientID +
            "').focus();return false;}} else {return true}; ");
            txtListDesc.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
            "{if ((event.which == 9) || (event.keyCode == 9) ||(event.which == 13) || (event.keyCode == 13)) " +
            "{document.getElementById('" + txtListComments.ClientID +
            "').focus();return false;}} else {return true}; ");

        }

    } // End Class

}// End Namespace
