   <!--ChatControl-->
       
                
<link href="../../Chat/CSS/Chat.css" rel="stylesheet" type="text/css" />

<input type="hidden" id="hfchatUserName" value='chatuser2' />

<input type="hidden" id="hfchatRoomID" value='1' />




<script language="JavaScript" type="text/javascript" src="../../Chat/Javascript/core.js"></script>
<script language="JavaScript" type="text/javascript" src="../../Chat/Javascript/events.js"></script>
<script language="JavaScript" type="text/javascript" src="../../Chat/Javascript/css.js"></script>
<script language="JavaScript" type="text/javascript" src="../../Chat/Javascript/coordinates.js"></script>
<script language="JavaScript" type="text/javascript" src="../../Chat/Javascript/drag.js"></script>


<script type="text/javascript">

    //Initialization
    var totaldivs = 0;
    
    var flagAjaxCall = true;
    //var flagAjaxShowMessageInclient = false;
    var maxChatWindow = 15;

    var userisactive = new Array(maxChatWindow);
    var circularfunctionref = new Array(maxChatWindow); //for getmsg calling
    var isLogoutFromChat = false;
    var userlistrefreshtime = 10000;
    var messageboxrefreshtime = 5000;
    var blinkrefreshtime = 1000;
    //var msgcharlength=10;

    //End Initialization

    function GetXmlHttpRequest() {
        var xmlhttp;

        if (window.XMLHttpRequest) {
            // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) {
            // code for IE6, IE5
            xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
        }
        else {
            alert('Your browser does not support XMLHTTP!');
        }

        return xmlhttp;
    }

    function doBlink() {
        var blink = document.all.tags("blink");
        for (var i = 0; i < blink.length; i++)
            blink[i].style.visibility = blink[i].style.visibility == "" ? "hidden" : "";

        //{
            //if (blink[i].style.visibility == "") {
            //    blink[i].style.display = "none";
            //}
            //else {
            //    blink[i].style.visibility = "";
            //}            
        //}
    }

    function startBlink() {
        if (document.all) {
            //alert(blinkrefreshtime);
            setInterval("doBlink()", blinkrefreshtime);
        }
    }

    function updateUserList() {
        var xmlhttp = GetXmlHttpRequest();
        var t;

        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4) {
                var objshowalluser = document.getElementById('showalluser');

                var response = xmlhttp.responseText;

                //                var elements = GetElemnts('div',objshowalluser);
                //               
                //                for(var i=0;i<elements.length;i++)
                //                {
                //                    openChatWindow(elements[i],false);
                //                }

                if (response == "Logout") {
                    isLogoutFromChat = true;

                    alert("You are loggedout from chat!!!");
                    objshowalluser.innerHTML = "<strong>You are loggedout from chat!!!</strong>";
                    clearTimeout(t);
                    for (var i = 0; i < circularfunctionref.length; i++) {
                        if (circularfunctionref[i]) {
                            userisactive[i] = false;
                            clearTimeout(circularfunctionref[i]);
                        }
                    }
                }
                else {
                    objshowalluser.innerHTML = response;
                    t = setTimeout('updateUserList()', userlistrefreshtime);
                }
            }
        }

        var params = "roomId=" + document.getElementById("hfchatRoomID").value;
        var url = "../../chat/Pages/PopulateAllUserList.aspx";
        xmlhttp.open("POST", url, true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.setRequestHeader("Content-Length", params.length);
        xmlhttp.send(params);

        //xmlhttp.open("POST","../../chat/Pages/PopulateAllUserList.aspx?roomId="+document.getElementById("hfchatRoomID").value,true);
        //xmlhttp.send(null);
    }

    function detectBrowser() {
        var browser = navigator.appName;
        //var b_version=navigator.appVersion;
        //var version=parseFloat(b_version);

        return browser;
    }

    /*function showhidealluser()
    {
    var objlabelShowAllUser = document.getElementById('labelShowAllUser');
    var objshowalluser = document.getElementById('showalluser');
      
    if(objshowalluser.style.visibility=='hidden')
    {
    objshowalluser.style.visibility='visible';
    document.getElementById('spanAllUserList').style.visibility = 'visible';
    objlabelShowAllUser.innerHTML='Hide all user';
    }
    else
    {
    objshowalluser.style.visibility='hidden';
    document.getElementById('spanAllUserList').style.visibility = 'hidden';
    objlabelShowAllUser.innerHTML='Show all user';
    }
        
    if(flagAjaxCall)
    {
    updateUserList();
            
    flagAjaxCall = false;
    }
    }*/

    function showhidealluser() {
        var objlabelShowAllUser = document.getElementById('labelShowAllUser');
        var objshowalluser = document.getElementById('showalluser');

        //alert(objshowalluser.style.display);

        if (objshowalluser.style.display == 'none') {
            objshowalluser.style.display = 'block';
            //objshowalluser.style.zIndex = 0;

            document.getElementById('spanAllUserList').style.display = 'block';
            //document.getElementById('spanAllUserList').style.zIndex = 0;

            objlabelShowAllUser.innerHTML = 'Hide all user';
        }
        else {
            objshowalluser.style.display = 'none';
            //objshowalluser.style.zIndex = -1;
            //objshowalluser.blur();

            document.getElementById('spanAllUserList').style.display = 'none';
            //document.getElementById('spanAllUserList').style.zIndex =-1;
            //document.getElementById('spanAllUserList').blur();

            objlabelShowAllUser.innerHTML = 'Show all user';
        }

        if (flagAjaxCall) {
            updateUserList();

            flagAjaxCall = false;
        }
    }

    function openChatWindow(objdiv, iscallshowhide) {
        if (iscallshowhide) {
            showhidealluser();
        }

        var objchatWindow = document.getElementById('chatWindow');
        createNewDiv('chat_' + objdiv.id, objchatWindow);
        //createCW(objchatWindow);        
    }
   
    function createNewDiv(divname, container) {
        //main chat window for each user
        //alert(IsExistControl(divname,"div"));

        //var totaldivs = CountNumberofElements("div", container);
        //totaldivs = totaldivs / 2; //<div>main div<div>message div</div></div>
        totaldivs++;
        if (totaldivs < maxChatWindow && IsExistControl(divname, "div") == false) {
            var newdiv = document.createElement('div');
            var divIdName = divname;
            newdiv.setAttribute('id', divIdName);
            //var leftPos = (totaldivs * 255);
            //var topPos = (totaldivs * 162) + 162;
            newdiv.style.cssText = "border:solid 1px; width:250px; height:160px;" 
                + "background-color:#ffffff;";//top:" + topPos.toString + 'px';
            
            //newdiv.style.left = leftpos.toString() + "px";
            //newdiv.style.position = 'absolute';
            
            createNewTitle("span_" + divname, newdiv);
            var newdiv1 = document.createElement('div');
            newdiv1.style.cssText = "padding:5px;padding-top:25px";
            createNewMessageBoxDiv("div_" + divname, newdiv1);
            createNewTextBox("txt_" + divname, newdiv1, "'div_" + divname + "'");
            createNewButton("btn_" + divname, newdiv1, "'div_" + divname + "'", "'txt_" + divname + "'");

            //Drag.init(newdiv);
            newdiv.appendChild(newdiv1);
            //container.style.cssText = "clear:both;position:absolute";
            container.appendChild(newdiv);

            //var boxHandle = document.getElementById('chat_' + objdiv.id);
            //var Handle = document.getElementById("span_" + divname);
            //alert(Handle);
            //boxHandle.style.cssText = "float: left;padding: 0px;width: 123px;height: 123px;margin: 5px;background-color: #eee;z-index: 1";
            //Handle.style.cssText = "cursor: move;height: 14px;border-width: 0px 0px 1px 0px;background: #666;color: #eee;padding: 2px 6px;margin: 0px;";
            //alert(document.getElementById("span_" + 'chat_' + objdiv.id));
            //group = drag.createSimpleGroup(boxHandle, Handle);
            //coordinates = ToolMan.coordinates();
            //drag = ToolMan.drag();
            
            //group = drag.createSimpleGroup(newdiv, document.getElementById("span_" + divname));
            
            var drag = ToolMan.drag();
	        drag.createSimpleGroup(newdiv, document.getElementById("span_" + divname));
	        
	        //var topPos = (totaldivs * 162) + 162;
	        //newdiv.style.top = "" + topPos.toString + "px";
            //RepositionChatDivs(newdiv);
            //var group;
            //var coordinates = ToolMan.coordinates();
            //var drag = ToolMan.drag();
            //var boxHandle = document.getElementById("boxHandle");
            //group = drag.createSimpleGroup(container, newdiv);
        }
        else {
            if (totaldivs >= maxChatWindow) {
                alert("You can chat with maximum " + maxChatWindow + " persons");
            }
        }
    }

    function createNewTitle(spanname, container) {
        //span_chat_div_u2_2
        var newspan = document.createElement('div');
        newspan.setAttribute('id', spanname);
        var tousername = GetUserNameFromContolID(spanname);
        newspan.innerHTML = "<strong>" + tousername + "</strong>";
        //newspan.innerHTML = " ";
        //newspan.style.width = '100%';
        //newspan.style.backgroundColor = 'gray';
        newspan.style.cssText = "cursor: move;color:white;width:100%;height:20px;background-color:gray;position:absolute";

        var newspanCross = document.createElement('div');
        newspanCross.setAttribute('id', 'cross');
        newspanCross.style.position = "absolute";
        newspanCross.style.right = "1px";
        newspanCross.style.color = "white";
        newspanCross.style.cursor = "pointer";
        newspanCross.innerHTML = "<strong>X</strong>";        
        newspanCross.onclick = new Function("removeElement('" + container.id + "')");

        //var newspanSpace = document.createElement('span');
        //var spacestr = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        //newspanSpace.innerHTML= spacestr+spacestr+spacestr;

        container.appendChild(newspan);
        //container.appendChild(newspanSpace);
        //newspanCross.cssText = "display:block;width:5px;height:5px;color:#ffffff; right:1px; top:1px; cursor:pointer;position:absolute";        
        container.appendChild(newspanCross);
    }

    function removeElement(toremoveDivid) {
        var objchatWindow = document.getElementById('chatWindow');
        var objremoveDiv = document.getElementById(toremoveDivid);
        //flagAjaxShowMessageInclient=false;
        userisactive[GetUserIDFromContolID(objremoveDiv.id)] = false;
        clearTimeout(circularfunctionref[GetUserIDFromContolID(objremoveDiv.id)]);
        objchatWindow.removeChild(objremoveDiv);
        //RepositionChatDivs(objchatWindow);
        totaldivs--;
    }

    function RepositionChatDivs(container) {
        var elements = GetElemnts("div", container);
        var parentdivcounter = 0;

        for (var i = 0; i < elements.length; i++) {
            var childdivs = GetElemnts("div", elements[i]); //find child div of a parent

            if (childdivs.length > 0) //the element is the parent element
            {
                var leftpos = parentdivcounter * 210;

                elements[i].style.left = leftpos.toString() + "px";
                parentdivcounter = parentdivcounter + 1;
            }
        }
    }

    function createNewMessageBoxDiv(messagedivname, container) {
        var newdiv = document.createElement('div');
        newdiv.setAttribute('id', messagedivname);
        newdiv.innerHTML = "";
        //newdiv.style.backgroundColor = '#ffffff';
        //newdiv.style.height = '100px';
        //newdiv.style.width = '240px';
        //newdiv.style.overflowY = 'auto';
        //newdiv.style.margin = '5px';
        newdiv.style.cssText = "margin:0px 0px 5px 0px;overflow-Y:auto;width:240px;height:100px;background-color:#ffffff";
        //newdiv.style.overflow = 'auto';        
        //newdiv.style.overflowX = 'visible';

        //var newdivstr = new String();
        //newdivstr = newdiv.id.toString();

        //ShowMessageInClientFromServer(newdivstr.substring(newdivstr.lastIndexOf("_")+1),newdiv);
        ShowMessageInClientFromServer(GetUserIDFromContolID(newdiv.id), newdiv);

        container.appendChild(newdiv);
    }

    function CountNumberofElements(ctrltype, container) {
        var items = container.getElementsByTagName(ctrltype);

        return items.length;
    }

    function GetElemnts(ctrltype, container) {
        return container.getElementsByTagName(ctrltype);
    }

    function ContiousCallShowMessageInClientFromServer(touserid, msgdiv) {
        //if(flagAjaxShowMessageInclient)
        //alert(userisactive[touserid]+":"+touserid);
        if (userisactive[touserid] == true) {
            var functionRef = setTimeout(function() { ShowMessageInClientFromServer(touserid, msgdiv) }, messageboxrefreshtime);
            circularfunctionref[touserid] = functionRef;

            //flagAjaxShowMessageInclient = false;
            userisactive[touserid] = false;
        }
    }

    function createNewTextBox(txtboxname, container, msgcontaindivid) {
        var newtxtbox = document.createElement('input');
        newtxtbox.setAttribute('id', txtboxname);
        newtxtbox.setAttribute('type', "text");

        newtxtbox.style.width = '140px';

        var txtValue = new String();
        txtValue = newtxtbox.id + ":" + msgcontaindivid.toString().replace("'", "").replace("'", "");
        //touserid will get from newtxtbox.id & message will get from newtxtbox.value

        var browsername = detectBrowser();

        if (browsername == "Netscape") {
            newtxtbox.setAttribute("onkeypress", "return DisplayAndSendOnKeyPress(event,'" + txtValue + "');");
        }
        else {
            newtxtbox.onkeypress = new Function("return DisplayAndSendOnKeyPress(event,'" + txtValue + "');");
        }

        newtxtbox.onclick = new Function("setfocusOnTextBox(this);");

        container.appendChild(newtxtbox);
    }

    function setfocusOnTextBox(txtboxobj) {
        txtboxobj.focus();
    }

    function createNewButton(buttonname, container, msgcontaindivid, msgcontaintxtboxid) {
        var newbutton = document.createElement('input');
        newbutton.setAttribute('id', buttonname);
        newbutton.setAttribute('type', 'button');
        newbutton.setAttribute('value', 'Send');

        newbutton.onclick = new Function("return DisplayAndSend(this," + msgcontaindivid + "," + msgcontaintxtboxid + ");");

        newbutton.style.width = '45px';

        container.appendChild(newbutton);
    }

    /*function GetMessageWithBR(message)
    {
    var returnMessage = new String();
    if (message.length == 0) return message;
    var messageArr = message.split(" ");
    for (var i = 0; i < messageArr.length; i++)
    {
    var j = 1;
    while (messageArr[i].length > (msgcharlength * j))
    {
    //messageArr[i] = messageArr[i].Insert(15 * j, "<BR />");
    messageArr[i] = messageArr[i].substring(0,msgcharlength * j) + "<BR />" + messageArr[i].substring(msgcharlength * j);
    j++;
    }
    returnMessage += messageArr[i];
    }
    //return returnMessage.Trim();
    return returnMessage;
    }*/

    function DisplayAndSend(btnObj, msgcontaindivid, msgcontaintxtboxid) {
        var objdiv = document.getElementById(msgcontaindivid);
        var objtxt = document.getElementById(msgcontaintxtboxid);

        if (objtxt.value != "" && !isLogoutFromChat) {
            //SaveMessageIntoDatabase(txtboxid.substring(txtboxid.lastIndexOf("_")+1),objtxt.value,msgcontaindivid);
            SaveMessageIntoDatabase(GetUserIDFromContolID(btnObj.id), objtxt.value, msgcontaindivid);

            //objdiv.innerHTML=objdiv.innerHTML+"<br>"+objtxt.value;
            //objdiv.innerHTML=objdiv.innerHTML+"<br>"+GetMessageWithBR(objtxt.value);
            objtxt.value = "";
        }
        else {
            if (isLogoutFromChat) {
                alert("You are logged out from chat!!!");
            }
        }

        return false;
    }

    function DisplayAndSendOnKeyPress(e, txtvalue) {
        var strarr = txtvalue.split(":");
        var txtboxid;
        var msgcontaindivid;
        if (strarr.length == 2) {
            txtboxid = strarr[0];
            msgcontaindivid = strarr[1];
        }

        var charCode;

        if (e && e.which) {
            charCode = e.which;
        }
        else if (window.event) {
            e = window.event;
            charCode = e.keyCode;
        }

        if (charCode == 13) {
            if (strarr.length == 2) {
                var objdiv = document.getElementById(msgcontaindivid);
                var objtxt = document.getElementById(txtboxid);

                if (objtxt.value != "" && !isLogoutFromChat) {
                    SaveMessageIntoDatabase(GetUserIDFromContolID(objtxt.id), objtxt.value, msgcontaindivid);

                    //objdiv.innerHTML=objdiv.innerHTML+"<br>"+objtxt.value;
                    //objdiv.innerHTML=objdiv.innerHTML+"<br>"+GetMessageWithBR(objtxt.value);
                    objtxt.value = "";
                }
                else {
                    if (isLogoutFromChat) {
                        alert("You are logged out from chat!!!");
                    }
                }
            }
            else {
                alert("Could not send message by Enter!!!");
            }

            return false;
        }
    }

    function GetUserIDFromContolID(ctrlid) //last value of the control will be user id
    {
        var ctrlidstr = new String();
        ctrlidstr = ctrlid.toString();
        return ctrlidstr.substring(ctrlidstr.lastIndexOf("_") + 1);
    }

    function GetUserNameFromContolID(ctrlid) {
        var strname = new String();
        strname = ctrlid.toString();
        strname = strname.substring(0, strname.lastIndexOf("_")); //span_chat_div_u2
        strname = strname.substring(strname.lastIndexOf("_") + 1);

        return strname;
    }

    function IsExistControl(ctrlid, ctrltype) {
        var allctrls = document.getElementsByTagName(ctrltype);
        for (var i = 0; i < allctrls.length; i++) {
            if (allctrls[i].id == ctrlid) {
                return true;
            }
        }
        return false;
    }

    function SaveMessageIntoDatabase(touserid, message, msgcontaindivid) {
        //alert(message);

        var xmlhttp = GetXmlHttpRequest();

        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4) {
                var divobj = document.getElementById(msgcontaindivid);
                //alert("save success");

                divobj.innerHTML = xmlhttp.responseText;

                divobj.scrollTop = divobj.scrollHeight;
            }
        }

        var params = "ToUserID=" + touserid + "&Message=" + message + "&RoomID=" + document.getElementById("hfchatRoomID").value;
        var url = "../../chat/Pages/SaveMessage.aspx";
        xmlhttp.open("POST", url, true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.setRequestHeader("Content-Length", params.length);
        xmlhttp.send(params);

        //xmlhttp.open("POST","../../chat/Pages/SaveMessage.aspx?ToUserID="+touserid+"&Message="+message+"&RoomID="+document.getElementById("hfchatRoomID").value,true);
        //xmlhttp.send(null);
    }

    function ShowMessageInClientFromServer(touserid, msgdiv) {
        var xmlhttp = GetXmlHttpRequest();

        //alert(xmlhttp);
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4) {
                //alert("update msg div:" + userisactive[touserid]);
                var prevresponse = msgdiv.innerHTML;
                //alert(prevresponse);
                var currentresponse = xmlhttp.responseText;
                //alert(currentresponse);
                msgdiv.innerHTML = currentresponse;
                msgdiv.scrollTop = msgdiv.scrollHeight;
                userisactive[touserid] = true;
                //flagAjaxShowMessageInclient = true;
                ContiousCallShowMessageInClientFromServer(touserid, msgdiv);
            }
        }

        var params = "ToUserID=" + touserid + "&RoomID=" + document.getElementById("hfchatRoomID").value;
        var url = "../../chat/Pages/GetMessages.aspx";
        xmlhttp.open("POST", url, true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.setRequestHeader("Content-Length", params.length);
        xmlhttp.send(params);

        //xmlhttp.open("POST","../../chat/Pages/GetMessages.aspx?ToUserID="+touserid+"&RoomID="+document.getElementById("hfchatRoomID").value,true);
        //xmlhttp.send(null);
    }
    

