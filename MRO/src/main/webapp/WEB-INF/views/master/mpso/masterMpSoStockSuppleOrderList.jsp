<%--
**********************************************
* 메뉴 : 주문관리>재고관리>재고보충발주
* 화면 : 재고보충발주
* 기능 : 상품을 조회하고 장바구니에 담아 발주처리 합니다.검색과 장바구니, 2개이상의 UI필요
* 프로그램 ID : PG_06_M_014_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_wms_code = CommonUtil.nvl((String) request.getParameter("st_wms_code"),"");  //  (조회조건)
String st_wms_name = CommonUtil.nvl((String) request.getParameter("st_wms_name"),"");  //  (조회조건)

//1: 허용, 0:불가
String poAuth	= "0";
String userId	= "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	userId =  CommonUtil.nvl((String)sessionInfo.getUserId());		
}  

if ("KEP200012".equals(userId)) {
	poAuth = "1";
}

%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var btnUpdateImg="/resources/images/btn_update.png";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공급경로코드",	SaveName:"PROCESS_TYPE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"공급경로",	SaveName:"COM_PATH"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE,"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"입고예정재고",	SaveName:"PRE_GR_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"가용재고",	SaveName:"AVAIL_QTY"}
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"보충재고량",	SaveName:"CART_QTY"}
					,{ Align:"Center",	Width:39,	Edit:false,	EditLen:100,	Hidden:false, 	Type:"Image",	Header:"보충재고량",	SaveName:"BTN_UPDATE_IMG"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품요청일",	SaveName:"RD_DATE"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"최소발주수량",	SaveName:"MIN_ORDER_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"안전재고",	SaveName:"SAFE_STOCK_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"최대재고",	SaveName:"MAX_STOCK_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"매입단가",	SaveName:"LIST_PRICE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"매입금액",	SaveName:"CART_AMT"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사연락처",	SaveName:"AGENT_TEL"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"용도구분",	SaveName:"USE_FLAG"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"DummyCheck",	Header:"수정구분",	SaveName:"CHECK_CAER_QTY"}
	];
	
	initsheet.Cfg={	
			MergeSheet:msHeaderOnly
	};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode );
	
	mySheet.SetImageList(1, btnUpdateImg);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");		//품목코드
	setLinkCol(mySheet, "AGENT_NAME");			//협력사
	setLinkCol(mySheet, "BTN_UPDATE_IMG", 37, 19);	//수정버튼
	
	$("#buyerTotAmt").html("0");
	
	<% if(st_wms_code != null && st_wms_code != "") {%>
		doAction("search");
	<% } %>
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
			if(isEmpty($("#st_wms_code").val())){
				alert("물류센터를 선택해 주세요.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoStockSuppleOrderList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
			$("#buyerTotAmt").html("0");
			kepReload('searchCondition');
			mySheet.RemoveAll();
			kepEraser('st_wms_code','st_wms_name');
		break;

	case "save": // 저장
	
		if(!checkProduct(arrRow)) return;
	
		if (!confirm('선택한 항목을 재고보충발주 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoStockSuppleOrderList.do" , "SELECTED" );
		break;
		
	case "del": // 취소
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/delMasterMpSoStockSuppleOrderList.do" , "SELECTED" );
		break;

	}
}

function checkProduct(arrRow){
	for(var inx = 0 ; inx < arrRow.length ; inx++){
		
		if(mySheet.GetCellValue(arrRow[inx],"PROCESS_TYPE") == "1" && "<%=poAuth%>" == "0") {
			alert(arrRow[inx] +"번째 행의 공급경로는 재고 입니다.\n재고보충발주는 대표이사님 품의전결 규정입니다.");
			return false ;
		}
		
		if(Number(mySheet.GetCellValue(arrRow[inx],"CART_QTY")) <= 0) {
			alert(arrRow[inx] +"번째 행의 보충재고량을 0이나 음수로 지정 할 수 없습니다.");
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("CART_QTY");
			return false ;
		}
	}
	return true;
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	setSumAmt();
}

//금액정보 설정
function setSumAmt() {
	var buyerTotAmt = 0;
	for( var i = 1; i <= mySheet.RowCount(); i++ ) {
		buyerTotAmt = buyerTotAmt + Number( kepFilterNum( String( mySheet.GetCellValue(i, "CART_AMT") ) ) );
    }

	$("#buyerTotAmt").html( kepCommaNum(buyerTotAmt) );
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoStockSuppleOrderList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterMpSoWmsSearchPop": // 물류센터
			openSearchPopup("/mpso/getMasterMpSoWmsSearchPop.do", "?1=1", "500,500,no");
			popupSel = "masterMpSoWmsSearchPop";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = $("#st_wms_code").val();
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		openSearchPopup("/common/catalogDetailPop.do", "?BUYER="+buyer+"&BUYER_ITEM_NO="+buyerItemNo+"&CONTRACT_NO="+contractNo+"&CONTRACT_SEQ="+contractSeq, "800,290,no");
	}else if(column == 'AGENT_NAME'){
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+agent, "800,550,no");
	}else if(column == "BTN_UPDATE_IMG"){
		var st_cart_qty = mySheet.GetCellValue(Row,"CART_QTY");
		if(st_cart_qty <= 0){
			alert('수량을 0 또는 음수로 지정 할 수 없습니다');
			mySheet.SetSelectRow(arrRow[inx]);
			mySheet.SetSelectCol("CART_QTY");
			return;
		}
		
		if(confirm('수량을 수정 하시겠습니까?')){
			mySheet.SetCellValue(Row,"CHECK_CAER_QTY", 1);
			kepSave(document.searchCondition ,  mySheet , "/mpso/modifyMasterMpSoSoStockSuppleOrderCardQty.do" , "CHECK_CAER_QTY" );
		}
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMpSoWmsSearchPop") {	// 물류센터
		$("#st_wms_code").val(value1);
		$("#st_wms_name").val(value2);
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고보충발주</h3>
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
			
            	<table  class="cont_t_list01" style="width:1024px;">
					<caption>재고보충발주</caption>
					<colgroup>
						<col width="100" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td><font color="red"><b>*</b></font>물류센터</td>
							<td>
								<input type="text" class="input_type_text" name="st_wms_name" id="st_wms_name" style="width:30%" value="<%=st_wms_name %>" readonly onclick="javascript:doPop('masterMpSoWmsSearchPop');">
								<input type="hidden" name="st_wms_code" id="st_wms_code" style="width:80%" value="<%=st_wms_code %>">
								<a href="javascript:doPop('masterMpSoWmsSearchPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepCenterEraser('st_wms_code','st_wms_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
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
  			
  			<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1" bgcolor="#FFFFFF">
				<tr>
					<td height="35" align="right" style="font-weight:bold" align="center">
						&nbsp;
					</td>
					<td height="35" align="right" style="font-weight:bold" align="center">
						총 합계액:<span id="buyerTotAmt" style="font-weight:bold; color:orange;">0</span>원&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</table>
		</div>
		
  			<!--버튼영역-->
            <div class="btnArea">
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">발주</a></span>
  					<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
