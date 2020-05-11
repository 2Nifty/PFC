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
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for EmployeeInfo
    /// </summary>
    public class EmployeeInfo
    {

        string tableName = "";
        string columnName = "";
        string whereClause = "";

       string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
       //string connectionString = "workstation id=PFCERPDB;packet size=4096;user id=pfcnormal;data source=PFCERPDB;persist security info=True;initial catalog=PERP;password=pfcnormal";

        public DataTable GetLocationView(string whereCondition)
        {
            try
            {

                columnName = "SU.pSecUserID as ID,EM.EmployeeName as Name,SU.UserName,LocM.LocState,LocM.LocName,(LocM.LocName+', '+LocM.LocState) as Location,SG.GroupName as GroupName," +
                             "D.DepartmentName as Department,D.DepartmentNo";

                tableName = "SecurityUsers SU inner join EmployeeMaster EM on EM.pEmployeeMasterId=SU.fEmpMasterId left outer join Departments D on EM.DepartmentNo=D.DepartmentNo left outer  join " +
                            "LocMaster LocM on SU.IMLoc=LocM.Locid left outer join SecurityMembers SM on  SM.SecUserId=SU.pSecUserId " +
                            "left outer join  SecurityGroups SG on  SM.SecGroupID= SG.pSecGroupID ";
                //and SM.SecUserID
              
                if (whereCondition != "")

                    whereClause = "SU.DeleteDt is null " + whereCondition;
                else
                    whereClause = "SU.DeleteDt is null";

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                                new SqlParameter("@tableName", tableName),
                                                new SqlParameter("@columnNames", columnName),
                                                new SqlParameter("@whereClause", whereClause));

                return dsDetails.Tables[0];
                
            }
            catch (Exception ex) { return null; }
        }

        public DataTable GetUser(string whereCondition)
        {
            try
            {

                columnName = "SU.pSecUserID AS ID,EM.pEmployeeMasterID as EmpId, ISNULL(SU.UserName, '') AS UserName, LocM.LocState, LocM.LocName,LocM.LocName + ', ' + LocM.LocState AS Location, EM.EmployeeName  as [Name]";
                tableName = "dbo.SecurityUsers AS SU INNER JOIN dbo.EmployeeMaster AS EM ON SU.fEmpMasterID = EM.pEmployeeMasterID LEFT OUTER JOIN dbo.LocMaster AS LocM ON SU.IMLoc = LocM.LocID";
                whereClause = "SU.DeleteDt is null " + whereCondition + " Order By EM.EmployeeName";
                
                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                return dsDetails.Tables[0];

            }
            catch (Exception ex)
            { throw ex; }
        }

        public DataTable GetBindData(string whereClause)
        {
            try
            {
                tableName = "ListMaster LM,ListDetail LD";
                columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
               
               

                DataSet dsProgram = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsProgram.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetDepartment(string location)
        {
            try
            {
                
                columnName = "DepartmentNo, cast(DepartmentNo as varchar(5)) +' – '+ DepartmentName as Department";
                whereClause = "LocationNo='"+location+"'";

                DataSet dsDept = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                              new SqlParameter("@tableName", "Departments"),
                              new SqlParameter("@columnNames", columnName),
                              new SqlParameter("@whereClause", whereClause));

                return dsDept.Tables[0];
            }
            catch (Exception ex)
            { throw ex; }
        }

        public DataTable GetSupervisior(string location)
        {
            try
            {

                columnName = "(EmployeeName ) as Supervisior,pEmployeeMasterID  ";
                whereClause =" SupervisorInd = 'Y' and Location='"+location+"'";

                DataSet dsLoc = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                              new SqlParameter("@tableName", "EmployeeMaster"),
                              new SqlParameter("@columnNames", columnName ),
                              new SqlParameter("@whereClause", whereClause));

                return dsLoc.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        public DataTable GetDefaultSupervisior(string location)
        { 
 
            try
            {
                tableName ="EmployeeMaster e,Departments d";
                columnName = "(e.EmployeeNo+' - '+e.EmployeeName ) as Supervisior,pEmployeeMasterID ";
                whereClause =" e.SupervisorInd = 'Y' and e.Location='"+location +"' and d.ManagerId=e.pEmployeeMasterID";

                DataSet dsLoc = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                              new SqlParameter("@tableName", tableName),
                              new SqlParameter("@columnNames", columnName ),
                              new SqlParameter("@whereClause", whereClause));

                return dsLoc.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetLocationName()
        {
            try
            {

                DataSet dsLoc = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                              new SqlParameter("@tableName", "LocMaster"),
                              new SqlParameter("@columnNames", " Rtrim(LOCID) as Code, LOCID + ' - ' + [LocName] as Name"), //LOCID + '-' +
                              new SqlParameter("@whereClause", " Loctype ='B'"));

                return dsLoc.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public DataTable GetSecurityGroups(string userName)
        {

            try
            {


               
                tableName = "SecurityGroups";
                columnName = "distinct psecGroupID as ListValue,GroupName as GroupCd";
                whereClause = "psecGroupID not in ( select SM.SecGroupID from SecurityGroups SG,dbo.SecurityMembers SM " +
                                "where SM.SecGroupID= SG.pSecGroupID and SM.SecUserID=" + userName + ")";
                    
                DataSet dsSecurity = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsSecurity.Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        public DataTable GetUserGroup(string userName)
        {

            try
            {
              
               tableName = "SecurityGroups SG,dbo.SecurityMembers SM";
                columnName = "distinct SG.pSecGroupID as SecGroupID,SG.GroupName as SecurityGroupApp,SM.pSecMembersID";
                whereClause = " SM.SecGroupID= SG.pSecGroupID and SM.SecUserID="+userName;
                   
        

                DataSet dsUser = SqlHelper.ExecuteDataset(connectionString, "PSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
                return dsUser.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public string  GetUserID(string userName)
        {
            try
            {
                tableName = "SecurityUsers ";
                columnName = "pSecUserID";
                whereClause = "fEmpMasterId=(select pEmployeeMasterId from EmployeeMaster where EmployeeName='"+userName+"') and DeleteDt is null  ";

                object user =(object) SqlHelper.ExecuteScalar(connectionString, "PSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));
               
                if (user != null)
                     return user.ToString().Trim();
                 // return Convert.ToInt32(user);
                else
                    return "";
            }
            catch (Exception ex)
            {
                return "";
            }

        }

        public string GetUserIDByEmployeeID(string employeeID)
        {
            try
            {
                tableName = "SecurityUsers";
                columnName = "pSecUserID";
                whereClause = "fEmpMasterId=" + employeeID + "  and DeleteDt is null  ";

                object user = (object)SqlHelper.ExecuteScalar(connectionString, "PSOESelect",
                                new SqlParameter("@tableName", tableName),
                                new SqlParameter("@columnNames", columnName),
                                new SqlParameter("@whereClause", whereClause));

                if (user != null)
                    return user.ToString().Trim();
                // return Convert.ToInt32(user);
                else
                    return "";
            }
            catch (Exception ex)
            {
                return "";
            }

        }

        public string GetSecUserID(string userName)
        {
            try
            {
                tableName = "SecurityUsers";
                columnName = "pSecUserId as SecUserID";
                whereClause = "UserName='" + userName + "'";

                object UserId = (object)SqlHelper.ExecuteScalar(connectionString, "PSOESelect",
                                        new SqlParameter("@tableName", tableName),
                                        new SqlParameter("@columnNames", columnName),
                                        new SqlParameter("@whereClause", whereClause));
                if (UserId != null)
                {
                    return UserId.ToString().Trim();
                }
                else
                    return "";
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public DataTable GetSecurityData(string userName,string whereCondition)
        {
            try
            {
              
                tableName = "SecurityGroups";
                columnName = "distinct psecGroupID as ListValue,GroupName as GroupCd";
                whereClause = "psecGroupID not in ( select SM.SecGroupID from SecurityGroups SG,dbo.SecurityMembers SM " +
                                "where SM.SecGroupID= SG.pSecGroupID and SM.SecUserID=" + userName + ") " + whereCondition;
                   
                
                DataSet dsSecurity = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsSecurity.Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateSecurityGroup(string columnValue,string groupId)
        {
            try
            {
                tableName = "SecurityMembers SM ";

                whereClause = "SM.SecGroupID =" + groupId;

                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                                     new SqlParameter("@tableName", tableName ),
                                     new SqlParameter("@ColumnValues", columnValue),
                                     new SqlParameter("@WhereClause", whereClause));

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void  UpdateSecurityAfterDelete(string columnValue,string userId)
        {
            try
            {
                tableName = "SecurityMembers";

                whereClause = "SecUserID =" + userId;

                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                                     new SqlParameter("@tableName", tableName),
                                     new SqlParameter("@ColumnValues", columnValue),
                                     new SqlParameter("@WhereClause", whereClause));

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertUserGroup(string columnValue)
        {
            try
            {
                tableName = "SecurityMembers ";
                columnName = "SecGroupID,SecurityGroupApp,SecUserId,EntryId,EntryDt";
              
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEInsert]",
                                        new SqlParameter("@tableName", tableName),
                                        new SqlParameter("@columnNames", columnName ),
                                        new SqlParameter("@ColumnValues", columnValue));

             }
            
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string InsertSecurityUser(string columnValue)
        {
            try
            {
                tableName = "SecurityUsers";
                columnName = "fUserMasterID,UserName,EntryId,EntryDt";

                string userID = SqlHelper.ExecuteScalar(connectionString, "[pSOEGetIdentityAfterInsert]",
                                        new SqlParameter("@tableName", tableName),
                                        new SqlParameter("@columnNames", columnName),
                                        new SqlParameter("@ColumnValues", columnValue)).ToString();
                return userID;
            }

            catch (Exception ex)
            {
                return "";
                throw ex;
            }
        }

        public void DeleteUserGroup(string whereClause)
        { 
            
            try
            {
                tableName = "SecurityMembers";
                
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", tableName),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetUserName(string whereCondition)
        {
            try
            {               
                tableName = "EmployeeMaster EM inner join  SecurityUsers SU on EM.pEmployeeMasterID=SU.fEmpMasterID ";
                columnName = "EM.EmployeeName,SU.UserName";
                whereClause = "SU.DeleteDt is null and " + whereCondition;
                DataSet  dsUserName = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                           new SqlParameter("@tableName", tableName),
                           new SqlParameter("@columnNames", columnName),
                           new SqlParameter("@whereClause", whereClause));

                return dsUserName.Tables[0];
               
            }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable  CountUser(string whereCondition)
        {
            try
            {
                tableName = "EmployeeMaster EM inner join  SecurityUsers SU on EM.pEmployeeMasterID=SU.fEmpMasterID ";
                columnName = "EM.EmployeeName, SU.pSecUserId as SecUserID";
                whereClause = "SU.DeleteDt is null " + whereCondition;

                DataSet dsUser = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                            new SqlParameter("@tableName",  tableName),// "EmployeeMaster"),
                            new SqlParameter("@columnNames", columnName ),// "EmployeeName"),
                            new SqlParameter("@whereClause", whereClause));

                return dsUser.Tables[0];

            }

            catch (Exception ex)
            { 
                throw ex; 
            }
        }

        #region EmployeeData

        public bool CheckUser(string whereCondition)
        {
            try
            {
               
                DataSet dsUser = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                            new SqlParameter("@tableName", "EmployeeMaster"),
                            new SqlParameter("@columnNames", "EmployeeName"),
                            new SqlParameter("@whereClause", whereCondition));

                if (dsUser.Tables[0].Rows.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
               

            }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool CheckUserID(string empNo)
        {
            try
            {
                whereClause = "EmployeeNo='" + empNo + "'  and DeleteDt is null";
                DataSet dsUser = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                            new SqlParameter("@tableName", "EmployeeMaster"),
                            new SqlParameter("@columnNames", "EmployeeName"),
                            new SqlParameter("@whereClause", whereClause));

                if (dsUser.Tables[0].Rows.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }


            }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        public string InsertEmployeeData(string columnValue)
        {
            try 
            {
                tableName = "EmployeeMaster";
                columnName = "EmployeeName,Location,EmployeeNo,EmploymentStatus,HireDt,DepartmentNo,"+
                             "DefaultJobCd,Shift,SupervisorEmpID,FirstName,MiddleInitial,LastName,Salutation,"+
                             "EmailAddress,PhoneNo,FaxNo,PayCd,PayRollEmployeeNo,PayRollLocation,HolidayHours,SickHours,"+
                             "VacationHours,LeaveBeginDt,LeaveEndDt,LeaveBalanceDt,BenefitBalance,EntryID,EntryDt,SupervisorInd";

                object objUserId = (object)SqlHelper.ExecuteScalar(connectionString, "[pSOEInsert]",
                                       new SqlParameter("@tableName", tableName),
                                       new SqlParameter("@columnNames", columnName),
                                       new SqlParameter("@ColumnValues", columnValue)).ToString();

                return objUserId.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
                return null;
            }
        }

        public DataTable  GetEmployeeData(string employeeName)
        {
            try
            {
                tableName = "EmployeeMaster";
                columnName = "EmployeeName,Location,EmployeeNo,EmploymentStatus,convert(char(10),HireDt,101)as HireDt,DepartmentNo," +
                             "DefaultJobCd,Shift,SupervisorEmpID,FirstName,MiddleInitial,LastName,Salutation," +
                             "EmailAddress,PhoneNo,FaxNo,PayCd,PayRollEmployeeNo,PayRollLocation,HolidayHours,SickHours," +
                             "VacationHours,convert(char(10),LeaveBeginDt,101) as LeaveBeginDt,convert(char(10), LeaveEndDt,101)as LeaveEndDt,convert(char(10),LeaveBalanceDt,101) as LeaveBalanceDt,BenefitBalance,pEmployeeMasterID";
                whereClause = "EmployeeName='" + employeeName+"' and DeleteDt is null";

                DataSet dsEmployee = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                   new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause));
                return dsEmployee.Tables[0];

            }
            catch (Exception ex)
            { throw ex; }
        }

        public void UpdateEmployeeData(string columnValues,string employeeID)
        {
            try
            {
                whereClause = "pEmployeeMasterID=" + employeeID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "EmployeeMaster"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region UserSettings

        public string InsertUserData(string columnValue)
        {
            try
            {
                tableName = "SecurityUsers";
                columnName = "Location,IMLoc,fEmpMasterID," +
                              "EntryID,EntryDt";
               object objUserId=(object) SqlHelper.ExecuteScalar(connectionString, "[pSOEInsert]",
                                       new SqlParameter("@tableName", tableName),
                                       new SqlParameter("@columnNames", columnName),
                                       new SqlParameter("@ColumnValues", columnValue));

               return objUserId.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateUserData(string columnValue, string userID)
        {
            try
            {
                whereClause = "pSecUserID=" + userID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "SecurityUsers"),
                             new SqlParameter("@columnNames", columnValue),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetUserData(string userId)
        { 
            try
            {
                tableName = "SecurityUsers";
                columnName = "Location,UserInterfaceInd,MSADUserName, convert(char(10),DateofLastLogin,101) as LastLoginDt,NoofLogins,LogonStatusInd," +
                            "UserName, UserPassword as Password, Domain,BuyerInd,ApproveOrderInd,ARClerkInd,PrimaryBinPrmpt,PODolLimit,ConsumablesAmt," +
                            "APApplicationInd,ARApplicationInd,GLApplicationInd, IMApplicationInd,POApplicationInd,OEApplicationInd";

                whereClause = " DeleteDt is null and  pSecUserId=" + userId ;
                              
                DataSet dsEmployee = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                  new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause));
                return dsEmployee.Tables[0];

            }
            catch (Exception ex)
            { throw ex; }
        }

        public string GetHireLocPhoneFormat(string locId)
        {
            try
            {
                tableName = "LocMaster";
                columnName = "isnull(PhoneFmt,'') as PhoneFmt";
                whereClause = "LocID=" + locId;
                              
                string _phoneFmt = SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                                  new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause)).ToString();
                return _phoneFmt;

            }
            catch (Exception ex)
            { return ""; }
        }

        public DataSet CheckUserNameDuplicate(string userName,string msadUserName,string userID)
        {
            try
            {
                // Check duplicate
                string whereCondition = "(UserName='" + userName + "' OR MSADUserName='" + msadUserName + "') AND pSecUserID<> " + userID + " AND DeleteDt is null ";

                DataSet dsUser = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "SecurityUsers"),
                                    new SqlParameter("@columnNames", "UserName,MSADUserName"),
                                    new SqlParameter("@whereClause", whereCondition));

                return dsUser;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        #endregion

        #region UserSecurity

        public void UpdateUserSecurityData(string columnValue, int userID)
        {
            
            try
            {
                whereClause = "pSecUserID=" + userID;

                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "SecurityUsers"),
                             new SqlParameter("@columnNames", columnValue),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        #endregion

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
            catch (Exception ex) { throw ex; }
        }

        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {

                string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
                #region Create where clause based on module type

                string whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='User (W) ')"; ;
              
                #endregion

                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + whereClause));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
        #endregion

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