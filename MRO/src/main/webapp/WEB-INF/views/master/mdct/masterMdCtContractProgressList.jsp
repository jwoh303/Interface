<%--
**********************************************
* 메뉴 : 회원사관리>계약관리>계약진행조회
* 화면 : 계약진행조회
* 기능 : 
* 프로그램 ID : PG_02_M_003_00
* 담당자 : 개발자3 ( 설계 : 권우재 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String department = (String)_sessionInfo.getDepartment() ;
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var selDept = "<%=department%>";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
					,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Radio",				Header:"선택",				SaveName:"SELECTED"}
					,{ Align:"Right",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"회원사코드",		SaveName:"COMPANY_CODE"}
					,{ Align:"Center",		Width:160,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"진행상태",			SaveName:"CONT_STATUS"}
					,{ Align:"Center",		Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"진행상태",			SaveName:"CONT_STATUS_TEXT"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"계약서식번호",		SaveName:"FORM_NO"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약서식명",		SaveName:"FORM_NAME"}
					,{ Align:"Center",		Width:90,		Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"회원사유형",		SaveName:"COMPANY_TYPE"}
					,{ Align:"Center",		Width:90,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"회원사유형",		SaveName:"COMPANY_TYPE_TEXT"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"사업구분",			SaveName:"BIZ_TYPE"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"사업구분",			SaveName:"BIZ_TYPE_TEXT"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",	SaveName:"BIZMN_REGST_NO"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"거래처명",			SaveName:"COMPANY_NAME"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약번호",			SaveName:"CONT_NO"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약명",				SaveName:"CONT_TITLE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"담당부서",			SaveName:"COP_DEPT_NAME"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"담당자",				SaveName:"USER_NAME"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약일",				SaveName:"CONT_DATE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약시작일",		SaveName:"START_DATE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약종료일",		SaveName:"END_DATE"}
					,{ Align:"Center",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약취소일",		SaveName:"RJ_DATE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"취소유형",			SaveName:"RJ_TYPE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"취소자",				SaveName:"RJ_USER"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"취소사유",			SaveName:"RJ_REASON"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"계약번호",			SaveName:"CONT_NO_HID"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"계약번호",			SaveName:"CONT_COUNT"}

	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CONT_NO");	//계약번호

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdct.selectMasterMdCtContractProgressDeptList','ALL', selDept);								// 조회조건 : 부서
	kepAjaxCommonQueryIdSearchTwoCombo('st_kep_user_id','master.mdct.selectMasterMdCtContractProgressKepUserList', selDept, '', 'ALL','');		//조회조건 : 방문자

}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ((str =="del" || str == "transmit" )&& selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if ($("#st_user_dept option:selected").text() == "전체") {
				$("#st_user_dept_name").val("");
			} else {
				$("#st_user_dept_name").val($("#st_user_dept option:selected").text());
			}	
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtContractProgressList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			$("#st_buyer_code").val("");
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_from_date").val("");
			$("#st_to_date").val("");
			kepAjaxCommonQueryIdCombo('st_user_dept','master.mdct.selectMasterMdCtContractProgressDeptList','ALL', selDept);								// 조회조건 : 부서
			kepAjaxCommonQueryIdSearchTwoCombo('st_kep_user_id','master.mdct.selectMasterMdCtContractProgressKepUserList', selDept, '', 'ALL','');		//조회조건 : 방문자
			mySheet.RemoveAll();
			break;
		case "kepUser":
			kepAjaxCommonQueryIdSearchTwoCombo('st_kep_user_id','master.mdct.selectMasterMdCtContractProgressKepUserList', $("#st_user_dept").val(), '', 'ALL','');	
			break;	
		case "del": // 취소
			if (mySheet.GetCellValue(selectedGrid, "CONT_STATUS") != "TMP") {
				alert("임시저장상태의 데이터만 삭제가능합니다.");
				return;
			}
	
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdct/delMasterMdCtContractProgressList.do" , "SELECTED" );
			break;
		case "transmit": // 취소
			if (mySheet.GetCellValue(selectedGrid, "CONT_STATUS") != "TMP") {
				alert("임시저장상태의 데이터만 협력사전송이 가능합니다.");
				return;
			}
	
			if (!confirm('선택한 항목을 협력사로 전송 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdct/updateMasterMdCtContractProgress.do" , "SELECTED" );
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
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtContractProgressList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	
	switch (str) {
		case "company": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			break;
		case "constract": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtContractProgressPop.do", "?st_cont_no=" + val1 + "&st_cont_count=" + val2, "780,700,no");
			break;
		case "contChg":
		case "contModify":
			openSearchPopup("/mdct/showMasterMdCtContractRegPop.do", "?st_cont_no=" + mySheet.GetCellValue(grbRow, "CONT_NO_HID") +  "&st_cont_count=" + mySheet.GetCellValue(grbRow, "CONT_COUNT") + "&st_com_code=" + mySheet.GetCellValue(grbRow, "COMPANY_CODE") + "&st_form_no=" + mySheet.GetCellValue(grbRow, "FORM_NO") + "&st_company_type=" + mySheet.GetCellValue(grbRow, "COMPANY_TYPE") + "&st_biz_type=" + mySheet.GetCellValue(grbRow, "BIZ_TYPE") + "&st_cont_chg_type=" + val1, "820,700,no");
			break;
		case "constractMod":
			openSearchPopup("/mdct/showMasterMdCtContractAlterPop.do", "?st_cont_no=" + val1 + "&st_cont_count=" + val2, "820,700,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'CONT_NO') { // 요청자
		doPop('constract',  mySheet.GetCellValue(Row,"CONT_NO_HID"), mySheet.GetCellValue(Row,"CONT_COUNT"));
		
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, val) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "company") {	// 다중 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	
	} else if (popupSel == "constract") {
		if (code == "OK") {
				doAction('search');
		} else if (code == "contChg" || code == "contModify") {
			doPop(code, text);
		} else if (code == "constractMod") {
			doPop(code, text, val);
		}
	} else if (popupSel == "contChg" || popupSel == "contModify") {
		doAction('search');
	} else if (code == "constractMod") {
		doAction('search');
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>계약진행조회</h3>
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
			<input type="hidden" id="st_user_dept_name" name="st_user_dept_name"  value="">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>계약진행조회</caption>
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
							<td>계약명</td>
							<td colspan="3">
								<input type="text" class="input_type_text" id="st_cont_title" name="st_cont_title" style="width:80%;" value="" onkeydown="kepEnter()" />
							</td>
							<td>계약기간</td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
							</td>
						</tr>
						<tr> 
							<td>사업구분</td>
							<td>
								<select id="st_biz_type" name="st_biz_type" style="width:80%;height:20px" disabled>
									<option value="C001">구매대행</option>
									<option value="C002">유통</option>
								</select>
							</td>
							<td>회원사유형</td>
							<td>
								<select id="st_company_type" name="st_company_type" style="width:80%;height:20px" disabled>
									<option value="C002" selected>협력사</option>
									<option value="C001">고객사</option>
								</select>
							</td>
							<td>진행상태</td>
							<td>
								<select id="st_cont_status" name="st_cont_status" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="TMP">임시저장</option>
									<option value="PRG">운영사 결재중</option>
									<option value="CS1">회원사 서명대기</option>
									<option value="OS1">운영사 서명대기</option>
									<option value="CS2">회원사 취소서명대기</option>
									<option value="OS2">운영사 취소서명대기</option>
									<option value="DRP">진행취소</option>
									<option value="END">계약완료</option>
									<option value="FNL">계약종료</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>회원사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('company');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('company');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code', 'st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							
							<td>부서</td>
							<td>
								<select id="st_user_dept" name="st_user_dept" style="width:80%;height:20px" onchange="doAction('kepUser');"></select>
							</td>		
							<td>담당자</td>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:80%;height:20px"></select>
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
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
					<span class="btn_04"><a href="javascript:doAction('transmit');">협력사전송</a></span>
				</span>
			</div>

<!--내용 종료-->	                 

</body>
</html>
