
var common = {};
//저장할 데이터 추출(시트객체 , 체크박스 컬럼 , 저장될 컬럼을 "|"로 연결한 문자열 , 구분자(null이면 ‡) , 인코딩 여부) 
function getSaveColString(sheet,param){
	var chk = param.chk;
	var savecol = param.savecol;
	var separator = param.separator;
	var encode = param.encode;
	var sheetversion = false;
	
	
    //ibsheet 종류에 따른 LastRow, LastCol
    var lr,lc,hr;
    if(typeof(sheet.classid)=="undefined"){
    		sheetversion = true;
          lr = sheet.LastRow();
          lc = sheet.LastCol();
          hr = sheet.HeaderRows();
   } else{
	   		sheetversion = false;
          lr = sheet.LastRow;
          lc = sheet.LastCol;
          hr = sheet.HeaderRows;
   }
    if(lr==hr){
    	alert("저장할 데이터가 없습니다.");
    	return;
    }
	
	if(encode==null||typeof(encode)=="undefinede"){
		encode = true;
	}
    var cols = [],savenames = [];
   
    if(separator==null||typeof (separator)=="undefined"){
          separator = "‡";
   }
    //col 이 없는 경우 모든 컬럼의 값을 가져온다.
    if(savecol==null ||typeof(savecol)=="undefined"||savecol== ""){
           for(var i=0;i<=lc;i++){
                 cols.push(i);
                 savenames.push(sheet.ColSaveName(i));                                         
          }
   } else{
           var tcols = savecol.split("|" );
           for(var i=0;i< tcols.length;i++){
                 cols.push( isNaN(tcols[i])?sheet.SaveNameCol(tcols[i]):tcols[i]);
                 savenames.push(sheet.ColSaveName(cols[i]));
          }      
   }
   
    var rtn = {};
    for(var i=0;i< savenames.length;i++){
          rtn[savenames[i]] = [];
   }
    //선택된 데이터가 없는 경우
    if(chk!=null &&typeof(chk)!="undefined"&&chk!= ""){
    	if(sheet.FindCheckedRow(chk)==""){
    		alert("선택된 데이터가 없습니다.");
    		return "";
    	}
    }
    

    var datas = [];
    for(var i=0;i< cols.length;i++){
           var d = sheet.GetRangeValue(1,cols[i],lr,cols[i],"†" ,"‡" );
          d = d.split( "‡");
          datas.push(d);
   }
   
    //chk가 없는 경우 모든 행의 값을 가져온다.
    if(chk==null ||typeof(chk)=="undefined"||chk== ""){
           for(var c=0;c< datas.length;c++){
                 rtn[savenames[c]] = datas[c] ;
          }
   } else{
           //check된 행의 값을 가져온다.
          chk = isNaN(chk)?sheet.SaveNameCol(chk):chk;
           var chks = sheet.GetRangeValue(1,chk,lr,chk,"†" ,"‡" );
          
          chks = chks.split( "‡");
          cols = [];
           for(var i=0;i< chks.length;i++){
                  if(chks[i]=="1" ){
                         for(var c=0;c< datas.length;c++){
                               rtn[savenames[c]].push( (datas[c][i]) );
                        }
//                                              
                 }
          }
   }
    var rtnStr = "" ;
    for(var item in rtn){
    	if(encode){
    		rtnStr += "&"+item+"="+encodeURIComponent((rtn[item]).join(separator));
    	}else{
    		rtnStr += "&"+item+"="+(rtn[item]).join(separator);
        	}
       }
    

    
    return rtnStr;
       
 }



