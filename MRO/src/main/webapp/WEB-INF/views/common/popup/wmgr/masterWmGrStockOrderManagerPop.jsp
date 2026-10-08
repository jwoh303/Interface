<%--
**********************************************
* 메뉴 : 
* 화면 : 재고보충 발주 조회 및 삭제
* 기능 : 재고보충 발주 조회 및 삭제
* 프로그램 ID : PG_08_M_005_01
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
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
				    ,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드", SaveName:"BUYER_ITEM_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호", SaveName:"CONTRACT_NO"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약순번", SaveName:"CONTRACT_SEQ"} 
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명", SaveName:"DESCRIPTION"} 
					,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격", SaveName:"SPECIFICATION"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위", SaveName:"UNIT_MEASURE"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"발주수량", SaveName:"ITEM_QTY"} 
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사", SaveName:"MAKER_NAME"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"매입단가", SaveName:"UNIT_PRICE"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",Format:"#,##0",	Header:"매입금액", SaveName:"ITEM_AMT"} 
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사", SaveName:"AGENT_NAME"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,Type : "Float",  Format:"${qtyFormat}",	Header:"송장수량", SaveName:"IV_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,Type : "Float",  Format:"${qtyFormat}",	Header:"가용재고", SaveName:"AVAIL_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,Type : "Float",  Format:"${qtyFormat}",	Header:"입고예정재고", SaveName:"PRE_GR_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"flag", SaveName:"FLAG"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"status", SaveName:"STATUS"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"", SaveName:"GR_QTY"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"", SaveName:"PO_SEQ"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"", SaveName:"ORDER_CODE"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"", SaveName:"ORDER_DETAIL_CODE"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"", SaveName:"CON_NO"} 
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,Type:"Text", Header:"", SaveName:"CON_SEQ"} 
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockOrderManagerPop.do" , pagingMode );

}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockOrderManagerPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "del":
			if(!poDelCheck()){
				return;
			}
			
			if (!confirm('보충발주를 삭제하시겠습니까? '))
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmgr/deleteMasterWmGrStockOrderManagerPopPoDel.do" , "SELECTED" );
			break;
		case "setAgentChange":
			break;
		case "setPriceChange": //단가 변경
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			for(i= 1 ; i<arrRow.length; i++)
			{
				if(eval(mySheet.GetCellValue(i,"GR_QTY")) > 0)
				{
					alert("입고완료 건입니다.\n\n입고완료건은 수정 할수 없습니다\n\n입고 삭제후 처리해주세요");
					return;
				}
			}
			if(!confirm("단가를 변경 하시겠습니까?")){
				return;
			}
			kepSave(document.searchCondition ,  mySheet , "/wmgr/deleteMasterWmGrStockOrderManagerPopPriceChange.do" , "SELECTED" );
			break;
	}

}

function poDelCheck()
{
	var rtnValue = true;
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	if(selectedGrid.length == 0)
	{
		alert('삭제할 품목을 선택 하세요');
		rtnValue = false;
		return;
	}
	
	for(i= 0 ; i<arrRow.length; i++)
	{
		if(mySheet.GetCellValue(i,'FLAG')=="N")
		{
			alert("KEP유통연계 사내매출 관련하여 삭제 할수 없는 발주 입니다.\n\n유통담당자와 협의후 삭제 처리하세요");
			rtnValue = false;
			return;
		}	
	}
	
	var  st_status = document.searchCondition.st_STATUS.value;
	
	if(!(st_status=='발주'||st_status=='입고예정'||st_status=='권고발주'))
	{
		alert("입고완료된 목록은 입고삭제후 발주삭제 하세요");
		rtnValue = false;
		return;
	}
	
	return rtnValue;
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockOrderManagerPop.do?page="+current_page , pagingMode );
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
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CON_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CON_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}
	return;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	else
	{
		alert( "발주삭제가 정상적으로 이루어 졌습니다");
	}
	opener.doAction('search');
	 this.close();
}

//확인
function kepConfirm()
{ 
 opener.doAction('search');
 
 this.close();
}


function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_multi":
			 var com_code = document.searchCondition.AGENT.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		break;
	}
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="PO_NO"  name="PO_NO" value="<%=CommonUtil.nvl((String) request.getParameter("PO_NO"),"") %>">
	<input type="hidden" id="ware_house_code"  name="ware_house_code" value="<%=CommonUtil.nvl((String) request.getParameter("ware_house_code"),"") %>">
    <input type="hidden" id="GUBUN"  name="GUBUN" value="<%=CommonUtil.nvl((String) request.getParameter("GUBUN"),"") %>">
     <input type="hidden" id="st_STATUS"  name="st_STATUS" value="<%=CommonUtil.nvl((String) request.getParameter("STATUS"),"") %>">
	<input type="hidden" id="AGENT"  name="AGENT" value="<%= CommonUtil.nvl((String) request.getParameter("AGENT"),"") %>">	
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">재고보충 발주 조회 및 삭제</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:425px">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" >
						<colgroup>
							<col width="10%" />
							<col width="25%" />
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="20%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>물류센터</th>
							<td ><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC")) %></td>
                  			<th >공급경로</th>
					  		<td ><%=CommonUtil.nvl(rowData.get("GUBUN")) %></td>
							<th >요청자</th>
							<td ><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC")) %></td>
						 </tr>
						 <tr>
							<th >발주번호</th>
							<td  ><b><%=CommonUtil.nvl(rowData.get("PO_NO")) %></b></td>
                  			<th >발주일</th>
					  		<td  ><%=CommonUtil.formatStrinigDate(rowData.get("VPO_DATE")) %></td>
							<th >납품요청일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE")) %></td>
						 </tr>
						 <tr>
							<th >협력사</th>
							<td   colspan='5'><%=CommonUtil.nvl(rowData.get("AGENT_NAME")) %>(<%=CommonUtil.nvl(rowData.get("AGENT_TEL_NO")) %>)</td>
						 </tr>
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "250px");
				</script>
			</div>
			
			<br/>
			        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
			<% if("KRKORE0236".equals(CommonUtil.nvl((String) request.getParameter("ware_house_code"),"")) || "KRKORE0234".equals(CommonUtil.nvl((String) request.getParameter("ware_house_code"),"")) )  { %>
				<span class="btn_04 mr04"><a href="javascript:doAction('setPriceChange');;">단가변경</a></span>
				<span class="btn_05 mr05"><a href="javascript:doAction('setAgentChange')">공급사변경</a></span>
			<% } %>	
				<!--  <span class="btn_06 mr06"><a href="javascript:doAction('del');">재고발주삭제</a></span>-->
			</span>
       </div>
		</div>	

        
    </div>
</form> 
</body>
</html>
