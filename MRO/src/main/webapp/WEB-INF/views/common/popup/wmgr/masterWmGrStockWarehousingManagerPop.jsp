<%--
**********************************************
* 메뉴 : 
* 화면 : 재고보충 입고 조회 및 삭제
* 기능 : 재고보충 입고 조회 및 삭제
* 프로그램 ID : PG_08_M_005_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-5
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>  
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "표준코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "발주수량",	Type : "Float",  Format:"${qtyFormat}",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "INV_QTY",		Header : "납품수량",	Type : "Float",  Format:"${qtyFormat}",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",	Type : "Float",  Format:"${qtyFormat}",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AVAIL_QTY",		Header : "가용재고",	Type : "Float",  Format:"${qtyFormat}",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "PRE_GR_QTY",		Header : "입고예정재고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매입단가",	Type : "Float",  Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "매입금액",	Type:"Int",Format:"#,##0",Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "CONTRACT_NO",		Header : "",	Type:"Text",Width : 100,	EditLen : 110,	Edit : false,Hidden : true},
	    			{Align : "Right",SaveName : "CONTRACT_SEQ",		Header : "",	Type:"Text",Width : 100,	EditLen : 110,	Edit : false,Hidden : true},
	    			{Align : "Right",SaveName : "GR_MODIFIABLE",		Header : "",	Type:"Text",Width : 100,	EditLen : 110,	Edit : false,Hidden : true},
	    			{Align : "Right",SaveName : "VPO_SEQ",		Header : "",	Type:"Text",Width : 100,	EditLen : 110,	Edit : false,Hidden : true},
	    			{Align : "Right",SaveName : "INV_SEQ",		Header : "",	Type:"Text",Width : 100,	EditLen : 110,	Edit : false,Hidden : true}
	    			
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
   setLinkCol(mySheet, "BUYER_ITEM_NO");
	
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockWarehousingManagerPop.do" , pagingMode );
	
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockWarehousingManagerPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "del": //삭제
			if(!checkGrDate()){
				alert("  현재월 이전 입고완료(또는 마감완료) 건으로 입고 삭제가 불가능합니다.\n\n(전월 입고완료 건은 매월 7일까지만 삭제 가능합니다.)");
				return;
			}
			if(!checkStck()){
				alert('재고 수량이 부족한 제품이 있습니다\n입고삭제를 할 수 없습니다.');
				return;
			}	
			if(!confirm('입고를 삭제 하시겠습니까?')){
				return;
			}
			kepSave(document.searchCondition ,  mySheet , "/wmgr/delMasterWmGrStockWarehousingManagerPop.do","BUYER_ITEM_NO" );
			break;	
	}

}

//입고 삭제 가능 여부 체크
function checkGrDate(){
	
		for(k=1 ; k<mySheet.GetTotalRows()+1; k++ )
		{
			if(mySheet.GetCellValue(k,"GR_MODIFIABLE")=="N")
			{
				return false;
			}
		}
		
		return true;
}

//삭제 전 재고 체크 
function checkStck(){

		for(var k=1 ; k<mySheet.GetTotalRows(); k++)
		{
			
			if(eval(mySheet.GetCellValue(k,"INV_QTY")) > eval(mySheet.GetCellValue(k,"AVAIL_QTY")))
			{
					return false;	
			}
		}
	return true;
}



function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}

	
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockWarehousingManagerPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_ITEM_NO" ){ 
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = document.searchCondition.ware_house_code.value;
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}
	return;
}


//확인
function kepConfirm()
{ 
 	var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 	var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 	opener.setPopupReturn(value1,value2);
 
 	this.close();
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(code>0){
		alert("정상적으로 입고 삭제가 되었습니다.");		
		//저장 성공시 재조회
		opener.doAction('search');
	 	this.close();
	}
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="GUBUN"  name="GUBUN" value="<%=CommonUtil.nvl((String) request.getParameter("GUBUN"),"") %>">
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=CommonUtil.nvl((String) request.getParameter("PO_NO"),"") %>">
	<input type="hidden" id="ware_house_code"  name="ware_house_code" value="<%=CommonUtil.nvl((String) request.getParameter("ware_house_code"),"") %>">
	<input type="hidden" id="st_inv_no"  name="st_inv_no" value="<%=CommonUtil.nvl((String) request.getParameter("INV_NO"),"") %>">	
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">재고보충 입고 조회 및 삭제</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:425px;">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="10%" />
							<col width="25%" />
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="15%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>물류센터</th>
							<td ><%=CommonUtil.nvl(rowData.get("BUYER_NAME")) %></td>
                  			<th >공급경로</th>
					  		<td ><%=CommonUtil.nvl(rowData.get("GUBUN")) %></td>
							<th >요청자</th>
							<td ><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME")) %>(<%=CommonUtil.nvl(rowData.get("ADD_USER_TEL")) %>)</td>
						 </tr>
						 <tr>
							<th >발주번호</th>
							<td  ><%=CommonUtil.nvl(rowData.get("PO_NO")) %></td>
                  			<th >발주일</th>
					  		<td  ><%=CommonUtil.formatStrinigDate(rowData.get("PO_DATE")) %></td>
							<th >납품요청일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE")) %></td>
						 </tr>
						 <tr>
							<th >입고번호</th>
							<td><b><%=CommonUtil.nvl(rowData.get("INV_NO")) %></b></td>
                  			<th>입고예정일</th>
					  		<td ><%=CommonUtil.formatStrinigDate(rowData.get("INV_DATE")) %> (<%=CommonUtil.nvl((String) request.getParameter("STATUS"),"") %>)</td>
							<th >입고일</th>
							<td><%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE")) %></td>
						 </tr>						 
						 <tr>
							<th >협력사</th>
							<td   colspan='5'><%=CommonUtil.nvl(rowData.get("AGENT_NAME")) %>(<%=CommonUtil.nvl(rowData.get("AGENT_TEL")) %>)</td>
						 </tr>
					</tbody>
				</table>
            <br/>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:235px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "235px");
				</script>
			</div>
		 <br/>	
	     <div class="btnArea mr25">
			<span class="fr">
				<% if("입고완료".equals(CommonUtil.nvl((String) request.getParameter("STATUS"),"") )) { %>
				<span class="btn_06 mr05"><a href="javascript:doAction('del');">재고입고 삭제</a></span>
				<% } %>
			</span>
			<br/>
       </div>
		</div>	
        
    </div>
</form> 
</body>
</html>
