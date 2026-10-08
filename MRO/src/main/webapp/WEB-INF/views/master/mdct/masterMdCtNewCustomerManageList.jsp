<%--
**********************************************
* 메뉴 : 신규영업관리
* 화면 : 신규영업관리
* 기능 : 신규영업관리
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	SaveName:"sStatus",			Header:"상태|상태",				Type:"Status",	Width:60,	Edit:false,	EditLen:0,	Sort:0,	Hidden:true}
		,{ Align:"Center",	SaveName:"BUYER",			Header:"기업코드|기업코드",			Type:"Text",	Width:140,	Edit:false,	EditLen:6,	Sort:1,	Hidden:false}
		,{ Align:"Left",	SaveName:"BUYER_NAME",		Header:"기업명|기업명",				Type:"Text",	Width:260,	Edit:false,	EditLen:6,	Sort:1,	Hidden:false}
		,{ Align:"Center",	SaveName:"IRS_NO",			Header:"사업자번호|사업자번호",		Type:"Text",	Width:140,	Edit:false,	EditLen:6,	Sort:1,	Hidden:false}
		,{ Align:"Center",	SaveName:"KEP_USER_DEPT_NM",Header:"담당부서|담당부서",			Type:"Text",	Width:80,	Edit:false,	EditLen:6,	Sort:1,	Hidden:true}
		,{ Align:"Center",	SaveName:"KEP_USER_NM",		Header:"담당자|담당자",				Type:"Text",	Width:120,	Edit:false,	EditLen:6,	Sort:1,	Hidden:false}
		,{ Align:"Center",	SaveName:"ADD_DATE",		Header:"등록일|등록일",				Type:"Date",	Width:120,	Edit:false,	EditLen:6,	Sort:1,	Hidden:false}
		,{ Align:"Center",	SaveName:"ADD_USER_DEPT_NM",Header:"등록부서|등록부서",			Type:"Text",	Width:80,	Edit:false,	EditLen:6,	Sort:1,	Hidden:true}
		,{ Align:"Center",	SaveName:"ADD_USER_NM",		Header:"등록자|등록자",				Type:"Text",	Width:60,	Edit:false,	EditLen:6,	Sort:1,	Hidden:true}
		,{ Align:"Center",	SaveName:"CHANGE_DATE",		Header:"수정일|수정일",				Type:"Date",	Width:80,	Edit:false,	EditLen:6,	Sort:1,	Hidden:true}
		,{ Align:"Center",	SaveName:"CHANGE_USER_NM",	Header:"수정자|수정자",				Type:"Text",	Width:100,	Edit:false,	EditLen:6,	Sort:1,	Hidden:true}
		,{ Align:"Center",	SaveName:"STATUS_NM",		Header:"진행상태|진행상태",			Type:"Text",	Width:120,	Edit:false,	EditLen:6,	Sort:1,	Hidden:false}
		,{ Align:"Center",	SaveName:"VISIT_DATE",		Header:"최근 영업일|최근 영업일",Type:"Date",	Width:120,	Edit:false,	EditLen:6,	Sort:1,	Hidden:false}
		,{ Align:"Center",	SaveName:"PROCESS_TYPE_1",	Header:"영업단계|유선영업",			Type:"Image",	Width:110,	Edit:false,	ImgWidth:50,Sort:0}
		,{ Align:"Center",	SaveName:"PROCESS_TYPE_2",	Header:"영업단계|대면영업",			Type:"Image",	Width:110,	Edit:false,	ImgWidth:50,Sort:0}
		,{ Align:"Center",	SaveName:"PROCESS_TYPE_3",	Header:"영업단계|입찰",				Type:"Image",	Width:110,	Edit:false,	ImgWidth:50,Sort:0}
		,{ Align:"Center",	SaveName:"PROCESS_TYPE_4",	Header:"영업단계|셋업",				Type:"Image",	Width:110,	Edit:false,	ImgWidth:50,Sort:0}
		,{ Align:"Center",	SaveName:"PROCESS_TYPE_5",	Header:"영업단계|계약완료",			Type:"Image",	Width:110,	Edit:false,	ImgWidth:50,Sort:0}
		,{ Align:"Center",	SaveName:"REVISION",		Header:"REVISION",				Type:"Text",	Width:100,	Edit:false,	EditLen:100,Sort:0,	Hidden:true}
		,{ Align:"Center",	SaveName:"PROCESS_TYPE",	Header:"PROCESS_TYPE",			Type:"Text",	Width:100,	Edit:false,	EditLen:100,Sort:0,	Hidden:true}
		,{ Align:"Center",	SaveName:"CUSTOMER_MNG_YN",	Header:"CUSTOMER_MNG_YN",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,Sort:0,	Hidden:true}
	];
	//InitHeaders의 두번째 인자
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	initsheet.HeaderMode = {ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	IBS_InitSheet(mySheet, initsheet,pagingMode, '');	

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER");	//고객사코드
	setLinkCol(mySheet, "BUYER_NAME");	//고객사명
	setLinkCol(mySheet, "IRS_NO");	//사업자번호
	setLinkCol(mySheet, "STATUS_NM");	//진행상태
	setLinkCol(mySheet, "PROCESS_TYPE_1");	
	setLinkCol(mySheet, "PROCESS_TYPE_2");	
	setLinkCol(mySheet, "PROCESS_TYPE_3");	
	setLinkCol(mySheet, "PROCESS_TYPE_4");	
	resetValue();
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
}

