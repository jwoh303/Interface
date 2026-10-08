<%--
**********************************************
* 메뉴 : SMS보내기
* 화면 : SMS보내기
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 생성일 : 2016-09-26
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<%
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String userNameLoc = "";
String userTel = "";
String userInfo = "";
if (sessionInfo != null){ 
	userNameLoc = CommonUtil.nvl((String)sessionInfo.getUserNameLoc());
	userTel = CommonUtil.nvl((String)sessionInfo.getTel());
	userInfo = userNameLoc+" ("+userTel+")";
}  
%>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		
		var initsheet = {};
		
		initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 50,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 40,	EditLen : 50, Edit : true, Hidden : false}, 
		    			{Align : "Left",SaveName : "USER_NAME_LOC",		Header : "사용자명",	Type : "Text",	Width : 70, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Left",SaveName : "MOBILE_PHONE",		Header : "휴대폰번호",	Type : "Text",	Width : 190,	EditLen : 100,Hidden:false, Edit : true},
		];
		
		IBS_InitSheet(mySheet, initsheet,pagingMode);

	}
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");
		switch (str) {
			case "reload":
				kepReload('searchCondition');
				break;
			case "save":
				if (selectedGrid.length == 0){
					alert("수신자 정보가 없습니다.");
					return;
				}

				for(var inx = 0 ; inx < arrRow.length ; inx++){
					var st_m_phone = mySheet.GetCellValue(arrRow[inx], "MOBILE_PHONE");
					if(st_m_phone == ""){
						alert(inx+1+"번째 휴대폰번호 입력해야 합니다.");
						return;
					}
					if (!containsCharsOnly(st_m_phone,"-0123456789")) {
						alert(inx+1+"번째 숫자와 - 만 입력할수 있습니다.");
						return;
					}
				}
				
				// 마우스 우클릭 복사하는 경우를 위한 문자수 체크
				fn_TextAreaInputLimit('s_cont');
				
				if(document.forms.searchCondition.st_cont.value == ""){
					alert("내용 입력 바랍니다.");
					return;
				}
				if( document.forms.searchCondition.st_length.value > 90){
					document.forms.searchCondition.st_kind.value = "M";
				}else{
					document.forms.searchCondition.st_kind.value = "S";
				}
				if (!confirm('문자 전송하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/none/sendSms.do" , "SELECTED" );
				break;
			case "close":
				this.close();
			case "deleteRows": // 행삭제
				for(var inx = 0 ; inx < arrRow.length ; inx++){
					if(mySheet.GetCellValue(arrRow[inx], "sStatus") != "I"){
						alert("행추가로 등록된 행만 삭제 할 수 있습니다.");
						return;
					}
				}
				mySheet.RowDelete(selectedGrid, 1);	
				break;
			case "excel": // 일괄 업로드
				var params = { Mode : "NoHeader ", StartRow: "1", ColumnMapping:"|||1|"};
				mySheet.LoadExcel(params);
				break;
		}

	}
	function mySheet_OnLoadExcel() {
		var maxRow  = mySheet.RowCount();
		if(maxRow == 0){
			  return;
		}
		 
		if (3000 < maxRow + 1) {
			alert("3000건이하의 파일만 업로드하여 주세요.");
			mySheet.RemoveAll();
			return;
		} 
	}
	function mySheet_OnLoadData(DATA) {
		mt = new Date();
		return DATA;
	}
	
	function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
		if (msg != "") {
			alert(msg);
		}
	}


	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		grbRow = Row;
		if (column == "BUYER_NAME" ){ 
		}
		return;
	}
	
	

	var popupSel = "";
	//팝업함수호출
	function doPop(str) {
		switch (str) {
		case "user_multi":
			openSearchPopup("/none/showCommonNoNeUserChoiceMultiPop.do","",'1000,500,no');
			popupSel = "user_multi";
			break;
		case "mobile":
			mySheet.RemoveAll();
			openSearchPopup('/common/multiSearchCondPop.do','?header_text=휴대폰 번호',"300,400,no");
			popupSel = "mobile";
			break;
		case "sent_sms":
			openSearchPopup("/none/showCommonNoNeSentSmsPop.do","",'1000,500,no');
			popupSel = "sent_sms";
			break;
		}
	}
	//콜백함수(파일명은 모두 동일)
   function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
									,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
									,value21,value22,value23,value24,value25,value26,value27,value28,value29){
		if (popupSel == "user_multi") {	// 사용자조회
			var arrKey = value3.split("@");
			var arrKey2 = value4.split("@");
			if(arrKey.length == 1){
				var rows = mySheet.DataInsert(-1);
				mySheet.SetCellValue(rows, 'USER_NAME_LOC', value3);
				mySheet.SetCellValue(rows, 'MOBILE_PHONE', value4);
				mySheet.SetCellValue(rows, 'SELECTED', "1");				
			}else{
				for(var i =0; i < arrKey.length-1; i++){
					var rows = mySheet.DataInsert(-1);
					mySheet.SetCellValue(rows, 'USER_NAME_LOC', arrKey[i]);
					mySheet.SetCellValue(rows, 'MOBILE_PHONE', arrKey2[i]);
					mySheet.SetCellValue(rows, 'SELECTED', "1");
				}
			}

		}else if(popupSel == "mobile"){
			var arrKey = value1.split("@");
			for(var i =0; i < arrKey.length-1; i++){
				var rows = mySheet.DataInsert(-1);
				mySheet.SetCellValue(rows, 'MOBILE_PHONE', arrKey[i]);
				mySheet.SetCellValue(rows, 'SELECTED', "1");
			}
		} 
	}
 //TABLE의 ROW 데이타 생성
   function addrows() {
	   var rows = mySheet.DataInsert(-1);
	   mySheet.SetCellValue(rows, 'SELECTED', "1");
   }
	function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
		
		if (msg != "") {
			alert(msg);
		}
		
		if(code>0){
			mySheet.RemoveAll();
			document.forms.searchCondition.st_cont.value = "";
		}
	}
	// TEXTAREA 최대값 체크
	function fn_TextAreaInputLimit(gbn) {

	    var tempText = $("textarea[name='"+gbn+"']");
	    var tempChar = "";                                        // TextArea의 문자를 한글자씩 담는다
	    var countChar = 0;                                        // 한글자씩 담긴 문자를 카운트 한다
	    var tempHangul = 0;                                        // 한글을 카운트 한다

	    // 글자수 바이트 체크를 위한 반복
	    for(var i = 0 ; i < tempText.val().length; i++) {
	        tempChar = tempText.val().charAt(i);
	        // 한글일 경우 2 추가, 영문일 경우 1 추가
	        if(escape(tempChar).length > 4) {
	            countChar += 2;
	            tempHangul++;
	        } else {
	            countChar++;
	        }
	    }
	    // 카운트된 문자수가 MAX 값을 초과하게 되면 절삭 수치까지만 출력을 한다.(한글 입력 체크)
	    // 내용에 한글이 입력되어 있는 경우 한글에 해당하는 카운트 만큼을 전체 카운트에서 뺀 숫자가 maxSize보다 크면 수행
	    document.forms.searchCondition.st_length.value= countChar;

	}
	
	//textarea 백그라운드 
	function clrImg(obj){
		$("#st_cont").val("");
		obj.onkeydown=obj.onmousedown=null;
	}	