</script>


<div id="chatboxforfirefox" style="width:200px">
    <div id="spanAllUserList" style="width: 200px; border-style: solid; border-width: thin;
        border-bottom: none; background-color: #FEDEEB;">
    </div>
    <div class="chatWindowContainer">
        <div id="showalluser" class="leftUserList">
            <div id="div_chatuser1_139" onclick="openChatWindow(this,true);" onmouseover="this.style.backgroundColor='#84DFC1';" onmouseout="this.style.backgroundColor='#98BF21';" style='cursor: pointer;'><img src='../../Chat/Images/manIcon.gif' style='vertical-align:middle' alt=''><b>chatuser1</b></div>
        </div>

        <div id="chatWindow" class="righChatWindow" style="">
        </div>
    </div>
    <div style="border-style: solid; border-width: thin; width: 200px; background-color: #FEDEEB;"
        align="left">
        <div id="labelShowAllUser" style="cursor: pointer; width: 90px;" onclick="showhidealluser();">
            Show all user
        </div>
    </div>
</div>

<script type="text/javascript">
//    var group;
//    var coordinates = ToolMan.coordinates();
//    var drag = ToolMan.drag();
    
    //document.getElementById('showalluser').style.visibility='hidden';
    document.getElementById('showalluser').style.display = 'none';
    //document.getElementById('showalluser').style.zIndex=-1;
    //document.getElementById('showalluser').blur();

    document.getElementById('spanAllUserList').innerHTML = "Me as: " + document.getElementById('hfchatUserName').value;

    //document.getElementById('spanAllUserList').style.visibility = 'hidden';
    document.getElementById('spanAllUserList').style.display = 'none';
    //document.getElementById('spanAllUserList').style.zIndex=-1;
    //document.getElementById('spanAllUserList').blur();

    startBlink();

    var brnameforchat = navigator.appName;
    var b_versionforchat = navigator.appVersion;
    b_versionforchat = b_versionforchat.toString();
    //alert(b_versionforchat);
    //var versionforchat=parseFloat(b_versionforchat);

    if (brnameforchat == "Microsoft Internet Explorer" && b_versionforchat.indexOf("MSIE 6.0") != -1) {
        var chatboxid = document.getElementById("chatboxforfirefox");
        chatboxid.removeAttribute("id");
        chatboxid.setAttribute("id", "fixmetoo");        
    }
    else {
        var chatboxid = document.getElementById("chatboxforfirefox");
        chatboxid.style.width = "100%";
        chatboxid.style.position = "fixed";
        chatboxid.style.bottom = "0px";
        chatboxid.style.left = "0px";
    }
</script>


                
                <!--End ChatControl-->         
