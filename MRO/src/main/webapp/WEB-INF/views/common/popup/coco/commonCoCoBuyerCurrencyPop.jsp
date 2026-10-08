<%--
**********************************************
* 메뉴 : 고객사 외화단가 정보 팝업
* 화면 : 고객사 외화단가 정보 팝업
* 기능 :
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<%
String sessionDept = CommonUtil.nvl((String) request.getParameter("sessionDept"),"");
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var unit01 = KepSheetComboQueryIdData('common.masterCodeList','','');	// IBSHEET : 팀구분
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
    
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"환율코드",	SaveName:"EXP_CODE", BackColor:"${notnullColor}"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",	Header:"통화단위",	SaveName:"EXP_CUR"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",	Header:"구분",	SaveName:"EXP_PRICE_NM"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Type:"Float",	Header:"환율",	SaveName:"EXP_CUR_PRICE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,	Type:"Date",	Header:"환율변경일",	SaveName:"CURRENCY_CHANGE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Type:"Float",	Header:"외화단가",	SaveName:"EXP_FOR_UNIT_PRICE"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Type:"Float",	Header:"단가(KRW)",	SaveName:"EXP_KR_UNIT_PRICE"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Type:"Float",	Header:"부대비용(KRW)",	SaveName:"EXP_INC_EXPENSE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,	Type:"Date",	Header:"등록일",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,	Type:"Text",	Header:"수정자",	SaveName:"CHANGE_USER_NM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,	Type:"Date",	Header:"수정일",	SaveName:"CHANGE_DATE"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"BUYER",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"BUYER_ITEM_NO",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ"}

					];
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	setLinkCol(mySheet, "EXP_CODE");
	mySheet.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	kepSearch(document.searchCondition ,  mySheet , "/coco/getCommonCoCoBuyerCurrencyPop.do" , pagingMode );
}
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if ((str =="mapping" || str =="save") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	switch (str) {
	case "search": // 조회
		//조회
		kepSearch(document.searchCondition,  mySheet , "/coco/getCommonCoCoBuyerCurrencyPop.do" , pagingMode );
		break;		break; 
	case "save": // 저장
		for(var i=0; i<arrRow.length; i++){
			if(mySheet.GetCellValue(arrRow[i],"sStatus") != "I"){
				alert("신규 매핑건만 저장 가능 합니다.");
				return;				
			}
		}
		if (!confirm('환율 매핑 하시겠습니까?')){
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/coco/saveCommonCoCoBuyerCurrencyPop.do" , "SELECTED" );
		}
		break; 
	case "delete": // 삭제
		if (!confirm('환율매핑 삭제 하시겠습니까?')){
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/coco/deleteCommonCoCoBuyerCurrencyPop.do" , "SELECTED" );
		}
		break; 
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {

	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
}

//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'SELECTED', "1");
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'EXP_CODE') { //환율코드
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_buyer = $("#st_below_code").val();//고객사코드
		if(st_buyer_item_no == ""){ //기존품 변경 불가능 신규만 환율 매핑 되도록.
			popupSel = "currencyPop";
			openSearchPopup("/coco/showCommonCoCoCurrencyPop.do", "?st_buyer="+st_buyer,"550,350,no");
		}
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	if(popupSel =="currencyPop"){//환율팝업
		mySheet.SetCellValue(grbRow,"EXP_CODE",value1);
	}

}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	if (msg != ""){
		alert(msg);
		//저장 성공시 재조회
		doAction('search');
		opener.doAction('search');
	}

}
</script>

<body onload="kep_onload_view()">
<!--내용 시작-->
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag"  name="pageflag" value="1">
			<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
			<input type="hidden" id="st_below_code"  name="st_below_code" value="${param.st_below_code}">		
			<input type="hidden" id="st_contract_no"  name="st_contract_no" value="${param.st_contract_no}">
			<input type="hidden" id="st_contract_seq"  name="st_contract_seq" value="${param.st_contract_seq}">
			<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="${param.st_buyer_item_no}">
			<input type="hidden" id="st_unit_price"  name="st_unit_price" value="${param.st_unit_price}">
		</form>
      	<!--grid-->
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">외화단가 정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <br>
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "99%", "250px");
  				</script>
  			</div>
  			<!--버튼영역-->
  			<br>
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
  					<span class="btn_02"><a href="javascript:doAction('delete');">매핑삭제</a></span>
  					<span class="btn_02"><a href="javascript:doAction('save');">매핑</a></span>
  				</span> 
  			 </div>
</div>
<!--내용 종료-->	                 
</body>
</html>
