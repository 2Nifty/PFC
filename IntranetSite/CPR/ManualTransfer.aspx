<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="ManualTransfer.aspx.cs"
    Inherits="ManualTransfer" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Manual Transfer</title>
    <link href="Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript">
        var CommitValid = true;
        var ErrCtl = "";
        var FocusCtl = "";
        function pageUnload() 
        {
        }

        function ClosePage()
        {
            var msg = "MANUAL TRANSFER LOCK IN CONFIRMATION\n\n" +
                "Press OK to Lock In transfers you have Accepted.\n" +
                "      ALL the transfers for All items will be Locked In.\n" +
                "      Transfers will be created automatically.\n\n" +
                "Press Cancel to NOT Lock In the transfers.\n" + 
                "      You will be able to return to this page and lock them in next time.\n";
            if (confirm(msg))
            {
                LockXfers();
            }
            window.close();	
        }

        function AdjustHeight()
        {
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel onload="AdjustHeight();"
            yh = yh - 155;
            xw = xw - 5
            // size the grid
            var DetailGridPanel = $get("div1");
            DetailGridPanel.style.height = yh;  
            var OtherGridPanel = $get("div2");
            OtherGridPanel.style.height = yh - 146; 
        }
       
        function ZItem(itemNo)
        {
            var section="";
            var completeItem=0;
            event.keyCode=0;
            // process ZItem
            //alert(itemNo.split('-').length);
            switch(itemNo.split('-').length)
            {
            case 1:
                // this is actually taken care of by the item alias search
                itemNo = "00000" + itemNo;
                itemNo = itemNo.substr(itemNo.length-5,5);
                $get("txtItemNo").value=itemNo+"-";  
                break;
            case 2:
                // close if they are entering an empty part
                if (itemNo.split('-')[0] == "00000") {ClosePage()};
                section = "0000" + itemNo.split('-')[1];
                section = section.substr(section.length-4,4);
                $get("txtItemNo").value=itemNo.split('-')[0]+"-"+section+"-";  
                break;
            case 3:
                section = "000" + itemNo.split('-')[2];
                section = section.substr(section.length-3,3);
                $get("txtItemNo").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                completeItem=1;
                break;
            }
            if (completeItem==1) $get("btnFindItem").click();
            return false;
        }
        
        function SetShipFrom(ctl)
        {
            if (ctl.parentNode.tagName == "TD")
            {
                var LineParent = ctl.parentNode.parentNode;
            }
            else
            {
                var LineParent = ctl.parentNode.parentNode.parentNode;
            }
            $get("lblShippingLoc").innerHTML = ctl.innerHTML;
            $get("hidShippingLoc").value = ctl.innerHTML;
            CommitValid = true;
            $get("btnUpdXfers").click();
/*
            RefreshCommitted();
            var FromLoc = ctl.innerHTML;
            var status = ManualTransfer.GetBrQtys(ctl.innerHTML).value;
            
            if (status.substring(0,2) == "!!")
            {
                ctl.focus();
                document.getElementById('lblMessage').innerText = status;
                ErrCtl = ctl.id;
            }
            else
            {
                $get("lblOnHandExcessQty").innerHTML = status.split(':')[0];
                $get("lblCommittedQty").innerHTML = status.split(':')[1];
                $get("lblRemainingQty").innerHTML = status.split(':')[2];
                LineParent.childNodes[11].childNodes[0].style.display="none";
                LineParent.childNodes[11].childNodes[2].style.display="";
                LastCommited = LineParent.childNodes[11];
                LastAccum = LineParent.childNodes[10];
                ErrCtl = "";
            }
            */
            //alert(status);
        }

        function NavigateGrid(ctl)
        {
            if (!CommitValid)
            {
                event.keyCode=0;
                return false;
            }
            var ItemGrid = document.getElementById('dgItemDtl');
            if (ItemGrid != null)
            {
                var BrInputs = ItemGrid.getElementsByTagName("INPUT");
                for (var i = 0, il = BrInputs.length - 1; i < il; i++)
                {
                    // if we found our row, move to the next one
                    if (BrInputs[i].id == ctl.id)
                    {
                        if (i < il)
                        {
                            // jump to get over the hidden item numbers and non displayed inputs
                            if ((BrInputs[i + 1].type != 'hidden') && (BrInputs[i + 1].style.display != 'none')) 
                            {
                                BrInputs[i + 1].focus();
                                il = i;
                            }
                            else if ((i+1 < il) && (BrInputs[i + 2].type != 'hidden') && (BrInputs[i + 2].style.display != 'none'))  
                            {
                                BrInputs[i + 2].focus();
                                il = i;
                            }
                            else if ((i+2 < il) && (BrInputs[i + 3].type != 'hidden') && (BrInputs[i + 3].style.display != 'none'))  
                            {
                                BrInputs[i + 3].focus();
                                il = i;
                            }
                            else if ((i+3 < il) && (BrInputs[i + 4].type != 'hidden') && (BrInputs[i + 4].style.display != 'none'))  
                            {
                                BrInputs[i + 4].focus();
                                il = i;
                            }
                            else if ((i+4 < il) && (BrInputs[i + 5].type != 'hidden') && (BrInputs[i + 5].style.display != 'none'))  
                            {
                                BrInputs[i + 5].focus();
                                il = i;
                            }
                            else if ((i+5 < il) && (BrInputs[i + 6].type != 'hidden') && (BrInputs[i + 6].style.display != 'none'))  
                            {
                                BrInputs[i + 6].focus();
                                il = i;
                            }
                        }
                        else
                        {
                            //document.getElementById('btnAccept').focus();
                        }
                    }
                }
            }
            event.keyCode=0;
            return false;                
            //alert(status);
        }
        
        function CommitQty(ctl)
        {
        /*"javascript:if ((!CommitValid)||(ErrCtl == this.id)){CommitValid = true;CommitQty(this);}"
            */
                $get("lblShippingLoc").innerHTML = $get("hidShippingLoc").value;
                //alert("1+"+FocusCtl);
                if (ctl.parentNode.tagName == "TD")
                {
                    var LineParent = ctl.parentNode.parentNode;
                }
                else
                {
                    var LineParent = ctl.parentNode.parentNode.parentNode;
                }
                var ToLoc = LineParent.childNodes[0].innerText;
                //var OnHandExcessQty = document.getElementById('lblOnHandExcessQty').innerText;
                // Update the field in the session data table
                var status = ManualTransfer.UpdCommitQty(ToLoc, $get("hidShippingLoc").value, $get('lblItemNo').innerHTML, ctl.value).value;
                document.getElementById('lblMessage').innerText = "";
                if (status.substring(0,2) != "OK")
                {
                    CommitValid = false;
                    //ctl.focus();
                    document.getElementById('lblMessage').innerText = status;
                    document.getElementById('btnAccept').style.display = "none";
                    ErrCtl = ctl.id;
                }
                else
                {
                    CommitValid = true;
                    //RefreshCommitted();
                    ErrCtl = "";
                    var tables = status.split('&');
                    var rows = tables[1].split('|');
                    if (rows.length == 1)
                    {
                        document.getElementById('lblOtherMsg').style.display = "";
                    }
                    else
                    {
                        document.getElementById('lblOtherMsg').style.display = "none";
                    }
                    RefreshXfers(rows);
                    var ItemGrid = document.getElementById('dgItemDtl');
                    var ItemRows = ItemGrid.rows;
                    var ItemLen = ItemRows.length;
                    var rows = tables[2].split('|');
                    var dataFrom = "";
                    dataFrom = rows[0].split(':')[0];
                    var dataQty = rows[0].split(':')[1];
                    for (i=1; i<ItemLen; i++)
                    {
                        var GridRow = ItemRows[i];
                        var GridFrom = "";
                        GridFrom = GridRow.childNodes[0].childNodes[0].innerHTML;
                        GridFrom = GridFrom.replace(" ","");
                        //alert(":"+GridFrom +":"+dataFrom + ":");
                        if (GridFrom == dataFrom)
                        {
                            var AccumCel = GridRow.childNodes[10].childNodes[0];                            
                            AccumCel.nodeValue = dataQty; 
                            var CurItemQty = document.getElementById('lblOnHandExcessQty').innerText;        
                            document.getElementById('lblCommittedQty').innerText = dataQty;
                            document.getElementById('CommitTot').innerText = dataQty;
                            //alert(CurCommitQty); 
                            var CurRemainQty = parseInt(CurItemQty, 10) - parseInt(dataQty, 10);
                            document.getElementById('lblRemainingQty').innerText = CurRemainQty;
                            
                        }
                        else
                        {
                        }
                    }
                }
                //alert(status);
            event.keyCode=0;
            return false;                
        }
        
        function AcceptXfers()
        {
            var status = ManualTransfer.UpdAccept($get("lblItemNo").innerHTML).value;
            if (status.substring(0,2) != "OK")
            {
                document.getElementById('lblMessage').innerText = status;
                document.getElementById('btnAccept').style.display = "none";
            }
            else
            {
                var tables = status.split('&');
                var rows = tables[1].split('|');
                RefreshXfers(rows);
            }
            /*
            */
        }
        
        function LockXfers()
        {
            var status = ManualTransfer.UpdLockIn().value;
            if (status != "OK")
            {
                alert(status);
            }
        }
        
        function RefreshXfers(xfers)
        {
            var XferGrid = document.getElementById('dgOther');
            var XferRows = XferGrid.rows;
            var XFerLen = XferRows.length - 1;
            for (i=0; i<xfers.length-1; i++)
            {
                var data = xfers[i].split(':');

                if (i < XFerLen)
                {
                    var GridRow = XferRows[i+1];
                    var FromCel = GridRow.childNodes[0].childNodes[0];                            
                    FromCel.nodeValue = data[0]; 
                    var ToCel = GridRow.childNodes[1].childNodes[0];                            
                    ToCel.nodeValue = data[1]; 
                    var QtyCel = GridRow.childNodes[2].childNodes[0];                            
                    QtyCel.nodeValue = data[2]; 
                    var AccptCel = GridRow.childNodes[3].childNodes[0];                            
                    AccptCel.nodeValue = data[3]; 
                    var UserCel = GridRow.childNodes[4].childNodes[0];                            
                    UserCel.nodeValue = data[4]; 
                }
                else
                {
                    var NewRow=XferGrid.insertRow(-1);
                    var FromCel=NewRow.insertCell(0);
                    var ToCel=NewRow.insertCell(1);
                    var QtyCel=NewRow.insertCell(2);
                    var AccptCel=NewRow.insertCell(3);
                    var UserCel=NewRow.insertCell(4);
                    
                    FromCel.style.textAlign="center";
                    ToCel.style.textAlign="center";
                    QtyCel.style.textAlign="right";
                    AccptCel.style.textAlign="center";
                    UserCel.style.textAlign="center";
                    
                    QtyCel.className = "Right2pxPadd";
                    FromCel.appendChild(document.createTextNode(data[0]));
                    ToCel.appendChild(document.createTextNode(data[1])); 
                    QtyCel.appendChild(document.createTextNode(data[2])); 
                    AccptCel.appendChild(document.createTextNode(data[3])); 
                    UserCel.appendChild(document.createTextNode(data[4])); 
                }
            }
            for (i=xfers.length-1; i<XFerLen; i++)
            {
                XferGrid.deleteRow(-1) 
            }
        
        }
        
        function RefreshCommitted()
        {
            // update the territory totals
            var CurCommitQty = "";
            var ItemGrid = document.getElementById('dgItemDtl');
            if (ItemGrid != null)
            {
                var TerrCommQty = 0;
                var TotCommQty = 0;
                var TerrAccumQty = 0;
                var TotAccumQty = 0;
                var BrRows = ItemGrid.rows;
                for (var i = 1, il = BrRows.length; i < il; i++)
                {
                    var BrRow = BrRows[i];
                    // run a total until we hit a Sum
                    var Col0 = BrRow.childNodes[0].innerText.replace(/\s/g,'');
                    if (Col0.length == 2)
                    {
                        var status = ManualTransfer.SumCommitQty(Col0).value;
                        if (status.substring(0,2) == "!!")
                        {
                            alert(status);
                            return;
                        }
                        var LineQty = BrRow.childNodes[11].childNodes[0];
                        //alert(status.split(':')[1]); 
                        if(isNaN(status.split(':')[1]))
                        {
                            LineQty.value = 0;;
                        }
                        else
                        {
                            LineQty.value = status.split(':')[1];
                        }
                        TerrCommQty += parseInt(LineQty.value, 10)
                        TotCommQty += parseInt(LineQty.value, 10)
                        var AccumQty = BrRow.childNodes[10];
                        if(isNaN(status.split(':')[0]))
                        {
                            AccumQty.innerHTML = 0;;
                        }
                        else
                        {
                            AccumQty.innerHTML = status.split(':')[0];
                        }
                        TerrAccumQty += parseInt(AccumQty.innerHTML, 10)
                        TotAccumQty += parseInt(AccumQty.innerHTML, 10)
                        //alert('T:' + TerrAccumQty + ' L:' + AccumQty.innerHTML); 
                    }
                    if ((Col0.length != 2) && (Col0.length != 14))
                    {
                        var SumQty = BrRow.childNodes[11];
                        //alert(SumQty.innerText); 
                        SumQty.innerText = TerrCommQty;
                        TerrCommQty = 0;
                        var AccumQty = BrRow.childNodes[10];
                        AccumQty.innerHTML = TerrAccumQty;
                        TerrAccumQty = 0;
                    }
                    if (Col0.length == 14)
                    {
                        var SumQty = BrRow.childNodes[10];
                        //alert(SumQty.innerText); 
                        SumQty.innerText = TotCommQty;
                        var AccumQty = BrRow.childNodes[9];
                        AccumQty.innerHTML = TotAccumQty;
                    }
                }
                //alert('go');
                $get("btnUpdXfers").click();
            }
        }

        function CPRReport()
        {
            if (document.getElementById('CPRFactor').value == "" || document.getElementById('CPRFactor').value == null || document.getElementById('CPRFactor').value.search(/\d+/) == -1 || document.getElementById('CPRFactor').value.search(/[a-zA-Z]/) != -1)
            {
                alert("To run the CPR report you must enter a numeric factor");
                document.getElementById('CPRFactor').focus();
            }
            else
            {
                CPRWin = window.open("CPRReport.aspx?Item=" + $get('lblItemNo').innerHTML + "&Factor=" + document.getElementById('CPRFactor').value,"CPRReport","height=768,width=1024,scrollbars=yes,location=no,status=no,top="+((screen.height/2) - (760/2))+",left=0,resizable=YES","");
            }
        }
    </script>

