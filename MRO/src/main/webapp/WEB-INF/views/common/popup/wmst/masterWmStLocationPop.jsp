<%--
**********************************************
* 메뉴 : 
* 화면 : 로케이션 변경
* 기능 : 로케이션 변경
* 프로그램 ID : PG_08_M_012_01
* 담당자 : 개발5 ( 설계 : 김상근 )
* 착수일 : 2014-8-25
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
	                  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "LOCATION_ID",Header : "로케이션코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "LOCATION_NAME",	Header : "로케이션 구역명",	Type : "Text",	Width : 200,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "STDCATLG_ID",Header : "표준코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},	
	    			{Align : "Center",SaveName : "CONTRACT_NO",Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},	
	    			{Align : "Center",SaveName : "CONTRACT_SEQ",Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}	
	    			];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "STDCATLG_ID");
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStLocationPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {

	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStLocationPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "add":
			alert('미구현');
			//kepSearch(document.searchCondition ,  mySheet , "/wmst/saveMasterWmStLocationPop.do" , pagingMode );
			break;
	}

}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	
	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}


	
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
		   alert('as-is 쿼리 오류');
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "STDCATLG_ID");
			var BYIT_COMORG_CODE =document.searchCondition.st_warehouse_code.value;
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");			
			openSearchPopup("/wmco/showMasterWmCoGoodsCodePop.do","?BUYER_ITEM_NO="+BUYER_ITEM_NO+"&BYIT_COMORG_CODE="+BYIT_COMORG_CODE+"&CONTRACT_NO="+CONTRACT_NO+"&CONTRACT_SEQ="+CONTRACT_SEQ,"800,255,no");
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
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%= CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">	
	<input type="hidden" id="st_location_id"  name="st_location_id" value="<%= CommonUtil.nvl((String) request.getParameter("st_location_id"),"") %>">			
	<input type="hidden" id="st_alloc_qty"  name="st_alloc_qty" value="<%= CommonUtil.nvl((String) request.getParameter("st_alloc_qty"),"") %>">	
	<input type="hidden" id="st_agent"  name="st_agent" value="<%= CommonUtil.nvl((String) request.getParameter("st_agent"),"") %>">	
	<input type="hidden" name="st_check"		  value="SEARCH">		
	<div id="popWrapper" style="height:500px;">
    	<div id="popHeader">
        	<h1 class="title">로케이션 변경</h1>
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
							<col width="25%" />
							<col width="*" />
							
						</colgroup>
						
						<tbody>
						<tr>
							
							<td>로케이션 코드</td>
							<td><input type="text" name="st_location_id" id="st_location_id" class="al" title="" style="width:100px;" /></td>
						  </tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:230px">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "230px");
				</script>
			</div>
			
			<br/>
			
			<!--버튼영역-->
        	<div class="btnArea mr25">
				<span class="fr">
					<span class="btn_06 mr04"><a href="javascript:doAction('add')">로케이션 추가</a></span>
				</span>
       		</div>
		</div>	
		
    </div>
</form> 
</body>
</html>
