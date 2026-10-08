<%--
**********************************************
* 메뉴 : 고객카드관리>고객 카드관리
* 화면 : 고객 카드관리
* 기능 : 고객카드 조회
* 프로그램 ID : PG_01_M_015_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var selDept = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",			SaveName:"sStatus"}
		,{ Align:"Left",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Left",		Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명",		SaveName:"COM_NAME_LOC"}
		,{ Align:"Left",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"부서명",			SaveName:"USR_DEPT_NM"} 
		,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"담당BM",		SaveName:"USR_RSPNSR"} 
		,{ Align:"Center",		Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"최종방문일시",	SaveName:"LST_VISIT_DATE"} 
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"전월방문여부",	SaveName:"PRE_VISIT"} 
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"당월방문여부",	SaveName:"THAT_VISIT"}
		,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서코드",		SaveName:"USR_DEPT"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER");					//고객사코드
	
	if ( $("#st_user_id").val() != "KEP2119104" && $("#st_user_id").val() != "KEP200143" && $("#st_user_id").val() != "KEP200040" && $("#st_user_id").val() != "KEP2109024" && $("#st_user_id").val() != "KEP2109028" && $("#st_user_id").val() != "KEP2119063" && $("#st_user_id").val() != "KEP2129146" && $("#st_user_id").val() != "KEP2109074") {
		selDept = $("#user_dept").val();
	}	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', selDept);							// 조회조건 : 부서
	kepAjaxCommonQueryIdSearchTwoCombo('st_kep_user_id','master.mdcd.selectMasterMdCdBuyerCardManageVisitorList', selDept, '', 'ALL','');		//조회조건 : 방문자
}

var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcd/getMasterMdCdBuyerCardManageList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_user_dept").val(selDept);
			mySheet.RemoveAll();
			break;
		case "save": // 저장
			kepAjaxFormCall("/mdcd/saveMasterMdCdBuyerCardManageList.do","searchCondition", str);
			break; 
		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
			var param = {FileName:"고객카드 관리 리스트.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER|COM_NAME_LOC|USR_DEPT_NM|USR_RSPNSR|LST_VISIT_DATE|PRE_VISIT|THAT_VISIT"};
			kepDownExcel(document.searchCondition ,mySheet , "/mdcd/excelMasterMdCdBuyerCardManageList.do", param);
			$("#pageflag").val('1');
			break;
		case "visitor":
			kepAjaxCommonQueryIdSearchTwoCombo('st_kep_user_id','master.mdcd.selectMasterMdCdBuyerCardManageVisitorList', $("#st_user_dept").val(), '', 'ALL','');	
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BUYER') { // 요청자
		doPop("crmBuyer", mySheet.GetCellValue(Row,"BUYER"), mySheet.GetCellValue(Row,"USR_DEPT"));
	}
	return;
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
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
	kepSearch(document.searchCondition ,  mySheet , "/mdcd/getMasterMdCdBuyerCardManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	
	switch (str) {
		case "buyer":				// 고객사 검색
			openSearchPopup("/coco/showCommonCoCoCompanyPop.do", "?com_type=B&safety_flag=Y&kway_flag=Y", "500,500,no");
			break;
		case "insert":				// 고객사 등록
			openSearchPopup("/coco/showCommonCoCoCompanyPop.do", "?com_type=B&safety_flag=Y&kway_flag=Y", "500,500,no");
			break;
		case "crmBuyer":		// 고객사 정보
			openSearchPopup("/mdcd/showMasterMdCdBuyerCardInfoPop.do", "?com_code=" + val1 + "&usr_dept=" + val2, "1000,640,no");
			break;	
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, com_org_level, com_org_code, db_com_code, com_info, com_type, site) {
	if (popupSel == "buyer") {
		$("#st_buyer_code").val(code); 
		$("#st_buyer_name").val(text);	
	} else if (popupSel == "insert") {
		$("#st_com_code").val(code);
		$("#st_site").val(site);
		doAction("save");
	} else if (popupSel == "crmBuyer" && code == "OK") {
		doAction("search");
	}
 
	grbRow="";	//초기화
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("등록이 완료 되었습니다.");
         // 처리후 재조회
    		doAction("search");
		} else if (sMsg == 'DUP') {
			alert("이미 등록이 되어있습니다.");
            return;
		} else {
			alert("고객카드 등록이 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	Company_Create_flag = "N"; 	
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 
</script>
</head>
<body onload="kep_onload_view()">

	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>고객사 관리 작성</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		<span class="btn_search"><a href="javascript:doPop('insert')">등록</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>        	
	<!--조회영역-->
	<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false" >
	<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="st_com_code" name="st_com_code"  value="" />
		<input type="hidden" id="user_dept" name="user_dept"  value="<%=_sessionInfo.getDepartment()%>">
		<input type="hidden" id="st_site" name="st_site"  value="" />
			
			<table  class="cont_t_list01" >
				<caption>고객 카드관리</caption> 
				<colgroup> 
					<col width="8%" /> 
					<col width="12%" />
					<col width="8%" /> 
					<col width="*" />
					<col width="8%" /> 
					<col width="10%" />
					<col width="8%" /> 
					<col width="8%" />
					<col width="8%" /> 
					<col width="8%" />																								
				</colgroup> 
				<tbody>
					<tr>
						<td>부 서</td>
						<td>
							<select id="st_user_dept" name="st_user_dept" style="width:80%;height:20px" onchange="doAction('visitor');">
							</select>
						</td>
						<td>고객사</td>
						<td>
							<input type="hidden" id="st_buyer_code" name="st_buyer_code" value=""/>
							<input type="text" id="st_buyer_name" name="st_buyer_name" style="width:70%" value = "" class="input_type_text"  readonly />
							<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>								
						</td>
						<td>방문자</td>
						<td>
							<select id="st_kep_user_id" name="st_kep_user_id" style="width:80%;height:20px">
							</select>
						</td>
						<td>전월방문</td>
						<td>
							<select id="st_avisit_gbn" name="st_avisit_gbn" style="width:80%;height:20px">
								<option value="">전체</option>
				                <option value="Y">Y</option>
				                <option value="N">N</option>
							</select>
						</td>
						<td>당월방문</td>
						<td>
							<select id="st_bvisit_gbn" name="st_bvisit_gbn" style="width:80%;height:20px">
								<option value="">전체</option>
				                <option value="Y">Y</option>
				                <option value="N">N</option>
							</select>
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
		<span class="fr" style="display:none">
			<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</span> 
	</div>
	
</body>
</html>
