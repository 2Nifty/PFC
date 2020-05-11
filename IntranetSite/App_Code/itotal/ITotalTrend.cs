using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for ITotalTrend
    /// </summary>


    

    public class ITotalTrend
    {
        string connectionString = ConfigurationManager.ConnectionStrings["ITotalERP"].ToString();

        public DataTable GetGridData()
        {
           DataSet  dsTrend = SqlHelper.ExecuteDataset(connectionString, "[pITotalBuyCatTrend]");
           return dsTrend.Tables[0];
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
                case MessageType.None:

                    break;

            }

            lblMessage.Text = messageText;
            lblMessage.Visible = true;
        }
    }
}