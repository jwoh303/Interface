<%--
**********************************************
* 메뉴 : S/R 처리부서>S/R 현황조회
* 화면 : S/R 현황조회
* 기능 : 
* 프로그램 ID : PG_90_C_700_03
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 2014-08-06
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

String recv_flag       = CommonUtil.nvl((String) request.getParameter("st_recv_flag"), "ING");
String st_sr_no_f       = CommonUtil.nvl((String) request.getParameter("st_sr_no_f"), "");
String st_remark       = CommonUtil.nvl((String) request.getParameter("st_remark"), "");
String st_kep_user_id = CommonUtil.nvl((String) request.getParameter("st_kep_user_id"), user_id);

String st_req_confirm_name = CommonUtil.nvl((String) request.getParameter("st_req_confirm_name"), "");
String st_sys_type = CommonUtil.nvl((String) request.getParameter("st_sys_type"), "");
String st_req_type = CommonUtil.nvl((String) request.getParameter("st_req_type"), "");
String st_req_sr_type = CommonUtil.nvl((String) request.getParameter("st_req_sr_type"), "");
String st_order_by = CommonUtil.nvl((String) request.getParameter("st_order_by"), "1");
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
					{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"S/R번호",	SaveName:"SR_NO"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청일시",	SaveName:"REQ_DATE"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"제목",	SaveName:"SR_SUBJECT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"진행상태",	SaveName:"RECV_TEXT"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"처리자",	SaveName:"DS_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"처리일시",	SaveName:"DF_DATE"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"처리내역",	SaveName:"DF_REMARK"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Type:"Text",	Header:"결재자",	SaveName:"REQ_CONFIRM_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"완료일시",	SaveName:"FF_DATE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"시스템구분",	SaveName:"SYS_TEXT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청영역",	SaveName:"REQ_TEXT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"요청내역분류",	SaveName:"REQ_SR_TEXT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"USER_ID",	SaveName:"USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"RECV_FLAG",	SaveName:"RECV_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REQ_CONFIRM_ID",	SaveName:"REQ_CONFIRM_ID"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "SR_NO");

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo("st_kep_user_id","getUserSelectkorea", "ALL", "<%=st_kep_user_id%>");
	
	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_sys_type','getSrsysTypeList','SR01','4','ALL','<%=st_sys_type%>');
	kepAjaxCommonQueryIdSearchTwoCombo('st_req_type','getSrsysTypeList','SR02','4','ALL','<%=st_req_type%>');
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
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdsr/getMasterMdSrSrStateList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		$("#st_order_by").val("1");
		$("#st_recv_flag").val("ING");
		$("#st_kep_user_id").val("<%=st_kep_user_id%>");
		
		break;
		
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
	    var downCol = "";
		for(var i=0;i<=mySheet.LastCol();i++){
			if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
				downCol += "|"+i;	
			}
		}
		var param = {FileName:"masterMdSrSrStateList.xlsx",DownCols:downCol.substring(1)};
		kepDownExcel(document.searchCondition ,mySheet , "/mdsr/excelMasterMdSrSrStateList.do", param);
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
	kepSearch(document.searchCondition ,  mySheet , "/mdsr/getMasterMdSrSrStateList.do?page="+current_page , pagingMode );
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'SR_NO') { // S/R번호
		var st_sr_user_id = mySheet.GetCellValue(Row, "USER_ID");
		var st_sr_no = mySheet.GetCellValue(Row,"SR_NO");
		
		popupSel = "masterMdSrSrDetailPop";
		openSearchPopup("/mdsr/getMasterMdSrSrDetailPop.do", '?st_sr_user_id='+st_sr_user_id+'&st_sr_no='+st_sr_no, "1000,640,no");// S/R 상세 팝업
	}
	return;
}


</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>S/R 현황조회</h3>
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
					<caption>S/R 현황조회</caption>
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
							<th>진행상태</th>
							<td>
								<select id="st_recv_flag" name="st_recv_flag">
					              <option <%=(recv_flag.equals("ALL") ? "selected" : "")%> value="ALL">전체</option>
					              <option <%=(recv_flag.equals("ING") ? "selected" : "")%> value="ING">진행중</option>
					              <option <%=(recv_flag.equals("결재대상") ? "selected" : "")%> value="결재대상">결재대상</option>
					              <option <%=(recv_flag.equals("결재중") ? "selected" : "")%> value="결재중">결재중</option>
					              <option <%=(recv_flag.equals("결재반려") ? "selected" : "")%> value="결재반려">결재반려</option>
					              <option <%=(recv_flag.equals("요청") ? "selected" : "")%> value="요청">요청</option>
					              <option <%=(recv_flag.equals("요청취소") ? "selected" : "")%> value="요청취소">요청취소</option>
					              <option <%=(recv_flag.equals("접수") ? "selected" : "")%> value="접수">접수</option>
					              <option <%=(recv_flag.equals("처리중") ? "selected" : "")%> value="처리중">처리중</option>
					              <option <%=(recv_flag.equals("처리완료") ? "selected" : "")%> value="처리완료">처리완료</option>
					              <option <%=(recv_flag.equals("보류처리") ? "selected" : "")%> value="보류처리">보류처리</option>
					              <option <%=(recv_flag.equals("완료") ? "selected" : "")%> value="완료">완료</option>
					            </select>
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
							<th>S/R번호</th>
							<td>
								<input type="text" id="st_sr_no_f"  name="st_sr_no_f"  class="input_type_text" value="<%=st_sr_no_f %>" style="width:86%;ime-mode:active" onkeydown="kepEnter()">
							</td>
							<td>제목/요청내역</td>
							<td colspan="3">
								<input type="text" id="st_remark"  name="st_remark"  class="input_type_text" value="<%=st_remark %>"  style="width:95%;ime-mode:active" onkeydown="kepEnter()">
							</td>
						</tr>
						<tr> 
							<th>요청자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" disabled></select>
							</td>
							<th>결재자</th>
							<td>
								<input type="text" id="st_req_confirm_name"  name="st_req_confirm_name"  class="input_type_text" value="<%=st_req_confirm_name %>"  style="width:86%;ime-mode:active" onkeydown="kepEnter()">
							</td>
							<th></th>
							<td>
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
				<select id="st_order_by" name="st_order_by">
	              <option <%=(st_order_by.equals("1") ? "selected" : "")%> value = "1">요청일시</option>
	              <option <%=(st_order_by.equals("2") ? "selected" : "")%> value = "2">처리일시</option>
	              <option <%=(st_order_by.equals("3") ? "selected" : "")%> value = "3">완료일시</option>
	            </select>&nbsp;기준&nbsp;
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
  					<span class="btn_03"><a href="javascript:doAction('excelDown');">다운로드</a></span>
  				</span>
  			 </div>
  			
<!--내용 종료-->	                 

</body>
</html>
