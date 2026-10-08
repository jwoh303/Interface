<%--
**********************************************
* 메뉴 : wms>입고>tr입고
* 화면 : 배차정보 팝업
* 기능 : * 배차정보(차량정보)를 매핑하는 팝업 - 추가
* 프로그램 ID : PG_08_M_001_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-5-22
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
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "Radio",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "CAR_ID",		Header : "차량아이디",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:true, Edit : false},
	    			{Align : "Left",SaveName : "CAR_NO",		Header : "차량번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "CAR_PERSON_NAME",		Header : "차량기사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "CAR_PERSON_TEL",		Header : "연락처",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BASE_YN",		Header : "기본차량여부",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "DELIVERY_CNT",		Header : "일일배송횟수",	Type : "Float", Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrIntervalsInfoPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrIntervalsInfoPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
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
	
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		if(mySheet.GetCellValue(i,"BASE_YN") == "Y"){
			
			mySheet.SetCellValue(i,"SELECTED","1");
		}

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
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrIntervalsInfoPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	if (column == "SELECTED" ){ 
		grbRow = Row;
	}
	return;
}





//확인
function kepConfirm()
{ 
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		if(mySheet.GetCellValue(i,"SELECTED") == "1"){
			
			 var value1 = mySheet.GetCellValue(i, "CAR_ID")+"@"+mySheet.GetCellValue(i, "CAR_NO");
			 var value2 = mySheet.GetCellValue(i, "CAR_PERSON_NAME")+"@"+mySheet.GetCellValue(i, "CAR_PERSON_TEL")
			 opener.setPopupReturn(value1,value2);
			 
			 this.close();
		}

	}

}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="BUYER"  name="BUYER" value="<%=CommonUtil.nvl((String) request.getParameter("BUYER"),"") %>">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	
	<div id="popWrapper" style="height:375px;">
    	<div id="popHeader">
        	<h1 class="title">배차정보 팝업</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            
            <!--grid-->
 			<div class="scrollArea" style="border-top:2px solid #3c639c;height:225px;width:100%; ">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:kepConfirm();">확인</a></span>
				<!-- <span class="btn_02"><a href="javaScript:window.close();">닫기</a></span> -->
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
