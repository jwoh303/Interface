var gJson = {DATA:[[]]};

/*
 * IBSheet를 생성(호출 위치에서 동적 생성)
 */
function createIBSheet(sheetid, width, height, locale) {
    var div_str = "";

    if (!locale) locale = "";

    Grids.Locale = locale;

    div_str += "<div id='DIV_" + sheetid + "' style='width:" + width + ";height:" + height + ";'>";
	div_str += "<script> IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>',\"DIV_" + sheetid + "\", \"" + sheetid + "\"); </script>";
    div_str += "</div>\n";

    //<![CDATA[
    document.write(div_str);
    //]]>
}
/*
 * IBSheet를 생성 (특정 div 하위로 넣는 경우에 사용)
 */

function createIBSheet2(obj, sheetid, width, height, locale) {
    // locale 처리
    Grids.Locale = locale ? locale : "";

    if (typeof obj === "string") {
        obj = document.getElementById(obj);
    }

    if (obj && typeof obj === "object") {
        // width, height 적용
        obj.style.width = width;
        obj.style.height = height;

        IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>', obj.id, sheetid);
    } else {
        throw "[createIBSheet2] IBSheet container is null.";
    }
}

/* MergeSheet 속성에 설정 값 */
var msNone            = 0;      // 머지 없음
var msAll             = 1;      // 전부 머지 가능
var msPrevColumnMerge = 2;      // 앞 컬럼이 머지 된 경우 해당 행 안에서 머지 가능
var msFixedMerge      = 3; // 단위데이터행 구조에서의 고정 셀 병합 기능
var msBaseColumnMerge = 4; // 기준 컬럼 머지 영역 범위 내에서의 머지 기능
var msHeaderOnly      = 5;      // 해더만 머지

/* BasicImeMode 속성 설정 값 */
var imeAuto           = 0;      // 마지막 상태를 그대로 사용
var imeHan            = 1;      // 기본 상태를 한글 입력 상태로 함
var imeEng            = 2;      // 기본 상태를 영문 입력 상태로 함

/* SizeMode 속성 설정 값 */
var sizeAuto          = 0;      // 설정한 높이, 너비 그대로 사용
var sizeNoVScroll     = 1;      // 높이를 스크롤 없이 자동 설정
var sizeNoHScroll     = 2;      // 너비를 스크롤 없이 자동 설정
var sizeNoBothScroll  = 3;      // 높이, 너비 모두 스크롤 없이 자동 설정

/* SearchMode 속성 설정 값 */
var smGeneral         = 0;		// 일반 조회
var smClientPaging    = 1;		// 클라이언트 페이징 조회
var smLazyLoad        = 2;		// Lazy Load 조회
var smServerPaging    = 3;      // 실시간 서버 페이징 조회

/* SumPosition 속성 설정 값 */
var posTop            = 0;		// 상단 고정 위치
var posBottom         = 1;		// 하단 고정 위치

/* VScrollMode 속성 설정 값 */
var vsAuto            = 0;		// 자동 생성
var vsFixed           = 1;		// 고정 생성

/*
    FormQueryString 관련 함수 정의
*/
/* FormQueryString과 FormQueryStringEnc함수에서 필수입력 체크시 메시지로 사용한다.-3.4.0.50 */
var IBS_MSG_REQUIRED      = "은(는) 필수입력 항목입니다.";			
/**
 * 에러메시지를 표시한다. IBS_ShowErrMsg 대신 이 함수를 사용해야 한다.
 * @param   : sMsg      - 메시지
 * @return  : 없음
 * @version : 3.4.0.50
 * @sample
 *  IBS_ShowErrMsg("에러가 발생했습니다.");
 */
function IBS_ShowErrMsg(sMsg){
    return alert("[IBSheetInfo.js]\n" + sMsg);
}
function IBS_getName(obj){
	if(obj.name!=""){
		return obj.name;	
	}else if(obj.id!=""){
		return obj.id;	
	}else{
		return "";	
	}
}
function IBS_RequiredChk(obj){

	return (obj.getAttribute("required")!=null);
}

function IBS_RequiredChkMsg(obj){
//	if(__Browser___Version.Version()==10){
//	    alert("필수입력필드는 반드시 입력하셔야 합니다.");
//	}else{
//	loader_obj("N");
		if (obj.getAttribute("required")=="") {
	    alert('"' + IBS_getName(obj) + '"' + IBS_MSG_REQUIRED);
	  }else{
	    alert('"' + obj.getAttribute("required")  + '"' + IBS_MSG_REQUIRED);
	  }
//	}
}


/**
 * Form오브젝트 안에 있는 컨트롤을 QueryString으로 구성한다. 이때, 한글은 인코딩하지 않는다.
 * @param   : form          - 필수,html의 Form 오브젝트 Name
 * @param   : checkRequired - 선택,필수입력 체크 여부(true,false)
 * @return  : String        - Form오브젝트 안에 Control을 QueryString으로 구성한 문자열
 *            undefined     - checkRequired인자가 true이고, 필수입력에 걸린경우 return 값
 * @version : 1.0.0.0, 
 *            3.4.0.50(checkRequired 인자 추가)
 * @sample1
 *  var sCondParam=FormQueryString(document.frmSearch); //결과:"txtname=이경희&rdoYn=1&sltMoney=원화";
 * @sample2
 *  <input type="text" name="txtName" required="이름">        //필수 입력 항목이면 required="이름" 를 설정한다.
 *  var sCondParam = FormQueryString(document.mainForm, true);//필수입력까지 체크하며, 필수입력에 걸리면 리턴값은 null
 *  if (sCondParam==null) return;
 */
function FormQueryString(form, checkRequired) {
  if (typeof form != "object" || form.tagName != "FORM") {
    IBS_ShowErrMsg("FormQueryString 함수의 인자는 FORM 태그가 아닙니다.");
    return "";
  }
  
  if(checkRequired==null) checkRequired=false;

  var name = new Array(form.elements.length);
  var value = new Array(form.elements.length);
  var j = 0;
  var plain_text="";

  //사용가능한 컨트롤을 배열로 생성한다.
  len = form.elements.length;
  for (i = 0; i < len; i++) {
    var prev_j = j;
    switch (form.elements[i].type) {
      case undefined:
      case "button":
      case "reset":
      case "submit":
        break;
      case "radio":
      case "checkbox":
          if (form.elements[i].checked == true) {
            name[j] = IBS_getName(form.elements[i]);
            value[j] = form.elements[i].value;
            j++;
          }
          break;
      case "select-one":
          name[j] = IBS_getName(form.elements[i]);
          var ind = form.elements[i].selectedIndex;
          if(ind >= 0) {
            
              value[j] = form.elements[i].options[ind].value;
            
          } else {
            value[j] = "";
          }
          j++;
          break;
      case "select-multiple":
          name[j] = IBS_getName(form.elements[i]);
          var llen = form.elements[i].length;
          var increased = 0;
          for( k = 0; k < llen; k++) {
            if (form.elements[i].options[k].selected) {
              name[j] = IBS_getName(form.elements[i]);
              value[j] = form.elements[i].options[k].value;
              
              j++;
              increased++;
            }
          }
          if(increased > 0) {
            j--;
          } else {
            value[j] = "";
          }
          j++;
          break;
        default :
          name[j] = IBS_getName(form.elements[i]);
          value[j] = form.elements[i].value;
          j++;
    }
    
    if (checkRequired) {
      //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
      //<input type="text" name="txtName" required="이름">
      
      if (  IBS_RequiredChk(form.elements[i]) &&prev_j != j && value[prev_j] == "") {
//    	  loader_obj("N");
       	if (form.elements[i].getAttribute("required")==null||
       	form.elements[i].getAttribute("required")==""
       	) {
          alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
        }else{
        	
          alert('"' + form.elements[i].getAttribute("required")  + '"' + IBS_MSG_REQUIRED);
        }
        //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
        try{
          form.elements[i].focus();
        } catch(ee) {;}
        
        return;
      }
    }
  }
  //QueryString을 조합한다.
  for (i = 0; i < j; i++) {
     if (name[i] != '') plain_text += name[i]+ "=" + value[i] + "&";
  }

  //마지막에 &를 없애기 위함
  if (plain_text != "") plain_text = plain_text.substr(0, plain_text.length -1);
  
  return plain_text;
}

/**
 * Form오브젝트 안에 있는 컨트롤을 QueryString으로 구성한다. 이때, 한글은 인코딩한다.
 * @param   : form          - 필수,html의 Form 오브젝트 Name
 * @param   : Sheet         - 필수,IBheet의 Object id
 * @param   : checkRequired - 선택,필수입력 체크 여부(true,false)
 * @return  : String        - Form오브젝트 안에 Control을 QueryString으로 구성한 문자열
 *            undefined     - checkRequired인자가 true이고, 필수입력에 걸린경우 return 값
 * @version : 1.0.0.0, 
 *            3.4.0.50(checkRequired 인자 추가)
 * @sample1
 *  var sCondParam=FormQueryStringEnc(document.frmSearch, mySheet1);
 *  원본:"txtname=이경희&rdoYn=1&sltMoney=원화";
 *  결과:"txtname=%C0%CC%B0%E6%C8%F1&rdoYn=1&sltMoney=%BF%F8%C8%AD";                //UTF16인 경우
 *  결과:"txtname=%EC%9D%B4%EA%B2%BD%ED%9D%AC&rdoYn=1&sltMoney=%EC%9B%90%ED%99%94"; //UTF8인 경우
 * @sample2
 *  <input type="text" name="txtName" required="이름">                    //필수 입력 항목이면 required="이름" 를 설정한다.
 *  var sCondParam = FormQueryStringEnc(document.mainForm, mySheet, true);//필수입력까지 체크하며, 필수입력에 걸리면 리턴값은 null
 *  if (sCondParam==null) return;
 */
function FormQueryStringEnc(form, checkRequired) {
  if (typeof form != "object" || form.tagName != "FORM") {
    IBS_ShowErrMsg("FormQueryStringEnc 함수의 form 인자는 FORM 태그가 아닙니다.");
    return "";
  }

  
  if(checkRequired==null) checkRequired=false;

  var name = new Array(form.elements.length);
  var value = new Array(form.elements.length);
  var j = 0;
  var plain_text="";

  //사용가능한 컨트롤을 배열로 생성한다.
  len = form.elements.length;
  for (i = 0; i < len; i++) {
    var prev_j = j;
    switch (form.elements[i].type) {
      case "button":
      case "reset":
      case "submit":
        break;
      case "radio":
      case "checkbox":
          if (form.elements[i].checked == true) {
            name[j] = IBS_getName(form.elements[i]);
            value[j] = form.elements[i].value;
            j++;
          }
          break;
      case "select-one":
          name[j] = IBS_getName(form.elements[i]);
          var ind = form.elements[i].selectedIndex;
          if(ind >= 0) {
            
              value[j] = form.elements[i].options[ind].value;
            
          } else {
            value[j] = "";
          }
          j++;
          break;
      case "select-multiple":
          name[j] = IBS_getName(form.elements[i]);
          var llen = form.elements[i].length;
          var increased = 0;
          for( k = 0; k < llen; k++) {
            if (form.elements[i].options[k].selected) {
              name[j] = IBS_getName(form.elements[i]);
              
                value[j] = form.elements[i].options[k].value;
              
              j++;
              increased++;
            }
          }
          if(increased > 0) {
            j--;
          } else {
            value[j] = "";
          }
          j++;
          break;
        default :
          
            name[j] = IBS_getName(form.elements[i]);
            value[j] = form.elements[i].value;
            j++;
    }

    if (checkRequired) {
      //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
      //<input type="text" name="txtName" required="이름">
      if (IBS_RequiredChk(form.elements[i])&&prev_j != j && value[prev_j] == "") {
//    	  loader_obj("N");
       	if (form.elements[i].getAttribute("required")=="") {
          alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
        }else{
          alert('"' + form.elements[i].getAttribute("required")  + '"' + IBS_MSG_REQUIRED);
        }
        //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
        try{
          form.elements[i].focus();
        } catch(ee) {;}
        
        return;
      }
    }
  }

  //QueryString을 조합한다.
  for (i = 0; i < j; i++) {
    if (name[i] != '') plain_text += encodeURIComponent(name[i])+ "=" + encodeURIComponent(value[i]) + "&";
  }

  //마지막에 &를 없애기 위함
  if (plain_text != "")  plain_text = plain_text.substr(0, plain_text.length -1);
  
  return plain_text;
}

