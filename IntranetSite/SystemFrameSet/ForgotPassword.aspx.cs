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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;

namespace  PFC.Intranet
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        #region Variable Declaration


        protected DataSet dsUserInfo;
        protected string userName, passWord, eMailID, Name;
        protected MailSystem objMailSystem = new MailSystem();

        #endregion

        #region constant Declaration

        protected const string TBLUSERSETUP = "UCOR_Usersetup";
        protected const string SPGENERALSELECT = "UGEN_SP_Select";

        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    protected void ibtnshortcut_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (GetUserPassword())
            {
                //
                // If UserName is present in Ucor_Usersetup table send Password info to User emailID
                //
                MailUserPassword();
                lblError.Visible = true;
                lblError.ForeColor = System.Drawing.Color.Green;
                lblError.Text = "User Information has been sent to your Email";
            }
            else
            {
                lblError.Visible = true;
                lblError.ForeColor = System.Drawing.Color.Red;
                lblError.Text = "Invalid User Name supplied";
            }
        }
        catch (Exception ex)
        {
            ex = ex;
        }
    }
    /// <summary>
    /// Function to get user Password and EmailID from table
    /// </summary>
    private bool GetUserPassword()
    {
        try
        {
            DataSet dsUserPassword = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGENERALSELECT,
                                            new SqlParameter("@tableName", TBLUSERSETUP),
                                            new SqlParameter("@columnNames", "UserName,Name,Password,Email"),
                                            new SqlParameter("@whereCondition", "UserName = '" + txtUserName.Text + "'"));

            if (dsUserPassword.Tables[0].Rows.Count > 0)
            {
                DataRow drUserPassword = dsUserPassword.Tables[0].Rows[0];
                userName = drUserPassword["UserName"].ToString();
                passWord = Cryptor.Decrypt(drUserPassword["Password"].ToString());
                eMailID = drUserPassword["Email"].ToString();
                Name = drUserPassword["Name"].ToString();
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (Exception ex)
        {

            throw;
        }
    }
    /// <summary>
    /// Function used to create mail body and send a mail to User
    /// </summary>
    private void MailUserPassword()
    {
        try
        {
            objMailSystem.SendMail(eMailID, "", "", "77", "Here is your login information", userName, Name, passWord);

        }
        catch (Exception ex)
        {
            throw;
        }
    }
    }
    
}