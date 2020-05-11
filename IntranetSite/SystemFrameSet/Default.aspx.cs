using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.DirectoryServices;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using System.Net.Sockets;
using System.Net;
using System.IO;

  public partial class _Default : System.Web.UI.Page
    {
        UserValidation user = new UserValidation();
        string _userLoginName = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //System.Net.IPHostEntry ipEntry = System.Net.Dns.GetHostByAddress(Request.ServerVariables["REMOTE_HOST"].ToString());
                //if (ipEntry.HostName.ToString().ToLower().Trim().Contains(Global.WinSystemName.ToString()))
                //{

                //    Response.Redirect(@"http://pfcintranet/IntranetWindowsAuthentication/default.aspx", false);
                //}
                //else if (ipEntry.HostName.ToString().Split('.')[1].ToString().ToLower().Trim() == "pfca")
                //{
                //    Response.Redirect(@"http://pfcintranet/IntranetWindowsAuthentication/default.aspx", false);
                //}
                //else
                //{
                //    Response.Redirect("UserLogin.aspx?UserID=" + _userLoginName, true);
                //}
                
                Response.Redirect("http://pfcintranet/IntranetWindowsAuthentication/default.aspx", false);
                
            }
            catch (Exception ex)
            {
                Response.Redirect("UserLogin.aspx");
            }
        }


      public bool UrlIsValid(string Url)
      {
          Stream sStream;
          WebRequest URLReq;
          WebResponse URLRes;

          try
          {
              URLReq = WebRequest.Create(Url);
              URLRes = URLReq.GetResponse();
              sStream = URLRes.GetResponseStream();
              string reader = new StreamReader(sStream).ReadToEnd();
              return true;
          }
          catch (SocketException se)
          {
              return false;
          }

      }
      
    } 

