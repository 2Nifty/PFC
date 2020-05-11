
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
using PFC.Intranet;


namespace PFC.Intranet
{
    public partial class ItemControl : System.Web.UI.UserControl
    {
        #region Variable declaration

        public event EventHandler PackageChange;
        public event EventHandler Change;
        ItemBuilder itemBuilder = new ItemBuilder();
        DataTable dtItem = new DataTable();
        DataTable dtplating = new DataTable();
        private string _tableName = string.Empty;
        private string _columnNames = string.Empty;
        private string _whereClause = string.Empty;
        HiddenField hidPagevalue = new HiddenField();
        private string hidflag = "true";       
        HiddenField hidButton = new HiddenField();
        DataTable dtCustomerInformation = new DataTable();
        private string connectionString = string.Empty;
        //Utility utilityFunction = new Utility();
        string Category = "";
        string HeaderImageName = "";
        string BodyImageName = "";
        string ImageLibrary = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() + ConfigurationManager.AppSettings["ProductImagesPath"].ToString();
        string imgPath = "";
        string PFCERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();        
        DataSet dsImage = new DataSet();
        DataTable dtImage = new DataTable();
        DataTable dtItemNo = new DataTable();
        int tbIndex = 1;
        #endregion

        #region Property Bag
        private string strItem = string.Empty;
        /// <summary>
        /// PFC ItemNumber 
        /// </summary>
        public string ItemNumber
        {
            get { return strItem; }
            set { strItem = value; }
        }
        #endregion

        #region HAndlers

        /// <summary>
        /// Onvalue Change Event Handler
        /// </summary>
        /// <param name="e"></param>
        protected void OnValueChange(EventArgs e)
        {
            if (PackageChange != null)
            {
                PackageChange(this, e);
            }
        }
        /// <summary>
        /// onchange event handler
        /// </summary>
        /// <param name="e">EventArgs</param>
        protected void OnChange(EventArgs e)
        {
            if (Change != null)
            {
                Change(this, e);
            }
        }

        #endregion

        #region pageLoad
        protected void Page_Load(object sender, EventArgs e)
        {

            //dtCustomerInformation = itemBuilder.GetCustomerID(Session["CustNo"].ToString());
            //if(Request.QueryString["Internet"] !=null)
            //    lblCustNo.Text = Session["CustNo"].ToString() + " " + dtCustomerInformation.Rows[0]["Name1"].ToString();
         

            Ajax.Utility.RegisterTypeForAjax(typeof(ItemControl));
            if (Session["ItemFamily"] != null)
            {
               
                if (ViewState["ItemFamily"].ToString() != Session["ItemFamily"].ToString())
                {
                    LoadProductLine();
                }

            }
            else
            {
                dgProductLine.Visible = false;
            }
        }
        #endregion

        public void UpdateValue()
        {
            LoadProductLine();
        }

        //UpdateValue :method used to update value
        private void LoadProductLine()
        {
            
            tblProduct.Visible = true;
            tblResult.Visible = false;
            lstBoxPlating.Visible = false;
            lblMessage.Visible = false;
           
            if (Session["ItemFamily"] != null)
            {
                itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
                dtItem = itemBuilder.GetItemProductLine();
                string ItemFamily = itemBuilder.ItemFamily;
                dtplating = itemBuilder.GetProduct();
                lblProduct.Text = dtplating.Rows[0]["DESCR"].ToString();
                ViewState["ItemFamily"] = Session["ItemFamily"].ToString();
                dgProductLine.Visible = true;

                if (Page.IsPostBack)
                {
                    if (dtItem != null)
                    {

                        dgProductLine.DataSource = dtItem;
                        ViewState["DS"] = dtItem;
                        dgProductLine.CurrentPageIndex = 0;
                        dgProductLine.DataBind();
                        tblFilter.Visible = false;
                        
                        lblCategoryItem.Visible = false;
                        lblProduct.Visible = true;
                        dtItemNo = itemBuilder.GetItemID(ItemFamily);
                        string categoryNo = dtItemNo.Rows[0]["Category"].ToString();
                        BindImage(categoryNo);
                        
                        // Since No image for product line in DB, hide the images
                        BodyImage.Visible = false;
                        HeadImage.Visible = false;

                    }
                }

            }
        }

