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
using PFC.WOE.DataAccessLayer;

namespace Novantus.Umbrella.UserControls
{
    public partial class OrderEntrydatepicker : System.Web.UI.UserControl
    {
        public event EventHandler BubbleClick;
        DataUtility datauUtility = new DataUtility();

        public string SelectedDate
        {
            get
            {
                if (textBox.Text != "")
                {
                    return textBox.Text;
                }
                else
                    return String.Empty;
            }
            set
            {
                if (value != "1/1/1900")
                    textBox.Text = value;
                else
                    textBox.Text = "";
                
                hidPreviousvalue.Value = textBox.Text;
            }

        }

        public int TabIndex
        {
            set { textBox.TabIndex = (short)value; }
        }

        public bool ReadOnly
        {
            set
            {
                Image1.Visible = (!value);
                textBox.ReadOnly = value;
            }
        }

        public string Name
        {
            get { return Hidname.Value; }
            set { Hidname.Value = value; }
        }

        public string UserName = string.Empty;                

        protected void OnBubbleClick(EventArgs e)
        {
            if (BubbleClick != null)
            {
                BubbleClick(this, e);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(OrderEntrydatepicker),this.Page);
        }

        protected string GetSiteURL()
        {
            string url = "'Common/DatePicker/DatePicker_ClientInterface.aspx'"; 
            return url;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string _columnValue = "";
            ScriptManager scmParent = this.Parent.Page.FindControl("scmWOE") as ScriptManager;

            if (textBox.ClientID == "dpPickShtDt_textBox")
            {
                _columnValue = "PickSheetDt='" + textBox.Text +"'";
                UpdatePOHeaderDate(_columnValue);
                scmParent.SetFocus("dpReqDt_textBox");
            }
            else if (textBox.ClientID == "dpReqDt_textBox")
            {
                _columnValue = "ScheduledReceiptDt='" + textBox.Text + "',RequestedReceiptDt='" + textBox.Text + "'";
                UpdatePODetailDate(_columnValue);
                scmParent.SetFocus("dpIMReviewDt_textBox");
            }
            
        }

        public void UpdatePODetailDate(string columnValue)
        {
            try
            {
                if (Session["PODetailID"] != null && Session["PODetailID"].ToString() != "")
                {
                    string tableName = (Session["WODetailTableName"] == null) ? "PODetail" : Session["WODetailTableName"].ToString();                    
                    datauUtility.UpdateTableData(tableName,
                                                columnValue + ",ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now + "'",
                                                "pPODetailId=" + Session["PODetailID"].ToString());
                }

            }
            catch (Exception ex) { }
        }

        public void UpdatePOHeaderDate(string columnValue)
        {
            try
            {
                if (Session["POHeaderID"] != null && Session["POHeaderID"].ToString() != "")
                {
                    string tableName = (Session["WOHeaderTableName"] == null) ? "POHeader" : Session["WOHeaderTableName"].ToString();
                    datauUtility.UpdateTableData(tableName,
                                                columnValue + ",ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now + "'",
                                                "pPoHeaderID=" + Session["POHeaderID"].ToString());
                }

            }
            catch (Exception ex) { }
        }
        
    }
}
