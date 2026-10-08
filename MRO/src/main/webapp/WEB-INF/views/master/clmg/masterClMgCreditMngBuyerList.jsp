<%--
**********************************************
* 메뉴 : 여신관리>여신한도 조회
* 화면 : 여신한도조회(고객사)
* 기능 :
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var manageDept = KepSheetComboQueryIdData('getKepDeptList','SEL','');	// IBSHEET : 담당부서

var iconR="/resources/images/icon_r.gif";
var iconO="/resources/images/icon_o.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
	              	{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",	 ColMerge:0,		Header:"고객사|고객사코드",	SaveName:"COM_CODE"}
	              	,{ Align:"left",	Width:200,	Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",		ColMerge:0,	Header:"고객사|사업자명",	SaveName:"COM_NAME_LOC"}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",	ColMerge:0,		Header:"고객사|사업자번호",	SaveName:"BUYER_IRS_NO"}
	              	,{ Align:"left",		Width:200,	Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",	 ColMerge:1,		Header:"여신|업체명",				SaveName:"COM_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",	ColMerge:1,		Header:"여신|사업자번호",	SaveName:"IRS_NO"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		ColMerge:1,	Header:"여신|사업팀",				SaveName:"DEPT_NAME"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Float",	ColMerge:1,	Header:"여신총액|기본여신",			SaveName:"BASE_CREDIT_AMT"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	ColMerge:1,	Header:"여신총액|추가여신",			SaveName:"ADD_CREDIT_AMT"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	ColMerge:1,	Header:"여신총액|여신합계",			SaveName:"TOT_CREDIT_AMT"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float", ColMerge:1,	Header:"여신|채권잔액",				SaveName:"BOND_BAL_AMT"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"여신|어음잔액",				SaveName:"BILL_BAL_AMT"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"여신|발주잔액",				SaveName:"PO_BAL_AMT"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"여신|여신잔액",				SaveName:"CREDIT_BAL_AMT"}
					,{ Align:"right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"여신|선수금",					SaveName:"P_RECV_AMT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:60,		Hidden:true,	Type:"Text",			Header:"여신사용률|여신사용률",	SaveName:"CREDIT_RATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"상태|상태",						SaveName:"CREDIT_STATUS_IMG"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",			Header:"사업팀(회계)|사업팀(회계)",	SaveName:"ACCOUNT_DEPT_NM"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",			Header:"사업팀코드|사업팀코드",	SaveName:"DEPT_CODE"}
];


	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','getKepDeptList','ALL','');
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	//신호등 이미지 설정
	mySheet.SetImageList(0, iconR);
	mySheet.SetImageList(1, iconO);
	mySheet.SetImageList(2, iconY);
	mySheet.SetImageList(3, iconG);
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_BAL_AMT");
	setLinkCol(mySheet, "BOND_BAL_AMT");
	setLinkCol(mySheet, "BILL_BAL_AMT");
	setLinkCol(mySheet, "P_RECV_AMT");
	
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		kepSearch(document.searchCondition,  mySheet , "/clmg/getMasterClMgCreditMngBuyerList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1)
		return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == 'PO_BAL_AMT'){ // 발주잔액
		var st_irs_no = mySheet.GetCellValue(Row,"IRS_NO");
		var st_kep_dept = mySheet.GetCellValue(Row,"DEPT_CODE");
		
		openSearchPopup("/mdct/showMasterMdCtCreditDeptPop.do","?st_irs_no="+st_irs_no+"&st_kep_dept="+st_kep_dept, "1080, 550, no");
	}else if(column == "BOND_BAL_AMT"||column == "BILL_BAL_AMT"||column == "P_RECV_AMT"){
		var st_irs_no = mySheet.GetCellValue(Row,"IRS_NO");
		var st_kep_dept = mySheet.GetCellValue(Row,"DEPT_CODE");
		
		openSearchPopup("/mdct/showMasterMdCtCreditInfoPop.do","?st_irs_no="+st_irs_no+"&st_dept_cd="+st_kep_dept, "800, 400, no");		
	}
	
	return;
}

/**
* 입력값 숫자 체크
*/
function fnNumberCheck(id) {
	
	if (!kepIsNumDash(id)) {
		alert("숫자와 - 만 입력할수 있습니다.");
		$("#"+id).val("");
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	if (msg != ""){
		alert(msg);
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
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
	
	if(!checkedSession(stCode)){
		return;
		}	

	if (msg != ""){
		alert(msg);
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	
	if (msg != ""){
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result){
	loader_obj("N");
}
function mySheet2_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>여신한도조회(고객사)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>여신한도조회(사업팀)</caption> 
					<colgroup> 
						<col width="30px" />
						<col width="25%" />
						<col width="30px" />
						<col width="25%" />
						<col width="30px" />
						<col width="25%" />
					</colgroup>
					<tbody>
					<tr>
						<th>고객사</th>
						<td>
							<input type="text"   class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" onKeyDown="kepEnter()">
						</td>
						<th>사업팀</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:180px; height:20px"></select>
						</td>
						<th>여신사용률 상태</th>
						<td>
							<select id="st_status" name="st_status"	style="width:120px;">
								<option value="ALL">전체</option>
								<option value="0">빨강</option>
								<option value="1">주황</option>
								<option value="2">노랑</option>
								<option value="3">초록</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>사업자번호</th>
						<td>
							<input type="text"   class="input_type_text" name="st_irs_no" id="st_irs_no" style="width:70%" value="" onKeyDown="kepEnter()" onkeyup="fnNumberCheck('st_irs_no')" onchange="fnNumberCheck('st_irs_no')">
						</td>
						<th></th>
						<td></td>
						<th></th>
						<td></td>
					</tr>
					</tbody>
				</table>
            </div>
            <span class="fl">
				&nbsp;<img src="/resources/images/icon_r.gif"> 100% 이상
				&nbsp;<img src="/resources/images/icon_o.gif"> 90% 이상
				&nbsp;<img src="/resources/images/icon_y.gif"> 80% 이상
				&nbsp;<img src="/resources/images/icon_g.gif"> 80% 미만
			</span>
			<br>
		</form>

      	<!--grid-->
      	<div class="ib_product" style="border-top:2px solid #3c639c">
	      	<script type="text/javascript">
	      	createIBSheet("mySheet", "100%", "480px");
			</script>
		</div>

		<!--버튼영역-->
		<div class="btnArea">
			<span class="fr">
			</span> 
		</div>
  			 
<!--내용 종료-->	                 
</body>
</html>
