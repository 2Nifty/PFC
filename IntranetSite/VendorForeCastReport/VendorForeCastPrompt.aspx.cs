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
using PFC.Intranet.BusinessLogicLayer;


public partial class VendorForeCastPrompt : System.Web.UI.Page
{
    #region Variable Declaration
    VendorForecast vendorForecast = new VendorForecast();
    #endregion

    #region Enums Declaration

    private enum DeleteMode
    {
        Remove,
        RemoveAll
    }
    #endregion

    #region Control Events
    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(VendorForeCastPrompt));

        if (!Page.IsPostBack)
        {
            //BindControls();
            rdlCategoryRangeType.SelectedIndex = 0;
            rdlPlatingType.SelectedIndex = 0;
            rdlVarianceRangeType.SelectedIndex = 0;

            hidPlatingRangeType.Value = "2";
            hidCategoryRangeType.Value = "2";
            hidVarianceRangeType.Value = "2";

            divPlatingThro.Attributes.Add("style", "display:block");
            divCategoryThro.Attributes.Add("style", "display:block");
            divVarianceThro.Attributes.Add("style", "display:block");

            ShowEditTabs(divPlatingThro);
            ShowEditTabs(divVarianceThro);
            ShowEditTabs(divCategoryThro);

            divCategory.Attributes.Add("style", "display:none");
            divVariance.Attributes.Add("style", "display:none");
            divPlatingType.Attributes.Add("style", "display:none");

            
        }   
    }

    #region Category Type
    protected void ibtnCategoryEdit_Click(object sender, ImageClickEventArgs e)
    {
        ShowEditTabs(divCategory);
    }

    protected void ibtnCategoryDelete_Click(object sender, ImageClickEventArgs e)
    {
        DeleteItems(DeleteMode.Remove, lstCategory);
    }

    protected void ibtnCategoryReset_Click(object sender, ImageClickEventArgs e)
    {
        DeleteItems(DeleteMode.RemoveAll, lstCategory);
    }

    protected void ibtCategoryAdd_Click(object sender, ImageClickEventArgs e)
    {
        FillListControl(txtCategoryFrom, txtCategoryThro, lstCategory, rdlCategoryRangeType);
    }
    protected void rdlCategoryRangeType_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidCategoryRangeType.Value = rdlCategoryRangeType.SelectedValue;
        ShowEditTabs(divCategoryThro);
    }
    #endregion

    #region Variance Type
    protected void ibtnEditVarient_Click(object sender, ImageClickEventArgs e)
    {
        ShowEditTabs(divVariance);
    }
    protected void ibtnVarianceDelete_Click(object sender, ImageClickEventArgs e)
    {
        DeleteItems(DeleteMode.Remove, lstVariance);
    }
    protected void ibtnVarianceReset_Click(object sender, ImageClickEventArgs e)
    {
        DeleteItems(DeleteMode.RemoveAll, lstVariance);
    }
    protected void ibtnVarianceAdd_Click(object sender, ImageClickEventArgs e)
    {
        FillListControl(txtVarianceFrom, txtVarianceThro, lstVariance, rdlVarianceRangeType);
    }
    protected void rdlVarianceRangeType_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidVarianceRangeType.Value = rdlVarianceRangeType.SelectedValue;
        ShowEditTabs(divVarianceThro);
    }
    #endregion

    #region Plating Type
    protected void ibtnPlatingTypeEdit_Click(object sender, ImageClickEventArgs e)
    {
        ShowEditTabs(divPlatingType);
    }
    protected void ibtnPlatingTypeDelete_Click(object sender, ImageClickEventArgs e)
    {
        DeleteItems(DeleteMode.Remove, lstPlatingType);
    }
    protected void ibtnPlatingTypeReset_Click(object sender, ImageClickEventArgs e)
    {
        DeleteItems(DeleteMode.RemoveAll, lstPlatingType);
    }
    protected void ibtnPlatingTypeAdd_Click(object sender, ImageClickEventArgs e)
    {
        FillListControl(txtPlatingTypeFrom, txtPlatingTypeThro, lstPlatingType, rdlPlatingType);
    }
    protected void rdlPlatingType_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidPlatingRangeType.Value = rdlPlatingType.SelectedValue;
        ShowEditTabs(divPlatingThro);
    }
    #endregion
   
    protected void ibtnViewReport_Click(object sender, ImageClickEventArgs e)
    {
        if(txtMultiplier.Text != "")
            Session["VendorMultiplier"] = txtMultiplier.Text;       
        Session["VendorCategory"] = BuildWhereClause("CatNo", lstCategory);
        Session["VendorVariance"] = BuildWhereClause("LEFT(VarNo, 2)", lstVariance);
        Session["VendorPlatingType"] = BuildWhereClause("PlateNo", lstPlatingType);        
        Session["VendorSort"] = ddlSort.SelectedValue;

        string Url = string.Empty;
        if(ddlSort.SelectedValue == "Item")
            Url= "ProgressBar.aspx?destPage=VendorForecastReport.aspx";
        else
            Url = "ProgressBar.aspx?destPage=VendorForecastReportByPlating.aspx";

        string script = "window.open('" + Url + "','BranchItemSalesAnalysis' ,'height=710,width=840,scrollbars=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (840/2))+',resizable=YES','');";

        ScriptManager.RegisterClientScriptBlock(this.ibtnViewReport, ibtnViewReport.GetType(), "msg", script, true);

    }
    #endregion

    #region Developer Method
    private void BindControls()
    {
        // Bind Multiplier dropdown
        for (int i = 1; i <= 100; i++)
        {
            //ddlMultiplier.Items.Add( new ListItem( i.ToString() + " %",i.ToString()));
        }
        //ddlMultiplier.SelectedIndex = 99;
    }

    private bool CheckDuplication(ListBox lstCtl, string strValue)
    {
        for (int iIndex = 0; iIndex < lstCtl.Items.Count; iIndex++)
        {
            if (lstCtl.Items[iIndex].Value == strValue)
                return false;
        }
        return true;
    }

    private void FillListControl(TextBox txtFrom, TextBox txtThro, ListBox lstCtl, RadioButtonList rdlCtl)
    {
        if (rdlCtl.SelectedValue == "1")
        {
            if (txtFrom.Text != "")
            {
                if(CheckDuplication(lstCtl,txtFrom.Text))
                {
                    ListItem lstItemCategory = new ListItem(txtFrom.Text, txtFrom.Text);
                    lstCtl.Items.Add(lstItemCategory);
                }
            }
            txtFrom.Text = "";
        }
        else
        {
            if (txtFrom.Text != "" || txtThro.Text != "")
            {
                string strItem = string.Empty;
                string strValue = string.Empty;

                if (txtFrom.Text != "")
                {
                    strItem = "[" + txtFrom.Text;
                    strValue = "[" + txtFrom.Text;
                }
                else
                {
                    strItem = "(";
                    strValue = "(";
                }

                if (txtThro.Text != "")
                {
                    strItem += "..." + txtThro.Text + "]";
                    strValue += "~" + txtThro.Text + "]";
                }
                else
                {
                    strItem += "...)";
                    strValue += "~)";
                }

                if (CheckDuplication(lstCtl, strValue))
                {
                    ListItem lstItemCategory = new ListItem(strItem, strValue);
                    lstCtl.Items.Add(lstItemCategory);                    
                }
            }
            txtFrom.Text = "";
            txtThro.Text = "";
        }
        // Remove all from list control
        if (lstCtl.Items[0].Text == "All")
        {
            lstCtl.Items.RemoveAt(0);
        }

    }

    private void DeleteItems(DeleteMode iMode, ListBox lstCtl)
    {
        // Delete selected item from drop down list
        if (iMode == DeleteMode.Remove)
        {
            int lstItemCount = lstCtl.Items.Count -1 ;
            for (int iIndex = lstItemCount; iIndex >= 0; iIndex--)
            {
                if (lstCtl.Items[iIndex].Selected)
                    lstCtl.Items.RemoveAt(iIndex);
            }            
        }
        // Remove all the items from drop down
        else
        {
            lstCtl.Items.Clear();
        }

        // Check for default value,if it's not there add it
        if (lstCtl.Items.Count == 0)
            lstCtl.Items.Add(new ListItem("All","0",true));
        
    }

    private void ShowEditTabs(HtmlContainerControl objDiv)
    {
        string str = objDiv.Attributes["style"];
        if (objDiv.Attributes["style"] == "display:none")
            objDiv.Attributes["style"] = "display:block";
        else
            objDiv.Attributes["style"] = "display:none";
    }

    private string BuildWhereClause(string databaseFieldName, ListBox lstControl)
    {
        string result = string.Empty;

        if (lstControl.Items.Count == 1 && lstControl.Items[0].Text == "All")
        {
            return "";
        }
        for (int i = 0; i <= lstControl.Items.Count - 1; i++)
        {
            if (lstControl.Items[i].Text.Contains("..."))
            {
                string startingChar = lstControl.Items[i].Text.Substring(0, 1);
                string endingChar = lstControl.Items[i].Text.Substring(lstControl.Items[i].Text.Length - 1, 1);

                if (startingChar == "[" && endingChar == "]")
                    result = result + "(" + databaseFieldName + " between " + lstControl.Items[i].Value.Replace("[", "").Replace("]", "").Split('~')[0].ToString() + " and " + lstControl.Items[i].Value.Replace("[", "").Replace("]", "").Split('~')[1].ToString() + ") OR ";
                if (startingChar == "(" && endingChar == "]")
                    result = result + "(" + databaseFieldName + " <= " + lstControl.Items[i].Value.Replace("(", "").Replace("]", "").Split('~')[1].ToString() + ") OR ";
                if (startingChar == "[" && endingChar == ")")
                    result = result + "(" + databaseFieldName + " >= " + lstControl.Items[i].Value.Replace("[", "").Replace(")", "").Split('~')[0].ToString() + ") OR ";
            }
            else
            {
                if (lstControl.Items[i].Text != "All")
                    result = result + "(" + databaseFieldName + " = '" + lstControl.Items[i].Value.Replace("[", "").Replace(")", "") + "') OR ";
            }
        }
        if (result.Contains("OR"))
        {
            result = result.Substring(0, result.LastIndexOf("OR"));
            //result = result.Remove(result.Length - 4, 3);
        }
        return result;
    }
    #endregion
}
