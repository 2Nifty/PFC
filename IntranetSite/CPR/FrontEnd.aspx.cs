using System;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Utility;
using PFC.Intranet.Securitylayer;

public partial class CPRFrontEnd : System.Web.UI.Page 
{
    Utility utility = new Utility();
    PFC.Intranet.BusinessLogicLayer.CPR cpr = new PFC.Intranet.BusinessLogicLayer.CPR();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            CurItemsName.Value = "CurItems";
            if (Request.QueryString["Type"] != null)
            {
                CurItemsName.Value = "BuyItems";
                ReportType.Value = Request.QueryString["Type"];
                this.Title = "CPR Buy Front End";
                lblParentMenuName.Text = "CPR Buy Report Item Selection";
            }
            RunByLabel.Text = Session["UserName"].ToString();
            dt = cpr.GetVMIDDL().Tables[0];
            VMIContractDDL.DataSource = dt.DefaultView.ToTable();
            VMIContractDDL.DataBind();
            BindStaticLists();
            StaticListsGrid.Visible = false;
            BindExceptionLists();
            ExceptionListsGrid.Visible = false;
            BindListTypeDDL();
            SingleItemNo.Focus();
            if (Session[CurItemsName.Value] != null)
            {
                try
                {
                    dt = (DataTable)Session[CurItemsName.Value];
                    //DataView dv = new DataView(dt);
                    ReportItemsGrid.DataSource = dt;
                    ReportItemsGrid.DataBind();
                    ItemCountLabel.Text = ReportItemsGrid.Rows.Count.ToString();
                    Static.Checked = true;
                    Single.Checked = false;
                    Excel.Checked = false;
                }
                catch { };
            }
        }
        else
        {
            ScriptManager1.AsyncPostBackTimeout = 1200;
        }
    }

    protected DataTable ParseExcelFile()
    {
        DataTable dtLocal = new DataTable();
        int recctr = 0;
        bool FileOK = false;
        if (Path.GetExtension(ExcelFileUpload.FileName).ToLower().ToString() == ".txt")
        {
            dtLocal.Columns.Add("Item", typeof(String));
            dtLocal.Columns.Add("Cat", typeof(String));
            dtLocal.Columns.Add("Plate", typeof(String));
            dtLocal.Columns.Add("Var", typeof(String));
            //Stream LoadingStream = ExcelFileUpload.FileContent();
            Stream st = ExcelFileUpload.FileContent;
            byte[] bytes = new byte[1000];
            int numBytesToRead = (int)st.Length;
            int numBytesRead = 0;
            //lblSuccessMessage.Text = "File length = " + numBytesToRead.ToString();
            string itemNo;
            while (numBytesToRead > 0)
            {
                // Read may return anything from 0 to numBytesToRead.
                int n = st.Read(bytes, 0, 16);
                //lblSuccessMessage.Text = lblSuccessMessage.Text.TrimEnd() + "," + n.ToString() + "," + System.Text.Encoding.Default.GetString(bytes);

                // The end of the file is reached.
                if (n == 0)
                    break;
                numBytesRead += n;
                numBytesToRead -= n;
                recctr++;
                itemNo = System.Text.Encoding.Default.GetString(bytes).TrimEnd();
                dtLocal.Rows.Add(new Object[] { itemNo.Substring(0, 14), itemNo.Substring(0, 5), itemNo.Substring(13, 1), itemNo.Substring(11, 3) });
                //lblErrorMessage.Text = System.Text.Encoding.Default.GetString(bytes);
            }
            lblSuccessMessage.Text = "Text file processed. " + dtLocal.Rows.Count.ToString() + " lines.";
            FileOK = true;
        }
        if (Path.GetExtension(ExcelFileUpload.FileName).ToLower().ToString() == ".xls")
        {
            // Upload the file to the Excel folder under the app folder to we will then have permission to open it.
            //string SiteFileName = "D:\\software\\PFCApps\\IntranetSite\\CPR\\Excel\\Uploaded.xls";
            string SiteFileName = Server.MapPath(
                @"Excel\"
                + Session["UserName"].ToString()
                + "Upload.xls");
            //SiteFileName.Replace(@"\", @"\\");
            ExcelFileUpload.SaveAs(SiteFileName);
            OleDbConnection cn = new OleDbConnection("provider=Microsoft.Jet.OLEDB.4.0;data source=" +
                SiteFileName +
                ";Extended Properties=Excel 8.0;");
            // Select the data from Sheet1 of the workbook.
            OleDbDataAdapter cmd = new OleDbDataAdapter("select Item from [Sheet1$]", cn);
            try
            {
                cn.Open();
                cmd.Fill(ds);
                dtLocal = ds.Tables[0];
                DataColumn FirstColumn = dtLocal.Columns[0];
                dtLocal.Columns.Add("Cat", typeof(String));
                dtLocal.Columns.Add("Plate", typeof(String));
                dtLocal.Columns.Add("Var", typeof(String));
                string item = "";
                foreach (DataRow row in dtLocal.Rows)
                {
                    item = row["Item"].ToString();
                    row["Cat"] = item.Substring(0,5);
                    row["Plate"] = item.Substring(13, 1);
                    row["Var"] = item.Substring(11, 3);
                }
                FileOK = true;
                cn.Close();
                lblSuccessMessage.Text = "Excel file " + ExcelFileUpload.FileName.ToString() + " processed. " + dtLocal.Rows.Count.ToString() + " lines.";
            }
            catch { }
        }
        if (!FileOK)
        {
            lblErrorMessage.Text = "File must be a list of items in a text file (.txt) or an Excel file (.xls). Click on Help for more info.";
        }


        return dtLocal.DefaultView.ToTable();
    }

    protected void BindStaticLists()
    {
        dt = cpr.GetStaticLists().Tables[0];
        if (dt.Rows.Count == 0)
        {
            lblErrorMessage.Text = "No static lists have been defined.";
        }
        else
        {
        }
        StaticListsGrid.DataSource = dt.DefaultView.ToTable();
        StaticListsGrid.DataBind();
    }

    protected void BindListTypeDDL()
    {
        dt = cpr.GetStaticListTypes().Tables[0];
        StaticListDDL.DataSource = dt.DefaultView.ToTable();
        StaticListDDL.DataBind();
    }

    protected void BindExceptionLists()
    {
        dt = cpr.GetExceptionLists().Tables[0];
        if (dt.Rows.Count == 0)
        {
            lblErrorMessage.Text = "No AD Exception lists exist.";
        }
        else
        {
        }
        ExceptionListsGrid.DataSource = dt.DefaultView.ToTable();
        ExceptionListsGrid.DataBind();
    }

    protected virtual void SortCurItems(object source, GridViewSortEventArgs e)
    {
        // Retrieve the data source from session state.
        dt = (DataTable)Session[CurItemsName.Value];

        // Create a DataView from the DataTable.
        DataView dv = new DataView(dt);

        // The DataView provides an easy way to sort. Simply set the
        // Sort property with the name of the field to sort by.
        dv.Sort = e.SortExpression;

        // Re-bind the data source and specify that it should be sorted
        // by the field specified in the SortExpression property.
        ReportItemsGrid.DataSource = dv;
        ReportItemsGrid.DataBind();

    }

    protected void StaticListCommand(object source, GridViewCommandEventArgs e)
    {
        ClearPageMessages();
        if (e.CommandName == "ShowStaticListContents")
        {
            VMI.Checked = false;
            Static.Checked = true;
            Single.Checked = false;
            Excel.Checked = false;
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = StaticListsGrid.Rows[index];
            dt = cpr.GetStaticListItems(row).Tables[0];
            Session[CurItemsName.Value] = null;
            Session[CurItemsName.Value] = dt;
            //DataView dv = new DataView(dt);
            ReportItemsGrid.DataSource = dt;
            ReportItemsGrid.DataBind();
            ItemCountLabel.Text = ReportItemsGrid.Rows.Count.ToString();
            lblSuccessMessage.Text = "Static List " + row.Cells[2].Text.ToString() + " loaded.";
        }

        if (e.CommandName == "DelStaticListContents")
        {
            if (hidDelConf.Value == "true")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = StaticListsGrid.Rows[index];
                cpr.DelStaticListItems(row);

                lblSuccessMessage.Text = "Static List " + row.Cells[2].Text.ToString() + " deleted.";
                BindStaticLists();
            }
        }
    }

    protected void ExceptionListCommand(object source, GridViewCommandEventArgs e)
    {
        ClearPageMessages();
        if (e.CommandName == "ShowExceptionListContents")
        {
            VMI.Checked = false;
            Static.Checked = false;
            Single.Checked = false;
            Excel.Checked = false;
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = ExceptionListsGrid.Rows[index];
            dt = cpr.GetExceptionListItems(row).Tables[0];
            Session[CurItemsName.Value] = null;
            Session[CurItemsName.Value] = dt;
            //DataView dv = new DataView(dt);
            ReportItemsGrid.DataSource = dt;
            ReportItemsGrid.DataBind();
            ItemCountLabel.Text = ReportItemsGrid.Rows.Count.ToString();
            lblSuccessMessage.Text = "AD Exception List " + row.Cells[1].Text.ToString() + " from " + row.Cells[0].Text.ToString() + " loaded.";
        }

        if (e.CommandName == "DelExceptionListContents")
        {
            if (hidDelConf.Value == "true")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = ExceptionListsGrid.Rows[index];
                string whereclause = cpr.DelExceptionListItems(row);

                lblSuccessMessage.Text = "AD Exception List " + row.Cells[1].Text.ToString() + " from " + row.Cells[0].Text.ToString() + " deleted.";
                //lblSuccessMessage.Text = whereclause.ToString();
                BindExceptionLists();
            }
        }
    }

    protected void ExcelLoadButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        VMI.Checked = false;
        Static.Checked = false;
        Single.Checked = false;
        Excel.Checked = true;
        FilteredItems.Checked = false;
        if (ExcelFileUpload.HasFile)
        {
            dt = ParseExcelFile();
            Session[CurItemsName.Value] = null;
            Session[CurItemsName.Value] = dt;
            ReportItemsGrid.DataSource = dt;
            ReportItemsGrid.DataBind();
            ItemCountLabel.Text = ReportItemsGrid.Rows.Count.ToString();
        }
        else
        {
            lblErrorMessage.Text = "Use the Browse button to select a file or enter a file path manually";
        }

    }

    protected void StaticSearchButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        ListPanelLabel.Text = "Static";
        VMI.Checked = false;
        Static.Checked = true;
        Single.Checked = false;
        Excel.Checked = false;
        FilteredItems.Checked = false;
        dt = cpr.GetStaticLists(StaticListDDL.SelectedValue.ToString()).Tables[0];
        if (dt.Rows.Count == 0)
        {
            lblErrorMessage.Text = "Problem with static lists.";
        }
        else
        {
        }
        StaticListsGrid.DataSource = dt.DefaultView.ToTable();
        StaticListsGrid.DataBind();
        StaticListsGrid.Visible = true;
        ExceptionListsGrid.Visible = false;
    }

    protected void GetListButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        Static.Checked = false;
        Single.Checked = false;
        Excel.Checked = false;
        VMI.Checked = false;
        FilteredItems.Checked = true;
        dt = cpr.GetFilteredItems(BegCatTextBox.Text.ToString()
            , EndCatTextBox.Text.ToString()
            , BegSizeTextBox.Text.ToString()
            , EndSizeTextBox.Text.ToString()
            , BegVarTextBox.Text.ToString()
            , EndVarTextBox.Text.ToString()
            , BegCFVCTextBox.Text.ToString().ToUpper()
            , EndCFVCTextBox.Text.ToString().ToUpper()
            , Session["UserName"].ToString()
            ).Tables[0];
        Session[CurItemsName.Value] = null;
        Session[CurItemsName.Value] = dt;
        ReportItemsGrid.DataSource = dt;
        ReportItemsGrid.DataBind();
        ItemCountLabel.Text = ReportItemsGrid.Rows.Count.ToString();
    }

    protected void VMILoadButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        Static.Checked = false;
        Single.Checked = false;
        Excel.Checked = false;
        VMI.Checked = true;
        FilteredItems.Checked = false;
        dt = cpr.GetVMIContractItems(VMIContractDDL.SelectedValue.ToString()).Tables[0];
        Session[CurItemsName.Value] = null;
        Session[CurItemsName.Value] = dt;
        ReportItemsGrid.DataSource = dt;
        ReportItemsGrid.DataBind();
        ItemCountLabel.Text = ReportItemsGrid.Rows.Count.ToString();
    }

    protected void ShowStaticList_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        ListPanelLabel.Text = "Static";
        dt = cpr.GetStaticLists().Tables[0];
        if (dt.Rows.Count == 0)
        {
            lblErrorMessage.Text = "Problem with static lists.";
        }
        else
        {
        }
        StaticListsGrid.DataSource = dt.DefaultView.ToTable();
        StaticListsGrid.DataBind();
        StaticListsGrid.Visible = true;
        ExceptionListsGrid.Visible = false;
    }

    protected void ShowADExceptionList_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        ListPanelLabel.Text = "Auto Distribution Exception";
        ExceptionListsGrid.Visible = true;
        StaticListsGrid.Visible = false;
    }

    protected void ClearPageMessages()
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
    }

    protected string CurItemKey()
    {
        if (ReportType.Value == "Buy")
        {
            return ReportType.Value.ToString() + Session["UserName"].ToString();
        }
        else
        {
            return Session["UserName"].ToString();
        }
    }

    protected void RunReportButt_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        Boolean ReportOK = false;
        if (Single.Checked)
        {
            if (SingleItemNo.Text != "")
            {
                dt = cpr.LoadCurrentItems(CurItemKey(), SingleItemNo.Text).Tables[0];
                Session[CurItemsName.Value] = null;
                Session[CurItemsName.Value] = dt;
                ReportOK = true;
            }
            else
            {
                lblErrorMessage.Text = " A Single Item number is required or there must a Items to Report";
                SingleItemNo.Focus();
                return;
            }
        }
        if (CreateStaticList.Checked)
        {
            if (NewStaticListName.Text != "")
            {
                cpr.CreateStaticList(Session["UserName"].ToString(), NewStaticListName.Text, ReportItemsGrid);
                BindListTypeDDL();
                BindStaticLists();
            }
            else
            {
              lblErrorMessage.Text = "Static List name is required";
              NewStaticListName.Focus();
              return;
            }
        }
        if (!Single.Checked)
        {      
            if (ReportItemsGrid.Rows.Count > 0)
            {
                cpr.LoadCurrentItems(CurItemKey(), ReportItemsGrid);
                ReportOK = true;
            }
            else
            {
                lblErrorMessage.Text = "There are no Items to Report";
                NewStaticListName.Focus();
                return;
            }
        }
        if (ReportOK)
        {
            Session["VMIRun"] = VMI.Checked;
            Session["VMIContractCode"] = VMIContractDDL.SelectedValue.ToString();
            string NextPage = "ReportPrompts.aspx";
            if (ReportType.Value == "Buy")
            {
                NextPage = "ReportPrompts.aspx?Type=Buy";
            }
            Server.Transfer(NextPage);
        }
    }
}