<%--
**********************************************
* 메뉴 : 유니폼 진행관리 > 유니폼 요청상세 팝업
* 화면 : 유니폼 요청상세 팝업 
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ 
* 착수일 : 2020-04-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"%>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>

<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList_hd = (List<Map<String,String>>) request.getAttribute("data_hd"); // 조회된결과
String buyer = CommonUtil.nvl((String) request.getParameter("buyer"), "");
String st_no = CommonUtil.nvl((String) request.getParameter("st_no"), "");
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"), "");

Map<String,String> rowData_hd = null;

if (_dataList_hd == null || _dataList_hd.size() == 0){	 
}else{	
	rowData_hd = _dataList_hd.get(0); 
}
// 공통
String SessionComCode = "";
String SessionUserId = "";
String SessionBusinessCond = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	SessionComCode = CommonUtil.nvl((String)sessionInfo.getComCode());
	SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId());
	SessionBusinessCond = CommonUtil.nvl((String)sessionInfo.getBusinessCond());
}
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {

	var initsheet = {};
	initsheet.Cols = [
			{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"고객사",	SaveName:"BUYER"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"요청번호",	SaveName:"ST_NO"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"요청항번",	SaveName:"ST_SEQ"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",		Header:"상태",	SaveName:"STATUS"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"상태",	SaveName:"STATUS_TEXT"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:30,		Hidden:false,	Type:"Text",		Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Left",	Width:250,	Edit:false,	EditLen:20,		Hidden:false,	Type:"Text",		Header:"품명",	SaveName:"DESCRIPTION"}
			,{ Align:"Left",	Width:250,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"규격",	SaveName:"SPECIFICATION"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"단위",	SaveName:"UNIT_MEASURE"}
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"요청수량",	SaveName:"ITEM_QTY"}
			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"비고",	SaveName:"REQ_NOTE"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	doAction("search");
}

function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

//팝업함수호출
function doPop(str, value1, value2) {
	popupSel = "";
	
	switch (str) {
		case "dept": // 요청부서
			var buyerCode = "";
			var sessionCode = $("#st_com_code").val();
			var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
			openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+comCode, "500,500,no");
			break;
			
		case "remark_r"://의견
			var viewType = "R";
			popupSel = "remark_r";
			
			openSearchPopup("/mpso/showMasterMpSoUniformAprvRemarkPop.do", "?viewType="+viewType+"&st_return_remark="+value1, "500,230,no"); // 협력사 비고  
			break;
			
		case "remark_c"://결재 반려 의견 작성
			var viewType = "C";
			popupSel = "remark_c";
			
			if(value1 == "Y"){
				if(!confirm('생산 계획에 대하여 결재하시겠습니까?'))
					return;	
			}else{
				if(!confirm('생산 계획에 대하여 반려하시겠습니까?'))
					return;
			}
			
			openSearchPopup("/mpso/showMasterMpSoUniformAprvRemarkPop.do", "?viewType="+viewType+"&title="+value1, "500,230,no"); // 협력사 비고  
			break;
	}
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "remark_c") {
		$("#st_remark").val(value1);
		$("#st_aprv_flag").val(value2);
		
		kepAjaxFormCall("/mpso/saveMasterMpSoUniformDetailPop.do","searchForm","save");
	}
	
	grbRow="";	//초기화
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;
	
    if(sMsg == "UPDATE_OK"){
		if(pMethod == "save"){
			alert("정상적으로 처리되었습니다.");
			
			// 처리후 재조회
			opener.doAction('search');
			this.close();
			
       }
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response){
	if(pMethod == "save"){
		alert("등록 실패하였습니다. \n\n확인 후 다시 시도해 주시기 바랍니다.");
	}
}

var st;
var mt;

//기능함수
function doAction(str, flag) {
	st = new Date();
	
	switch (str) {
		case "search":
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mpso/getMasterMpSoUniformDetailPopList.do", pagingMode);
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
}

function mySheet_OnChange(Row, Col, Value) {
}

//그리드 표시후 처리	
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

	if (current_page==-1) {
		makePageIndex2(mySheet, 1, document.searchForm.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchForm.onepagerow.value);	
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
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchForm, mySheet, "/mpso/getMasterMpSoUniformDetailPopList.do?page="+current_page, pagingMode);
}

