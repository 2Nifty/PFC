using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class ContainerRcptDetail : System.Web.UI.Page
{
    //string RBConnectionString = ConfigurationManager.ConnectionStrings["PFCRBConnectionString"].ToString();
    //string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string SessionTableName = "ContainerLPNDetail";
    ContainerReceiptData ReceiptData = new ContainerReceiptData();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    GridViewRow row;
    LinkButton LPNLink;
    TextBox RcvQty;
    CheckBox LineSelected;
    bool LineError;
    private string NumFieldFormat = "{0:#########0.000}, ";
    private string IntFieldFormat = "{0:#########0}, ";
    private string StringFieldFormat = "'{0}', ";
    private string DateFieldFormat = "'{0:MM/dd/yy}', ";

    protected void Page_Load(object sender, EventArgs e)
    {
        PageFooter2.FooterTitle = "Warehouse Container Detail";
        ApproveSubmit.Visible = false;
        if (!IsPostBack)
        {
            LocLabel.Text = Request.QueryString["Loc"].ToString();
            LPNLabel.Text = Request.QueryString["LPNumber"].ToString();
            GetLPNData();
            BindPrintDialog();
        }
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(ContainerRcptDetail));
    }

    protected void GetLPNData()
    {
        try
        {
            Session[SessionTableName] = null;
            // get the data.
            dt = CheckError(ReceiptData.GetItems(LPNLabel.Text.ToString().Trim(), Session["UserName"].ToString()));
            if ((dt != null) && (dt.Rows.Count > 0))
            {
                LPNGridView.DataSource = dt;
                LPNGridView.DataBind();
                Session[SessionTableName] = dt;
                lblSuccessMessage.Text = "Cross Dock Orders have been submitted for Printing.";
            }
            else
            {
                lblErrorMessage.Text = "No data for LPN " + LPNLabel.Text;
                MessageUpdatePanel.Update();
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "GetLPNData Error " + e3.Message + ", " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void ApproveSubmit_Click(object sender, EventArgs e)
    {
    //    XferTimer.Enabled = false;
    //    lblXFerCreation.Text = "Transfer creation started " + DateTime.Now.ToLongDateString() + " " + DateTime.Now.ToLongTimeString();
    //    XFerCreationUpdatePanel.Update();
    //    try
    //    {
    //        dt = CheckError(ReceiptData.CreateXFers(LPNLabel.Text.ToString().Trim(), Session["UserName"].ToString()));
    //        lblSuccessMessage.Text = "Transfers created successfully.";
    //        MessageUpdatePanel.Update();
    //        XFerCreationUpdatePanel.Visible = false;
    //    }
    //    catch (Exception e3)
    //    {
    //        lblErrorMessage.Text = "pWHSLPNAccept Error " + e3.Message + ", " + e3.ToString();
    //        MessageUpdatePanel.Update();
    //    }
    //    GetLPNData();
    //    BindPrintDialog();
    }

    protected string FormatLineColumn(int FieldNo, int FormatType, string FieldVal)
    {
        // FormatType 1=string, 2=int, 3=dec, 4=date
        string FieldResult = "";
        if (LineError)
        {
            return FieldResult;
        }
        switch (FormatType)
        {
            case 1:
                try
                {
                    FieldResult = String.Format(StringFieldFormat, FieldVal.Replace("'", "''").Trim());
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 2:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = "0";
                    }
                    FieldResult = String.Format(IntFieldFormat, int.Parse(FieldVal, NumberStyles.Number));
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 3:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = "0";
                    }
                    FieldResult = String.Format(NumFieldFormat, decimal.Parse(FieldVal, NumberStyles.Number));
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 4:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = DateTime.Now.ToShortDateString();
                    }
                    FieldResult = String.Format(DateFieldFormat, DateTime.Parse(FieldVal));
                }
                catch (Exception ex)
                {
                    //LineError = true;
                }
                break;
        }
        if (LineError)
        {
            lblErrorMessage.Text = "Error on field " + FieldNo.ToString() + " Val=" + FieldVal;
            MessageUpdatePanel.Update();
        }
        return FieldResult;
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView 
            string LineFilter;
            DataView dv = new DataView((DataTable)Session[SessionTableName]);
            dv.Sort = e.SortExpression;
            LPNGridView.DataSource = dv;
            LPNGridView.DataBind();
            DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
            DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "Sort Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void DetailGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        //DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
        LPNGridView.DataSource = (DataTable)Session[SessionTableName];
        LPNGridView.PageIndex = e.NewPageIndex;
        LPNGridView.DataBind();
        DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
        DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
    }
    public void BindPrintDialog()
    {
        Print.PageTitle = "Receiving Report for " + Session["UserName"].ToString() +
        ". Branch=" + LocLabel.Text.Substring(0, 2) +
        ". LPN=" + LPNLabel.Text.Trim();
        // we build a url according to how the Receiving Report report is configured
        string RecvRepURL = "RBReceiving/RBReceiveReport.aspx?UserName=" + Session["UserName"].ToString();
        RecvRepURL += "&Branch=" + LocLabel.Text.Substring(0, 2);
        RecvRepURL += "&Container=" + LPNLabel.Text.Trim();
        Print.PageUrl = Server.UrlEncode(RecvRepURL);
        Print.FormName = "RBReceiveReport";
        PrintUpdatePanel.Update();
        //lblErrorMessage.Text = "RecvRepURL " + RecvRepURL;
        //MessageUpdatePanel.Update();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ReleaseSoftLock(string Container)
    {
        string status = "0";
        try
        {
            DataTable tempDt = ReceiptData.ReleaseContainer(Container, Session["UserName"].ToString());
            status = "Released";
        }
        catch (Exception ex)
        {
            status = "ReleaseSoftLock fail" + ex.ToString();
        }
        return status;
    }

    public DataTable CheckError(DataTable NewData)
    {
        if ((NewData != null) && (NewData.Columns.Contains("ErrorType")))
        {
            lblErrorMessage.Text = NewData.Rows[0]["ErrorText"].ToString();
            MessageUpdatePanel.Update();
            return null;
        }
        else
        {
            return NewData;
        }
    }
}
