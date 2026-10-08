<%--
**********************************************
* 메뉴 : 회원사관리>사용자관리>Admin승인 대상조회
* 화면 : Admin승인 대상조회
* 기능 : Admin 승인 대상자 관리
* 프로그램 ID : PG_01_M_009_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
					,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
					,{ Align:"Left",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"ID",					SaveName:"USER_ID"}
					,{ Align:"Left",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"ID",					SaveName:"USER_ID_MASK"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이름(한글)",			SaveName:"USER_NAME_MASK"}
					,{ Align:"Left",		Width:350,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"회원사명",			SaveName:"COM_NAME"}
					,{ Align:"Left",		Width:350,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"회원사코드",		SaveName:"COM_CODE"}
					,{ Align:"Left",		Width:350,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"회원사구분",		SaveName:"BUSINESS_COND"}
					,{ Align:"Left",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"부서명",				SaveName:"DEPT_NAME"}
					,{ Align:"Center",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"전화번호",			SaveName:"TEL_MASK"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"업체승인여부",		SaveName:"COM_STATUS_TEXT"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"현재",				SaveName:"USER_TYPE_TEXT"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"변경",				SaveName:"CHANGE_USER_TYPE_TEXT"}

	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "USER_ID_MASK");				//아이디
	setLinkCol(mySheet, "COM_NAME");			//회원사명
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str != "search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpAdminApprovalObjctList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save": // 저장
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcp/saveMasterMdCpAdminApprovalObjctList.do" , "SELECTED" );
			break;
		case "reject": // 거절	
			if (kepTrimStr($("#st_reject_reason").val()) == "") {
				alert("거절 사유가 입력되지 않았습니다.");
				return false;
			 }
			kepSave(document.searchCondition ,  mySheet , "/mdcp/saveMasterMdCpAdminApprovalObjctConfirm.do" , "SELECTED" );
			break;
		case "confirm": // 승인
			$("#st_status").val("C");
			if (!confirm("선택한 사용자를 승인 하겠습니까?")) {
				return false;
			}
			kepSave(document.searchCondition ,  mySheet , "/mdcp/saveMasterMdCpAdminApprovalObjctConfirm.do" , "SELECTED" );
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
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAdminApprovalObjctList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	// 선택된 항목 유무 체크
	if (str != "search" && str !="excelDown" && str !="reload" && str !="user_detail" && str !="compy_detail" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	if(str == "reject") {
		if(!confirm("선택한 사용자를 거절 하겠습니까?")) {
			return;	
		}		
	}
	switch (str) {
		case "user_detail": // 사용자정보 상세조회
			openSearchPopup("/mdcp/showMasterMdCpUserDetailViewPop.do","?st_user_id="+val+"&callType=A","800,600,no");
			break;	
		case "compy_detail": // 사용자정보 상세조회
			openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", "?com_code="+val, "800,600,no");
			break;
		case "reject": // 거절사유등록
			$("#st_status").val("A");
			openSearchPopup("/common/remarkCancelPop.do", "?viewType=reject", "500,230,no");
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'USER_ID_MASK') { // 요청자
		var ID = mySheet.GetCellValue(Row,"USER_ID");
		doPop('user_detail', ID);
	} else if (column == 'COM_NAME') {
		var COM_CODE = mySheet.GetCellValue(Row,"COM_CODE");
		doPop('compy_detail', COM_CODE);
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {	
	//팝업 조회후 해당 항목에 값을 셋팅
	 if (popupSel == "reject") {		
		$("#st_reject_reason").val(value1);		
		doAction("reject");
	 }
	grbRow="";	//초기화
}

/* function checkReject() {	
		
	
	
} */
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>Admin승인 대상 조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" id="st_reject_reason" name="st_reject_reason"  value="" />
			<input type="hidden" id="st_status" name="st_status"  value="" />
			
            	<table  class="cont_t_list01" >
					<caption>관리자 승인대상 조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>ID</td>
							<td>
								<input type="text" class="input_type_text" id="st_search_user_id" name="st_search_user_id" style="width:80%;" value=""  onkeydown="kepEnter()" />
							</td>
							<td>이름</td>
							<td>
								<input type="text" class="input_type_text" name="st_search_user_name" id="st_search_user_name" style="width:71%" value="" onkeydown="kepEnter()" />
							</td>
							<td>회원사</td>
							<td>
								<input type="text" class="input_type_text" id="st_search_com_name" name="st_search_com_name" style="width:80%;" value="" onkeydown="kepEnter()" />
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
					<div class="fr">
						<span class="btn_04">
							<a href="javascript:doPop('reject');">거절</a>
						</span>	
						<span class="btn_04">
							<a href="javascript:doAction('confirm');">승인</a>
						</span>	
		            </div>
		        </div>

<!--내용 종료-->	                 

</body>
</html>
