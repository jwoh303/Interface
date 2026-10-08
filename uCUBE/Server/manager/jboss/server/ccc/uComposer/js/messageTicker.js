
// 마우스를 갖다대면 타이핑 치듯이 설명을 보여주는 자바 스크립트.
// onMouseOver="showmsg(메세지)"
// onMouseOut="hideticker()"
//아래의 줄을 추가 
//<DIV ID="tickerbg" style="position:absolute;"></DIV>
//<DIV ID="ticker" style="position:absolute;"></DIV> 


var tWidth=160;
var tHeight=50;
var tPadding=5;
var bWidth=2;
var font="굴림";
var fontsize=9;
var fontsizelastletter=9;
var fontcolor="008800";
var fontcolorlastletter="066807";
var fontweight=3;
var bgColor="CCFFCC";
var standstill=2000;
var speed=10;
var xdistance=15;
var ydistance=5;
var timer;
var x,y;
var i_substring=0;
var i_presubstring=0;
var i_msg=0;
var msg;
var msgcontent="";
var msgbackground="";
var msgpresubstring="";
var msgaftersubstring="";
fontweight=fontweight*100;

function s60divstyle(h,t) {
    var  cWid = document.body.clientWidth;
    var  cHig = document.body.clientHeight;

    document.write ('<style type="text/css">');
    document.write('#maintbl'+unescape('%7B')
                   +'width:'
                   +(cWid - 10)+'px'
                   +unescape('%7D')+'  ');
    document.write('.maindiv'+unescape('%7B')
                   +'position:absolute; margin:0; width:'
                   + (cWid - 20)
                   +'px;height:'
                   +(cHig - (130+h))
                   +'px; z-index:1; overflow-x:auto;overflow-y:hidden;'
                   +unescape('%7D')+'  ');
    document.write('.subdiv'+unescape('%7B')
                   +'height:'
                   +(cHig - (170 +h+t))
                   +'px; overflow-x:hidden; overflow-y:auto; overflow:auto;'
                   +unescape('%7D')+'  ');
    document.write('</style>');
}

function chkRetry(){
    if (is.ie) {
        return checkRetry();
    }
    return true;
}

function timeChk(sTime){
    var sw = 0;
    var st =sTime;
    var hh =st.substr(0,2);
    var mi =st.substr(3,2);
    if(!((parseInt(hh) >= 0 && parseInt(hh) < 24 ) && (parseInt(mi) >= 0 && parseInt(mi) < 60))) { sw=1; }
    if(st.length > 5 && st.length < 9) {
        var sec =st.substr(6,2);
        if(!((parseInt(sec) >= 0 && parseInt(sec) < 60))) { sw=1; }
    } 

    if(sw) { alert("시간은 00:00 ~ 23:59 로 입력해 주세요."); }
    return;
}

function openLoadding() {
	var xposition=200; var yposition=250;
	var wid=470;     var hig=270;
    xposition = (screen.width)?(screen.width-wid)/2 : xposition;
    yposition = (screen.height)?(screen.height-hig)/2 : yposition;
	var args="menubar=no,resizable=no" + ",width=" + wid + ",height=" + hig 
	     + ",left=" + xposition+ "," + "top=" + yposition;
    load = window.open("","loadding", args);
    load.location = "S600100001LoadPopUp.jsp";
}

function closeLoadding() {
    openLoadding();
    if(load) {
        load.close();
    }

}

// Browser ?
function ClientSnifferJr() {
    this.ua = navigator.userAgent.toLowerCase();
    this.major = parseInt(navigator.appVersion);
    this.minor = parseFloat(navigator.appVersion);
    this.nav = ( (this.ua.indexOf('mozilla')!=-1) && ((this.ua.indexOf('spoofer')==-1) && (this.ua.indexOf('compatible') == -1)) );
    this.nav2 = (this.nav && (this.major == 2));
    this.nav3 = (this.nav && (this.major == 3));
    this.nav4 = (this.nav && (this.major == 4));
    this.nav4up = (this.nav && (this.major >= 4));
    this.nav5 = (this.nav && (this.major == 5));
    this.nav5up = (this.nav && (this.major >= 5));
    this.ie = (this.ua.indexOf("msie") != -1);
    this.ie3 = (this.ie && (this.major == 2));
    this.ie4 = ( this.ie && (this.major == 4) && (this.ua.indexOf("msie 5.0")==-1) );
    this.ie4up = (this.ie && (this.major >= 4));
    this.ie5 = ( this.ie && (this.major == 4) && (this.ua.indexOf("msie 5.0")!=-1) );
    this.ie5up = (this.ie && !this.ie3 && !this.ie4);
    this.opera = (this.ua.indexOf("opera") != -1);
    this.webtv = (this.ua.indexOf("webtv") != -1); 
} 
var is = new ClientSnifferJr(); 
// END

