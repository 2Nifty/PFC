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
using PFC.Intranet.DataAccessLayer;

public partial class PalletLabel : System.Web.UI.Page
{
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    GridViewRow row;
    LinkButton RcptLink;
    HiddenField HiddenContainer;
    String LPNNumber;
    String LocNumber;
    DateTime LPNDate;
    DateTime XDocDate;
    LinkButton ContainerLink;
    DataView dv = new DataView();
    BarTender.ApplicationClass btApp;
    BarTender.Format btFormat;
    BarTender.Messages btMsgs;
    BarTender.Databases btBases;
    BarTender.QueryPrompts btQueryPrompts;
    BarTender.QueryPrompt btPrompt;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library
        Ajax.Utility.RegisterTypeForAjax(typeof(PalletLabel));
        if (!IsPostBack)
        {
            updpnlOrder.Visible = false;
            PrintLabel.Visible = false;
            PrintCancel.Visible = false;
        }
        else
        {
        }
    }

    protected void SearchSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            lblSuccessMessage.Text = "";
            lblErrorMessage.Text = "";
            if (txtOrderNumber.Text.Trim().Length == 0)
            {
                lblErrorMessage.Text = "An order number is required.";
            }
            else
            {
                int CheckOrder;
                if (int.TryParse(txtOrderNumber.Text.Trim().ToUpper().Replace("W", ""), out CheckOrder))
                {
                    ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOEGetDoc",
                                       new SqlParameter("@DocNumber", txtOrderNumber.Text.Trim().ToUpper().Replace("W", "")),
                                       new SqlParameter("@SortCode", "L"),
                                       new SqlParameter("@HeaderTable", "SOHeaderRel")
                                       );
                    if (ds.Tables.Count == 1)
                    {
                        lblErrorMessage.Text = "No Records Found.";
                        MessageUpdatePanel.Update();
                    }
                    else
                    {
                        lblOrderNumber.Text = ds.Tables[1].Rows[0]["OrderNo"].ToString();
                        hidOrderNo.Value = ds.Tables[1].Rows[0]["OrderNo"].ToString();
                        lblSellToNo.Text = ds.Tables[1].Rows[0]["SellToCustNo"].ToString();
                        SellToName.Text = ds.Tables[1].Rows[0]["SellToCustName"].ToString();
                        SellToAddr1.Text = ds.Tables[1].Rows[0]["SellToAddress1"].ToString();
                        SellToAddr2.Text = ds.Tables[1].Rows[0]["SellToAddress2"].ToString();
                        SellToCityStZip.Text = ds.Tables[1].Rows[0]["SellToCity"].ToString() + ", "
                            + ds.Tables[1].Rows[0]["SellToState"].ToString() + ".  "
                            + ds.Tables[1].Rows[0]["SellToZip"].ToString();
                        ShipToName.Text = ds.Tables[1].Rows[0]["ShipToName"].ToString();
                        ShipToAddr1.Text = ds.Tables[1].Rows[0]["ShipToAddress1"].ToString();
                        ShipToAddr2.Text = ds.Tables[1].Rows[0]["ShipToAddress2"].ToString();
                        ShipToCityStZip.Text = ds.Tables[1].Rows[0]["City"].ToString() + ", "
                            + ds.Tables[1].Rows[0]["State"].ToString() + ".  "
                            + ds.Tables[1].Rows[0]["Zip"].ToString();
                        lblBranchNo.Text = ds.Tables[1].Rows[0]["ShipLoc"].ToString();
                        lblBranchName.Text = ds.Tables[1].Rows[0]["ShipName"].ToString();
                        lblDocDate.Text = ds.Tables[1].Rows[0]["OrderDt"].ToString();
                        // get the ASN format folder and name
                        ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pEDIGetASNFormat",
                           new SqlParameter("@DocNumber", ds.Tables[1].Rows[0]["OrderNo"].ToString())
                           );
                        lblFormat.Text = ds.Tables[0].Rows[0]["ASNFolder"].ToString() + ds.Tables[0].Rows[0]["ASNFormat"].ToString();
                        hidLabelPath.Value = "file:" + ds.Tables[0].Rows[0]["ASNFolder"].ToString() + ds.Tables[0].Rows[0]["ASNFormat"].ToString();
                        updpnlOrder.Visible = true;
                        PrintLabel.Visible = true;
                        PrintCancel.Visible = true;
                        updpnlOrder.Update();
                        updpnlSelector.Visible = false;
                        SearchSubmit.Visible = false;
                    }
                }
                else
                {
                    lblErrorMessage.Text = "Order number must be numeric.";
                    MessageUpdatePanel.Update();
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pSOEGetDoc Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void PrintLabel_Click(object sender, EventArgs e)
    {
        try
        {
            string LabelLoc = "file:" + lblFormat.Text.ToString();
            //btFormat = btApp.Formats.Open(@"\\pfcdev\ftp\EDIPallet.btw", false, "");
            ////btFormat = btApp.Formats.Open(lblFormat.Text.ToString(), true, "");
            //btBases = btFormat.Databases;
            //btQueryPrompts = btBases.QueryPrompts;
            //btPrompt = btQueryPrompts.GetQueryPrompt("WarehouseOrderNumber");
            //btPrompt.Value = hidOrderNo.Value.ToString();
            //btFormat.PrintOut(true, true);
            //btFormat.Close(BarTender.BtSaveOptions.btDoNotSaveChanges);
            lblSuccessMessage.Text = "Printing Complete.";
            updpnlSelector.Visible = true;
            SearchSubmit.Visible = true;
            updpnlSelector.Update();
            updpnlOrder.Visible = false;
            PrintLabel.Visible = false;
            PrintCancel.Visible = false;
            updpnlOrder.Update();
            //ScriptManager.RegisterClientScriptBlock(PrintLabel, PrintLabel.GetType(), "ShowLabel", "OpenLabel('" + LabelLoc + "');", true);

 //           Response.Redirect(LabelLoc, true); 
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void PrintCancel_Click(object sender, EventArgs e)
    {
        updpnlSelector.Visible = true;
        SearchSubmit.Visible = true;
        updpnlOrder.Visible = false;
        PrintLabel.Visible = false;
        PrintCancel.Visible = false;
        lblSuccessMessage.Text = "Printing Cancelled.";
        lblErrorMessage.Text = "";
    }
}
