<%--
**********************************************
* 메뉴 : 
* 화면 : MSDS상세조회 팝업
* 기능 : MSDS상세조회 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-05-12
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
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
List<Map<String,String>> _headList = (List<Map<String,String>>) request.getAttribute("hdata"); // 조회된 결과
List<Map<String,String>> _detailList = (List<Map<String,String>>) request.getAttribute("detaildata"); // 조회된 결과
String st_msds_no = CommonUtil.nvl((String) request.getParameter("st_msds_no"),"");  //  (msds_no)
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String SessionUserId = sessionInfo.getUserId();
//수정, 삭제 버튼 권한
boolean getRoleYn = CommonUtil.getCodeCheckReturn("CM10",SessionUserId);
%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function kep_onload_view() {
	
// 	var initsheet = {};
// 	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
// 	initsheet.Cols = [
// 			{ Align:"Center",	SaveName:"NO",				Header:"NO",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
// 			,{ Align:"Left",	SaveName:"CAS_NO",			Header:"CAS번호",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}/*CAS번호*/
// 			,{ Align:"Center",	SaveName:"CAS_NO_MIN_MAX",		Header:"함량정보",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}/*함량정보*/
// 			,{ Align:"Left",	SaveName:"CAS_NO_INFO",			Header:"화관법 분류",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}/*화관법 분류*/
// 			,{ Align:"Center",	SaveName:"CAS_NO_MIN",		Header:"CAS_NO_MIN",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
// 			,{ Align:"Center",	SaveName:"CAS_NO_MAX",		Header:"CAS_NO_MAX",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
// 			,{ Align:"Center",	SaveName:"CAS_NO_HARMFUL",		Header:"CAS_NO_HARMFUL",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
// 			,{ Align:"Center",	SaveName:"CAS_NO_PREPARE",		Header:"CAS_NO_PREPARE",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
// 			,{ Align:"Center",	SaveName:"CAS_NO_LIMIT",		Header:"CAS_NO_LIMIT",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}
			
// 	];
// 	IBS_InitSheet(mySheet, initsheet, pagingMode);

// 	mySheet.SetHeaderBackColor("#f2f7ff");
<%-- 	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건 --%>
	
// 	mySheet.SetTheme("DB", "DeepBlue");
	
// 	doAction('search');
	
	
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch(document.masterCoCoMsdsDetailViewPop, mySheet, "/mdcm/getMasterMsdsDetailList_v2.do" , pagingMode);
			break;
		
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	//정상적으로 처리되었습니다.
	var text = "<%=CommonLang.msg("MSG507")%>";
	openLayerPopText2(text,but1text,but1funcSearch,but1width);
	// 처리후 재조회
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다
	var text = "<%=CommonLang.msg("MSG418")%>";
	openLayerPopText2(text,but1text,but1func,but1width);
}
function thisPopClose(){
	closePopText2();
	doAction("search");
}
var g_Row = "";
var popupSel  ="";
//팝업함수호출

function downLoad(index){
	var st_image_key = $("#st_image_key_"+index).val();
	location.href = "/common/download_v2.do?DOC_NO="+st_image_key;
// 	var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_image_key+'&viewType=R&TYPE=MSDS';
// 	openLayerPop(src,"600px","490px");
}
</script>
<body onload="kep_onload_view();">
<form name="processForm" id="processForm" method="post">
	<input type="hidden" name="st_query" id="st_query"  value=""/>
</form>
<form name="masterCoCoMsdsDetailViewPop" id="masterCoCoMsdsDetailViewPop" method=post >
	<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="st_msds_no" id="st_msds_no"  value="<%=st_msds_no%>">
