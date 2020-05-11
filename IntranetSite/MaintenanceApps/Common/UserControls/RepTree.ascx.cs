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

public partial class RepTree : System.Web.UI.UserControl
{
    RepMasterBl RepMasterBl = new RepMasterBl();
   
    public string SelectedNode
    {
        set
        {
            SetSelectedNode(value);
        }
    }

    public string filterRepName
    {
        set 
        {             
            ViewState["filterRepName"] = value;
            BindRep();

            UpdatePanel pnl = Page.FindControl("upnlTree") as UpdatePanel;
            pnl.Update();
        }
    }

    public string filterRepNo
    {
        set
        {   
            ViewState["filterRepNo"] = value;
            BindRep();

            UpdatePanel pnl = Page.FindControl("upnlTree") as UpdatePanel;
            pnl.Update();
        }
    }

    //public string RepBind
    //{
    //    set
    //    {
    //        ViewState["Value"] = value;
    //        BindRep();
    //    }
    //}

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRep();
        }
    }

    public void BindRep()
    {
        try
        {
            string whereCondition = "1=1";
            MenuFrameTV.Nodes.Clear();
            if (ViewState["filterRepName"] != null && ViewState["filterRepName"].ToString() != "")
                whereCondition = whereCondition + " AND Rep.RepName LIKE '%" + ViewState["filterRepName"].ToString() + "%'";

            if (ViewState["filterRepNo"] != null && ViewState["filterRepNo"].ToString() != "")
                whereCondition = whereCondition + " AND Rep.RepNo LIKE '%" + ViewState["filterRepNo"].ToString() + "%'";

            DataTable dsDetails = RepMasterBl.RepTree(whereCondition);

            if (dsDetails != null && dsDetails.Rows.Count > 0)
            {
                TreeNode tvRep;

                if ((ViewState["filterRepName"] != null && ViewState["filterRepName"].ToString() != "") ||
                    (ViewState["filterRepNo"] != null && ViewState["filterRepNo"].ToString() != ""))
                {
                    tvRep = new TreeNode("Filtered Reps", "Reps");
                }
                else
                {
                    tvRep = new TreeNode("All Reps", "Reps");
                   
                }

                MenuFrameTV.Nodes.Add(tvRep);
                tvRep.SelectAction = TreeNodeSelectAction.Expand;

                DataTable dtRep = dsDetails.DefaultView.ToTable(true, "RepNode", "RepNo");
               
                
                foreach (DataRow drow in dtRep.Rows)
                {
                    TreeNode tvRepNode = new TreeNode("<table cellpadding=0 cellspacing=0 border=0><tr><td style=\"width:auto;cursor:hand;\" onclick=\"javascript:return GetRep('" + drow["RepNode"].ToString() + "','" + drow["RepNo"].ToString() + "');\" >" + drow["RepNode"].ToString() + "</td></font></td></tr></table>", drow["RepNode"].ToString());
                    //TreeNode tvRepNode = new TreeNode(drow["RepNode"].ToString(), drow["RepNode"].ToString());

                    tvRep.ChildNodes.Add(tvRepNode);
                    tvRepNode.SelectAction = TreeNodeSelectAction.Expand;
                }

                if ((ViewState["filterRepName"] != null && ViewState["filterRepName"].ToString() != "") ||
                    (ViewState["filterRepNo"] != null && ViewState["filterRepNo"].ToString() != ""))
                {
                    MenuFrameTV.Nodes[0].ExpandAll();
                    MenuFrameTV.Nodes[0].ChildNodes[0].Selected = true;
                }
            }
            ViewState["filterRepName"] = "";
            ViewState["filterRepNo"] = "";
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
