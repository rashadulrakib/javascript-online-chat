<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChatContainer.aspx.cs" Inherits="ChatContainer" %>

<%@ Register Src="~/Chat/UserControls/UserList.ascx" TagName="UserList" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test Ajax Chat</title>
</head>
<body style="margin-left:0px; margin-bottom:0px; margin-right:0px; margin-top:0px">
    <form id="form1" runat="server">
    <div style="height:880px; text-align:right">
        <asp:LinkButton ID="linkLogout" runat="server" onclick="linkLogout_Click">Logut</asp:LinkButton>
    </div>
   <div style="cursor:crosshair">sadsadsadsadsadsadsadsadsadddaasdsadsadsad</div>
    <uc1:UserList ID="UserList1" runat="server" />
    
    </form>
</body>
</html>