<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1274")%><!--MSDS 상세조회--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSub"><%=CommonLang.get("HTITLE1074")%><!-- 기본정보 --></div>
   
  <table class="PopTableThL2TdL" width="100%">
    <colgroup>
      <col width="110px" />
      <col width="250px" />
      <col width="110px" />
      <col width="250px" />
    </colgroup>
    <% if (_headList == null || _headList.size() == 0) { %>
    <tr> <td colspan="4" align="center" height = "50"><span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span> </td> </tr>
    <%}else{ 
    	for (int j=0; j<_headList.size(); j++) {
			Map<String,String> rowData1 = _headList.get(j);
    %>
    <input type="hidden" id="kep_harmful_yn" name="kep_harmful_yn" value="<%=String.valueOf(CommonUtil.nvl(rowData1.get("CMC_HARMFUL_YN")))%>">
    <tr>
      <th><%=CommonLang.get("HTITLE565")%><!-- 품명 --></th>
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("DESCRIPTION")))%></td>
      <th><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("MAKER_NAME")))%></td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("SPECIFICATION")))%></td>
      <th><%=CommonLang.get("HTITLE1275")%><!--제출번호--></th>
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("MSDS_SUBMISSION_NUMBER")))%></td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1276")%><!--품목용도--></th>
      <input type="hidden" id="st_cmc_use_code" name="st_cmc_use_code" value="<%=String.valueOf(CommonUtil.nvl(rowData1.get("CMC_USE_CODE")))%>">
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("CMC_USE_NAME")))%></td>
      <th><%=CommonLang.get("HTITLE1277")%><!--물질상태--></th>
      <input type="hidden" id="st_cmc_info_code" name="st_cmc_info_code" value="<%=String.valueOf(CommonUtil.nvl(rowData1.get("CMC_INFO_CODE")))%>">
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("CMC_INFO_NAME")))%></td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1278")%><!--용도 비고--></th>
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("CMC_USE_NOTE")))%></td>
      <th><%=CommonLang.get("HTITLE1279")%><!--밀도--></th>
      <td><%=String.valueOf(CommonUtil.nvl(rowData1.get("CMC_INFO_LEVEL")))%></td>
    </tr>
    
    <tr>
      <th><%=CommonLang.get("HTITLE1280")%><!--최종개정일--></th>
      <td><%=String.valueOf(CommonUtil.formatStrinigDate(rowData1.get("LAST_REVISION_DATE")))%></td>
      <th><%=CommonLang.get("HTITLE1281")%><!--유해화학물질--></th>
      <td>
      <%if(CommonUtil.nvl(rowData1.get("CMC_HARMFUL_YN")).equals("Y")){ %>
	      <span class="ChipsDefault_Red mr05"><%=CommonLang.get("HTITLE1282")%><!--유해화학물질 대상--></span> 
      <%}else{ %>
    	  <span class="ChipsDefault_Blue mr05"><%=CommonLang.get("HTITLE1283")%><!--유해화학물질 비대상--></span>
      <%} %>
      </td>
    </tr>
    	<%} %>
    <%} %>  
  </table>
  <div class="PopupTitSub_LeftTxt"><%=CommonLang.get("HTITLE1284")%><!--화학물질 구성 정보--><span class="pl15"><%=_detailList.size() %><%=CommonLang.msg("MSG818")%><!--개의 CAS번호가 등록되어 있습니다.--></span></div>
  <table class="Table16px" width="100%">
    <colgroup>
      <col width="50px" />
      <col width="270px" />
      <col width="150px" />
      <col width="250px" />
    </colgroup>  
  	<tr>
      <th>NO</th>
      <th><%=CommonLang.get("HTITLE1285")%><!--CAS번호--></th>
      <th><%=CommonLang.get("HTITLE1286")%><!--함량정보--></th>
      <th><%=CommonLang.get("HTITLE1287")%><!--화관법 분류--></th>
    </tr>
    <% if (_detailList == null || _detailList.size() == 0) { %>
    <tr><td colspan="4"><span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span></td></tr>
    <%}else{ %>
    	<%for (int j=0; j<_detailList.size(); j++) {%>
			<%Map<String,String> rowData2 = _detailList.get(j);%>
    <input type="hidden" name="st_cas_no_harmful" id="st_cas_no_harmful_<%=j %>"  value="<%=String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_HARMFUL")))%>">
    <input type="hidden" name="st_cas_no_prepare" id="st_cas_no_prepare_<%=j %>"  value="<%=String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_PREPARE")))%>">
    <input type="hidden" name="st_cas_no_limit" id="st_cas_no_limit_<%=j %>"  value="<%=String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_LIMIT")))%>">
    <tr>
      <td align="center"><%=String.valueOf(CommonUtil.nvl(rowData2.get("NO")))%></td>
      <td><%=String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO")))%></td>
      <td align="center"><%=String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_MIN")))%> ~ <%=String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_MAX")))%>% </td>
      <td><span class="MSDS-red">
      <%if(String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_ACUT"))).equals("Y")){%> <%=CommonLang.get("HTITLE1498")%><!--급성--> <%} %>
      <%if(String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_CHRO"))).equals("Y")){%> <%=CommonLang.get("HTITLE1499")%><!--만성--> <%} %>
      <%if(String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_ECOL"))).equals("Y")){%> <%=CommonLang.get("HTITLE1500")%><!--생태--> <%} %>
      <%if(String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_PREPARE"))).equals("Y")){%> <%=CommonLang.get("HTITLE1289")%><!--사고대비--> <%} %>
      <%if(String.valueOf(CommonUtil.nvl(rowData2.get("CAS_NO_LIMIT"))).equals("Y")){%> <%=CommonLang.get("HTITLE1290")%><!--제한--> <%} %>
      </span></td>
    </tr>
    	<%} %>
    <%} %>
  </table>
   
<!--   <div style="width:680px;"> -->
<!--   		<script type="text/javascript"> -->
<!--   			createIBSheet("mySheet", "100%", "400px");  -->
<!--  		</script>  -->
<!--   </div>   -->
  <div class="PopupTitSub"><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></div>
  <div class="Popup_GrayBox">
  <table class="NoLine_TDBottom1px" width="100%">
    <colgroup>
      <col width="570px" />
      <col width="100px" />
    </colgroup>
    <% if (_dataList == null || _dataList.size() == 0) { %>
    <tr><td colspan="2"><span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span></td></tr>
    <%}else{ 
    	for (int j=0; j<_dataList.size(); j++) {
			Map<String,String> rowData3 = _dataList.get(j);
    %>
    <tr>
      <td><img src="/resources/imgs/Icon_file.png" style="width:12px;vertical-align:middle; margin-right:5px;"/>  <%=String.valueOf(CommonUtil.nvl(rowData3.get("TEXT1")))%></td>
      <input type="hidden" name="st_image_key" id="st_image_key_<%=j %>"  value="<%=String.valueOf(CommonUtil.nvl(rowData3.get("IMAGE_KEY")))%>">
      <td>
      <%if(!"".equals(CommonUtil.nvl(rowData3.get("IMAGE_KEY")))){%>
      <button class="ButOutlineBlue_Tiny" style=" float:right; vertical-align:middle;" onclick="javascript:downLoad('<%=j%>'); return false;"><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></button>
      <%} %>
      </td>
    </tr> 
    	<%} %>
    <%} %>
  </table>
 </div>   
</div><!-- wrapPopup 끝-->  
</form> 
</body>
</html>
