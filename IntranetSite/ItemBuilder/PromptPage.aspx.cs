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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.DataAccessLayer;

public partial class StandardComments : System.Web.UI.Page
{
    int count;    
    private DataTable dtTablesData = new DataTable();
    ItemBuilder itemBuilder = new ItemBuilder();
    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string code = "";
    string connectionString = "";
    string custNumber = "";
    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
  

    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Visible = false;
        
        if (!Page.IsPostBack)
        {
            string enterScript = "if(event.keyCode == 13) document.getElementById('" + btnPush.ClientID + "').click();";
            txtCustNo.Attributes.Add("onkeypress", enterScript);
        }
            
     }



    protected void btnPush_Click(object sender, ImageClickEventArgs e)
    {
        if (txtCustNo.Text != "")
        {
            custNumber = addPadding(txtCustNo.Text.ToString());
            bool custNo = itemBuilder.checkCustomerNumber(custNumber);
            if (custNo || custNumber == "000000")
            {
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "LoadPage", "window.open('CrossRefBuilder.aspx?CustomerNumber=" +custNumber+ "','CrossRefBuilder','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no')", true);
                             
            }
            else
            {
                lblMessage.Visible = true;
                MyScript.SetFocus(txtCustNo);
            }
        }
    }
    private string addPadding(string custNumber)
    {
        int length = custNumber.Length;
        int count = 6;
        string numZeropad = custNumber + "";

        while (numZeropad.Length < count)
        {
            numZeropad = "0" + numZeropad;
        }

        custNumber = numZeropad;
        return custNumber;
    }
}



