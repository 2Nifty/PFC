using System;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.IO;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class PalletPartnerUpload : System.Web.UI.Page
{
    string cnxXLS;
    string inpFile;

    OleDbConnection cnxOle;
    OleDbDataAdapter adpOle;
    
    SqlCommand cmdSQL;
    SqlDataAdapter adp;
    SqlConnection cnxConsPurchReq;

    DataSet dsSQL, dsXLS = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxConsPurchReq = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csConsPurchReq"].ConnectionString);

        if (!Page.IsPostBack)
        {
            btnClose.Attributes.Add("onclick", "javascript:window.location='" + Request.ServerVariables.Get("HTTP_REFERER") + "'");
        }
    }

    public void btnFileSel_Click(object sender, ImageClickEventArgs e)
    {
        lblUpdateMessage.Visible = false;

        if (SingleFileName.HasFile)
        {
            Server.MapPath(".");
            SingleFileName.SaveAs(@Server.MapPath(".") + "/Excel/" + SingleFileName.FileName);
            GridView1.Visible = true;
            btnAccept.Visible = true;
            //lblFilter.Visible = true;
            //btnFilterAll.Visible = true;
            //btnFilterGood.Visible = true;
            //btnFilterBad.Visible = true;
            
            inpFile = Server.MapPath(".") + "/Excel/" + SingleFileName.FileName;

            lblFileMessage.Text = "File selected = " + SingleFileName.FileName;

            cnxXLS = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + inpFile + ";Extended Properties=Excel 8.0;";
            cnxOle = new OleDbConnection(cnxXLS);
            try
            {
                adpOle = new OleDbDataAdapter("SELECT * FROM [Pallet Partners$]", cnxOle);
                cnxOle.Open();
                adpOle.Fill(dsXLS, "PPGrid");
                Session["Value"] = dsXLS;
                GridView1.DataSource = dsXLS.Tables["PPGrid"].DefaultView;
                GridView1.DataBind();
                cnxOle.Close();
            }
            catch (Exception ex)
            {
                cnxOle.Close();
                GridView1.Visible = false;
                btnAccept.Visible = false;
                lblFileMessage.Text = "ERROR: Excel worksheet must be named 'Pallet Partners'";
            }
        }
        else
        {
            GridView1.Visible = false;
            btnAccept.Visible = false;
            //lblFilter.Visible = false;
            //btnFilterAll.Visible = false;
            //btnFilterGood.Visible = false;
            //btnFilterBad.Visible = false;

            lblFileMessage.Text = "ERROR: You did not select a valid Excel file";
        }
    }

    public void btnAccept_Click(object sender, ImageClickEventArgs e)
    {
        dsXLS = (DataSet)Session["Value"];
        cmdSQL = new SqlCommand("DELETE FROM CPR_PalletPartner", cnxConsPurchReq);
        cnxConsPurchReq.Open();
        cmdSQL.ExecuteNonQuery();
        cnxConsPurchReq.Close();

        cmdSQL = new SqlCommand(string.Empty, cnxConsPurchReq);

      //Load Excel worksheet into DataTable
        DataTable dsRecord = new DataTable();
        dsRecord.Columns.Add("Vendor", typeof(string));
        dsRecord.Columns.Add("Item", typeof(string));
        dsRecord.Columns.Add("Committed", typeof(string));
        dsRecord.Columns.Add("Ready", typeof(string));
        for (int RowCount = 0; RowCount < dsXLS.Tables["PPGrid"].Rows.Count; RowCount++)
        {
            DataRow dr = dsRecord.NewRow();
            dr["Item"] = dsXLS.Tables["PPGrid"].Rows[RowCount]["Item"].ToString();
            dr["Vendor"] = dsXLS.Tables["PPGrid"].Rows[RowCount]["Vendor"].ToString();
            dr["Committed"] = dsXLS.Tables["PPGrid"].Rows[RowCount]["Committed"].ToString(); ;
            dr["Ready"] = dsXLS.Tables["PPGrid"].Rows[RowCount]["Ready"].ToString(); ;
            dsRecord.Rows.Add(dr);
        }

        try
        {
          //Load SQL Table CPR_PalletPartner from the DataTable 
            cmdSQL.CommandText = "INSERT INTO [CPR_PalletPartner] (Item, Vendor, [Committed], Ready) VALUES (@Item, @Vendor, @Committed, @Ready)";
            {
                cmdSQL.Parameters.Add("@Item", SqlDbType.VarChar, 255, "Item");
                cmdSQL.Parameters.Add("@Vendor", SqlDbType.VarChar, 255, "Vendor");
                cmdSQL.Parameters.Add("@Committed", SqlDbType.VarChar, 8, "Committed");
                cmdSQL.Parameters.Add("@Ready", SqlDbType.VarChar, 8, "Ready");
            }
            adp = new SqlDataAdapter();
            adp.InsertCommand = cmdSQL;
            cnxConsPurchReq.Open();
            adp.Update(dsRecord);
            cnxConsPurchReq.Close();
        }
        catch (Exception ex)
        {
            throw;
        }

        lblUpdateMessage.Text = "CPR_PalletPartner table has been updated: " + dsXLS.Tables["PPGrid"].Rows.Count.ToString() + " records loaded.";
        lblUpdateMessage.Visible = true;

        GridView1.Visible = false;
        btnAccept.Visible = false;
    }

}
