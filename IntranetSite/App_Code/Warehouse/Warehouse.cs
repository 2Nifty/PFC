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
    /// Summary description for Warehouse
    /// </summary>
    public class Warehouse
    {

        string tableName = "";
        string columnName = "";
        string whereClause = "";

        string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        //string erpConnectionString = "workstation id=PFCERPDB;packet size=4096;user id=pfcnormal;data source=PFCERPDB;persist security info=True;initial catalog=PERP;password=pfcnormal" ;

        public DataTable GetLPNInformation(string whereCondition)
        { 
               try
            {

                string command = "Select " +
                                " BIN.License_Plate as LPN,BIN.Location as WHSE,convert(char(10),cast (Substring(BIN.Date_TIme,1,9)as DateTime),101) as LPNDate,BIN.Product as ItemNo, " +
                                " cast((BIN.quantity*BIN.Packsize)as Varchar)+'/'+ PM.Pksize1 as QtyUOM, BIN.BinLabel as BinLoc," +
                                " LPN.ContainerNo as ContainerNo, LPN.BolNo as BolNo, LPN.DocumentNo as DocumentNo" +
                                " From" +
                                " ( " +
                                " Select SourceDocumentID,LPNNo, Location,ContainerNo,BolNo,DocumentNo" +
                                " From LPNAuditControl" +
                                " Where " + whereCondition + ") LPN Inner Join " +
                                " OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.[dbo].BINLOCAT BIN ON LPN.LPNNo = BIN.LICENSE_PLATE inner join " +
                                " OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.[dbo].ProdMstr PM on BIN.Product=PM.Product";


                DataSet dsReport = new DataSet();

                using (SqlConnection conn = new SqlConnection(erpConnectionString))
                {
                    SqlDataAdapter adp;
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = command;

                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = conn;
                    conn.Open();
                    adp = new SqlDataAdapter(cmd);
                    adp.Fill(dsReport);
                }
                

                return dsReport.Tables[0];
                
                
            }
            catch (Exception ex) { throw ex; }
        }

        public DataTable GetLocation()
        {
            try
            {

                DataSet dsData = new DataSet();
                SqlConnection conn = new SqlConnection(erpConnectionString);
                SqlDataAdapter adp;
                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "select LocID as Code, LocID + ' - ' + LocName  as Name from LocMaster (NoLock) where MaintainIMQtyInd='Y' Order By LocID";
                cmd.CommandType = CommandType.Text;
                cmd.Connection = conn;
                conn.Open();
                adp = new SqlDataAdapter(cmd);
                adp.Fill(dsData);
                conn.Close();
                
                return dsData.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

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

        }

    }
