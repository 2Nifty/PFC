<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemFamily.ascx.cs" Inherits="PFC.SalesPricing.ItemFamily" %>

<table cellspacing="0" cellpadding="0" id="mainTable" height=100%>
<tr>
<td valign="top" class="LeftBg">
<table id="LeftMenuContainer" width="200" border="0" cellspacing="0" >
      <tr>
        <td class="ShowHideBarBk" id="HideLabel">
        <div align="right">Click to hide family menu</div></td>
        <td width="1" class="ShowHideBarBk"><div align="right" id="SHButton"><img ID="Hide" style="cursor:hand" src="Common/Images/HidButton.gif" width="22" height="21" onclick="ShowHide(this)" onload="LoadSideBar()"  ></div></td>
      </tr>
      <tr valign="top">   
        </tr>
    </table>
    <table id="LeftMenu" width="100%"  border="0" cellspacing="0" cellpadding="0">
       <tr valign="top">
           <td valign="top" >
                <div style="overflow-y:auto;height:260px;" id=divItemFamily class=Sbar>
                    <asp:DataGrid ID=dgMenu ShowHeader=false runat=server Width=91% GridLines=Horizontal AutoGenerateColumns=false BorderWidth=1 OnItemDataBound="dgMenu_ItemDataBound" OnItemCommand="dgMenu_ItemCommand">
                    <ItemStyle CssClass=leftMenuItemBorder  BorderColor=Blue Height=25px />
                        <Columns>
                            <asp:TemplateColumn>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" style="text-decoration:none;" CssClass="link" CausesValidation=false Text='<%#DataBinder.Eval(Container,"DataItem.ChapterDesc") %>' runat=server CommandName="ItemBuilder"></asp:LinkButton>
                                    <asp:HiddenField ID=hidValue Value='<%#DataBinder.Eval(Container,"DataItem.CHAPTER") %>' runat=server />
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                    </asp:DataGrid>   
                </div>
           </td>       
       </tr>		 
      </table>
</td>
</tr>

</table>


