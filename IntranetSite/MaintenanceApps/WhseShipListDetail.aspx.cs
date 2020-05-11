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
#endregion

namespace PFC.Intranet.ListMaintenance
{
    public partial class _WhseShipListDetail : System.Web.UI.Page
    {
        #region  Valiable Declaration
        
        int pageSize = 12;
        string pListId = "";
        string listTypeValue = "";
        
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
            Ajax.Utility.RegisterTypeForAjax(typeof(_WhseShipListDetail));
            pListId = Request.QueryString["ListId"].ToString();
            listTypeValue = Request.QueryString["ListTypeValue"].ToString();
            lblListMsg.Visible = false;
            BindMessage("", false);    
        
            if (!Page.IsPostBack)
            {
                lblListName.Text = Request.QueryString["ListName"].ToString();
                lblLocation.Text = Request.QueryString["Location"].ToString();
                lblEntryID.Text = Request.QueryString["EntryID"].ToString();
                lblEntryDt.Text = Request.QueryString["EntryDt"].ToString();
                lblChangeId.Text = Request.QueryString["ChangeID"].ToString();
                lblChangeDt.Text = Request.QueryString["ChangeDt"].ToString();

                if (Session["ShipListSecurity"].ToString() == "")
                {
                    lblBtnHeader.Text += " [Query Only]";
                }
                if (listTypeValue == "D")
                    lblListType.Visible = true;

                // Final Dest City
                string[] _listNameArr = lblListName.Text.Split('-');
                for (int i = 1; i <= _listNameArr.Length - 2; i++)
                {
                    ViewState["FinalDestCity"] += _listNameArr[i];
                }

                SetDefaults();
                BindDataGrid();
            }

        }

        #endregion

        #region Event Handlers

        protected void btnAddItem_Click(object sender, ImageClickEventArgs e)
        {
            // Do Validation
            if (txtNewDocNo.Text.Trim() == "")
            {
                ScriptManager.RegisterClientScriptBlock(btnAddItem, btnAddItem.GetType(), "DocNoValidation", "alert('Document No Required.');", true);
                scmListDtl.SetFocus(txtNewDocNo);
                return;
            }

            // Clear Controls
            txtExistingDocNo.Text = txtExistingPalletNo.Text = lblItemDesc.Text = hidpListdtlId.Value = "";

            // Check DocNo/PalletNo Record Already Exist in SHIPLIVE DB
            DataSet _dsShipListDetail = GetShipListData("CheckItemExist", txtNewPalletNo.Text, txtNewDocNo.Text, "", "", "", "", "", "", "", pListId, "", "", "", "", "", "");
            
            if (_dsShipListDetail != null && _dsShipListDetail.Tables[0].Rows.Count > 0)
            {
                if (_dsShipListDetail.Tables[0].Rows[0]["ErrorMsg"].ToString() == "")
                {
                    hidpListdtlId.Value = _dsShipListDetail.Tables[0].Rows[0]["pShipListDetailID"].ToString();
                    txtExistingDocNo.Text = _dsShipListDetail.Tables[0].Rows[0]["OrderNo"].ToString();
                    txtExistingPalletNo.Text = _dsShipListDetail.Tables[0].Rows[0]["PalletNo"].ToString();
                    lblItemDesc.Text = _dsShipListDetail.Tables[0].Rows[0]["CustNo"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + _dsShipListDetail.Tables[0].Rows[0]["CustName"].ToString() +
                                        "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + _dsShipListDetail.Tables[0].Rows[0]["ShipWght"].ToString() + " Lbs";
                    
                    txtNewDocNo.Text = "";
                    BindMessage("Item already exist in this list.", false);
                    scmListDtl.SetFocus(txtNewDocNo);
                }
                else
                {
                    if (_dsShipListDetail.Tables[0].Rows[0]["ListStatus"].ToString().ToLower() == "closed")
                    {
                        BindMessage(_dsShipListDetail.Tables[0].Rows[0]["ErrorMsg"].ToString(), true);
                        
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(btnAddItem, 
                                                                btnAddItem.GetType()
                                                                , "showconfirm"
                                                                , "ShowShpDetailDeleteConfirmation('" + _dsShipListDetail.Tables[0].Rows[0]["pShipListDetailID"].ToString() + "','" + _dsShipListDetail.Tables[0].Rows[0]["ListName"].ToString() + "');", true);
                    }

                    scmListDtl.SetFocus(txtNewDocNo);                    
                }
            }
            else
            {
                // Check user entered valid Doc No
                // If valid then add it to SHIPLIVE DB
                // Else display error msg
                DataSet _dsDocData = ValidateDocNo(txtNewDocNo.Text);
                if (_dsDocData != null && _dsDocData.Tables[0].Rows.Count > 0)
                {
                    try
                    {
                        // Add new record to ShipLive DB
                        GetShipListData("AddItem"
                                        , txtNewPalletNo.Text
                                        , txtNewDocNo.Text
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Wght"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Cust_Num"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Name"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_City"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Prov"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Cust_Po"].ToString()
                                        , ""
                                        , pListId
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Add1"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Add2"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Zip"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Cntry"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_Attn"].ToString()
                                        , _dsDocData.Tables[0].Rows[0]["Ship_TelNo"].ToString());
                        
                        BindMessage(addMessage, false);
                        BindDataGrid();
                        UpdateParentGrid();
                        txtNewDocNo.Text = "";
                        scmListDtl.SetFocus(txtNewDocNo);
                    }
                    catch (Exception ex)
                    {
                        BindMessage(ex.Message.ToString(), true);
                    }
                }
                else
                {
                    BindMessage("Document does not exist in WMS, it cannot be added to a list.", true);
                    scmListDtl.SetFocus(txtNewDocNo);
                }
            }
        }

