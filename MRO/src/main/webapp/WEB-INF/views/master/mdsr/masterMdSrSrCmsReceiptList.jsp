<%--
**********************************************
* 메뉴 : S/R 처리부서(CMS)>S/R 접수조회
* 화면 : S/R 접수조회
* 기능 : 
* 프로그램 ID : PG_90_C_700_04
* 담당자 :  ( 설계 : 공통 )
* 착수일 : 2014-08-07
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_remark       = CommonUtil.nvl((String) request.getParameter("st_remark"), "");
String st_sys_type = CommonUtil.nvl((String) request.getParameter("st_sys_type"), "");
String st_req_type = CommonUtil.nvl((String) request.getParameter("st_req_type"), "");
String st_req_sr_type = CommonUtil.nvl((String) request.getParameter("st_req_sr_type"), "");
String st_order_by = CommonUtil.nvl((String) request.getParameter("st_order_by"), "1");
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"), "");
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"), "");

String st_view_type = CommonUtil.nvl((String) request.getParameter("st_view_type"), "");
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
					 { Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"S/R번호",		SaveName:"SR_NO"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청자",		SaveName:"REQ_USER_NAME"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Type:"Text",	Header:"부서명",		SaveName:"REQ_DEPT_NAME"}
					,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Type:"Text",	Header:"제목",		SaveName:"SR_SUBJECT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"시스템구분",	SaveName:"SYS_TEXT"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청영역",		SaveName:"REQ_TEXT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청내역분류",	SaveName:"REQ_SR_TEXT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청일시",		SaveName:"REQ_DATE"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"처리희망일",	SaveName:"PH_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"USER_ID",	SaveName:"USER_ID", Hidden:true}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "SR_NO");

	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_sys_type','getSrsysTypeList','SR01','4','ALL','<%=st_sys_type%>');
	
	var st_view_type = $("#st_view_type").val();
	//VIEW TYPE에 따른 콤보박스 분기.
	if(st_view_type == "CMS"){
		kepAjaxCommonQueryIdCombo("st_req_type","getSrsysTypeCms", "", "");
	}else{
		kepAjaxCommonQueryIdSearchTwoCombo('st_req_type','getSrsysTypeList','SR02','4','ALL','<%=st_req_type%>');	
	}
	kepAjaxCommonQueryIdSearchTwoCombo('st_req_sr_type','getSrsysTypeList','SR05','4','ALL','<%=st_req_sr_type%>');

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdsr/getMasterMdSrSrCmsReceiptList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		$("#st_order_by").val("1");
		$("#st_recv_flag").val("ING");
		
		break;

	}
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
	
	if(mySheet.RowCount() <= 0){
   		return;
   	}else{
   		for(var i=1; i<mySheet.RowCount()+1; i++){
   			mySheet.SetCellValue(i, "REQ_USER_NAME", kepMaskingName(mySheet.GetCellValue(i, "REQ_USER_NAME")));
   		}
   	}
	
}
	
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdsr/getMasterMdSrSrCmsReceiptList.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'SR_NO') { // S/R번호
		var st_sr_user_id = mySheet.GetCellValue(Row, "USER_ID");
		var st_sr_no = mySheet.GetCellValue(Row,"SR_NO");
		
		popupSel = "masterMdSrSrProcWritePop";
		openSearchPopup("/mdsr/getMasterMdSrSrProcWritePop.do", '?st_sr_user_id='+st_sr_user_id+'&st_sr_no='+st_sr_no, "1000,640,no");
	}
	return;
}


</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>S/R 접수 대상 조회</h3>
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
			<input type="hidden" id="st_view_type" name="st_view_type"  value="<%=st_view_type%>">
			
            	<table  class="cont_t_list01" >
					<caption>S/R 접수 대상 조회</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
                        <col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>요청기간</th>
							<td colspan="5">
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
							<th>시스템구분</th>
							<td>
								<select id="st_sys_type" name="st_sys_type"></select>
							</td>
							<th>요청영역</th>
							<td>
								<select id="st_req_type" name="st_req_type"></select>
							</td>
							<th>요청내역분류</th>
							<td>
								<select id="st_req_sr_type" name="st_req_sr_type"></select>
							</td>
						</tr>
						<tr> 
							<td>제목/요청내역</td>
							<td colspan="5">
								<input type="text" id="st_remark"  name="st_remark"  class="input_type_text" value="<%=st_remark %>"  style="width:97%;ime-mode:active" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" >10건</option>
					<option value="20" selected>20건</option>
					<option value="30" >30건</option>
					<option value="40" >40건</option>
					<option value="50" >50건</option>
				</select>
				<select id="st_order_by" name="st_order_by">
	              <option <%=(st_order_by.equals("1") ? "selected" : "")%> value = "1">요청일시</option>
	              <option <%=(st_order_by.equals("2") ? "selected" : "")%> value = "2">처리희망일</option>
	            </select>&nbsp;기준&nbsp;
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
  			
<!--내용 종료-->	                 

</body>
</html>
