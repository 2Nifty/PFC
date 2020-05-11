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
using System.Text.RegularExpressions;
#endregion

namespace PFC.Intranet.ListMaintenance
{
    public partial class _WhseShipListConfirm : System.Web.UI.Page
    {
        #region  Valiable Declaration
        
        int pageSize = 19;
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
            Ajax.Utility.RegisterTypeForAjax(typeof(_WhseShipListConfirm));
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

                BindDataGrid();
                scmListDtl.SetFocus(txtNewDocNo);
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

            DataSet _dsShipListDetail = GetShipListData("updateconfirmstatus", "", txtNewDocNo.Text, "", "", "", "", "", "", "", pListId, "", "", "", "", "", "");
            if (_dsShipListDetail != null &&
                _dsShipListDetail.Tables[0].Rows[0]["ErrorMsg"].ToString() != "")
            {
                BindMessage(_dsShipListDetail.Tables[0].Rows[0]["ErrorMsg"].ToString(), true);
            }
            else
            {
                BindMessage("Data has been successfully updated.", false);
            }

            BindDataGrid();

            txtNewDocNo.Text = "";
            scmListDtl.SetFocus(txtNewDocNo);


        }

        protected void dgListItem_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Footer)
            {
                DataTable dtListDetail = Session["ListDetail"] as DataTable;
                
                e.Item.Cells[3].Text = dtListDetail.Compute("Sum(ShipWght)", "").ToString();
                e.Item.Cells[2].Visible = false;
                e.Item.Cells[1].Visible = false;
                e.Item.Cells[0].ColumnSpan = 3;
                e.Item.Cells[0].Text = "Grand Total";
                e.Item.Cells[0].Font.Bold = true;                
            }
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
                
                Session["ListDetail"] = _dsShipListDetail.Tables[0].DefaultView.ToTable();
                dgListItem.DataSource = _dsShipListDetail.Tables[0].DefaultView.ToTable();
                pager.InitPager(dgListItem, pageSize);
                BindPrintDialog();
                pnlGrid.Update();
            }
 
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

        #endregion

        #region Print Methods

        public void BindPrintDialog()
        {
            PrintDialogue1.PageTitle = "Ship List Confirmation - " + Request.QueryString["ListName"].ToString();

            string CPRURL = "MaintenanceApps/WhseShipListConfirmExport.aspx?ListId=" + Request.QueryString["ListId"].ToString() +
                            "&ListTypeValue=" + Request.QueryString["ListTypeValue"].ToString() +
                            "&ListName=" + Request.QueryString["ListName"].ToString() +
                            "&Location=" + Request.QueryString["Location"].ToString()+
                            "&EntryID=" +  Request.QueryString["EntryID"].ToString() +
                            "&EntryDt=" + Request.QueryString["EntryDt"].ToString() +
                            "&ChangeID=" + Request.QueryString["ChangeID"].ToString() +
                            "&ChangeDt=" + Request.QueryString["ChangeDt"].ToString() +
                            "&Sort=" + hidSort.Value;

            PrintDialogue1.EnableFax = false;            
            PrintDialogue1.PageUrl = CPRURL;            
            //ItemDescLabel.Text = CPRURL;
        }

        #endregion

    } // End Class

}// End Namespace