/*------------------------------------------------------------------------------
 * titile : IBSheet의 조회,저장시 사용되는 함수
 * paramList : 
 * param1 : s_SAVENAME 객체를 담고 있는 form 객체
 * param2 : 조회해야 할 시트 객체
 * param3.. : 여러개 시트를 한번에 조회하는 경우 시트의 개수만큼 붙인다.
-------------------------------------------------------------------------------*/
function IBS_SaveName() {
	var param = arguments;
	if(param.length<2){
		IBS_ShowErrMsg("최하 두개의 인자가 필요합니다.");
		return;
	}
 
	
	if(param.length==2){
		param[0].s_SAVENAME.value = IBS_ConcatSaveName(param[1]);
	}else{
		param[0].s_SAVENAME.value = "";
		for(var i=1;i<param.length;i++){
			param[0].s_SAVENAME.value += IBS_ConcatSaveName(param[i])+"@@";
		}
		var tempStr = param[0].s_SAVENAME.value;
		param[0].s_SAVENAME.value = tempStr.substring(0,tempStr.length-2);
	}
	
	/*
	if(param[0].s_SAVENAME.value == ""){

	}else{
		if(param.length==2){
			param[0].s_SAVENAME.value = IBS_ConcatSaveName(param[1]);
		}else{
			param[0].s_SAVENAME.value = "";
			for(var i=1;i<param.length;i++){
				param[0].s_SAVENAME.value += IBS_ConcatSaveName(param[i])+"@@";
			}
			var tempStr = param[0].s_SAVENAME.value;
			param[0].s_SAVENAME.value = tempStr.substring(0,tempStr.length-2);
		}
	}
	*/
}


function IBS_SaveName_multi() {
	var param = arguments;
	if(param.length<2){
		IBS_ShowErrMsg("최하 두개의 인자가 필요합니다.");
		return;
	}
  
	//alert(param[0].s_SAVENAME.value);
	
	if(param[0].s_SAVENAME.value == ""){
		if(param.length==2){
			param[0].s_SAVENAME.value = IBS_ConcatSaveName(param[1]);
		}else{
			param[0].s_SAVENAME.value = "";
			for(var i=1;i<param.length;i++){
				param[0].s_SAVENAME.value += IBS_ConcatSaveName(param[i])+"@@";
			}
			var tempStr = param[0].s_SAVENAME.value;
			param[0].s_SAVENAME.value = tempStr.substring(0,tempStr.length-2);
		}
		
	}else{ 
	}
	
}



function IBS_ConcatSaveName(sheet){
	var lc = sheet.LastCol(); 
	var snStr = "";
	for(var c=0;c<=lc;c++){
		snStr += "|"+sheet.GetCellProperty (0, c, "SaveName");
	}
	return snStr.substring(1);
}

/*------------------------------------------------------------------------------
 * method : GetSaveJson
 * desc : 지정한 상태에 대한 데이터를 json 형태로 반환한다.
 * param list
 * param1 : IBSheet Object
 * param2 : 상태 (I|U|D)
 * param3 : SkipCol list 
-------------------------------------------------------------------------------*/
function GetSaveJson2(sheet,status,skipcols){
	if(sheet==null){
		alert("GetSaveJson2 함수의 첫번째 인자는 ibsheet 객체여야 합니다.");
		return; 
	}
	
	var skipcolsArr = null;
	if(skipcols!=null){
		skipcolsArr = skipcols.split("|");
	}
	
	var rtnJson = {};
	if(status==null){
		var temp = GetJsonStatus(sheet,"I",skipcolsArr);
		if(temp) rtnJson["INSERT"] = temp;
		temp = GetJsonStatus(sheet,"D",skipcolsArr);
		if(temp) rtnJson["DELETE"] = temp;
		temp = GetJsonStatus(sheet,"U",skipcolsArr);
		if(temp) rtnJson["UPDATE"] = temp;
	}else{
		switch(status){
			case "I":
				rtnJson["INSERT"] = GetJsonStatus(sheet,"I",skipcolsArr);
				break;
			case "U":
				rtnJson["UPDATE"] = GetJsonStatus(sheet,"U",skipcolsArr);
				break;
			case "D":
				rtnJson["DELETE"] = GetJsonStatus(sheet,"D",skipcolsArr);
				break;
		}
		GetJsonStatus(sheet,status);
	}
	return rtnJson;
}

function GetJsonStatus(sheet,status,skipcolsArr){
	var rtnJson = new Array();
	//지정한 상태 값을 갖는 행을 뽑는다.
	var rows = sheet.FindStatusRow(status);
  
	if(rows=="")return null;
  
	var rowArr = rows.split(";");
  
	for(var i=0;i<rowArr.length;i++){
		var temp = sheet.GetRowJson(rowArr[i]);
		if(skipcolsArr!=null){
			for(var c=0;c<skipcolsArr.length;c++){
				delete temp[skipcolsArr[c]]; 
			}
		}
		rtnJson.push(temp);
	}
	return rtnJson;
}


/*------------------------------------------------------------------------------
 * method : IBS_InitSheet
 * desc : 시트를 초기화 한다..
 * param list
 * param1 : IBSheet Object
 * param2 : 시트 초기화 정보
-------------------------------------------------------------------------------*/
function IBS_InitSheet(sheet, info,pagingMode, xlsflag) {
	
	//그리드 데이터 배경색 설정
	sheet.SetEditableColorDiff(0);
	
	// 필수 입력 요소 체크
	if (!sheet || !info || !info.Cols) {
		alert("시트 초기화 정보가 올바르지 않습니다.");
	}

	var cInfo = CloneArray(info);
	if (!cInfo.Cfg) {
		cInfo.Cfg = {
//				FrozenCol : 3,
				SearchMode : (pagingMode=="Y")?smClientPaging:smLazyLoad,
				Page : 50
//				ColPage : 10
				, PrevColumnMergeMode:0
			};
	}
	if (!cInfo.Headers) {
		cInfo.Headers = [
			{Text:"", Align:"Center"}
		];
	}

	if (!cInfo.HeaderMode) {
//		cInfo.HeaderMode = {};
		cInfo.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	} else {
		if (cInfo.HeaderMode.Align) {
			var header = cInifo.Headers;
			for (var i = 0, len = header.length; i < len; i++) {
				header[i].Align = cInfo.HeaderMode.Align;
			}
		}
	}

	if (cInfo.Cols[0].Header) {
		var cols = cInfo.Cols;
		var headers = new Array(cInfo.Cols[0].Header.split("|").length);

		for (var i = 0, len = cols.length; i < len; i++) {
			var col = cols[i];
			var header = col.Header.split("|");
			
			for (var j = 0, hlen = header.length;  j < hlen; j++) {
				if (!headers[j]) headers[j] = [];
				headers[j].push(header[j]?header[j]:"");
			}

			delete(col.Header);
		}

		cInfo.Headers = [];
		for (var i = 0, len = headers.length; i < len; i++) {
			var header = {};
			header.Text = headers[i].join("|");
			header.Align = cInfo.HeaderMode.Align?cInfo.HeaderMode.Align:"Center";
			cInfo.Headers.push(header);
		}
	}
	//var prefix = "LGY";
	//var folder = "LightGray";
	//Gray 테마를 적용한다.
	//sheet.SetTheme(prefix, folder); 
//	IBCalendarSetTheme(prefix, folder);
	var dataRows      = 1;
	// DataRows 설정
    if (cInfo.Cols[0] && typeof cInfo.Cols[0].length !== "undefined") {
        dataRows = cInfo.Cols.length;
    } 
    
	sheet.SetConfig(cInfo.Cfg);
	sheet.InitHeaders(cInfo.Headers, cInfo.HeaderMode);
	sheet.InitColumns(cInfo.Cols, dataRows);
	if(xlsflag == 'XLS'){
		sheet.SetActionMenu("셀복사|행복사|엑셀파일저장");
	}else{
		sheet.SetActionMenu("셀복사|행복사");
	}
	
	//드레그 방지(보안 문제로 드레그 복사를 막기위해 추가)
	sheet.SetDragMode(-1);

	//sheet.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]


	
//	setChangeTheme( obj , gubun);
	
//	sheet.SetWaitTimeOut(600);
//	sheet.SetDataAlternateBackColor("#FFFFFF");
//	sheet.SetDataBackColor("#FFFFFF");
//	sheet.SetEditableColorDiff(0);
//	if ( menu == "T"){
//		sheet.SetActionMenu("복사|붙여넣기|엑셀파일 저장");
//	}else {
//		sheet.SetActionMenu("복사|엑셀파일 저장");
//	}
	
}


/*------------------------------------------------------------------------------
 * method : IBS_InitSheet
 * desc : 시트를 초기화 한다..(컬럼고정)
 * param list
 * param1 : IBSheet Object
 * param2 : 시트 초기화 정보
-------------------------------------------------------------------------------*/
function IBS_InitSheet2(sheet, info,pagingMode, fronzencol) {
	
	//그리드 데이터 배경색 설정
	sheet.SetEditableColorDiff(0);
	
	// 필수 입력 요소 체크
	if (!sheet || !info || !info.Cols) {
		alert("시트 초기화 정보가 올바르지 않습니다.");
	}

	var cInfo = CloneArray(info);

	if (!cInfo.Cfg) {
		cInfo.Cfg = {
				FrozenCol : fronzencol,
				SearchMode : (pagingMode=="Y")?smClientPaging:smLazyLoad,
				Page : 50
//				ColPage : 10
			};
	}
	if (!cInfo.Headers) {
		cInfo.Headers = [
			{Text:"", Align:"Center"}
		];
	}

	if (!cInfo.HeaderMode) {
		cInfo.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	} else {
		if (cInfo.HeaderMode.Align) {
			var header = cInifo.Headers;
			for (var i = 0, len = header.length; i < len; i++) {
				header[i].Align = cInfo.HeaderMode.Align;
			}
		}
	}

	if (cInfo.Cols[0].Header) {
		var cols = cInfo.Cols;
		var headers = new Array(cInfo.Cols[0].Header.split("|").length);

		for (var i = 0, len = cols.length; i < len; i++) {
			var col = cols[i];
			var header = col.Header.split("|");
			
			for (var j = 0, hlen = header.length;  j < hlen; j++) {
				if (!headers[j]) headers[j] = [];
				headers[j].push(header[j]?header[j]:"");
			}

			delete(col.Header);
		}

		cInfo.Headers = [];
		for (var i = 0, len = headers.length; i < len; i++) {
			var header = {};
			header.Text = headers[i].join("|");
			header.Align = cInfo.HeaderMode.Align?cInfo.HeaderMode.Align:"Center";
			cInfo.Headers.push(header);
		}
	}
	//var prefix = "LGY";
	//var folder = "LightGray";
	//Gray 테마를 적용한다.
	//sheet.SetTheme(prefix, folder); 


	 
	sheet.SetConfig(cInfo.Cfg);
	sheet.InitHeaders(cInfo.Headers, cInfo.HeaderMode);
	sheet.InitColumns(cInfo.Cols);
	sheet.SetActionMenu("셀복사|행복사");
	//드레그 방지(보안 문제로 드레그 복사를 막기위해 추가)
	sheet.SetDragMode(-1);
	
}


/*------------------------------------------------------------------------------
* method : IBS_CopyJson2Form
* desc : json 데이터를 이름을 기준으로 폼객체에 넣는다.
* param list
* param1 : json 객체
* param2 : 대상 폼 name

json 자료 구조 :
{"폼객체명":{"객체명":"값","객체명2":"값2"}}
ex){"aFrm":{"sa_no":"12345","sa_name":"손이창","grade":"a3","married":"NO","enter_date":"2012-12-31"}}
-------------------------------------------------------------------------------*/
function IBS_CopyJson2Form(jsonobj, frmName) {
    var json ,
        obj  ,
        stype,
        idx  ,
        max  ;

    if (typeof frmName == "object") {
        frmName = frmName.name;
    }

    json = jsonobj[frmName];

    for (j in json) {
        obj = null;

        try {
            obj = document[frmName][j];
            if (obj == null || typeof obj == "undefined") {
                obj = document.getElementById(j);
            }
            if (obj == null || typeof obj == "undefined") {
                continue;
            }
        } catch(e) {
            //alert(e.message);
        }

        stype = (obj.type);
        
        if (typeof stype == "undefined" && obj.length > 0) {
            stype = obj[0].type;
        }
        
        switch (stype) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "select-one":
                obj.value = json[j];
                break;
            case "radio":
                obj.checked = json[j];
                break;
            case "checkbox":
                obj.checked = json[j];
                break;
            default :
                obj.value = json[j];
                break;
        }//end of switch
    }
}

