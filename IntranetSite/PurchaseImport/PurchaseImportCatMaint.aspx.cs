using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class PurchaseImportCatMaint : System.Web.UI.Page
{
    //string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    PurchaseImportData PIData = new PurchaseImportData();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    GridViewRow row;
    LinkButton RcptLink;
    HiddenField HiddenContainer;
    String LPNNumber;
    String LocNumber;
    DateTime LPNDate;
    DateTime PurchImpDate;
    LinkButton ContainerLink;
    DataView dv = new DataView();

    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SortHidden.Value = "Vendor";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(PurchaseImportCatMaint));
        PageFooter2.FooterTitle = "Purchase Import Category Maintenance";
        if (!IsPostBack)
        {
            // get the data.
            Session["PICatListData"] = null;
            dt = CheckError(PIData.GetCatLists());
            ShowData();
            ClearData();

        }
        else
        {
        }
    }

    protected void Add_Click(object sender, EventArgs e)
    {
        try
        {
            lblErrorMessage.Text = "";
            if (lblErrorMessage.Text.ToString().Trim().Length == 0)
            {
                dt = CheckError(PIData.AddCatData(
                    txtVendor.Text.ToString().Trim()
                    ,txtBegCat.Text.ToString().Trim()
                    ,txtEndCat.Text.ToString().Trim()
                    ,txtFileName.Text.ToString().Trim()
                    ,Session["UserName"].ToString()
                    ));
                ShowData();
            }
            MessageUpdatePanel.Update();
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "FindSubmit_Click Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    private void CheckData()
    {
        if (txtVendor.Text.ToString().Trim().Length == 0)
        {
            lblErrorMessage.Text = "A vendor number is required.";
        }
        if (txtBegCat.Text.ToString().Trim().Length == 0)
        {
            lblErrorMessage.Text = "A beginning category is required.";
        }
        if (txtEndCat.Text.ToString().Trim().Length == 0)
        {
            lblErrorMessage.Text = "A ending is required.";
        }
        if (txtFileName.Text.ToString().Trim().Length == 0)
        {
            lblErrorMessage.Text = "A file name is required.";
        }
    }

    protected void ShowData()
    {
        PurchImpGridView.DataSource = dt;
        PurchImpGridView.DataBind();
        DetailUpdatePanel.Update();
        Session["PICatListData"] = dt;
    }

    private void ClearData()
    {
        txtVendor.Text = "";
        txtBegCat.Text = "";
        txtEndCat.Text = "";
        txtFileName.Text = "";
        btnAdd.Visible = true;
        btnUpd.Visible = false;
        btnDel.Visible = false;
        btnCancel.Visible = false;
        btnRTS.Visible = false;

    }

    public void PurchImpGridView_RowCommand(Object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Fix")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = PurchImpGridView.Rows[index];
                hidRecID.Value = "";
                hidRecID.Value = row.Cells[5].Text;
                dt = null;
                dt = CheckError(PIData.GetCatFilter(hidRecID.Value.ToString()));
                txtVendor.Text = dt.Rows[0]["Vendor"].ToString();
                txtBegCat.Text = dt.Rows[0]["CategoryFrom"].ToString();
                txtEndCat.Text = dt.Rows[0]["CategoryTo"].ToString();
                txtFileName.Text = dt.Rows[0]["ImportFileName"].ToString();
                DataUpdatePanel.Update();
                btnAdd.Visible = false; 
                btnUpd.Visible = true;
                btnDel.Visible = true;
                btnCancel.Visible = true;
                btnRTS.Visible = true;
            }
            //if (e.CommandName == "MakeExcel")
            //{
            //    int index = Convert.ToInt32(e.CommandArgument);
            //    GridViewRow row = PurchImpGridView.Rows[index];
            //    hidRecID.Value = "";
            //    hidRecID.Value = row.Cells[6].Text;
            //    dt = null;
            //    dt = CheckError(PIData.GetRTSData(hidRecID.Value.ToString()));
            //    if (dt.Rows.Count > 0)
            //    {
            //        CreateExcelFile(dt);
            //    }
            //    else
            //    {
            //        lblErrorMessage.Text = "No RTS data available.";
            //        MessageUpdatePanel.Update();
            //    }
            //}
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "PurchImpGridView_RowCommand Error " + hidRecID.Value + "<BR>" + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void Update_Click(object sender, EventArgs e)
    {
        try
        {
            lblErrorMessage.Text = "";
            CheckData();
            if (lblErrorMessage.Text.ToString().Trim().Length == 0)
            {
                dt = CheckError(PIData.FixCatData(
                    txtVendor.Text.ToString().Trim()
                    , txtBegCat.Text.ToString().Trim()
                    , txtEndCat.Text.ToString().Trim()
                    , txtFileName.Text.ToString().Trim()
                    , hidRecID.Value.ToString()
                    , Session["UserName"].ToString()
                    ));
                ShowData();
                ClearData();

            }
            MessageUpdatePanel.Update();
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "Update_Click Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void Delete_Click(object sender, EventArgs e)
    {
        try
        {
            dt = CheckError(PIData.DeleteCatData(
                hidRecID.Value.ToString()
                ));
            ShowData();
            ClearData();
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "Delete_Click Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void Cancel_Click(object sender, EventArgs e)
    {
        ClearData();
    }

    protected void RTS_Click(object sender, EventArgs e)
    {
        try
        {
            dt = null;
            dt = CheckError(PIData.GetRTSData(hidRecID.Value.ToString()));
            if (dt.Rows.Count > 0)
            {
                CreateExcelFile(dt);
            }
            else
            {
                lblErrorMessage.Text = "No RTS data available.";
                MessageUpdatePanel.Update();
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "RTS_Click Error " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    private void CreateExcelFile(DataTable edt)
    {
        //
        // Create the quote detail spreadsheet
        //
        /*
         PRE-SHIPMENT REQUEST TO SHIP								
        Vendor I.D.	PFC P.O. No.	PFC Part No.	No. Pallets	Cartons	Gross Weight 	Shipping Port	PFC destination	Factory
        BENY	19071605	00023-2840-020	2	72	1454.4	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2820-020	1	36	1065.6	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2824-020	1	36	982.8	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2830-020	1	36	867.6	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2424-021	1	36	766.8	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2624-021	1	36	896.4	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2625-021	1	36	849.6	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2626-021	1	36	860.4	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2630-021	2	72	1533.6	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2824-021	1	36	982.8	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2832-021	2	72	1620	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2526-021	1	36	820.8	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2530-021	1	36	745.2	KAOHSIUNG		BEN YUAN
        BENY	19081905	00023-2540-021	1	36	601.2	KAOHSIUNG		BEN YUAN
        BENY	19082106	00050-2430-021	3	108	2008.8	KAOHSIUNG		BEN YUAN
        BENY	19082112	00050-2427-022	1	36	619.2	KAOHSIUNG		BEN YUAN
        BENY	19082112	00050-2430-022	1	36	669.6	KAOHSIUNG		BEN YUAN        

        */
        // Convert a virtual path to a fully qualified physical path.
        string ExcelFileName = @"Excel/" + edt.Rows[0]["ImportFileName"].ToString() + ".xls";
        string fullpath = Request.MapPath(ExcelFileName);
        string RowSelector = "";
        using (StreamWriter sw = new StreamWriter(fullpath))
        {
            sw.Write(" PURCHASE IMPORT REQUEST TO SHIP");
            sw.WriteLine();
            sw.Write("Vendor I.D.\tPFC P.O. No.\tPFC Part No.\tNo. Pallets\tCartons\tGross Weight\tShipping Port");
            sw.WriteLine();
            foreach (DataRow row in (edt.Rows))
            {
                sw.Write(row["Vendor"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["RTSPONo"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["RTSItemNo"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["Pallets"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["POQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["GrossWeight"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ShippingPort"].ToString().Trim());
                sw.WriteLine();
            }
        }
        // now open it.
        //ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PONo", "OpenExcel('" + ExcelFileName + "');", true);
        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(fullpath, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + fullpath);
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();


    }
    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            //// set the detail link
            //row = e.Row;
            //if (row.RowType == DataControlRowType.DataRow)
            //{
            //    RcptLink = (LinkButton)row.Cells[1].Controls[1];
            //    // line formatting
            //    if ((row.Cells[5].Text.ToString().Trim() != "&nbsp;") && (row.Cells[5].Text.ToString().Trim() != Session["UserName"].ToString().Trim()))
            //    {
            //        RcptLink.Enabled = false;
            //    }
            //    else
            //    {
            //        // check in cross dock exists
            //        HiddenContainer = (HiddenField)row.Cells[1].Controls[3];
            //        LPNNumber = row.Cells[0].Text;
            //        LocNumber = row.Cells[2].Text;
            //        if (HiddenContainer.Value == "")
            //        {
            //            RcptLink.Text = "Receive LPN";
            //        }
            //        else
            //        {
            //            RcptLink.Text = "View Cross Dock";
            //        }
            //        string LinkCommand = "";
            //        LinkCommand = "return ConfirmReceipt(this,'";
            //        LinkCommand += LPNNumber + "','";
            //        LinkCommand += LocNumber + "','";
            //        LinkCommand += HiddenContainer.Value + "','";
            //        LinkCommand += Server.UrlEncode("RBReceiving/RBReceiveReport.aspx?UserName=" + Session["UserName"].ToString() +
            //            "&Branch=" + LocNumber + "&Container=" + LPNNumber) + "');";
            //        ;
            //        RcptLink.OnClientClick = LinkCommand;
            //    }
            //}
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "DetailRowBound Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            //// Create a DataView 
            //if (Session["FilteredRcptData"] == null)
            //{
            //    dv = new DataView((DataTable)Session["LPNRcptData"]);
            //}
            //else
            //{
            dv = new DataView((DataTable)Session["PICatListData"]);
            //}
            SortHidden.Value = e.SortExpression;
            dv.Sort = e.SortExpression;
            dt = dv.ToTable();
            ShowData();
            //RePage(dt);
            //if (Session["FilteredRcptData"] == null)
            //{
            //    Session["LPNRcptData"] = dt;
            //}
            //else
            //{
            //    Session["FilteredRcptData"] = dt;
            //}
            //BindPageDetails();
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "Sort Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
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

    //[Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    //public string UpdDate(string LPN)
    //{
    //    string status = LPN;
    //    try
    //    {
    //        //// update the table in the session variable to show that the line is selected or not.
    //        //DataTable dt = ReceiptData.UpdateLPNAudit(LPN, Session["UserName"].ToString());

    //        //if (dt.Columns.Contains("ErrorType"))
    //        //{
    //        //    status = "--Error -- " + dt.Rows[0]["ErrorText"].ToString();
    //        //}
    //        //else
    //        //{
    //        //    DataTable tempDt = (DataTable)Session["LPNRcptData"];
    //        //    DataRow[] LPNRow = tempDt.Select("LPNNo = '" + LPN + "'");
    //        //    status = "OK";
    //        //    LPNRow[0]["RcptStatus"] = "Processed";
    //        //    Session["LPNRcptData"] = tempDt;
    //        //}
    //    }
    //    catch (Exception e2)
    //    {
    //        status = "--Error -- " + e2.ToString();
    //    }
    //    return status;
    //}

}
