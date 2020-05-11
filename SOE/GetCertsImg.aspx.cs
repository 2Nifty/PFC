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
using PFC.SOE.DataAccessLayer;
using System.Data.Sql;
using System.Data.SqlClient;

public partial class GetCertsImg : System.Web.UI.Page
{
    MailSystem mailSystem = new MailSystem();
    Certs certs = new Certs();
    string QuotesConnectionString = ConfigurationManager.AppSettings["QuotesConnectionString"].ToString();
    string ConnectionString = ConfigurationManager.AppSettings["ConnectionString"].ToString();
     
    string ItemNo = "";
    string mfgLotNo = "";
    string pfcLotNo = "";
    string imgName = "";
    string certFileName ;
    string strMode = "";
    string strPageUrl = "";
    string strPageTitle = "";
    int pageSize = 1;
    string certsType = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        ItemNo = txtItemNumber.Text = Request.QueryString["ItemNo"].ToString();
        mfgLotNo = txtMfgLotNo.Text = Request.QueryString["MfgLotNo"].ToString();
        pfcLotNo = txtPFCLotNo.Text = Request.QueryString["PFCLotNo"].ToString();
        certsType = Request.QueryString["ImgType"].ToString();

        certFileName = "Cert_" + HttpContext.Current.Session.SessionID.ToString() + ".jpg";
        Session["CertName"] = certFileName.Trim();

        if (!Page.IsPostBack)
        {
            if (Request.QueryString["ImgType"] != "Multiple")
            {
                BindDataGrid(GetCertData(certsType));

                hidPageTitle.Value = "Certificate  for ItemNo " + ItemNo;
                string TempUrl = "GetCertsExport.aspx?ItemNo=" + ItemNo + "&PFCLotNo=" + pfcLotNo + "&MfgLotNo=" + mfgLotNo + "&ImgType=Single";
                hidPageURL.Value = TempUrl;
                

            }
            else
            {
                BindDataGrid(GetCertData(certsType));

                hidCustomerNo.Value = ItemNo;
                hidPageTitle.Value = "Certificate  for ItemNo " + ItemNo;
                string TempUrl = "GetCertsExport.aspx?ItemNo=" + ItemNo + "&PFCLotNo=" + pfcLotNo + "&MfgLotNo=" + mfgLotNo + "&ImgType=Multiple";
                //string TempUrl = "GetCertsExport.aspx";
                hidPageURL.Value = TempUrl;               
            }
        }
    }


    #region Export Dialog
    protected void ibtnEmail_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            strMode = "Email";
            strPageUrl = hidPageURL.Value;
            strPageTitle = hidPageTitle.Value;

            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Fax", "OpenPrintDialog('" + ItemNo + "','" + pfcLotNo + "','" + mfgLotNo + "');", true);
        }
        catch (Exception ex) { }
        
    }
    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + hidPageURL.Value + "');", true);
     
    }

    #endregion

    public void BindDataGrid(DataTable dtCerts)
    {
        Session["CertsInformation"] = dtCerts;
        gvCertificates.DataSource = dtCerts;
        gvCertificates.DataBind();
        Pager1.InitPager(gvCertificates, pageSize);
    }

    private DataTable GetCertData(string certType)
    {
        DataTable dtCerts = new DataTable();

        if (certType.ToLower().Trim() == "single")
        {
            dtCerts = certs.GetCertImagesFromTifImage(ItemNo,pfcLotNo,mfgLotNo);

        }
        else if (certType.ToLower().Trim() == "multiple")
        {
            dtCerts = certs.GetCertImagesFromTifImage(Session["ImgURL"].ToString());
        }

        return dtCerts;
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        //custNumber = txtCustNumber.Text;
        gvCertificates.PageIndex = Pager1.GotoPageNumber;
        BindDataGrid(GetCertData(certsType));
    }

}
