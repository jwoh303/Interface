<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>협력사최종승인
* 화면 : 협력사최종승인
* 기능 : 협력사 1차 승인 후 최종승인 대상목록을 조회, 승인처리
* 프로그램 ID : PG_01_M_010_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사명",		SaveName:"COM_NAME"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"회사코드",		SaveName:"COM_CODE"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업자번호",	SaveName:"IRS_NO"}
		,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"대표자명",		SaveName:"CEO_NAME"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"1차승인일",		SaveName:"CONFIRM1_DATE"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP담당자",	SaveName:"KEP_USER_NAME"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"1차승인자",		SaveName:"CONFIRM1_USER_NAME"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"구분",			SaveName:"SP_TYPE_TEXT"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"신용평가여부",	SaveName:"CREDIT_STATUS_TEXT"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"신용등급",		SaveName:"CREDIT_RATING"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"만기일",			SaveName:"CREDIT_EXPIRE_DATE"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"만기일",			SaveName:"WIDUS"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "COM_NAME");			//요청자
	setLinkCol(mySheet, "IRS_NO");				//품목코드
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
			current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpAgntcmpyFinalApprovalList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		$("#st_kep_damdang_id").val("");
		kepReload('searchCondition');
			mySheet.RemoveAll();
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
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
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAgntcmpyFinalApprovalList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	
	switch (str) {
		case "kepManagerPop":				// Kep담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=" + val1, "500,500,no");
			break;
		case "aprroval":							// 협력사 승인반려
			openSearchPopup("/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do", "?com_code=" + val1 + "&simsaLevel=2", "950,670,no");
			break;
		case "creditEvaluation":					// 신용평가 정보
			// u : 인코딩된 사용자 아이디
			// p : 인코딩된 사용자 암호
			// i : 협력업체사업자번호 - 본사사업자번호
			// k : 인코딩된 협력업체본사번호 - 본사사업자번호
			// c : 암호화방법
			//      1(암호화안함), 2(base64), 7:(128bit, 인증정보 고정, 사업자번호암호화 X)
			// m : 통합인증서 기본 섹션
			//      1(업체검색), 2(Watch메인), 3(전자인증서메인), 4(건설실적메인), 5(거래위험메인)
			// g : 고정파라미터
			var c ="7";
			var m ="3";
			var link ='http://www.esrm.co.kr/esrm/SrmplusLogin?u=' + val1 + '&p=' + val2 + '&i=' + val3 + '&k=' + val4 + '&c=' + c + '&m=' + m +'&g=2';
	        var features ='height=768, width=1024, status=no, scrollbars=auto, resizable=yes';
	        window.open(link, 'watchwin', features);
			break;
		case "widusPool":				// 신규등록 협력사 정보 
			window.open('http://www.widuspool.com','new','resizable=yes,scrollbars=yes,width=800,height=600', 'widusPool');
			break;	
	}
}
	
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'COM_NAME') { // 요청자
		doPop("aprroval", mySheet.GetCellValue(Row,"COM_CODE"));
	} else if (column == 'IRS_NO') { // 품목코드
		var u="2d2d424547494e204349504845522d2d313131310000000b30303030303030308adcf2427727cb3c99f88cbb5d286f9feff44841390eea46e5459dd5012f1cfd25981f4352e8405c547bb1d999ae621930302d2d454e44204349504845522d2d";
		var p="2d2d424547494e204349504845522d2d313131310000000430303030303030308c39583fe0484e0f8fdb85524415eb1d8c0a5b801b3bda99d0389636bc5e7db086062756a066c45b41e8566fdf18764530302d2d454e44204349504845522d2d";
		var i = mySheet.GetCellValue(Row,"WIDUS").replace(/-/gi,"");
		var k ="";  
		doPop("creditEvaluation", u, p, i, k);
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "aprroval") {
		if (code == 'OK') {
			doAction('search');
		}
	}
	grbRow="";	//초기화
}

</script>
</head>
<%
String com_code= "";
if (_sessionInfo != null) {
	String st_user_id = _sessionInfo.getUserId();
	com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
}
%>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사최종승인</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>협력사최종승인</caption>
					<colgroup>
						<col width="8%" />
						<col width="14%" />
						<col width="8%" />
						<col width="14%" />
						<col width="6%" />
						<col width="8%" />
						<col width="8%" />
						<col width="10%" />
						<col width="8%" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>협력사명</td>
							<td><input type="text" class="input_type_text" id="st_com_name" name="st_com_name" style="width:80%;" value="" onkeydown="kepEnter()"></td>
							<td>사업자번호</td>
							<td><input type="text" class="input_type_text" id="st_irs_no" name="st_irs_no" style="width:80%;" value="" onkeydown="kepEnter()"></td>
							<td>구분</td>
							<td>
								<select id="st_sp_type" name="st_sp_type" style="width:80%;">
									<option value="">전체</option>
									<option value="N">정규</option>
									<option value="T">임시</option>
									<option value="A">옥션</option>
								</select>
							</td>
							<td>신용평가여부</td>
							<td>
								<select id="st_credit_status" name="st_credit_status" style="width:80%;">
									<option value="">전체</option>
									<option value="A">B-이상</option>
									<option value="B">등급미달</option>
									<option value="C">면제</option>
									<option value="N">미평가</option>
								</select>
							</td>
							<td>KeP담당자</td>
							<td>
								<input type="text" id="st_kep_damdang_id" name="st_kep_damdang_id" class="input_type_text" style="width:60%;" value="" >
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
			
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span class="btn_08 mr04"><a href="javascript:doPop('widusPool');">위더스풀(신용정보)</a></span>
			</span>
		</div>

<!--내용 종료-->	                 

</body>
</html>