        protected void ibtnUpdateLine_Click(object sender, ImageClickEventArgs e)
        {
            // Do Validation
            if (txtExistingDocNo.Text.Trim() == "")
            {
                ScriptManager.RegisterClientScriptBlock(ibtnUpdateLine, ibtnUpdateLine.GetType(), "ExistingDocNoValidation", "alert('Document No Required.');", true);
                scmListDtl.SetFocus(txtExistingDocNo);
                return;
            }

            try
            {
                GetShipListData("UpdateLine", txtExistingPalletNo.Text, txtExistingDocNo.Text, "", "", "", "", "", "", hidpListdtlId.Value, pListId, "", "", "", "", "", "");
                BindMessage(updateMessage, false);
                BindDataGrid();

                ScriptManager.RegisterClientScriptBlock(ibtnUpdateLine, ibtnUpdateLine.GetType(), "updateparentgrid", "RefreshParent();", true);
                txtExistingDocNo.Text = txtExistingPalletNo.Text = lblItemDesc.Text = txtNewDocNo.Text = "";
                scmListDtl.SetFocus(txtNewDocNo);
            }
            catch (Exception ex)
            {
                BindMessage(ex.Message, true);
                scmListDtl.SetFocus(txtExistingDocNo);
            }
        }

        protected void btnDelete_Click(object sender, ImageClickEventArgs e)
        {
            if (txtExistingDocNo.Text.Trim() != "")
            {
                GetShipListData("DeleteLine", "", "", "", "", "", "", "", "", hidpListdtlId.Value, pListId, "", "", "", "", "", "");
                BindDataGrid();
                UpdateParentGrid();
                SetDefaults();
                BindMessage(deleteMessage, false);
            }
        }

        protected void dgListItem_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton _lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
                LinkButton _lnkEdit = e.Item.FindControl("lnkEdit") as LinkButton;
                TextBox _txtPalletNo = e.Item.FindControl("txtPalletNo") as TextBox;

