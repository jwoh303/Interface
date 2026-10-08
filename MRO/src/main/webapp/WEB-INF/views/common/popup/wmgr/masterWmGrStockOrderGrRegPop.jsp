<%--
**********************************************
* 메뉴 :  wms>입고
* 화면 : 재고보충발주 입고등록
* 기능 : 재고보충발주 입고확정
* 프로그램 ID : PG_08_M_002_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-5-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
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
<script src="/resources/js/common.js"></script>
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
		    			{Align : "Center",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품명",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "발주수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "0",		Header : "기입고수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매입금액",	Type:"Int", Format:"#,##0",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "매입단가",	Type : "Float",  Format:"${priceFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "계약번호",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true },
		    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Center",SaveName : "BYIT_COMORG_CODE",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true}
		    			];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "STDCATLG_ID");
	
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockOrderGrRegPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockOrderGrRegPop.do" , pagingMode );
			break;
		case "save":
			
	 	 	if(mySheet.length == 0)
	 	 	{
	 	        alert(" 입고확정 대상을 선택해 주십시요.");
	 	        return;
	 	 	}
	 		//IBS_SaveName(document.searchCondition ,mySheet);
	 		//var info = FormQueryStringEnc(document.searchCondition , true);
	 		//mySheet.DoAllSave("/wmgr/saveMasterWmGrStockOrderGrRegPop.do", info);
	 		kepSaveAll(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrStockOrderGrRegPop.do");
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}

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
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrStockOrderGrRegPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	if((column == 'STDCATLG_ID') )
	{
		if(mySheet.GetCellValue(Row, 'STDCATLG_ID') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "STDCATLG_ID");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
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
	//if (!confirm('선택한 항목을 저장 하시겠습니까?'))
	//{
		//kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrStockOrderGrRegPop.do");
	//}

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
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(code==1){
		alert("정상적으로 센타 입고가 되었습니다.");
		//저장 성공시 재조회
		 opener.doAction('search');
		 this.close();
	}
	else{
		alert(msg);
	}
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition"   id = "searchCondition"  method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="PO_NO"  name="PO_NO" value="<%=CommonUtil.nvl((String) request.getParameter("PO_NO"),"") %>">
	<input type="hidden" id="IV_NO"  name="IV_NO" value="<%=CommonUtil.nvl((String) request.getParameter("IV_NO"),"") %>">
	<input type="hidden" id="IV_NO_pop"  name="IV_NO_pop" value="Y">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("ware_house_code"),"") %>">
	<input type="hidden" id="AGENT"  name="AGENT" value="<%= CommonUtil.nvl((String) request.getParameter("AGENT"),"") %>">
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
        	<h1 class="title">재고보충발주 입고등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%;">
						<caption>조회</caption>
						<colgroup>
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>물류센터</th>
							<td ><%=CommonUtil.nvl((String) request.getParameter("ware_house_name"),"") %></td>
                  			<th >공급경로</th>
					  		<td >재고</td>
							<th >요청자</th>
							<td ><%=CommonUtil.nvl((String) request.getParameter("PR_ADD_USER_NAME"),"") %>(<%=CommonUtil.nvl((String) request.getParameter("PR_USER_NAME"),"") %>)</td>
						 </tr>
						 <tr>
							<th >발주번호</th>
							<td  ><%=CommonUtil.nvl((String) request.getParameter("PO_NO"),"") %>(<%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_NO"),"") %>)</td>
                  			<th >발주일</th>
					  		<td  ><%=CommonUtil.nvl((String) request.getParameter("PO_CREATE_DATE"),"") %></td>
							<th >납품요청일</th>
							<td  ><%=CommonUtil.nvl((String) request.getParameter("RD_DATE"),"") %></td>
						 </tr>
						 <tr>
							<th >입고번호</th>
							<td  ><b><%=CommonUtil.nvl((String) request.getParameter("IV_NO"),"") %></b></td>
                  			<th >입고예정일</th>
					  		<td colspan='3'  ><%=CommonUtil.nvl((String) request.getParameter("DS_DATE"),"") %></td>
					  	 </tr>
						 <tr>
							<th >협력사</th>
							<td   colspan='5'><u><a href="javascript:doPop('buyer_multi')"><%=CommonUtil.nvl((String) request.getParameter("AGENT_NAME"),"") %></a></u>(<%=CommonUtil.nvl((String) request.getParameter("st_AGENT_TEL"),"") %>)</td>
						 </tr>
					</tbody>
				</table>
            
            <!--grid-->
 			<div class="scrollArea" style="border-top:2px solid #3c639c;height:225px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
			<% if(!"발주".equals(CommonUtil.nvl((String) request.getParameter("STATUS"),"") ) )
				{
			%>				
			<span class="btn_02 mr04"><a href="javascript:doAction('save');">입고확정</a></span>
			<%
				}
			%>
			</span>
       </div>
        
    </div>
</form>  
</body>
</html>
