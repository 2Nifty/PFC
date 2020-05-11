using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Windows.Forms;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace PFC.SOE.UserControls
{    
    public partial class CommonLink : System.Web.UI.UserControl
    {
        private string _tableName;
        private string _columnNames;
        private string _valueField;
        private string _textField;
        private string _whereClause;
        private bool isOpenItem =false;
        private bool isDefault;
        private bool isCarrier=false;
        private bool isreadOnly = false;
        private string _txtID;

        public string Text
        {
            get { return lblValue.Text; }
            set 
            { lblValue.Text = value.Trim();
            hidMode.Value = value.Trim();
            TxtID = lblValue.ClientID;
            }
        }
        public string ToolTip
        {  
            set
            {
                lblValue.ToolTip = value; 
            }
            get
            {
                return lblValue.ToolTip;
            }
        }
        public bool ReadOnly
        {
            set
            {
                lbtnLink.Font.Underline = (!value);
                lbtnLink.Style.Add(HtmlTextWriterStyle.Cursor,((value)?"default":"hand"));
                lblValue.ReadOnly = value;
                isreadOnly = value;
                if (value)
                {
                    lbtnLink.Attributes.Add("onclick", "javascript:return false;");
                    lblValue.Attributes.Add("onblur", "javascript:return false;");
                    lblValue.Attributes.Add("onkeypress", "javascript:return false;");
                }
            }
            get
            {
                return isreadOnly;
            }
        }
      
        public string TxtID
        {
            get { return _txtID; }
            set { _txtID = value; }
        }
        public int ContentWidth
        {
            set { lblValue.Width = value; }
        }
        public int CaptionWidth
        {
            set { lbtnLink.Width = value; }
        }
        public string LinkText
        {
            get { return lbtnLink.Text; }
            set { lbtnLink.Text = value; }
        } 
        public string TableName
        {
            get { return _tableName; }
            set { _tableName = value; }
        } 
        public string ColumnNames
        {
            get { return _columnNames; }
            set { _columnNames = value; }
        }
        public string ValueField
        {
            get { return _valueField; }
            set { _valueField = value; }
        }
        public string TextField
        {
            get { return _textField; }
            set { _textField = value; }
        }
        private string dataSource;

        public string DataSource
        {
            get { return dataSource; }
            set { dataSource = value; }
        }
        
        public bool ISDefault
        {
            get { return isDefault; }
            set { isDefault = value; }
        }
        public string WhereClause
        {
            get { return _whereClause; }
            set { _whereClause = value; }
        }
        public string Class
        {
            set { lblValue.CssClass = value; }
        }
        public bool IsOpenItem
        {
            get { return isOpenItem; }
            set { isOpenItem = value; }
        }
        public bool IsLineEditable
        {
            get { return isCarrier; }
            set { isCarrier = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
           

            if (IsOpenItem)
            {
                lblValue.Attributes.Add("onkeypress", "if(event.keyCode == 13){UpdateValue(this);OpenWorkSheet();}");
                lblValue.Attributes.Add("onblur", "UpdateValue(this);OpenWorkSheet();");
            }
            if (!ReadOnly)
            {

                if (!IsLineEditable)
                {
                     
                    lbtnLink.Attributes.Add("onclick", "javascript:return OpenWindow(this);");
                    lblValue.Attributes.Add("onblur", "javascript:UpdateValue(this);");
                    lblValue.Attributes.Add("onkeypress", "javascript:if(event.keyCode==13){UpdateValue(this);}");
                }
                else
                {
                    lbtnLink.Attributes.Add("onclick", "javascript:return OpenLineHeaderWindow(this,'" + lbtnLink.Text + "');");
                    lblValue.Attributes.Add("onblur", "javascript:UpdateLineHeaderValue(this,'" + lbtnLink.Text + "');");
                    lblValue.Attributes.Add("onkeypress", "javascript:if(event.keyCode==13){UpdateLineHeaderValue(this,'" + lbtnLink.Text + "');}");
                  //  lblValue.Attributes.Add("onkeydown", "javascript:if(event.keyCode==9){event.keyCode=0;UpdateCarrierValue(this);}");
                } 
            }
        }
        protected void lblValue_TextChanged(object sender, EventArgs e)
        {

        }
    }
}