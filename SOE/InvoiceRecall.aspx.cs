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


public partial class InvoiceRecall : System.Web.UI.Page
{
    Utility utility = new Utility();
    InvoiceReCall invoiceCall = new InvoiceReCall();

    string invalidMessage = "Bill To Number does not match";
    string noRecordMessage = "No Records Found";
    string queryMessage = "Query Completed Successfully";

    string whereClause = "";
    string NOInvoice = "";
    
    DataTable dt;

    protected void Page_Load(object sender, EventArgs e)
    {
        //Session ["UserName"]="intranet";
        Session["SecurityCode"] = invoiceCall.GetSecurityCode(Session["UserName"].ToString());

        if (!IsPostBack)
        {
            NOInvoice = txtInvoiceNumber.Text = Request.QueryString["InvoiceNo"].ToString();
            hidInvoice.Value = NOInvoice.Trim();          
            BindData(); 
         
        }
        lnkBillTo.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
     

        SecurityCheck();
        upnlBillInfo.Update();
        upnlInvoiceGrid.Update();
    }

    private void SecurityCheck()
    {
        if (Session["SecurityCode"].ToString() == "")
        {
            PrintDialogue1.Visible = false;
        }
    }
    private void BindData()
    {

        DataTable dtInvoice = invoiceCall.GetBillTo(NOInvoice.Trim());

        if (dtInvoice != null && dtInvoice.Rows.Count > 0)
        {
            lblBillCustName.Text = dtInvoice.Rows[0]["CustName"].ToString();
            lblBillCustNo.Text = dtInvoice.Rows[0]["CustNo"].ToString();
            lblBillToFax.Text = dtInvoice.Rows[0]["FaxPhoneNo"].ToString();
            lblCustCom.Visible = ((lblBillCustNo.Text.Trim() != "" && lblBillToFax.Text.Trim() != "") ? true : false);
            lblBillToMail.Text = dtInvoice.Rows[0]["Email"].ToString();
            lblEntryDate.Text = dtInvoice.Rows[0]["EntryDt"].ToString() == "" ? "" : Convert.ToDateTime(dtInvoice.Rows[0]["EntryDt"].ToString()).ToShortDateString();
            lblEntryID.Text = dtInvoice.Rows[0]["EntryID"].ToString();
            lblChangeID.Text = dtInvoice.Rows[0]["ChangeID"].ToString();
            lblChangeDate.Text = dtInvoice.Rows[0]["ChangeDt"].ToString() == "" ? "" : Convert.ToDateTime(dtInvoice.Rows[0]["ChangeDt"].ToString()).ToShortDateString();

            if (hidCust.Value  =="" || hidCust.Value == lblBillCustNo.Text)
            {
                if (txtInvoiceNumber.Text != " ")
                {
                    ViewState["Invoice"] += "'" + txtInvoiceNumber.Text + "'" + "|";
                }
                string invoiceNo = CreateTable();
                whereClause = "InvoiceNo in ( " + invoiceNo + " )";

                BindGrid(whereClause);
                ViewState["WhereClause"] = whereClause;
                ViewState["WhereCondition"] = whereClause.Replace(",", "|").Replace("'", "`");
                string imageInvoice=GetInvoiceNo();

                PrintDialogue1.CustomerNo = lblBillCustNo.Text;
                PrintDialogue1.PageTitle = "Invoice Recall  for  " + lblBillCustNo.Text;
                //Export page with image
                string TempUrl = "InvoiceRecallImageExport.aspx?InvoiceNo="+imageInvoice;
                //Export Print Page
                //string TempUrl = "InvoiceRecallExport.aspx?WhereClause=" + ViewState["WhereCondition"].ToString() + "&InvoiceNo=" + hidInvoice.Value.Trim();
                PrintDialogue1.PageUrl = Server.UrlEncode(TempUrl);
                
            }
            else
            {
                utility.DisplayMessage(MessageType.Failure, invalidMessage, lblMessage);
                upMessage.Update();
            }

        }
        else      
        {
            utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
            upMessage.Update();
        }
        txtInvoiceNumber.Text = "";
        upnlBillInfo.Update();
        upnlInvoiceGrid.Update();
    }
    private void BindGrid(string whereClause)
    {
        if (hidCust.Value == "")
            hidCust.Value = lblBillCustNo.Text;
        if (hidCust.Value.Trim() == lblBillCustNo.Text.Trim())
        {
            //whereClause = "";

            DataTable dtInvoiceGrid = invoiceCall.GetInvoice(whereClause);
            if (dtInvoiceGrid != null)
            {
                dtInvoiceGrid.DefaultView.Sort = (hidSortInvoice.Value == "") ? "InvoiceNo desc" : hidSortInvoice.Value;

                gvInvoice.DataSource = dtInvoiceGrid;
                gvInvoice.DataBind();
                utility.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
                upMessage.Update();
            }
        }
    }
    private string GetInvoiceNo()
    {
        string imageInvoiceNo = "";
        ArrayList invoiceNo = new ArrayList();
        foreach (GridViewRow gvrRecall in gvInvoice.Rows)
        {
            LinkButton lnk = (LinkButton)gvrRecall.FindControl("lnkInvoiceNo");
            invoiceNo.Add(lnk.Text); 
        }
        foreach (object item in invoiceNo)
        {
            imageInvoiceNo = item.ToString() + "|";
            
        }
        return imageInvoiceNo.Remove(imageInvoiceNo.Length - 1, 1);
    }
    protected void txtInvoiceNumber_TextChanged(object sender, EventArgs e)
    {
        ClearControl();
        hidInvoice.Value=NOInvoice= txtInvoiceNumber.Text;
        BindData();
        
    }
    
    public string CreateTable()
    {
        string invoice = ViewState["Invoice"].ToString().Replace("|", ",");
        return invoice.Remove(invoice.Length - 1, 1);
    }

    private void ClearControl()
    { 
        lblBillCustName.Text =lblBillCustNo.Text =lblBillToFax.Text = " ";
        lblBillToMail.Text = "";
        lblCustCom.Visible = false;           
    }

    protected void gvInvoice_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "BindInvoice")
        {
            LinkButton lnk = e.CommandSource as LinkButton;
            string invoice = lnk.Text;
            lnk.Attributes.Add("onclick", "javascript:OpenInvoice('" + invoice + "','"+hidCust.Value+"');");
        }
    }
    protected void gvInvoice_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (hidSortInvoice.Attributes["sortType"] != null)
        {
            if (hidSortInvoice.Attributes["sortType"].ToString() == "ASC")
                hidSortInvoice.Attributes["sortType"] = "DESC";
            else
                hidSortInvoice.Attributes["sortType"] = "ASC";
        }
        else
            hidSortInvoice.Attributes.Add("sortType", "ASC");

        hidSortInvoice.Value = e.SortExpression + " " + hidSortInvoice.Attributes["sortType"].ToString();
       // BindData(ViewState["WhereClause"].ToString());
        BindGrid(ViewState["WhereClause"].ToString());
       
    }
}