//초기화 설정
function resetValue() {
	// 콤보데이터 셋팅
	// 조회조건 : 담당자
	kepAjaxCommonQueryIdSearchTwoCombo('st_add_user_id','common.masterDepartmentUserList','','','ALL',''); 

}
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str =="del" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			kepSearch(document.searchCondition, mySheet, "/mdct/getMasterMdCtNewCustomerManageList.do"  );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			dateEraser();
			mySheet.RemoveAll();
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

}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtNewCustomerManageList.do" );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "saveCustomer": //잠재고객등록
			popupSel = "saveCustomer";
			openSearchPopup('/mdct/showMasterMdctNewCustomerPop.do', '?insertFlag=Y','1000,820,yes');
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	/*
	var st_custo_mng =  mySheet.GetCellValue(Row,"CUSTOMER_MNG_YN");
	if(st_custo_mng == "N"){
		alert("상세화면 조회 권한이 없습니다.");
		return;		
	}
	*/
	if (column == "BUYER"||column == "BUYER_NAME"||column == "IRS_NO"||column == "PROCESS_TYPE_1"||column == "PROCESS_TYPE_2") { 
		var comCode =  mySheet.GetCellValue(Row,"BUYER");
		openSearchPopupName("/mdct/getMasterMdCtNewCustomerManageDetailList.do", "?com_code=" + comCode,"1000,800,yes","");
	}else if (column == "PROCESS_TYPE_3") {//입찰등록 
		var comCode =  mySheet.GetCellValue(Row,"BUYER");
		var st_process_type =  mySheet.GetCellValue(Row,"PROCESS_TYPE");
		//사전영업단계가 아닐 경우에만 팝업 호출.
		if(st_process_type == "BD"||st_process_type == "ST"||st_process_type == "CN"||st_process_type == "CP"){
			openSearchPopup("/mdct/getMasterMdCtNewCustomerBidList.do", "?com_code=" + comCode, "1000,800,yes");	
		}else{
			alert("영업단계  확인 바랍니다.\n 사전단계 완료 처리 후 가능 합니다.");
			return;
		}
	}else if(column == "STATUS_NM"){
		
		var st_process_type =  mySheet.GetCellValue(Row,"PROCESS_TYPE");
		
		if(st_process_type == "BD"||st_process_type == "ST"||st_process_type == "CN"||st_process_type == "CP"){
			//고객사 정보 조회
			var comCode =  mySheet.GetCellValue(Row,"BUYER");
			openSearchPopup("/mdct/getMasterMdCtNewCustomerBidList.do", "?com_code=" + comCode+"&st_search_yn=Y", "1000,800,yes");			
		}else{
			alert("입찰단계 이후부터 조회 가능합니다.");
			return;
		}
	}else if(column == "PROCESS_TYPE_4"){//셋업
		var comCode =  mySheet.GetCellValue(Row,"BUYER");
		var st_process_type =  mySheet.GetCellValue(Row,"PROCESS_TYPE");
		if(st_process_type == "ST"||st_process_type == "CN"||st_process_type == "CP"){
			openSearchPopup("/mdct/getMasterMdCtNewCustomerSetList.do", "?com_code=" + comCode, "800,300,no");	
		}else{
			alert("영업단계  확인 바랍니다.\n 사전단계 완료 처리 후 가능 합니다.");
			return;
		}		
	}else if(column == "PROCESS_TYPE_5"){//계약
		var comCode =  mySheet.GetCellValue(Row,"BUYER");
		var st_process_type =  mySheet.GetCellValue(Row,"PROCESS_TYPE");
		if(st_process_type == "CN"||st_process_type == "CP"){
			openSearchPopup("/mdct/getMasterMdCtNewCustomerConList.do", "?com_code=" + comCode, "800,300,no");	
		}else{
			alert("영업단계  확인 바랍니다.\n 사전단계 완료 처리 후 가능 합니다.");
			return;
		}				
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}



