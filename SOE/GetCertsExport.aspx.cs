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
    Certs certs = new Certs();
     
    string ItemNo = "";
    string pfcLotNo = "";
    string mfgLotNo = "";
    string certFileName ;
    string certsType = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        ItemNo = txtItemNumber.Text = Request.QueryString["ItemNo"].ToString();
        pfcLotNo = txtMfgLotNo.Text = Request.QueryString["PFCLotNo"].ToString();
        mfgLotNo = txtMfgLotNo.Text = Request.QueryString["MfgLotNo"].ToString();
        certsType = Request.QueryString["ImgType"].ToString();

        certFileName = "Cert_" + HttpContext.Current.Session.SessionID.ToString() + ".jpg";
        Session["CertName"] = certFileName.Trim();

        if (!Page.IsPostBack)
        {
            if (Request.QueryString["ImgType"] != "Multiple")
            {
                BindDataGrid(GetCertData(certsType));                
            }
            else
            {
                BindDataGrid(GetCertData(certsType));
            }
        }
    }

    public void BindDataGrid(DataTable dtCerts)
    {
        gvCertificates.DataSource = dtCerts;
        gvCertificates.DataBind();        
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
    

}
