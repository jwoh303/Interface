<%--
**********************************************
* 메뉴 : 
* 화면 : 긴급납기
* 기능 : 긴급납기
* 프로그램 ID : PG_07_M_014_11
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-08-27
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
	    			{Align : "Center",SaveName : "BUYER_NAME",		Header : "고객사명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품번",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "RD_DATE",		Header : "납품요청일",	Type : "Date",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",SaveName : "DS_DATE",		Header : "납품예정일",	Type : "Date",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",SaveName : "PA_USER_NAME",		Header : "KeP담당자",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",SaveName : "INV_DATE",		Header : "송장생성일",	Type : "Date",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",SaveName : "AGENT_USER",		Header : "협력사담당자",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},  
	    			{Align : "Center",SaveName : "AGENT_USER_TEL_NO",		Header : "협력사연락처",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false} ,
	    			
	    			{Align : "Center",SaveName : "BUYER",		Header : "BUYER",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true} ,
	    			{Align : "Center",SaveName : "AGENT",		Header : "AGENT",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true} ,
	    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "CONTRACT_NO",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true} ,
	    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "CONTRACT_SEQ",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true} 
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO"); 
	setLinkCol(mySheet, "AGENT_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvUrgentManagementPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvUrgentManagementPop.do" , pagingMode );
			break;
		case "reload":
			searchCondition.reset();
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
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvUrgentManagementPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	 
	var com_code = mySheet.GetCellValue(Row, "BUYER");
	var PO_NO = mySheet.GetCellValue(Row, "PO_NO");
	var agent = mySheet.GetCellValue(Row, "AGENT");
	var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
	var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ"); 
	
	if (column == "BUYER_NAME" ){  
		 getAgentDisplayPop(com_code);
		
	}else if (column == "PO_NO" ){  
		 
		openSearchPopup('/mpiv/getCommonMpIvOrderDetailPop.do','?buyer='+com_code+'&po_no='+PO_NO  , "820,550,no"); 
		
	} else if (column == "BUYER_ITEM_NO" ){  
		getBuyerCatalogDisplayPop(com_code,BUYER_ITEM_NO,CONTRACT_NO,CONTRACT_SEQ) 
		
	}else if (column == "AGENT_NAME" ){  
		 getAgentDisplayPop(agent); 
		
	}
	
	 
	
	return;
}
 
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="50">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="BUYER"  name="BUYER" value="${sessionInfo.comCode}">
	
	<div id="popWrapper" style="height:510px;">
    	<div id="popHeader">
        	<h1 class="title">긴급납기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="70px" />
							<col width="18%" />
							<col width="70px" />
							<col width="18%" />							
							<col width="70px" />
							<col width="*" />
							
						</colgroup>
						
						<tbody>
						<tr>
							<td>발주번호</td>
							<td><input type="text" name="st_se_po_no" id="st_se_po_no" class="input_type_text" title="" style="width:100px;" /></td>
							<td>품목번호</td>
							<td><input type="text" name="st_se_item_no" id="st_se_item_no" class="input_type_text" title="" style="width:100px;" /></td>													
							<td>구분</td>
							<td> 
					  			<select name="st_doc_type" id="st_doc_type"> 
			                		<option value="F">긴급입고 </option>
			                        <option value="S">선입고</option>
			                    </select>
			                </td> 
						  </tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "300px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
  
    </div>
</form> 
</body>
</html>
