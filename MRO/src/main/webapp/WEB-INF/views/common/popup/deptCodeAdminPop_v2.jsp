<%--
**********************************************
* 메뉴 : 부서 팝업
* 화면 : 부서 팝업
* 기능 : 부서 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-03-12
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
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"C001");  //  (조회조건)
String st_open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
String st_init_flag = CommonUtil.nvl((String) request.getParameter("st_init_flag"),"N");
String st_coway_yn = CommonUtil.nvl((String) request.getAttribute("st_coway_yn"),request.getParameter("st_coway_yn"));
String st_dept_type = CommonUtil.nvl((String) request.getParameter("dept_type"), "D");  //  (조회조건)
String st_user_id = "";
String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"), "");  //  (조회조건)
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null) {
	st_user_id = CommonUtil.nvl( sessionInfo.getUserId(), "");
}else{
	st_user_id = "";
}
boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, com_code);
String group_mng_flag = "N";
if(getCodeTGCM == true){
	group_mng_flag = "Y"; 
}

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE380") %>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*부서코드*/
			,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE490") %>",				Type:"Text",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*요약 부서명*/
			,{ Align:"Left",	SaveName:"TEXT2",			Header:"<%=CommonLang.get("HTITLE491") %>",				Type:"Text",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,FontColor:"#3a72c7", Cursor:"Pointer"}/*상세 부서명*/
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

// 기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.deptCodeAdminPop, mySheet, "/common/commonList_v3.do" , pagingMode);
			break;
	}
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	var value1 = mySheet.GetCellValue(Row,"CODE");
	var value2 = mySheet.GetCellValue(Row,"TEXT1");
	if(column == "TEXT1" || column == "CODE" || column == "TEXT2"){
		var tab_id = "<%=tab_id%>";
		if(tab_id == ""){
			opener.setPopupReturn(value1,value2,"","dept");
		}else{
			opener.tabs[tab_id]["setPopupReturn"](value1,value2,"","dept");
		}
		this.close();
	}
}
</script>

<body onload="kep_onload_view();">
	 <form name=deptCodeAdminPop id=deptCodeAdminPop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAdminPop_v2">
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	 <input type="hidden" name="st_user_id" id="st_user_id"  value="<%=st_user_id%>"> 
	 <input type="hidden" name="po_dept" id="po_dept"  value="<%=po_dept%>">
	 <input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	 <input type="hidden" name="st_open" id="st_open"  value="<%=st_open%>">
	 <input type="hidden" name="tab_id" id="tab_id"  value="<%=tab_id%>">
	 <input type="hidden" name="st_init_flag" id="st_init_flag"  value="Y">
	 <input type="hidden" name="st_coway_yn" id="st_coway_yn"  value="<%=st_coway_yn%>">
	 <input type="hidden" name="group_mng_flag" id="group_mng_flag"  value="<%=group_mng_flag%>">
	 <input type="hidden" name="st_dept_type" id="st_dept_type" value="<%=st_dept_type%>">
	 <input type="hidden" name="dept_type" id="dept_type" value="<%=st_dept_type%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE329") %><!-- 부서 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopupSearchTable mt10" width="100%">
    <colgroup>
      <col width="90px" />
      <col width="280px" />
      <col width="80px" />
      <col width="210px" />
	</colgroup>
	<tr>
      <th><%=CommonLang.get("HTITLE380") %><!-- 부서코드 --></th>
      <td><div class="SearchPopupInput" onSubmit=" " style="width:210px;">
        <input type="text" name="st_req_dept_code" id="st_req_dept_code" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>     </td>
      <th><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></th>
      <td><div class="SearchPopupInput" onSubmit=" " style="width:210px;">
        <input type="text" name="st_req_dept_name" id="st_req_dept_name" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>    </td>
    </tr>
  </table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  </div>
  <div class="h15"></div>
  	<div style="height:350px; width: 680px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
