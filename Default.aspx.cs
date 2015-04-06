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

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DeleteLoggedInUser(); //assume that after logot default.aspx will be called
            //DeleteReceivedChatMessage();
            DeleteUnusedMessages();
            
            Session.RemoveAll();
            Session.Abandon();
        }
    }

    protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
    {
        LinqChatDataContext db = new LinqChatDataContext();

        var user = (from u in db.Users
                    where u.Username == Login1.UserName
                    && u.Password == Login1.Password
                    select u).SingleOrDefault();

        if (user != null)
        {
            e.Authenticated = true;
            Session["ChatUserID"] = user.UserID;
            Session["ChatUsername"] = user.Username;
        }
        else
        {
            e.Authenticated = false;
        }
    }
    protected void Login1_LoggedIn(object sender, EventArgs e)
    {
        DeleteOtherSessionsOfSameUser();

        SaveCurrentLoggedInUser();

        Response.Redirect("ChatContainer.aspx?roomId=1");
    }
    private void DeleteLoggedInUser()
    {
        // log out the user by deleting from the LoggedInUser table

        if (Session["ChatUserID"] != null)
        {
            LinqChatDataContext db = new LinqChatDataContext();

            int userid = int.Parse(Session["ChatUserID"].ToString());

            var loggedInUser = (from l in db.LoggedInUsers
                                where l.UserID == userid
                                && l.UserSessionID == Session.SessionID
                                select l).SingleOrDefault();
            
            if (loggedInUser != null)
            {
                db.LoggedInUsers.DeleteOnSubmit(loggedInUser);
                db.SubmitChanges();
            }
        }
    }

    private void DeleteOtherSessionsOfSameUser()
    {
        if (Session["ChatUserID"] != null)
        {
            LinqChatDataContext db = new LinqChatDataContext();

            int userid = int.Parse(Session["ChatUserID"].ToString());
         
            var loggedInSameUsers = (from l in db.LoggedInUsers
                                where l.UserID == userid
                                select l);
            foreach (var loggedInUser in loggedInSameUsers)
            {
                db.LoggedInUsers.DeleteOnSubmit(loggedInUser);
                db.SubmitChanges();
            }
        }
    }

    private void SaveCurrentLoggedInUser()
    {
        if (Session["ChatUserID"] != null)
        {
            LinqChatDataContext db = new LinqChatDataContext();

            // let's check if this authenticated user exist in the
            // LoggedInUser table (means user is logged-in to this room)

            int userid = int.Parse(Session["ChatUserID"].ToString());
            
            var user = (from u in db.LoggedInUsers
                        where u.UserID == userid
                        select u).SingleOrDefault();

            // if user does not exist in the LoggedInUser table
            // then let's add/insert the user to the table
            if (user == null)
            {
                LoggedInUser loggedInUser = new LoggedInUser();
                loggedInUser.UserID = userid;
                loggedInUser.RoomID = 1; //default room 1
                loggedInUser.UserSessionID = Session.SessionID;
                db.LoggedInUsers.InsertOnSubmit(loggedInUser);
                db.SubmitChanges();
            }  
        }
    }

    private void DeleteReceivedChatMessage()
    {
        if (Session["ChatUserID"] != null)
        {
            LinqChatDataContext db = new LinqChatDataContext();

            // let's check if this authenticated user exist in the
            // LoggedInUser table (means user is logged-in to this room)

            int userid = int.Parse(Session["ChatUserID"].ToString());

            var messages = from m in db.Messages
                           where m.RoomID == 1
                           && m.ToUserID == userid
                           select m;

            // if user does not exist in the LoggedInUser table
            // then let's add/insert the user to the table
            foreach (var message in messages)
            {
                db.Messages.DeleteOnSubmit(message);
                db.SubmitChanges();
            }
         }
    }

    private void DeleteUnusedMessages()
    {
        if (Session["ChatUserID"] != null)
        {
            int userid = int.Parse(Session["ChatUserID"].ToString());


        }
    }
}   
