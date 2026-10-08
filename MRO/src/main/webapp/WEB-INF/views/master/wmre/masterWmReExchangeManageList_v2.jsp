<%--
**********************************************
* 메뉴 : 교환/반품현황
* 화면 : 교환/반품현황 
* 기능 : 
* 프로그램 ID : BU0403001
* 담당자 : 최찬규
* 착수일 : 2026-04-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%

// 공통
@SuppressWarnings (value="unchecked")
String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디

if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}

List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String buyer = sessionInfo.getComCode();
String userid = sessionInfo.getUserId();
String row_cnt = sessionInfo.getRowCnt();
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(row_cnt,"30"));  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
String pageString = "30,50,100,200,500,1000";
if(!Arrays.asList(pageString.split(",")).contains(onepagerow)){
	onepagerow = "30";
}

String curDate   = CommonUtil.formatDateNoDateGubun(new Date(),1);
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),""); 
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  

String st_BUYER_PERSON_NAME = CommonUtil.nvl((String) request.getParameter("st_BUYER_PERSON_NAME"),"");    	
String st_WMRE_NO = CommonUtil.nvl((String) request.getParameter("st_WMRE_NO"),"");    	
String st_PO_NO = CommonUtil.nvl((String) request.getParameter("st_PO_NO"),"");    
String st_WMRE_TYPE = CommonUtil.nvl((String) request.getParameter("st_WMRE_TYPE"),"");    
String st_flag = CommonUtil.nvl((String) request.getParameter("st_flag"),"");    
String st_date_type= CommonUtil.nvl((String) request.getParameter("st_date_type"),"");    
%> 





<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>   
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
 <div class="SubPageTit">
    <%=CommonLang.get("HTITLE1244")%><!--교환/반품현황--> <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE197") %><!-- 주문 --></li>
        <li><%=CommonLang.get("HTITLE1244")%><!--교환/반품현황--></li>
      </ul>
    </div>   
  </div>
  <form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>">
        <input type="hidden" id="pageflag" name="pageflag" value="1" />
        <input type="hidden" id="st_all_page" name="st_all_page" value="N" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
  <div class="container">
	<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG787")%><!--교환/반품의 진행현황을 확인 할 수 있습니다.--></div>
    <table class="TabSearchTable" >
     <colgroup>
      <col width="90px" />
      <col width="350px" />
      <col width="90px" />
      <col width="350px" />
      <col width="90px" />
      <col width="310px" />
     </colgroup>           	
     <tr>
      <th>조회기간</th>
      <td colspan="3">
        <select name="st_date_type" id="st_date_type" class="Select40" style=" float:left; width:192px; margin-right:7px">
          <option value="b_req_date"><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></option>
          <option value="po_create_date"><%=CommonLang.get("HTITLE208") %><!-- 발주일 --></option>
        </select>               
        <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
          <div class="Buyer-date-input"  data-datepicker><input style=" " type="text" id="st_from_date" name="st_from_date" placeholder="" readonly /><span> </span></div>
          <span class="Buyer-dash">~</span>
          <div class="Buyer-date-input" data-datepicker><input type="text" id="st_to_date" name="st_to_date" placeholder="" readonly /><span></span></div>
        </div>
        <!--div class="Buyer-datepicker-wrap" style=" width:120px">
          <div class="Buyer-date-input" data-monthpicker><input type="text" placeholder="" readonly /><span>1</span></div>
        </div-->               
        	<button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
      </td>
      <th><%=CommonLang.get("HTITLE606") %><!-- 진행상태 --></th>
      <td>
        <select name="st_flag" id= "st_flag" class="Select40" style="width:310px;">
          <option value="">전체</option>
          <option value="1"><%=CommonLang.get("HTITLE226") %><!-- 고객사요청 --></option>
          <option value="2"><%=CommonLang.get("HTITLE227") %><!-- KeP접수 --></option>
          <option value="3"><%=CommonLang.get("HTITLE228") %><!-- 종결 --></option>
          <option value="4"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></option>
        </select>  
      </td>                     
     </tr>
     <tr>
      <th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
      <td><input class="input40" style="width:286px" name="st_BUYER_PERSON_NAME" id="st_BUYER_PERSON_NAME" type="text" onKeyDown="kepEnter_v2();"/></td>
      <th><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>
      <td><input class="input40" style="width:286px" name="st_PO_NO" id="st_PO_NO" type="text" onKeyDown="kepEnter_v2();"/></td>
      <th>신청구분</th>
      <td>
        <select id="st_WMRE_TYPE" name="st_WMRE_TYPE" class="Select40" style="width:310px;">
          <%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM01","ALL","" ) %>
        </select>  
      </td>
     </tr>           
	</table>
    <div class="SearchBtnBox">
      <button class="ButOutline_Medium" onclick="javascript:doAction('reload'); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
      <button class="ButDarkGray_Medium" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
    </div>
    <div class="ArraySub mt30 mb10">
      <div class="buttonLeft"><button class="But_ExcelDown40" onclick="javascript:doAction('search2'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button></div>
      <div class="buttonRight"></div>
    </div>
    <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet", "", "100%");
        </script>      
    </div><!--IBSheetBuyer 끝 -->
    <div class="IBSheetBuyer" style="display: none;">
      	<script type="text/javascript">
          	createIBSheet("mySheet2", "", "100%");
        </script>      
    </div><!--IBSheetBuyer 끝 --> 
    <div class="PagingCenter mt10" id="pageindex"></div>
    <div class="h50"></div>
             
  </div><!-- container -->
  </form>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
