var gJson = {DATA:[[]]};

/*
 * IBSheet를 생성(호출 위치에서 동적 생성)
 */
function createIBSheet(sheetid, width, height, locale) {
    var div_str = "";

    if (!locale) locale = "";

    Grids.Locale = locale;

    div_str += "<div id='DIV_" + sheetid + "' style='width:" + width + ";height:" + height + ";'>";
	div_str += "<script> IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>',\"DIV_" + sheetid + "\", \"" + sheetid + "\"); </script>"
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
	Grids.Locale = locale?locale:"";

	// width, height 적용
	obj.style.width = width;
	obj.style.height = height;

	IBSheet('<ibsheet Sync=\"1\" Data_Sync=\"0\"> </ibsheet>',obj.id, sheetid);
}

/* MergeSheet 속성에 설정 값 */
var msNone            = 0;      // 머지 없음
var msAll             = 1;      // 전부 머지 가능
var msPrevColumnMerge = 2;      // 앞 컬럼이 머지 된 경우 해당 행 안에서 머지 가능
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
		GetJsonStatus(sheet,status)
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
function IBS_InitSheet(sheet, info) {
	// 필수 입력 요소 체크
	if (!sheet || !info || !info.Cols) {
		alert("시트 초기화 정보가 올바르지 않습니다.");
	}

	var cInfo = CloneArray(info);

	if (!cInfo.Cfg) {
		cInfo.Cfg = {};
	}

	if (!cInfo.Headers) {
		cInfo.Headers = [
			{Text:"", Align:"Center"}
		];
	}

	if (!cInfo.HeaderMode) {
		cInfo.HeadersMode = {};
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

	sheet.SetConfig(cInfo.Cfg);
	sheet.InitHeaders(cInfo.Headers, cInfo.HeaderMode);
	sheet.InitColumns(cInfo.Cols);
}