function getmsgbackground() {
		msgbackground="<table border="+bWidth+" width="+tWidth+" height="+tHeight+" cellspacing=0 cellpadding=0><tr><td valign=top bgcolor='"+bgColor+"'>";
		msgbackground+="&nbsp;</td></tr></table>";
}

function getmsgcontent() {	
		msgcontent="<table border=0 cellspacing=0 cellpadding="+tPadding+" width="+tWidth+" height="+tHeight+"><tr><td valign=top>";
		msgcontent+="<span style='position:relative; font-family:"+font+";color:"+fontcolor+";font-size:"+fontsize+"pt;font-weight:"+fontweight+"'>"	;
		msgcontent+="<font color='"+fontcolor+"'>";
		msgcontent+=msgpresubstring;
		msgcontent+="</font>";
		msgcontent+="</span>";
		msgcontent+="<span style='position:relative; font-family:"+font+";color:"+fontcolor+";font-size:"+fontsizelastletter+"pt;font-weight:900'>"	;
		msgcontent+="<font color='"+fontcolorlastletter+"'>";
		msgcontent+=msgaftersubstring;
		msgcontent+="</font>";
		msgcontent+="</span>";
		msgcontent+="</td></tr></table>";
}

function showticker() {	
	if (i_substring<=msg.length-1) {
		i_substring++;
		i_presubstring=i_substring-1;
		if (i_presubstring<0) {i_presubstring=0;}
        msgpresubstring=msg.substring(0,i_presubstring);
        msgaftersubstring=msg.substring(i_presubstring,i_substring);
		getmsgcontent();

		if(document.getElementById){ // IE5, Mozilla
            var msgarea = document.getElementById("ticker");
            msgarea.innerHTML=msgcontent;
        } else if (document.all) {
			ticker.innerHTML=msgcontent;
		} else if (document.layers) {
			document.ticker.document.write(msgcontent);
			document.ticker.document.close();
		}
		
		timer=setTimeout("showticker()", speed);
	}
	else {
		clearTimeout(timer);
	}
}

function hideticker() {
    clearTimeout(timer);
    i_substring=0;
	i_presubstring=0;
	if(document.getElementById){ // IE5, Mozilla
        var vticker = document.getElementById("ticker");
        var vtickerbg = document.getElementById("tickerbg");
        
        vticker.style.visibility="hidden";
        vtickerbg.style.visibility="hidden";
    } else if (document.all) {
	    document.all.ticker.style.visibility="hidden";
        document.all.tickerbg.style.visibility="hidden";
	} else if (document.layers) {
		document.ticker.visibility="hidden";
        document.tickerbg.visibility="hidden";
	}
}

function showmsg(linkmsg) {
    getmsgbackground();
    msg=linkmsg;
   
	i_substring=0;
	i_presubstring=0;
    var leftposition=x+xdistance;
    var topposition=y+ydistance;
	if(document.getElementById){
        var vticker = document.getElementById("ticker");
        var vtickerbg = document.getElementById("tickerbg");
		vticker.style.left=leftposition+ "px";
		vticker.style.top=topposition+ "px";
		vtickerbg.style.left=leftposition+ "px";
		vtickerbg.style.top=topposition+ "px";
        vtickerbg.innerHTML=msgbackground;
        vticker.style.visibility="visible";
        vtickerbg.style.visibility="visible";
		showticker();
	} else if (document.all) {	
		document.all.ticker.style.posLeft=leftposition;
		document.all.ticker.style.posTop=topposition;
		document.all.tickerbg.style.posLeft=leftposition;
		document.all.tickerbg.style.posTop=topposition;
		tickerbg.innerHTML=msgbackground;
        document.all.ticker.style.visibility="visible";
        document.all.tickerbg.style.visibility="visible";
		showticker();
	} else if(document.layers) {
        document.ticker.left=leftposition;
		document.ticker.top=topposition;
		document.tickerbg.left=leftposition;
		document.tickerbg.top=topposition;
		document.tickerbg.document.write(msgbackground);
		document.tickerbg.document.close();
        document.ticker.visibility="visible";
        document.tickerbg.visibility="visible";
		showticker();
	}
}

function handlerMM(e){
    if (is.nav4up) {
        x = e.pageX;
        y = e.pageY;
    } else {
        x = window.event.clientX;
        y = window.event.clientY; 
    } 
//    window.status = "X="+x+" Y="+y;
    return true;
}

if (is.nav4up) {
   document.captureEvents(Event.MOUSEMOVE); 
} 
document.onmousemove=handlerMM; 
