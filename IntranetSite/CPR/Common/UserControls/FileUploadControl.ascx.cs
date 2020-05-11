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
using System.IO;

public partial class FileUploadControl : System.Web.UI.UserControl
{

    #region Variable
    public string fileName = String.Empty;
    public string path = String.Empty;
    public string newPath = String.Empty;
    public Stream fStream = Stream.Null;
    private string _mapPath = String.Empty; 
    #endregion

    #region Property
    /// <summary>
    /// Map Path Property
    /// </summary>
    public string MapPath
    {
        get
        {
            if (String.IsNullOrEmpty(_mapPath))
                return Server.MapPath("");
            else
                return _mapPath;
        }
        set { _mapPath = value; }
    }
    public string FileName
    {
        get
        {
            return fileName; 
        }
       
    }
    public Stream FileContent
    {
        get
        {
            Stream _file = ViewState["FileStream"] as Stream;
            return fStream;
        }

    }
    bool _hasFile;
    public bool HasFile
    {
        get
        {
            return _hasFile;//Convert.ToBoolean(ViewState["HasFile"]);
        }

    }


    #endregion

    
    #region Event Handlers
    /// <summary>
    /// Page Load Event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        confirmMsg.Visible = false;

        //if (IsPostBack)
        //{
        //    if (hidFileUpload.HasFile)
        //    {
        //        ViewState["FileName"] = System.IO.Path.GetFileName(hidFileUpload.PostedFile.FileName);
        //        ViewState["FileStream"] = hidFileUpload.FileContent;
        //        ViewState["HasFile"] = hidFileUpload.HasFile;
               
        //    }
        //}
        //hidFileUpload.Style.Add(HtmlTextWriterStyle.Display, "none");
            //ibtnBrowse.Attributes.Add("onclick", "javascript:" + hidFileUpload.ClientID + ".click();return false;");
            //hidFileUpload.Attributes.Add("onchange", "javascript:document.getElementById('" + txtFilePath.ClientID + "').value =this.value;return false;");
       
    }
    /// <summary>
    /// Upload button event handlers
    /// </summary>
    /// <param name="sender">object</param>
    /// <param name="e">Event Arg</param>
    protected void ibtnUpload_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            fileName = System.IO.Path.GetFileName(txtFilePath.Value);

            //newPath = MapPath + "\\" + fileName;
            fStream = File.OpenRead(txtFilePath.Value);
            _hasFile = true;
            WriteStream();
            confirmMsg.Text = fileName + " has been successfully uploaded";
            confirmMsg.Visible = true;
        }
        catch (Exception ex)
        {
            _hasFile = false;
            confirmMsg.Text = "<strong>Please select a file by clicking the \"Browse\" button</strong><br/><br/>";
            confirmMsg.Text += "<span class=\"compilerError\">" + ex.Message + "</span>";
            confirmMsg.Visible = true;

        }
    } 
    #endregion

    #region Developer Methods
    /// <summary>
    /// File Write Method
    /// </summary>
    public void WriteStream()
    {

        fStream = File.OpenRead(txtFilePath.Value);

        byte[] buffer = new byte[fStream.Length];
        fStream.Read(buffer, 0, (int)fStream.Length);

        int len = (int)fStream.Length;

        fStream.Dispose();
        fStream.Close();

        string uploadPath = newPath;
        FileStream newfStream = File.Create(uploadPath);

        newfStream.Write(buffer, 0, len);
        newfStream.Dispose();
        newfStream.Close();
    }
    public DataTable ParseExcelFile()
    {
        DataTable dtLocal = new DataTable();
        dtLocal.Columns.Add("Item", typeof(String));
        dtLocal.Columns.Add("Cat", typeof(String));
        dtLocal.Columns.Add("Plate", typeof(String));
        dtLocal.Columns.Add("Var", typeof(String));
        int recctr = 0;
        if (Path.GetExtension(FileName).ToLower().ToString() == ".txt")
        {
            //Stream LoadingStream = ExcelFileUpload.FileContent();
            Stream st = FileContent;
            byte[] bytes = new byte[1000];
            int numBytesToRead = (int)st.Length;
            int numBytesRead = 0;
            //lblSuccessMessage.Text = "File length = " + numBytesToRead.ToString();
            string itemNo;
            while (numBytesToRead > 0)
            {
                // Read may return anything from 0 to numBytesToRead.
                int n = st.Read(bytes, 0, 16);
                //lblSuccessMessage.Text = lblSuccessMessage.Text.TrimEnd() + "," + n.ToString() + "," + System.Text.Encoding.Default.GetString(bytes);

                // The end of the file is reached.
                if (n == 0)
                    break;
                numBytesRead += n;
                numBytesToRead -= n;
                recctr++;
                itemNo = System.Text.Encoding.Default.GetString(bytes).TrimEnd();
                dtLocal.Rows.Add(new Object[] { itemNo.Substring(0, 14), itemNo.Substring(0, 5), itemNo.Substring(13, 1), itemNo.Substring(11, 3) });
                //lblErrorMessage.Text = System.Text.Encoding.Default.GetString(bytes);
            }
           // lblSuccessMessage.Text = "Excel file processed. " + dtLocal.Rows.Count.ToString() + " lines.";

        }
        else
        {
            //lblErrorMessage.Text = "File must be a single list of items in a tab delimited format with a .txt extension";
        }
        return dtLocal.DefaultView.ToTable();
    }
    #endregion


    protected void btnClick_Click(object sender, EventArgs e)
    {

    }
    protected void ibtnBrowse_Click(object sender, ImageClickEventArgs e)
    {

    }
}
