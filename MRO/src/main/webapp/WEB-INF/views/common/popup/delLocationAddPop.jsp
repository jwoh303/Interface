<%--
**********************************************
* 메뉴 : 
* 화면 : 견적단가이력
* 기능 : 견적번호에 대한 견적단가 이력 조회-(추가요구:품목명,규격,수량추가) 
* 프로그램 ID : PG_04_M_006_03
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %> 
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

var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"Text",				Header:"순번",				SaveName:"RN"}
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Left",	Width:80,		Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"코드",				SaveName:"CODE",			KeyField:true}
		,{ Align:"Left",	Width:200,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"도착지명",			SaveName:"TEXT1",			KeyField:true}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"우편번호",			SaveName:"ZIP_CODE",		KeyField:true}
		,{ Align:"Left",	Width:400,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"도착지주소",		SaveName:"ADDRESS01",	KeyField:true}
		,{ Align:"Left",	Width:400,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"도착지상세주소",	SaveName:"ADDRESS02"}
		
		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"ORG_CODE",		SaveName:"ORG_CODE"}
		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT2",				SaveName:"TEXT2"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"ZIP_KEY",			SaveName:"TEXT3"}
		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT4",				SaveName:"TEXT4"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "ZIP_CODE"); // 요청자
	
}

var st;
var mt;

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str != "search" && str != "excelDown" && str != "reload" && str != "add" && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}
	switch (str) {
		case "search": // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmMasterCodeManageList.do" , pagingMode );
			break;
			
		case "add": // 추가
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "SELECTED", "1");	
			break;
			
		case "save": // 저장
			if ( !confirm('<%=CommonLang.msg("MSG292")%>') )	//선택한 항목을 저장 하시겠습니까?
				return;

			beforeProcessSave();
			kepSave(document.searchCondition ,  mySheet , "/mdam/saveMasterMdAmMasterCodeManageList.do" , "SELECTED" );
			break;
			
		case "del": // 삭제
			if ( !confirm('<%=CommonLang.msg("MSG293")%>') )	//선택한 항목을 삭제 하시겠습니까?
				return;
			if ( !beforeProcessDelete() )
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdam/delMasterMdAmMasterCodeManageList.do" , "SELECTED" );
			break;
	}
}
	

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		var zip_code_04 = mySheet.GetCellValue(i, "TEXT4");
		var zip_code_02 = mySheet.GetCellValue(i, "TEXT2");
		var zip_arr = new Array();
		var chkSpace6 = zip_code_02.substring(5,6);
		zip_arr = zip_code_04.split("@");
		
		if ( zip_code_04 != '' ) {
			mySheet.SetCellValue(i, "ZIP_CODE", zip_arr[0]);
			mySheet.SetCellValue(i, "ADDRESS01", zip_arr[1]);
			mySheet.SetCellValue(i, "ADDRESS02", zip_arr[2]);
		}
		else {
			if(chkSpace6 ==" "){
				mySheet.SetCellValue(i, "ZIP_CODE", zip_code_02.substring(0,5));
				mySheet.SetCellValue(i, "ADDRESS01", zip_code_02.substring(6));				
			}else{
				mySheet.SetCellValue(i, "ZIP_CODE", zip_code_02.substring(0,7));
				mySheet.SetCellValue(i, "ADDRESS01", zip_code_02.substring(8));				
			}
			
		}
	}
	
}

function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
    if(column=='CODE'){
    	var dupIdx = mySheet.ColValueDup("CODE");
    	if(dupIdx > -1){
        	alert("<%=CommonLang.msg("MSG294")%>");	//입력하신 코드는 이미 존재합니다.
        	mySheet.SetCellValue(dupIdx,"CODE",'');return;
    	}
    }
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmMasterCodeManageList.do?page="+current_page , pagingMode );
}

// 저장 선행 처리
function beforeProcessSave() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			var tempText2 = mySheet.GetCellValue(i, "ZIP_CODE") + ' ' + mySheet.GetCellValue(i, "ADDRESS01") + ' ' + mySheet.GetCellValue(i, "ADDRESS02");
			var tempText4 = mySheet.GetCellValue(i, "ZIP_CODE") + '@' + mySheet.GetCellValue(i, "ADDRESS01") + '@' + mySheet.GetCellValue(i, "ADDRESS02");
			mySheet.SetCellValue(i, "TEXT2", tempText2);
			mySheet.SetCellValue(i, "TEXT4", tempText4);
		}
	}
}

// 행삭제 선행 처리
function beforeProcessDelete() {
	for ( var i = mySheet.RowCount(); i >= 1; i-- ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "sStatus") == 'I' ) {
			mySheet.RowDelete(i, 0);
		}
	}
	
	if ( mySheet.FindCheckedRow("SELECTED").length == 0 ) {
		return false;
	}
	
	return true;
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'ZIP_CODE') { // 우편번호
		doPop("newzipcode"	);
	}

	return;
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481");
			break;
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	// 팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") { // 단일 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}

	grbRow="";	// 초기화
}
 
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	mySheet.SetCellValue(grbRow, "ZIP_CODE", zipNo.replace(/[^0-9]/gi, ''));
	mySheet.SetCellValue(grbRow, "TEXT3", bdMgtSn);
	mySheet.SetCellValue(grbRow, "ADDRESS01", roadAddrPart1 + " " + roadAddrPart2);
	mySheet.SetCellValue(grbRow, "ADDRESS02", addrDetail);
}

</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
	 <form name = "searchCondition" method = "post">
 	 <!-- 공통 -->
	 <input type="hidden" name="s_SAVENAME">
	 <input type="hidden" id="pageflag" name="pageflag" value="1">
	 <!-- 화면 내 정의 -->
	 <input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
	 <input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	 <input type="hidden" id="st_type" name="st_type"  value="C012">
	 <!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	 <div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE952") %><!-- 도착지추가 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>도착지정보 검색 리스트</caption>
						<colgroup>
							<col width="50px" />
							<col width="10%" />
							<col width="5%" />
							<col width="120px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE371") %><!-- 코드 --></td>						
							<td> 
								<input type="text" class="input_type_text" id="st_code" name="st_code" style="width:80%;" value="" onkeyup="kepToUpper('st_code')" onkeydown="kepEnter()"> 
                            </td> 
                            <td></td>
							<td><%=CommonLang.get("HTITLE488") %><!-- 도착지(명,주소) --></td>
							<td> 
								<input type="text" class="input_type_text" id="st_name" name="st_name" style="width:80%;" value="" onkeydown="kepEnter()"> 
                            </td> 
                         </tr>
					</tbody>
				</table>
            </div>   
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="20">20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="30">30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="40">40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="50">50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				</select>
			</span>
			<br>
            </form> 
		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "280px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
	  			
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
			</span>
	  				
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('add');"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a></span>
			</span>
		</div>
    </div>        
</div>

		
</body>
</html>
