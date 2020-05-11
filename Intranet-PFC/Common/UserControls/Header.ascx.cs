using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Drawing;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

// PFC Namespace
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet;


public partial class Common_UserControls_Header : System.Web.UI.UserControl
{
    //
    // global variable declaration
    //
    private int interfaceID = Convert.ToInt32(Global.IntranetInterfaceID);

    //
    // menu object creation
    //
    MenuGenerator menugenerator = new MenuGenerator();
    DataSet dsTabNames = new DataSet();
        
    public void LoadTab(int userID, int sensitivity)
    {
        dsTabNames = menugenerator.GetTabNames(interfaceID, userID, sensitivity);

        if (dsTabNames.Tables[0].Rows.Count > 0)
        {

            TableRow templatesRow = new TableRow();
            templatesRow.CssClass = "TopMenu";
            templatesRow.Width = Unit.Percentage(100);
            TableCell templateCell = new TableCell();
            int numberOfTemplates = dsTabNames.Tables[0].Rows.Count;
            int numberOfColumns = 6;

            for (int i = 0; i < numberOfTemplates; i++)
            {
                templateCell = new TableCell();
                templateCell.VerticalAlign = VerticalAlign.Middle;
                templateCell.HorizontalAlign = HorizontalAlign.Left;
                templateCell.ID = "td" + i;

                //templateCell.Width = Unit.Percentage(15);

                templateCell.Attributes.Add("onmouseover", "this.className='TopMenuMo'");
                templateCell.Attributes.Add("onmouseout", "CheckMenuCicked(this)");
                templateCell.CssClass = "TopMenu";
                Label lblMenuTabName = new Label();
                lblMenuTabName.ID = "lbl" + i;
                lblMenuTabName.Text = dsTabNames.Tables[0].Rows[i]["Name"].ToString();
                lblMenuTabName.ToolTip = dsTabNames.Tables[0].Rows[i]["Name"].ToString();
                //lblMenuTabName.Attributes.Add("onclick", "ChangeStatus(this,'" + dsTabNames.Tables[0].Rows[i]["TabID"].ToString() + "')");
                templateCell.Attributes.Add("onclick", "ChangeStatus(this,'" + dsTabNames.Tables[0].Rows[i]["TabID"].ToString() + "')");
               
                templateCell.Controls.Add(lblMenuTabName);

                templatesRow.Cells.Add(templateCell);
                if (((i + 1) % numberOfColumns) == 0)
                {
                    tblTemplates.Rows.Add(templatesRow);
                    templatesRow = new TableRow();
                    templatesRow.Width = Unit.Percentage(100);
                }
            }
            tblTemplates.Rows.Add(templatesRow);
        }        
        if (dsTabNames.Tables[0].Rows.Count <= 6)
        {
            hidTabRows.Value = "Single";
            Response.Write("<script>");
            Response.Write("top.Frame1.rows='105,*,29';");
            Response.Write("</script>");
        }
        else
        {
            hidTabRows.Value = "";
        }

    }

}