                if (Session["ShipListSecurity"].ToString() == "" || listTypeValue == "D")
                {
                    _lnkDelete.Visible = false;
                    _lnkEdit.Visible = false;
                    _txtPalletNo.ReadOnly = true;
                }
            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                DataTable dtListDetail = ViewState["ListDetail"] as DataTable;
                
                e.Item.Cells[8].Text = dtListDetail.Compute("Sum(ShipWght)", "").ToString();
                e.Item.Cells[1].Visible = false;
                e.Item.Cells[0].ColumnSpan = 2;
                e.Item.Cells[0].Text = "Grand Total";
                
            }
        }

        protected void dgListItem_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                hidpListdtlId.Value = e.CommandArgument.ToString().Trim();
                TextBox _txtPalletNo = e.Item.FindControl("txtPalletNo") as TextBox;         

                lblItemDesc.Text = e.Item.Cells[3].Text + "&nbsp;&nbsp;&nbsp;&nbsp;" + e.Item.Cells[4].Text + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + e.Item.Cells[8].Text + " Lbs";
                txtExistingDocNo.Text = (e.Item.Cells[1].Text == "&nbsp;") ? "" : e.Item.Cells[1].Text;
                txtExistingPalletNo.Text = _txtPalletNo.Text;
            }
            else if (e.CommandName == "Delete")
            {
                GetShipListData("DeleteLine", "", "", "", "", "", "", "", "", e.CommandArgument.ToString().Trim(), pListId, "", "", "", "", "", "");
                BindDataGrid();
                UpdateParentGrid();
                SetDefaults();
                BindMessage(deleteMessage, false);
            }

            pnlSearchList.Update();
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

        }

        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            SetDefaults();
        }

        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dgListItem.CurrentPageIndex = pager.GotoPageNumber;            
            BindDataGrid();
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

            //DataSet _dsShipListData = GetShipListData("search", txtSearchListName.Text, ddlLocation.SelectedValue, ddlUserId.SelectedValue, ddlListType.SelectedValue, dpStartDt.SelectedDate, dpEndDt.SelectedDate);
            BindDataGrid();
        }

        #endregion

        #region Developer Methods

        private void BindDataGrid()
        {
            DataSet _dsShipListDetail = GetShipListData("GetGridLines", "", "", "", "", "", "", "", "", "", pListId, "", "", "", "", "", "");

            if (_dsShipListDetail != null)
            {
                if (hidSort.Value != "")
                    _dsShipListDetail.Tables[0].DefaultView.Sort = hidSort.Value;

                dgListItem.ShowFooter = (_dsShipListDetail.Tables[0].DefaultView.ToTable().Rows.Count == 0) ? false : true;
                
                ViewState["ListDetail"] = _dsShipListDetail.Tables[0].DefaultView.ToTable();
                dgListItem.DataSource = _dsShipListDetail.Tables[0].DefaultView.ToTable();
                pager.InitPager(dgListItem, pageSize);
                pnlGrid.Update();
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
             txtNewDocNo.Text =  txtExistingDocNo.Text = txtExistingPalletNo.Text = lblItemDesc.Text = "";
             scmListDtl.SetFocus(txtNewDocNo);

             if (Session["ShipListSecurity"].ToString() == "" || listTypeValue == "D")             
                 btnAddItem.Visible = btnDelete.Visible = ibtnUpdateLine.Visible = false;             
        }

        private void UpdateParentGrid()
        {
            ScriptManager.RegisterClientScriptBlock(ibtnUpdateLine, ibtnUpdateLine.GetType(), "updateparentgrid", "RefreshParent();", true);
        }

        #endregion

        #region Ajax Methods

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string UpdatePalletNumber(string pListDetailId,string palletNo,string docNo, string fListId)
        {
            string result = "";

            DataSet _dsShipListDetail = GetShipListData("CheckItemExist", palletNo, docNo, "", "", "", "", "", "", "", fListId, "", "", "", "", "", "");
            if (_dsShipListDetail != null && _dsShipListDetail.Tables[0].Rows.Count > 0)
            {
                result = "Pallet No already exist.";
            }
            else
            {
                GetShipListData("UpdateLine", palletNo, docNo, "", "", "", "", "", "", pListDetailId, "", "", "", "", "", "", "");
            }

            return result;
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public bool DeleteExistingDetailLine(string pListDetailId)
        {
            try
            {
                GetShipListData("DeleteLine", "", "", "", "", "", "", "", "", pListDetailId, "", "", "", "", "", "", "");
                return true;
            }
            catch (Exception ex)
            {
                
                return false;
            }                   
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public string[] CheckOrderAlreadyExist(string docNo, string _pListId)
        {
            string[] _result = new string[10];
            _result[0] = ""; // Error Msg

            // Check DocNo/PalletNo Record Already Exist in SHIPLIVE DB
            DataSet _dsShipListDetail = GetShipListData("CheckItemExist", "", docNo, "", "", "", "", "", "", "", _pListId, "", "", "", "", "", "");
            
            if (_dsShipListDetail != null && _dsShipListDetail.Tables[0].Rows.Count > 0)
            {
                if (_dsShipListDetail.Tables[0].Rows[0]["ErrorMsg"].ToString() != "")
                {
                    if (_dsShipListDetail.Tables[0].Rows[0]["ListStatus"].ToString().ToLower() == "closed")
                    {
                        _result[0] = "";                        
                    }
                    else
                    {
                        _result[0] = _dsShipListDetail.Tables[0].Rows[0]["ErrorMsg"].ToString();
                        _result[1] = _dsShipListDetail.Tables[0].Rows[0]["pShipListDetailID"].ToString();
                        _result[2] = _dsShipListDetail.Tables[0].Rows[0]["ListName"].ToString();
                    }                                      
                }
            }

            return _result;


        }
        #endregion

        #region DB Helper Methods

        private DataSet GetShipListData(string mode
                                        ,string palletNo
                                        ,string docNo
                                        ,string shipWght
                                        ,string custNo
                                        ,string custName
                                        ,string city
                                        ,string state
                                        ,string custPONo
                                        ,string pListDtlId
                                        ,string fListId
                                        ,string shipAddr1
                                        ,string shipAddr2
                                        ,string shipToZip
                                        ,string shipToCountry
                                        ,string shipToContact
                                        ,string shipToPhone)
        {
            DataSet dsShipData = SqlHelper.ExecuteDataset(Global.ShipLiveConnectionString, "[pWhseShippingListDetail]",
                                new SqlParameter("@mode", mode),
                                new SqlParameter("@pListId", pListDtlId),
                                new SqlParameter("@palletNo", palletNo),
                                new SqlParameter("@docNo", docNo),
                                new SqlParameter("@fShipListHeaderID", fListId),
                                new SqlParameter("@shipWght", shipWght),
                                new SqlParameter("@entryID", Session["UserName"].ToString()),
                                new SqlParameter("@custNo", custNo),
                                new SqlParameter("@custName", custName),
                                new SqlParameter("@city", city),
                                new SqlParameter("@state", state),
                                new SqlParameter("@custPONo", custPONo),
                                new SqlParameter("@finalDest", (ViewState["FinalDestCity"] != null ? ViewState["FinalDestCity"].ToString() : "")),
                                new SqlParameter("@shipAddr1", shipAddr1),
                                new SqlParameter("@shipAddr2", shipAddr2),
                                new SqlParameter("@shipToZip", shipToZip),
                                new SqlParameter("@shipCountry", shipToCountry),
                                new SqlParameter("@shipToContact", shipToContact),
                                new SqlParameter("@shipToPhone", shipToPhone));
            return dsShipData;

        }

        private DataSet ValidateDocNo(string docNo)
        {
            DataSet dsDocData = SqlHelper.ExecuteDataset(Global.RBConnectionString, "[pWhseValidateDocNo]",                                
                                    new SqlParameter("@docNo", docNo));
            return dsDocData;

        }


        #endregion

        
} // End Class

}// End Namespace