/*------------------------------------------------------------------------------
method : IBS_CopyForm2Sheet()
desc  : Form객체에 있는 내용을 시트에 복사
param list
param : json 유형

param 내부 설정값
sheet : 값을 입력 받을 ibsheet 객체 (필수)
form : copy할 폼객체 (필수)
row : ibsheet 객체의 행 (default : 현재 선택된 행)
sheetPreFiex : 맵핑할 시트의 SavaName 앞에 PreFix 문자 (default : "")
formPreFiex : 맵핑할 폼객체의 이름 혹은 id 앞에  PreFix 문자 (default : "")
useOnChange : 시트값 변경시 OnChange 이벤트 사용 유무 (default : false)
-------------------------------------------------------------------------------*/
function IBS_CopyForm2Sheet(param) {
    var sheetobj    ,
        formobj     ,
        row         ,
        sheetPreFix ,
        frmPreFix   ,
        uoc         ,
        col         ,
        max         ,
        colSaveName ,
        baseSaveName,
        frmchild    ,
        sType       ,
        sValue      ;

    if ((!param.sheet) || (!param.sheet.IBSheetVersion)) {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 sheet 인자가 없거나 ibsheet객체가 아닙니다.");
        return false;
    }
    if (param.form==null || typeof param.form != "object" || param.form.tagName != "FORM") {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 form 인자가 없거나 FORM 객체가 아닙니다.");
         return false;
    }
    
    sheetobj    = param.sheet;
    formobj     = param.form;
    row         = param.row == null ? sheetobj.GetSelectRow() : param.row;
    sheetPreFix = param.sheetPreFix == null ? "" : param.sheetPreFix;
    frmPreFix   = param.formPreFix == null ? "" : param.formPreFix;
    uoc         = param.useOnChange == null ? 0 : param.useOnChange;
    if (row < 0){
        alert("선택된 행이 존재하지 않습니다.");
        return;
    }

    //Sheet의 컬럼개수만큼 찾아서 HTML의 Form 각 Control에 값을 설정한다.
    //컬럼개수만큼 루프 실행
    for (col = 0, max = sheetobj.LastCol(); col <= max; col++) {
        //컬럼의 별명을 문자열로 가져온다.
        colSaveName = sheetobj.ColSaveName(col)
        if (colSaveName == "") {
            continue;
        }
        //PreFix가 붙지 않은 형태의 SaveName을 가져온다.
        baseSaveName = colSaveName.substring(sheetPreFix.length);

        frmchild = null;
        try {
            //폼에 있는 해당 이름의 컨트롤을 가져온다.예)"frm_CardNo"
            frmchild = formobj[frmPreFix + baseSaveName];
        } catch(e) {
        	alert(e);
        }

        //폼에 해당하는 이름의 컨트롤이 없는 경우는 계속 진행한다.
        if (frmchild == null) continue;

        sType = frmchild.type;
        sValue = "";
        
        //radio의 경우 frmchild가 배열형태가 되므로, frmchild.type으로는 타입을 알수 없다.
        if (typeof sType == "undefined" && frmchild.length > 0) {
            sType = frmchild[0].type;
        }

        //타입별로 값을 설정한다.
        switch (sType) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "radio":
                for (idx = 0; idx < frmchild.length; idx++) {
                    if (frmchild[idx].checked) {
                        sValue = frmchild[idx].value;
                        break;
                    }
                }
            break;
                case "checkbox":
                sValue = (frmchild.checked) ? 1 : 0;
                break;
            default :
                sValue = frmchild.value;
        }//end of switch

        sheetobj.SetCellValue(row, sheetPreFix+baseSaveName, sValue, uoc);
    }//end of for(col)

    //정상적인 처리완료
    return true;
}

/*----------------------------------------------------------------------------
method : IBS_CopySheet2Form()
desc : 시트의 한 행을 폼객체에 복사

param list
param : json 유형

param 내부 설정값
sheet : 값을 입력 받을 ibsheet 객체 (필수)
form : copy할 폼객체 (필수)
row : ibsheet 객체의 행 (default : 현재 선택된 행)
sheetPreFiex : 맵핑할 시트의 SavaName 앞에 PreFix 문자 (default : "")
formPreFiex : 맵핑할 폼객체의 이름 혹은 id 앞에  PreFix 문자 (default : "")
-----------------------------------------------------------------------------*/
function IBS_CopySheet2Form(param) {
    var sheetobj    ,
        formobj     ,
        row         ,
        sheetPreFix ,
        frmPreFix   ,
        col         ,
        max         ,
        colSaveName ,
        baseSaveName,
        sheetvalue  ,
        frmchild    ,
        sType       ,
        sValue      ;

    if ((!param.sheet) || (!param.sheet.IBSheetVersion)) {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 sheet 인자가 없거나 ibsheet객체가 아닙니다.");
        return false;
    }

    if (param.form == null || typeof param.form != "object" || param.form.tagName != "FORM") {
        IBS_ShowErrMsg("IBS_CopyForm2Sheet 함수의 form 인자가 없거나 FORM 객체가 아닙니다.");
        return false;
    }
    sheetobj = param.sheet;
    formobj = param.form;
    row = param.row==null?sheetobj.GetSelectRow():param.row;
    sheetPreFix = param.sheetPreFix==null?"":param.sheetPreFix;
    frmPreFix = param.formPreFix==null?"":param.formPreFix;

    if (row < 0){
        alert("선택된 행이 존재하지 않습니다.");
        return;
    }

    //Sheet의 컬럼개수만큼 찾아서 HTML의 Form 각 Control에 값을 설정한다.
    //컬럼개수만큼 루프 실행
    for (col = 0, max = sheetobj.LastCol(); col <= max; col++) {
        //컬럼의 별명을 문자열로 가져온다.
        colSaveName = sheetobj.ColSaveName(col)
        if (colSaveName == "") {
            continue;
        }
        //PreFix가 붙지 않은 형태의 SaveName을 가져온다.
        baseSaveName = colSaveName.substring(sheetPreFix.length);

        sheetvalue = sheetobj.GetCellText(row,sheetPreFix+baseSaveName);

        frmchild = null;
        try{
            //폼에 있는 해당 이름의 컨트롤을 가져온다.예)"frm_CardNo"
            frmchild = formobj[frmPreFix + baseSaveName];
        }catch(e){

        }

        //폼에 해당하는 이름의 컨트롤이 없는 경우는 계속 진행한다.
        if (frmchild == null) {
            continue;
        }

        sType = frmchild.type;
        sValue = "";
        //radio의 경우 frmchild가 배열형태가 되므로, frmchild.type으로는 타입을 알수 없다.
        if (typeof sType == "undefined" && frmchild.length > 0) {
            sType = frmchild[0].type;
        }

        //타입별로 값을 설정한다.
        switch(sType) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "select-one":
                frmchild.value = sheetobj.GetCellValue(row, sheetPreFix + baseSaveName);
                break;
            case "radio":
                for (idx = 0, max = frmchild.length; idx < max; idx++) {
                    if (frmchild[idx].value == sheetvalue) {
                        frmchild[idx].checked=true;
                        break;
                    }
                }
                break;
            case "checkbox":
                frmchild.checked = (sheetobj.GetCellValue(row, sheetPreFix + baseSaveName) == 1);
                break;
            default :
                frmchild.value = sheetvalue;
                break;
        }//end of switch
    }//end of for(col)
    
    //정상적인 처리완료
    return true;
}




/*------------------------------------------------------------------------------
 * method : initSheet1 , initSheet2
 * desc : 그리드 공통 설정.
 * param list
 * param1 : obj       대상 그리드
 * param2 : mode  2 : 메모리  3: 페이징
 * param3 : headers   해더 내용
 * param4 : cols      컬럼 내용
 * param5 : menu  	   우측버튼 활성 (S,T)
 * param6 : gubun  	  그리드 디자인 테마 (S)
-------------------------------------------------------------------------------*/
function initSheet1( obj , mode,headers, cols , menu, gubun){
	setChangeTheme( obj , gubun);
	var cfg = {"SearchMode":mode,Page:50};
	obj.SetConfig(cfg);
	
	var info = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	obj.InitHeaders(headers,info);
	
	obj.InitColumns(cols);
	
	obj.SetCountPosition(4);	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	obj.SetWaitTimeOut(600);
	obj.SetDataAlternateBackColor("#FFFFFF");
	obj.SetDataBackColor("#FFFFFF");
	obj.SetEditableColorDiff(0);
	if ( menu == "T"){
		obj.SetActionMenu("복사|붙여넣기|엑셀파일 저장");
	}else {
		obj.SetActionMenu("복사|엑셀파일 저장");
	}
}

function initSheet2( obj , mode,headers, cols , menu, gubun){
	setChangeTheme( obj , gubun);
	var cfg = {"SearchMode":mode,Page:50};
	obj.SetConfig(cfg);
	
	obj.InitColumns(cols);
	obj.SetCountPosition(4);	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	obj.SetWaitTimeOut(600);
	obj.SetDataAlternateBackColor("#FFFFFF");
	obj.SetDataBackColor("#FFFFFF");
	obj.SetEditableColorDiff(0);
	if ( menu == "T"){
		obj.SetActionMenu("복사|붙여넣기|엑셀파일 저장");
	}else {
		obj.SetActionMenu("복사|엑셀파일 저장");
	}
}

function initSheet3( obj , mode,headers, cols , menu, gubun,pageCnt){
	setChangeTheme( obj , gubun);
	var cfg = {"SearchMode":mode,Page:pageCnt};
	obj.SetConfig(cfg);
	
	var info = {Sort:1,ColMove:1,ColResize:1};
	obj.InitHeaders(headers,info);
	
	obj.InitColumns(cols);
	
	obj.SetCountPosition(4);	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	obj.SetWaitTimeOut(600);
	obj.SetDataAlternateBackColor("#FFFFFF");
	obj.SetDataBackColor("#FFFFFF");
	obj.SetEditableColorDiff(0);
	if ( menu == "T"){
		obj.SetActionMenu("복사|붙여넣기|엑셀파일 저장");
	}else {
		obj.SetActionMenu("복사|엑셀파일 저장");
	}
}

function initSheet4( obj , mode,headers, cols , menu, gubun){
	setChangeTheme( obj , gubun);
	var cfg = {"SearchMode":mode,Page:50, FrozenCol:5};
	obj.SetConfig(cfg);
	
	var info = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	obj.InitHeaders(headers,info);
	
	obj.InitColumns(cols);
	
	obj.SetCountPosition(4);	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	obj.SetWaitTimeOut(600);
	obj.SetDataAlternateBackColor("#FFFFFF");
	obj.SetDataBackColor("#FFFFFF");
	obj.SetEditableColorDiff(0);
	if ( menu == "T"){
		obj.SetActionMenu("복사|붙여넣기|엑셀파일 저장");
	}else {
		obj.SetActionMenu("복사|엑셀파일 저장");
	}
}


function initSheet5( obj , mode,headers, cols , menu, gubun){
	setChangeTheme( obj , gubun);
	var cfg = {"SearchMode":mode,Page:20, FrozenCol:3};
	obj.SetConfig(cfg);
	var info = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	obj.InitHeaders(headers,info);
	
	obj.InitColumns(cols);
	
	obj.SetWaitTimeOut(600);
	obj.SetCountPosition(4);	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	obj.SetDataAlternateBackColor("#FFFFFF");
	obj.SetDataBackColor("#FFFFFF");
	obj.SetEditableColorDiff(0);

	if ( menu == "T"){
		obj.SetActionMenu("복사|붙여넣기|엑셀파일 저장");
	}else {
		obj.SetActionMenu("복사|엑셀파일 저장");
	}

}

/*------------------------------------------------------------------------------
 * method : setChangeTheme
 * desc : 그리드 테마설정
 * param list
 * param1 : obj       대상 그리드
 * param2 : gubun     테마 설정 (S)
-------------------------------------------------------------------------------*/
function setChangeTheme(obj , gubun){
	if(gubun == "S"){
		obj.SetTheme('GN', 'Green');
	}
	
  
/*  테마화면은 ibsheet 샘플 참조
	mySheet.SetTheme('BL', 'Blue');
	mySheet.SetTheme('BN', 'Brown');
	mySheet.SetTheme('GY', 'Gray');
	mySheet.SetTheme('GN', 'Green');
	mySheet.SetTheme('NB', 'Navy');
	mySheet.SetTheme('OR', 'Orange');
	mySheet.SetTheme('PP', 'Purple');
	mySheet.SetTheme('YL', 'Yellow');
	mySheet.SetTheme('LBN', 'LightBrown');
	mySheet.SetTheme('LGY', 'LightGray');
	mySheet.SetTheme('LGN', 'LightGreen');
	mySheet.SetTheme('LPP', 'LightPurple');
	mySheet.SetTheme('LS', 'LightSky');
*/
}



