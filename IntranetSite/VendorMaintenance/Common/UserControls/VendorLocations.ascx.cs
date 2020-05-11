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

namespace PFC.Intranet.VendorMaintenance
{
    public partial class VendorLocation : System.Web.UI.UserControl
    {
        public string _mode = "";
        public string _vendorNo = "";
        DataSet dsDetails = new DataSet();
        VendorDetailLayer vendorDetails = new VendorDetailLayer();

        #region Property Bags

        public String Mode
        {
            get { return _mode; }
            set
            {
                _mode = value;
                BindLocationDetails(hidVendor.Value);
            }
        }

        public string VendorNumber
        {
            get
            {
                return hidVendor.Value;
            }
            set
            {
                hidVendor.Value = value;
            }
        }



        public string SelectNode
        {
            set
            {
                SetSelectedNode(value);
            }
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
        public void BindLocationDetails(string vendorNumber)
        {
            try
            {
                MenuFrameTV.Nodes.Clear();
                DataSet dsVend = vendorDetails.GetDataToDateset("VendorMaster", "Code+' - '+VendNo", "pVendMstrID="+hidVendor.Value.Trim());
               
                if (dsVend != null && dsVend.Tables[0].Rows.Count > 0)
                {
                    dsDetails = vendorDetails.GetTreeviewDetails(hidVendor.Value.Trim());

                    TreeNode tvCaption = new TreeNode(dsVend.Tables[0].Rows[0][0].ToString().Trim(), dsVend.Tables[0].Rows[0][0].ToString().Trim());
                    MenuFrameTV.Nodes.Add(tvCaption);
                  
                    tvCaption.SelectAction = TreeNodeSelectAction.Expand;

                    TreeNode tvBuyFrom = new TreeNode("<div  onclick=\"javasctip:BindDetails('0','BF','Add');\">Buy From &nbsp;&nbsp; <span style=\"color:red;\">New</span></div>","Buy From");
                    tvCaption.ChildNodes.Add(tvBuyFrom);
                    tvBuyFrom.SelectAction = TreeNodeSelectAction.Expand;

                    if (dsDetails != null && dsDetails.Tables[0].Rows.Count>0)
                    {
                        DataTable dtShipFrom = dsDetails.Tables[1].Copy();
                        foreach (DataRow dr in dsDetails.Tables[0].Rows)
                        {
                            TreeNode tvBuy = new TreeNode("<div style=\"cursor:hand;\" onclick=\"javasctip:BindDetails('" + dr["ID"].ToString().Trim() + "','BF','Edit');\">" + dr["LocationName"].ToString().Trim() + "</div>", dr["LocationName"].ToString().Trim());
                            tvBuyFrom.ChildNodes.Add(tvBuy);
                            tvBuy.SelectAction = TreeNodeSelectAction.Expand;

                            if (dtShipFrom != null && dtShipFrom.Rows.Count > 0)
                            {
                                dtShipFrom.DefaultView.RowFilter = "fBuyFromAddrID=" + dr["ID"].ToString().Trim();
                                DataTable dtCurrent = dtShipFrom.DefaultView.ToTable();
                                foreach (DataRow drow in dtCurrent.Rows)
                                {
                                    TreeNode tvShip = new TreeNode("<div style=\"cursor:hand;\" onclick=\"javasctip:BindDetails('" + drow["fBuyFromAddrID"].ToString().Trim() + "~" + drow["ID"].ToString().Trim() + "','SF','Edit');\">" + drow["LocationName"].ToString().Trim() + "</div>", drow["LocationName"].ToString().Trim());
                                    tvBuy.ChildNodes.Add(tvShip);
                                    tvShip.SelectAction = TreeNodeSelectAction.Expand;
                                }
                            }

                            TreeNode tvNewShip = new TreeNode("<div style=\"color:red;cursor:Hand;\" onclick=\"javasctip:BindDetails('" + dr["ID"].ToString().Trim() + "','SF','Add');\">New Ship From</div>", dr["LocationName"].ToString().Trim()+"ShipNew");
                            tvBuy.ChildNodes.Add(tvNewShip);
                            tvNewShip.SelectAction = TreeNodeSelectAction.Expand;
                        }
                    }
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
