<%--
**********************************************
* 메뉴 : 벌크소싱 견적요청 > 견적 현황
* 화면 : 품목정보 및 요청 협력사 노출
* 기능 : 400px
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _datamap = (Map<String,String>) request.getAttribute("item_data"); // 조회된결과

	String burq_no = CommonUtil.nvl((String) request.getParameter("st_burq_no"),"");
	String item_key_id = CommonUtil.nvl((String) request.getParameter("st_item_key_id"),"");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [
		{Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태",	SaveName:"sStatus"},
		{Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사 구분",	SaveName:"AGENT_TYPE_NAME"},
		{Align:"Left",		Width:215,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"},
		{Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",	Header:"제출여부",	SaveName:"SUBMIT_YN"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	$("#st_burq_no").val("<%=burq_no%>");
	$("#st_item_key_id").val("<%=item_key_id%>");
	
	kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqBulkQuotationAddAgentListPop.do" , pagingMode );
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
</script>
</head>
<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 

		<!--내용 시작-->
	<div id="popWrapper" >
		<div id="popHeader">
			<h1 class="title">진행현황</h1>
		    <p class="popClose"><a href="javascript:self.close()">
 			    <img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
		    </a></p>
		</div>
		<div id="popContainer" style="background-color:#f5f5f5"  >
	   		<table  class="cont_t_list06 mb15" summary="품목정보" style="width:100%;">
				<caption>품목정보</caption>
				<colgroup>
					<col width="15%" />
					<col width="*" />
				</colgroup>
				<tbody>
					<tr> 
						<th scope="row" class="center">품명</th>
						<td><%=_datamap.get("KEP_DESCRIPTION") %></td>
					</tr>
					<tr>
						<th scope="row" class="center">규격</th>
						<td><%=_datamap.get("KEP_SPECIFICATION") %></td>
					</tr>
					<tr>
						<th scope="row" class="center">모델번호</td>
						<td><%=_datamap.get("KEP_MAKER_PART_NO") %></td>
					</tr>
				</tbody>
			</table>
	   		<form name = "searchCondition" id = "searchCondition" method = "post">
		   		<input type="hidden" name="s_SAVENAME">
		   		<input type="hidden" name="st_burq_no" id="st_burq_no">
		   		<input type="hidden" name="st_item_key_id" id="st_item_key_id">
	    		
	    		<!--grid-->
   				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "290px");
	  				</script>
  				</div>
	  			<br>
			</form>

<!--내용 종료-->
		</div>
	</div>

</div>

</body>
</html>