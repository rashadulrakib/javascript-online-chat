<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserList.ascx.cs" Inherits="Chat_UserControls_UserList" %>
<link href="Chat/CSS/Chat.css" rel="stylesheet" type="text/css" />
<input type="hidden" id="hfchatUserName" value='<%= Session["ChatUsername"].ToString()%>' />
<input type="hidden" id="hfchatRoomID" value='<%= Request["roomId"]%>' />
<script type="text/javascript" src="Chat/Javascript/dom-drag.js"></script>
<script type="text/javascript">
    
    //Initialization
    
    var flagAjaxCall = true;
    //var flagAjaxShowMessageInclient = false;
    var maxChatWindow = 3;
    
    var userisactive = new Array(maxChatWindow);
    var circularfunctionref = new Array(maxChatWindow);
    var isLogoutFromChat = false;
    var userlistrefreshtime = 4000;
    var messageboxrefreshtime = 10000;
    
    //End Initialization
    
    function GetXmlHttpRequest()
    {
        var xmlhttp;
        
        if (window.XMLHttpRequest)
        {
          // code for IE7+, Firefox, Chrome, Opera, Safari
          xmlhttp=new XMLHttpRequest();
          }
        else if (window.ActiveXObject)
          {
          // code for IE6, IE5
          xmlhttp=new ActiveXObject('Microsoft.XMLHTTP');
          }
        else
          {
          alert('Your browser does not support XMLHTTP!');
          }
          
          return xmlhttp;
    }
    
    function doBlink() 
    {
	    var blink = document.all.tags("blink");
	    for (var i=0; i<blink.length; i++)
	    {
	        if( blink[i].style.visibility == "")
	        {
	             blink[i].style.visibility="hidden";
	        }
	        else
	        {
	            blink[i].style.visibility="";
	        }
	        //blink[i].style.backgroundColor = "#660033";
	    }
    }

    function startBlink() 
    {
	    if (document.all)
		    setInterval("doBlink()",500);
    }
    
    function updateUserList()
    {
        var xmlhttp = GetXmlHttpRequest();
        var t;
       
        xmlhttp.onreadystatechange=function()
        {
            if(xmlhttp.readyState==4)
            {
                var objshowalluser = document.getElementById('showalluser');
                
                var response = xmlhttp.responseText;
                
                //                var elements = GetElemnts('div',objshowalluser);
                //               
                //                for(var i=0;i<elements.length;i++)
                //                {
                //                    openChatWindow(elements[i],false);
                //                }
                
                if(response == "Logout")
                {
                    isLogoutFromChat = true;
                    
                    alert("You are loggedout from chat!!!");
                    objshowalluser.innerHTML="<strong>You are loggedout from chat!!!</strong>";
                    clearTimeout(t);   
                    for(var i=0; i<circularfunctionref.length;i++)
                    {
                        if(circularfunctionref[i])
                        {
                             userisactive[i] = false;
                             clearTimeout(circularfunctionref[i]);
                        }
                    }
                }
                else
                {
                     //alert(prevoius);
                     
                     /**Check user is in previous but not in current rsponse*/
                     /*var prevelements = GetElemnts('div',objshowalluser);
                     objshowalluser.innerHTML= response;
                     var currentelements = GetElemnts('div',objshowalluser);
                     
                     for(var i=0;i<prevelements.length;i++)
                     {
                        var getflag = false;
                        var prevelemntid=prevelements[i].id;
                        
                        for(var j=0;j<currentelements.length;j++)
                        {
                            if(prevelements[i].id==currentelements[j].id)
                            {
                                getflag=true;
                                break;
                            }    
                        }
                        
                        if(!getflag)
                        {
                            var userid = GetUserIDFromContolID(prevelemntid);
                            userisactive[userid] =false;
                            alert("update user list div:" + userisactive[userid]);
                            clearTimeout(circularfunctionref[userid]);
                        }
                    }*/
                    objshowalluser.innerHTML= response;
                    t = setTimeout('updateUserList()', userlistrefreshtime);
                }
            }
        }
      
        xmlhttp.open("POST","chat/Pages/PopulateAllUserList.aspx?roomId="+document.getElementById("hfchatRoomID").value,true);
        xmlhttp.send(null);
    }
    
    function detectBrowser()
    {
        var browser=navigator.appName;
        var b_version=navigator.appVersion;
        var version=parseFloat(b_version);

        return browser;
    }
    
    function showhidealluser()
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
    }
    
    function openChatWindow(objdiv,iscallshowhide)
    {
        if(iscallshowhide)
        {
            showhidealluser();
        }
        
        var objchatWindow = document.getElementById('chatWindow');
        createNewDiv('chat_'+objdiv.id,objchatWindow);
    }
    
    function createNewDiv(divname,container)
    {
        //main chat window for each user
       //alert(IsExistControl(divname,"div"));
        
        var totaldivs = CountNumberofElements("div", container); 
        totaldivs = totaldivs/2; //<div>main div<div>message div</div></div>         
        
        if(totaldivs<maxChatWindow && IsExistControl(divname,"div")==false)
        {
            var newdiv = document.createElement('div');
            var divIdName = divname;
            newdiv.setAttribute('id',divIdName);

            newdiv.style.borderStyle = 'solid';
            newdiv.style.borderWidth ='thin';
            newdiv.style.width = '210px';
            newdiv.style.height = '150px';
            //newdiv.style.cssFloat = 'left';
            newdiv.style.overflow = 'auto';
            var leftpos = totaldivs*210;
            newdiv.style.left = leftpos.toString()+"px";
            newdiv.style.position = 'absolute';
            
            createNewTitle("span_"+divname,newdiv);
            createNewMessageBoxDiv("div_"+divname,newdiv);
            createNewTextBox("txt_"+divname,newdiv,"'div_"+divname+"'");
            createNewButton("btn_"+divname,newdiv,"'div_"+divname+"'","'txt_"+divname+"'");
            
            Drag.init(newdiv);
            
            container.appendChild(newdiv);
        }
        else
        {
            if(totaldivs>=maxChatWindow)
            {
                alert("You can chat with maximum "+maxChatWindow+" persons");
            }
        }
    }
    
    function createNewTitle(spanname,container)
    {
        //span_chat_div_u2_2
        var newspan= document.createElement('span');
              
        newspan.setAttribute('id',spanname);
        
//        var strspanname = new String();
//        strspanname = spanname;
//        strspanname = strspanname.substring(0,strspanname.lastIndexOf("_")); //span_chat_div_u2
//      
//        strspanname = strspanname.substring(strspanname.lastIndexOf("_")+1);
        
        var tousername = GetUserNameFromContolID(spanname);
       
        newspan.innerHTML="<strong>" + tousername +"</strong>";
        
        newspan.style.width = '100%';
        newspan.style.backgroundColor = 'gray';
        //newspan.onmouseover = new Function("alert('adadad');");
        
        var newspanCross = document.createElement('span');
        newspanCross.style.position = "absolute";
        newspanCross.style.right = "1px";
        newspanCross.innerHTML= "<strong>X</strong>";
        newspanCross.style.cursor = "pointer";
        newspanCross.onclick = new Function("removeElement('"+container.id +"')");
        
        //var newspanSpace = document.createElement('span');
        //var spacestr = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        //newspanSpace.innerHTML= spacestr+spacestr+spacestr;
        
        container.appendChild(newspan);
        //container.appendChild(newspanSpace);
        container.appendChild(newspanCross);
    }
    
    function removeElement(toremoveDivid)
    {
         var objchatWindow = document.getElementById('chatWindow');
         var objremoveDiv = document.getElementById(toremoveDivid);
         
         //flagAjaxShowMessageInclient=false;
         userisactive[GetUserIDFromContolID(objremoveDiv.id)]=false;
         clearTimeout(circularfunctionref[GetUserIDFromContolID(objremoveDiv.id)]);
         
         objchatWindow.removeChild(objremoveDiv);
         
         RepositionChatDivs(objchatWindow);   
    }
    
    function RepositionChatDivs(container)
    {
         var elements = GetElemnts("div",container);
         var parentdivcounter = 0;
         
         for(var i=0;i<elements.length;i++ )
         {
            var childdivs = GetElemnts("div",elements[i]); //find child div of a parent
         
            if(childdivs.length>0) //the element is the parent element
            {
                var leftpos = parentdivcounter*210;
                
                elements[i].style.left = leftpos.toString()+"px";
                parentdivcounter=parentdivcounter+1;
            }
        }
    }
    
    function createNewMessageBoxDiv(messagedivname,container)
    {
        var newdiv= document.createElement('div');
      
        newdiv.setAttribute('id',messagedivname);
        
        newdiv.innerHTML = "";
        
        newdiv.style.backgroundColor = '#E5EECC';
        newdiv.style.height = '100px';
        newdiv.style.overflow = 'auto';
        
        //var newdivstr = new String();
        //newdivstr = newdiv.id.toString();
        
        //ShowMessageInClientFromServer(newdivstr.substring(newdivstr.lastIndexOf("_")+1),newdiv);
        ShowMessageInClientFromServer(GetUserIDFromContolID(newdiv.id),newdiv);
        
        container.appendChild(newdiv);
    }
    
    function CountNumberofElements(ctrltype,container)
    {
        var items = container.getElementsByTagName(ctrltype);    
   
        return items.length;
    }
    
    function GetElemnts(ctrltype,container)
    {
        return container.getElementsByTagName(ctrltype);
    }
    
    function ContiousCallShowMessageInClientFromServer(touserid,msgdiv)
    {
        //if(flagAjaxShowMessageInclient)
        //alert(userisactive[touserid]+":"+touserid);
        if(userisactive[touserid]==true)
        {
            var functionRef = setTimeout(function() {ShowMessageInClientFromServer(touserid,msgdiv)}, messageboxrefreshtime);
            circularfunctionref[touserid] = functionRef;
            
            //flagAjaxShowMessageInclient = false;
            userisactive[touserid]=false;
        }
    }
    
    function createNewTextBox(txtboxname,container,msgcontaindivid)
    {
        var newtxtbox = document.createElement('input');
        newtxtbox.setAttribute('id',txtboxname);
        newtxtbox.setAttribute('type',"text");
       
        newtxtbox.style.width = '140px';
        
        var txtValue = new String();
        txtValue = newtxtbox.id+":"+msgcontaindivid.toString().replace("'","").replace("'","");
        //touserid will get from newtxtbox.id & message will get from newtxtbox.value
        
        var browsername = detectBrowser();
        
        if(browsername=="Netscape")
        {
            newtxtbox.setAttribute("onkeypress","return DisplayAndSendOnKeyPress(event,'"+txtValue+"');");
        }
        else
        {
            newtxtbox.onkeypress = new Function("return DisplayAndSendOnKeyPress(event,'"+txtValue+"');");
        }
        
        newtxtbox.onclick = new Function("setfocusOnTextBox(this);");
        
        container.appendChild(newtxtbox);
    }
    
    function setfocusOnTextBox(txtboxobj)
    {
        txtboxobj.focus();
    }
    
    function createNewButton(buttonname,container,msgcontaindivid,msgcontaintxtboxid)
    {
        var newbutton = document.createElement('input');
        newbutton.setAttribute('id',buttonname);
        newbutton.setAttribute('type','button');
        newbutton.setAttribute('value','Send');
     
        newbutton.onclick = new Function("return DisplayAndSend(this,"+msgcontaindivid+","+msgcontaintxtboxid +");");
        
        newbutton.style.width = '45px';
           
        container.appendChild(newbutton);
    }
    
    function DisplayAndSend(btnObj,msgcontaindivid,msgcontaintxtboxid)
    {
        var objdiv = document.getElementById(msgcontaindivid);
        var objtxt = document.getElementById(msgcontaintxtboxid);
        
        if(objtxt.value!="" && !isLogoutFromChat)
        {
            //SaveMessageIntoDatabase(txtboxid.substring(txtboxid.lastIndexOf("_")+1),objtxt.value,msgcontaindivid);
            SaveMessageIntoDatabase(GetUserIDFromContolID(btnObj.id),objtxt.value,msgcontaindivid);
            
            objdiv.innerHTML=objdiv.innerHTML+"<br>"+objtxt.value;
            objtxt.value="";
        }
        else
        {
            if(isLogoutFromChat)
            {
                alert("You are logged out from chat!!!");
            }
        }
        
        return false;
    } 
    
    function DisplayAndSendOnKeyPress(e,txtvalue)
    {
        var strarr = txtvalue.split(":");
        var txtboxid;
        var msgcontaindivid;
        if(strarr.length==2)
        {
             txtboxid = strarr[0];
             msgcontaindivid = strarr[1];
        }
        
        var charCode;
    
        if(e && e.which)
        {
            charCode = e.which;
        }
        else if(window.event)
        {
            e = window.event;
            charCode = e.keyCode;
        }

        if(charCode == 13) 
        {
            if(strarr.length==2)
            {
                var objdiv = document.getElementById(msgcontaindivid);
                var objtxt = document.getElementById(txtboxid);
            
               if(objtxt.value!="" && !isLogoutFromChat)
                {
                    SaveMessageIntoDatabase(GetUserIDFromContolID(objtxt.id),objtxt.value,msgcontaindivid);
                
                    objdiv.innerHTML=objdiv.innerHTML+"<br>"+objtxt.value;
                    objtxt.value="";
                }
                else
                {
                    if(isLogoutFromChat)
                    {
                        alert("You are logged out from chat!!!");
                    }
                }
            }
            else
            {
                alert("Could not send message by Enter!!!");
            }
            
            return false;
        }
    }
    
    function GetUserIDFromContolID(ctrlid) //last value of the control will be user id
    {
        var ctrlidstr = new String();
        ctrlidstr = ctrlid.toString();
        return ctrlidstr.substring(ctrlidstr.lastIndexOf("_")+1);
    }
    
    function GetUserNameFromContolID(ctrlid)
    {
        var strname = new String();
        strname = ctrlid.toString();
        strname = strname.substring(0,strname.lastIndexOf("_")); //span_chat_div_u2
        strname = strname.substring(strname.lastIndexOf("_")+1); 
        
        return strname;  
    }
    
    function IsExistControl(ctrlid,ctrltype)
    {
        var allctrls = document.getElementsByTagName(ctrltype);
        for (var i = 0; i < allctrls.length; i++) 
        {
            if (allctrls[i].id == ctrlid) 
            {
                return true;
            }
        }
        return false;
    }
    
    function SaveMessageIntoDatabase(touserid,message,msgcontaindivid)
    {
        //alert(message);
        var xmlhttp=GetXmlHttpRequest();
      
        xmlhttp.onreadystatechange=function()
        {
            if(xmlhttp.readyState==4)
            {
                var divobj = document.getElementById(msgcontaindivid);
                
                divobj.innerHTML= xmlhttp.responseText;
                             
                divobj.scrollTop = divobj.scrollHeight;
            }
        }
      
        xmlhttp.open("POST","chat/Pages/SaveMessage.aspx?ToUserID="+touserid+"&Message="+message+"&RoomID="+document.getElementById("hfchatRoomID").value,true);
        xmlhttp.send(null);
    }
    
    function ShowMessageInClientFromServer(touserid,msgdiv)
    {
        var xmlhttp=GetXmlHttpRequest();
          
          //alert(xmlhttp);
        xmlhttp.onreadystatechange=function()
        {
            if(xmlhttp.readyState==4)
            {
                //alert("update msg div:" + userisactive[touserid]);
                var prevresponse = msgdiv.innerHTML;
                //alert(prevresponse);
                var currentresponse = xmlhttp.responseText;
                //alert(currentresponse);
              
//                var flagMefoundPrev = false;
//                var flagMefoundCurrent = false;  
//                
//                if(prevresponse.indexOf("Me:")>=0)
//                {
//                    flagMefoundPrev=true;
//                }
//                
//                if(currentresponse.indexOf("Me:")>=0)
//                {
//                    flagMefoundCurrent=true;
//                }
                
                /*if(flagMefoundPrev && !flagMefoundCurrent)
                {
//                    if(prevresponse.indexOf("logged out")<0)
//                    {
//                        msgdiv.innerHTML= prevresponse+"<i><b>"+GetUserNameFromContolID(msgdiv.id)+" is logged out    !!!</b></i><br>";                  
//                    }
//                    else
                    //{
                       
                    //}
                }    
                else
                {
                    msgdiv.innerHTML = currentresponse;
                }*/
                
//                if(currentresponse!="" && prevresponse.toUpperCase()!=currentresponse.toUpperCase())
//                {
//                    if(prevresponse.indexOf(currentresponse)<0 && currentresponse.indexOf(prevresponse)<0)
//                    {
//                        msgdiv.innerHTML = prevresponse+ currentresponse;
//                    }
//                    else
//                    {
//                        msgdiv.innerHTML = prevresponse;
//                    }
//                }
//                else
//                {
//                    msgdiv.innerHTML = prevresponse;
//                }
                msgdiv.innerHTML = currentresponse;
                msgdiv.scrollTop = msgdiv.scrollHeight;
                userisactive[touserid]= true;
                //flagAjaxShowMessageInclient = true;
                ContiousCallShowMessageInClientFromServer(touserid,msgdiv);
            }
        }
      
        xmlhttp.open("POST","chat/Pages/GetMessages.aspx?ToUserID="+touserid+"&RoomID="+document.getElementById("hfchatRoomID").value,true);
        xmlhttp.send(null);
    }
    
</script>
<div style="position:fixed; bottom:0px; left:0px; width:100%">
<div id="spanAllUserList" style="width: 200px; border-style: solid; border-width: thin;
    border-bottom: none; background-color: #FEDEEB;">
    </div>
<div class="chatWindowContainer">
    <div id="showalluser" class="leftUserList">
        <asp:Literal ID="ltrlUserList" runat="server"></asp:Literal>
    </div>
    <div id="chatWindow" class="righChatWindow">
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
    document.getElementById('showalluser').style.visibility='hidden';
    document.getElementById('spanAllUserList').innerHTML = "Me as: " + document.getElementById('hfchatUserName').value;
    document.getElementById('spanAllUserList').style.visibility = 'hidden';
    startBlink();
</script>