//멀티파트 형태로 보내기..
//function GetSaveDataMultipart(url,str)
//{
//	var retxml = null;
//	var ConfigUpdateRequest = getHTTPObject();
//	if( ConfigUpdateRequest == undefined || ConfigUpdateRequest == null )
//		return;
//
//	ConfigUpdateRequest.onreadystatechange = function()
//	{
//		if( ConfigUpdateRequest.readyState == 4 && ConfigUpdateRequest.status == 200 )
//		{
//			retxml =  ConfigUpdateRequest.responseText;
//			try{
//				multipartWorkFinish(retxml);
//			}catch(e){}
//		}
//		else if( ConfigUpdateRequest.readyState == 4 && ConfigUpdateRequest.status == 404 ) 
//		{
//			alert( "Unable to update at this time." );
//		}
//	};
//
//	ConfigUpdateRequest.open( "POST", url+"?t=" + Math.random(), true );
//	var boundary = "---------------";
//	ConfigUpdateRequest.setRequestHeader( "Content-Type", 'multipart/form-data; boundary=' + boundary );
//	
//	var body = "!!"+str;
//	ConfigUpdateRequest.send( body );
//	if (isXMLHttpRequest) {
//		retxml =  xmlhttp.responseText;
//	}
//}
function GetSaveDataMultipart(url,str){
	if(str==null||str=="") return;
	if(!confirm("저장하시겠습니까?")) return;
	if(typeof(document.getElementById("_hiframe")=="undefined")){
		//iframe과 form 객체 생성
		var iff = document.createElement("iframe");
		iff.id = "_hiframe";
		iff.name = "_hiframe";
		iff.style.display = "none";
		document.body.appendChild(iff);
		
		var ff = document.createElement("form");
		ff.setAttribute("enctype","multipart/form-data");    
		ff.setAttribute("method","post");                    
		ff.setAttribute("action",url);        
		ff.style.display = "none";
		ff.target = "_hiframe";
		
		var strArr = str.split("&");
		for(var i=0;i<strArr.length;i++){
			
			var item = strArr[i].split("=");
			
			if(item[0]=="") continue;
			
			var inf = document.createElement("input");
			inf.name = item[0];
			inf.id = item[0];
			inf.setAttribute("type","hidden");
			inf.value = item[1];
			ff.appendChild(inf);
			document.body.appendChild(ff);	
		}
		ff.submit();
	}else{
		document.body.removeChild(document.getElementById("_form"));
		var ff = document.createElement("form");
		ff.setAttribute("enctype","multipart/form-data");    
		ff.setAttribute("method","post");                    
		ff.setAttribute("action",url);        
		ff.style.display = "none";
		ff.id = "_form";
		ff.target = "_hiframe";
		
		var strArr = str.split("&");
		for(var i=0;i<strArr.length;i++){
			var item = strArr[i].split("=");
			if(item[0]=="") continue;
			var inf = document.createElement("input");
			inf.name = item[0];
			inf.id = item[0];
			inf.setAttribute("type","hidden");
			inf.value = item[1];
			ff.appendChild(inf);
			document.body.appendChild(ff);	
		}
		ff.submit();
	}
	
}


function fnPopupCalendar(str){
	//달력
	var theday = document.getElementById(str).value;
	var info = {Format:"yyyy/MM/dd",Result:document.getElementById(str)};
	IBShowCalendar(theday,info);
}    

var isXMLHttpRequest = false;
var xmlhttp = false;

//XMLHttpRequest 객체를 브라우져에 따라서 리턴함.
function getHTTPObject() {
	if (! xmlhttp) {	
		try {
			xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (E) {
				xmlhttp = false;
			}
		}
	
	    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
	        try {
	            xmlhttp = new XMLHttpRequest();
				isXMLHttpRequest = true;
	        } catch (e) {
	            xmlhttp = false;
	        }
	    }
	}
    return xmlhttp;
}

//--------------------------------------------------------------------
// ajax 를 이용하여 서버의 jsp 페이지나 서블릿을 호출하고 거기로 부터 
// 가져온 xml 데이터를 리턴한다. 
//--------------------------------------------------------------------
function GetSearchData(url, param) {
	var retxml = null;
	//전달해야할 인자

	var xmlhttp = getHTTPObject();
												//select 데이터를 가져다 줄 URL
	xmlhttp.open('POST', url + "?"+param,false);

	xmlhttp.onreadystatechange = function() {
		if(xmlhttp.readyState==4 && xmlhttp.status == 200 && xmlhttp.statusText=='OK') {
			retxml =  xmlhttp.responseText;
		}
	}
	xmlhttp.send(null);
	if (isXMLHttpRequest) {
		retxml =  xmlhttp.responseText;
	}
	//일단 필요한 코드와 text를 가져왔다고 치자.
	
	return retxml;
}



