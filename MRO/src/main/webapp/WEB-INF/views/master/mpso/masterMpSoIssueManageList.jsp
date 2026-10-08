<%--
**********************************************
* 메뉴 : 주문진행관리 > 운영자 발주 관리
* 화면 : 운영자 발주 관리
* 기능 : 
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_user_dept = ""; //사용자 부서
if (_sessionInfo != null){
	st_user_dept = _sessionInfo.getDepartment();
}

//SMART팀 확인( 견적담당자 전체 조회 시 견적이관 대상 SG 담당자 제외하고 조회 P04-4029-05 )
String st_smart_dept_yn = "";
boolean st_smart_dept = CommonUtil.getCodeCheckReturn("SMRTDEPT",st_user_dept);
if(st_smart_dept == true){
	st_smart_dept_yn = "Y";
}else{
	st_smart_dept_yn = "N";
}
%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
			 { Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",		Header:"발주일",			SaveName:"PO_ADD_DATE",	Format:"Ymd"}
			,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",		Header:"이슈등록일",		SaveName:"ADD_DATE",	Format:"YmdHm"}
			,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",		Header:"이슈상태",			SaveName:"TYPE_TEXT",	KeyField:true}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",		Header:"협력사",			SaveName:"AGENT_NAME",	KeyField:true}
			,{ Align:"Left",	Width:308,	Edit:false,	EditLen:100,	Type:"Text",		Header:"고객사",			SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",		Header:"발주번호",			SaveName:"PO_NO"}
			,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",		Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",		Header:"재확인일",			SaveName:"NOTICE_DATE",	Format:"Ymd"}
			,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",		Header:"처리자",			SaveName:"CONFIRM_USER_NAME"}
			,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",		Header:"운영자처리일",		SaveName:"CONFIRM_DATE",	Format:"Ymd"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER",			Hidden:true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"협력사코드",		SaveName:"AGENT",			Hidden:true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"발주항번",			SaveName:"PO_SEQ", 			Hidden:true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"카탈로그관리코드",	SaveName:"BYIT_COMORG_CODE",Hidden:true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"계약서번호",		SaveName:"CONTRACT_NO", 	Hidden:true}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",		Header:"계약서항번",		SaveName:"CONTRACT_SEQ",	Hidden:true}
			,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",		Header:"이슈상태",			SaveName:"TYPE_CODE", 		Hidden:true}
			,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",		Header:"0",				SaveName:"ZERO_FLAG", 		Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "TYPE_TEXT");
	setLinkCol(mySheet, "AGENT_NAME");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	
	//이슈상태 콤보데이터 셋팅
	kepAjaxCommonCombo("st_type","PMNGTYPE","ALL");
	
	// PLANT 담당자 (SMART 팀에게 전체는 미리 지정한 ICOMCOD3.ISMG 외 고객사)
	var st_user_dept = "<%=st_user_dept%>";
	kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','');
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
}
//기능함수
function doAction(str) {
	switch (str){
		case "search":	 // 조회
			current_page = -1;
			if($("#st_date_type").val() != "BA"){
				if($("#st_from_date").val() == ""|| $("#st_from_date").val() == null || $("#st_to_date").val() == "" || $("#st_to_date").val() == null){
					alert("반드시 날짜를 지정하여야 합니다.");
					return;
				}
				
				if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false){
					return;
				}
				
				if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
					//MSG494
					alert("조회기간은 6개월 단위로 조회가 가능합니다.");
					return;
				}
			}
			
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoIssueManageList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			
			$("#st_from_date").val("");
			$("#st_to_date").val("");
			$("#st_buyer_code").val("");
			$("#st_buyer_name").val("");
			$("#st_agent_code").val("");
			$("#st_agent_name").val("");
			$("#st_po_no").val("");
			$("#st_buyer_item_no").val("");
			// 이슈상태 초기화
			kepAjaxCommonCombo("st_type","PMNGTYPE","ALL");
			mySheet.RemoveAll();
			break;
	}
}
//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop1": // 고객사 팝업
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop1";
			break;
			break;
		case "masterCmCoBuyerAgntcmpyPop2": // 협력사 팝업
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=S&st_sys_change_flag=N&st_sys_type=KA", "500,500,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop2";
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmCoBuyerAgntcmpyPop1") {	// 고객사, 협력사 팝업
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}else if (popupSel == "masterCmCoBuyerAgntcmpyPop2") {	// 고객사, 협력사 팝업
		$("#st_agent_code").val(value2);
		$("#st_agent_name").val(value3);
	}
	
	grbRow="";	//초기화
}
//  그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0){
   		$("#pageindex").html("");
   		return;
   	} 
   	
	if (msg != "") {
		alert(msg);
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoIssueManageList.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var st_popup_url="";
	var st_popup_param = "";
	var st_popup_option = "";
	if (column == 'TYPE_TEXT') { // 발주관리 비고
		st_popup_url = "/mpso/masterMpSoIssueManageRemarkPop.do";
		st_popup_param = "st_buyer@@"+mySheet.GetCellValue(Row,"BUYER")+"^||^st_po_no@@"+mySheet.GetCellValue(Row,"PO_NO")+"^||^st_po_seq@@"+mySheet.GetCellValue(Row,"PO_SEQ");
		st_popup_option = "1300,800,no";
		
		openSearchPopupAppendPost("IssueRemarkPopForm1",st_popup_url,st_popup_param,st_popup_option);
	}else if(column == 'AGENT_NAME'){
		st_popup_url = "/common/agentPoMngPop.do";
		st_popup_param = "st_com_code@@"+mySheet.GetCellValue(Row,"AGENT");
		st_popup_option = "890,800,no";

		openSearchPopupAppendPost("IssueRemarkPopForm2",st_popup_url,st_popup_param,st_popup_option);
	}else if(column == 'BUYER_NAME'){
		
		st_popup_url = "/common/agentInfoDisplayPop.do";
		st_popup_param = "st_com_code@@"+mySheet.GetCellValue(Row,"BUYER");
		st_popup_option = "800,550,no";
		
		openSearchPopupAppendPost("IssueRemarkPopForm3",st_popup_url,st_popup_param,st_popup_option);	
	}else if(column == 'PO_NO'){

		st_popup_url = "/common/mpso/poDetailPop.do";
		st_popup_param = "st_buyer@@"+mySheet.GetCellValue(Row,"BUYER")+"^||^st_po_no@@"+ mySheet.GetCellValue(Row,"PO_NO");
		st_popup_option = "800,570,no";
		
		openSearchPopupAppendPost("IssueRemarkPopForm4",st_popup_url,st_popup_param,st_popup_option);
	}else if(column == 'BUYER_ITEM_NO'){
		
		st_popup_url = "/common/catalogDetailPop.do";
		st_popup_param = "BUYER@@"+mySheet.GetCellValue(Row,"BYIT_COMORG_CODE")
						+"^||^BUYER_ITEM_NO@@"+ mySheet.GetCellValue(Row,"BUYER_ITEM_NO")
						+"^||^CONTRACT_NO@@"+mySheet.GetCellValue(Row,"CONTRACT_NO")
						+"^||^CONTRACT_SEQ@@"+mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		st_popup_option = "800,310,no";
		
		openSearchPopupAppendPost("IssueRemarkPopForm5",st_popup_url,st_popup_param,st_popup_option);
	}
	
	return;
}