</script>
<title>코리아 e 플랫폼</title>
</head>
<style>
body{ background-color:#959595;margin:0; padding:0; font-family:돋움; font-size:12px}
.Phone{margin:0; padding:0; background:url(/resources/images/sms/phone_bg.png) no-repeat; width:280px; height:510px;}
.Phone textarea{ position:relative; margin-top:68px; left:30px; border:0; height:125px; width:220px; overflow-y:auto; font-family:돋움; font-size:12px;}
.byte{ position:relative; margin-top:5px;left:30px;  width:222px; text-align:right; height:20px; line-height:20px;}
.Sender{ position:relative; margin-top:13px; left:25px;  width:233px;  height:30px; line-height:30px; color:#fff; font-weight:bold}
.Sender input{ border:1px solid #aaaaaa; height:24px; width:160px; float:right; font-family:돋움; font-size:12px;}
.Number{ position:relative; margin-top:2px; left:25px;  width:233px;  height:30px; line-height:30px; color:#fff; font-weight:bold}
.Table{ position:relative; margin-top:5px; left:25px;  width:233px;  height:135px; }
.Send{ position:relative; margin-top:4px; left:25px;  width:233px;  height:30px; line-height:30px; color:#fff; font-weight:bold}
.Send button{ float:left; *display:inline-block}/*추가*/
.Sendernum{border:0px solid #FFF; height:20px; line-height:20px;width:30px;  font-family:돋움; font-size:12px;text-align:right; }
.btn01 {width:28px;  height:24px; background:url(/resources/images/sms/btn01.gif) center; color:#fff; border:0; cursor:pointer; vertical-align:middle; margin-left:12px}
.btn02 {width:25px;  height:24px; padding:0;line-height:24px; background:url(/resources/images/sms/btn02.gif) center;  color:#fff; border:0; cursor:pointer;  letter-spacing:-1px;vertical-align:middle}
.btn03 {width:91px; height:37px; padding:0; line-height:37px; margin-right:2px; background:url(/resources/images/sms/btn03.gif) center; color:#fff; border:0; cursor:pointer; font-weight:bold; vertical-align:middle; font-size:14px;}/*수정*/
.btn04 {width:40px;  height:37px; padding:0; line-height:37px; background:url(/resources/images/sms/btn04.gif) center; color:#fff; border:0; cursor:pointer; font-weight:bold; vertical-align:middle; font-size:14px;}/*수정*/
.btn05 {width:52px;  height:24px; padding:0;line-height:24px; background:url(/resources/images/sms/btn02.gif) center;  color:#fff; border:0; cursor:pointer;  letter-spacing:-1px;vertical-align:middle}
.btn06 {width:98px;  height:37px; padding:0; line-height:37px; margin-right:2px; background:url(/resources/images/sms/btn03.gif) center; color:#fff; border:0; cursor:pointer; font-weight:bold; vertical-align:middle; font-size:14px;}/*추가*/
</style>
<body onLoad="initPage();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onSubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="USER_TEL"  name="USER_TEL" value="<%=userTel%>">
	<input type="hidden" name="st_length" id="st_length" type="text"  value="" >		
	<input type="hidden" name="st_kind" id="st_kind" type="text"  value="" >
    <div class="Phone">
        <textarea id="st_cont" name="s_cont" cols="" rows="" onKeyUp="javascript:fn_TextAreaInputLimit('s_cont');" onKeyDown="clrImg(this)" onMouseDown="clrImg(this)">발신번호 변경 시 S/R 요청 바랍니다.</textarea>
        <div class="byte"></div>
        <div class="Sender">보낸사람 <input name="" type="text" value="<%=userInfo%>" readonly/></div>
        <div class="Number">수신번호
            <button id="" type="button" class="btn01" onClick="doPop('user_multi');"></button>
            <button id="" type="button" class="btn02" onClick="addrows();">+</button>
            <button id="" type="button" class="btn02" onClick="doAction('deleteRows');">-</button>
            <button id="" type="button" class="btn02" onClick="doPop('mobile');">M</button>
            <button id="" type="button" class="btn02" onClick="doAction('excel');">E</button>
        </div>
        <div class="Table">
            <script type="text/javascript">
                createIBSheet("mySheet", "", "130px");
            </script>
        </div>
        <div class="Send">
            <button id="" type="button" class="btn06" onClick="doPop('sent_sms');">보낸문자함</button>
            <button id="" type="button" class="btn03" onClick="doAction('save');">보내기</button>
            <button id="" type="button" class="btn04" onClick="doAction('close');">취소</button>
        </div>
    </div>
</form>
		
</body>
</html>
