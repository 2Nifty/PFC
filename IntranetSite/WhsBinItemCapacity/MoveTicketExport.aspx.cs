#region Name Space
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
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using System.Reflection;
using Microsoft.Web.UI;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using System.Drawing;
#endregion

public partial class MoveTicketExport : System.Web.UI.Page 
{
    BinItemCapacityData binItemCapacityData = new BinItemCapacityData();

    DataSet ds;
    DataTable dt;

    #region Auto generated event
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TicketNo"] != null)
        {
            if (!Page.IsPostBack)
            {
                dt = binItemCapacityData.GetATicket(Request.QueryString["TicketNo"]);
                if (dt == null)
                {
                    lblErrorMessage.Text = "No data for Ticket number" + Request.QueryString["TicketNo"] + ".";
                }
                else
                {
                    Session["BICXPrevFrom"] = null;
                    Session["BICXPrevTo"] = null;
                    BindData();
                    dt = binItemCapacityData.SetPrinted(Request.QueryString["TicketNo"]);
                }
            }
        }
        else
        {
            lblErrorMessage.Text = "Ticket number not specified. Unable to generate report.";

        }
    }
    #endregion

    #region Developer generated code

    private void BindData()
    {
        //lblItemCount.Text = dt.Compute("count(distinct ItemNo)", "1 = 1").ToString();
        lblTicketNo.Text = dt.Rows[0]["TicketNo"].ToString();
        lblBranch.Text = dt.Rows[0]["Location"].ToString();
        lblGenerated.Text = dt.Rows[0]["EntryDt"].ToString();
        //dt.DefaultView.RowFilter = "MoveType = 'Pick'";
        //dt.DefaultView.Sort = "Bin ASC";
        dgPickData.DataSource = dt; 
        dgPickData.DataBind();
        lblTotal.Text = String.Format("{0:#,##0}", dt.Compute("sum(OnHand)", "StatusCd <> '00'"));
        //dt.DefaultView.RowFilter = "MoveType = 'Put'";
        //dt.DefaultView.Sort = "Bin ASC";
        //dgPutData.DataSource = dt.DefaultView.ToTable(); 
        //dgPutData.DataBind();
    }

    public void dgPickData_ItemDataBound(Object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            //Label OverPick = (Label)e.Item.FindControl("OverPickQty");
            if (e.Item.DataSetIndex > 0)
            {
                //e.Item.Cells[0].Text = Session["PrevFrom"].ToString().CompareTo(e.Item.Cells[0].Text.Trim()).ToString();
                if ((Session["BICXPrevFrom"].ToString().CompareTo(e.Item.Cells[0].Text.Trim() + e.Item.Cells[1].Text.Trim()) == 0))
                {
                    Session["BICXPrevFrom"] = e.Item.Cells[0].Text.Trim() + e.Item.Cells[1].Text.Trim();
                    e.Item.Cells[0].Text = "";
                }
                else
                {
                    Session["BICXPrevFrom"] = e.Item.Cells[0].Text.Trim() + e.Item.Cells[1].Text.Trim();
                }

                if ((Session["BICXPrevTo"] != null) && (Session["BICXPrevTo"].ToString() == e.Item.Cells[3].Text))
                {
                    Session["BICXPrevTo"] = e.Item.Cells[3].Text;
                    e.Item.Cells[3].Text = "";
                    e.Item.Cells[4].Text = "";
                }
                else
                {
                    Session["BICXPrevTo"] = e.Item.Cells[3].Text;
                }
            }
            else
            {
                Session["BICXPrevFrom"] = e.Item.Cells[0].Text.Trim() + e.Item.Cells[1].Text.Trim();
                Session["BICXPrevTo"] = e.Item.Cells[3].Text;
            }
        }

    }

    #endregion
}