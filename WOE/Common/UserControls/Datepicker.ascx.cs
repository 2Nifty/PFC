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
using PFC.WOE.BusinessLogicLayer;
namespace Novantus.Umbrella.UserControls
{
    public partial class Datepicker : System.Web.UI.UserControl
    {
        public event EventHandler BubbleClick;

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
        public string SOOrderID
        {             
            get
            {
                return Session["OrderHeaderID"].ToString();
            }

        }
        public string HeaderIDColumn
        {
            get
            {
                if (Session["OrderTableName"].ToString() == "SOHeader")
                    return "fSOHeaderID";
                else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                    return "pSOHeaderRelID";
                else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                    return "pSOHeaderHistID";
                else
                    return "fSOHeaderID";
            }
        }

        public string DetailIDColumn
        {
            get
            {
                if (Session["OrderTableName"].ToString() == "SOHeader")
                    return "pSODetailID";
                else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                    return "pSODetailRelID";
                else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                    return "pSODetailHistID";
                else
                    return "pSODetailID";
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
            //customerDetail = new CustomerDetail();
            Ajax.Utility.RegisterTypeForAjax(typeof(Datepicker));
           // HidSession.Value= Session["UserName"].ToString();
        }
        /// <summary>
        /// Function to Return site url for OpenDatePicker function used in javascript
        /// </summary>
        /// <returns></returns>
        protected string GetSiteURL()
        {
            //Umbrella.Securitylayer.UmbrellaControlBlock ControlBlock = new Novantus.Umbrella.Securitylayer.UmbrellaControlBlock();
            //string url = "'" + ControlBlock.SiteURL + "Umbrella/CodePro/ScreenBuilder/DatePicker_ClientInterface.aspx" + "'";
            string url = "'Common/DatePicker/DatePicker_ClientInterface.aspx'"; 
            return url;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            //try
            //{
            //    if (Convert.ToDateTime(DateTime.Now.ToShortDateString()) <= Convert.ToDateTime(textBox.Text))
            //    {
            //        string strTableName = (Session["OrderTableName"] == null) ? "SOHeader" : Session["OrderTableName"].ToString();
            //        if (Name.Trim() == "CustReqDt")
            //        {
            //            string strSchDt = customerDetail.GetValues(strTableName, "SchShipDt", HeaderIDColumn + "=" + SOOrderID);
            //            if (Convert.ToDateTime(strSchDt) <= Convert.ToDateTime(textBox.Text))
            //            {
            //                string ColumnValue = "[" + Name + "]='" + textBox.Text + "'";
            //                customerDetail.UpdateHeader(strTableName, ColumnValue + ",ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'", HeaderIDColumn + "=" + SOOrderID);                            
            //            }
            //            else
            //                ScriptManager.RegisterClientScriptBlock(btnUpdate, typeof(Button), "Invalid", "alert('Customer req Date should not be less than Sch Ship Date.');document.getElementById('" + textBox.ClientID + "').value=' ';document.getElementById('" + textBox.ClientID + "').focus();document.getElementById('" + textBox.ClientID + "').select();", true);
            //        }
            //        else
            //        {
            //            string ColumnValue = "[" + Name + "]='" + textBox.Text + "'";
            //            customerDetail.UpdateHeader(strTableName, ColumnValue + ",ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'", HeaderIDColumn + "=" + SOOrderID);                        

            //            // Update the sch ship value in sodetail reqshipdt field
            //            if (Name.Trim() == "SchShipDt")
            //            {
            //                hidPreviousvalue.Value = textBox.Text;
            //                customerDetail.UpdateHeader(Session["DetailTableName"].ToString(), "RqstdShipDt='" + textBox.Text + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'", HeaderIDColumn + "=" + SOOrderID);
            //                OnBubbleClick(e);
            //            }
            //        }

            //        ScriptManager.RegisterClientScriptBlock(btnUpdate, typeof(Button), "nextCtl", "document.getElementById('" + Image1.ClientID + "').focus();document.getElementById('" + Image1.ClientID + "').select();", true);                    
            //    }
            //    else
            //        ScriptManager.RegisterClientScriptBlock(btnUpdate, typeof(Button), "Invalid", "alert('Invalid Date');document.getElementById('" + textBox.ClientID + "').focus();document.getElementById('" + textBox.ClientID + "').select();", true);
            //}
            //catch (Exception ex) { }
        }
        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public void UpdateDate(string strSO,string dtField,string dtValue,string UserID)
        {
            try
            {   
                //string strTableName = (Session["OrderTableName"] == null) ? "SOHeader" : Session["OrderTableName"].ToString();
                //string ColumnValue = "[" + dtField + "]='" + dtValue + "'";
                //customerDetail.UpdateHeader(strTableName, ColumnValue + ",ChangeID='" + UserID.ToString() + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'", HeaderIDColumn + "=" + SOOrderID);
                
            }
            catch (Exception ex) { }

        }
        
    }
}
