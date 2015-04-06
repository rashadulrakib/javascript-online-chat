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

public partial class Chat_Pages_GetMessages : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string ToUserID = this.Request["ToUserID"];
        string RoomID = this.Request["RoomID"];
        string FromUserID = this.Session["ChatUserID"].ToString();
        string ToUserName = string.Empty;
        string FromUserName = this.Session["ChatUsername"].ToString();

        LinqChatDataContext db = new LinqChatDataContext();

        var msgList = from m in db.Messages
                      where m.RoomID == int.Parse(RoomID)
                      && (m.UserID == int.Parse(FromUserID) || m.UserID == int.Parse(ToUserID)) 
                      && (m.ToUserID == int.Parse(ToUserID) ||m.ToUserID == int.Parse(FromUserID))
                      select m;

        var toUser = (from tou in db.Users
                      where tou.UserID == int.Parse(ToUserID)
                      select tou).SingleOrDefault();

        ToUserName = toUser.Username;
        
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        foreach (var chatmsg in msgList)
        {
            if (chatmsg.ToUserID == int.Parse(FromUserID))
            {
                chatmsg.MessageStatus = "read";
                db.SubmitChanges();
            }
            
            string name = chatmsg.UserID == int.Parse(FromUserID) ? "<strong>Me:</strong>" : "<strong>" + ToUserName + ":</strong>";

            sb.Append("<span>" + name + chatmsg.Text + "</span><br>");
        }

        Response.Write(sb.ToString());

        Response.End();
    }
}
