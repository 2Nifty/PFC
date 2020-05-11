namespace  Novantus.Umbrella.UserControls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;


    #region Enum Declaration
    /// <summary>
    /// Enum for display fast pager 
    /// </summary>
    public enum PagerStyle
    {
        ComboEnabled,
        ComboDisabled
    }
    #endregion 

	/// <summary>
	///	Summary description for Pager.
	/// </summary>
	public partial class Pager : System.Web.UI.UserControl
	{
		public event EventHandler BubbleClick;
        private int gotoPageNumber;
        private int defaultPageSize = 20;
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if(!IsPostBack)
			{				
				gotoPageNumber=0;
				ViewState["GotoPageNumber"]="0";
               
			}
            else
            {
                gotoPageNumber = Convert.ToInt32(ViewState["GotoPageNumber"].ToString());
               
            }
           
		}

		public int GotoPageNumber
		{
			get
			{
				return gotoPageNumber;
			}

		}

		protected void OnBubbleClick(EventArgs e)
		{
			if(BubbleClick != null)
			{
				BubbleClick(this, e);
			}
        }

        #region Data grid Intialization Function
        public void InitPager(DataGrid dataGrid)
		{
			try
			{
				int currentPageIndex=dataGrid.CurrentPageIndex;
                int pageSize = defaultPageSize;
				//int totalNoOfRec=((DataTable)dataGrid.DataSource).Rows.Count;
				int totalNoOfRec;
				if( dataGrid.VirtualItemCount != 0)
					totalNoOfRec=dataGrid.VirtualItemCount;
				else
                    totalNoOfRec=((DataTable)dataGrid.DataSource).Rows.Count;
                if (totalNoOfRec > 0)
                {
                    int totalNumberOfPages = 0;

                    if (totalNoOfRec <= pageSize && totalNoOfRec > 0)
                    {
                        totalNumberOfPages = 1;
                    }
                    else
                    {
                        if (totalNoOfRec % pageSize == 0)
                            totalNumberOfPages = totalNoOfRec / pageSize;
                        else
                            totalNumberOfPages = totalNoOfRec / pageSize + 1;
                    }
                    if (totalNumberOfPages <= 0)
                    {
                        rnvGotoPage.MaximumValue = 0.ToString();
                        rnvGotoPage.MaximumValue = 0.ToString();

                    }
                    else
                        rnvGotoPage.MaximumValue = totalNumberOfPages.ToString();

                    if (currentPageIndex > 0 && currentPageIndex >= totalNumberOfPages)
                        dataGrid.CurrentPageIndex = totalNumberOfPages - 1;

                    // Hide the default Pager
                    dataGrid.ItemCreated += new DataGridItemEventHandler(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = defaultPageSize;
                    dataGrid.DataBind();
                    lblCurrentPageRecCount.Text = dataGrid.Items.Count.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    if (totalNumberOfPages != 0 && totalNumberOfPages<= currentPageIndex)
                        lblCurrentPage.Text = totalNumberOfPages.ToString();
                    else
                        lblCurrentPage.Text = (currentPageIndex + 1).ToString();
                    lblTotalPage.Text = totalNumberOfPages.ToString();
                    if (Convert.ToInt32(lblCurrentPage.Text.ToString()) > 1)
                    {
                        lblCurrentPageRecCount.Text = Convert.ToString(((((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize)+1));
                        lblCurrentTotalRec.Text = Convert.ToString(((((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize) + dataGrid.Items.Count));
                    }
                    else
                    {
                        lblCurrentPageRecCount.Text = "1";
                        lblCurrentTotalRec.Text = dataGrid.Items.Count.ToString();
                    }
                    InitPager(dataGrid.CurrentPageIndex, totalNumberOfPages, dataGrid.PageSize, PagerStyle.ComboEnabled);
                }
                else
                {
                    
                    dataGrid.CurrentPageIndex = 0;
                    ddlPages.Items.Clear();
                    dataGrid.ItemCreated += new DataGridItemEventHandler(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = defaultPageSize;
                    dataGrid.DataBind();
                    lblCurrentPageRecCount.Text = totalNoOfRec.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    lblCurrentPage.Text = totalNoOfRec.ToString();
                    lblTotalPage.Text = totalNoOfRec.ToString();
                    lblCurrentTotalRec.Text = totalNoOfRec.ToString();
                }

			}
			catch(Exception ex)
			{
				throw ex;
			}
			finally
			{
			}
		}
        /// <summary>
        /// Overridden method with custom page size
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="PageSize"></param>
        public void InitPager(DataGrid dataGrid, int PageSize)
        {
            try
            {
                int pageSize;
                int currentPageIndex = dataGrid.CurrentPageIndex;
                pageSize = PageSize;
                //int totalNoOfRec=((DataTable)dataGrid.DataSource).Rows.Count;
                int totalNoOfRec;
                if (dataGrid.VirtualItemCount != 0)
                    totalNoOfRec = dataGrid.VirtualItemCount;
                else
                    totalNoOfRec = ((DataTable)dataGrid.DataSource).Rows.Count;
                if (totalNoOfRec > 0)
                {
                    int totalNumberOfPages = 0;

                    if (totalNoOfRec <= pageSize && totalNoOfRec > 0)
                    {
                        totalNumberOfPages = 1;
                    }
                    else
                    {
                        if (totalNoOfRec % pageSize == 0)
                            totalNumberOfPages = totalNoOfRec / pageSize;
                        else
                            totalNumberOfPages = totalNoOfRec / pageSize + 1;
                    }
                    if (totalNumberOfPages <= 0)
                    {
                        rnvGotoPage.MaximumValue = 0.ToString();
                        rnvGotoPage.MaximumValue = 0.ToString();

                    }
                    else
                        rnvGotoPage.MaximumValue = totalNumberOfPages.ToString();

                    if (currentPageIndex > 0 && currentPageIndex >= totalNumberOfPages)
                        dataGrid.CurrentPageIndex = totalNumberOfPages - 1;

                    // Hide the default Pager
                    dataGrid.ItemCreated += new DataGridItemEventHandler(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = PageSize;
                    dataGrid.DataBind();

                    lblCurrentPageRecCount.Text = dataGrid.Items.Count.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    if (totalNumberOfPages != 0 && totalNumberOfPages <= currentPageIndex)
                        lblCurrentPage.Text = totalNumberOfPages.ToString();
                    else
                        lblCurrentPage.Text = (currentPageIndex + 1).ToString();
                    lblTotalPage.Text = totalNumberOfPages.ToString();
                    if (Convert.ToInt32(lblCurrentPage.Text.ToString()) > 1)
                    {
                        lblCurrentPageRecCount.Text = Convert.ToString(((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize);
                        lblCurrentTotalRec.Text = Convert.ToString(((((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize) + dataGrid.Items.Count));
                    }
                    else
                    {
                        lblCurrentPageRecCount.Text = "1";
                        lblCurrentTotalRec.Text = dataGrid.Items.Count.ToString();
                    }
                    InitPager(dataGrid.CurrentPageIndex, totalNumberOfPages, dataGrid.PageSize, PagerStyle.ComboEnabled);
                }
                else
                {

                    dataGrid.CurrentPageIndex = 0;
                    ddlPages.Items.Clear();
                    dataGrid.ItemCreated += new DataGridItemEventHandler(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = defaultPageSize;
                    dataGrid.DataBind();
                    lblCurrentPageRecCount.Text = totalNoOfRec.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    lblCurrentPage.Text = totalNoOfRec.ToString();
                    lblTotalPage.Text = totalNoOfRec.ToString();
                    lblCurrentTotalRec.Text = totalNoOfRec.ToString();
                    
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
            }
        }
        public void InitPager(DataGrid dataGrid, PagerStyle pagerStyle)
        {
            try
            {
                int currentPageIndex = dataGrid.CurrentPageIndex;
                dataGrid.CurrentPageIndex = 0;
                int pageSize = defaultPageSize;
                int totalNoOfRec;
                if (dataGrid.VirtualItemCount != 0)
                    totalNoOfRec = dataGrid.VirtualItemCount;
                else
                    totalNoOfRec = ((DataTable)dataGrid.DataSource).Rows.Count;
                if (totalNoOfRec > 0)
                {
                    int totalNumberOfPages = 0;

                    if (totalNoOfRec <= pageSize && totalNoOfRec > 0)
                    {
                        totalNumberOfPages = 1;
                    }
                    else
                    {
                        if (totalNoOfRec % pageSize == 0)
                            totalNumberOfPages = totalNoOfRec / pageSize;
                        else
                            totalNumberOfPages = totalNoOfRec / pageSize + 1;
                    }
                    if (totalNumberOfPages <= 0)
                    {
                        rnvGotoPage.MaximumValue = 0.ToString();
                        rnvGotoPage.MaximumValue = 0.ToString();

                    }
                    else
                        rnvGotoPage.MaximumValue = totalNumberOfPages.ToString();

                    if (currentPageIndex > 0 && currentPageIndex >= totalNumberOfPages)
                        dataGrid.CurrentPageIndex = totalNumberOfPages - 1;

                    // Hide the default Pager
                    dataGrid.ItemCreated += new DataGridItemEventHandler(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = defaultPageSize;
                    dataGrid.DataBind();

                    lblCurrentPageRecCount.Text = dataGrid.Items.Count.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    if (totalNumberOfPages != 0 && totalNumberOfPages <= currentPageIndex)
                        lblCurrentPage.Text = totalNumberOfPages.ToString();
                    else
                        lblCurrentPage.Text = (currentPageIndex + 1).ToString();
                    lblTotalPage.Text = totalNumberOfPages.ToString();
                    if (Convert.ToInt32(lblCurrentPage.Text.ToString()) > 1)
                    {
                        lblCurrentPageRecCount.Text = Convert.ToString(((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize);
                        lblCurrentTotalRec.Text = Convert.ToString(((((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize) + dataGrid.Items.Count));
                    }
                    else
                    {
                        lblCurrentPageRecCount.Text = "1";
                        lblCurrentTotalRec.Text = dataGrid.Items.Count.ToString();
                    }
                    InitPager(currentPageIndex, totalNumberOfPages, dataGrid.PageSize, pagerStyle);
                }
                else
                {

                    dataGrid.CurrentPageIndex = 0;
                    ddlPages.Items.Clear();
                    dataGrid.ItemCreated += new DataGridItemEventHandler(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = defaultPageSize;
                    dataGrid.DataBind();
                    lblCurrentPageRecCount.Text = totalNoOfRec.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    lblCurrentPage.Text = totalNoOfRec.ToString();
                    lblTotalPage.Text = totalNoOfRec.ToString();
                    lblCurrentTotalRec.Text= totalNoOfRec.ToString();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
            }
        }
        /// <summary>
        /// Override method to enable fast pager in modules generated by codepro
        /// </summary>
        /// <param name="currentPageIndex">Page index of the grid</param>
        /// <param name="totalPages">Total no of pages present in the grid</param>
        /// <param name="pageSize">No of grid lines to be displayed</param>
        /// <param name="pagerStyle">option to display combo box in the pager</param>
        public void InitPager(int currentPageIndex, int totalPages, int pageSize, PagerStyle pagerStyle)
        {
            bool isValidPage = (currentPageIndex >= 0 && currentPageIndex <= totalPages - 1);
            bool canMoveBack = (currentPageIndex > 0);
            bool canMoveForward = (currentPageIndex < totalPages - 1);

            try
            {
                ViewState["TotalPages"] = totalPages;
                ddlPages.Items.Clear();
                ibtnFirst.Enabled = isValidPage && canMoveBack;
                ibtnPrevious.Enabled = isValidPage && canMoveBack;
                btnNext.Enabled = isValidPage && canMoveForward;
                btnLast.Enabled = isValidPage && canMoveForward;
                if (PagerStyle.ComboEnabled == pagerStyle)
                {
                    for (int i = 0; i < totalPages; i++)
                    { ddlPages.Items.Add((i + 1).ToString()); }
                    if (gotoPageNumber > totalPages)
                    {
                        ddlPages.SelectedValue = totalPages.ToString();
                        gotoPageNumber = totalPages;
                        ViewState["GotoPageNumber"] = totalPages.ToString();
                        //ddlPages.SelectedValue = (gotoPageNumber + 1).ToString();
                    }
                    else
                        ddlPages.SelectedValue=(currentPageIndex+1).ToString();
                }
                else
                {
                    ddlPages.Visible = false;
                    txtGotoPage.Width = 50;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// Overridden method with custom page size
        /// </summary>
        /// <param name="dataGrid"></param>
        /// <param name="PageSize"></param>
        public void InitPager(GridView dataGrid, int PageSize)
        {
            try
            {
                int virtualCount = 0;
                int pageSize;
                //ControlBlock = ControlBlockInitializer.Initialize();
                int currentPageIndex = dataGrid.PageIndex;
                pageSize = PageSize;
                //int totalNoOfRec=((DataTable)dataGrid.DataSource).Rows.Count;
                int totalNoOfRec;
                if (virtualCount != 0)
                    totalNoOfRec = virtualCount;
                else
                    totalNoOfRec = ((DataTable)dataGrid.DataSource).Rows.Count;
                if (totalNoOfRec > 0)
                {
                    int totalNumberOfPages = 0;

                    if (totalNoOfRec <= pageSize && totalNoOfRec > 0)
                    {
                        totalNumberOfPages = 1;
                    }
                    else
                    {
                        if (totalNoOfRec % pageSize == 0)
                            totalNumberOfPages = totalNoOfRec / pageSize;
                        else
                            totalNumberOfPages = totalNoOfRec / pageSize + 1;
                    }
                    if (totalNumberOfPages <= 0)
                    {
                        rnvGotoPage.MaximumValue = 0.ToString();
                        rnvGotoPage.MaximumValue = 0.ToString();

                    }
                    else
                        rnvGotoPage.MaximumValue = totalNumberOfPages.ToString();

                    if (currentPageIndex > 0 && currentPageIndex >= totalNumberOfPages)
                        dataGrid.PageIndex = totalNumberOfPages - 1;

                    // Hide the default Pager
                    // dataGrid.RowCreated += new DataGridItemEventHandler(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = PageSize;
                    dataGrid.DataBind();

                    lblCurrentPageRecCount.Text = dataGrid.Rows.Count.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    if (totalNumberOfPages != 0 && totalNumberOfPages <= currentPageIndex)
                        lblCurrentPage.Text = totalNumberOfPages.ToString();
                    else
                        lblCurrentPage.Text = (currentPageIndex + 1).ToString();
                    lblTotalPage.Text = totalNumberOfPages.ToString();
                    if (Convert.ToInt32(lblCurrentPage.Text.ToString()) > 1)
                    {
                        lblCurrentPageRecCount.Text = Convert.ToString(((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize);
                        lblCurrentTotalRec.Text = Convert.ToString(((((Convert.ToInt32(lblCurrentPage.Text.ToString()) - 1)) * pageSize) + dataGrid.Rows.Count));
                    }
                    else
                    {
                        lblCurrentPageRecCount.Text = "1";
                        lblCurrentTotalRec.Text = dataGrid.Rows.Count.ToString();
                    }
                    InitPager(dataGrid.PageIndex, totalNumberOfPages, dataGrid.PageSize, PagerStyle.ComboEnabled);
                }
                else
                {

                    dataGrid.PageIndex = 0;
                    ddlPages.Items.Clear();
                    //   dataGrid.RowCreated += new GridViewRowEventArgs(this.dataGrid_ItemCreated);
                    dataGrid.PageSize = PageSize;
                    dataGrid.DataBind();
                    lblCurrentPageRecCount.Text = totalNoOfRec.ToString();
                    lblTotalNoOfRec.Text = totalNoOfRec.ToString();
                    lblCurrentPage.Text = totalNoOfRec.ToString();
                    lblTotalPage.Text = totalNoOfRec.ToString();
                    lblCurrentTotalRec.Text = totalNoOfRec.ToString();

                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
            }
        }
        #endregion

        #region Event BackUp
        /*
		this.btnGo.Click += new System.EventHandler(this.btnGo_Click);
		this.btnLast.Click += new System.EventHandler(this.btnLast_Click);
		this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
		this.ddlPages.SelectedIndexChanged += new System.EventHandler(this.ddlPages_SelectedIndexChanged);
		this.btnPrevious.Click += new System.EventHandler(this.btnPrevious_Click);
		this.btnFirst.Click += new System.EventHandler(this.btnFirst_Click);
		this.Load += new System.EventHandler(this.Page_Load);

		*/
		#endregion

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		

		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.ddlPages.SelectedIndexChanged += new System.EventHandler(this.ddlPages_SelectedIndexChanged);
            this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

        protected void ddlPages_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gotoPageNumber != (Convert.ToInt32(ddlPages.SelectedItem.Value) - 1) && ddlPages.SelectedItem.Value != "-1")
            {
                gotoPageNumber = Convert.ToInt32(ddlPages.SelectedItem.Value) - 1;
                ViewState["GotoPageNumber"] = gotoPageNumber;
                OnBubbleClick(e);
            }
        }

		public void dataGrid_ItemCreated(object sender, DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.Pager)
				e.Item.Visible=false;
		}

        protected void ImageButton1_Click(object sender, System.EventArgs e)
        {
            gotoPageNumber++;
            ViewState["GotoPageNumber"] = gotoPageNumber;
            OnBubbleClick(e);
        }

        protected void btnLast_Click(object sender, System.EventArgs e)
        {
            try
            {
                gotoPageNumber = Convert.ToInt32(ViewState["TotalPages"].ToString()) - 1;
                ViewState["GotoPageNumber"] = gotoPageNumber;
                OnBubbleClick(e);
            }
            catch (Exception ex)
            { }
        }

        protected void btnLast_Click1(object sender, System.EventArgs e)
        {
            gotoPageNumber = Convert.ToInt32(ViewState["TotalPages"].ToString()) - 1;
            ViewState["GotoPageNumber"] = gotoPageNumber;
            OnBubbleClick(e);
        }

        protected void btnGo_Click(object sender, System.EventArgs e)
        {
            string txt = txtGotoPage.Text.Trim();
            if (txt != "0" && txt != "")
            {   
                int pageNumberEntered = Convert.ToInt32(txtGotoPage.Text.ToString().Trim()) - 1;
                int totalPages = Convert.ToInt32(ViewState["TotalPages"].ToString().Trim()) - 1;
                if (pageNumberEntered >= 0 && pageNumberEntered != gotoPageNumber && pageNumberEntered <= totalPages)
                {
                    gotoPageNumber = pageNumberEntered;
                    ViewState["GotoPageNumber"] = gotoPageNumber;
                    OnBubbleClick(e);
                }
            }
        }

        protected void ibtnPrevious_Click(object sender, System.EventArgs e)
        {
            try
            {
                if (ddlPages.Visible == true && ddlPages.SelectedItem.Text != "")
                {
                    gotoPageNumber--;
                    ViewState["GotoPageNumber"] = gotoPageNumber;
                    OnBubbleClick(e);
                }
                else
                {
                    gotoPageNumber--;
                    ViewState["GotoPageNumber"] = gotoPageNumber;
                    OnBubbleClick(e);
                }
            }
            catch(Exception ex)
            {}
        }

        protected void ibtnFirst_Click(object sender, System.EventArgs e)
        {
            gotoPageNumber = 0;
            ViewState["GotoPageNumber"] = gotoPageNumber;
            OnBubbleClick(e);
        }
}
}