        protected void BindImage(string CategoryNo)
        {
            if (CategoryNo != "")
            {
                Category = CategoryNo;
                string ColumnNames = "Category,BodyFileName,HeadFileName,TechSpec";
                dtImage = itemBuilder.BindImage(PFCERPConnectionString, ColumnNames, Category);

                if (dtImage.Rows.Count > 0)
                {
                    BodyImageName = dtImage.Rows[0]["BodyFileName"].ToString();
                    HeaderImageName = dtImage.Rows[0]["HeadFileName"].ToString();
                    BodyImage.ImageUrl = ImageLibrary + BodyImageName;
                    HeadImage.ImageUrl = ImageLibrary + HeaderImageName;
                    SetBodyImageSize();
                    SetHeaderImageSize();
                    imageDescription.Text = (dtImage.Rows[0]["TechSpec"].ToString() != "\0" ? dtImage.Rows[0]["TechSpec"].ToString() : "");
                    BodyImage.Visible = true;
                    HeadImage.Visible = true;
                    imageDescription.Visible = true;
                }
                else
                {
                    BodyImage.Visible = false;
                    HeadImage.Visible = false;
                    imageDescription.Visible = false;
                }
            }
        }

        private void SetBodyImageSize()
        {
            imgPath = Server.MapPath("../" + ConfigurationManager.AppSettings["ProductImagesPath"].ToString());
            try
            {
                System.Drawing.Image bimg = System.Drawing.Image.FromFile(imgPath + BodyImageName);
                int MaxWidth = 300;
                int MaxHeight = 75;
                if (bimg.Width > MaxWidth || bimg.Height > MaxHeight)
                {
                    double widthRatio = (double)bimg.Width / (double)MaxWidth;
                    double heightRatio = (double)bimg.Height / (double)MaxHeight;
                    double ratio = Math.Max(widthRatio, heightRatio);
                    int newWidth = (int)(bimg.Width / ratio);
                    int newHeight = (int)(bimg.Height / ratio);
                    BodyImage.Width = Unit.Pixel(newWidth);
                    BodyImage.Height = Unit.Pixel(newHeight);
                }
            }
            catch (Exception)
            {

            }
        }

