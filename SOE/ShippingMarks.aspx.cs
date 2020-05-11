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

public partial class ShippingMarks : System.Web.UI.Page
{
    ShippingMark shippingMark = new ShippingMark();
    ExpenseEntry securityCheck = new ExpenseEntry();

    private DataTable dtShipInstruction = new DataTable();
    Utility utility = new Utility();
    private string SONumber;

    protected void Page_Load(object sender, EventArgs e)
    {
        BindName();
        if (!Page.IsPostBack)
        {
            // Security Code ( SOE(W) or ENTRY(W))
            Session["ShippingMarkSecurity"] = securityCheck.GetSecurityCode(Session["UserName"].ToString());
            
            BindShipInstruction();
            BindData();

            PrintDialogue1.CustomerNo = SoHeader.CustNumber;
            PrintDialogue1.PageUrl = Server.UrlEncode("ShippingMarksExport.aspx?SONumber=" + SONumber + "&SOTableName=" + Session["OrderTableName"].ToString());
            PrintDialogue1.PageTitle = "Shipping Mark for " + SONumber;
        }

        if (Session["ShippingMarkSecurity"] == "")
            imgsave.Visible = false;   
    }

    private void BindName()
    {
        SONumber = Request.QueryString["SONumber"].ToString().ToLower().Replace("w", "");
        SoHeader.SONumber = Request.QueryString["SONumber"].ToString().ToLower().Replace("w", "");         
    }

    private void BindData()
    {
        try
        {
            DataTable dsShippingMarks = shippingMark.GetShippingMarks(SONumber);
            if (dsShippingMarks.Rows.Count != 0)
            {
                txtShipMark1.Text = dsShippingMarks.Rows[0]["ShippingMark1"].ToString();
                txtShipMark2.Text = dsShippingMarks.Rows[0]["ShippingMark2"].ToString();
                txtShipMark3.Text = dsShippingMarks.Rows[0]["ShippingMark3"].ToString();
                txtShipMark4.Text = dsShippingMarks.Rows[0]["ShippingMark4"].ToString();
                txtRemarks.Text = dsShippingMarks.Rows[0]["Remarks"].ToString();
                foreach (ListItem item in ddlShippingInstruction.Items)
                {
                    if (item.Text == dsShippingMarks.Rows[0]["ShipInstrCdName"].ToString())
                        item.Selected = true;
                }
                pnlExport.Update();
                hidCustomerName.Value = dsShippingMarks.Rows[0]["SellToCustName"].ToString();
                hidCustomerNumber.Value = dsShippingMarks.Rows[0]["SellToCustNo"].ToString();
                //hidPrintURL.Value = Server.UrlEncode("ShippingMarksExport.aspx?SONumber=" + SONumber);
            }

        }
        catch (Exception ex) { }

    }

    private void BindShipInstruction()
    {
        try
        {
            dtShipInstruction = shippingMark.GetShipInstructionType();
            if (dtShipInstruction.Rows.Count != 0)
            {
                ddlShippingInstruction.DataSource = dtShipInstruction;
                ddlShippingInstruction.DataTextField = "ListDtlDesc";
                ddlShippingInstruction.DataValueField = "ListValue";
                ddlShippingInstruction.DataBind();
            }
            else
            {
                ddlShippingInstruction.Items.Add(new ListItem("N/A","NULL"));
            }

        }
        catch (Exception ex) { }

    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {

            string columnvalues = "shippingMark1 = '" + txtShipMark1.Text.Trim().Replace("'", "''") + "'," +
                                  "shippingMark2='" + txtShipMark2.Text.Trim().Replace("'", "''") + "'," +
                                  "shippingMark3='" + txtShipMark3.Text.Trim().Replace("'", "''") + "'," +
                                  "shippingMark4='" + txtShipMark4.Text.Trim().Replace("'", "''") + "'," +
                                  "ShipInstrCdName='" + ddlShippingInstruction.SelectedItem.Text.ToString().Trim().Replace("'", "''") + "'," +
                                  "ShipInstrCd=" + ddlShippingInstruction.SelectedValue.Trim().Replace("'", "''") + "," +
                                  "Remarks='" + txtRemarks.Text.Trim().Replace("'", "''") + "'";
            shippingMark.UpdateShippingMarks(columnvalues, SONumber);
           
            lblMessage.Text = utility.UpdateMessage;
            pnlInstruction.Update();
            pnlShipMark.Update();
            pnlMessage.Update();


        }
        catch (Exception ex) { }

    }

    protected void imgPrint_Click(object sender, EventArgs e)
    {
        try
        {
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportShippingMarks('Print');", true);
        }
        catch (Exception ex) { }
    }

    protected void imgMail_Click(object sender, EventArgs e)
    {
        try
        {
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Email", "ExportShippingMarks('Email');", true);
        }
        catch (Exception ex) { }
    }

    protected void imgFax_Click(object sender, EventArgs e)
    {
        try
        {
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Fax", "ExportShippingMarks('Fax');", true); ;
        }
        catch (Exception ex) { }
    }

}
