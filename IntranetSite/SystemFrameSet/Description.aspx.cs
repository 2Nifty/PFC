using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;

public partial class SystemFrameSet_Description : System.Web.UI.Page
{
    private const string SP_GENERALSELECT = "UGEN_SP_Select";
    UserValidation objUser = new UserValidation();
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();

        if (Request.QueryString["DolistID"] != null)
          LoadDolist();
    }
   
    private void LoadDolist()
    {
        try
        {
            // Local variable declaration
            string _tableName = "PFC_UserFavourites";
            string _columnName = "Content,Description";
            string _whereClause = "[ID] = '" + Request.QueryString["DolistID"].ToString()+"'";

            DataSet dsuserDolist = SqlHelper.ExecuteDataset(Global.QuotesSystemConnectionString, SP_GENERALSELECT,
                                            new SqlParameter("@tableName", _tableName),
                                            new SqlParameter("@columnNames", _columnName),
                                            new SqlParameter("@whereCondition", _whereClause));


            // Check whether any value has returned
            if (dsuserDolist.Tables[0].Rows.Count > 0)
            {
                lblHeader.Text = "Do List:  " + dsuserDolist.Tables[0].Rows[0]["Content"].ToString();
                Description.InnerHtml = dsuserDolist.Tables[0].Rows[0]["Description"].ToString();   
            }
        }
        catch (Exception ex)
        {
            throw;
        }
    }
}
