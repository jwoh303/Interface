// Design Team 
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
// Design Team 

function openQueue(queueName){
	var serverName = document.QueueManagerForm.server.value;
	var myWin = window.open("/uComposer/queueManagerDetail.do?queueName=" + queueName 
							+ "&serverName=" + serverName, "openWin1",  
            "width=650,height=500,toolbar=no,scrollbars=yes");
}

function openWindow(url)
{
	var winWidth = "550";
	var winHeight = "300";
	var winPosLeft = (screen.width - winWidth) / 2;
	var winPosTop = (screen.height - winHeight) / 2;
	var winSize = "width=" + winWidth + ",height=" + winHeight + ",top=" + winPosTop + ",left=" + winPosLeft;
	var winOption = "status=yes,toolbar=no,menubar=no,resizable=no,scrollbars=no";
	paramOption = winSize + ", " + winOption;
	
	popupWin = window.open(url,"openWinXX", paramOption );
}

function excelExport()
{
	return "/EAI2/INT/JMS/jboss/server/webmon/file/sample.xls";
}

function ConfirmChoice(loc,mesg){
        answer = confirm(mesg);
        if (answer !=0){
                location = loc;
        }
}

function show_calendar(str_target, str_datetime) {
	var arr_months = ["January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"];
	var week_days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
	var n_weekstart = 1; 

	var dt_datetime = (str_datetime == null || str_datetime =="" ?  new Date() : str2dt(str_datetime));

	var dt_prev_month = new Date(dt_datetime);//
	dt_prev_month.setMonth(dt_datetime.getMonth()-1);

	var dt_next_month = new Date(dt_datetime);//
	dt_next_month.setMonth(dt_datetime.getMonth()+1);

	var dt_firstday = new Date(dt_datetime);
	dt_firstday.setDate(1);
	dt_firstday.setDate(1-(7+dt_firstday.getDay()-n_weekstart)%7);
	var dt_lastday = new Date(dt_next_month);
	dt_lastday.setDate(0);
	
	var str_buffer = new String (
		"<html>\n"+
		"<head>\n"+
		"	<title>Calendar</title>\n"+
		"</head>\n"+
		"<body bgcolor=\"White\">\n"+
		"<table class=\"clsOTable\" cellspacing=\"0\" border=\"0\" width=\"100%\">\n"+
		"<tr><td bgcolor=\"#4682B4\">\n"+
		"<table cellspacing=\"1\" cellpadding=\"3\" border=\"0\" width=\"100%\">\n"+
		"<tr>\n	<td bgcolor=\"#4682B4\"><a href=\"javascript:window.opener.show_calendar('"+
		str_target+"', '"+ dt2dtstr(dt_prev_month)+"'+document.cal.time.value);\">"+
		"<img src=\"prev.gif\" width=\"16\" height=\"16\" border=\"0\""+
		" alt=\"previous month\"></a></td>\n"+
		"	<td bgcolor=\"#4682B4\" colspan=\"5\">"+
		"<font color=\"white\" face=\"tahoma, verdana\" size=\"2\">"
		+arr_months[dt_datetime.getMonth()]+" "+dt_datetime.getFullYear()+"</font></td>\n"+
		"	<td bgcolor=\"#4682B4\" align=\"right\"><a href=\"javascript:window.opener.show_calendar('"
		+str_target+"', '"+dt2dtstr(dt_next_month)+"'+document.cal.time.value);\">"+
		"<img src=\"next.gif\" width=\"16\" height=\"16\" border=\"0\""+
		" alt=\"next month\"></a></td>\n</tr>\n"
	);

	var dt_current_day = new Date(dt_firstday);
	str_buffer += "<tr>\n";
	for (var n=0; n<7; n++)
		str_buffer += "	<td bgcolor=\"#87CEFA\">"+
		"<font color=\"white\" face=\"tahoma, verdana\" size=\"2\">"+
		week_days[(n_weekstart+n)%7]+"</font></td>\n";
	str_buffer += "</tr>\n";
	while (dt_current_day.getMonth() == dt_datetime.getMonth() ||
		dt_current_day.getMonth() == dt_firstday.getMonth()) {
		str_buffer += "<tr>\n";
		for (var n_current_wday=0; n_current_wday<7; n_current_wday++) {
				if (dt_current_day.getDate() == dt_datetime.getDate() &&
					dt_current_day.getMonth() == dt_datetime.getMonth())
					str_buffer += "	<td bgcolor=\"#FFB6C1\" align=\"right\">";
				else if (dt_current_day.getDay() == 0 || dt_current_day.getDay() == 6)
					str_buffer += "	<td bgcolor=\"#DBEAF5\" align=\"right\">";
				else
					str_buffer += "	<td bgcolor=\"white\" align=\"right\">";

				if (dt_current_day.getMonth() == dt_datetime.getMonth())
					str_buffer += "<a href=\"javascript:window.opener."+str_target+
					".value='"+dt2dtstr(dt_current_day)+"'+document.cal.time.value; window.close();\">"+
					"<font color=\"black\" face=\"tahoma, verdana\" size=\"2\">";
				else 
					str_buffer += "<a href=\"javascript:window.opener."+str_target+
					".value='"+dt2dtstr(dt_current_day)+"'+document.cal.time.value; window.close();\">"+
					"<font color=\"gray\" face=\"tahoma, verdana\" size=\"2\">";
				str_buffer += dt_current_day.getDate()+"</font></a></td>\n";
				dt_current_day.setDate(dt_current_day.getDate()+1);
		}
		str_buffer += "</tr>\n";
	}
	str_buffer +=
		"<form name=\"cal\">\n<tr><td colspan=\"7\" bgcolor=\"#87CEFA\">"+
		"<font color=\"White\" face=\"tahoma, verdana\" size=\"2\">"+
		"Time: <input type=\"text\" name=\"time\" value=\""+dt2tmstr(dt_datetime)+
		"\" size=\"8\" maxlength=\"8\"></font></td></tr>\n</form>\n" +
		"</table>\n" +
		"</tr>\n</td>\n</table>\n" +
		"</body>\n" +
		"</html>\n";

	var vWinCal = window.open("", "Calendar", 
		"width=200,height=250,status=no,resizable=yes,top=200,left=200");
	vWinCal.opener = self;
	var calc_doc = vWinCal.document;
	calc_doc.write (str_buffer);
	calc_doc.close();
}
function str2dt (str_datetime) {
//	var re_date = /^(\d+)\-(\d+)\-(\d+)\s+(\d+)\:(\d+)\:(\d+)$/;
	var re_date = /^(\d+)\-(\d+)\-(\d+)\s+(\d+)\:(\d+)\:(\d+)$/;
	if (!re_date.exec(str_datetime))
		return alert("??? ????? ???? : "+ str_datetime);
//	return (new Date (RegExp.$3, RegExp.$2-1, RegExp.$1, RegExp.$4, RegExp.$5, RegExp.$6));
	return (new Date (RegExp.$1, RegExp.$2-1, RegExp.$3, RegExp.$4, RegExp.$5, RegExp.$6));
}
function dt2dtstr (dt_datetime) {
	return (new String (
//			dt_datetime.getDate()+"-"+(dt_datetime.getMonth()+1)+"-"+dt_datetime.getFullYear()+" "));
			dt_datetime.getFullYear()+"-"+(dt_datetime.getMonth()+1)+"-"+dt_datetime.getDate()+" "));
}
function dt2tmstr (dt_datetime) {
	return (new String (
			dt_datetime.getHours()+":"+dt_datetime.getMinutes()+":"+dt_datetime.getSeconds()));
}

function selectAllListenerClicked(){
        var i=0;
        var j=0;
        var selectAllbox=document.getElementById('selectall_list');
        var state = selectAllbox.checked;
        while(j!=1){
                var checkboxObj = document.getElementById('l'+i);
                if(checkboxObj==null){
                        j=1;
                }else{
                        var checkboxvalue = checkboxObj.value;
                        i++;
                        if(checkboxvalue==null){
                                j=1;
                        }
                        if(checkboxObj.disabled==false){
                                checkboxObj.checked=state;
                        }
                }
        }
}

function upperCase(str) {
    if (str.length = 0 ) return "";
    else return str;
    //.toUpperCase();
}

function InputFieldSetNum(obj){
	val=obj.value;
	
	if(isNaN(val)) { 
		alert("Number Field!!!"); 
	}
	
	re=/[^0-9]/gi;
	obj.value = val.replace(re, "");
} 
 