        private void SetHeaderImageSize()
        {
            imgPath = Server.MapPath("../" + ConfigurationManager.AppSettings["ProductImagesPath"].ToString());
            try
            {

                System.Drawing.Image bimg = System.Drawing.Image.FromFile(imgPath + HeaderImageName);
                int MaxWidth = 300;
                int MaxHeight = 75;
                if (bimg.Width > MaxWidth || bimg.Height > MaxHeight)
                {
                    double widthRatio = (double)bimg.Width / (double)MaxWidth;
                    double heightRatio = (double)bimg.Height / (double)MaxHeight;
                    double ratio = Math.Max(widthRatio, heightRatio);
                    int newWidth = (int)(bimg.Width / ratio);
                    int newHeight = (int)(bimg.Height / ratio);
                    HeadImage.Width = Unit.Pixel(newWidth);
                    HeadImage.Height = Unit.Pixel(newHeight);
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void dgProductLine_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Session["ItemLength"] = null;
                Session["ItemDiameter"] = null;
                Label lblProduct = e.Item.FindControl("lblProduct") as Label;
                DataList dlProductItem = e.Item.FindControl("dlProductItem") as DataList;
                HiddenField hidProductLine = e.Item.FindControl("hidProduct") as HiddenField;
                itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
                itemBuilder.ItemProductLine = hidProductLine.Value;
                dtItem = itemBuilder.GetItemCatagory();
                dlProductItem.DataSource = dtItem;
                dlProductItem.DataBind();


            }

        }
      
        protected void lnkProductItem_Click(object sender, EventArgs e)
        {

            Session["ItemLength"] = null;
            Session["ItemDiameter"] = null;

            #region Code to get the parameter details
            lblQueryMessage.Visible = false;
            lblCategoryItem.Visible = true;
            lblProduct.Visible = false;
            lblMessage.Visible = false;
         
            tblResult.Visible = true;
            tblFilter.Visible = true;
            tblProduct.Visible = false;
            lstBoxPackage.Visible = false;
            lstBoxPlating.Visible = false;
            ViewState["Plating"] = "";
            ViewState["Package"] = "";
            BindDataGridFilter();
            BindListPlating();
            BindPackage();

            #endregion
        }

        protected void BindDataGridFilter()
        {
            
            tblFilterPager.Visible = true;
            lblMessage.Visible = false;
            tblFilter.Visible = true;
            lblQueryMessage.Visible = false;
            string categoryNumber = "";
            string categoryItem = "";
            string productLine = "";
            try
            {

                categoryNumber = Request.QueryString["CategoryID"].ToString();
                categoryItem = Request.QueryString["CategoryItem"].ToString();
                productLine = Request.QueryString["ProductLine"].ToString();

            }
            catch (Exception ex)
            {
                categoryNumber = Session["CategoryID"].ToString();
                categoryItem = Session["CategoryItem"].ToString();
                productLine = Session["ProductLine"].ToString();
            }

            lblCategoryItem.Text = Request.QueryString["CategoryItem"].ToString();
            
            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            itemBuilder.ItemProductLine = productLine;
            itemBuilder.ItemCategory = categoryNumber;
            string Package = " AND ( a.ItemId IS NOT NULL)";
            dtItem = itemBuilder.GetItemNumberWithCrossReference(Session["CustNo"].ToString(),Package);
            dtItem.Columns.Add("Select");
            foreach (DataRow dr in dtItem.Rows)
                dr["Select"] = "False";
            if (dtItem != null && dtItem.Rows.Count != 0)
            {
                if (dtItem.DefaultView.ToTable() != null && dtItem.DefaultView.ToTable().Rows.Count > 0)
                {
                    dgFinalFilter.CurrentPageIndex = 0;
                    dgFinalFilter.DataSource = dtItem.DefaultView;
                    dgFinalFilter.DataBind();
                    ViewState["DT"] = dtItem.DefaultView.ToTable();
                    ddlFinalFilter.Items.Clear();
                    for (int intcount = 0; intcount < dgFinalFilter.PageCount; intcount++)
                    {
                        ListItem LI = new ListItem();
                        LI.Value = Convert.ToString(intcount);
                        LI.Text = Convert.ToString(intcount + 1) + " of " + dgFinalFilter.PageCount.ToString();
                        ddlFinalFilter.Items.Add(LI);
                    }
                    FinalFilter();
                    checkFocus();

                    BindImage(categoryNumber);

                }
                else
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Cross-reference item cannot be found";
                    lblQueryMessage.Visible = false;
                    tblFilter.Visible = false;
                }
            }
            else
            {
               
                lblQueryMessage.Visible = false;
                lblMessage.Visible = true;
                tblFilter.Visible = false;
                
            }
           
        }

        protected void BindListPlating()
        {
            itemBuilder.ItemProductLine = Request.QueryString["ProductLine"].ToString();
            itemBuilder.ItemCategory = Request.QueryString["CategoryID"].ToString();

            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();           
            dtplating = itemBuilder.GetPlating();

            //this is for IE 6
            lstBoxPlating.Height = Unit.Pixel((dtplating.Rows.Count == 0) ? (int)(48) : (dtplating.Rows.Count == 1) ? (int)(48) : (dtplating.Rows.Count == 2) ? (int)(48) :70);

            //this is for IE 7
            //lstBoxPlating.Height = Unit.Pixel((dtplating.Rows.Count == 0) ? (int)(40) : (dtplating.Rows.Count == 1) ? (int)(40) : (dtplating.Rows.Count == 2) ? (int)(50) : 81);


            itemBuilder.BindListControls(lstBoxPlating, "PLATINGDESC", "PLATING", dtplating);
            lstBoxPlating.SelectedIndex = 0;

        }

        protected void BindPackage()
        {
            itemBuilder.ItemProductLine = Request.QueryString["ProductLine"].ToString();
            itemBuilder.ItemCategory = Request.QueryString["CategoryID"].ToString();

            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
            itemBuilder.ItemPlating = ((ViewState["Plating"] == null) ? "" : ViewState["Plating"].ToString());
            dtItem = itemBuilder.GetPackage();

            //this is for IE 6
            lstBoxPackage.Height = Unit.Pixel((dtItem.Rows.Count == 0) ? (int)(48) : (dtItem.Rows.Count == 1) ? (int)(48) : (dtItem.Rows.Count == 2) ? (int)(48) :70);

            //this is for IE 7
            //lstBoxPackage.Height = Unit.Pixel((dtItem.Rows.Count == 0) ? (int)(40) : (dtItem.Rows.Count == 1) ? (int)(40) : (dtItem.Rows.Count == 2) ? (int)(50) : 81);



            itemBuilder.BindListControls(lstBoxPackage, "AppOptionValue", "AppOptionNumber", dtItem);
            lstBoxPackage.SelectedIndex = 0;
        }

