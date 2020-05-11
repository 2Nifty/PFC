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
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;


public partial class StandardComments : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    ddlBind ddlBind = new ddlBind();
    //ItemBuilderBuilder ItemBuilderBuilder = new ItemBuilderBuilder();

    DataTable dtCustPriceSched;

    int count;    
    private DataTable dtTablesData = new DataTable();
    ItemBuilder itemBuilder = new ItemBuilder();
    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string code = "";
    string connectionString = "";
    string custNumber = "";

    string PageMode = "";

    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
  

    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Visible = false;
        trNewContract.Visible = false;               
        
        if (!Page.IsPostBack)
        {
            string enterScript = "if(event.keyCode == 13) document.getElementById('" + btnPush.ClientID + "').click();";
            txtCustNo.Attributes.Add("onkeypress", enterScript);                    

            BindContractDDL();         
        
        }

        if (Request.QueryString["Mode"] != null && Request.QueryString["Mode"].ToLower() == "singleitem")
        {
            PageMode = Request.QueryString["Mode"].ToLower();           
        }            
     }
    

      protected void btnPush_Click(object sender, ImageClickEventArgs e)
    {
        DataTable dupRep;
    
        if (rdoNewContract.Checked != true)    //if new contract radio button is not check then do this...
        {
            string uploadOption = (rdoUpdate.Checked == true ? "U" : "R");
            custNumber = ddlContract.SelectedValue.ToString();
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "LoadPage", "window.open('Reference.aspx?CustomerNumber=" + custNumber + "&UserName=" + Session["UserName"].ToString().Trim() + "&UploadOption=" + uploadOption + "','ContractLoader','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no')", true);
            DisplaStatusMessage("Contract Found", "success");
                      
        }
        else
        {
            if ((string.IsNullOrEmpty(txtCustNo.Text.ToString())) || (txtCustNo.Text == " "))
            {
                DisplaStatusMessage("Please enter a valid Customer Name cannot be empty", "fail");
                MyScript.SetFocus(txtCustNo);
                trNewContract.Visible = true;
            }
            else
            {
                ViewState["Mode"] = "Dupp";
                dupRep = DupRep(txtCustNo.Text);
                if (dupRep.Rows.Count > 0)
                {                    
                    DisplaStatusMessage("Customer Contract " + txtCustNo.Text + " already exists on Contract ", "fail");

                }               
                else
                {
                    //string newContract = txtCustNo.Text; 
                    string newContract = txtCustNo.Text.ToString().ToUpper();
   
                    DisplaStatusMessage("Are you sure you want to create a new contract?", "fail");     //outstanding fix to have a box popout to ask if user agrees to create new contract
                    //ViewState["Mode"] = "Add";                   
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "LoadPage", "window.open('Reference.aspx?CustomerNumber=" + newContract + "&UploadOption=N','Reference','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no')", true);
                    AddCustPriceSched();    //adds new contract name to ListDetail                  
                }              
                trNewContract.Visible = true;     
            }
        }
    }
       

    #region Control Events
    protected void rdoReplace_CheckedChanged(object sender, EventArgs e)
    {
        lblCustomerNo.Visible = false;
        txtCustNo.Visible = false;
        ddlContract.Visible = true;
        lblExistingContract.Visible = true;
        trNewContract.Visible = false;
        ViewState["Mode"] = "Replace";
    }

    protected void rdoUpdate_CheckedChanged(object sender, EventArgs e)
    {
        lblCustomerNo.Visible = false;
        txtCustNo.Visible = false;
        ddlContract.Visible = true;
        lblExistingContract.Visible = true;
        trNewContract.Visible = false;
        txtCustNo.Text = "";                     
    }

    protected void rdoNewContract_CheckedChanged(object sender, EventArgs e)
    {
        ddlContract.Visible = false;
        lblExistingContract.Visible = false;    
        lblCustomerNo.Visible = true;
        txtCustNo.Visible = true;
        trNewContract.Visible = true;
        txtCustNo.Text = "";      
        MyScript.SetFocus(txtCustNo);
    }
       
    #endregion


    private void AddCustPriceSched()     //adds new contract name to ListDetail 
    {   
            //Add the record to the Database
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pCustomerContractLoader",
                                                        new SqlParameter("@Mode", "Add"),
                                                        new SqlParameter("@CustNo", txtCustNo.Text.Trim().ToUpper()), 
                                                        new SqlParameter("@ItemNo", ""),
                                                        new SqlParameter("@AltSellPrice", "0"),
                                                        new SqlParameter("@ContractPrice", "0"),
                                                        new SqlParameter("@UserName", Session["UserName"].ToString())
                                                       );
            
            //Add the record to the DataTable
            if (dsResult.Tables[0].DefaultView.ToTable().Rows.Count > 0)
            {
                dtCustPriceSched = (DataTable)Session["dtCustPrice"];               
            }            

            DisplaStatusMessage("New Contract Created ", "success");

            return;            
            
    }
    

    //
    //Check RepMaster for duplicate RepNo
    //
    public DataTable DupRep(string _custNo)
    {
        try
        {
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pCustomerContractLoader",
                                                       new SqlParameter("@Mode", "Dupp"),
                                                       new SqlParameter("@CustNo", _custNo),
                                                       new SqlParameter("@ItemNo", ""),
                                                       new SqlParameter("@AltSellPrice", "0"),
                                                       new SqlParameter("@ContractPrice", "0"),
                                                       new SqlParameter("@UserID", "")
                                                      );

            return dsResult.Tables[1].DefaultView.ToTable();
        }
        catch (Exception ex)
        { throw ex; }
    }
        

    private void DisplaStatusMessage(string message, string messageType) 
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
        pnlProgress.Update();
    }

    private void BindContractDDL()
    {
        string tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
        string columnName = "LD.ListValue, LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc ";
        string whereClause = "LM.ListName = 'CustContractSchd' and ListDtlDesc not in('D  Contract','Discount of List') AND LD.fListMasterID = LM.pListMasterID ORDER BY SequenceNo ASC";

        DataSet dsType = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                   new SqlParameter("@tableName", tableName),
                                   new SqlParameter("@columnNames", columnName),
                                   new SqlParameter("@whereClause", whereClause));
        
        ddlBind.ddlBindControl(ddlContract, dsType.Tables[0], "ListValue", "ListDesc", "", "");
    }

   }



