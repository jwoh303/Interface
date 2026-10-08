<%--
**********************************************
* 메뉴 : 통계>경영실적통계>협력사SG별 실적
* 화면 : 협력사SG별 실적
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
int nowYear             = Integer.parseInt(check_date.substring(0,4));
int startYear = 2010;
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
					{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,		ColMerge:1, Type:"Text",	Header:"협력사|협력사",	SaveName:"COM_NAME"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,		ColMerge:1, Type:"Text",	Header:"부서|부서",	SaveName:"DEPT_NM"}
					,{ Align:"Left",	Width:90,	Edit:false,	EditLen:100,		ColMerge:0, Type:"Text",	Header:"SG|SG",	SaveName:"SG_NAME"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,			ColMerge:0, Type:"Float",	 Format:"#,##0.0",	Header:"합계|매입액",	SaveName:"AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,			ColMerge:0, Type:"Float",	 Format:"#,##0.0",	Header:"합계|매출이익",	SaveName:"MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"1월|매입액",	SaveName:"M01_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"1월|매출이익",	SaveName:"M01_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"2월|매입액",	SaveName:"M02_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"2월|매출이익",	SaveName:"M02_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"3월|매입액",	SaveName:"M03_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"3월|매출이익",	SaveName:"M03_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"4월|매입액",	SaveName:"M04_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"4월|매출이익",	SaveName:"M04_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"5월|매입액",	SaveName:"M05_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"5월|매출이익",	SaveName:"M05_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"6월|매입액",	SaveName:"M06_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"6월|매출이익",	SaveName:"M06_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"7월|매입액",	SaveName:"M07_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"7월|매출이익",	SaveName:"M07_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"8월|매입액",	SaveName:"M08_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"8월|매출이익",	SaveName:"M08_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"9월|매입액",	SaveName:"M09_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"9월|매출이익",	SaveName:"M09_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"10월|매입액",	SaveName:"M10_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"10월|매출이익",	SaveName:"M10_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"11월|매입액",	SaveName:"M11_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"11월|매출이익",	SaveName:"M11_MARGIN_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"12월|매입액",	SaveName:"M12_AMT"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"12월|매출이익",	SaveName:"M12_MARGIN_AMT"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');

	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	kepAjaxCommonQueryIdCombo('st_buyer_group','commonPopup.getMasterMdStBuyerGroup','ALL', '');
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		var st_agent_code   = $("#st_agent_code").val();
		var st_c_sg_id        = $("#st_c_sg_id").val();
		if(st_agent_code=="" && st_c_sg_id==""){
			alert("협력사 또는 SG 정보 입력 바랍니다.");
			return;
		} 
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStAgentSgResultList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_year").val("<%=nowYear%>");
		$("#st_agent_code").val("");
		$("#st_c_sg_id").val("");		
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
	
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getMasterMpStAgentSgResultList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str,key) {
	popupSel = str;
	
	switch (str) {
	case "agent_single": // 협력사
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
        popupSel = "agent_single";
        break;
	case "sg_info"://SG정보
		openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
		break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "agent_single") {
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	} else if(popupSel=="sg_info"){
		$("#st_c_sg_id").val(value1);
		$("#st_c_sg_nm").val(value2);
	}
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사 SG별 실적</h3>
			(단위 : 만원)
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>협력사 SG별 실적</caption>
					<colgroup>
						<col width="5%" />
					    <col width="10%" />
					    <col width="5%" />
					    <col width="15%" />
					    <col width="5%" />
					    <col width="15%" />
					    <col width="5%" />
					    <col width="15%" />					    					    
					    <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>년도</th>
							<td>
								<select id="st_year" name="st_year" style="width:60px;">
								<% 
								  	for (int i=startYear ; i<=nowYear; i++) {
								  		out.println("<option value='"+i+"'" + ((i == nowYear) ? " selected>" : ">")+i);
								  	} 
								 %>
								</select>							
							</td>
							<th><font color="red"><b>*</b></font>협력사</th>
							<td>
							    <input type="text" class="input_type_text" id="st_agent_name" name="st_agent_name" style="width:65%;" value=""  readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:87%" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td><font color="red"><b>*</b></font>SG</td>
							<td>
								<input type="text" id="st_c_sg_nm" name="st_c_sg_nm" class="input_type_text" style="width:65%;" value=""  readonly onclick="javascript:doPop('sg_info');">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:80%" value="">
								<a href="javascript:doPop('sg_info');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>부서</th>
							<td>
								<select id="st_user_dept" name="st_user_dept" style="width:150px;">
								</select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
			<table style="width:100%;">
				<tr>
					<td align="left">
							&nbsp;&nbsp;* 협력사, SG 검색조건 중 한가지 이상 검색조건 입력해야 조회가 됩니다.
					</td>
		   		</tr>
			</table>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "550px");
  				</script>
  			</div>
  			<!--버튼영역-->
               <div class="btnArea">
	  	          	<span class="fl">
  					</span>
  				</div>

<!--내용 종료-->	                 
		</form>
</body>
</html>
