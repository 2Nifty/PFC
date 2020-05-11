using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using System.IO;




public partial class SalesAnalysisReport_ReportDownLoad : System.Web.UI.Page
{
    string strFilename = string.Empty;
    string StrPathname = string.Empty;
    System.IO.FileStream fStream;

    protected void Page_Load(object sender, EventArgs e)
    {
        strFilename = Request.QueryString["FileName"].ToString();
        //string strPathname = Server.MapPath("..//Common//ExcelUploads//CategoryTrendAnalysis");
        StrPathname = Server.MapPath("..//Common//ExcelUploads//" + strFilename);
        //lnkDownLoad.HRef = "../Common/ExcelUploads/" + Request.QueryString["FileName"].ToString();
        GetDownloadExcelFile(strFilename, StrPathname);
    }

    public void GetDownloadExcelFile(string strFile, string strPath)
    {
        fStream = new System.IO.FileStream(strPath, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read);
        Byte[] b;
        if (fStream.Length > 0)
        {
            //b = new Byte[fStream.Length];
            //Response.Clear();
            //Response.ClearContent();
            //Response.ClearHeaders();
            //Response.ContentType = "application/vnd.ms-excel";
            //fStream.Read(b, 0, (int)fStream.Length - 1);
            //Response.AppendHeader("Content-Disposition", "attachment;filename=" + strFile);
            //Response.BinaryWrite(b);
            //Response.End();
            //fStream.Close();

            b = new Byte[fStream.Length];
            Response.Clear();
            Response.ClearContent();

            // Disable caching this page (C#)
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Buffer = true;
            Response.ContentType = "application/vnd.ms-excel";
            Response.ClearHeaders();
            //Response.ContentType = "application/vnd.ms-excel";
            fStream.Read(b, 0, (int)fStream.Length - 1);
            Response.CacheControl = "private";
            Response.AppendHeader("Content-Disposition", "attachment;filename=" + strFile);
            Response.BinaryWrite(b);
            Response.End();
            fStream.Close();

        }
    }

}
