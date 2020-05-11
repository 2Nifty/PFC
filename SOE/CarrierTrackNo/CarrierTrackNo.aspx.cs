using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.DataAccessLayer;


public partial class CarrierTrackNo : System.Web.UI.Page
{
    SqlConnection cnxERP;
    DataSet dsOrd = new DataSet();
    string strSQL;

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

        //lblStatus.Text = "test";
        //tStatus.Visible = true;
        tStatus.Visible = false;

        if (!Page.IsPostBack)
        {
            //btnClose.Attributes.Add("onclick", "javascript:window.location='" + Request.ServerVariables.Get("HTTP_REFERER") + "'");

            tSOInfo1.Visible = false;
            tSOInfo2.Visible = false;
            //tUpdate.Visible = false;
            divUpdate.Visible = false;
            txtOrderNo.Focus();
        }
    }

    public void GetSO()
    {
        strSQL = "SELECT OrderNo, CustPONo, BOLNO, InvoiceDt, EntryID, ChangeID, ChangeDt, ";
        strSQL += "SellToCustNo, SellToCustName, SellToAddress1, SellToCity, SellToState, SellToZip, SellToCountry, SellToContactPhoneNo, SellToContactName, ";
        strSQL += "BillToCustNo, OrderTermsName, BillToCustName, ";
        strSQL += "ShiptoName, ShipToAddress1, City, State, Zip, Country, PhoneNo, ContactName, ";
        strSQL += "OrderCarrier, OrderCarName ";
        strSQL += "FROM SOHeaderRel WITH (NOLOCK) ";
        strSQL += "WHERE OrderNo=" + txtOrderNo.Text.ToString();

        dsOrd = SqlHelper.ExecuteDataset(cnxERP, CommandType.Text, strSQL);
    }

    public void DisplaySO()
    {
        DataRow OrderRow = dsOrd.Tables[0].DefaultView.ToTable().Rows[0];
        //CSR 06/22/10 Removed Restriction not allowing invoiced to be changed
      //  if (string.IsNullOrEmpty(OrderRow["InvoiceDt"].ToString()) == false)
      //  {
      //      DocInvoiced();
      //      return;
      //  }

        //Sell To Data
        lblSellToName.Text = OrderRow["SellToCustName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["SellToCustNo"].ToString()))
            lblSellToNo.Text = "&nbsp;";
        else
            lblSellToNo.Text = OrderRow["SellToCustNo"].ToString();
        lblSellToAddress1.Text = OrderRow["SellToAddress1"].ToString();
        if (string.IsNullOrEmpty(OrderRow["SellToCity"].ToString()))
            lblSellToAddress2.Text = OrderRow["SellToState"].ToString() + " " + OrderRow["SellToZip"].ToString() + " " + OrderRow["SellToCountry"].ToString();
        else
            lblSellToAddress2.Text = OrderRow["SellToCity"].ToString() + ", " + OrderRow["SellToState"].ToString() + " " + OrderRow["SellToZip"].ToString() + " " + OrderRow["SellToCountry"].ToString();
        lblSellToPhone.Text = OrderRow["SellToContactPhoneNo"].ToString();
        lblSellToContact.Text = OrderRow["SellToContactName"].ToString();

        lblBillToTerms.Text = OrderRow["OrderTermsName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["BillToCustNo"].ToString()))
            lblBillToNo.Text = "&nbsp;";
        else
            lblBillToNo.Text = OrderRow["BillToCustNo"].ToString();
        lblBillToName.Text = OrderRow["BillToCustName"].ToString();

        //Ship To Data
        lblShipToName.Text = OrderRow["ShipToName"].ToString();
        if (string.IsNullOrEmpty(OrderRow["SellToCustNo"].ToString()))
            lblShipToNo.Text = "&nbsp;";
        else
            lblShipToNo.Text = OrderRow["SellToCustNo"].ToString();
        lblShipToAddress1.Text = OrderRow["ShipToAddress1"].ToString();
        if (string.IsNullOrEmpty(OrderRow["City"].ToString()))
            lblShipToAddress2.Text = OrderRow["State"].ToString() + " " + OrderRow["Zip"].ToString() + " " + OrderRow["Country"].ToString();
        else
            lblShipToAddress2.Text = OrderRow["City"].ToString() + ", " + OrderRow["State"].ToString() + " " + OrderRow["Zip"].ToString() + " " + OrderRow["Country"].ToString();
        lblShipToPhone.Text = OrderRow["PhoneNo"].ToString();
        lblShipToContact.Text = OrderRow["ContactName"].ToString();

        lblCustPO.Text = OrderRow["CustPONo"].ToString();
        txtCarTrackNo.Text = OrderRow["BOLNO"].ToString();

        BindListValue("ApprovedCarriers", "-- Select --", ddlCarrier);
        SetValueDropDownList(ddlCarrier, OrderRow["OrderCarrier"].ToString().Trim());

        tStatus.Visible = false;
        tSOInfo1.Visible = true;
        tSOInfo2.Visible = true;
        //tUpdate.Visible = true;
        divUpdate.Visible = true;
        txtCarTrackNo.Focus();
    }

    protected void txtOrderNo_TextChanged(object sender, EventArgs e)
    {
        if (System.Text.RegularExpressions.Regex.IsMatch(txtOrderNo.Text.ToString(), @"\D") || txtOrderNo.Text.ToString() == "")
        {
            DocNotNum();
            return;
        }

        GetSO();

        if (dsOrd.Tables[0].Rows.Count > 0)
            DisplaySO();
        else
            DocNotFound();
    }

    protected void btnUpd_Click(object sender, ImageClickEventArgs e)
    {
        tStatus.Visible = false;

        strSQL = "UPDATE SOHeaderRel SET BOLNO='" + txtCarTrackNo.Text.ToString() + "', ";
        //if (hidCarChng.Value == "true")
        if (ddlCarrier.SelectedIndex > 0)
        {
            strSQL += "OrderCarrier='" + ddlCarrier.SelectedItem.Value.Trim().Replace("'", "''") + "', ";
            strSQL += "OrderCarName='" + ddlCarrier.SelectedItem.Text.Trim().Replace("'", "''") + "', ";
        }
        strSQL += "ChangeID='" + Session["UserName"] + "', ChangeDt=GetDate()";
        strSQL += "WHERE OrderNo=" + txtOrderNo.Text.ToString();

        dsOrd = SqlHelper.ExecuteDataset(cnxERP, CommandType.Text, strSQL);

        //if (hidCarChng.Value == "true")
        if (ddlCarrier.SelectedIndex > 0)
            lblStatus.Text = "Carrier & Tracking Number Updated";
        else
            lblStatus.Text = "Tracking Number Updated";
        tStatus.Visible = true;
        tSOInfo1.Visible = true;
        tSOInfo2.Visible = true;
        //tUpdate.Visible = true;
        divUpdate.Visible = true;
        txtOrderNo.Focus();
    }
    //CSR: This restriction is not used by this program as of June 2010
    public void DocInvoiced()
    {
        lblStatus.Text = "Sales Order already invoiced";
        tStatus.Visible = true;
        tSOInfo1.Visible = false;
        tSOInfo2.Visible = false;
        //tUpdate.Visible = false;
        divUpdate.Visible = false;
        txtOrderNo.Focus();
    }

    public void DocNotNum()
    {
        lblStatus.Text = "Sales Order No. must be numeric";
        tStatus.Visible = true;
        tSOInfo1.Visible = false;
        tSOInfo2.Visible = false;
        //tUpdate.Visible = false;
        divUpdate.Visible = false;
        txtOrderNo.Focus();
    }

    public void DocNotFound()
    {
        lblStatus.Text = "Released Sales Order not found";
        tStatus.Visible = true;
        tSOInfo1.Visible = false;
        tSOInfo2.Visible = false;
        //tUpdate.Visible = false;
        divUpdate.Visible = false;
        txtOrderNo.Focus();
    }

    public void BindListValue(string listName, string defaultString, DropDownList ddlList)
    {
        DataTable dtList = GetListValue(listName);
        if (dtList != null)
        {
            ddlList.DataSource = dtList;
            ddlList.DataValueField = "ListValue";
            ddlList.DataTextField = "ListDesc";
            ddlList.DataBind();
        }
        ddlList.Items.Insert(0, new ListItem(defaultString, ""));
    }

    public DataTable GetListValue(string listName)
    {
        string _whereClause = "CM.SOAppInd = 1 ORDER BY CM.ShortDesc";
        string _tableName = "CarrierMaster CM (NOLOCK) ";
        string _columnName = "CM.Code AS ListValue, CM.ShortDesc AS ListDesc";
        
        //string _whereClause = "LM.ListName = '" + listName + "' AND Tbl.TableType = 'CAR' ORDER BY Tbl.TableCd";
        //string _tableName = "ListMaster LM (NOLOCK) INNER JOIN ListDetail (NOLOCK) LD ON LM.pListMasterID = LD.fListMasterID INNER JOIN Tables (NOLOCK) Tbl ON Tbl.TableCd = LD.ListValue";
        ////string _columnName = "Tbl.TableCd AS ListValue, Tbl.TableCd + ' - ' + Tbl.Dsc AS ListDesc";
        //string _columnName = "Tbl.TableCd AS ListValue, Tbl.Dsc AS ListDesc";
        
        //string _whereClause = "b.plistmasterid=a.flistmasterid and b.listname='" + listName + "' order by a.sequenceno";
        //string _tableName = "listdetail a,listmaster b (NOLOCK) ";
        //string _columnName = "a.ListValue as ListValue,a.ListValue +' - '+ a.ListDtlDesc as 'Desc'";

        DataSet dsListValue = new DataSet();
        dsListValue = SqlHelper.ExecuteDataset(cnxERP, "pSOESelect",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));
        return dsListValue.Tables[0];
    }

    private void SetValueDropDownList(DropDownList ddlControl, String value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }
}
