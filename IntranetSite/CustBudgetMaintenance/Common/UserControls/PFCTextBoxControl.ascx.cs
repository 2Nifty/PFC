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

public partial class PFCTextBox : System.Web.UI.UserControl
{
    #region Property Bags

    public string Text
    {
        get
        {
            hidPreviousValue.Value = txtBox.Text;
            return txtBox.Text;
        }
        set
        {
            txtBox.Text = value;
            hidPreviousValue.Value = txtBox.Text;
        }
    }

    public int Height
    {
        set
        {
            txtBox.Height = Unit.Pixel(value);
        }
    }

    public int Width
    {
        set
        {
            txtBox.Width = Unit.Pixel(value);
        }
    }

    public string CssClass
    {
        set
        {
            txtBox.CssClass = value;
        }
    }

    public int TabIndex
    {
        set
        {
            txtBox.TabIndex = (short)value;
        }
    }

    public string TextBoxClientID
    {
        get
        {
            return txtBox.ClientID;
        }        
    }

    public string NextControlClientID
    {
        get
        {
            return ViewState["ControlClientID"].ToString();
        }
        set
        {
            ViewState["ControlClientID"] = value;            
        }
    }

    public enum AlignType
    {
        Center,
        Left,
        Right
    }

    public AlignType TextAlign
    {
        set
        {
            txtBox.Attributes.Add("style","text-align:" +  value +";");            
        }
    }

    public enum TextBoxValidationType
    {
        OnlyNumbers,
        AllowDecimals,
        None
    }

    public TextBoxValidationType Validation
    {
        set
        {
            if (TextBoxValidationType.AllowDecimals == value)
                txtBox.Attributes.Add("onkeypress", "return OnlyNumbers();");
        }
       
    }

    public bool ReadOnly
    {
        set
        {
            txtBox.ReadOnly = value;
            if (value == true)
            {
                txtBox.BorderStyle = BorderStyle.None;
                txtBox.Attributes.Add("onfocus", "");
            }
        }
    }

    #endregion

    #region Page Events

    public event EventHandler BubbleClick;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void OnBubbleClick(EventArgs e)
    {
        if (BubbleClick != null)
        {
            BubbleClick(this, e);
        }
    }

    protected void btnCallServerEvent_Click(object sender, EventArgs e)
    {
        OnBubbleClick(e);
    }

    #endregion
}
