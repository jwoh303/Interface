<%--
**********************************************
* 메뉴 :  wms>입고
* 화면 : 구매회원사
* 기능 : 
* 프로그램 ID : PG_08_M_900_10
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-9
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
<script src="/resources/libs/jquery/js/jquery-ui.custom.min.js" type="text/javascript"></script>
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
		    			{Align : "Left",SaveName : "BUYER",		Header : "고객사코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "BUYER_NAME",		Header : "고객사명",	Type : "Text",	Width : 235,	EditLen : 110,Hidden:false, Edit : false},
		    			{Align : "Right",SaveName : "INV_NO_COUNT",		Header : "총건수",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "SEQ",		Header : "SEQ",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	setLinkCol(mySheet, "BUYER_NAME");
	
   kepSearch(document.searchCondition ,  mySheet , "/wmco/getMasterWmCoMbrcmpyCountSinglePop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmco/getMasterWmCoMbrcmpyCountSinglePop.do" , pagingMode );
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
	
	for(i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		if(mySheet.GetCellValue(i,"BUYER")=="KRXPR0")
		{
			mySheet.SetCellEditable(i, "SELECTED", 0);
			mySheet.SetCellValue(i, "PO_CNT", "KePmro");
			
		}else{
			mySheet.SetCellEditable(i, "SELECTED", 1);
		}
	}

}

//페이지 인덱스 눌렀을 경우 조회


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_NAME" ){ 
		
		value1 = mySheet.GetCellValue(Row, "BUYER");
		value2 = mySheet.GetCellValue(Row, "BUYER_NAME");
		opener.setPopupReturn(value1,value2);	 
		this.close();
	}
	return;
}



</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("ware_house_code"),"") %>">	
	<input type="hidden" id="st_from_date"  name="st_from_date" value="<%=CommonUtil.nvl((String) request.getParameter("st_from_date"),"") %>">	
	<input type="hidden" id="st_to_date"  name="st_to_date" value="<%=CommonUtil.nvl((String) request.getParameter("st_to_date"),"") %>">	
	
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
        	<h1 class="title">고객사</h1>
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
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>검색 리스트</caption>
						<colgroup>
							<col width="100px" />
							<col width="20%" />
							<col width="10px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>고객사명</td>
							<td> 
								<input type="text" name="st_com_name"  id="st_com_name" size=20 value="" onkeydown="kepEnter()" style="ime-mode:active" > 
                            </td>
							<td></td>						
							<td>  
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:300px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "300px");
				</script>
			</div>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
