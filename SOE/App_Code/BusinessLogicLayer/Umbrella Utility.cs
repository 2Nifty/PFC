/** 
 * Project Name:
 *     Umbrella 2.0
 * 
 * Module Name
 *		Novantus.Umbrella.DataAccessLayer
 *
 * Author:
 *     Senthil Kumar Ramachandran <rsenthil@novantus.com> 
 *
 * Abstract:
 *     This is Data Abstraction layer for Data accessing purpose with data source neutrla feature...
 *
 * Revision History:
 * 
 *  DATE				VERSION			AUTHOR							ACTION
 * <-------------------------------------------------------------------------->			
 *	24 Oct '05			Ver-1			Senthil Kumar Ramachandran		Created

 **/
using System;
using System.Web.UI.WebControls;


namespace Novantus.Umbrella.Utils
{
	public class Utility
	{
		/// <summary>
		/// Set the selected values in List Controls
		/// </summary>
		/// <param name="control"></param>
		/// <param name="selectedValues"></param>
		public static void SetSelectedValuesInListControl(
			ListControl listControl,
			string selectedValues)
		{
			
			try
			{
				if(listControl.GetType().Name == "ListBox")
				{
					ListBox listBox=listControl as ListBox;
					if(listBox.SelectionMode == ListSelectionMode.Single && listControl.SelectedIndex != -1)
						throw(new Exception());
				}
				if((listControl.GetType().Name == "DropDownList" || listControl.GetType().Name == "AutoFillCombo") && listControl.SelectedIndex != -1)
				{
					listControl.SelectedIndex=-1;					
				}
			
				if(selectedValues.Split('~').Length == 1)
				{
					SetSelectedItems(listControl,selectedValues);									
				}
				else
				{
					string []valuesList=selectedValues.Split('~');
					for(int i=0;i<valuesList.Length;i++)
					{
						SetSelectedItems(listControl,valuesList[i]);
					}
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}	
			
		}
		private static void SetSelectedItems(
			ListControl listControl,
			string value)
		{
			try
			{
				ListItemCollection itemCollection=listControl.Items;
				
				foreach(ListItem item in itemCollection)
				{
                    if(item.Value.Trim().ToLower() == value.Trim().ToLower())
					{					
						item.Selected=true;
						break;
					}
                    else if (listControl.GetType().FullName == "System.Web.UI.WebControls.RadioButtonList" && value.Trim() == "0")
                    {
                        listControl.Items[0].Selected = false;
                        listControl.Items[1].Selected = true;
                    }
                    else if (listControl.GetType().FullName == "System.Web.UI.WebControls.RadioButtonList" && value.Trim() == "1")
                    {
                        listControl.Items[0].Selected = true;
                        listControl.Items[1].Selected = false;
                    }
					
                    
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}
			finally
			{
			}
		}
        
	}
}