//2014-02-21 카렌더 슬래시 제거용      
function FormQueryStringEnc3(form, checkRequired) {
if (typeof form != "object" || form.tagName != "FORM") {
 IBS_ShowErrMsg("FormQueryStringEnc2 함수의 form 인자는 FORM 태그가 아닙니다.");
 return "";
}

if(checkRequired==null) checkRequired=false;

var name = new Array(form.elements.length);
var value = new Array(form.elements.length);
var j = 0;
var plain_text="";

//사용가능한 컨트롤을 배열로 생성한다.
len = form.elements.length;
for (i = 0; i < len; i++) {
 var prev_j = j;
 switch (form.elements[i].type) {
   case "button":
   case "reset":
   case "submit":
     break;
   case "radio":
   case "checkbox":
       if (form.elements[i].checked == true) {
         name[j] = IBS_getName(form.elements[i]);
         value[j] = form.elements[i].value;
         j++;
       }
       break;
   case "select-one":
       name[j] = IBS_getName(form.elements[i]);
       var ind = form.elements[i].selectedIndex;
       if(ind >= 0) {
         if (form.elements[i].options[ind].value != '' || checkRequired)
           value[j] = form.elements[i].options[ind].value;
         else
         	value[j] = "";
          // value[j] = form.elements[i].options[ind].text;
       } else {
         value[j] = "";
       }
       j++;
       break;
   case "select-multiple":
       name[j] = IBS_getName(form.elements[i]);
       var llen = form.elements[i].length;
       var increased = 0;
       for( k = 0; k < llen; k++) {
         if (form.elements[i].options[k].selected) {
           name[j] = IBS_getName(form.elements[i]);
           if (form.elements[i].options[k].value != '')
             value[j] = form.elements[i].options[k].value;
           else
             value[j] = form.elements[i].options[k].text;
           j++;
           increased++;
         }
       }
       if(increased > 0) {
         j--;
       } else {
         value[j] = "";
       }
       j++;
       break;
     default :
         name[j] = IBS_getName(form.elements[i]);
         value[j] = _getValueFromStype(form.elements[i]);
         j++;
 }

 if (checkRequired) {
   //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
   //<input type="text" name="txtName" required="이름">
   
 	if (IBS_RequiredChk(form.elements[i])&&prev_j != j && value[prev_j] == "") {
 	 	IBS_RequiredChkMsg(form.elements[i]);
     //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
     try{
       form.elements[i].focus();
     } catch(ee) {;}
     
     return;
   }
 }
}

//QueryString을 조합한다.
for (i = 0; i < j; i++) {
 if (name[i] != '') plain_text += encodeURIComponent(name[i])+ "=" + encodeURIComponent(value[i]) + "&";
}

//마지막에 &를 없애기 위함
if (plain_text != "")  plain_text = plain_text.substr(0, plain_text.length -1);

return plain_text;
}



//2012-10-18 카렌더 슬래시 제거용      
function FormQueryStringEnc2(form, checkRequired) {

if (typeof form != "object" || form.tagName != "FORM") {
 IBS_ShowErrMsg("FormQueryStringEnc2 함수의 form 인자는 FORM 태그가 아닙니다.");
 return "";
}

if(checkRequired==null) checkRequired=false;

var name = new Array(form.elements.length);
var value = new Array(form.elements.length);
var j = 0;
var plain_text="";

//사용가능한 컨트롤을 배열로 생성한다.
len = form.elements.length;
for (i = 0; i < len; i++) {
 var prev_j = j;
 switch (form.elements[i].type) {
   case "button":
   case "reset":
   case "submit":
     break;
   case "radio":
   case "checkbox":
       if (form.elements[i].checked == true) {
         name[j] = IBS_getName(form.elements[i]);
         value[j] = form.elements[i].value;
         j++;
       }
       break;
   case "select-one":
       name[j] = IBS_getName(form.elements[i]);
       var ind = form.elements[i].selectedIndex;
       if(ind >= 0) {
         if (form.elements[i].options[ind].value != '' || checkRequired)
           value[j] = form.elements[i].options[ind].value;
         else
         	value[j] = "";
          // value[j] = form.elements[i].options[ind].text;
       } else {
         value[j] = "";
       }
       j++;
       break;
   case "select-multiple":
       name[j] = IBS_getName(form.elements[i]);
       var llen = form.elements[i].length;
       var increased = 0;
       for( k = 0; k < llen; k++) {
         if (form.elements[i].options[k].selected) {
           name[j] = IBS_getName(form.elements[i]);
           if (form.elements[i].options[k].value != '')
             value[j] = form.elements[i].options[k].value;
           else
             value[j] = form.elements[i].options[k].text;
           j++;
           increased++;
         }
       }
       if(increased > 0) {
         j--;
       } else {
         value[j] = "";
       }
       j++;
       break;
     default :
         name[j] = IBS_getName(form.elements[i]);
         value[j] = _getValueFromStype(form.elements[i]);
         j++;
 }

 if (checkRequired) {
   //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
   //<input type="text" name="txtName" required="이름">
   
 	if (IBS_RequiredChk(form.elements[i])&&prev_j != j && value[prev_j] == "") {
 	 	IBS_RequiredChkMsg(form.elements[i]);
     //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
     try{
       form.elements[i].focus();
     } catch(ee) {;}
     
     return;
   }
 }
}

//QueryString을 조합한다.
for (i = 0; i < j; i++) {
// if (name[i] != '') plain_text += encodeURIComponent(name[i])+ "=" + encodeURIComponent(value[i]) + "&";
 if (name[i] != '') plain_text += name[i]+ "=" + value[i] + "&";
}

//마지막에 &를 없애기 위함
if (plain_text != "")  plain_text = plain_text.substr(0, plain_text.length -1);

return plain_text;
}

