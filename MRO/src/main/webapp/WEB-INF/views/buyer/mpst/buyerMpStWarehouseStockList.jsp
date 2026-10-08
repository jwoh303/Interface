<%--
**********************************************
* 메뉴 : 재고관리>재고조회
* 화면 : 재고조회화면
* 기능 : 재고 조회
* 프로그램 ID : 
* 담당자 : CCK
* 착수일 : 2020-12-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	// 공통
	@SuppressWarnings (value="unchecked")


	String sessionComCode = _sessionInfo.getComCode();
	String SessionUserId = _sessionInfo.getUserId();
	
	
	//그룹기준 사업장 조회
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, sessionComCode);
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  // 계열사정보
	String group_mng_flag = "N";

	if(getCodeTGCM == true){
	   group_mng_flag = "Y"; 
	}
		
%>
<script src="/resources/js/kep_buyer.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:240,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"재고수량",	SaveName:"STOCK_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고수량",	SaveName:"GR_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"출고수량",	SaveName:"IV_QTY"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"카탈로그관리코드",	SaveName:"BYIT_COMORG_CODE"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약항번",	SaveName:"CONTRACT_SEQ"}
	];

// 	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:7};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var st_com_code = $("#st_buyer").val(); 
	if(st_com_code.indexOf("GROUP") >=0){
		$("#st_group_info").val(st_com_code); 
	}else{
		$("#st_group_info").val(""); 
	}
	
	switch (str) {
	case "search":	 // 조회	
		$("#re_current_page").val(1);
		current_page = -1;
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mpst/getBuyerMpStWarehouseStockList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
	
		$("#re_current_page").val(1);
		$( '#searchCondition' )[0].reset();
		
		mySheet.RemoveAll();		
		
		break;
	}
}
	
// 그리드 표시후 처리	 
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
	
	var totRow = mySheet.RowCount();
 
	if(current_page==-1){
		$("#re_current_page").val(1);
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		$("#re_current_page").val(current_page);
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	var st_com_code = $("#st_buyer").val(); 
	if(st_com_code.indexOf("GROUP") >=0){
		$("#st_group_info").val(st_com_code); 
	}else{
		$("#st_group_info").val(""); 
	}
	
	//조회
    pagingMode = "P";
	current_page = param.page;
	$("#re_current_page").val(current_page);
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getBuyerMpStWarehouseStockList.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == "BUYER_ITEM_NO") { // 품목코드
		
		var buyer = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		getBuyerCatalogDisplayPop(buyer,buyerItemNo,contractNo,contractSeq);

	}
	return;
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
		<h3>재고조회</h3>
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="re_current_page" name="re_current_page"  value="">
			<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
			<input type="hidden" name="st_group_info" id="st_group_info" value="">

		  <table  class="cont_t_list01">
		    <caption></caption>
		    <colgroup>
		    <col width="8%" />
		    <col width="25%" />
		    <col width="8%" />
		    <col width="25%" />
		    <col width="8%" />
		    <col width="25%" />
		    </colgroup>
		    <tbody>
		      <tr>
					<th>품목코드</th>
						<td><input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value="" onkeydown="kepEnter()"></td>
					<th>품명</th>
						<td><input type="text" class="input_type_text" id="st_description" name="st_description" style="width:87%;" value="" onkeydown="kepEnter()"></td>
					<th>규격</th>
						<td><input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:87%;" value="" onkeydown="kepEnter()"></td>
		      </tr>
		      <%if(group_mng_flag.equals("Y")){%>
		      <tr>
					<td>고객사</td>
					<td >
						<select name="st_buyer" id="st_buyer" style="width:90%;height:20px;" onchange="buyerChange()">
					      	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_com_code, "") %>
					    </select> 
					</td>
		      </tr>
		      <%}else {%>
		      <input type="hidden" id="st_buyer" name="st_buyer"  value="${sessionInfo.comCode}">
		      <%} %>
		    </tbody>
		  </table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
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
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
</html>
