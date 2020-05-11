/********************************************************************************************
 * Project				:	Umbrella 2.0
 * Specification Doc.   :   NA
 * File					:	DatePicker_ClientInterface.aspx.aspx.cs
 * File Type			:	Code File
 * Description			:	File to display popup datepicker 
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 02 July '05			Ver-1			Sathishvaran	 	Created
 *********************************************************************************************/

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
using System.Globalization;

public partial class Umbrella_CodePro_ScreenBuilder_DatePicker_ClientInterface : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SetDefaultValues();
            ViewState["ContorlID"] = Request.QueryString["txtID"].ToString();
        }
    }

    private void InitializeComponent()
    {
        this.Load += new System.EventHandler(this.Page_Load);
    }

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
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    #endregion

    public void BindYear()
    {
        for (int i = 1930; i <= (System.DateTime.Now.Year) + 10; i++)
        {
            string dd;
            dd = i.ToString();
            ddlYear.Items.Add(dd);
        }
    }

    protected void Calender_SelectionChanged(object sender, EventArgs e)
    {
        //
        // Data Manupulation to get textbox ID in parent form
        //
        string renderControlName = string.Empty;
        string[] txtDate ={ };
        string dateID = ViewState["ContorlID"].ToString();
        txtDate = ViewState["ContorlID"].ToString().Split('_');

        //
        //This code is modified by sundaresan. This work when conrol Name contains _ .
        //
        if (txtDate.Length > 1)
        {
            for (int kCount = 0; kCount < txtDate.Length - 1; kCount++)
            {
                renderControlName = renderControlName + txtDate[kCount].ToString() + "_";
            }
            renderControlName = renderControlName + "txtDatePicker";
        }
        else
        {
            renderControlName = ViewState["ContorlID"].ToString().Split('_')[0] + "_txtDatePicker";
        }

        string result = calender.SelectedDate.ToShortDateString();

        Response.Write("<script>");
        if (dateID != "dpPickShtDt_textBox" && dateID != "dpReqDt_textBox") // For WO Find screen
            Response.Write("window.opener.document.getElementById ('" + renderControlName + "').value= '" + result + "' ; ");
        else // For WO Entry screen
            Response.Write("window.opener.document.getElementById ('" + dateID + "').value= '" + result + "' ; ");
        
        if (dateID == "dpPickShtDt_textBox" || dateID == "dpReqDt_textBox")
            Response.Write("window.opener.document.getElementById ('" + dateID.Replace("_textBox", "_btnUpdate") + "').click(); ");
        
        Response.Write("top.window.close();");
        Response.Write("</script>");
    }

    protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        calender.VisibleDate = Convert.ToDateTime(ddlMonth.SelectedItem.Value + "/" + calender.SelectedDate.Date.Day + "/" + ddlYear.SelectedItem.Value);
    }

    protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        calender.VisibleDate = Convert.ToDateTime(ddlMonth.SelectedItem.Value + "/" + calender.SelectedDate.Date.Day + "/" + ddlYear.SelectedItem.Value);
    }

    /// <summary>
    /// Function to Set local timing to text boxes
    /// </summary>
    private void SetDefaultValues()
    {
        BindYear();

        DateTime localtime = System.DateTime.Now.ToLocalTime();

        //txtMinutes.Text = localtime.Minute.ToString();
        //txtSeconds.Text = localtime.Second.ToString();
        txtMinutes.Text = (localtime.Minute.ToString().Length == 1 ? "0" + localtime.Minute.ToString() : localtime.Minute.ToString());
        txtSeconds.Text = (localtime.Second.ToString().Length == 1 ? "0" + localtime.Second.ToString() : localtime.Second.ToString());

        Novantus.Umbrella.Utils.Utility.SetSelectedValuesInListControl(rdoNoon, localtime.ToString().Split(' ')[2]);
        Novantus.Umbrella.Utils.Utility.SetSelectedValuesInListControl(ddlYear, System.DateTime.Now.Year.ToString());
        Novantus.Umbrella.Utils.Utility.SetSelectedValuesInListControl(ddlMonth, System.DateTime.Now.Month.ToString());
        if (localtime.Hour <= 12)
            txtHour.Text = localtime.Hour.ToString();
        else
            txtHour.Text = Convert.ToString(localtime.Hour - 12);
    }
}
