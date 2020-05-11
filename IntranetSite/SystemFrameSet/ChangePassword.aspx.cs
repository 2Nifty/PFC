#region NameSpaces
using System;
using System.Data.SqlClient;
using System.Drawing;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;

#endregion
namespace PFC.Intranet
{
    public partial class Homepage : System.Web.UI.Page
    {
        protected bool passwordStatus, UpdateStatus;
        protected const string TBLUSERSETUP = "UCOR_Usersetup";
        protected const string SPGENERALUPDATE = "UGEN_SP_Update";
        protected const string SPGENERALSELECT = "UGEN_SP_Select";
        SystemCheck systemCheck = new SystemCheck();
        protected void Page_Load(object sender, EventArgs e)
        {
            systemCheck.SessionCheck();
        }
        /// <summary>
        /// Function which is used to change the existing password 
        /// </summary>
        protected void Ibtnsave_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {

         
             if (CheckExistingPassword())
                {
                    //
                    // IF user enters correct existing password compare the new password and update the values in table
                    //
                    UpdateStatus = InsertNewPassword();
                    if (UpdateStatus)
                    {
                        lblError.ForeColor = Color.Green;
                        lblError.Text = "You have successfully chosen a new Password.";
                    }
                    else
                    {
                        lblError.ForeColor = Color.Red;
                        lblError.Text = "Your new password entries did not match.";
                    }
                }
                else
                {
                    lblError.ForeColor = Color.Red;
                    lblError.Text = "Please specify the correct current password";
                }     
             }
          
    
        /// <summary>
        /// Function Used to check whether the user has enter the correct existin password
        /// </summary>
        private bool CheckExistingPassword()
        {
            string existingPassword = txtExistingPassWord.Text;

            DataSet dsUserPassword = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGENERALSELECT,
                                            new SqlParameter("@tableName", TBLUSERSETUP),
                                            new SqlParameter("@columnNames", "Password"),
                                            new SqlParameter("@whereCondition", "UserID = " + Session["UserID"].ToString()));


               //
            // Check the Password present in UserSetup table ,If both the passwords matched return true else false
            //
            if (dsUserPassword.Tables[0].Rows.Count > 0)
            {
                DataRow drUserPassword = dsUserPassword.Tables[0].Rows[0];
                string expassword = Cryptor.Decrypt(drUserPassword["Password"].ToString());
                if (txtExistingPassWord.Text.ToString() == expassword)
                {
                    return true;
                }
            }

            return false;
        }
        /// <summary>
        /// Function used to compare new password and update the new password to server
        /// </summary>
        private bool InsertNewPassword()
        {
            try
            {

                if (txtNewPassword.Text.ToString().Trim() == txtConfirmPassword.Text.ToString().Trim())
                {
                    //
                    // Assigning Columns and whereclause values to be inserted into Ucor_usersessionlog table
                    //
                    string newPassword = Cryptor.Encrypt(txtConfirmPassword.Text);


                    string _columnNames = "Password ='" + newPassword + "'";
                    string _whereClause = "UserID = " + Session["UserID"].ToString();

                    SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SPGENERALUPDATE,
                                                                          new SqlParameter("@tableName", TBLUSERSETUP),
                                                                          new SqlParameter("@columnNames", _columnNames),
                                                                          new SqlParameter("@whereClause", _whereClause));         

                   
                    return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                
                return false;
            }

        }

        /// <summary>
        /// Function used to redirect to home page 
        /// </summary>
        protected void IbtnCancel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {
            Server.Transfer("MainbodyFrame.aspx");
        }

      
}

}