//toUpperCase
function ToUpper(obj) {
	obj.value = obj.value.toUpperCase();
}

//blank check
function IsEmpty(arg) {
	return ( arg == "" || arg == 'undefined' )? true : false;
}

//특수문자 입력체크
function checkSpecialChar(str) {
	
	for(var i=0 ; i < str.length; i++) {
		if(str.charAt(i) == '%'||str.charAt(i)=='$'||str.charAt(i)=='&'||str.charAt(i)=='*' || str.charAt(i)=='@' || str.charAt(i)=='!' || str.charAt(i)=='#' || str.charAt(i)=='\'' || str.charAt(i)=='"'){
			return false;
		}
	}
	return true;
} 

//특정 문자열 안의 일부문자를 삭제한다.
function removeStr( arg0, arg1 )
{
	if( arg0 == "" || arg1 == "" ) return "";
	
	var str = arg0;
	
	var i = 0;
	var pos_str = 0;
	var rtn_str = "";
	
	while( i < str.length ) {
		pos_str = str.indexOf(arg1,i);
		
		if( pos_str == -1 ) {
			rtn_str += str.substring(i, str.length );
			break;
		}else {
			rtn_str += str.substring(i, pos_str );
			i = pos_str+1;
		}
	}
	return rtn_str;
}



var formdata = [];

function getJspFormDatas(formNm) {
    var form = eval(formNm);
    alert(form);
    var els = form.elements;
    var size = els.length;
    for(var idx=0;idx<size;idx++) {
        var element = els[idx];
        formdata[element.name] = element.value;
    }
    alert(formdata);
    return formdata;
}


function getFormatedValue(obj){
	var rtnValue = "";
	switch(obj.getAttribute("stype")){
		case 'dateYMD':
			rtnValue = (obj.value).split("/").join(""); 
		break;
		default:
			rtnValue = obj.value;
		break;
	}
	return rtnValue;
}


/* ---------------------------------------------------------------------------------------------------------------------------------*/

common.getFormatedDate = function(sys_date) {
	var now = removeStr(sys_date,'"'); // System Date 입니다!
	
	var ny = now.substring(0, 4);
	var nm = now.substring(4, 6);
	var nd = now.substring(6, 8);
	var date;

	date = ny +'/'+ nm +'/'+ nd;
	
	return date;
};

/**
 * Trim(val) Comment : 입력된 값의 좌우 공백을 전부 없앤다.
 */
common.Trim = function(val) {
	return (common.LTrim(common.RTrim(val)));
};

/**
 * Function : LTrim(val) Comment : 입력된 값의 좌측 공백을 전부 없앤다.
 */
common.LTrim = function(val) {
	var i;
	i = 0;
	while (val.substring(i, i + 1) == ' ')
		i = i + 1;
	return val.substring(i);
};

/**
 * Function : RTrim(val) Comment : 입력된 값의 우측 공백을 전부 없앤다.
 */
common.RTrim = function(val) {
	var i = val.length - 1;
	while (i >= 0 && val.substring(i, i + 1) == ' ')
		i = i - 1;
	return val.substring(0, i + 1);
};


/**
 * Javascript Map 구현
 */
function Map() {
	this.keys = new Array();
	this.data = new Object();

	this.put = function(key, value) {
	    if(this.data[key] == null){
	        this.keys.push(key);
	    }
	    this.data[key] = value;
	};

	this.get = function(key) {
	    return this.data[key];
	};

	this.remove = function(key) {
	    this.keys.remove(key);
	    this.data[key] = null;
	};

	this.each = function(fn){
	    if(typeof fn != 'function'){
	        return;
	    }
	    var len = this.keys.length;
	    for(var i=0;i<len;i++){
	        var k = this.keys[i];
	        fn(k,this.data[k],i);
	    }
	};

	this.entrys = function() {
	    var len = this.keys.length;
	    var entrys = new Array(len);
	    for (var i = 0; i < len; i++) {
	        entrys[i] = {
	            key : this.keys[i],
	            value : this.data[i]
	        };
	    }
	    return entrys;
	};

	this.isEmpty = function() {
	    return this.keys.length == 0;
	};

	this.size = function(){
	    return this.keys.length;
	};
}
