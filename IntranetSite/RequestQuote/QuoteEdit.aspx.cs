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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
using System.IO;
using PFC.Intranet;
using System.Data.SqlClient;

public partial class RequestQuote_REFEdit : System.Web.UI.Page
{
    RequestQuote reqQuote = new RequestQuote();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["Status"].ToString().ToLower() == "edit")
            {
                btnCompleted.Visible = true;
                btnSave.Visible = true;
            }
            else
            {
                btnCompleted.Visible = false;
                btnSave.Visible = false;
            }
            hidFileName.Value = "QuoteDetail_"  + "Quote.xls";
            BindUserInformation();
            BindDatagrid();
        }
    }

    protected void BindUserInformation()
    {
        DataTable dtCustomerInformation = reqQuote.GetCustomerID(Request.QueryString["CustNo"].ToString());
        lblCustomerName.Text = dtCustomerInformation.Rows[0]["Name1"].ToString();
        lblAddress.Text = dtCustomerInformation.Rows[0]["AddrLine1"].ToString();
        lblCity.Text = dtCustomerInformation.Rows[0]["City"].ToString();
        lblState.Text = dtCustomerInformation.Rows[0]["State"].ToString();
        lblPostCd.Text = dtCustomerInformation.Rows[0]["PostCd"].ToString();
        txtRef.Text = Request.QueryString["CustRefNo"].ToString();
        lblRFQID.Text = Request.QueryString["RFQID"].ToString();
        txtPFCSales.Text = Request.QueryString["SalesRep"].ToString();
    }

    protected void BindDatagrid()
    {
        DataTable dtCustQuotationInfo = reqQuote.GetCustQuotationInfo("SessionID='" + Request.QueryString["RFQID"].ToString() + "'");
        ViewState["dt"] = dtCustQuotationInfo;
        dgRequestQuote.DataSource = dtCustQuotationInfo;
        dgRequestQuote.DataBind();
    }

    protected void dgRequestQuote_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item))
        {
            TextBox txtQty = e.Item.FindControl("txtQty") as TextBox;           
            if (txtQty.Text.ToString() == "")
                txtQty.Text = txtQty.Text;
            else
                txtQty.Text = Convert.ToInt32(Convert.ToDouble(txtQty.Text)).ToString();

            TextBox txtQtyperUOM = e.Item.FindControl("txtQtyperUOM") as TextBox;
            TextBox txtPFCItem = e.Item.FindControl("txtPFCitem") as TextBox;
            txtPFCItem.Attributes.Add("onkeypress","document.getElementById('"+txtPFCItem.ClientID +"').title = document.getElementById('"+txtPFCItem.ClientID +"').value");


            HiddenField hidBaseUOMQty = e.Item.FindControl("hidBaseUOMQty") as HiddenField;
            HiddenField hidBaseUOM = e.Item.FindControl("hidBaseUOM") as HiddenField;
            if ((hidBaseUOMQty.Value.ToString() == "") && (hidBaseUOM.Value.ToString() == ""))
            {
                hidBaseUOMQty.Value = hidBaseUOMQty.Value;
                txtQtyperUOM.Text = "";

            }
            else if ((hidBaseUOMQty.Value.ToString() == "") && (hidBaseUOM.Value.ToString() != ""))
            {
                
                txtQtyperUOM.Text = hidBaseUOM.Value;
            }
            else if ((hidBaseUOMQty.Value.ToString() != "") && (hidBaseUOM.Value.ToString() == ""))
            {
                hidBaseUOMQty.Value = Convert.ToInt32(Convert.ToDouble(hidBaseUOMQty.Value)).ToString();
                txtQtyperUOM.Text = hidBaseUOMQty.Value;
            }
            else
            {
                hidBaseUOMQty.Value = Convert.ToInt32(Convert.ToDouble(hidBaseUOMQty.Value)).ToString();
                txtQtyperUOM.Text = hidBaseUOMQty.Value + "/" + hidBaseUOM.Value;
            }

            TextBox txtPriceperUOM = e.Item.FindControl("txtPriceperUOM") as TextBox;
            HiddenField hidAltPriceQty = e.Item.FindControl("hidAltPriceUOM") as HiddenField;           


            if (hidAltPriceQty.Value.ToString() == "")
            {
                hidAltPriceQty.Value = hidAltPriceQty.Value;
                txtPriceperUOM.Text = "";
            }
            else
            {
                txtPriceperUOM.Text = Math.Round(Convert.ToDecimal(hidAltPriceQty.Value), 2).ToString();
            }
            
            Label txtExtAmt = e.Item.FindControl("txtExtAmt") as Label;
            if (txtExtAmt.Text.ToString() == "")
                txtExtAmt.Text = txtExtAmt.Text;
            else
                txtExtAmt.Text = Math.Round(Convert.ToDecimal(txtExtAmt.Text),2).ToString();       
            
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        UpdateDataGrid();
        ScriptManager.RegisterClientScriptBlock(btnSave, btnSave.GetType(), "Save", "alert('Quote Saved successfully')", true);
        BindDatagrid();
    }

    protected void btnCompleted_Click(object sender, EventArgs e)
    {
        if (txtPFCSales.Text.Trim() != "")
        {
            UpdateDataGrid();
            string strColumnName = "RFQCompleteDt='" + DateTime.Now.ToShortDateString() + "',PFCSalesRep='" + txtPFCSales.Text + "'" ;
            string strWhere = "SessionID='" + Request.QueryString["RFQID"].ToString() + "' and QuoteType='RFQ'";
            reqQuote.UpdateTables(strColumnName, strWhere);
            SendEMailNotification();

            ScriptManager.RegisterClientScriptBlock(btnCompleted, btnCompleted.GetType(), "Save", "alert('Quote Completed successfully')", true);
            BindDatagrid();
            btnSave.Visible = false;
            btnCompleted.Visible = false;
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(btnCompleted, btnCompleted.GetType(), "Save", "alert('PFC Sales Person is required')", true);
        }
    }

    private void SendEMailNotification()
    {
        MailSystem sendMail = new MailSystem();
        DataTable _dtQuoteDetail = ViewState["dt"] as DataTable;
        if (_dtQuoteDetail != null && _dtQuoteDetail.Rows.Count >0)
        {
            string _toAddress = GetCustomerEmailID(_dtQuoteDetail.Rows[0]["UserID"].ToString());

            SqlDataReader NameReader1 = SqlHelper.ExecuteReader(Global.InternerUmbrellaConnectionString, "UGEN_SP_Select",
                                                   new SqlParameter("@tableName", "UEMM_EmailContent"),
                                                   new SqlParameter("@columnNames", "*"),
                                                   new SqlParameter("@whereClause", "TemplateID='" + 81 + "'"));            

            if (NameReader1.Read())
            {
                string subject = NameReader1["Subject"].ToString();
                string body = NameReader1["Content"].ToString();
                body = body.Replace("[SiteURL]", ConfigurationManager.AppSettings["UmbrellaSiteURL"].ToString());
                sendMail.SendMail(ConfigurationManager.AppSettings["FromAddress"].ToString(), _toAddress, subject, body);
            }

        }
    }

    private string GetCustomerEmailID(string loginID)
    {
        string _emailID = "";
        try
        {
            _emailID = SqlHelper.ExecuteScalar(Global.QuotesSystemConnectionString, "UGEN_SP_Select",
                                            new SqlParameter("@tableName", "SDK_EndUserRegistration"),
                                            new SqlParameter("@columnNames", "AdministratorEmailID"),
                                            new SqlParameter("@whereCondition", "LoginID='" + loginID + "'")).ToString();
            return _emailID;
        }
        catch (Exception ex)
        {
            return _emailID;
        }
    }

    protected void imgExcel_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter= fnExcel.CreateText();       

                
       DataTable dtTotal =(DataTable)ViewState["dt"];


        headerContent = "<table border='1' width='900'>";
        headerContent += "<tr><th colspan='8' style='color:blue'>Quote Information</th></tr>";
       // headerContent += "<tr><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2' align='left'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


        if (dtTotal.Rows.Count > 0)
        {
            headerContent += "<tr><th  style='width:100px'>Customer Number #</th><th style='width:200px'>Size Description</th><th style='width:50px'>UOM" +
                                        "</th><th style='width:50px'>BX/QTY</th><th>PFC Item #</th><th>QTY</th><th>QTY/UOM</th><th>Price/UOM</th><th>Ext Amt</th></tr>";
            foreach (DataGridItem dataGridItem in dgRequestQuote.Items)
            {
                String strPFCItem = ((TextBox)dataGridItem.FindControl("txtPFCitem")).Text;
                String strQty = ((TextBox)dataGridItem.FindControl("txtQty")).Text;
                String strprice = ((TextBox)dataGridItem.FindControl("txtPriceperUOM")).Text;
                String strQtyPerUOM = ((TextBox)dataGridItem.FindControl("txtQtyperUOM")).Text;
                String strExtAmt = ((Label)dataGridItem.FindControl("txtExtAmt")).Text;
                
                string strcustNo = ((HiddenField)dataGridItem.FindControl("hidCustNo")).Value;
                string strDescription = ((HiddenField)dataGridItem.FindControl("hidDesc")).Value;
                string strUOM = ((HiddenField)dataGridItem.FindControl("hidUOM")).Value;
                string strBXPerUOM = ((HiddenField)dataGridItem.FindControl("hidBXPERUOM")).Value;


                //excelContent += "<tr><td>" + roiReader["CustomerNumber"] + "</td><td nowrap=nowrap>" +
                //         roiReader["CustItemDesc"] + "</td><td nowrap=nowrap>" +
                //         roiReader["CustUOM"] + "</td><td nowrap=nowrap>" +
                //         roiReader["CustBxperQty"] + "</td><td nowrap=nowrap>" +
                //         roiReader["PFCItemNo"] + "</td><td nowrap=nowrap>" +
                //         roiReader["AvailableQuantity"] + "</td><td nowrap=nowrap>" +
                //         BXperQTY + "</td><td nowrap=nowrap>" +
                //         PriceperQTY + "</td><td nowrap=nowrap>" +
                //         extAmt + "</td></tr>";

                excelContent += "<tr><td>" + strcustNo + "</td><td nowrap=nowrap>" +
                        strDescription + "</td><td nowrap=nowrap>" +
                        strUOM + "</td><td nowrap=nowrap>" +
                        strBXPerUOM + "</td><td nowrap=nowrap>" +
                        strPFCItem + "</td><td nowrap=nowrap>" +
                        strQty + "</td><td nowrap=nowrap>" +
                        strQtyPerUOM + "</td><td nowrap=nowrap>" +
                        strprice + "</td><td nowrap=nowrap>" +
                        strExtAmt + "</td></tr>";
            }


           

        }
        reportWriter.WriteLine(headerContent + excelContent + footerContent);
        reportWriter.Close();

        //Downloding Process
        FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();


        //  Download Process
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);

        //Code to Delete Excel File
        DeleteExcel();

        Response.End();
      

        

    }

    public string DeleteExcel()
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("Common\\ExcelUploads"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(hidFileName.Value))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }

    private void UpdateDataGrid()
    {
        try
        {
            foreach (DataGridItem dataGridItem in dgRequestQuote.Items)
            {
                String pfcItemNo = ((TextBox)dataGridItem.FindControl("txtPFCitem")).Text;
                String Qty = ((TextBox)dataGridItem.FindControl("txtQty")).Text;
                String price = ((TextBox)dataGridItem.FindControl("txtPriceperUOM")).Text;
                String QtyPerUOM = ((TextBox)dataGridItem.FindControl("txtQtyperUOM")).Text;
                string id = ((HiddenField)dataGridItem.FindControl("hidID")).Value;

                String priceuom = ((HiddenField)dataGridItem.FindControl("hidAltPriceUOM")).Value;
                String priceqty = ((HiddenField)dataGridItem.FindControl("hidAltPrice")).Value;
                String baseuom = ((HiddenField)dataGridItem.FindControl("hidBaseUOM")).Value;
                String baseqty = ((HiddenField)dataGridItem.FindControl("hidBaseUOMQty")).Value;

                string[] strQtyarray = new string[2];
                if (QtyPerUOM.Contains("/"))
                {
                    strQtyarray = QtyPerUOM.Split('/');
                    strQtyarray[0] = "'" + strQtyarray[0] + "'";
                }
                else
                {
                    strQtyarray[0] = "NULL"; // Qty
                    strQtyarray[1] = "";
                }


                // Total Calculation
                decimal decExtAmt = (decimal)0.00;
                if (Qty != "" && price != "")
                    decExtAmt = Math.Round(Convert.ToDecimal(price.Replace("'", "")) * Convert.ToDecimal(Qty), 2);

                //decExtAmt = Convert.ToInt16(strPricearray[0].Replace("'", "")) * Convert.ToInt16(Qty);
                string txtExtAmt = decExtAmt.ToString() == "0.00" ? "NULL" : "'" + decExtAmt.ToString() + "'";

                string strColumnName = "TotalPrice=" + txtExtAmt + "," +
                                        "PFCItemNo='" + pfcItemNo.ToString().Replace("'", "''") + "'," +
                                        "AvailableQuantity=" + (Qty != "" ? Qty : "NULL") + "," +
                                        "BaseUOMQty=" + strQtyarray[0] + "," +
                                        "BaseUOM='" + strQtyarray[1] + "'," +
                                        "AlternateUOMQty=" + price + "," +
                                        "PFCSalesRep='" + txtPFCSales.Text + "'";
                string strWhere = "ID='" + id + "' and QuoteType='RFQ'";
                reqQuote.UpdateTables(strColumnName, strWhere);
            }
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
   
}
