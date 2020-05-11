using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.DataAccessLayer;

public partial class Profitometer : System.Web.UI.UserControl
{
    private DataSet ProfitDS = new DataSet();
    private Color lossBottomColor = Color.FromName("firebrick");
    private Color lossTopColor = Color.FromName("white");
    private Color profitColor = Color.FromName("green");
    private string ReturnedStatus = "";

    protected void Page_Init(object sender, EventArgs e)
    {
        ThermoPanel.Width = this.ThermoWidth;
        ThermoPanel.Height = this.ThermoHeight;
        int sectionHeight;
        int sectionWidth;
        if (this.ThermoDirection == "VERTICAL")
        {
            sectionHeight = (this.ThermoHeight / 2);
            sectionWidth = this.ThermoWidth - 4;
        }
        else
        {
            sectionHeight = this.ThermoHeight;
            sectionWidth = this.ThermoWidth / 2;
        }
        thermoTop.Width = sectionWidth;
        thermoTop.Height = sectionHeight;
        thermoBottom.Width = sectionWidth;
        thermoBottom.Height = sectionHeight;
        this.ProfitPrice = 0;
        this.profitText.Value = "";
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public int ThermoWidth
    {
        get
        {
            return (int)ViewState["thermowidth"];
        }
        set
        {
            ViewState["thermowidth"] = value;
        }
    }

    public int ThermoHeight
    {
        get
        {
            return (int)ViewState["thermoheight"];
        }
        set
        {
            ViewState["thermoheight"] = value;
        }
    }

    public string ThermoDirection
    {
        get
        {
            return (string)ViewState["thermodirect"].ToString().ToUpper();
        }
        set
        {
            ViewState["thermodirect"] = value;
        }
    }

    public decimal ProfitPrice
    {
        get
        {
            return (decimal)ViewState["profitprice"];
        }
        set
        {
            ViewState["profitprice"] = value;
        }
    }

    public string WebPriceInd
    {
        get
        {
            return (string)ViewState["webpriceind"];
        }
        set
        {
            ViewState["webpriceind"] = value;
        }
    }

    public void Clear()
    {
        this.profitText.Value = "";
        this.ProfitPrice = 0;
        profitPrice.Value = "0";
        thermoTop.BackColor = lossTopColor;
        thermoBottom.BackColor = lossTopColor;
    }
    
    public void Update(string connectString, string OrderNo, string HeaderTable)
    {
        // refresh the profitometer  , 10, ParameterDirection.Output
        ProfitDS = SqlHelper.ExecuteDataset(connectString, "pSOEGetProfitabilty",
                 new SqlParameter("@SearchOrderNo", OrderNo),
                 new SqlParameter("@HeaderTable", HeaderTable),
                 new SqlParameter("@StatusOnly", "0"),
                 new SqlParameter("@ProfitStatus", ReturnedStatus),
                 new SqlParameter("@NewLineDollars", "0"),
                 new SqlParameter("@NewLineCOGS", "0"),
                 new SqlParameter("@NewLineWeight", "0"),
                 new SqlParameter("@NewLineCount", "0"));
        if (ProfitDS.Tables.Count >= 1)
        {
            if (ProfitDS.Tables.Count == 1)
            {
                // We only got one table back. do nothing
            }
            else
            {
                UpdThermo(ProfitDS.Tables[1]);
            }
        }
    }

    public void Update(string connectString, string OrderNo, string HeaderTable, decimal LineDollars, decimal LineCost, decimal LineWeight, int LineCount)
    {
        // overload for pricing worksheet
        ProfitDS = SqlHelper.ExecuteDataset(connectString, "pSOEGetProfitabilty",
                 new SqlParameter("@SearchOrderNo", OrderNo),
                 new SqlParameter("@HeaderTable", HeaderTable),
                 new SqlParameter("@StatusOnly", "0"),
                 new SqlParameter("@ProfitStatus", ReturnedStatus),
                 new SqlParameter("@NewLineDollars", LineDollars),
                 new SqlParameter("@NewLineCOGS", LineCost),
                 new SqlParameter("@NewLineWeight", LineWeight),
                 new SqlParameter("@NewLineCount", LineCount));
        if (ProfitDS.Tables.Count >= 1)
        {
            if (ProfitDS.Tables.Count == 1)
            {
                // We only got one table back. do nothing
            }
            else
            {
                UpdThermo(ProfitDS.Tables[1]);
            }
        }
    }

    private void UpdThermo(DataTable ProfitDT)
    {
        string profitStatus = ProfitDT.Rows[0]["ProfitStatus"].ToString();
        string profitInfo = "The current profit is " +
           String.Format("${0:#,##0.00}", ProfitDT.Rows[0]["Profit"]) +
            " (" + ProfitDT.Rows[0]["ProfitStatus"].ToString() + ").<br>";
        //profitInfo += " The order value is " + String.Format("${0:#,##0.00}", ProfitDT.Rows[0]["OrderDollars"]) + (char)13;
        profitInfo += " The materials cost is " + String.Format("${0:#,##0.00}", ProfitDT.Rows[0]["OrderCost"]) + "<br>";
        profitInfo += " The weighted cost is " + String.Format("${0:#,##0.00}", ProfitDT.Rows[0]["WeightedCost"]) + "<br>";
        profitInfo += " The current profit target is " + String.Format("${0:#,##0.00}", ProfitDT.Rows[0]["LineTarget"]) + "<br>";
        profitInfo += " The current profit price is " + String.Format("${0:#,##0.00}", ProfitDT.Rows[0]["ProfitPrice"]) + "<br>";
        profitInfo += "<div style='font: 9pt Arial, sans-serif'>Click On the Profitometer to Set the Minimum Price</div>";
        //ThermoPanel.ToolTip = profitInfo;
        this.profitText.Value = profitInfo;
        this.ProfitPrice = (decimal)ProfitDT.Rows[0]["ProfitPrice"];
        profitPrice.Value = ProfitDT.Rows[0]["ProfitPrice"].ToString();
        if (profitStatus == "Loss" && WebPriceInd != "G")
        {
            if (this.ThermoDirection == "VERTICAL")
            {
                thermoTop.BackColor = lossTopColor;
                thermoBottom.BackColor = lossBottomColor;
            }
            else
            {
                // things are reversed for the horizontal
                thermoTop.BackColor = lossBottomColor;
                thermoBottom.BackColor = lossTopColor;
            }
        }
        else
        {
            thermoTop.BackColor = profitColor;
            thermoBottom.BackColor = profitColor;
        }
    }

}
