#region Namespace
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using WebSupergoo.ABCpdf5;
using dotnetCHARTING; 
#endregion

/// <summary>
/// Summary description for CustomerActivitySheet
/// </summary>
namespace PFC.Intranet.BusinessLogicLayer
{
    public class CustomerActivitySheet
    {
        #region Constructor
        /// <summary>
        /// CustomerActivitySheet constructor
        /// </summary>
        public CustomerActivitySheet()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        #endregion

        #region Developer generated Code
        /// <summary>
        /// GetCustomerActivityDetail :Method used to get from database based on the query Parameter
        /// </summary>
        /// <param name="strWhere"> DataType:String Required filter criteria </param>
        /// <param name="strFields">DataType:String required fields to fetch from DB </param>
        /// <param name="strTable">DataType:String Required Table name</param>
        /// <returns>Return retrived data as DataTable </returns>
        public DataTable GetCustomerActivityDetail(string strWhere, string strFields, string strTable)
        {
            try
            {
                DataSet dsCas = new DataSet();

                dsCas = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", strTable),
                    new SqlParameter("@columnNames", strFields),
                    new SqlParameter("@whereClause", strWhere));

                return dsCas.Tables[0];
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// Method used to get Category Sales Data based on the parameter
        /// </summary>
        /// <param name="strMonth">CurMonth</param>
        /// <param name="strYear">CurYear</param>
        /// <param name="strBranch">Branch </param>
        /// <param name="strCustNo">Customer Number</param>
        /// <returns></returns>
        public DataSet GetCategorySalesData(string strMonth, string strYear, string strBranch, string strCustNo)
        {
            try
            {
                DataSet dsCategoryInfo = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[PFC_SP_CASCategories]",
                      new SqlParameter("@PeriodMonth", strMonth),
                      new SqlParameter("@PeriodYear", strYear),
                      new SqlParameter("@Branch", strBranch),
                      new SqlParameter("@CustNo", strCustNo));

                return dsCategoryInfo;
            }
            catch (Exception ex)
            {
                return null;
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
        /// <summary>
        /// GetPaletteName :Public method used to get dotnetCHARTING Palette type based on 
        /// chartPalette Parameter
        /// </summary>
        /// <param name="chartPalette">Required dotnetCHARTING.Palette Type</param>
        /// <returns>dotnetCHARTING.Palette Type </returns>
        public dotnetCHARTING.Palette GetPaletteName(string chartPalette)
        {
            switch (chartPalette)
            {
                case "None":
                    return Palette.None;
                    break;
                case "One":
                    return Palette.One;
                    break;
                case "Two":
                    return Palette.Two;
                    break;
                case "Three":
                    return Palette.Three;
                    break;
                case "Four":
                    return Palette.Four; ;
                    break;
                case "Five":
                    return Palette.Five;
                    break;
                case "Random":
                    return Palette.Random;
                    break;
                case "Autumn":
                    return Palette.Autumn;
                    break;
                case "Bright":
                    return Palette.Bright;
                    break;
                case "Lavender":
                    return Palette.Lavender;
                    break;
                case "Midtones":
                    return Palette.MidTones;
                    break;
                case "Mixed":
                    return Palette.Mixed;
                    break;
                case "Pastel":
                    return Palette.Pastel;
                    break;
                case "Poppies":
                    return Palette.Poppies;
                    break;
                case "Spring":
                    return Palette.Spring;
                    break;
                case "WarmEarth":
                    return Palette.WarmEarth;
                    break;
                case "WaterMeadow":
                    return Palette.WaterMeadow;
                    break;
                case "DarkRainbow":
                    return Palette.DarkRainbow;
                    break;
                case "MidRange":
                    return Palette.MidRange;
                    break;
                case "VividDark":
                    return Palette.VividDark;
                    break;
                default:
                    return Palette.WarmEarth;
                    break;
            }
        } 
        #endregion

    }//End Class 

}//End Namespace 