        protected void dlProductItem_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lnkProductItem = (LinkButton)e.Item.FindControl("lnkProductItem") as LinkButton;
                HiddenField hidCategoryID = (HiddenField)e.Item.FindControl("hidCategoryID") as HiddenField;
                dtItem = itemBuilder.GetProductLine(hidCategoryID.Value);
                Session["ProductLine"] = dtItem.Rows[0][0].ToString();
                Session["CategoryID"] = hidCategoryID.Value.ToString();                
                lnkProductItem.PostBackUrl = lnkProductItem.PostBackUrl + "&CustomerNumber=" + Session["CustNo"].ToString()+ "&CategoryID=" + Session["CategoryID"].ToString() + "&ProductLine=" + Session["ProductLine"].ToString();
            }

        }

        protected void btnGetResults_Click(object sender, EventArgs e)
        {
            LoadProductLine();

        }

        protected void checkFocus()
        {

            foreach (DataGridItem dgItem in dgFinalFilter.Items)
            {
                // #region Cast the control in the datagrid               
                TextBox txtCustomerNo = dgItem.FindControl("txtCustomerNo") as TextBox;
                if (txtCustomerNo.Text == "" && hidflag == "true")
                {
                    ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                    scriptManager.SetFocus(txtCustomerNo);
                    hidflag = "false";
                    break;
                }
            }

        }

        protected void btnPlating_Click(object sender, EventArgs e)
        {

            if (lblQueryMessage.Visible == false)
            {
                BindListPlating();
                lstBoxPlating.Visible = true;
                // lstBoxPlating.Visible = (lstBoxPlating.Visible == true ? false : true);

            }
            ViewState["Plating"] = "";
            ViewState["Package"] = "";
            BindDataGridFilter();
            BindListPlating();
            BindPackage();
            lstBoxPackage.Visible = false;

        }

        protected void btnPackage_Click(object sender, EventArgs e)
        {
            if (lblQueryMessage.Visible == false)
            {             
                BindPackage();
                lstBoxPackage.Visible = true;
            }         
            ViewState["Package"] = "";
            filter();
            lstBoxPackage.Visible = true;
            

        }

        #region Fianl Grid Pager Events  

        protected void btnlast_Command(object sender, CommandEventArgs e)
        {
            dgFinalFilter.CurrentPageIndex = 0;
            dgFinalFilter.DataSource = (DataTable)ViewState["DT"];
            dgFinalFilter.DataBind();
            ddlFinalFilter.SelectedIndex = dgFinalFilter.CurrentPageIndex;
            FinalFilter();
        }

        protected void btnBack_Command(object sender, CommandEventArgs e)
        {
            dgFinalFilter.CurrentPageIndex = dgFinalFilter.CurrentPageIndex - 1;
            dgFinalFilter.DataSource = (DataTable)ViewState["DT"];
            dgFinalFilter.DataBind();
            ddlFinalFilter.SelectedIndex = dgFinalFilter.CurrentPageIndex;
            FinalFilter();
        }

        protected void ddlFinalFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgFinalFilter.CurrentPageIndex = Convert.ToInt32(ddlFinalFilter.SelectedItem.Value);
            dgFinalFilter.DataSource = (DataTable)ViewState["DT"];
            dgFinalFilter.DataBind();
            FinalFilter();
            checkFocus();
        }

        protected void btnForward_Command(object sender, CommandEventArgs e)
        {
            dgFinalFilter.CurrentPageIndex = dgFinalFilter.CurrentPageIndex + 1;
            dgFinalFilter.DataSource = (DataTable)ViewState["DT"];
            dgFinalFilter.DataBind();
            ddlFinalFilter.SelectedIndex = dgFinalFilter.CurrentPageIndex;
            FinalFilter();
        }

        protected void btnFirst_Command(object sender, CommandEventArgs e)
        {

            dgFinalFilter.CurrentPageIndex = dgFinalFilter.PageCount - 1;
            dgFinalFilter.DataSource = (DataTable)ViewState["DT"];
            dgFinalFilter.DataBind();
            ddlFinalFilter.SelectedIndex = dgFinalFilter.CurrentPageIndex;
            FinalFilter();

        }
        #endregion        

        void FinalFilter()
        {
            btnBack.Enabled = true;
            btnFirst.Enabled = true;
            btnForward.Enabled = true;
            btnlast.Enabled = true;

            //string chkDCUser = Session["UserName"].ToString().Trim();
            //if (chkDCUser == "DC")
            //    btnClose.Style.Add(HtmlTextWriterStyle.Display, "none");
            //else
            //    btnClose.Style.Add(HtmlTextWriterStyle.Display, "");

            if (dgFinalFilter.CurrentPageIndex == 0)
            {
                btnlast.Enabled = false;
                btnBack.Enabled = false;
            }
            if (dgFinalFilter.CurrentPageIndex == dgFinalFilter.PageCount - 1)
            {
                btnFirst.Enabled = false;
                btnForward.Enabled = false;
            }
        }
        
        protected void txtCustomerNo_TextChanged(object sender, EventArgs e)
        {
            TextBox txtCustomerNo = sender as TextBox;
            DataGridItem dgItem = txtCustomerNo.Parent.Parent as DataGridItem;
            //CheckBox chkDelete = dgItem.FindControl("chkDelete") as CheckBox;
            //chkDelete.Checked = false;
            LinkButton lnkdelete = dgItem.FindControl("LinkButton2") as LinkButton;
            LinkButton lnkedit = dgItem.FindControl("LinkButton1") as LinkButton;
            Label lblCustNo = dgItem.FindControl("lblCustomerNo") as Label;
            Label lblDeleteId = dgItem.FindControl("lblID") as Label;
            //lnkdelete.Enabled = false;
            string pfcItemNumber = dgItem.Cells[0].Text;
            string customerItemNo = txtCustomerNo.Text.Replace("'", "''");
            string UOM = (dgItem.Cells[3].Text.Split('/').Length == 2 ? dgItem.Cells[3].Text.Split('/')[1].Trim() : "");
            string description = dgItem.Cells[2].Text;

            dtItem = itemBuilder.GetCustValidation(customerItemNo, Session["CustNo"].ToString());
            if ((dtItem != null && dtItem.Rows.Count > 0) && txtCustomerNo.Text.Trim() != "")
            {
                ScriptManager.RegisterClientScriptBlock(txtCustomerNo, txtCustomerNo.GetType(), "Check", "javascript:alert('Customer Number does not allow duplicate information')", true);
                txtCustomerNo.Text = "";
                if (lblCustNo.Text != "")
                {
                    lblCustNo.Visible = false;
                }
                ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                scriptManager.SetFocus(txtCustomerNo);

            }
            else
            {
                string newpItemAliasID = itemBuilder.updateRecords(Session["CustNo"].ToString(), customerItemNo, pfcItemNumber, UOM, description,lblDeleteId.Text);
                lblDeleteId.Text = newpItemAliasID;

                DataTable dt = ViewState["DT"] as DataTable;
                DataRow[] dr = dt.Select("ItemNo='" + pfcItemNumber + "'");
                dr[0]["CrossRefNumber"] = customerItemNo;
                dt.AcceptChanges();
                ViewState["DT"] = dt;
                lblCustNo.Style.Add("display","block");
                //chkDelete.Enabled = (customerItemNo =="")?false:true;
                lnkdelete.Enabled = (customerItemNo == "") ? false : true;
                lnkedit.Enabled = (customerItemNo == "") ? false : true;
                if (txtCustomerNo.Text == "")
                {
                    lblCustNo.Visible = false;
                    ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                    scriptManager.SetFocus(txtCustomerNo);
                }
                else
                {
                    lnkdelete.Attributes.Add("onclick", "return confirm('Do you want to delete selected Customer No.?');");
                    lblCustNo.Visible = true;
                    lblCustNo.Text = txtCustomerNo.Text;
                    txtCustomerNo.Visible = false;
                    
                    //focus the next textbox
                    int selectedRow = dgItem.ItemIndex;
                    for (int count = selectedRow; count < dgFinalFilter.Items.Count; count++)
                    {
                        TextBox txtCustNo = dgFinalFilter.Items[count].FindControl("txtCustomerNo") as TextBox;
                        if (txtCustNo.Visible)
                        {
                            ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                            scriptManager.SetFocus(txtCustNo);
                            break;
                        }
                    } 
                }    
                
            }
        }        

        protected void lstBoxPlating_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            tblFilter.Visible = true;
            string selectedTextField = lstBoxPlating.SelectedItem.Text;
            string selectedValueField = lstBoxPlating.SelectedValue;
           
            DataTable dt = new DataTable("Plating");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "PLATINGDESC";
            dc.DataType = typeof(String);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "PLATING";
            dc1.DataType = typeof(String);

            dt.Columns.Add(dc);
            dt.Columns.Add(dc1);


            DataRow dr = dt.NewRow();
            dr["PLATINGDESC"] = selectedTextField;
            dr["PLATING"] = selectedValueField;
            dt.Rows.Add(dr);
            //string chkDCUser = Session["UserName"].ToString().Trim();
            //if (chkDCUser == "DC")
            //    btnClose.Style.Add(HtmlTextWriterStyle.Display, "none");
            //else
            //    btnClose.Style.Add(HtmlTextWriterStyle.Display, "");
            ViewState["Plating"] = selectedValueField;
            lstBoxPlating.DataSource = dt;
            lstBoxPlating.DataTextField = "PLATINGDESC";
            lstBoxPlating.DataValueField = "PLATING";
            lstBoxPlating.DataBind();
           // lstBoxPlating.SelectedIndex = 0;
            lstBoxPlating.Height = Unit.Pixel((dt.Rows.Count > 3) ? (int)(70) :20);
           filter();

           
        }

        protected void filter()
        {
            itemBuilder.ItemProductLine = Request.QueryString["ProductLine"].ToString();
            itemBuilder.ItemCategory = Request.QueryString["CategoryID"].ToString();
            itemBuilder.ItemFamily = Session["ItemFamily"].ToString();
           // string pack = lstBoxPackage.SelectedItem.Text.ToString();
            itemBuilder.ItemPlating =((ViewState["Plating"] ==null)?"":ViewState["Plating"].ToString());
            string _package = ((ViewState["Package"] == null || ViewState["Package"].ToString()=="") ? "" : ViewState["Package"].ToString());
            

            if (_package == "")
            {
                _package = "AND ( a.ItemId IS NOT NULL)";
            }
            else
            {
                _package = " AND (SUBSTRING( a.ItemId, 12, 1))='" + _package + "'";
            }
            dtItem = itemBuilder.GetItemNumberWithCrossReference(Session["CustNo"].ToString(),_package);

            dtItem.Columns.Add("Select");
            //foreach (DataRow dr1 in dtItem.Rows)
            //    dr["Select"] = "False";
            if (dtItem != null && dtItem.Rows.Count != 0)
            {
                if (dtItem.DefaultView.ToTable() != null && dtItem.DefaultView.ToTable().Rows.Count > 0)
                {
                    dgFinalFilter.CurrentPageIndex = 0;
                    dgFinalFilter.DataSource = dtItem.DefaultView;
                    dgFinalFilter.DataBind();
                    ViewState["DT"] = dtItem.DefaultView.ToTable();
                    ddlFinalFilter.Items.Clear();
                    for (int intcount = 0; intcount < dgFinalFilter.PageCount; intcount++)
                    {
                        ListItem LI = new ListItem();
                        LI.Value = Convert.ToString(intcount);
                        LI.Text = Convert.ToString(intcount + 1) + " of " + dgFinalFilter.PageCount.ToString();
                        ddlFinalFilter.Items.Add(LI);
                    }
                    FinalFilter();
                    checkFocus();
                    tblFilter.Visible = true;
                    lblMessage.Visible = false;
                }
                else
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "Cross-reference item cannot be found";
                    lblQueryMessage.Visible = false;
                    tblFilter.Visible = false;
                }
            }
            else
            {

                lblMessage.Visible = true;
                lblQueryMessage.Visible = false;
                tblFilter.Visible = false;
            }
        }

        protected void lstBoxPackage_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedTextField = lstBoxPackage.SelectedItem.Text;
            string selectedValueField = lstBoxPackage.SelectedValue;
            lblMessage.Visible = false;
            tblFilter.Visible = true;
            DataTable dt = new DataTable("Package");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "AppOptionValue";
            dc.DataType = typeof(String);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "AppOptionNumber";
            dc1.DataType = typeof(String);

            dt.Columns.Add(dc);
            dt.Columns.Add(dc1);


            DataRow dr = dt.NewRow();
            dr["AppOptionValue"] = selectedTextField;
            dr["AppOptionNumber"] = selectedValueField;
            dt.Rows.Add(dr);
            ViewState["Package"] = selectedValueField;
            
            lstBoxPackage.DataSource = dt;
            lstBoxPackage.DataTextField = "AppOptionValue";
            lstBoxPackage.DataValueField = "AppOptionNumber";
            lstBoxPackage.DataBind();
            //lstBoxPackage.SelectedIndex = 0;
            lstBoxPackage.Height = Unit.Pixel((dt.Rows.Count > 3) ? (int)(80) :20);
            filter();
         

        }

        protected void dgFinalFilter_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton deleteButton = e.Item.FindControl("LinkButton2") as LinkButton;
                TextBox txtCustNo = e.Item.FindControl("txtCustomerNo") as TextBox;
                Label lblCustNo = e.Item.FindControl("lblCustomerNo") as Label;
                if (txtCustNo.Text != "")
                {
                    deleteButton.Attributes.Add("onclick", "return confirm('Do you want to delete selected Customer No.?');");
                   
                }
                    
                txtCustNo.TabIndex = Convert.ToInt16(tbIndex);
                tbIndex++;
            }

        }

        protected void dgFinalFilter_DeleteCommand(object source, DataGridCommandEventArgs e)
        {
            string pfcItemNumber = e.Item.Cells[0].Text;
            Label lblCustNo = e.Item.FindControl("lblCustomerNo") as Label;
            LinkButton lnkDelete = e.Item.FindControl("LinkButton2") as LinkButton;
            LinkButton lnkEdit = e.Item.FindControl("LinkButton1") as LinkButton;
            Label lbldeleteID = e.Item.FindControl("lblID") as Label;
            itemBuilder.DeleteCrossReferenceNumber(pfcItemNumber, lblCustNo.Text, Session["CustNo"].ToString());
            TextBox txtCustNo = e.Item.Cells[1].FindControl("txtCustomerNo") as TextBox;
            txtCustNo.Text = "";

            DataTable dt = ViewState["DT"] as DataTable;
            DataRow[] dr = dt.Select("ItemNo='" + pfcItemNumber + "'");
            dr[0]["CrossRefNumber"] = "";
            dt.AcceptChanges();
            ViewState["DT"] = dt;

            txtCustNo.Visible = true;
            lblCustNo.Visible = false;
            lnkDelete.Enabled = false;
            lnkEdit.Enabled = false;
            lnkDelete.Attributes.Add("onclick", "false");
            ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
            scriptManager.SetFocus(txtCustNo);
        }

        protected void dgFinalFilter_EditCommand(object source, DataGridCommandEventArgs e)
        {
           
            Label lblCustNo = e.Item.FindControl("lblCustomerNo") as Label;
            TextBox txtCustNo = e.Item.Cells[1].FindControl("txtCustomerNo") as TextBox;
            if (lblCustNo.Text != "")
            {
                txtCustNo.Visible = true;
                lblCustNo.Visible = true;
                lblCustNo.Style.Add("display", "none");
                ScriptManager scriptManager = Page.FindControl("MyScript") as ScriptManager;
                scriptManager.SetFocus(txtCustNo);
                LinkButton lnkedit = e.Item.Cells[1].FindControl("LinkButton1") as LinkButton;
                LinkButton lnkdelete = e.Item.Cells[1].FindControl("LinkButton2") as LinkButton;
                txtCustNo.Attributes.Add("onblur", "javascript:CheckEmpty('" + lblCustNo.ClientID + "','" + txtCustNo.ClientID + "');");               
            }

            // Method to close other textboxes opened in previuos edit command
            foreach (DataGridItem dgItem in dgFinalFilter.Items)
            {
                TextBox openTextBox = dgItem.Cells[1].FindControl("txtCustomerNo") as TextBox;
                Label openCustNo = dgItem.Cells[1].FindControl("lblCustomerNo") as Label;

                if ((openTextBox.ClientID != txtCustNo.ClientID) && openCustNo.Text != "" && openTextBox.Text.Trim() != "")
                {
                    openTextBox.Visible = false;
                    openCustNo.Style.Add("display", "");
                    openCustNo.Visible = true;
                }
            }

        }
    }
}












