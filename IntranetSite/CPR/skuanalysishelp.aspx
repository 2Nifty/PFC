<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>BSA Help</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="BSAStyles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div><a name="#PageTop"></a>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="middle" class="PageHead">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Branch Stocking Analysis Help"></asp:Label></span>
                    </td>
                    <td align="right" class="PageHead">
                        <img src="../Common/Images/close.gif" style="cursor:hand" onclick="javascript:window.close();"
                         title="Click Here to Close&#013;the Help window">&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="Left5pxPadd">
                        <asp:Panel ID="TOCPanel" runat="server" Height="700px" Width="125px">
                            <b>Table of Contents</b><br />
                            <hr />
                            <a href="#Overview">Overview</a><br />
                            <a href="#Branches">Selecting Branches</a><br />
                            <a href="#Selecting">Selecting Items</a><br />
                            <a href="#Grid">The Item/Location Grid</a><br />
                            <a href="#Changing">Changing Status</a><br />
                            <a href="#Accepting">Verifying Your Changes</a><br />
                            <a href="#CPR">CPR</a><br />
                            <a href="#Submitting">Submitting Your Changes</a><br />
                            <hr />
                            <hr />
                            <center><img src="../Common/Images/close.gif" style="cursor:hand" onclick="javascript:window.close();"
                            title="Click Here to Close&#013;the BSA Help window"></center>
                       </asp:Panel>
                    </td>
                    <td>
                        <asp:Panel ID="ContentPanel" runat="server" Height="700px" ScrollBars="Vertical" CssClass="Left5pxPadd">
                            <a name="#Overview"></a><div class="PageHeadsmall">Overview</div>
                            The Branch Stocking Analysis (BSA) page allows you to change the stocking status for an SKU.<p>
                            The first page allows you to select the branches and a range of items to work with. 
                            The second page will show you the items and locations 
                            and allow you to indiciate which are to be changed. The third page verifies the changes you plan to make.
                            The fourth page shows you the results of your actions and brings you back to the start.</p>
                            Build the list of branches (described below) and then set the category, package, plating ranges and click
                            on the Search button. If you decide not to make any changes, enter a new category, package, plating range
                            and click on the Search button again. If you want to see different branches, click on the List button. Make
                            changes to the Branches To Report list and then click on the Search button. Use the Print button if you want 
                            a printed copy of the item/location grid.
                            <p>If you see that you do want to change an item, check the check box for the items to be changed. You can make
                            multiple changes in one pass so check on as many as you want to change. Then click on the
                            Accept button to review your proposed changes. If this is what you want to do, click on the Update button
                            and your changes will be made.
                            </p>
                            <table border="1" bordercolor="black" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td>
                                        <img src="../Common/images/search.gif" />
                                    </td>
                                    <td>Use this button to find the items in the category, package, plating ranges.
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <img src="../Common/images/list.gif" />
                                    </td>
                                    <td>Use this button to return to the Branches To Report list and change the branches to be shown in the 
                                    item/location grid
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <img src="../Common/Images/accept.jpg" />
                                    </td>
                                    <td>Use this button if you have made changes to the stocking status. It will bring up a screen to
                                    verify your changes.
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <img src="../Common/Images/print.gif" />
                                    </td>
                                    <td>When the item/location grid is being displayed, click on this button to get a printout.
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <img src="../Common/Images/update.gif" />
                                    </td>
                                    <td>After you have made changes and clicked on the Accept button, you will see a list of the proposed
                                    actions to be taken. Use this button to apply the actions. <div class="readtxt">Remember, no changes will be made unless
                                    you click on the Update button.</div>
                                    </td>
                                </tr>
                            </table><br />
                            
                            <a name="#Branches"></a><div class="PageHeadsmall">Selecting Branches</div>
                            When the page first come up, the Branches To Report list is empty. You must build a list of branches you want to work
                            with. The Branch List has all the available branches. Press the Add link to the right of the branch you want to
                            add to the Branches To Report list.
                            <p><b>Branches To Report</b> This is the list of branch you will be working with while using BSA. The branch at 
                            the top of the list will be the left-most column. The last branch on the list will be the last column on the
                            right. You have the ability to modify the list. You can move items up and down, delete items, an indicate an
                            item is a hub branch. Click on the red link to the right of the branch to perform that action. To empty the
                            Branches To Report list, click on the red Clear All link.
                            </p>
                            <b>Branch List</b> If you want to load all the branches in the Branch List into the Branches To Report, click on 
                            the red link Load All to the right of Branch List and all the branches will be loaded into the Branches To Report.
                            To add an individual branch, click on the red Add link to the right of the branch.
                            <p>
                            The easiest way to build the Branches To Report list is to add them from the Branch List in the order you want
                            to see them. Use the List button to retunr to the Branches to Report list.
                            </p>
                            
                            <a name="#Selecting"></a><div class="PageHeadsmall">Selecting Items</div>
                            Once you have your branches selected, enter a range of categories, packages and platings at the top of the
                            page. Each range
                            has a beginning and ending input separated by a dash. Only the beginning range is required. Use the ending if
                            you are searching across more than one category, package, or plating.
                            <p>The search inputs are Z-Item enabled so you can enter in part of the value and it will be zero filled for you
                            when you press the Enter key on the keyboard.
                            </p>
                            Enter a category, package and plating then press the Search button. If you are using the Z-Item capability, press
                            the Enter key when you are on the Search button. You can use the Search button at any time. If you look at
                            the grid and decide you do not want to make any changes, you can enter new search ranges and see a new grid.
                            <p>
                            A grid of items will come up. The first column will have the part number and the other columns will have the
                            SKU data for the branches you selected. View the next section for more information about the grid.
                            </p>
                                                        
                            <a name="#Grid"></a><div class="PageHeadsmall">The Item/Location Grid</div>
                            The Item/Location grid shows all the SKU data for the items in your range. There are check boxes that allow
                            you to change the stocked status. If the item is not stocked, checking the box will make it stocked. If the 
                            item is stocked, checking the box will make it not stocked. The changes will occur after you verfiy and update.
                            <p>You can see three types of color coded data.  
                            </p>
                            <table cellpadding="2" cellspacing="0" border="0">
                                <tr class="hasSKU">
                                    <td>A check box with a letter next to it is stocked and the letter
                            is the sales velocity code (SVC).
                                    </td>
                                    <td>Stocked
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr class="nSVC">
                                    <td>A check box with a number next to it is not stocked (SVC=N) and the number is
                            the reorder point (ROP). 
                                    </td>
                                    <td>Not&nbsp;Stocked
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr class="noSKU">
                                    <td>A check box with a blank next to it is not stocked and there is no SKU record on file.
                                    </td>
                                    <td>Not&nbsp;Stocked
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                            
                            <br />
                            
                            <a name="#Changing"></a><div class="PageHeadsmall">Changing Status</div>
                            You change status by checking a check box, accepting (verifying), and submitting.
                            <p>
                            Check only the Item/Location you want to change. If you change your mind, uncheck the check box. Check as many
                            boxes as you like. This system can change dozens of parts in one pass.
                            </p>
                            Once you have the check boxes the way you want them, click on the Accept button. This will bring up a detailed
                            list of the actions you plan to make. See the next section for more info.<br /><br />
                            
                            <a name="#Accepting"></a><div class="PageHeadsmall">Verifying Your Changes</div>
                            Once you have set the check boxes the way you like them and pressed the Accept button, you'll see the list of
                            actions that will occur if you update. This is your last chance to check and make sure you want to make
                            these changes. <div class="readtxt">Once you press the Update button, there is no going back. Your listed 
                            actions will be applied to the SKU table immediately!</div>
                            <p>The verification list shows the item, location, current state, and action to be taken. If you decide not to take
                            an action, you can uncheck the check box in the action to be taken and it will be ignored. Only actions that
                            are checked will be applied when you click on the Update button.
                            </p>
                                                        
                            <a name="#CPR"></a><div class="PageHeadsmall">Getting a CPR Report</div>
                            When the list of actions is displayed, you can get a CPR report on any item in the list.
                            <p>You will see a input at the top of the screen that says Factor. This is the standard factor used to run a CPR report.
                            You must put a number there. The default is set to 1.
                            </p>
                            With the factor set the way you want, click on any item number and a CPR report page will appear for that item.
                            <p>
                            You can click on any number in the list. If the CPR page is already displayed, the page will be refreshed with the
                            item number you click on.
                            </p>
                                                        
                            <a name="#Submitting"></a><div class="PageHeadsmall">Submitting Your Changes</div>
                            Verify the actions and then click on the Update button. This will apply your updates to the SKU table.
                            <p>You will see the Process Log of the changes you made. There is a red link at the top of the Process Log that says
                            "Show All Changes Made this Session". Clicking on this link will show you all of the changes you have made since you 
                            started. This log is cleared every time you start the program and is added to each time you process
                            actions. If you made a lot of changes and want to keep your own list, you can copy the log and paste it to a Word or 
                            Excel file. Remember that once you close the Branch Stocking Analysis screen, the Process Log will be cleared. And it 
                            you spend a long timme working with quite a few diferrnt items, you can see the log of that changes that you made 
                            in this session.
                            </p>When the Process Log is displayed, you changes are complete and you can enter a new category, package and/or plating
                            and start updating a new set of items. If you want to change the Branches you are working with, click onthe List button
                            and the Branches To Report list will appear.
                            <p><div class="readtxt">Important: Once you press the Update button, there is no going back. Your listed actions will be applied to
                            the SKU table immdediately!</div></p><br />
                            
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