function _getValueFromStype(obj){
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
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



var $forms = [];

function getFormDatas() {
    var forms = document.getElementsByTagName("form");
    var formSize = forms.length;
    for(var i=0;i<formSize;i++) {
        var form = forms[i];
        var els = form.elements;
        var size = els.length;
        for(var idx=0;idx<size;idx++) {
            var element = els[idx];
            $forms[element.name] = element.value;
        }
    }
    return $forms;
}

//--------------------------make Page Index ---------------------------------------------
	//페이지 인덱스 처리 부분 
//---------------------------------------------------------------------------------------
	var current_page = -1;
	/* page index */
	function makePageIndex( sheetObj , tp , p){
		try{
			if (document.getElementById("pageindex").firstChild) {
				document.getElementById("pageindex").removeChild(document.getElementById("pageindex").firstChild);
			}
			if(p==null||p==undefined){
				p = 50;
			}
			current_page = tp;
			var sr = sheetObj.SearchRows(); //전체 조회 건수
			var page = p; //페이지당 레코드 수
			var thispage = tp; //현재 페이지
			var pagecnt = 5; //한번에 표시할 페이지 개수
			var lastpage = Math.ceil(sr/page); //마지막 페이지 인덱스
			
			var li = null;
			var tt = null;
			var a = null;
			var ul = document.createElement("DIV");
			ul.style.textAlign = "center";
		
			var k=1;
			if(thispage!= 1){
				  li = document.createElement("span");
				  li.style.padding = "1px 4px 1px 4px";
				  li.style.cursor = "hand";
				  a = document.createElement("a");
					tt =  document.createTextNode("<<");
					addEventHandler(li,"click",pagemove,{methodName:"GoToFirstPage",page:1,sheetId:sheetObj});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					li = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "hand";
					a = document.createElement("a");
					addEventHandler(li,"click",pagemove,{methodName:"GoToPrevPage",page:tp-1,sheetId:sheetObj});
					tt =  document.createTextNode("<");
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
			}
			
			
			var sr = (Math.ceil(tp/pagecnt)*pagecnt)-(pagecnt-1);
			
			for(var i=sr;i<(sr+pagecnt);i++){
				if(i<=lastpage){
					li = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "hand";
					a = document.createElement("a");
					tt =  document.createTextNode(i);
					addEventHandler(li,"click",pagemove,{methodName:"GoToPageNum",page:i,sheetId:sheetObj});
					if(i==tp)	{	
						li.style.fontWeight  = "bold";
						li.style.textDecoration  = "underline";
					}
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
				}	
			}		
			
			if(thispage < lastpage){
					a = document.createElement("a");
				  li = document.createElement("span");
				  li.style.padding = "1px 4px 1px 4px";
				  li.style.cursor = "hand";
					tt =  document.createTextNode(">");
					addEventHandler(li,"click",pagemove,{methodName:"GoToNextPage",page:tp+1,sheetId:sheetObj});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					li = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "hand";
					tt =  document.createTextNode(">>");
					a = document.createElement("a");
					addEventHandler(li,"click",pagemove,{methodName:"GoToLastPage",page:lastpage,sheetId:sheetObj});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
			}
			
			ul.className = "pageindex";
			document.getElementById("pageindex").appendChild(ul);
		}catch(ex){
			alert(ex.message);
		}
		
	}
	function pagemove(param){
		var mn = param.methodName;
		var page = param.page;
		var sheetObj = param.sheetId;
		if(mn=="GoToPageNum"){
			sheetObj.GoToPageNum(page);	
		}else{
			eval(sheetObj+"."+mn+"()");
		}
		makePageIndex(sheetObj,page);
		
	}
	
	function addEventHandler (obj,evtName,func,param) {
		
	    if (obj.addEventListener) {   // all browsers except IE before version 9
	        obj.addEventListener (evtName, function(){func(param)} , false );
	    } 
	    else {
	        if (obj.attachEvent) {    // IE before version 9
	            obj.attachEvent ("on"+evtName, function(){func(param)});
	        }
	    }
	}

	
	function makePageIndex2( sheetObj , tp , p ){
		try{
			if (document.getElementById("pageindex").firstChild) {
				document.getElementById("pageindex").removeChild(document.getElementById("pageindex").firstChild);
			}
			
			if(sheetObj.RowCount() <= 0) return;
			
			if(p=='all'){
				return;
			}
			if(p==null||p==undefined){
				p = 50;
			}
			current_page = tp;
			var sr = sheetObj.GetTotalRows(); //전체 조회 건수
			if(sr == 0)return;
				
			var page = p; //페이지당 레코드 수
			var thispage = tp; //현재 페이지
			var pagecnt = 5; //한번에 표시할 페이지 개수
			var lastpage = Math.ceil(sr/page); //마지막 페이지 인덱스
			
			var li = null;
			var li2 = null;
			var tt = null;
			var tt2 = null;
			var a = null;
			var ul = document.createElement("DIV");
			ul.style.textAlign = "center";
		
			var k=1;
			if(thispage!= 1){
				  li = document.createElement("span");
				  li2 = document.createElement("span");
				  li.style.padding = "1px 4px 1px 4px";
				  li.style.cursor = "pointer";
				  a = document.createElement("a");
					tt =  document.createTextNode("<<");
					addEventHandler(li,"click",pagemove2,{methodName:"GoToPageNum",page:1,sheetId:sheetObj});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					li = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "pointer";
					a = document.createElement("a");
					addEventHandler(li,"click",pagemove2,{methodName:"GoToPageNum",page:tp-1,sheetId:sheetObj});
					tt =  document.createTextNode("<");
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					ul.appendChild(li2);
			}
			
			
			var sr = (Math.ceil(tp/pagecnt)*pagecnt)-(pagecnt-1);
			
			for(var i=sr;i<(sr+pagecnt);i++){
				if(i<=lastpage){
					li = document.createElement("span");
					li2 = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "pointer";
					a = document.createElement("a");
					tt =  document.createTextNode(i);
					
					if(i==tp)	{	
						li.style.fontWeight  = "bold";
//						li.style.textDecoration  = "underline";
					}else{
						addEventHandler(li,"click",pagemove2,{methodName:"GoToPageNum",page:i,sheetId:sheetObj});
					}
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					ul.appendChild(li2);
				}	
			}		
			
			if(thispage < lastpage){
					a = document.createElement("a");
				  li = document.createElement("span");
				  li.style.padding = "1px 4px 1px 4px";
				  li.style.cursor = "pointer";
					tt =  document.createTextNode(">");
					addEventHandler(li,"click",pagemove2,{methodName:"GoToPageNum",page:tp+1,sheetId:sheetObj});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					li = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "pointer";
					tt =  document.createTextNode(">>");
					a = document.createElement("a");
					addEventHandler(li,"click",pagemove2,{methodName:"GoToPageNum",page:lastpage,sheetId:sheetObj});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					ul.appendChild(li2);
					
			}
			
			ul.className = "pageindex";
			tt2 =  document.createTextNode("[ 총 "+ sheetObj.GetTotalRows() +" 건 ]");
			li.appendChild(tt);
			li2.appendChild(tt2);
			document.getElementById("pageindex").appendChild(ul);
		}catch(ex){
			alert(ex.message);
		}
		
	}
	//고객사 리뉴얼 탭용 페이징 처리
	function makePageIndex_v2( sheetObj , tp , p,tabName,tabIndex ){
		try{
			if (document.getElementById("pageindex"+tabIndex).firstChild) {
				document.getElementById("pageindex"+tabIndex).removeChild(document.getElementById("pageindex"+tabIndex).firstChild);
			}
			
			if(sheetObj.RowCount() <= 0) return;
			
			if(p=='all'){
				return;
			}
			if(p==null||p==undefined){
				p = 50;
			}
//			tabs[tabName+tabIndex].current_page = tp;
			current_page = tp;
			var sr = sheetObj.GetTotalRows(); //전체 조회 건수
			if(sr == 0)return;
				
			var page = p; //페이지당 레코드 수
			var thispage = tp; //현재 페이지
			var pagecnt = 5; //한번에 표시할 페이지 개수
			var lastpage = Math.ceil(sr/page); //마지막 페이지 인덱스
			
			var li = null;
			var li2 = null;
			var tt = null;
			var tt2 = null;
			var a = null;
			var ul = document.createElement("DIV");
			ul.style.textAlign = "center";
		
			var k=1;
			if(thispage!= 1){
				  li = document.createElement("span");
				  li2 = document.createElement("span");
				  li.style.padding = "1px 4px 1px 4px";
				  li.style.cursor = "pointer";
				  a = document.createElement("a");
					tt =  document.createTextNode("<<");
					addEventHandler(li,"click",pagemove_v2,{methodName:"GoToPageNum",page:1,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					li = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "pointer";
					a = document.createElement("a");
					addEventHandler(li,"click",pagemove_v2,{methodName:"GoToPageNum",page:tp-1,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
					tt =  document.createTextNode("<");
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					ul.appendChild(li2);
			}
			
			
			var sr = (Math.ceil(tp/pagecnt)*pagecnt)-(pagecnt-1);
			for(var i=sr;i<(sr+pagecnt);i++){
				if(i<=lastpage){
					li = document.createElement("span");
					li2 = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "pointer";
					a = document.createElement("a");
					tt =  document.createTextNode(i);
					
					if(i==tp)	{	
						li.style.fontWeight  = "bold";
//						li.style.textDecoration  = "underline";
					}else{
						addEventHandler(li,"click",pagemove_v2,{methodName:"GoToPageNum",page:i,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
					}
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					ul.appendChild(li2);
				}	
			}		
			
			if(thispage < lastpage){
					a = document.createElement("a");
				  li = document.createElement("span");
				  li.style.padding = "1px 4px 1px 4px";
				  li.style.cursor = "pointer";
					tt =  document.createTextNode(">");
					addEventHandler(li,"click",pagemove_v2,{methodName:"GoToPageNum",page:tp+1,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					li = document.createElement("span");
					li.style.padding = "1px 4px 1px 4px";
					li.style.cursor = "pointer";
					tt =  document.createTextNode(">>");
					a = document.createElement("a");
					addEventHandler(li,"click",pagemove_v2,{methodName:"GoToPageNum",page:lastpage,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
					a.appendChild(tt);
					li.appendChild(a);
					ul.appendChild(li);	
					ul.appendChild(li2);
					
			}
			
			ul.className = "pageindex";
			tt2 =  document.createTextNode("[ 총 "+ sheetObj.GetTotalRows() +" 건 ]");
			li.appendChild(tt);
			li2.appendChild(tt2);
			document.getElementById("pageindex"+tabIndex).appendChild(ul);
		}catch(ex){
			alert(ex.message);
		}
		
	}
	//탭 아닌 화면 페이징 신규 css
	function makePageIndex2_v3( sheetObj , tp , p ){
		try{
			tp = parseInt(tp, 10);   //문자열이어도 숫자로 강제 변환
			var container = document.getElementById("pageindex");
			while(container.firstChild){
				container.removeChild(container.firstChild);
			}

			if(sheetObj.RowCount() <= 0) return;

			if(p=='all'){
				return;
			}
			if(p==null||p==undefined){
				p = 50;
			}
			current_page = tp;

			var sr = sheetObj.GetTotalRows();
			if(sr == 0) return;

			var page = p;
			var thispage = tp;
			var pagecnt = 5;
			var lastpage = Math.ceil(sr/page);

			// 총 건수
			var totalDiv = document.createElement("DIV");
			totalDiv.className = "AllPaging";
			totalDiv.appendChild(document.createTextNode("총 " + sr + "건"));
			container.appendChild(totalDiv);

			// 페이지 버튼 영역
			var countDiv = document.createElement("DIV");
			countDiv.className = "AllPagingCount";

			// 1페이지가 아닐 때만 << , < 버튼 생성
			if(thispage != 1){
				var btnFirst = document.createElement("button");
				btnFirst.type = "button";
				btnFirst.className = "ButPagLeft02";
				addEventHandler(btnFirst,"click",pagemove2,{methodName:"GoToPageNum",page:1,sheetId:sheetObj});
				countDiv.appendChild(btnFirst);

				var btnPrev = document.createElement("button");
				btnPrev.type = "button";
				btnPrev.className = "ButPagLeft01";
				addEventHandler(btnPrev,"click",pagemove2,{methodName:"GoToPageNum",page:tp-1,sheetId:sheetObj});
				countDiv.appendChild(btnPrev);
			}

			// 페이지 번호
			var startPage = (Math.ceil(tp/pagecnt)*pagecnt)-(pagecnt-1);
			for(var i=startPage; i<(startPage+pagecnt); i++){
				if(i<=lastpage){
					var pTag = document.createElement("p");
					pTag.appendChild(document.createTextNode(i));

					if(i==tp){
						pTag.style.color = "#fff";
						pTag.style.backgroundColor = "#272E47";
					}else{
						pTag.style.cursor = "pointer";
						addEventHandler(pTag,"click",pagemove2,{methodName:"GoToPageNum",page:i,sheetId:sheetObj});
					}
					countDiv.appendChild(pTag);
				}
			}

			// 마지막 페이지가 아닐 때만 > , >> 버튼 생성
			if(thispage < lastpage){
				var btnNext = document.createElement("button");
				btnNext.type = "button";
				btnNext.className = "ButPagRight01";
				addEventHandler(btnNext,"click",pagemove2,{methodName:"GoToPageNum",page:tp+1,sheetId:sheetObj});
				countDiv.appendChild(btnNext);

				var btnLast = document.createElement("button");
				btnLast.type = "button";
				btnLast.className = "ButPagRight02";
				addEventHandler(btnLast,"click",pagemove2,{methodName:"GoToPageNum",page:lastpage,sheetId:sheetObj});
				countDiv.appendChild(btnLast);
			}

			container.appendChild(countDiv);

		}catch(ex){
			alert(ex.message);
		}
	}
	//탭 사용하는 화면 페이징 신규 css
	function makePageIndex_v3( sheetObj , tp , p, tabName, tabIndex ){
		try{
			tp = parseInt(tp, 10);   //문자열이어도 숫자로 강제 변환
			var container = document.getElementById("pageindex"+tabIndex);
			while(container.firstChild){
				container.removeChild(container.firstChild);
			}

			if(sheetObj.RowCount() <= 0) return;

			if(p=='all'){
				return;
			}
			if(p==null||p==undefined){
				p = 50;
			}
			current_page = tp;

			var sr = sheetObj.GetTotalRows();
			if(sr == 0) return;

			var page = p;
			var thispage = tp;
			var pagecnt = 5;
			var lastpage = Math.ceil(sr/page);

			// 총 건수
			var totalDiv = document.createElement("DIV");
			totalDiv.className = "AllPaging";
			totalDiv.appendChild(document.createTextNode("총 " + sr + "건"));
			container.appendChild(totalDiv);

			// 페이지 버튼 영역
			var countDiv = document.createElement("DIV");
			countDiv.className = "AllPagingCount";

			// 1페이지가 아닐 때만 << , < 버튼 생성
			if(thispage != 1){
				var btnFirst = document.createElement("button");
				btnFirst.type = "button";
				btnFirst.className = "ButPagLeft02";
				addEventHandler(btnFirst,"click",pagemove_v2,{methodName:"GoToPageNum",page:1,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
				countDiv.appendChild(btnFirst);

				var btnPrev = document.createElement("button");
				btnPrev.type = "button";
				btnPrev.className = "ButPagLeft01";
				addEventHandler(btnPrev,"click",pagemove_v2,{methodName:"GoToPageNum",page:tp-1,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
				countDiv.appendChild(btnPrev);
			}

			// 페이지 번호
			var startPage = (Math.ceil(tp/pagecnt)*pagecnt)-(pagecnt-1);
			for(var i=startPage; i<(startPage+pagecnt); i++){
				if(i<=lastpage){
					var pTag = document.createElement("p");
					pTag.appendChild(document.createTextNode(i));

					if(i==tp){
						pTag.style.color = "#fff";
					    pTag.style.backgroundColor = "#272E47";
					}else{
						pTag.style.cursor = "pointer";
						addEventHandler(pTag,"click",pagemove_v2,{methodName:"GoToPageNum",page:i,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
					}
					countDiv.appendChild(pTag);
				}
			}

			// 마지막 페이지가 아닐 때만 > , >> 버튼 생성
			if(thispage < lastpage){
				var btnNext = document.createElement("button");
				btnNext.type = "button";
				btnNext.className = "ButPagRight01";
				addEventHandler(btnNext,"click",pagemove_v2,{methodName:"GoToPageNum",page:tp+1,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
				countDiv.appendChild(btnNext);

				var btnLast = document.createElement("button");
				btnLast.type = "button";
				btnLast.className = "ButPagRight02";
				addEventHandler(btnLast,"click",pagemove_v2,{methodName:"GoToPageNum",page:lastpage,sheetId:sheetObj,tabName:tabName,tabIndex:tabIndex});
				countDiv.appendChild(btnLast);
			}

			container.appendChild(countDiv);

		}catch(ex){
			alert(ex.message);
		}
	}
	function pagemove2(param){
		try{
			
			pageSearch(param);
		}catch(e){
			alert(e.message);
		}
		
	}
	function pagemove_v2(param){
		try{
			tabs[param.tabName+param.tabIndex]["pageSearch"](param);
//			pageSearch(param);
		}catch(e){
			alert(e.message);
		}
		
	}
	
	
//--------------------------make Page Index ---------------------------------------------

	
/*-------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * method : setChangeTheme
 * desc : 그리드 테마설정
 * param list
 * param1 : obj       대상 그리드
 * param2 : gubun     테마 설정 (S)
-------------------------------------------------------------------------------*/
function setChangeTheme(obj , gubun){
	if(gubun == "S"){
		obj.SetTheme('GN', 'Green');
	}
	
  
/*  테마화면은 ibsheet 샘플 참조
	mySheet.SetTheme('BL', 'Blue');
	mySheet.SetTheme('BN', 'Brown');
	mySheet.SetTheme('GY', 'Gray');
	mySheet.SetTheme('GN', 'Green');
	mySheet.SetTheme('NB', 'Navy');
	mySheet.SetTheme('OR', 'Orange');
	mySheet.SetTheme('PP', 'Purple');
	mySheet.SetTheme('YL', 'Yellow');
	mySheet.SetTheme('LBN', 'LightBrown');
	mySheet.SetTheme('LGY', 'LightGray');
	mySheet.SetTheme('LGN', 'LightGreen');
	mySheet.SetTheme('LPP', 'LightPurple');
	mySheet.SetTheme('LS', 'LightSky');
*/
}

/*------------------------------------------------------------------------------
 * method : setLinkCol
 * desc : 링크 컬럼 디자인 설정
 * param list
 * param1 : obj       대상 그리드
 * param2 : colName   대상 컬럼
-------------------------------------------------------------------------------*/
function setLinkCol(obj , colName, imageWidth, imageHeight){
	imageWidth = imageWidth == null || imageWidth == "" ? "15px" : imageWidth + "px";  
	imageHeight = imageHeight == null || imageHeight == "" ? "15px" : imageHeight + "px";  
	obj.SetDataLinkMouse(colName , 1);
	obj.SetColFontColor(colName, "#0100FF");
	
	var info = {HoverUnderline:false, ImgWidth:imageWidth,ImgHeight:imageHeight};
	obj.SetColProperty(colName, info);
}

/*------------------------------------------------------------------------------
 * method : fnPopupCalendar
 * desc : 달력 관련
 * param list
 * param1 : fobj   from obj
 * param2 : tobj   to obj
 * param3 : index  없으면 from , T 이면 to 에서 달력 설정
-------------------------------------------------------------------------------*/
var _arr = new Array();
function fnPopupCalendar(fobj , tobj , index ) {
    var f = document.getElementById(fobj);
    var fv = f.value;
	if(fv == "") fv= '${currDate}';
    if( tobj == null || tobj == "undefined") {
    	IBShowCalendar(fv, { Format: "Ymd", Target: f, Result:f , CalButtons:"Today|Close"});
    	return;
    }
    
    var t = document.getElementById(tobj);
    tv = t.value;
    if(tv == "") tv= '${currDate}';

    _arr[0] = f ;
    _arr[1] = t;
    _arr[2] = index;
    if( index == "T"){
    	IBShowCalendar(tv, { Format: "Ymd", Target: t, Result:t , CallBack:"_checkDate" , CalButtons:"Today|Close"});
    } else {
    	IBShowCalendar(fv, { Format: "Ymd", Target: f, Result:f , CallBack:"_checkDate" , CalButtons:"Today|Close"});
    }
    
}

function _checkDate(date){
	
  	try{
      	var sdate = _ConvertNumber(_arr[0].value);
      	var edate = _ConvertNumber(_arr[1].value);
      	var target = _arr[2];

      	
//      	alert(sdate + " " + edate + " "+round);
      	if(edate!=""||sdate!=""){
      		//종료일 보다 후일인 경우
      		if(parseInt(sdate)>parseInt(edate)){
      			alert("시작일 값이 종료일보다 큽니다.");
      			if(_arr[2] == "T")
      				_arr[1].value = common.getFormatedDate(sdate);
      			else 
      				_arr[0].value = common.getFormatedDate(edate);
      			return;
      		}
//      		//두 날짜 차이가 3개월 이상인 경우
//      		alert(_getDayInterval(sdate,edate) + "  " +round);
//      		if(getDayInterval(sdate,edate)> round){
//      			alert("최대 3개월치 데이터만 조회하실 수 있습니다..");
//      			_arr[0].value = "";	
//      			return;
//      		}
      	}
    }catch(e){
    	alert(e.message);	
    }
  }

/* -----------------------------------------------------------------------------
Title   :   두 Time이 며칠 차이나는지 구함 
--------------------------------------------------------------------------------
Argument:	[0]String : 비교할 일자1( YYYYMMDD )
            [1]String : 비교할 일자2( YYYYMMDD )
Return	:	[0]String : 비교 결과 후 차이 나는 일수 수  
Example :   1) getDayInterval('20050501','20050401');   ==>  '-29'  일  
		    2) getDayInterval('20050501','20050506');   ==>  '6'  일 
----------------------------------------------------------------------------- */   
function getDayInterval(time1,time2) {
   
   var date1 = _toTimeObject(time1);
   var date2 = _toTimeObject(time2);
   var day   = 1000 * 3600 * 24; //24시간

   return parseInt((date2 - date1) / day, 10) + 1;
}

/* -----------------------------------------------------------------------------
Title   :   String 객체를 Time 객체로 변환 
Action	:   Time 스트링을 자바스크립트 Date 객체로 변환  parameter time: Time 형식의 String  
--------------------------------------------------------------------------------
Argument:	[0]String : 변환 할 년월일( YYYYMMDD )
Return	:	[0]Time 객체 :  입력 받은 String 을 변환한 Time 객체   
Example :   1) toTimeObject( '20050501' ) ==>  Time 객체          
----------------------------------------------------------------------------- */   
function _toTimeObject(time) { //parseTime(time)
  // Time 스트링을 자바스크립트 Date 객체로 변환  parameter time: Time 형식의 String
  var year  = time.substr(0,4);
  var month = time.substr(4,2) - 1; // 1월=0,12월=11
  var day   = time.substr(6,2);
  var hour  = time.substr(8,2);
  var min   = time.substr(10,2);

  return new Date(year,month,day,hour,min);
}
/* -----------------------------------------------------------------------------
Title   :   숫자가 아닌 값들은 제거한다. 
Action	:   숫자 이외에 모든 값들을 제거한다. 
--------------------------------------------------------------------------------
Argument:	[0]Value : 
Return	:	[0]Value
Example :   1) ConvertNumber('\12,000') : 12000    
            2) ConvertNumber('2002-08-10') : 20020810   
----------------------------------------------------------------------------- */    
function _ConvertNumber(value)
{
	var strNumber = "";
	var s = new String(value);
			
	for(i=0; i < value.length; i++)
	{
		if(parseInt(value.slice(i,i+1))>=0 && parseInt(value.slice(i,i+1))<=9)
			strNumber += value.slice(i,i+1);
	}

	if(s.substr(0,1) == "-") return s.substr(0,1) + strNumber;
	else return strNumber
}


/*Sheet 각종 이벤트 처리*/
function doAction(sAction)
{
  switch(sAction)
  {
	case "reload":
		mySheet.RemoveAll();
	break;
	case "formClear":
		document.forms.reset();
	break;
	case "image":
		if( mySheet.GetColHidden("IMAGE") == 1 ){
			mySheet.SetDataRowHeight(20);
			mySheet.SetColHidden("IMAGE", false );
			mySheet.SetColHidden("IMAGE_PATH", true );
			
			for ( var i = 1 ; i < mySheet.RowCount()+1 ; i++){
				mySheet.InitCellProperty( i,"IMAGE" , {Type:"Image", ImgHeight:20});
			}

		} else {
			mySheet.SetDataRowHeight(100);
			mySheet.SetColHidden("IMAGE", true );
			mySheet.SetColHidden("IMAGE_PATH", false );
			
			for ( var i = 1 ; i < mySheet.RowCount()+1 ; i++){
				mySheet.InitCellProperty(i,"IMAGE_PATH",{Type:"Image", ImgHeight:100});
			}
			
		}
	break;
  }
}


//AS-IS 그리드 컬럼 추출
function GetColumnToText(gridObj){
	
	var path = "C:\\formToText.txt";
	var fso=new ActiveXObject('Scripting.FileSystemObject');
	var fileObj=fso.CreateTextFile(path,true);
	
//	var grid = gridObj;
	var grid = $C('grid');
		var colCount = grid.getColCount();
 		var headerText = "";
 		var selectedFlg = false;
 		
 		for(var i=0; i<colCount; i++){
			var colId 		= grid.getColHDKey(i); 
			var colText 	= grid.getColHDText(colId);
			var colWidth 	= grid.getColWidth(colId);
			var colType 	= grid.getColType(colId);
			var updateEdit = "";
			
			var headerProperty = "";
	  		//alert("test : "+colId + "test : "+colText + "test : "+colWidth + "test : "+colType);
			if(i==0){
				//alert("first"+i);
				if(colId=="SELECTED"){
					headerText = 'var headers = [ {Text:"선택|';
					headerProperty = '[';
					//headerProperty += '{Type:"CheckBox",Width:30,SaveName:"SELECTED",Align:"center"},';
					selectedFlg=true;
				}else{
					headerText = 'var headers = [ {Text:"'+colText+'|';
				}
			}else if(i<colCount-1){
				headerText += colText+'|';
			}else{
				headerText += colText;
			}
			
			switch(colType){
				case "t_checkbox":
					colType = "CheckBox";
					break;
				case "t_text":
					colType = "Text";
					updateEdit = ",UpdateEdit:false";
					break;
				case "t_number":
					colType = "Int";
					updateEdit = ",UpdateEdit:false";
					break;
				case "t_date":
					colType = "Date";
					updateEdit = ",UpdateEdit:false";
					break;
				case "t_imagetext":
					colType = "Text";
					updateEdit = ",UpdateEdit:false";
					break;
				default:
					break;
			}
		
			if(colWidth==125){
				colWidth=0;
				headerProperty += '{Type:"'+colType+'",Width:'+colWidth+',Hidden:true'+',SaveName:"'+colId+'"' +updateEdit+', Align:"center"}, //'+colText;
			}else{
				headerProperty += '{Type:"'+colType+'",Width:'+colWidth+',SaveName:"'+colId+'"' +updateEdit+', Align:"center"}, //'+colText;
			}
	 		fileObj.WriteLine(headerProperty);
	 		
	 		if(i==colCount-1){
	 			headerProperty = "";
	 			if(selectedFlg == true ){
					headerText += '|상태", Align:"Center"} ];';
					headerProperty += '{Type:"Status",Width:0,Hidden:true,SaveName:"STATUS"}]; // 상태';
			 		fileObj.WriteLine(headerProperty);
				}else{
					headerText += '", Align:"Center"} ];';
					headerProperty += '];';
			 		fileObj.WriteLine(headerProperty);
				}
	 		}
		}
 		//alert(headerText);
		 fileObj.WriteLine(headerText);
 		 //fileObj.Close();
 		 
  		
  		GetFormToText(fileObj);
  		alert("헤더및 폼정보추출완료 ("+path+")");

}

//TO-BE 그리드 컬럼 추출(hidden 미포함)
function GetColumnNameToText(gridObj){
	
	var path = "C:\\ColumnNameToText.txt";
	var fso=new ActiveXObject('Scripting.FileSystemObject');
	var fileObj=fso.CreateTextFile(path,true);
	
//	var grid = gridObj;
	var grid = $C('grid');
		var colCount = grid.getColCount();
 		var columnKeyStr = "";
 		var columnTextStr = "";
 		var selectedFlg = false;
 		
 		for(var i=0; i<colCount; i++){
			var colId 		= grid.getColHDKey(i); 
			var colText 	= grid.getColHDText(colId);
			var colWidth 	= grid.getColWidth(colId);
			var colType 	= grid.getColType(colId);
		
			if(colWidth!=125 && colType != 't_imagetext'){

				if(i<colCount-1){
					columnTextStr += colText+'|';
				}else{
					columnTextStr += colText;
				}

				if(i<colCount-1){
					columnKeyStr += colId+',';
				}else{
					columnKeyStr += colId;
				}
			}
		}
 		fileObj.WriteLine(columnTextStr);
 		fileObj.WriteLine('---------------------------');
 		fileObj.WriteLine(columnKeyStr);
 		 
  		alert("헤더타이틀정보추출완료");

}

//TO-BE 그리드 컬럼 추출(hidden 포함)
function GetColumnNameToTextWithHidden(gridObj){
	
	var path = "C:\\ColumnNameToTextWithHidden.txt";
	var fso=new ActiveXObject('Scripting.FileSystemObject');
	var fileObj=fso.CreateTextFile(path,true);
	
//	var grid = gridObj;
	var grid = $C('grid');
		var colCount = grid.getColCount();
 		var columnKeyStr = "";
 		var columnKeyStrJsp = "";
 		var columnTextStr = "";
 		var selectedFlg = false;
 		
 		for(var i=0; i<colCount; i++){
			var colId 		= grid.getColHDKey(i); 
			var colText 	= grid.getColHDText(colId);
			var colWidth 	= grid.getColWidth(colId);
			var colType 	= grid.getColType(colId);
		
//			if(colId != 'SELECTED' && colType != 't_imagetext'){
			if(colId != 'SELECTED' ){

				if(colText != ""){
					if(i<colCount-1){
						columnTextStr += colText+'|';
					}else{
						columnTextStr += colText;
					}
	
					if(i<colCount-1){
						columnKeyStr += colId+',';
						columnKeyStrJsp += colId+'|';
					}else{
						columnKeyStr += colId;
						columnKeyStrJsp += colId;
					}
				}
			}
		}
 		fileObj.WriteLine(columnTextStr);
 		fileObj.WriteLine('---------------------------');
 		fileObj.WriteLine(columnKeyStrJsp);
 		fileObj.WriteLine('---------------------------');
 		fileObj.WriteLine(columnKeyStr);
 		 
  		alert("헤더타이틀정보추출완료");

}

//AS-IS 그리드 컬럼 추출
function GetFormToText(fileObj){
	
	//var path = "C:\\formToText.txt";
	//var fso=new ActiveXObject('Scripting.FileSystemObject');
	//var fileObj=fso.CreateTextFile(path,true);

	var form = $C('form');
	var fields = form.getFields();
	var formText = "";

	formText = '\n\n\n<form name="searchCondition">\n\n';
	formText += '\t<input type="hidden" name="s_SAVENAME">\n';

	formText = showAttribute(formText, fields);
	
	formText += '\t<div id="function" >\n';
	formText += '\t\t<div>\n';
	formText += '\t\t\t<table class="ib_column2">\n';
	formText += '\t\t\t\t<tr> \n';
	formText += '\t\t\t\t\t<th class="tit">AAA<th>\n';
	//var childs = form.getChilds();
	formText += '\t\t\t\t\t<td class="r20">\n';
	formText += '\t\t\t\t\t\t<input type="text" id="" value="" onkeypress="javascript:selectList();" >\n';
	formText += '\t\t\t\t\t</td>\n';
	formText += '\t\t\t\t</tr>\n';
	formText += '\t\t\t</table>\n';
	formText += '\t\t</div>\n';
	formText += '\t</div>\n';
	formText += '</form>';
	
	//alert(formText);
	fileObj.WriteLine(formText);
	fileObj.Close();
	 
	//alert("폼정보추출완료 ("+path+")");

}

//트랜젝션 파라미터 NULL 체크
function CheckParams(){
	
	var path = "C:\\log\\console.txt";
	var result = "C:\\log\\checkResult.txt";
	var fso=new ActiveXObject('Scripting.FileSystemObject');
	var fileObj=fso.OpenTextFile(path,1);
	var resultObj=fso.CreateTextFile(result,true);
	
	while(!fileObj.AtEndOfStream){
		var oneLine = fileObj.Readline();
		if(oneLine.indexOf("= ''")>-1){
				resultObj.WriteLine(oneLine);
		}
	}
	
	resultObj.Close();
	
	resultObj=fso.OpenTextFile(result,1);
	while(!resultObj.AtEndOfStream){
		var oneLine = resultObj.Readline();
		if(oneLine != ""){
			alert("SQL 파라미터 설정을 확인해 주십시오.(C:\log\checkResult.txt)");
			return;
		}
		
	}
		
	resultObj.Close();
	fileObj.Close();
}

function showAttribute(formText, obj) {   
	try {     
		var data = '';
		var cnt = 0;
		for (var attr in obj) {       
			formText += '\t<input type="hidden" name="'+obj[cnt].getId()+'" value="">\n';
			cnt++;
		}    
	} catch (e) {     
		alert(e.message);   
	}
	return formText;
}

/** gubun 1 : 전체 .. 무조건 select */
/*------------------------------------------------------------------------------
 * method : setSelectCombo
 * desc :  MultCombo 단일 select 설정
 * param list
 * param1 : obj    miltcombo obj 
 * param2 : str    json 
 * param3 : gubun  전체 사용 여부 ( 1 :전체 )
 * param4 : code   selected 대상 
-------------------------------------------------------------------------------*/
function setSelectCombo(obj , str , gubun , code){
    var result = {};

	obj.Init(0);
	obj.SetSaveName(obj.id);
    json = eval('('+str+')');
    for(var i in json){
    	obj.InsertItem(i, json[i].text, json[i].value);
    }
	if ( gubun == 1){
		obj.InsertItem(0, "전체", "");
		obj.SetSelectIndex("0");
	} 
	
	if (! (code == null || code =="undefined")){
		obj.SetSelectCode(code);
	}
}

/*------------------------------------------------------------------------------
 * method : setSelectMutiCombo
 * desc :  MultCombo 복수 선택 설정
 * param list
 * param1 : obj    miltcombo obj 
 * param2 : str    json 
 * param3 : gubun  전체 사용 여부 ( 1 :전체 )
-------------------------------------------------------------------------------*/
function setSelectMutiCombo(obj , str , gubun){

	 var result = {};

		obj.Init(0);
		obj.SetMultiSelect(true);
		obj.SetSaveName(obj.id);
	    json = eval('('+str+')');
	    for(var i in json){
	    	obj.InsertItem(i, json[i].text, json[i].value);
	    }
		if ( gubun == 1){
			obj.InsertItem(0, "전체", "");
			obj.SetSelectIndex("0");
		} 
		
//		if (! (code == null || code =="undefined")){
//			obj.SetSelectCode(code);
//		}
}

/*------------------------------------------------------------------------------
 * method : setSelectData
 * desc :  select 설정
 * param list
 * param1 : id     select id 
 * param2 : str    json 
 * param3 : gubun  전체 사용 여부 ( 1 :전체 )
 * param4 : code   selected 대상 
-------------------------------------------------------------------------------*/
function setSelectData( id , str , gubun , code){
	var elm = document.getElementById(id);

	if( gubun == 1 ){
		var opt = document.createElement("option"); //option 객체를 생성합니다.
    	opt.setAttribute("value", ""); 
    	opt.appendChild(document.createTextNode('전체')); 
    	elm.appendChild(opt);   
	}
	if(str == "") {
	    return;
	}
    json = eval('('+str+')');
    for(var i in json){
    	var opt = document.createElement("option"); //option 객체를 생성합니다.
    	opt.setAttribute("value", json[i].value); 
    	opt.appendChild(document.createTextNode( json[i].text));
    	if( code == json[i].value){
    		opt.selected = true;
    	}
    	 
    	elm.appendChild(opt);   
    }
   }

/*------------------------------------------------------------------------------
 * method : setSelectYear
 * desc :  기준년도를 기준으로 before year(number) select 설정
 * param list
 * param1 : id     select id 
 * param2 : yesr   기분년도 (기본은 현재의 년도) 
 * param3 : befyear   기준년도 -  befyear (구간)
-------------------------------------------------------------------------------*/
function setSelectYear( id, year , befyear){
	var elm = document.getElementById(id);
	var dt = new Date();
	if ( year == null || year == "undefined" || year == ""){
		year = dt.getFullYear();
	}

	for( i = befyear ; i > 0 ; i --){
		var code = year-(i-1);
		var opt = document.createElement("option"); //option 객체를 생성합니다.
    	opt.setAttribute("value", code); 
    	opt.appendChild(document.createTextNode( code ));
    	if( code == year){
    		opt.selected = true;
    	}
    	elm.appendChild(opt);   
	}
}
/*------------------------------------------------------------------------------
 * method : setSelectMonth
 * desc :  월 select 설정
 * param list
 * param1 : id     select id 
 * param2 : month   선택할 월
-------------------------------------------------------------------------------*/
function setSelectMonth( id, month ){
	var elm = document.getElementById(id);
	var dt = new Date();
	if ( month == null || month == "undefined" || month == ""){
		month = dt.getMonth()+1;
	}

	for( i = 1 ; i < 13 ; i ++){
		
		var opt = document.createElement("option"); //option 객체를 생성합니다.
    	if ( i < 10) {
    		opt.setAttribute("value", "0"+i);
    		opt.appendChild(document.createTextNode("0"+i ));
    	} else {
    		opt.setAttribute("value", i);
    		opt.appendChild(document.createTextNode(i));
    	}
    	if( i == month){
    		opt.selected = true;
    	}
    	elm.appendChild(opt);   
	}
}

function setSelectComboData(obj , text , code){
	obj.Init(0);
	obj.InsertItem(0, text, code);
	obj.SetSelectIndex("0");
	obj.SetSaveName(obj.id);
}


function sheetComboData(str){
    var result = {};
    var t = "";
    var c = "";
    if(str == "") {
        return;
    }
    json = eval('('+str+')');
    for(var i in json){
     t += "|"+json[i].text;
     c += "|"+json[i].value;
    }
    result.ComboCode = c.substring(1);
    result.ComboText = t.substring(1);
    return result;
   }
/** WISE GRID 의 결과 사용 */
function makeB2BData( str){
	return "{DATA:" + str.replace(/\n/g , '\\r\\n') +"}";
	
}
/** check ==1  인 값을 json 으로 만들어서 LoadSearchXml 로 데이타 조회 */
function GetCheckDataJson(sheet, col ,skipcols){
	if(sheet==null){
		alert("GetCheckDataJson 함수의 첫번째 인자는 ibsheet 객체여야 합니다.");
		return; 
	}
	
	var skipcolsArr = null;
	if(skipcols!=null){
		skipcolsArr = skipcols.split("|");
	}
	
	var rtnJson = "{ data: [" ;
	var selectedGrid = mySheet.FindCheckedRow(col);
	if (selectedGrid == "") return "";
	
	var arrRow = selectedGrid.split("|");
	
	for(idx=0; idx<arrRow.length; idx++){
		var temp = sheet.GetRowJson(arrRow[idx]);
		if(skipcolsArr!=null){ 
			for(var c=0;c<skipcolsArr.length;c++){
				delete temp[skipcolsArr[c]]; 
			}
		}
		if ( idx == arrRow.length-1){
			rtnJson = rtnJson + JSONtoString(temp) ;
		} else {
			rtnJson = rtnJson + JSONtoString(temp)+"," ;
		}
		//rtnJson.push(temp);
	}
	return rtnJson+" ] }";
}

function JSONtoString(object) {    
	 var results = [];    
	 
	 for (var property in object) {       
	  var value = object[property];        
	  if (value != null) {            
	   if(typeof value ===  "string") {
	    value = "'"+value+"'";
	   }
	   results.push(property.toString() + ': ' + value);        
	  }
	 }                         
	 
	 return '{' + results.join(', ') + '}';
	}

function enableButtons() {
//	for(var $idx in _root._buttons) {
//        $C(_root._buttons[$idx]).setDisable(false);
//    }
}

function disableButtons() {
//	for(var $idx in _root._buttons) {
//		$C(_root._buttons[$idx]).setDisable(true);
//	}
}

var searchInfo; 
	
function  kepSearch(frm ,  obj , method , flag ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
	IBS_SaveName(frm,obj);
	
	var pageNum = 0;
	
	if(method.indexOf("?") > -1){
		var paramObj = method.substring(method.indexOf("?") + 1, method.length).split("&");
		for(var inx = 0 ; inx < paramObj.length ; inx++){
			paramObj = paramObj[inx].split("=");
			if(paramObj[0] == "page"){
				pageNum = paramObj[1]; 
			}
		}
	}
	
	//조회조건 묶기
	if(pageNum<= 0){
		searchInfo = FormQueryStringEnc2(frm,true);
	}
	
	if(searchInfo){
//		disableButtons();
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		obj.SetWaitImageVisible(false);
		obj.SetWaitTimeOut(600); //10분 timeout
		if ( flag == "Y"){
			var param = {PageParam:"page",Param:searchInfo+"&onepagerow=10&pageflag=1" };
			//조회
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearchPaging(method,param);
		} else {
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearch(method,searchInfo,{Sync:1});
		}
	}
}
function  kepSearch_v2(frm ,  obj , method , flag ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
	IBS_SaveName(frm,obj);
	
	var pageNum = 0;
	
	if(method.indexOf("?") > -1){
		var paramObj = method.substring(method.indexOf("?") + 1, method.length).split("&");
		for(var inx = 0 ; inx < paramObj.length ; inx++){
			paramObj = paramObj[inx].split("=");
			if(paramObj[0] == "page"){
				pageNum = paramObj[1]; 
			}
		}
	}
	
	//조회조건 묶기
//	if(pageNum<= 0){ //처음부터 page들어와도 조회되도록
		searchInfo = FormQueryStringEnc2(frm,true);
//	}
	
	if(searchInfo){
//		disableButtons();
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		obj.SetWaitImageVisible(false);
		obj.SetWaitTimeOut(600); //10분 timeout
		if ( flag == "Y"){
			var param = {PageParam:"page",Param:searchInfo+"&onepagerow=10&pageflag=1" };
			//조회
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearchPaging(method,param);
		} else {
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearch(method,searchInfo,{Sync:1});
		}
	}
}

function  kepSearchNoBar(frm ,  obj , method , flag ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
	IBS_SaveName(frm,obj);
	
	//조회조건 묶기
	if(flag != "P"){
		searchInfo = FormQueryStringEnc2(frm,true);
	}
	
	if(searchInfo){
//		disableButtons();
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		obj.SetWaitImageVisible(true);
		if ( flag == "Y"){
			var param = {PageParam:"page",Param:searchInfo+"&onepagerow=10&pageflag=1" };
			//조회
			obj.DoSearchPaging(method,param);
		} else {
			obj.DoSearch(method,searchInfo,{Sync:1});
		}
	}
}


function  kepSearch_multi(frm ,  obj , method , flag ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
	IBS_SaveName_multi(frm,obj);
	
	var pageNum = 0;
	
	if(method.indexOf("?") > -1){
		var paramObj = method.substring(method.indexOf("?") + 1, method.length).split("&");
		for(var inx = 0 ; inx < paramObj.length ; inx++){
			paramObj = paramObj[inx].split("=");
			if(paramObj[0] == "page"){
				pageNum = paramObj[1]; 
			}
		}
	}
	
	//조회조건 묶기
	if(pageNum<= 0){
		searchInfo = FormQueryStringEnc2(frm,true);
	}
	
	if(searchInfo){
//		disableButtons();
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		obj.SetWaitImageVisible(false);
		obj.SetWaitTimeOut(600); //10분 timeout
		if ( flag == "Y"){
			var param = {PageParam:"page",Param:searchInfo+"&onepagerow=10&pageflag=1" };
			//조회
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearchPaging(method,param);
		} else {
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearch(method,searchInfo,{Sync:1});
		}
	}
}

//클릭시 버튼 비활성화 제거 
function  kepSearch2(frm ,  obj , method , flag ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
    
	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc2(frm , true);
	if(info){
		obj.SetWaitTimeOut(600); //10분 timeout
		//disableButtons();
		if ( flag == "Y"){
			var param = {PageParam:"page",Param : info+"&onepagerow=50&pageflag=1"+flag };
			//조회
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearchPaging(method,param);
		} else {
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearch(method,info);
		}
	}
}

function  kepSearch3(frm ,  obj , method , flag, pageCnt){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.

	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc2(frm , true);
	if(info){
		obj.SetWaitTimeOut(600); //10분 timeout
		disableButtons();

		if ( flag == "Y"){
			var param = {PageParam:"page",Param : info+"&onepagerow="+pageCnt+"&pageflag="+flag };
			//조회
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearchPaging(method,param);
		} else {
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearch(method,info);
		}
	}
}


function  kepSearch4(frm ,  obj , method , flag ,subparam){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
    
	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc2(frm , true)+subparam;
	if(info){
		obj.SetWaitTimeOut(600); //10분 timeout
		disableButtons();
		
		if ( flag == "Y"){
			var param = {PageParam:"page",Param : info+"&onepagerow=50&pageflag="+flag };
			//조회
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearchPaging(method,param);
		} else {
			loader_obj("Y");		// 로딩바 ON
			obj.DoSearch(method,info);
		}
	}
}




function  kepDownExcel(frm ,  obj , method , param ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.

	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc2(frm , true);
//	var info = FormQueryString(frm);
	
	var param2 = param;
	if(info){
//		disableButtons();
		//var excelparam = {URL:method , ExtendParam : info};
//		SheetName : "발주진행관리",
		param2.URL = method;
		param2.ExtendParam = info;		
		param2.ExtendParamMethod = "POST";
		param2.WordWrap = false;
		param2.Merge = 1;
		param2.SheetDesign = 1;
		param2.Multipart = 0;
		loader_obj("Y");		// 로딩바 ON
		obj.DirectDown2Excel(param2);
	}
}
function  kepDownExcel2(frm ,  obj , method , param ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.

	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc2(frm , true);
//	var info = FormQueryString(frm);
	
	var param2 = param;
	if(info){
//		disableButtons();
		//var excelparam = {URL:method , ExtendParam : info};
//		SheetName : "발주진행관리",
		param2.URL = method;
		param2.ExtendParam = info;		
		param2.ExtendParamMethod = "POST";
		param2.WordWrap = false;
		param2.Merge = 1;
		param2.SheetDesign = 1;
		param2.Multipart = 0;
		obj.DirectDown2Excel(param2);
	}
}
function  kepSave(frm ,  obj , method , col ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.

	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc(frm , true);
	if(info){
//		disableButtons();
		obj.SetShowMsgMode(0);
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		obj.SetWaitTimeOut(600); //10분 timeout
		loader_obj("Y");		// 로딩바 ON
		obj.DoSave(method,info , col , false);
		obj.SetShowMsgMode(1);
		//CheckParams();
	}
}
function  kepSaveNoCheck(frm ,  obj , method , col ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.

	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc(frm , true);
	if(info){
		obj.SetShowMsgMode(0);
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		obj.SetWaitTimeOut(600); //10분 timeout
		loader_obj("Y");		// 로딩바 ON
		var SaveStr = obj.GetSaveString();
		var rtnData = obj.GetSaveData(method,SaveStr);
		obj.LoadSaveData(rtnData);
		obj.SetShowMsgMode(1);
	}
}
function  kepSaveAll(frm ,  obj , method  ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.

	IBS_SaveName(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc(frm , true);
	if(info){
//		disableButtons();
		obj.SetShowMsgMode(0);
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		obj.SetWaitTimeOut(600); //10분 timeout
		loader_obj("Y");		// 로딩바 ON
		obj.DoAllSave(method,info);
		obj.SetShowMsgMode(1);
		//CheckParams();
	}
}

function mySheet_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet1_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet2_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet3_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet4_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet5_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet6_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet7_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet8_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet9_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}
function mySheet10_OnMessage(Msg, Level, IsConfirm) {
	loader_obj("N");
	alert(Msg);
}


function  kepSave_multi(frm ,  obj , method , col ){
	//mySheet.RemoveAll();
	//시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.

	IBS_SaveName_multi(frm ,obj);
	//조회조건 묶기
	var info = FormQueryStringEnc(frm , true);
	if(info){
//		disableButtons();
		obj.SetShowMsgMode(0);
		obj.SetUserAgent("XMLHttpRequest");	// 익셉션 처리를 위해 ajax 전송시 명시적으로 헤더에 셋팅
		loader_obj("Y");		// 로딩바 ON
		obj.DoSave(method,info , col , false);
		//CheckParams();
	}
}

//날짜 범위 체크(개월수 단위)
function isDateTermChecked(fromObj, toObj, mon,date1,date2)
{
	var fromdate = removeStr(document.getElementById(fromObj).value,'/');
	var todate = removeStr(document.getElementById(toObj).value,'/');

	var differ = common.checkTerm(todate,fromdate);
	
	if(mon==1){
		return false;
	}
	else if(mon==3){
		if(parseInt(differ) > 95)
		{
			alert("최대 조회기간은 3개월 입니다. 참조 바랍니다.");
			document.getElementById(fromObj).value = common.getFormatedDate(date1);
			document.getElementById(toObj).value = common.getFormatedDate(date2);
			return false;
		}
	}else if(mon==12){
		return false;
	}
	
	return true;
}


//엔터를 누르면 조회기능 실행
function onKeyPress(event) {
	if(event.charCode == 13) {
		selectList();
	}
}

//그리드의 선택된 행이 없는지 체크
function isChecked(mySheet, msgStr)
{
	var msg = (msgStr)? msgStr: '선택된  데이터가 없습니다.'; 
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	if (selectedGrid==""){
		alert(msg);
		return false;
	}
	return true;
}


function RGBToHex(colorValue)
{
	var colorArr = colorValue.split("|");
	  
  Red = colorArr[0];
  Green = colorArr[1];
  Blue = colorArr[2];
  a = GiveHex(Math.floor(Red / 16));
  b = GiveHex(Red % 16);
  c = GiveHex(Math.floor(Green / 16));
  d = GiveHex(Green % 16);
  e = GiveHex(Math.floor(Blue / 16));
  f = GiveHex(Blue % 16);

  z = a + b + c + d + e + f;
  return z;
}
function GiveHex(Dec)
{
   if(Dec == 10)
      Value = "A";
   else
   if(Dec == 11)
      Value = "B";
   else
   if(Dec == 12)
      Value = "C";
   else
   if(Dec == 13)
      Value = "D";
   else
   if(Dec == 14)
      Value = "E";
   else
   if(Dec == 15)
      Value = "F";
   else
      Value = "" + Dec;
  
   return Value;
}

function checkedSession(stCode){
	
	if(stCode == '403'){
		//팝업창이면 opener창을 redirect시킴.
		if(typeof opener == 'undefined'){
			alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
			parent.location.href = "/login/sub_login.do";
			return false;
		}else{
			alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
			opener.parent.location.href = "/login/sub_login.do";
			self.close();
			return false;
		}
	}
	return true;
}

/*------------------------------------------------------------------------------
 * method : isBrowserCheck
 * desc : 사용자 브라우저 체크
-------------------------------------------------------------------------------*/
function isBrowserCheck(){ 
	const agt = navigator.userAgent.toLowerCase(); 
	if (agt.indexOf("chrome") != -1) return 'Chrome'; 
	if (agt.indexOf("opera") != -1) return 'Opera'; 
	if (agt.indexOf("staroffice") != -1) return 'Star Office'; 
	if (agt.indexOf("webtv") != -1) return 'WebTV'; 
	if (agt.indexOf("beonex") != -1) return 'Beonex'; 
	if (agt.indexOf("chimera") != -1) return 'Chimera'; 
	if (agt.indexOf("netpositive") != -1) return 'NetPositive'; 
	if (agt.indexOf("phoenix") != -1) return 'Phoenix'; 
	if (agt.indexOf("firefox") != -1) return 'Firefox'; 
	if (agt.indexOf("safari") != -1) return 'Safari'; 
	if (agt.indexOf("skipstone") != -1) return 'SkipStone'; 
	if (agt.indexOf("netscape") != -1) return 'Netscape'; 
	if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla'; 
	if (agt.indexOf("msie") != -1) { 
    	let rv = -1; 
		if (navigator.appName == 'Microsoft Internet Explorer') { 
			let ua = navigator.userAgent; var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})"); 
		if (re.exec(ua) != null) 
			rv = parseFloat(RegExp.$1); 
		} 
		return 'Internet Explorer '+rv; 
	} 
}
/*------------------------------------------------------------------------------
 * method : copyToClipboard
 * desc : 크롬 복사용도를 위한 함수
-------------------------------------------------------------------------------*/
function copyToClipboard(val){
	const t = document.createElement("textarea");
	document.body.appendChild(t);
	t.value = val;
	t.select();
	document.execCommand('copy');
	document.body.removeChild(t);
}
/*------------------------------------------------------------------------------
 * method : mySheet_OnSelectMenu
 * desc : SetActionMenu 선택시 발생하는 이벤트
 * param list
 * param1 : sAction   event
-------------------------------------------------------------------------------*/
function mySheet_OnSelectMenu(sAction) {
	var st_agt = isBrowserCheck();
	switch(sAction) {
	case "셀복사" :
		var text = mySheet.GetCellValue( mySheet.MouseRow() , mySheet.MouseCol());
		if(st_agt == "Chrome"){
			copyToClipboard(text.toString());
		}else{
			window.clipboardData.setData("Text",text.toString());
		}
		break;
	case "행복사" :
		var obj = mySheet.GetRowJson(mySheet.MouseRow());
		if(st_agt == "Chrome"){
			copyToClipboard(JSONtoString(obj));
		}else{
			window.clipboardData.setData("Text",JSONtoString(obj));
		}
	break;
	case "엑셀파일저장" :
		loader_obj("Y");
		mySheet.Down2Excel({HiddenColumn:0});
	break;
	
	default :
	break;
	}
}
function mySheet0_OnSelectMenu(sAction) {
	var st_agt = isBrowserCheck();
	switch(sAction) {
	case "셀복사" :
		var text = mySheet0.GetCellValue( mySheet0.MouseRow() , mySheet0.MouseCol());
		if(st_agt == "Chrome"){
			copyToClipboard(text.toString());
		}else{
			window.clipboardData.setData("Text",text.toString());
		}
		break;
	case "행복사" :
		var obj = mySheet0.GetRowJson(mySheet0.MouseRow());
		if(st_agt == "Chrome"){
			copyToClipboard(JSONtoString(obj));
		}else{
			window.clipboardData.setData("Text",JSONtoString(obj));
		}
	break;
	case "엑셀파일저장" :
		loader_obj("Y");
		mySheet0.Down2Excel({HiddenColumn:0});
	break;
	
	default :
	break;
	}
}
function mySheet1_OnSelectMenu(sAction) {
	var st_agt = isBrowserCheck();
	switch(sAction) {
	case "셀복사" :
		var text = mySheet1.GetCellValue( mySheet1.MouseRow() , mySheet1.MouseCol());
		if(st_agt == "Chrome"){
			copyToClipboard(text.toString());
		}else{
			window.clipboardData.setData("Text",text.toString());
		}
		break;
	case "행복사" :
		var obj = mySheet1.GetRowJson(mySheet1.MouseRow());
		if(st_agt == "Chrome"){
			copyToClipboard(JSONtoString(obj));
		}else{
			window.clipboardData.setData("Text",JSONtoString(obj));
		}
	break;
	case "엑셀파일저장" :
		loader_obj("Y");
		mySheet1.Down2Excel({HiddenColumn:0});
	break;
	
	default :
	break;
	}
}

function mySheet2_OnSelectMenu(sAction) {
	var st_agt = isBrowserCheck();
	switch(sAction) {
	case "셀복사" :
		var text = mySheet2.GetCellValue( mySheet2.MouseRow() , mySheet2.MouseCol());
		if(st_agt == "Chrome"){
			copyToClipboard(text.toString());
		}else{
			window.clipboardData.setData("Text",text.toString());
		}
		break;
	case "행복사" :
		var obj = mySheet2.GetRowJson(mySheet2.MouseRow());
		if(st_agt == "Chrome"){
			copyToClipboard(JSONtoString(obj));
		}else{
			window.clipboardData.setData("Text",JSONtoString(obj));
		}
	break;
	case "엑셀파일저장" :
		loader_obj("Y");
		mySheet2.Down2Excel({HiddenColumn:0});
	break;
	
	default :
	break;
	}
}

function mySheet3_OnSelectMenu(sAction) {
	var st_agt = isBrowserCheck();
	switch(sAction) {
	case "셀복사" :
		var text = mySheet3.GetCellValue( mySheet3.MouseRow() , mySheet3.MouseCol());
		if(st_agt == "Chrome"){
			copyToClipboard(text.toString());
		}else{
			window.clipboardData.setData("Text",text.toString());
		}
		break;
	case "행복사" :
		var obj = mySheet3.GetRowJson(mySheet3.MouseRow());
		if(st_agt == "Chrome"){
			copyToClipboard(JSONtoString(obj));
		}else{
			window.clipboardData.setData("Text",JSONtoString(obj));
		}
	break;
	case "엑셀파일저장" :
		loader_obj("Y");
		mySheet3.Down2Excel({HiddenColumn:0});
	break;
	
	default :
	break;
	}
}
function IBS_PieChartSet(obj, s_title, s_text, height, locale) {
	
	var count			= "";
	var rate				= "";
	obj.SetOptions({
		Chart:{
			Type:"pie",
			Options3d:{
				Enabled : true,
				Alpha : 75
			}
		},
		Title:{
			Text:"s_title",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		ToolTip:{
			Enabled:true,
			Shadow:true,
			Formatter:function(){
				
				var rowArr = s_text.split("|");
				  
				for(var i=0;i<rowArr.length;i++){
					var point_name = rowArr[i];
					if(this.point.name ==  point_name){
						count	= normalSum;
						rate	= normalRate;						
					}

				}
				return count + '<br/>' + rate;
			},
			Style:{
				Color:"#000000",
				FontSize:"12px",
				FontWeight:"bold"
			}
		},
		plotOptions:{
			Pie:{
				StartAngle:30,
				Depth : 40,
				Size : 300,
				dataLabels: {
	                enabled: true,
	                distance: -30,				//파이 영역위에 레이블 표시
	                formatter:function(){			//레이블 표시 방식 (시리즈 색상: 시리즈명 /n 포이트명: 포인트값)
	                	if(this.point.name == "정상재고"){
	                		count	= normalSum;
	    					rate	= normalRate;
	    				}else if(this.point.name == "장기재고"){
	    					count	= longSum;
	    					rate	= longRate;
	    				}else{
	    					count	= faultySum;
	    					rate	= faultyRate;
	    				}
	                	return count + '<br/>' + rate;
	                }
	            }
			}
		},
		series: [{
            data: [
                ["정상재고", normalSum_num],
                ["장기재고", longSum_num],
                ["불용재고", faultySum_num]
            ],
            showInLegend: true 
        }],
        legend: {
            align: 'center',
            verticalAlign: 'bottom',
            layout: 'horizontal'
        },
	});
}








