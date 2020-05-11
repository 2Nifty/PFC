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

public partial class RBRecvRprtSelector : System.Web.UI.Page
{
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Print.Visible = false;
        }
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        MessageUpdatePanel.Update();
    }

    protected void Submit_Click(object sender, EventArgs e)
    {
        if ((ContainerTextBox.Text.Trim().Length == 0) && (LPNTextBox.Text.Trim().Length == 0))
        {
            lblErrorMessage.Text = "Please enter a Container or LPN number.";
            MessageUpdatePanel.Update();
        }
        else
        {
            GetData();
        }
    }

    protected void GetData()
    {
        try
        {
            Print.Visible = false;
            // get the data.
            ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWHSRcvRprtData",
                    new SqlParameter("@Branch", LocationDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim()),
                    new SqlParameter("@Container", ContainerTextBox.Text.Trim()),
                    new SqlParameter("@LPN", LPNTextBox.Text.Trim()));
            if (ds.Tables.Count == 1)
            {
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    lblSuccessMessage.Text = "Use the Buttons to the right to Process the Report";
                    MessageUpdatePanel.Update();
                    BindPrintDialog();
                    Print.Visible = true;
                }
                else
                {
                    //lblErrorMessage.Text = "Error " + ItemNoTextBox.Text + ":" + QuoteFilterValueHidden.Value + ":" + QOHCommandHidden.Value;
                    lblErrorMessage.Text = "No matchings Bins in Branch " 
                        + LocationDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim();
                    MessageUpdatePanel.Update();
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pWHSLPNSummary Error " + e3.Message + ", " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void BindPrintDialog()
    {
        PrintUpdatePanel.Visible = true;
        Print.PageTitle = "Receiving Report for " + LocationDropDownList.SelectedItem.Text.Trim();
        string PrintURL = "RBReceiveReport.aspx.cs?Branch=" 
            + LocationDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim();
        Print.PageTitle = "Receiving Report";
        if (LPNTextBox.Text.Trim() != "")
        {
            PrintURL += "&LPN=" + LPNTextBox.Text.Trim();
        }
        if (ContainerTextBox.Text.Trim() != "")
        {
            PrintURL += "&Container=" + ContainerTextBox.Text.Trim();
        }
        // we build a url according to what search criterai they have entered. we may even sho line detail
        Print.PageUrl = PrintURL;
        PrintUpdatePanel.Update();
        //ShowPageMessage(PrintURL, 0);
    }
}
