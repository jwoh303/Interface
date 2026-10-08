<%--
**********************************************
* 메뉴 : 개선제안제도 > 개선제안현황
* 화면 : 개선제안현황
* 기능 : 개선제안현황
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 현명환 )
* 착수일 : 2015-12-21
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String user_id		= CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());

String recv_flag       = CommonUtil.nvl((String) request.getParameter("st_status"),"");
String st_pp_no_f       = CommonUtil.nvl((String) request.getParameter("st_pp_no_f"), "");
String st_remark       = CommonUtil.nvl((String) request.getParameter("st_remark"), "");
String st_kep_user_id = CommonUtil.nvl((String) request.getParameter("st_kep_user_id"), user_id);

String st_pp_type = CommonUtil.nvl((String) request.getParameter("st_pp_type"), "");
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"), "");
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"), "");
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
					{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제안번호",		SaveName:"PP_NO"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",	Header:"제안부서",		SaveName:"USER_DEPT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",	Header:"제안자ID",		SaveName:"REQ_USER_ID"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"제안자",			SaveName:"USER_NAME"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",	Header:"제안일시",		SaveName:"ADD_DATE"}
					,{ Align:"Left",		Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",	Header:"제목",				SaveName:"PP_SUBJECT"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:70,		Hidden:true,	Type:"Text",	Header:"진행상태",		SaveName:"STATUS"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",	Header:"진행상태",		SaveName:"STATUS_TEXT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"평가자1",		SaveName:"PP_ARPS_ID1"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"사업1부",		SaveName:"PP_POINT1"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"평가자2",		SaveName:"PP_ARPS_ID2"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"사업2부",		SaveName:"PP_POINT2"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"평가자3",		SaveName:"PP_ARPS_ID3"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"전략기획실",	SaveName:"PP_POINT3"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"평가자4",		SaveName:"PP_ARPS_ID4"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"시스템실",		SaveName:"PP_POINT4"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"평가자5",		SaveName:"PP_ARPS_ID5"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"미래사업부",	SaveName:"PP_POINT5"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등급확정자",	SaveName:"PP_ARPS_ID6"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",	Header:"등급확정",		SaveName:"PP_POINT6"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",	Header:"등급확정",		SaveName:"PP_POINT6_TEXT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",	Header:"평가자체크",	SaveName:"CHK_ARPS_ID"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",	Header:"수정가능여부",	SaveName:"MODIFY_YN"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:true,	Type:"Text",	Header:"실행부서코드",	SaveName:"EXC_DEPT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",	Header:"실행부서",		SaveName:"EXC_DEPT_NAME"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PP_SUBJECT");
	setLinkCol(mySheet, "PP_POINT1");
	setLinkCol(mySheet, "PP_POINT2");
	setLinkCol(mySheet, "PP_POINT3");
	setLinkCol(mySheet, "PP_POINT4");
	setLinkCol(mySheet, "PP_POINT5");
	setLinkCol(mySheet, "PP_POINT6");

	// 제안자 콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getUserSelectkorea', 'ALL', '');
	
	// 요청영역 콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_pp_type','getSrsysTypeList','M147','4','','');

	// 사업팀 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo('st_exec_dept','getKepDeptList','ALL','');
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_pp_type").val("00");
}
	
// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false)
			return;
	
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdpp/getMasterMdPpPropList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		$("#st_pp_type").val("00");
		
		$("#st_kep_user_id").val("");
		
		break;
	
	case "excelDown": // 엑셀다운로드
		if (mySheet.RowCount() < 1){
			alert("다운로드할 내용이 없습니다.");
			return;
		}
		 $("#pageflag").val('0');
		var fromTo =  $("#st_from_date").val().replace(/\//gi, "") + "_" + $("#st_to_date").val().replace(/\//gi, "");
	    var param = {FileName:"개선제안현황_"+fromTo+".xlsx",Merge:1,SheetDesign:1,DownCols:"PP_NO|USER_DEPT|USER_NAME|ADD_DATE|PP_SUBJECT|STATUS_TEXT|PP_POINT1|PP_POINT2|PP_POINT3|PP_POINT4|PP_POINT5|PP_POINT6_TEXT|EXC_DEPT_NAME"};
		kepDownExcel(document.searchCondition ,mySheet , "/mdpp/excelMasterMdPpPropList.do", param);
		$("#pageflag").val('1');
		break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
   	
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
	kepSearch(document.searchCondition ,  mySheet , "/mdpp/getMasterMdPpPropList.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	var st_pp_no = mySheet.GetCellValue(Row,"PP_NO");
	var st_chk_arps_id = mySheet.GetCellValue(Row,"CHK_ARPS_ID");
	var modify_yn= mySheet.GetCellValue(Row,"MODIFY_YN");
	var status_flag = mySheet.GetCellValue(Row,"STATUS");
	var st_arps_open_flag = "N";
	var grad_open_flag = "N";
	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	// 평가자 ID  체크
	var chk_user_id = $("#st_user_id").val();
	var st_arps_id1 = mySheet.GetCellValue(Row, "PP_ARPS_ID1");
	var st_arps_id2 = mySheet.GetCellValue(Row, "PP_ARPS_ID2");
	var st_arps_id3 = mySheet.GetCellValue(Row, "PP_ARPS_ID3");
	var st_arps_id4 = mySheet.GetCellValue(Row, "PP_ARPS_ID4");
	var st_arps_id5 = mySheet.GetCellValue(Row, "PP_ARPS_ID5");
	var st_arps_id6 = mySheet.GetCellValue(Row, "PP_ARPS_ID6");
	
	// 평가여부 체크
	var st_pp_point1 = mySheet.GetCellValue(Row, "PP_POINT1");
	var st_pp_point2 = mySheet.GetCellValue(Row, "PP_POINT2");
	var st_pp_point3 = mySheet.GetCellValue(Row, "PP_POINT3");
	var st_pp_point4 = mySheet.GetCellValue(Row, "PP_POINT4");
	var st_pp_point5 = mySheet.GetCellValue(Row, "PP_POINT5");
	var st_pp_point6 = mySheet.GetCellValue(Row, "PP_POINT6");
	
	// st_chk_arps_id 가 비어있으면 평가자 아닌 ID로 로그인함
	if(st_chk_arps_id != ""){
		st_arps_open_flag = "Y";
	}
	
	// 평가자 5명이 모두 평가해야 확정등급 창 열림
	if((st_pp_point1 != "미평가") && (st_pp_point2 != "미평가") && (st_pp_point3 != "미평가") && (st_pp_point4 != "미평가") && (st_pp_point5 != "미평가")){
		grad_open_flag = "Y";	
	}
	
	// 요청내역 상세 팝업
	if (column == 'PP_SUBJECT') { // 제목
		var st_req_user_id = mySheet.GetCellValue(Row, "REQ_USER_ID");
		openSearchPopup("/mdpp/getMasterMdPpPropDetailPop.do", '?st_req_user_id='+st_req_user_id+'&st_pp_no='+st_pp_no, "800,500, no");
	}
	
	/*
	1. 평가자 체크
	2. 불채택 체크
	3. 진행상태(G:제안요청, P:제안평가, R:불채택, C:확정등급) 체크
	*/
	if (column == 'PP_POINT1') {
		// 평가자 이면
		if(st_arps_open_flag == "Y"){
			// 불채택 사유 팝업
			if(st_pp_point1 == "불채택"){
				openSearchPopup("/mdpp/getMasterMdPpPropRejectPop.do", '?st_pp_no='+st_pp_no+'&st_pp_seq='+"000001", "500,200, no");
				return;
			}
			// 제안요청 : G, 제안평가 : P
			if(chk_user_id == st_arps_id1){
				if(status_flag == "G" || status_flag == "P"){
					modify_yn = 'Y';	
				}
			}else{	// 불채택, 확정등급
				modify_yn = 'N';
			}
			openSearchPopup("/mdpp/getMasterMdPpPropArpsPop.do", '?st_arps_id='+st_arps_id1+'&st_pp_no='+st_pp_no+'&st_pp_seq='+"000001"+'&modify_yn='+modify_yn, "700,600, no");
		}
	}
	if (column == 'PP_POINT2') {
		if(st_arps_open_flag == "Y"){
			if(st_pp_point2 == "불채택"){
				openSearchPopup("/mdpp/getMasterMdPpPropRejectPop.do", '?st_pp_no='+st_pp_no+'&st_pp_seq='+"000002", "500,200, no"); 
				return;
			}
			if(chk_user_id == st_arps_id2){
				if(status_flag == "G" || status_flag == "P"){
					modify_yn = 'Y';	
				}
			}else{
				modify_yn = 'N';
			}
			openSearchPopup("/mdpp/getMasterMdPpPropArpsPop.do", '?st_arps_id='+st_arps_id2+'&st_pp_no='+st_pp_no+'&st_pp_seq='+"000002"+'&modify_yn='+modify_yn, "700,600, no");
		}
	}
	if (column == 'PP_POINT3') {
		if(st_arps_open_flag == "Y"){
			if(st_pp_point3 == "불채택"){
				openSearchPopup("/mdpp/getMasterMdPpPropRejectPop.do", '?st_pp_no='+st_pp_no+'&st_pp_seq='+"000003", "500,200, no"); 
				return;
			}
			if(chk_user_id == st_arps_id3){
				if(status_flag == "G" || status_flag == "P"){
					modify_yn = 'Y';	
				}
			}else{
				modify_yn = 'N';
			}
			openSearchPopup("/mdpp/getMasterMdPpPropArpsPop.do", '?st_arps_id='+st_arps_id3+'&st_pp_no='+st_pp_no+'&st_pp_seq='+"000003"+'&modify_yn='+modify_yn, "700,600, no");
		}
	}
	if (column == 'PP_POINT4') {
		if(st_arps_open_flag == "Y"){
			if(st_pp_point4 == "불채택"){
				openSearchPopup("/mdpp/getMasterMdPpPropRejectPop.do", '?st_pp_no='+st_pp_no+'&st_pp_seq='+"000004", "500,200, no");
				return;
			}
			if(chk_user_id == st_arps_id4){
				if(status_flag == "G" || status_flag == "P"){
					modify_yn = 'Y';
				}
			}else{
				modify_yn = 'N';
			}
			openSearchPopup("/mdpp/getMasterMdPpPropArpsPop.do", '?st_arps_id='+st_arps_id4+'&st_pp_no='+st_pp_no+'&st_pp_seq='+"000004"+'&modify_yn='+modify_yn, "700,600, no");
		}
	}
	if (column == 'PP_POINT5') {
		if(st_arps_open_flag == "Y"){
			if(st_pp_point5 == "불채택"){
				openSearchPopup("/mdpp/getMasterMdPpPropRejectPop.do", '?st_pp_no='+st_pp_no+'&st_pp_seq='+"000005", "500,200, no");
				return;
			}
			if(chk_user_id == st_arps_id5){
				if(status_flag == "G" || status_flag == "P"){
					modify_yn = 'Y';
				}
			}else{
				modify_yn = 'N';
			}
			openSearchPopup("/mdpp/getMasterMdPpPropArpsPop.do", '?st_arps_id='+st_arps_id5+'&st_pp_no='+st_pp_no+'&st_pp_seq='+"000005"+'&modify_yn='+modify_yn, "700,600, no");
		}
	}
	if (column == 'PP_POINT6') {
		// 불채택이면
		if(st_pp_point6 == "R"){
			openSearchPopup("/mdpp/getMasterMdPpPropRejectPop.do", '?st_pp_no='+st_pp_no+'&st_pp_seq='+"000006", "500,200, no");
			return;
		}
		
		// 평가자인지 체크
		if(st_arps_open_flag == "Y"){
			// 확정등급ID 비어있으면(확정등급 처리 가능)
			if(st_arps_id6 == ""){
				modify_yn = 'Y';
			}else{	// 확정등급 한 이후 수정 불가
				modify_yn = 'N';
			}
			// 모두 평가한 상태(확정등급 가능)
			if(grad_open_flag == "Y"){
				openSearchPopup("/mdpp/getMasterMdPpPropArpsPop.do", '?st_arps_id='+st_arps_id6+'&st_pp_no='+st_pp_no+'&st_pp_seq='+"000006"+'&modify_yn='+modify_yn+'&grad_open_flag='+grad_open_flag, "700,600, no");	
			}else{
				alert("모든 평가완료 후 등급확정이 가능합니다.");
				return;				
			}
		}
	}
	return;
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>개선제안현황</h3>
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
			<input type="hidden" id="st_pp_arps_id1" name="st_pp_arps_id1"  value="">
			<input type="hidden" id="st_pp_arps_id2" name="st_pp_arps_id2"  value="">
			<input type="hidden" id="st_pp_arps_id3" name="st_pp_arps_id3"  value="">
			<input type="hidden" id="st_pp_arps_id4" name="st_pp_arps_id4"  value="">
			<input type="hidden" id="st_pp_arps_id5" name="st_pp_arps_id5"  value="">
			
            	<table  class="cont_t_list01" >
					<caption>개선제안현황</caption>
					<colgroup>
						<col width="5%" />
						<col width="10%" />
						<col width="5%" />
						<col width="10%" />
						<col width="5%" />
						<col width="10%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>제안기간</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="<%=st_from_date%>">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
						</tr>
						<tr> 
							<th>요청영역</th>
							<td>
								<select id="st_pp_type" name="st_pp_type"></select>
							</td>
							<th>진행상태</th>
							<td>
								<select id="st_status" name="st_status">
					              <option value="ALL">전체</option>
					              <option value="G">제안요청</option>
					              <option value="P">제안평가</option>
					              <option value="C">등급확정</option>
					              <option value="R">불채택</option>
					            </select>
							</td>
							<th>등급확정</th>
							<td>
								<select id="st_grade" name="st_grade">
					              <option value="ALL">전체</option>
					              <option value="1">1등급</option>
					              <option value="2">2등급</option>
					              <option value="3">3등급</option>
					              <option value="4">4등급</option>
					              <option value="5">5등급</option>
					              <option value="R">불채택</option>
					            </select>
							</td>
						</tr>
						<tr>
							<th>제안번호</th>
							<td>
								<input type="text" id="st_pp_no_f"  name="st_pp_no_f"  class="input_type_text" value="<%=st_pp_no_f %>" style="width:86%;ime-mode:active" onkeydown="kepEnter()">
							</td>
							<th>제안자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id"></select>
							</td>
							<th>실행부서</th>
							<td>
								<select id="st_exec_dept" name="st_exec_dept" ></select>
							</td>
						</tr>
						<tr>
							<th>제목/제안내역</th>
							<td colspan="3">
								<input type="text" id="st_remark"  name="st_remark"  class="input_type_text" value="<%=st_remark %>"  style="width:95%;ime-mode:active" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20" >20건</option>
					<option value="30" >30건</option>
					<option value="40" >40건</option>
					<option value="50" >50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "320px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<div class="btnArea">
  	          	<span class="fr">
  	          		<span class="btn_06"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>
  			
<!--내용 종료-->	                 

</body>
</html>