function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

function dateEraser() {
	kepEraser('st_from_date','st_from_date');
	kepEraser('st_to_date','st_to_date');
}

</script>
</head>
<%
@SuppressWarnings (value="unchecked")

String userID = _sessionInfo.getUserId();
%>
<body onload="kep_onload_view()">
	<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>신규영업 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" id="st_dept_cd" name="st_dept_cd"  value="${sessionInfo.department}" />
			<input type="hidden" id="st_corp_code" name="st_corp_code"  value="" />
            	<table  class="cont_t_list01" >
					<caption>신규영업 관리</caption>
					<colgroup>
						<col width="11%" />
						<col width="23%" />
						<col width="8%" />
						<col width="20%" />
						<col width="8%" />
						<col width="15%" />
						<col width="6%" />
                        <col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td>
								<select name = "st_date_type" id="st_date_type" style="height:20px">
							      		<option value="VIS" selected="selected">최근영업방문일</option>
										<option value="ADD" >등록일</option>
		                        </select>
	                        </td>
	                        <td>
								<input type="text" id="st_from_date" name="st_from_date" readOnly style="width:25%; text-align:center;" >
								~
								<input type="text" id="st_to_date" name="st_to_date" readOnly style="width:25%; text-align:center;" >
								<a href="#" onClick="dateEraser()"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>고객사명</td>
							<td>
								<input type="text" class="input_type_text" id="st_buyer" name="st_buyer" style="width:77%;" value=""  onkeydown="kepEnter()" />
							</td>
							<td>사업자번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_irs_no" name="st_irs_no" style="width:77%;" value=""  onkeydown="kepEnter()" />
							</td>
							<td></td><td></td>
						</tr>
						<tr>	
							<td>진행상태</td>
							<td>
								<select id="st_status_cond" name="st_status_cond" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="P">진행</option>
									<option value="D">종결</option>
									<option value="C">완료</option>
								</select>
							</td>
							<td>영업단계</td>
							<td>
								<select name="st_process_type" id="st_process_type" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "ALL", "CP01","", "ICOMCOD1", "", "") %>           
						         </select>
							</td>
							<td>담당자</td>
							<td>
								<select id="st_add_user_id" name="st_add_user_id" style="width:80%;height:20px"></select>
							</td>
							<td>담당자명</td>
							<td>
								<input type="text" class="input_type_text" id="st_add_user_name" name="st_add_user_name" style="width:77%;" value=""  onkeydown="kepEnter()" />
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl">               	
				&nbsp;<img src="/resources/images/icon_g.gif"> 진행중
				&nbsp;<img src="/resources/images/icon_bl.gif"> 완료
			</span>
			<br>
		</form>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "512px");
			</script>
		</div>		
  		<!--버튼영역-->
  		<div class="btnArea">
			<span class="fr">
				<!--  span class="btn_06 mr04"><a href="javascript:doPop('saveCustomer');">잠재고객등록</a></span> 기업정보 관리 등록 통해서 등록. 현명환--> 
			</span>
		</div>
		<!--내용 종료-->                 
</body>
</html>