</div>
</body>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";
var pagingMode = "N";

// 최초 화면 함수 
function kep_onload_view(){
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
			 ,{ Align:"Center",	SaveName:"B_REQ_DATE",				Header:"<%=CommonLang.get("HTITLE650")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*요창일자*/
			 ,{ Align:"Center",	SaveName:"M_REC_DATE",				Header:"<%=CommonLang.get("HTITLE647")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*접수일자*/
			,{ Align:"Center",	SaveName:"NAME_FLAG",				Header:"<%=CommonLang.get("HTITLE136")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*진행상태*/
			,{ Align:"Center",	SaveName:"WMRE_TYPE_NAME",		Header:"<%=CommonLang.get("HTITLE1213")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*신청구분*/
			,{ Align:"Center",	SaveName:"WMRE_NO",				Header:"<%=CommonLang.get("HTITLE216")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*요청번호*/
			,{ Align:"Center",	SaveName:"PO_NO",			Header:"<%=CommonLang.get("HTITLE203")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*발주번호*/
			,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
			,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
			,{ Align:"Right",	SaveName:"WMRE_QTY",				Header:"<%=CommonLang.get("HTITLE651")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*요청수량*/
			,{ Align:"Right",	SaveName:"ITEM_QTY",				Header:"<%=CommonLang.get("HTITLE217")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*발주수량*/
			,{ Align:"Left",	SaveName:"BUYER_PERSON_NAME",				Header:"<%=CommonLang.get("HTITLE133")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*요청자*/
			,{ Align:"Left",	SaveName:"ADD_USER_NAME",				Header:"<%=CommonLang.get("HTITLE654")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*접수자*/
			,{ Align:"Center",	SaveName:"WMRE_FILE_YN",			Header:"<%=CommonLang.get("HTITLE119")%>",		Type:"Button",Cursor:"Pointer",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}/*첨부파일*/
			,{ Align:"Center",	SaveName:"WMRE_FILE",			Header:"WMRE_FILE",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"PO_SEQ",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER",				Header:"BUYER",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"RECV_FLAG",				Header:"RECV_FLAG",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	
	IBS_InitSheet(mySheet2, initsheet, pagingMode);

	doAction('search');
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date','st_to_date','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		document.forms.searchForm.curPage.value = 1; 
		$("#st_all_page").val("N");
		kepSearch_v2(document.searchForm, mySheet, "/wmre/getMasterWmReExchangeManageList_v2.do?page="+document.forms.searchForm.curPage.value, pagingMode);
		break;
	case "search2":	 //조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date','st_to_date','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		$("#st_all_page").val("Y");
		kepSearch_v2(document.searchForm, mySheet2, "/wmre/getMasterWmReExchangeManageList_v2.do", pagingMode);
		break;
		
	case "reload":	//초기화
		kepReload_v2('searchForm');
		kepMonth_v2('st_from_date','st_to_date','1');
		mySheet.RemoveAll();
		mySheet2.RemoveAll();
		break;
	case "excelDown":
		excelDownload();
		break;
	
	}
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	makePageIndex2_v3( mySheet , document.forms.searchForm.curPage.value , document.searchForm.onepagerow.value);	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	doAction('excelDown');
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	
	var buyer = mySheet.GetCellValue(Row,"BUYER");
	var po_no = mySheet.GetCellValue(Row,"PO_NO");
	var po_seq = mySheet.GetCellValue(Row,"PO_SEQ");
	var recv_flag = mySheet.GetCellValue(Row,"RECV_FLAG");
	
	var wmre_no = mySheet.GetCellValue(Row,"WMRE_NO");
	var image_key = mySheet.GetCellValue(Row,"WMRE_FILE");
	
	if(column == "WMRE_NO"){ //wmre_no 클릭 시 
		openSearchPopup('/wmre/showMasterWmReDetailPop_v2.do','?WMRE_NO='+wmre_no , "1090,650,no"); 
	}else if(column == "WMRE_FILE_YN"){
		if(mySheet.GetCellValue(Row, "WMRE_FILE") == "")
			return;
		location.href="/common/download_v2.do?DOC_NO="+image_key;
	}
	return;
}
function pageSearch(param){
	//조회
	current_page = param.page;
	document.forms.searchForm.curPage.value = current_page;
	$("#st_all_page").val("N");
	kepSearch_v2(document.searchForm ,  mySheet , "/wmre/getMasterWmReExchangeManageList_v2.do?page="+current_page , pagingMode );
}
function excelDownload(){
	if(mySheet2.RowCount() == 0){
		var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	mySheet2.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i = 1; i <= mySheet2.RowCount(); i++) {
		downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<= mySheet2.LastCol(); i++){
		if(!mySheet2.GetColHidden(i) && mySheet2.ColSaveName(i) !="SELECTED" && mySheet2.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	var fileName = "교환반품현황_";
	
	var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	mySheet2.Down2Excel(param);
}
  

//팝업함수호출
function doPop(str,reason) {
	
	switch (str) {
	case "reason":
		openSearchPopup('/wmco/showMasterWmReturnReasonPop.do', '?st_title=요청사유&st_reason='+reason ,'500,220,no');
		break;
	case "cancel":
		openSearchPopup('/wmco/showMasterWmReturnReasonPop.do', '?st_title=사유&st_reason='+reason ,'500,220,no');
		break;
	}
}

</script>

</html>
