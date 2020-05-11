using System;
using System.Collections.Specialized;
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

using PFC.SOE.DataAccessLayer;

public partial class ShowPartImage : System.Web.UI.Page
{
    string Category = "";
    string HeaderImageName = "";
    string BodyImageName = "";
    string ImageLibrary = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + ConfigurationManager.AppSettings["ProductImagesPath"].ToString();
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["ItemNumber"].ToString() != "")
        {
            Category = Request.QueryString["ItemNumber"].ToString();
            Category = Category.Substring(0, 5);
            ItemNoLabel.Text = Request.QueryString["ItemNumber"].ToString();
            DescriptionLabel.Text = Request.QueryString["Itemdesc"].ToString();

            string ColumnNames = "";
            ColumnNames = "Category ,";
            ColumnNames += "BodyFileName,";
            ColumnNames += "HeadFileName";
            ds = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                new SqlParameter("@tableName", "ItemCategory"),
                new SqlParameter("@columnNames", ColumnNames),
                new SqlParameter("@whereClause", "Category='" + Category + "'"));
            if (ds.Tables.Count == 1)
            {
                // We only got one table back
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    BodyImageName = dt.Rows[0]["BodyFileName"].ToString();
                    HeaderImageName = dt.Rows[0]["HeadFileName"].ToString();
                    BodyImage.ImageUrl = ImageLibrary + BodyImageName;
                    HeadImage.ImageUrl = ImageLibrary + HeaderImageName;
                }
                else
                {
                    lblErrorMessage.Text = Category + " Not Found";
                }
            }
            else
            {
                lblErrorMessage.Text = Category + " Not Found";
            }
        }
        else
        {
            BodyImage.Visible = false;
            HeadImage.Visible = false;
        }
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        

    }

}
