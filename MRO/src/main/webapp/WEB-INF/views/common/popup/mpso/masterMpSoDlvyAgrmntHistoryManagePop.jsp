<%--
**********************************************
* 메뉴 : 
* 화면 : 발주정보 이력보기
* 기능 : 해당주문의 변경이력을 조회한다. 발주번호변경포함
* 프로그램 ID : PG_06_M_002_05
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-08-06
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
   			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
   			,{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true} 
   			,{Align : "Center",SaveName : "PR_NO",		Header : "PR번호",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
   			,{Align : "Center",SaveName : "PO_NO",		Header : "PO번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
   			,{Align : "Left",SaveName : "HIST_ID",		Header : "변경ID",	Type : "Text",	Width : 130, EditLen : 110,	Edit : false, Hidden : true}
   			,{Align : "Left",SaveName : "HIST_RSN",		Header : "변경사유",	Type : "Text",	Width : 130, EditLen : 110,	Edit : false, Hidden : false}
   			,{Align : "Left",SaveName : "HIST_RSN_MEMO",		Header : "변경사유 상세",	Type : "Text",	ToolTip:true, Width : 200, EditLen : 110,	Edit : false, Hidden : false}
   			,{Align : "Center",SaveName : "HIST_DTTM",		Header : "변경일시",	Type : "Date",	Format:"YmdHm", Width : 100, EditLen : 110,	Edit : false, Hidden : false, ToolTip:true}
   			,{Align : "Center",SaveName : "PROC_USER_ID",		Header : "처리자",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");
	
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoDlvyAgrmntHistoryManagePop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoDlvyAgrmntHistoryManagePop.do" , pagingMode );
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
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoDlvyAgrmntHistoryManagePop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == 'PO_NO') { // 발주번호
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var HIST_ID = mySheet.GetCellValue(Row,"HIST_ID");
		var HIST_DTTM = mySheet.GetCellValue(Row,"HIST_DTTM");
		openSearchPopup('/common/mpso/poDetailHistPop.do','?st_buyer='+$("#st_buyer").val()+'&st_po_no='+PO_NO+'&st_hist_id='+HIST_ID+'&st_hist_dttm='+HIST_DTTM,'900,550,no');
		return;
	}
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
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
	
	
	<div id="popWrapper" style="height:374px;">
    	<div id="popHeader">
        	<h1 class="title">발주정보 이력보기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
<!--             <div id="searchBtnA02"> -->
<!--             	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  -->
<!--             	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span> -->
<!--             </div> -->
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>PO번호 :</th>
							<td><input type="text" name="st_po_no" id="st_po_no" class="input_type_text"  value="${param.st_po_no}" title="" style="width:87%;" readonly /> </td>
							<th>PR번호 :</th>
							<td><input type="text" name="st_pr_no" id="st_pr_no" class="input_type_text"  value="${param.st_pr_no}" title="" style="width:87%;" readonly /> </td>
						  </tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        
    </div>
</form> 
</body>
</html>
