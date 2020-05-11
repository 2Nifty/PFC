using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class _Default : System.Web.UI.Page
{
    private int numOfColumns = 12;
    public static int ctr = 0;
    static Table table = new Table();
    protected void Page_Load(object sender, EventArgs e)
    {
        table.ID = "table1";
        Panel1.Controls.Add(table);
    }
    protected void btnAddNewRow_Click(object sender, EventArgs e)
    {
        numOfColumns = 12;
        //Generate the Table based from the inputs
        GenerateTable(numOfColumns);
    }
    private void GenerateTable(int colsCount)
    {
        ctr++;
        // Now iterate through the table and add your controls
        TableRow row = new TableRow();
        row.ID = "row" + ctr;
        TableCell cell1 = new TableCell();
        DropDownList dl = new DropDownList();
        dl.ID = "DrpDwnBrand" + ctr;
        dl.AutoPostBack = false;
        dl.Width = 135;
        // Add the control to the TableCell
        cell1.Controls.Add(dl);
        // Add the TableCell to the TableRow
        row.Cells.Add(cell1);
        for (int j = 1; j <= colsCount; j++)
        {
            TableCell cell2 = new TableCell();
            TextBox tb = new TextBox();
            if (j == 1)
            {
                tb.ID = "txtJan" + ctr;
            }
            else if (j == 2)
            {
                tb.ID = "txtFeb" + ctr;
            }
            else if (j == 3)
            {
                tb.ID = "txtMar" + ctr;
            }
            else if (j == 4)
            {
                tb.ID = "txtApr" + ctr;
            }
            else if (j == 5)
            {
                tb.ID = "txtMay" + ctr;
            }
            else if (j == 6)
            {
                tb.ID = "txtJun" + ctr;
            }
            else if (j == 7)
            {
                tb.ID = "txtJul" + ctr;
            }
            else if (j == 8)
            {
                tb.ID = "txtAug" + ctr;
            }
            else if (j == 9)
            {
                tb.ID = "txtSep" + ctr;
            }
            else if (j == 10)
            {
                tb.ID = "txtOct" + ctr;
            }
            else if (j == 11)
            {
                tb.ID = "txtNov" + ctr;
            }
            else if (j == 12)
            {
                tb.ID = "txtDec" + ctr;
            }
            tb.Width = 37;
            // Add the control to the TableCell
            cell2.Controls.Add(tb);
            // Add the TableCell to the TableRow
            row.Cells.Add(cell2);
        }
        TableCell cell3 = new TableCell();
        CheckBox cb = new CheckBox();
        cb.Controls.Clear();
        cb.ID = "chkSameAll" + ctr;
        cb.AutoPostBack = false;
        cb.Width = 10;
        // Add the control to the TableCell
        cell3.Controls.Add(cb);
        // Add the TableCell to the TableRow
        row.Cells.Add(cell3);
        // Add the TableRow to the Table
        table.Rows.Add(row);
    }
}