function dateTypeChange(value1){
	if(value1 == "BA"){
		$("#st_from_date").val("");
		$("#st_to_date").val("");
	}
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>운영자 발주 관리 조회</h3>
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
			<input type="hidden" name="st_smart_dept_yn" id="st_smart_dept_yn" value ="<%=st_smart_dept_yn%>">
			
            	<table  class="cont_t_list01" >
					<caption>운영자 이슈 조회</caption>
					<colgroup>
						<col width="11%" />
						<col width="12%" />
						<col width="8%" />
						<col width="15%" />
						<col width="6%" />
						<col width="*" />
						<col width="6%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>
								<select name = "st_date_type" id="st_date_type" style="height:20px; width:80%;" class="TitSelect" onChange="javascript:dateTypeChange(this.value);">
									<option value="BA" selected>기본조회</option>
									<option value="RE">재확인일</option>
									<option value="S">이슈등록일</option>
									<option value="CM">운영자처리일</option>
								</select>
							</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:65px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:65px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span> 
							</td>
							<td>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<input type="hidden" name="st_sys_type" id="st_sys_type" value="">
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop1');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>협력사</td>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" value="" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">
								<input type="hidden" name="st_sys_type" id="st_sys_type" value="">
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop2');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_name','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
						<tr>
							<td>PLANT 담당자</td>
		                    <td class ="font1_table_font" >
		                    <%if("Y".equals(st_smart_dept_yn)){ %> <!-- SMART팀 전용, 팀코드 변경되거나 사용안해서 삭제해도 화면 사용에 이상 없음. -->
		                    	<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;"></select>
		                    <%}else{%>
		                    	<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;" disabled></select>
		                    <%}%>
		                    </td>
		                    <td>발주번호</td>
							<td><input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" onKeyDown="kepEnter()"></td>
							<td>품목코드</td>
							<td><input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" onKeyDown="kepEnter()"></td>
							<td>이슈상태</td>
							<td>
								<select id="st_type" nam	e="st_type">
									<option value="" >선택</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="70" >70건</option>
					<option value="100" >100건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "500px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<span><font color="red"><b>※ 수주미접수/수주거부요청/거래유형변경/수주접수 초기화요청 건에 대한 처리는 발주단위로 일괄 반영 됩니다.</b></font></span>
<!--내용 종료-->

</body>
</html>
