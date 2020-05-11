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

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.Maintenance
{
    public partial class Location : System.Web.UI.UserControl
    {
        public string _mode = "";
         
        DataSet dsDetails = new DataSet();
        CustomerMaintenance customerDetails = new CustomerMaintenance();

        #region Property Bags

        public String Mode
        {
            get { return _mode; }
            set
            {
                _mode = value;
                
            }
        }
        //public CustomerType CustType
        //{
        //    get
        //    {
        //        return (CustomerType) ViewState["CustomerType"];
        //    }
        //}
        public string BillToCustomerID
        {
            get
            {
                return hidCustomerID.Value;
            }
            set
            {
                hidCustomerID.Value = value;
                BindLocationDetails();
            }
        }



        public string SelectNode
        {
            set
            {
                SetSelectedNode(value);
            }
        }

        public CustomerType CustType
        {
            get { return (ViewState["CustomerType"] == null) ? CustomerType.BTST : (CustomerType)ViewState["CustomerType"]; }
             
        }
        

        #endregion

        #region Control Events

        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        /// <summary>
        /// Function to bind the location details
        /// </summary>
        /// <param name="vendorNumber"></param>
        public void BindLocationDetails()
        {
            try
            {
                MenuFrameTV.Nodes.Clear();
                DataSet dsCustomer = customerDetails.GetDataToDateset("CustomerMaster (NOLOCK) ", "'Code - '+CustNo as 'Name',CustNo", "pCustMstrID=" + BillToCustomerID);

                if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
                {
                    dsDetails = customerDetails.GetTreeviewDetails(dsCustomer.Tables[0].Rows[0]["CustNo"].ToString());

                    TreeNode tvCaption = new TreeNode(dsCustomer.Tables[0].Rows[0]["Name"].ToString().Trim(), dsCustomer.Tables[0].Rows[0]["Name"].ToString().Trim());
                    MenuFrameTV.Nodes.Add(tvCaption);

                    tvCaption.SelectAction = TreeNodeSelectAction.Expand;

                    TreeNode tvSoldTo = new TreeNode("<div  style=\"cursor:hand;\" onclick=\"javascript:BindDetails('0','ST','Add');\">Sold To &nbsp;&nbsp; <span style=\"color:red;\">" + ((Session["SecurityCode"].ToString().Trim() == "" || Session["CustomerLock"].ToString().Trim() == "L") ? "" : "New") + "</span></div>", "Sold To");
                    tvCaption.ChildNodes.Add(tvSoldTo);
                    tvSoldTo.SelectAction = TreeNodeSelectAction.Expand;

                    if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    {
                        MenuFrameTV.Style.Add(HtmlTextWriterStyle.Display, "");
                        //if (CustType == CustomerType.BTST)
                        //{
                        //    DataRow dr = dsDetails.Tables[0].NewRow();
                        //    dr[""]
                        //}
                        Session["SoldToAddressCount"] = dsDetails.Tables[0].Rows.Count.ToString();
                        DataTable dtShipTo = dsDetails.Tables[1].Copy();
                        foreach (DataRow dr in dsDetails.Tables[0].Rows)
                        {
                            TreeNode tvSold = new TreeNode("<div style=\"cursor:hand;\" onclick=\"javascript:BindDetails('" + dr["pCustMstrID"].ToString().Trim() + "','ST','Edit');\">" + dr["Name"].ToString().Trim() + "</div>", dr["Name"].ToString().Trim());
                            tvSoldTo.ChildNodes.Add(tvSold);
                            tvSold.SelectAction = TreeNodeSelectAction.Expand;

                            if (dtShipTo != null && dtShipTo.Rows.Count > 0)
                            {
                                dtShipTo.DefaultView.RowFilter = "fCustomerMasterID=" + dr["pCustMstrID"].ToString().Trim();
                                DataTable dtCurrent = dtShipTo.DefaultView.ToTable();
                                foreach (DataRow drow in dtCurrent.Rows)
                                {
                                    TreeNode tvShip = new TreeNode("<div style=\"cursor:hand;\" onclick=\"javascript:BindDetails('" + drow["pCustomerAddressID"].ToString().Trim() + "~" + drow["fCustomerMasterID"].ToString().Trim() + "','SH','Edit');\">" + dr["CustNo"].ToString() + " - " + drow["Name"].ToString().Trim() + "</div>", drow["Name"].ToString().Trim());
                                    tvSold.ChildNodes.Add(tvShip);
                                    tvShip.SelectAction = TreeNodeSelectAction.Expand;
                                }
                            }

                            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
                            {
                                TreeNode tvNewShip = new TreeNode("<div style=\"color:red;cursor:Hand;\" onclick=\"javascript:BindDetails('" + dr["pCustMstrID"].ToString().Trim() + "','SH','Add');\">New Ship To</div>", "New Ship To");
                                tvSold.ChildNodes.Add(tvNewShip);
                                tvNewShip.SelectAction = TreeNodeSelectAction.Expand; 
                            }
                            // }

                        }

                    }
                    else
                        Session["SoldToAddressCount"] = "0";
                }
                else
                {
                    MenuFrameTV.Style.Add(HtmlTextWriterStyle.Display, "none");
                }

            }
            catch (Exception ex) { }
        }

        protected void btnBindDetails_Click(object sender, EventArgs e)
        {

        }

        protected void btnExpand_Click(object sender, ImageClickEventArgs e)
        {
          MenuFrameTV.CollapseAll(); 
        }

        protected void btnCollapse_Click(object sender, ImageClickEventArgs e)
        {
             MenuFrameTV.ExpandAll();
        }

        /// <summary>
        /// Function to expand the Parent
        /// </summary>
        /// <param name="Node"></param>
        public void SetSelectedNode(string Node)
        {
            try
            {
                foreach (TreeNode tn in MenuFrameTV.Nodes)
                {
                    if (tn.Value.Trim() == Node.Trim())
                    { tn.Selected = true; break; }
                    else
                        CheckChildNode(tn, Node);
                }

            }
            catch (Exception ex) { }
        }

        /// <summary>
        /// function to expand the child node
        /// </summary>
        /// <param name="tnCheck"></param>
        /// <param name="nodeValue"></param>
        public void CheckChildNode(TreeNode tnCheck, string nodeValue)
        {
            try
            {

                foreach (TreeNode tn in tnCheck.ChildNodes)
                {
                    if (tn.Value.Trim() == nodeValue.Trim())
                    {
                        tn.Selected = true;
                        tn.Parent.ExpandAll();

                        if (tn.Parent.Parent != null)
                        {
                            tn.Parent.Parent.ExpandAll();
                            if (tn.Parent.Parent.Parent != null)
                            {
                                tn.Parent.Parent.ExpandAll();
                                tn.Parent.Parent.Parent.ExpandAll();
                            }
                        }
                        break;

                    }
                    else
                        CheckChildNode(tn, nodeValue);
                }
            }
            catch (Exception ex) { }
        }
        #endregion

        
    } 
}
