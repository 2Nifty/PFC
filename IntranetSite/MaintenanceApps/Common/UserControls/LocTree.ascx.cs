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
using PFC.Intranet.MaintenanceApps;

public partial class LocTree : System.Web.UI.UserControl
{
    RepMasterBl RepMasterBl = new RepMasterBl();

    public string SelectedNode
    {
        set
        {
            SetSelectedNode(value);
        }
    }

    public string LocBind
    {
        set
        {
            ViewState["Value"] = value;
            BindLoc();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindLoc();
        }
    }

    public void BindLoc()
    {
        try
        {
            string whereCondition = "1=1";
            MenuFrameTV.Nodes.Clear();

            DataTable dsDetails = RepMasterBl.LocTree(whereCondition);

            if (dsDetails != null && dsDetails.Rows.Count > 0)
            {
                TreeNode tvRep = new TreeNode("All Locs ", "Locs");

                MenuFrameTV.Nodes.Add(tvRep);
                tvRep.SelectAction = TreeNodeSelectAction.Expand;

                DataTable dt = dsDetails.Copy();

                DataTable dtLoc = dsDetails.DefaultView.ToTable(true, "LocNode", "LocationNo");

                foreach (DataRow drow in dtLoc.Rows)
                {
                   TreeNode tvLocNode = new TreeNode(drow["LocNode"].ToString(), drow["LocNode"].ToString());

                    tvRep.ChildNodes.Add(tvLocNode);
                    tvLocNode.SelectAction = TreeNodeSelectAction.Expand;

                    dt.DefaultView.RowFilter = "LocationNo='" + drow["LocationNo"].ToString() + "'";
                    DataTable dtRep = dt.DefaultView.ToTable();

                    if (dtRep != null && dtRep.Rows.Count > 0)
                    {
                        foreach (DataRow drow1 in dtRep.Rows)
                        {
                            TreeNode tvRepNode = new TreeNode("<table cellpadding=0 cellspacing=0 border=0><tr><td style=\"width:auto;cursor:hand;\" onclick=\"javascript:return GetRep('" + drow1["RepNode"].ToString() + "','" + drow1["RepNo"].ToString() + "');\" >" + drow1["RepNode"].ToString() + "</td></font></td></tr></table>", drow1["RepNode"].ToString());
                            //TreeNode tvRepNode = new TreeNode(drow1["RepNode"].ToString(), drow1["RepNode"].ToString());
                            tvLocNode.ChildNodes.Add(tvRepNode);
                            tvRepNode.SelectAction = TreeNodeSelectAction.Expand;
                        }
                    }
                }
            }
        }
        catch (Exception ex) { }
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
                {
                    tn.Selected = true;
                    tn.Expand();
                    break;
                }
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
                    tn.Parent.Expand();
                    tn.ExpandAll();
                    break;

                }
                else
                    CheckChildNode(tn, nodeValue);
            }
        }
        catch (Exception ex) { }
    }
}