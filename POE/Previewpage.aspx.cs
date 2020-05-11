using System;
using System.IO;
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
using PFC.POE.BusinessLogicLayer;

public partial class _Default : System.Web.UI.Page
{
    POCommentEntry comments = new POCommentEntry();
    DataTable dtBindGrid = new DataTable();
    DataTable dtCommentTop = new DataTable();
    DataTable dtCommentBtm = new DataTable();
    DataTable dtComments = new DataTable();
    string POOrdorNO = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        POOrdorNO = Request.QueryString["PONumber"].ToString();
        poHeader.PONumber = POOrdorNO;
        BindGrid();
        BindTop();
        BindBottom();

    }
    protected void BindGrid()
    {
        dtBindGrid = comments.BindGrid(POOrdorNO);
        gvComment.DataSource = dtBindGrid.DefaultView.ToTable();
        gvComment.DataBind();
    }

    protected void BindTop()
    {
        dtCommentTop = comments.BindTop(POOrdorNO);
        dlCommentTop.DataSource = dtCommentTop.DefaultView.ToTable();
        dlCommentTop.DataBind();
    }

    protected void BindBottom()
    {
        dtBindGrid = comments.BindBottom(POOrdorNO);
        dlCommentBtm.DataSource = dtBindGrid.DefaultView.ToTable();
        dlCommentBtm.DataBind();
    }


    protected void dlComment_ItemDataBound(object sender, DataListItemEventArgs e)
    {

    }
    protected void GridViewDtl1_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label lblLineNo = e.Item.FindControl("lblLineNo") as Label;
            DataList dlComment = e.Item.FindControl("dlComment") as DataList;
            dtComments = comments.BindComments(POOrdorNO, lblLineNo.Text.ToString());
            dlComment.DataSource = dtComments.DefaultView.ToTable();
            dlComment.DataBind();

        }
    }
    protected void gvComment_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label lblLineNo = e.Row.FindControl("lblLineNo") as Label;
            DataList dlComment = e.Row.FindControl("dlComment") as DataList;
            dtComments = comments.BindComments(POOrdorNO, lblLineNo.Text.ToString());
            dlComment.DataSource = dtComments.DefaultView.ToTable();
            dlComment.DataBind();
        }
    }
}