</head>
<body scroll="no" onresize="AdjustHeight();" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <div id="Container" style="height: 100%">
            <uc1:Header ID="Header1" runat="server" />
            <div id="Content">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td valign="top" class="shadeBgDown">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td valign="top" rowspan="3">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <asp:UpdatePanel ID="pnlMain" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <table width="100%" class=" blueBorder ItemHeader" border="0" cellspacing="0" cellpadding="2">
                                                                <tr>
                                                                    <td>
                                                                        <table border="0" cellspacing="0" cellpadding="1">
                                                                            <tr>
                                                                                <td style="width: 40px; padding-left: 10px;">
                                                                                    <strong>Item</strong></td>
                                                                                <td style="width: 200px;">
                                                                                    <strong>
                                                                                        <asp:TextBox ID="txtItemNo" runat="server" Width="150px" onDblClick="javascript:ClosePage();"
                                                                                            onClick="javascript:this.select();" onkeypress="javascript:if(event.keyCode==13){return ZItem(this.value)};"
                                                                                            onfocus="javascript:this.select();">
                                                                                        </asp:TextBox></strong>
                                                                                    <asp:Button ID="btnFindItem" runat="server" Text="FindItem" Style="display: none;"
                                                                                        OnClick="btnFindItem_Click" CausesValidation="false" UseSubmitBehavior="false" />
                                                                                </td>
                                                                                <td style="padding-left: 10px;">
                                                                                    Item ROP Factor
                                                                                    <asp:Label ID="lblROPFactor" runat="server"></asp:Label>
                                                                                </td>
                                                                                <td style="width: 200px;" align="right">
                                                                                    <a onclick="javascript:CPRReport();" style="cursor: hand" class="redhead" title="CLICK HERE TO RUN A CPR REPORT FOR THIS ITEM">
                                                                                        CPR Report</a> Factor:
                                                                                    <asp:TextBox ID="CPRFactor" runat="server" Width="30px" ToolTip="Enter the FACTOR for the CPR Report"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%--Branch Item Details Panel width: 540px;--%>
                                                    <asp:UpdatePanel ID="pnlShipDetails" runat="server" UpdateMode="conditional" ChildrenAsTriggers="false">
                                                        <ContentTemplate>
                                                            <div class="blueBorder">
                                                                <div id="div1" class="Sbar" align="left" style="overflow-x: hidden; overflow-y: auto;
                                                                    position: relative; top: 0px; left: 0px; height: 622px; border: 0px solid;">
                                                                    <asp:DataGrid CssClass="grid BlueBorder" BackColor="white" Width="97%" ID="dgItemDtl"
                                                                        GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                                        OnItemDataBound="dgItemDtl_ItemDataBound" ShowFooter="True">
                                                                        <HeaderStyle CssClass="gridHeader1" Height="18px" HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="gridItem TestRow" Wrap="False" Height="23px" />
                                                                        <AlternatingItemStyle CssClass="zebra TestRow" />
                                                                        <FooterStyle Font-Bold="True" ForeColor="#003366" CssClass="lightBlueBg" VerticalAlign="Top"
                                                                            HorizontalAlign="Right" />
                                                                        <Columns>
                                                                            <asp:TemplateColumn HeaderText="Br" SortExpression="LocationCode">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="LocID" runat="server" Width="65px" Text='<%#DataBinder.Eval(Container,"DataItem.LocationCode")%>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <FooterTemplate>
                                                                                    <table cellpadding="0" cellspacing="0" width="100%" align="left" class="noBorder">
                                                                                        <tr>
                                                                                            <td style="height: 15px" align="left" nowrap="nowrap">
                                                                                                <asp:Label Font-Bold="true" ForeColor="#003366" ID="lblItmNo" runat="server"></asp:Label></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </FooterTemplate>
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                                <HeaderStyle Width="50px" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:BoundColumn DataField="SVCode" SortExpression="SVCode" HeaderText="SV">
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                                <HeaderStyle Width="15px" HorizontalAlign="center" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="ROP" DataFormatString="{0:#,##0.0}" SortExpression="ROP"
                                                                                HeaderText="ROP">
                                                                                <HeaderStyle Width="40px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="ROPDays" DataFormatString="{0:#,##0}" SortExpression="ROPDays"
                                                                                HeaderText="Days">
                                                                                <HeaderStyle Width="40px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Avl" DataFormatString="{0:#,##0}" SortExpression="Avl"
                                                                                HeaderText="Avl">
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                                <HeaderStyle Width="40px" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="MosAvl" DataFormatString="{0:#,##0.0}" HeaderText="Avl Mos">
                                                                                <HeaderStyle Width="50px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="RTSB" DataFormatString="{0:#,##0}" HeaderText="RTSB"
                                                                                SortExpression="RTSB">
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                                <HeaderStyle Width="40px" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="InTransit" DataFormatString="{0:#,##0}" SortExpression="InTransit"
                                                                                HeaderText="Trf OW">
                                                                                <HeaderStyle Width="55px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Alloc" DataField="Allocated" DataFormatString="{0:#,##0}"
                                                                                SortExpression="Allocated">
                                                                                <ItemStyle HorizontalAlign="Right" Width="55px" />
                                                                                <FooterStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="OH Exc" DataField="OnHandExcess" DataFormatString="{0:#,##0}"
                                                                                SortExpression="OnHandExcess">
                                                                                <ItemStyle HorizontalAlign="Right" Width="55px" />
                                                                                <FooterStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Accum" DataField="AccumQty" DataFormatString="{0:#,##0}"
                                                                                SortExpression="AccumQty">
                                                                                <ItemStyle HorizontalAlign="Right" Width="55px" />
                                                                                <FooterStyle HorizontalAlign="Right" />
                                                                            </asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="Comm." SortExpression="CommitQty">
                                                                                <HeaderStyle Width="75px" />
                                                                                <ItemStyle HorizontalAlign="Right" />
                                                                                <ItemTemplate>
                                                                                    <asp:TextBox ID="txtCommit" runat="server" onchange="CommitQty(this);"
                                                                                        onkeypress="javascript:if(event.keyCode==13){return CommitQty(this)}"
                                                                                        onFocus="this.select();" Width="65px" Text='<%#DataBinder.Eval(Container,"DataItem.CommitQty","{0:#,##0}")%>'
                                                                                        CssClass="txtRight"></asp:TextBox>
                                                                                    <asp:Label ID="lblCommit" runat="server" Width="65px" Text='<%#DataBinder.Eval(Container,"DataItem.CommitQty","{0:#,##0}")%>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <FooterStyle VerticalAlign="Top" />
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                    <asp:Label ID="lblBrMsg" Font-Bold="true" runat="server" Text="No Records Found"></asp:Label>
                                                                    <asp:HiddenField ID="hidBranch" runat="server" />
                                                                    <input type="hidden" id="hidSortBranch" runat="server" />
                                                                </div>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <%--End Branch Item Details Panel--%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="blueBorder shadeBgDown">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td width="100%" class="blueBorder TabCntBk" style="padding: 5px">
                                                    <asp:UpdatePanel ID="pnlItemDetails" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <%--Item Details--%>
                                                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                <tr>
                                                                    <td>
                                                                        Item :
                                                                    </td>
                                                                    <td colspan="5" class="splitBorder_r_h" width="280px">
                                                                        <asp:Label ID="lblItemNo" Font-Bold="true" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Description :
                                                                    </td>
                                                                    <td colspan="5" class="splitBorder_r_h">
                                                                        <asp:Label ID="lblDescription" Font-Bold="true" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        UOM :
                                                                    </td>
                                                                    <td colspan="5" class="splitBorder_r_h">
                                                                        <asp:Label ID="lblUOM" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Qty Per :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblQtyPer" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right">
                                                                            <asp:Label ID="lblLbs" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        Lbs
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right">
                                                                        </div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        &nbsp;
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Super Eq. :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblSuperEqu" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right">
                                                                            <asp:Label ID="lblPCS" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        Pcs
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <div align="right">
                                                                            <asp:Label ID="lblTotLbs" runat="server" Font-Bold="true" Style="padding-left: 15px;"></asp:Label></div>
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        Lbs
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        Wgt/100 :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lbl100Wgt" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td colspan="2">
                                                                        Low Profile Qty :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblLowProfileQty" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        HarmCode :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblHarmCode" runat="server"></asp:Label>
                                                                    </td>
                                                                    <td colspan="2">
                                                                        Corp Fixed Velocity :
                                                                    </td>
                                                                    <td class="splitBorder_r_h">
                                                                        <asp:Label ID="lblVelocity" runat="server"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                </tr>
                                                            </table>
                                                            <%--End Item Details--%>
                                                    <asp:HiddenField ID="hidShippingLoc" runat="server" />
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:UpdatePanel ID="pnlFromTots" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <div class="blueBorder shadeBgDown">
                                                                <table border="0" cellspacing="2" cellpadding="0">
                                                                    <tr>
                                                                        <td class="Left2pxPadd" style="width: 150px">
                                                                            <strong>Shipping Location:</strong>
                                                                        </td>
                                                                        <td style="width: 35px" align="center">
                                                                            <asp:Label ID="lblShippingLoc" runat="server"></asp:Label>&nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd">
                                                                            <strong>On-Hand Excess Qty:</strong>
                                                                        </td>
                                                                        <td align="right">
                                                                            <asp:Label ID="lblOnHandExcessQty" runat="server" Text="0"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd">
                                                                            <strong>Committed Qty:</strong>
                                                                        </td>
                                                                        <td align="right">
                                                                            <asp:Label ID="lblCommittedQty" runat="server" Text="0"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd">
                                                                            <strong>Remaining Qty:</strong>
                                                                        </td>
                                                                        <td align="right">
                                                                            <b>
                                                                                <asp:Label ID="lblRemainingQty" CssClass="readtxt" runat="server" Text="0"></asp:Label></b>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="blueBorder">
                                                    <asp:UpdatePanel ID="pnlXFerLines" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <div id="div2" class="Sbar" style="overflow-x: hidden; overflow-y: visible;
                                                                position: relative; top: 0px; left: 0px; height: 470px; width: 100%; border: 0px solid;">
                                                                <asp:Panel ID="OtherPanel" runat="server" Width="100%" Height="100%" ScrollBars="Vertical">
                                                                    <asp:DataGrid runat="server" ID="dgOther" GridLines="both" CssClass="grid"
                                                                        AutoGenerateColumns="false" UseAccessibleHeader="true" AllowSorting="true" OnSortCommand="SortXFerGrid">
                                                                        <HeaderStyle CssClass="gridHeader2" Height="20px" HorizontalAlign="Center" />
                                                                        <ItemStyle CssClass="" />
                                                                        <AlternatingItemStyle CssClass="zebra" />
                                                                        <Columns>
                                                                            <asp:BoundColumn SortExpression="FromLocationCode" DataField="FromLocationCode" HeaderText="From">
                                                                                <ItemStyle HorizontalAlign="center" Width="40px" />
                                                                                <HeaderStyle Width="40px" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn SortExpression="ToLocationCode" DataField="ToLocationCode" HeaderText="To">
                                                                                <ItemStyle HorizontalAlign="center" Width="40px" />
                                                                                <HeaderStyle Width="40px" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Qty" DataFormatString="{0:#,##0}" HeaderText="Qty" SortExpression="Qty">
                                                                                <ItemStyle HorizontalAlign="Right" Width="60px" CssClass="Right2pxPadd" />
                                                                                <HeaderStyle Width="60px" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="AcceptDt" SortExpression="AcceptDt" DataFormatString="{0:MM/dd/yyyy}"
                                                                                HeaderText="Accepted">
                                                                                <ItemStyle HorizontalAlign="center" Width="90px" />
                                                                                <HeaderStyle Width="90px" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="EntryID" HeaderText="By" SortExpression="EntryID">
                                                                                <ItemStyle HorizontalAlign="center" Width="120px" />
                                                                                <HeaderStyle Width="120px" />
                                                                            </asp:BoundColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                    <asp:Label ID="lblOtherMsg" Font-Bold="true" runat="server" Text="No Other Manual Transfer Records Found"></asp:Label>
                                                                </asp:Panel>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <asp:Button ID="btnUpdXfers" runat="server" Text="UpdXFers" Style="display: none;"
                                                        OnClick="btnUpdXfers_Click" CausesValidation="false" UseSubmitBehavior="true" />
                                                </td>
                                            </tr>
                                        </table>
                                        <%--End Vendor Item and Shipment Details Panel--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="blueBorder" colspan="2" valign="top">
                            <%--Pager Panel--%>
                            <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <table class="BluBg" id="Table1" height="1" cellspacing="0" cellpadding="0" width="100%"
                                        border="0">
                                        <tr>
                                            <td colspan="2" height="8px">
                                                <table id="Table2" cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
                                                    <tr>
                                                        <td width="10%" height="8px">
                                                            <table id="Table3" cellspacing="0" cellpadding="2" width="40%" border="0">
                                                                <tr>
                                                                    <td>
                                                                        <asp:ImageButton ID="ibtnFirst" runat="server" ImageUrl="../Common/Images/PageFirst.jpg"
                                                                            OnClick="ibtnFirst_Click" /></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="ibtnPrevious" runat="server" ImageUrl="../Common/Images/PagePrev.jpg"
                                                                            OnClick="ibtnPrevious_Click" /></td>
                                                                    <td>
                                                                        <div class="TabHead">
                                                                            <strong>&nbsp;&nbsp;&nbsp;GoTo</strong></div>
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="ddlPages" runat="server" AutoPostBack="True" CssClass="PageCombo"
                                                                            Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged">
                                                                        </asp:DropDownList></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="btnNext" runat="server" ImageUrl="../Common/Images/PageNext.jpg"
                                                                            OnClick="btnNext_Click" /></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="btnLast" runat="server" ImageUrl="../Common/Images/PageLast.jpg"
                                                                            OnClick="btnLast_Click" /></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="center">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="40%" align="left">
                                                                        <table id="Table6" cellspacing="0" cellpadding="0" border="0" height="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td align="center">
                                                                                        <asp:Label ID="lblPage" runat="server" CssClass="TabHead">Page(s):</asp:Label></td>
                                                                                    <td align="center" style="width: 9px" class="LeftPadding">
                                                                                        <asp:Label ID="lblCurrentPage" runat="server" CssClass="TabHead">1</asp:Label></td>
                                                                                    <td align="center" class="LeftPadding">
                                                                                        <asp:Label ID="lblOf" runat="server" CssClass="TabHead">of</asp:Label></td>
                                                                                    <td align="center" class="LeftPadding">
                                                                                        <asp:Label ID="lblTotalPage" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                    <td width="60%" align="right">
                                                                        <table id="TblPagerRecord" cellspacing="0" cellpadding="0" border="0" height="1">
                                                                            <tr>
                                                                                <td style="height: 17px">
                                                                                    <asp:Label ID="lblRecords" runat="server" CssClass="TabHead">Record(s):</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblCurrentPageRecCount" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="Label1" runat="server" CssClass="TabHead">-</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblCurrentTotalRec" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblOf1" runat="server" CssClass="TabHead">of</asp:Label></td>
                                                                                <td style="height: 17px" class="LeftPadding">
                                                                                    <asp:Label ID="lblTotalNoOfRec" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="35%">
                                                            <table id="Table4" height="0%" cellspacing="0" cellpadding="2" border="0">
                                                                <tr>
                                                                    <td colspan="3">
                                                                        <asp:CompareValidator Style="display: none" ID="cpvGotoPage" runat="server" ErrorMessage="Enter Integer values alone"
                                                                            CssClass="Required" ForeColor=" " ControlToValidate="txtGotoPage" Operator="DataTypeCheck"
                                                                            Type="Integer"></asp:CompareValidator>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right" class="Left2pxPadd">
                                                                        <asp:Label ID="lblGotoPAge" runat="server" CssClass="TabHead">Go to Page # :</asp:Label></td>
                                                                    <td class="Left2pxPadd">
                                                                        <asp:TextBox ID="txtGotoPage" onkeypress="javascript:if(event.keyCode==13){if(this.value!=''){document.getElementById('btnGo').click();return false;}}else{ValdateNumber();}"
                                                                            runat="server" CssClass="FormControls" Width="25px">0</asp:TextBox></td>
                                                                    <td class="Left2pxPadd">
                                                                        <asp:ImageButton ID="btnGo" runat="server" ImageUrl="~/Common/Images/Go.gif" OnClick="btnGo_Click" /></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <%--End Pager Panel--%>
                        </td>
                    </tr>
                </table>
                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table width="100%" cellpadding="0" cellspacing="0" class="BluBg buttonBar">
                                <tr>
                                    <td width="50%" align="left">
                                        <asp:UpdateProgress ID="upPanel" runat="server" AssociatedUpdatePanelID="pnlItemDetails">
                                            <ProgressTemplate>
                                                <span style="padding-left: 5px" class="TabHead">Loading...</span>
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                    runat="server" Text=""></asp:Label>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                    <td align="right" style="padding-right: 8px;">
                                                <img alt="Accept" src="../Common/Images/accept.jpg" id="btnAccept" onclick="javascript:AcceptXfers();" />
                                                <img alt="Close" src="../Common/Images/close.gif" id="imgClose" onclick="javascript:ClosePage();" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:BottomFooter ID="BottomFrame2" Title="CPR Manual Transfer Processing" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
