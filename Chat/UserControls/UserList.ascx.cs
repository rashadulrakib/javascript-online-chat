using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class Chat_UserControls_UserList : System.Web.UI.UserControl
{
    int userid = 0;
    string username = string.Empty;
    int roomId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.Session["ChatUserID"] != null)
        {
            userid = int.Parse(this.Session["ChatUserID"].ToString()); 
        }

        if (this.Session["ChatUsername"] != null)
        {
            username = this.Session["ChatUsername"].ToString();
        }

        roomId = int.Parse(Request["roomId"]);
   
        this.PopulateUserList();
     }
   
    private void PopulateUserList()
    {
        LinqChatDataContext db = new LinqChatDataContext();

        string userIcon;
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        // get all logged in users to this room
        var loggedInUsers = from l in db.LoggedInUsers
                            where l.RoomID == roomId
                            select l;

        // list all logged in chat users in the user list
        string qutation = '"'.ToString();

        foreach (var loggedInUser in loggedInUsers)
        {
            if (username != loggedInUser.User.Username)
            {
                // show user icon based on sex
                if (loggedInUser.User.Sex.ToString().ToLower() == "m")
                    userIcon = "<img src='Chat/Images/manIcon.gif' style='vertical-align:middle' alt=''>  ";
                else
                    userIcon = "<img src='Chat/Images/womanIcon.gif' style='vertical-align:middle' alt=''>  ";

                var unreadmsgs = from um in db.Messages
                                 where um.RoomID == roomId
                                 && um.UserID == loggedInUser.User.UserID
                                 && um.ToUserID == userid
                                 && um.MessageStatus == "unread"
                                 select um;

                string blinkstart = string.Empty;
                string blinkend = string.Empty;

                if (unreadmsgs != null && unreadmsgs.Count() > 0)
                {
                    blinkstart = "<blink>";
                    blinkend = "</blink>";
                }

                sb.Append("<div id=" + qutation + "div_" + loggedInUser.User.Username + "_" + loggedInUser.User.UserID.ToString() + qutation + " onclick=" + qutation + "openChatWindow(this,true);" + qutation + " onmouseover=" + qutation + "this.style.backgroundColor='#84DFC1';" + qutation +
                            " onmouseout=" + qutation + "this.style.backgroundColor='#98BF21';" + qutation +
                   " style='cursor: pointer;'>" + userIcon + "<b>" + blinkstart + loggedInUser.User.Username + "</b>" + blinkend + "</div>");
            }
        }

        // holds the names of the users shown in the chatroom

        ltrlUserList.Text = sb.ToString();
    }
}
