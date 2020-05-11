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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;

public partial class UnReceivedItemsFrm : System.Web.UI.Page
{
    Warehouse warehouse = new Warehouse();

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(UnReceivedItemsFrm));

        if (!Page.IsPostBack)
        {
            if (Session["UserName"] == null)
                Response.Redirect("WHLogin.aspx");
            
            txtPackLabel.Text = "HTI";
            txtBinLabel.Focus();
        }
    }

    protected void btnClear_Click(object sender, ImageClickEventArgs e)
    {
        txtBinLabel.Text = "";
        txtDesc.Text = "";
        txtItemNo.Text = "";
        txtQty.Text = "";
        txtPcsPer.Text = "";
        scmHTIItems.SetFocus(txtBinLabel);
        
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (hidMode.Value == "update")
            {
                string columnValues = "ItemNo='" + txtItemNo.Text.Trim().Replace("'", "''") + "'"
                                 + ",ItemDesc='" + txtDesc.Text.Trim().Replace("'", "''") + "'"
                                 + ",BinLabel='" + txtBinLabel.Text.Trim().Replace("'", "''") + "'"
                                 + ",Location='" + Session["BranchID"].ToString() + "'"
                                 + ",Quantity='" + (txtQty.Text.Trim() == "" ? "0" : txtQty.Text.Trim()) + "'"
                                 + ",PiecesPerQuantity='" + (txtPcsPer.Text.Trim() == "" ? "0" : txtPcsPer.Text.Trim()) + "'"
                                 + ",PackagedForLabel='" + txtPackLabel.Text.Replace("'", "''") + "'"
                                 + ",ChangeID='" + Session["UserName"].ToString() + "'"
                                 + ",ChangeDt='" + DateTime.Now.ToString() + "'";

                SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOEUpdate",
                                   new SqlParameter("@tableName", "[HTIBranchItemDetail]"),
                                   new SqlParameter("@columnNames", columnValues),
                                   new SqlParameter("@columnValues", "pHTIBranchItemDetailID=" + hidPkId.Value ));
            }
            else
            {
                string columnName = "ItemNo"
                                  + ",ItemDesc"
                                  + ",BinLabel"
                                  + ",Location"
                                  + ",Quantity"
                                  + ",PiecesPerQuantity"
                                  + ",PackagedForLabel"
                                  + ",EntryID"
                                  + ",EntryDt";

                string columnValue = "'" + txtItemNo.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtDesc.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtBinLabel.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + Session["BranchID"].ToString() + "'," +
                                    "'" + (txtQty.Text.Trim() == "" ? "0" : txtQty.Text.Trim()) + "'," +
                                    "'" + (txtPcsPer.Text.Trim() == "" ? "0" : txtPcsPer.Text.Trim()) + "'," +
                                    "'" + txtPackLabel.Text.Replace("'", "''") + "'," +
                                    "'" + Session["UserName"] + "'," +
                                    "'" + DateTime.Now.ToString() + "'";

                SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOEInsert",
                                   new SqlParameter("@tableName", "[HTIBranchItemDetail]"),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@columnValues", columnValue));

               
            }

            btnClear_Click(btnSave, new ImageClickEventArgs(0, 0));
            txtBinLabel.Focus();
            //lblMessage.Text = "Record Added";            
        }
        catch (Exception ex)
        {            
            throw ex;
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string[] GetGTIItemDesc(string itemNo,string binLabel)
    {
        string[] _itemInfo = new string[20];
        _itemInfo[0] = "add";
        _itemInfo[1] = "";

        // First Check if the item is already exist in the table 
        // if item not exist in the HTI table then try to find the Description
        string isExistCmd = "Select pHTIBranchItemDetailID" +
                            "       ,ItemDesc " +
                            "       ,Cast(Quantity as decimal(18,0)) as Quantity" +
                            "       ,Cast(PiecesPerQuantity as decimal(18,0)) as PiecesPerQuantity" +
                            "       ,PackagedForLabel " +
                            "From   HTIBranchItemDetail " +
                            "Where  ItemNo ='" + itemNo + "'" +
                            "       and BinLabel='" + binLabel + "'" +
                            "       and Location='" + Session["BranchID"].ToString() + "'";
        DataTable dsExistingRecord = PFCDBHelper.ExecuteERPSelectQuery(isExistCmd);
        if (dsExistingRecord != null && dsExistingRecord.Rows.Count > 0)
        {
            _itemInfo[0] = "update"; // Mode
            _itemInfo[1] = dsExistingRecord.Rows[0]["ItemDesc"].ToString();
            _itemInfo[2] = dsExistingRecord.Rows[0]["Quantity"].ToString();
            _itemInfo[3] = dsExistingRecord.Rows[0]["PiecesPerQuantity"].ToString();
            _itemInfo[4] = dsExistingRecord.Rows[0]["PackagedForLabel"].ToString();
            _itemInfo[5] = dsExistingRecord.Rows[0]["pHTIBranchItemDetailID"].ToString();
        }
        else
        {
            
            string getDescCmd = "Select	AliasDesc " +
                                "From	ItemAlias (NOLOCK)" +
                                "Where	AliasWhseNo='HTI'" +
                                "       And OrganizationNo='000000'" +
                                "       And AliasItemNo='" + itemNo + "'";
            DataTable dtResult = PFCDBHelper.ExecuteERPSelectQuery(getDescCmd);
            if (dtResult != null && dtResult.Rows.Count > 0)                
                _itemInfo[1] = dtResult.Rows[0]["AliasDesc"].ToString();
            
        }

        return _itemInfo;         
    }

   
}
