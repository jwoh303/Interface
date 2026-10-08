<%--
**********************************************
* 메뉴 : 마이페이지 > 전체상품조회
* 화면 : 전체상품조회
* 기능 : 
* 프로그램 ID : BU0803006
* 담당자 : 임희은
* 착수일 : 2026-10-16
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

// 조회조건 S
String st_keyword = CommonUtil.nvl((String) request.getParameter("st_keyword"),"");
String keyword_sel = CommonUtil.nvl((String) request.getParameter("keyword_sel"),"");
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");
// 조회조건 E
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
    <%=CommonLang.get("HTITLE1540")%><!-- 전체상품조회 --> <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE987")%><!-- 마이페이지 --></li>
        <li><%=CommonLang.get("HTITLE1540")%><!-- 전체상품조회 --></li>
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
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<div class="container">
			<table class="TabSearchTable" >
				<colgroup>
				  <col width="80px" />
				  <col width="690px" />
				  <col width="70px" />
				  <col width="440px" />
				</colgroup>           	
				<tr>
				  <th>등록일</th>
				  <td >
				    <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
				      <div class="Buyer-date-input"  data-datepicker><input id="st_from_date" name="st_from_date" type="text" placeholder="" readonly value="<%=st_from_date %>" /><span>1 </span></div>
				      <span class="Buyer-dash">~</span>
				      <div class="Buyer-date-input" data-datepicker><input type="text" id="st_to_date" name="st_to_date" placeholder="" readonly value="<%=st_to_date %>"/><span>1</span></div>
				    </div>
				    <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','1'); return false;">1개월</button> 
				    <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','2'); return false;">2개월</button>
				    <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','3'); return false;">3개월</button>
				    <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','12'); return false;">1년</button>
				  </td>
				  <th>검색어</th>
				  <td>
				    <select name="keyword_sel" class="Select40" style=" float:left;width:120px; margin-right:5px">
				      <option value="ALL" <%if ("ALL".equals(keyword_sel)) {%>selected<%} %>>전체</option>
				      <option value="BUYER_ITEM_NO" <%if ("BUYER_ITEM_NO".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
				      <option value="DESCRIPTION" <%if ("DESCRIPTION".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
				      <option value="SPECIFICATION" <%if ("SPECIFICATION".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE14") %><!-- 규격 --></option>
				      <option value="MAKER_NAME" <%if ("MAKER_NAME".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></option>
				    </select>  
				    <input class="input40" style="width:293px" name=st_keyword id="st_keyword" type="text" maxlength="100" value="<%=st_keyword%>" onKeyDown="kepEnter_v2()"/>
				  </td>                 
				</tr>
			</table>
		    <div class="SearchBtnBox">
		      <button class="ButOutline_Medium" onclick="javascript:doAction('reload'); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
		      <button class="ButDarkGray_Medium" onclick="javascript:doAction('search'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
		    </div>
		    <div class="IBSheetBuyer mt30">
		      	<script type="text/javascript">
		          	createIBSheet("mySheet", "", "100%");
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
var pagingMode = "N";

// 최초 화면 함수 
function kep_onload_view(){
	
	$("#st_from_date").val( kepToMonthAdd("3","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
		{ Align:"Left",		SaveName:"BUYER_ITEM_NO",	Header:"<%=CommonLang.get("HTITLE12")%>",		Type:"Text",		Width:120,	Edit:false,	EditLen:0,		Hidden:false} /*품목코드*/
		,{ Align:"Left",	SaveName:"DESCRIPTION",		Header:"<%=CommonLang.get("HTITLE13")%>",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
		,{ Align:"Left",	SaveName:"SPECIFICATION",	Header:"<%=CommonLang.get("HTITLE14")%>",		Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
		,{ Align:"Left",	SaveName:"MAKER_PART_NO",	Header:"<%=CommonLang.get("HTITLE1454")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*모델번호*/
		,{ Align:"Center",	SaveName:"MAKER_NAME",		Header:"<%=CommonLang.get("HTITLE15")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*제조사*/
		,{ Align:"Center",	SaveName:"ORIGIN_NAME",		Header:"<%=CommonLang.get("HTITLE120")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*원산지*/
		,{ Align:"Center",	SaveName:"UNIT_MEASURE",	Header:"<%=CommonLang.get("HTITLE52")%>",		Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false} /*단위*/
		,{ Align:"Right",	SaveName:"DELIVERY_LT",		Header:"<%=CommonLang.get("HTITLE1033")%>",		Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false} /*배송일수*/
		,{ Align:"Right",	SaveName:"MIN_ORDER_QTY",	Header:"<%=CommonLang.get("HTITLE1028")%>",		Type:"Float",		Width:70,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"} /*최소주문*/
		,{ Align:"Right",	SaveName:"PUR_UNIT_QTY",	Header:"<%=CommonLang.get("HTITLE1029")%>",		Type:"Float",		Width:70,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"} /*주문배수*/
		,{ Align:"Right",	SaveName:"UNIT_PRICE",		Header:"<%=CommonLang.get("HTITLE174")%>",		Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"} /*단가*/
		,{ Align:"Center",	SaveName:"ADD_DATE",		Header:"<%=CommonLang.get("HTITLE393")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"} /*등록일*/
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		document.forms.searchForm.curPage.value = 1; 
		kepSearch_v2(document.searchForm, mySheet, "/mdcm/getBuyerMdCmAllGoodsSearchList.do?page="+document.forms.searchForm.curPage.value, pagingMode);
		break;

	case "reload":	//초기화
		kepReload_v2('searchForm');
		kepMonth_v2('st_from_date','st_to_date','1');
		mySheet.RemoveAll();
		mySheet2.RemoveAll();
		break;
	
	}
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	makePageIndex2_v3( mySheet , document.forms.searchForm.curPage.value , document.searchForm.onepagerow.value);	
	
	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

function pageSearch(param){
	//조회
	current_page = param.page;
	document.forms.searchForm.curPage.value = current_page;
	kepSearch_v2(document.searchForm ,  mySheet , "/mdcm/getBuyerMdCmAllGoodsSearchList.do?page="+current_page , pagingMode );
}

</script>

</html>