</script> 
<body onload="kep_onload_view();">
<form name="searchForm" id="searchForm" method=post>
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME"/>
<input type="hidden" id="pageflag" name="pageflag" value="1"/>
<input type="hidden" name="onepagerow" id="onepagerow"  value="10">
<input type="hidden" name="buyer" id="buyer"  value="<%=buyer%>">
<input type="hidden" name="st_no" id="st_no"  value="<%=st_no%>">
<input type="hidden" name="st_remark" id="st_remark"  value="">
<input type="hidden" name="st_aprv_flag" id="st_aprv_flag"  value="">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:400px;">
    	<div id="popHeader">
			<h1 class="title">유니폼 요청 상세</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        
        <div id="popContainer">
        	<div id="cont_searchA">	
				<table class="cont_t_list01" style="width:100%">
					<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>
					<colgroup>
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
					</colgroup>
				
					<tbody>
						<tr>
							<th>사업장명</th>
							<td><%=CommonUtil.nvl(rowData_hd.get("HD_BUYER_NAME"))%></td>
				      		
				      		<th>요청번호</th>
							<td><%=CommonUtil.nvl(rowData_hd.get("HD_ST_NO"))%></td>
							
							<th></th>
							<td></td>
							
							<th></th>
							<td></td>
						</tr>
						
						<tr>
							<th>요청일시</th>
							<td><%=CommonUtil.nvl(rowData_hd.get("HD_ADD_DATE"))%></td>
				      		
				      		<th>요청자</th>
							<td><%=CommonUtil.nvl(rowData_hd.get("HD_ADD_USER_NAME"))%></td>
							
							<th>결재일시</th>
							<td><%=CommonUtil.nvl(rowData_hd.get("HD_B_CONFIRM_DATE"))%></td>
							
							<th>결재자</th>
							<td>
								<%=CommonUtil.nvl(rowData_hd.get("HD_B_CONFIRM_USER_NAME"))%>
								
								<%if(!rowData_hd.get("HD_B_CONFIRM_USER_NAME").equals("")){%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%if(rowData_hd.get("HD_B_CONFIRM_NOTE").equals("")){%>
	                                		<img name = "st_b_remark_img" id="st_b_remark_img" src="/resources/images/icon2.gif" border="0" style="vertical-align: middle;">
	                                <%}else{%>
											<a href="javascript:doPop('remark_r','<%=CommonUtil.nvl(rowData_hd.get("HD_B_CONFIRM_NOTE"))%>');">
												<img name="st_b_remark_img" id="st_b_remark_img" src="/resources/images/icon.gif" border="0" style="vertical-align: middle;">
											</a>
									<%}%>
								<%}%>
							</td>
						</tr>
						
						<tr>
							<th>확인일시</th>
							<td><%=CommonUtil.nvl(rowData_hd.get("HD_A_CONFIRM_DATE"))%></td>
				      		
				      		<th>확인자</th>
							<td>
								<%=CommonUtil.nvl(rowData_hd.get("HD_A_CONFIRM_USER_NAME"))%>
								
								<%if(!rowData_hd.get("HD_A_CONFIRM_USER_NAME").equals("")){%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%if(rowData_hd.get("HD_A_CONFIRM_NOTE").equals("")){%>
	                                		<img name = "st_a_remark_img" id="st_a_remark_img" src="/resources/images/icon2.gif" border="0" style="vertical-align: middle;">
	                                <%}else{%>
											<a href="javascript:doPop('remark_r','<%=CommonUtil.nvl(rowData_hd.get("HD_A_CONFIRM_NOTE"))%>');"  >
												<img name="st_a_remark_img" id="st_a_remark_img" src="/resources/images/icon.gif" border="0" style="vertical-align: middle;">
											</a>
									<%}%>
								<%}%>
							</td>
							
							<th>접수일시</th>
							<td><%=CommonUtil.nvl(rowData_hd.get("HD_S_CONFIRM_DATE"))%></td>
							
							<th>접수자</th>
							<td>
								<%=CommonUtil.nvl(rowData_hd.get("HD_S_CONFIRM_USER_NAME"))%>
								
								<%if(!rowData_hd.get("HD_S_CONFIRM_USER_NAME").equals("")){%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%if(rowData_hd.get("HD_S_CONFIRM_NOTE").equals("")){%>
	                                		<img name = "st_s_remark_img" id="st_s_remark_img" src="/resources/images/icon2.gif" border="0" style="vertical-align: middle;">
	                                <%}else{%>
											<a href="javascript:doPop('remark_r','<%=CommonUtil.nvl(rowData_hd.get("HD_S_CONFIRM_NOTE"))%>');"  >
												<img name="st_s_remark_img" id="st_s_remark_img" src="/resources/images/icon.gif" border="0" style="vertical-align: middle;">
											</a>
									<%}%>
								<%}%>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
            <div class="contArea" style="height:380px;" >
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "340px");
					</script>
				</div>
				<p class="paging" id="pageindex"></p>
			</div>

			<!--버튼영역-->	
			<div class="btnArea">
			
<%if("A".equals(CommonUtil.nvl(rowData_hd.get("HD_APRV_YN")))){%>
	<!-- 고객사 -->
	<%if("B".equals(SessionBusinessCond)){%>
		<%if("NNN".equals(CommonUtil.nvl(rowData_hd.get("HD_CONFIRM_STATUS")))){%>
				<input type="hidden" name="st_business_cond" id="st_business_cond"  value="B">
				<span class="fr">
					<span class="btn_04">
						<a href="javascript:doPop('remark_c', 'R');">반려</a>
					</span>
					<span class="btn_04">
						<a href="javascript:doPop('remark_c', 'Y');">결재</a>
					</span>
				</span>
		<%}%>
	<!-- 운영사-->
	<%}else if("M".equals(SessionBusinessCond)){%>
		<%if("YNN".equals(CommonUtil.nvl(rowData_hd.get("HD_CONFIRM_STATUS")))){%>
				<input type="hidden" name="st_business_cond" id="st_business_cond"  value="M">
				<span class="fr">
					<span class="btn_04">
						<a href="javascript:doPop('remark_c', 'R');">반려</a>
					</span>
					<span class="btn_04">
						<a href="javascript:doPop('remark_c', 'Y');">결재</a>
					</span>
				</span>
		<%}%>
	<!-- 협력사 -->
	<%}else if("S".equals(SessionBusinessCond)){%>
		<%if("YYN".equals(CommonUtil.nvl(rowData_hd.get("HD_CONFIRM_STATUS")))){%>
				<input type="hidden" name="st_business_cond" id="st_business_cond"  value="S">
				<span class="fr">
					<span class="btn_04">
						<a href="javascript:doPop('remark_c', 'R');">반려</a>
					</span>
					<span class="btn_04">
						<a href="javascript:doPop('remark_c', 'Y');">결재</a>
					</span>
				</span>
		<%}%>
	<%}%>
<%}%>
			</div>
			
		</div>
	</div>
</form> 
</body>
</html>
