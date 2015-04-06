<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Src="Chat/UserControls/UserList.ascx" TagName="UserList" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test Chat</title>
</head>
<body>
    <form id="formMain" runat="server">
    <div style="height: 200px; width: 100%">
    </div>
    <center>
        <div style="width: 100%">
            <asp:Login ID="Login1" runat="server" OnAuthenticate="Login1_Authenticate" OnLoggedIn="Login1_LoggedIn">
            </asp:Login>
        </div>
    </center>
    </form>
</body>
</html>
