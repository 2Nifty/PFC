<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SiteMap.aspx.cs" Inherits="SystemFrameSet_SiteMap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Site Map</title>
    <LINK href="../common/stylesheet/Styles.css" type=text/css rel=stylesheet>
    <style>
    .SubMenu
    {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 11px;
        color: #CC0000;
    }
    
    </style>
    
    <script>
        function ChangeStatus(LabelID)
        {
            var tabID = document.getElementById(LabelID.replace("lblMenuTab","hidTabID")).value;
            if(parent.bodyframe!=null)
	        {
                if(tabID=="322")
		        {		
		            parent.document.getElementById("frameSet2").cols='0,*';
		            parent.bodyframe.location.href="UnderConstruction.aspx";
		        }
	        }
             
            if(tabID=="323")
            {    
                parent.document.getElementById("frameSet2").cols='0,*';
                window.open('http://www.companycasuals.com/porteousfastener/start.jsp', '', '',"");        
            }
            else if(tabID =="326")
            {
                parent.document.getElementById("frameSet2").cols='0,*';
                window.open('http://www.porteousfastener.com', '',' ',"");        
            }
            else if(tabID=="327")
            {
                parent.document.getElementById("frameSet2").cols='0,*';
                window.open('http://www.porteousfastener.com/locations/locations.htm', '', '',"");        
            }
            else
            {   
                if(parent.mainmenus!=null)
				    parent.mainmenus.location.href="LeftFrame.aspx?TabID="+tabID;	
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table cellSpacing=0 cellPadding=0 width="100%" border=0>
                <tr>
                <td class=PageHead colspan="3" valign=middle>
                    <span class=BannerText >Site Map </span>                    
                </td>
            </tr>
                
                <tr>
                    <td class=LoginPageBk width="30%" valign=top>
                        <asp:DataList ID=dlMenuTab runat=server  RepeatColumns=1 OnItemDataBound="dlMenuTab_ItemDataBound" RepeatDirection="Horizontal">
                        <ItemStyle VerticalAlign=Top />
                            <ItemTemplate>
                                <table cellpadding=0 cellspacing=0 width=325 align="left" >
                                    <tr align=left valign=Top >
                                        <td width="35"><img src="../Common/Images/mainlk_bullet.gif" /></td>
                                        <td align="left"><strong><asp:Label runat=server ID=lblMenuTab style="cursor:hand;" Text='<%#DataBinder.Eval(Container,"DataItem.Name") %>' onclick="javascript:ChangeStatus(this.id);"></asp:Label></strong><asp:HiddenField ID=hidTabID Value='<%#DataBinder.Eval(Container,"DataItem.TabID") %>' runat=server/></td>
                                    </tr>
                                    <tr >
                                        <td></td>
                                        <td align="left">
                                            <asp:TreeView  ID="MenuFrameTV" runat=server Width="100%" ExpandImageUrl="~/Images/mainlk_bullet.gif" CollapseImageUrl="~/Images/mainlk_bullet.gif" LeafNodeStyle-ImageUrl="~/Images/sublk_bullet.gif" ExpandDepth="0"  RootNodeStyle-Font-Bold=true RootNodeStyle-CssClass=SubMenu>
						                      <hovernodestyle backcolor="#E0F0FF" />
						                      <leafnodestyle cssclass=SubMenu />
						                      <parentnodestyle cssclass=mainmnu_lk1/>
						                      <RootNodeStyle  VerticalPadding=8px />
						                     </asp:TreeView>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                   <td class=LoginPageBk width="30%" valign=top>
                        <asp:DataList ID=dlMenuTab1 runat=server RepeatColumns=1 OnItemDataBound="dlMenuTab_ItemDataBound" RepeatDirection="Horizontal">
                        <ItemStyle VerticalAlign=Top />
                            <ItemTemplate>
                                <table cellpadding=0 cellspacing=0 width=325 align="left" >
                                    <tr align=left valign=Top >
                                        <td width="35"><img src="../Common/Images/mainlk_bullet.gif" /></td>
                                        <td align="left"><strong><asp:Label runat=server ID=lblMenuTab style="cursor:hand;" Text='<%#DataBinder.Eval(Container,"DataItem.Name") %>' onclick="javascript:ChangeStatus(this.id);"></asp:Label></strong><asp:HiddenField ID=hidTabID Value='<%#DataBinder.Eval(Container,"DataItem.TabID") %>' runat=server/></td>
                                    </tr>
                                    <tr >
                                        <td></td>
                                        <td align="left">
                                            <asp:TreeView ID="MenuFrameTV" runat=server Width="100%" ExpandImageUrl="~/Images/mainlk_bullet.gif" CollapseImageUrl="~/Images/mainlk_bullet.gif" LeafNodeStyle-ImageUrl="~/Images/sublk_bullet.gif" ExpandDepth="0"  RootNodeStyle-Font-Bold=true RootNodeStyle-CssClass=SubMenu>
						                      <hovernodestyle backcolor="#E0F0FF" />
						                      <leafnodestyle cssclass=SubMenu />
						                      <parentnodestyle cssclass=mainmnu_lk1/>
						                      <RootNodeStyle  VerticalPadding=8px />
						                     </asp:TreeView>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                    <td class=LoginPageBk width="30%" valign=top>
                        <asp:DataList ID=dlMenuTab2 runat=server RepeatColumns=1 OnItemDataBound="dlMenuTab_ItemDataBound" RepeatDirection="Horizontal">
                        <ItemStyle VerticalAlign=Top />
                            <ItemTemplate>
                                <table cellpadding=0 cellspacing=0 width=325 align="left" >
                                    <tr align=left valign=Top >
                                        <td width="35"><img src="../Common/Images/mainlk_bullet.gif" /></td>
                                        <td align="left"><strong><asp:Label runat=server ID=lblMenuTab style="cursor:hand;" Text='<%#DataBinder.Eval(Container,"DataItem.Name") %>' onclick="javascript:ChangeStatus(this.id);"></asp:Label></strong><asp:HiddenField ID=hidTabID Value='<%#DataBinder.Eval(Container,"DataItem.TabID") %>' runat=server/></td>
                                    </tr>
                                    <tr >
                                        <td></td>
                                        <td align="left">
                                            <asp:TreeView ID="MenuFrameTV" runat=server Width="100%" ExpandImageUrl="~/Images/mainlk_bullet.gif" CollapseImageUrl="~/Images/mainlk_bullet.gif" LeafNodeStyle-ImageUrl="~/Images/sublk_bullet.gif" ExpandDepth="0"  RootNodeStyle-Font-Bold=true RootNodeStyle-CssClass=SubMenu>
						                      <hovernodestyle backcolor="#E0F0FF" />
						                      <leafnodestyle cssclass=SubMenu />
						                      <parentnodestyle cssclass=mainmnu_lk1/>
						                      <RootNodeStyle  VerticalPadding=8px />
						                     </asp:TreeView>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                </tr>
                
            </table>
        </div>
    </form>
</body>
</html>
