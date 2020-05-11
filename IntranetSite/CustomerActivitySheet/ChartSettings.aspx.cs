#region Namespaces
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
using dotnetCHARTING;
using System.Drawing;
using PFC.Intranet.Securitylayer; 
#endregion

namespace PFC.Intranet.CustomerActivity
{
    public partial class ChartSettings : System.Web.UI.Page
    {
        #region Declaration
        PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerActivitySheet = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet(); 
        #endregion
        
        #region Page Load Event Handler
        /// <summary>
        /// Page Load Event Handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {

            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
            if (!IsPostBack)
            {
                ddlChartType.SelectedValue = Session["ChartType"].ToString();
                ddlPalette.SelectedValue = Session["ChartPalette"].ToString();
                ChartDisplay(Session["ChartType"].ToString(), Session["ChartPalette"].ToString());
            }
        } 
        #endregion

        #region Developer code 
        /// <summary>
        /// ChartDisplay: Method used to display chart 
        /// </summary>
        /// <param name="strChart">string Chart type </param>
        /// <param name="strName">string Chart Color palette</param>
        private void ChartDisplay(string strChart, string strName)
        {
            ArrayList myArrayList = new ArrayList();
            myArrayList.Add(new Product("P1", 44));
            myArrayList.Add(new Product("P2", 12));
            myArrayList.Add(new Product("P3", 20));
            myArrayList.Add(new Product("P4", 65));
            myArrayList.Add(new Product("P5", 50));
            myArrayList.Add(new Product("P6", 40));


            dotnetCHARTING.ChartType myChartType = (dotnetCHARTING.ChartType)Enum.Parse(typeof(dotnetCHARTING.ChartType), strChart, true);
            dotnetCHARTING.Scale myAxisScale = (dotnetCHARTING.Scale)Enum.Parse(typeof(dotnetCHARTING.Scale), "Normal", true);
            dotnetCHARTING.SeriesType mySeriesType = (dotnetCHARTING.SeriesType)Enum.Parse(typeof(dotnetCHARTING.SeriesType), "Column", true);
            dotnetCHARTING.PieLabelMode myPieLabelMode = dotnetCHARTING.PieLabelMode.Outside;
            dotnetCHARTING.LegendBoxPosition myLegendBoxPosition = dotnetCHARTING.LegendBoxPosition.None;


            //General settings            
            chartModule.DefaultSeries.LimitMode = (dotnetCHARTING.LimitMode)Enum.Parse(typeof(dotnetCHARTING.LimitMode), "Top", true);
            chartModule.DefaultSeries.DefaultElement.ShowValue = true;
            chartModule.DefaultAxis.NumberPercision = 0;

            chartModule.Mentor = false;
            chartModule.TempDirectory = "temp";
            chartModule.Visible = true;
            chartModule.Type = myChartType;
            chartModule.Height = 200;
            chartModule.Width = 300;
            chartModule.UseFile = true;
            chartModule.Debug = false;
            chartModule.DonutHoleSize = 50;
            chartModule.LegendBox.Template = "%icon%name";
            chartModule.LegendBox.Position = myLegendBoxPosition;
            chartModule.Use3D = true;
            chartModule.Transpose = true;
            chartModule.DefaultSeries.ShowOther = true;
            chartModule.DefaultSeries.Type = mySeriesType;
            chartModule.DefaultAxis.Scale = myAxisScale;
            chartModule.PieLabelMode = myPieLabelMode;
            chartModule.Series.Name = "";
            chartModule.AutoNameLabels = true;
            chartModule.Title = "";
            chartModule.Series.Data = myArrayList;
            chartModule.Series.DataFields = "xAxis=Name,yAxis=Total";
            chartModule.SeriesCollection.Add();
            chartModule.DefaultSeries.DefaultElement.Transparency = 10;
            chartModule.PaletteName = customerActivitySheet.GetPaletteName(strName);
            chartModule.DefaultSeries.DefaultElement.ShowValue = true;
        } 
        #endregion

        #region Event Handler
        /// <summary>
        /// imgApply_Click :Apply button click event handler
        /// </summary>
        /// <param name="sender">object sender</param>
        /// <param name="e">ImageClickEventArgs e</param>
        protected void imgApply_Click(object sender, ImageClickEventArgs e)
        {
            Session["ChartType"] = ddlChartType.SelectedValue;
            Session["ChartPalette"] = ddlPalette.SelectedValue;
            ChartDisplay(ddlChartType.SelectedValue, ddlPalette.SelectedValue);
            Response.Write("<script>");
            Response.Write("window.opener.location.href=window.opener.location.href+'&Mode=Chart'");
            Response.Write("</script>");
        }
        /// <summary>
        /// ddlChartType_SelectedIndexChanged:Chart type onchange event handler
        /// </summary>
        /// <param name="sender">object name</param>
        /// <param name="e">EventArgs</param>
        protected void ddlChartType_SelectedIndexChanged(object sender, EventArgs e)
        {
            ChartDisplay(ddlChartType.SelectedValue, ddlPalette.SelectedValue);
        }
        /// <summary>
        /// ddlPalette_SelectedIndexChanged:Chart color palette onchange event handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">EventArgs e</param>
        protected void ddlPalette_SelectedIndexChanged(object sender, EventArgs e)
        {
            ChartDisplay(ddlChartType.SelectedValue, ddlPalette.SelectedValue);
        }
        /// <summary>
        /// imgbtnDefault_Click:Event handler used to set default 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void imgbtnDefault_Click(object sender, ImageClickEventArgs e)
        {
            ddlChartType.SelectedIndex = 3;
            ddlPalette.SelectedIndex = 15;
            ChartDisplay(ddlChartType.SelectedValue, ddlPalette.SelectedValue);
        } 
        #endregion

    }// End Class
 
}// End Namespaces

#region For Chart Sample Data
public class Product
{
    string name;
    double total;
    public Product()
    {
    }
    public Product(string proName, double proTotal)
    {
        name = proName;
        total = proTotal;
    }
    public string Name
    {
        get
        {
            return name;
        }
        set
        {
            name = value;
        }
    }
    public double Total
    {
        get
        {
            return total;
        }
        set
        {
            total = value;
        }
    }
} 
#endregion

