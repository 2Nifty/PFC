using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace PFC.Intranet.Utility
{
    /// <summary>
    /// Summary description for Utility
    /// </summary>
    public class Utility
    {
        public Utility()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        public void CheckBrowserCompatibility(HttpRequest request, DataGrid dataGrid, ref int pageSize)
        {
            if (request.Browser.Type.ToString().ToLower().Contains("firefox"))
            {
                dataGrid.GridLines = GridLines.None;
                pageSize = 20;
            }
        }

        public void CheckBrowserCompatibility(HttpRequest request, DataGrid dataGrid)
        {
            if (request.Browser.Type.ToString().ToLower().Contains("firefox"))
            {
                dataGrid.GridLines = GridLines.None;                
            }
        }

        public static string ConvertColumnvaluesToCSV(DataTable dtSourceTable,string columnName)
        {
            string _CSVstring = "";

            DataTable dvSourceTable = dtSourceTable.DefaultView.ToTable(true, columnName);

            if (dvSourceTable.Rows.Count > 0)
            {
                foreach (DataRow dr in dvSourceTable.Rows)
                {
                    _CSVstring += ",'" + dr[columnName.Trim()].ToString() + "'";
                }
            }
            _CSVstring = (_CSVstring.Trim().Length > 0 ? _CSVstring.Remove(0, 1) : _CSVstring);

            return _CSVstring;
        }
        public static string ConvertColumnvaluesToCSV(DataTable dtSourceTable, string columnName,int startIndex,int endIndex)
        {
            string _CSVstring = "";

            DataTable dvSourceTable = dtSourceTable.DefaultView.ToTable(true, columnName);

            if (dvSourceTable.Rows.Count > 0)
            {

                for (int count = startIndex; count < endIndex; count++)
                {
                    _CSVstring += ",'" + dvSourceTable.Rows[count][columnName.Trim()].ToString() + "'"; 
                }
                
            }
            _CSVstring = (_CSVstring.Trim().Length > 0 ? _CSVstring.Remove(0, 1) : _CSVstring);

            return _CSVstring;
        }
        public string FormatePhoneNumber(string phoneNumber)
        {
            string phone = phoneNumber;
            if (phone.Trim().Length == 10)
                phone = ("(" + phone.Substring(0, 3) + ")" + " " + phone.Substring(3, 3) + "-" + phone.Substring(6, 4));
            else if (phone.Trim().Length == 11)
                phone = (phone.Substring(0, 1) + "-" + phone.Substring(1, 3) + "-" + phone.Substring(4, 3) + "-" + phone.Substring(7, 4));

            return phone;
        }
    }

}
