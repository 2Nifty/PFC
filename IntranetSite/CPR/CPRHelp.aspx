<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CPRHelp.aspx.cs" Inherits="CPRHelp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CPR Help</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div><a name="#PageTop"></a>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="middle" class="PageHead">
                        <span class="Left5pxPadd">
                            <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="CPR Web Help"></asp:Label></span>
                    </td>
                    <td align="right" class="PageHead">
                        <img src="../Common/Images/close.gif" style="cursor:hand" onclick="javascript:window.close();"
                         title="Click Here to Close&#013;the CPR Help window">&nbsp;&nbsp;
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
                            <a href="#Selecting">Selecting Items</a><br />
                            <a href="#Import">Excel Import</a><br />
                            <a href="#Static">Static Lists</a><br />
                            <a href="#Filtering">Options and Filtering</a><br />
                            <a href="#Definitions">Filter Definitions</a><br />
                            <a href="#Showing">Showing Items</a><br />
                            <a href="#Page">The CRP Page</a><br />
                            <a href="#Printed">The Printed Report</a><br />
                            <a href="#Excel">Excel Output</a><br />
                            <hr />
                            <hr />
                            <center><img src="../Common/Images/close.gif" style="cursor:hand" onclick="javascript:window.close();"
                            title="Click Here to Close&#013;the CPR Help window"></center>
                       </asp:Panel>
                    </td>
                    <td>
                        <asp:Panel ID="ContentPanel" runat="server" Height="700px" ScrollBars="Vertical">
                            <a name="#Overview"></a><div class="PageHeadsmall">Overview</div>
                            The CPR .Net report is a new version of the CPR report. This report does not have the same selection options
                            as the original CPR report.<p>
                            There are two pages (Item Selection and Report Options) to go through and then the report will be displayed. In both pages, press the 'View Report"
                            button to get to the next step.</p>
                            There are some interesting calculations used in CPR reporting that will be discussed here.<br />
                            Need amount is ROP Cust - (Avail + Trf + OW Next). This is a little stange in that a negative number is a good thing.
                            In this calculation you are subtracting the available, transfer and the next on the water qty from the ROP Cust. So the more
                            there is avaliable or in transfer or on the water, the smaller the number will get. The number goes negative once this qty 
                            goes beyond the ROP Cust. This calculation is used extensively for shading and filtering.
                            <p><b>ROP Cust and ROP</b><br />
                            ROP Cust is the ROP that is defined in the inventory system. This is the base ROP that is used by many of the shading and 
                            filtering calculations.<br />
                            ROP is also known as Hub ROP. The CPR system calculates this value by adding a percentage of branch ROPs to ensure that a hub
                            can supply its dependent branches. Usually ROP and ROP Cust are the same except for hubs where the ROP will be larger then the ROP Cust.
                            </p>
                            
                            <a name="#Selecting"></a><div class="PageHeadsmall">Selecting Items</div>
                            The Item Selection page allows you to load items to be used in the report.  There is a variety of ways to load items:<br />
                            Load an Excel spreadsheet that has item numbers in the first column.<br />
                            Select a VMI Contract.<br />
                            Load a previously saved Static List.<br />
                            Load an Auto Distribution Exception list.<br />
                            You can also type in a single item number.<br />
                            <p>You are either running the report on a single item or running the report from a list of items.<br />
                            There are four selections for loading items at the top of the page:<br />
                            <b>Excel Import</b> allows you to load text files or spreadsheet containing item numbers. 
                            <a href="#Import">See below for an in-depth discussion.</a><br />
                            <b>Static List</b> allows you to search for Static Lists of the same type (name). Select a Static List from the drop down
                            and click on the Search button. The matching Static Lists will be shown in the lower left of the page. 
                            <a href="#Static">See below for an in-depth discussion on Static Lists.</a><br />
                            <b>Single Item</b> allows you to enter a single item for the CPR .Net report. This is a Z-Item field so you can put in part of the
                            item number and press Enter to have that portion of the item number zero filled.<br />
                            <b>VMI Contract</b> allows to you load all the item numbers on a contract. Select the contact to load then click on the Submit
                            button to the right to load the contract items.
                            </p>
                            You can view all the Static Lists or all the AD Exception Lists by clicking on the OK button next to the text with
                            the blue background.
                            <p>
                            <b>Loading the Items from a Static List or AD Exception List</b><br />
                            The box of Lists in the lower left will either contain Static Lists or AD Exception lists. 
                            AD Exception Lists are items that were on the Hungry list after an AD process was executed. The list has the
                            date the process was run, the AD Process name, and the user that ran the process.<br />
                            The rightmost column is either list type
                            has the word Load in red. Click on the word Load to load all the items in the list to the Items to Report box on the
                            right.
                            </p>
                            The Items to Report box in the lower right has the list of items that will be shown on the report if you are
                            not running a single item report. The basic goal of the Item Selection page it to either get a single item number
                            or a list of Items to Report in the lower right. To move to the next page for the Report Options, you have to have
                            entered a single item number and selected the Single Item radio button or have a list of numbers in the Items to Report.
                            The Items to Report will give you the Item number count in parentheses.<br />
                            
                            <a name="#Import"></a><div class="PageHeadsmall">Excel Import</div>
                            You can load either a text file or a spreadsheet. 
                            <p>The text file has to have a single column of item numbers
                            (and nothing else). The extension of the filename has to be .txt.
                            Items numbers have to be complete with full category numbers and dashes.</p>
                            Only spreadsheets 
                            with item numbers as the first column will work. If the items numbers you want to use are in some other column, remove 
                            the extra columns until the items are in Column A. The first row must have the word 'Item'. The second row and all
                            the remaining rows must have item numbers. Items numbers have to be complete with full category numbers
                            and dashes. Blank rows are not allowed. There can be data in the other columns to the right of the item numbers.
                            These columns will be ignored.<br />
                            
                            <a name="#Static"></a><div class="PageHeadsmall">Static Lists</div>
                            Static lists allow you to run the same item numbers through the CPR .Net report again and again. You can create
                            a Static List from any CPR .Net report run.
                            <p><b>Loading current Static Lists</b><br />
                            You can either see all the Static Lists or only Staic Lists with the same name (type). To see all the Static Lists,
                            press the OK button next to the text 'Show Static Lists' with the blue background. The most
                            recent lists are at the top. To see only he Static Lists with the same name, use the Static Lists selector
                            at the top of the page and press the Search button.</p>
                            Once you decide the list you want to report, click on the word Load in red in the rightmost column. This
                            will load the items into the Items to Report list.
                            <p><b>Creating Static Lists</b><br />
                            You can create a Static List out of the Items to Report list. This means you can load an Excel spreadsheet
                            then turn it into a Static List. Or load an AD Exception List and turn it into a Static List. You can even come back
                            to this page after you have done filtering in the Report Options and create a Static List.</p>
                            To create a Static List, check the box left of the text 'Create Static List from Run' and enter the name
                            in the box to the right of the text 'Static List Name'. When you click on the View Report button, a Static List
                            will be created. You can create many lists with the same name because the date the Static List is created is tracked.<br />
                            
                            <a name="#Filtering"></a><div class="PageHeadsmall">Report Options and Filtering</div>
                            The Report Options pages is where you set the CPR Factor, the Report Format, Sort, and Filter items.
                            <p>The CPR Factor is that same as the factor on the original CPR report and is used in the calculation of the
                            columns in the 'BUY' section of the report.</p>
                            The Report Format is either Long or Short. The Long format has all the standard CPR columns. The Short format
                            does not show OW Next, Total, and the ROP data.
                            <p>The Report Sort sets the way the Items are sorted. The default is by item number. You can also choose to sort
                            by Corporate Fixed Velocity Code (CFVC) then Item.</p>
                            Below the Report Sort is the number of items to be reported. If you Filter records, this total will be updated.
                            If you accidentally apply a filter an end up with no (0) records, just press the Close button to return to the
                            Item Selection page and reload the items.
                            <p>The right side of the page allows filtering of the items. You can apply one of four exception filters,
                            remove or keep only items out at all branches (Empty Pantry), or remove items that have no requirements (all the items are either
                            shaded or have an ROP of zero). To use a filter, click on the radio button (the liitle white dot) next to the filter you wish to apply
                            then press the OK button to the right. You can apply as many filters as you like.</p>
                            
                            <a name="#Definitions"></a><div class="PageHeadsmall">Filter Definitions:</div>
                            <b>Exception Filters:</b><br />
                            Total company excess is defined as the Available - ROP Cust totaled for all branches.<br />
                            Total (hub) excess for Exception 4 is defined as the Available - ROP Cust totaled for Carson and NJ (other branches
                            may be added in the future).<br />
                            Total required is defined as the largest branch requirement (not the total of all branch requirements) where the 
                            calculated ROP minus the available, transfer and on the water is greater than or equal to one 
                            (ROP Cust - (Available + Transfer + OW Next) >= 1).<br />
                            Total hub required is defined as the largest hub requirement where the calculated ROP minus the available, transfer 
                            and on order is greater than or equal to one (ROP Cust - (Avail + Trf + OW Next) >= 1).
                            <p><b>Branch Required < Company Excess</b> = Total required is less than company total excess available. <br />
                            <b>Hub Required > Company Excess; 75% Hub Required < Company Excess</b> = Total hub required is greater than total 
                            excess available, and hub required times 75% is less than company total excess available. <br />
                            <b>Branch Required > Company Excess; Hub Required < Company Excess</b> = Total required is greater than 
                            total excess available, and total hub required is less than total company excess available. <br />
                            <b>Hub Required > Company Excess; 75% Hub Required < Branch 01,18 Excess</b> = Total hub required is greater than total 
                            excess available, and hub required times 75% is less than total excess available in Carson and NJ only.</p>
                            <b>Remove / Keep Only Items Out at All branches (Empty Pantry):</b><br />
                            This filter applies to items that are out of inventory at all branches. An item is considered to have extra inventory
                            if  ROP minus the available, transfer and the next on the water qty is less than zero 
                            (ROP Cust - (Avail + Trf + OW Next) < 0). Another way to say it is that the available, transfer and the next 
                            on the water qty is greater the the ROP. An Empty Pantry item is one that does not have extra inventory. You can filter
                            to either remove these records (becasue there is not an opportunity to move inventory between branches) or to can keep only
                            these items (so someone in Purchasing will buy some quick). If you decide to keep only these items, you may want to use the Show Items 
                            option described below. This will show you a list of these Empty Pantry items that can be forwarded to someone for action.
                            <p><b>Remove Items with no requirements</b><br />
                            This filter uses the shading logic to determine if a branch is OK. Using this filter is like saying remove the parts that
                            have enough inventory and don't require any action. Each branch within a single item must meet one or more of these rules:<br />
                            The sales velocity code is 'N'.<br />
                            The ROP is zero.<br />
                            The available plus transfer plus the next on the water qty is less that the ROP Cust.<br />
                            The need amount (ROP Cust - (Avail + Trf + OW Next) is less than 25% of the ROP Cust.<br />
                            </p>
                            
                            <a name="#Showing"></a><div class="PageHeadsmall">Showing Items</div>
                            Once the items have been loaded and you are on the Report Options page, you can see the list of items that will
                            be shown in the report. Click on the OK button next the the text 'Show Item List'.
                            This list can be sorted by clicking on the column headings. Sorting the item list does
                            not affect the order in which the  items are shown in the CPR .Net report.
                            <p>The list allows you to copy and paste items into Excel. The Excel spreadsheet can be saved and loaded into the Item Selection page
                            at a later time. The list can also be copied and pasted into an e-mail. The list allows you to see the part number without the CPR data.
                            A common use of this is to filter showing only the 'Empty Pantry' items and then e-mail them to a person responsible 
                            for filling the immediate need.</p>
                            
                            <a name="#Page"></a><div class="PageHeadsmall">The CRP Page</div>
                            Once you click on the View Report button from the Report Options page, the CPR .Net report will appear in a
                            new window. The page has the same information as the original CPR report.<p>
                            Use the toolbar at the bottom of the report to page through the items.</p>
                            You can change to format of the report (Long or Short) by using the radio buttons in the upper left of the window.
                            <p>There are buttons in the upper right area of the window to allow you to output the CPR .Net report to an Excel
                            spreadsheet or to a printer. See the following sections for an in depth discussion of these options.</p>
                            
                            <a name="#Printed"></a><div class="PageHeadsmall">The Printed Report</div>
                            If you press the Print button in the upper right of the CPR .Net report, you will create a printable version of the
                            CPR .Net report.<p>
                            There is a timing issue here. If you have selected hundreds of items, it is going to take a while to create a really big
                            web page to print them all. Then it will take time to send the really big page to the printer. Once you hit the Print button,
                            your report will start being created. A dialog box will appear giving you instructions to wait for the Print Dialog box, wait for the printing to
                            complete, then press the OK button.</p>
                            The Print Dialog box is the place where you get to choose the printer you want to use. Go through the list of available printers and select the
                            one you want. Once you have the printer selected, click on the Preferences button and set the orientation to Landscape. It is important
                            to remember to do this. Otherwise, the printed report will be clipped on the right side. Please be patient when waiting for the Print Dialog box.
                            If you are printing a large report, it may take a few minutes to appear.
                            <p>Once the printing is complete, press the OK button on the dialog box with the instructions. This will close the page with the
                            printed report. If for some reason the page with the report does not close, you can close it by using the little 'x' button 
                            in the upper right.</p>
                            
                            <a name="#Excel"></a><div class="PageHeadsmall">Excel Output</div>
                            You only want to use this option for small runs of less than 100 items. Large runs of over a hundred items take a long time to 
                            excute and will seriously slow down your system. Also, this is not good for printing. You you want a printed copy, use
                            the Print button.<p>
                            Once you press the Excel button, a large Excel page will be created with the CPR items. You will see the same data as the report.</p>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
