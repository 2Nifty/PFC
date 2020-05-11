using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using WebSupergoo.ABCpdf5;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.Enums;

namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for Utility
    /// </summary>
    public class Utility
    {
        public string UpdateMessage
        {
            get { return "Data has been successfully updated"; }
        }
        public string AddMessage
        {
            get { return "Data has been successfully added"; }
        }
        public string DeleteMessage
        {
            get { return "Data has been successfully deleted"; }
        }
        
        public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();

                  
                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("N/A", ""));
                    }

                }
            }
            catch (Exception ex) { }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="lstControl"></param>
        /// <param name="textField"></param>
        /// <param name="valueField"></param>
        /// <param name="dtSource"></param>
        public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource, string defaultValue)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();
                    lstControl.Items.Insert(0, new ListItem(defaultValue, ""));


                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("N/A", ""));
                    }

                }
            }
            catch (Exception ex) { }
        }
        /// <summary>
        /// Public method to set selected value in dropdown controls
        /// </summary>
        /// <param name="lstControl"></param>
        /// <param name="selectedValue"></param>
        public void HighlightDropdownValue(DropDownList lstControl, string selectedValue)
        {
            foreach (ListItem item in lstControl.Items)
            {
                if (item.Value.ToLower().Trim() == selectedValue.Trim().ToLower())
                {
                    item.Selected = true;
                    return;
                }

            }
        }
        /// <summary>
        /// CreatePDF :Public method used to create PDF file  
        /// </summary>
        /// <param name="SourceFilePath">SourceFilePath Datatype:String </param>
        /// <param name="DestinationFilePath">DestinationFilePath Datatype:String</param>
        public void CreatePDF(string SourceFilePath, string DestinationFilePath)
        {
            //
            // Initialize required variables
            //
            string theURL = string.Empty;
            int theID;

            //
            // Create Pdf using the source file as input
            //
            Doc theDoc = new Doc();
            //theDoc.Rect.Inset(120, 100);
            theDoc.Page = theDoc.AddPage();

            theID = theDoc.AddImageUrl(SourceFilePath);

            //
            // Loop through and add all the html files
            //
            while (true)
            {
                theDoc.FrameRect(); // add a black border
                if (!theDoc.Chainable(theID))
                    break;
                theDoc.Page = theDoc.AddPage();
                theID = theDoc.AddImageToChain(theID);
            }

            for (int i = 1; i <= theDoc.PageCount; i++)
            {
                theDoc.PageNumber = i;
                theDoc.Flatten();
            }

            //
            // Now save the pdf file
            //
            theDoc.Save(DestinationFilePath);
            theDoc.Clear();

        }

        public static bool IsNumeric(object o)
        {
            if (o is IConvertible)
            {
                TypeCode tc = ((IConvertible)o).GetTypeCode();
                if (TypeCode.Char <= tc && tc <= TypeCode.Decimal)
                    return true;
            }
            return false;
        }

        public void DisplayMessage(MessageType messageType, string messageText, Label lblMessage)
        {
            switch (messageType)
            {
                case MessageType.Success:
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case MessageType.Failure:
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;
            }

            lblMessage.Text = messageText;
            lblMessage.Visible = true;
        }

        public string FormatPhoneNumber(string phoneNumber)
        {
            string result = string.Empty;
            if (phoneNumber.Trim() != "")
                result = ((phoneNumber.Length == 10) ?
                                ("(" + phoneNumber.Substring(0, 3) + ")" + " " + phoneNumber.Substring(3, 3) + "-" + phoneNumber.Substring(6, 4)) : ((phoneNumber.Length == 11)?
                                (phoneNumber.Substring(0, 1) + "-" + phoneNumber.Substring(1, 3) + "-" + phoneNumber.Substring(4, 3) + "-" + phoneNumber.Substring(7, 4)):phoneNumber));
            else
                result = "";

            return result;
        }
    }
}