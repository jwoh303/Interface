<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		var initsheet = {};
		
		initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
		    			{Align : "Center",SaveName : "NO",		Header : "순번",	Type : "Text",	Width : 60,	EditLen : 110,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "BUYER_NM",		Header : "요청공장",	Type : "Text",	Width : 150,	EditLen : 110, Edit : false},
		    			{Align : "Center",SaveName : "ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110, Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품명",	Type : "Text",	Width : 200,	EditLen : 110, Edit : false},
		    			{Align : "Center",SaveName : "COLUMN_NM",		Header : "수정사항",	Type : "Text",	Width : 80,	EditLen : 110, Edit : false},
		    			{Align : "Center",SaveName : "OLD_VALUES",		Header : "변경전",	Type : "Text",	Width : 100,	EditLen : 110, Edit : false},
		    			{Align : "Center",SaveName : "NEW_VALUES",		Header : "변경후",	Type : "Text",	Width : 130,	EditLen : 110, Edit : false},
		    			{Align : "Center",SaveName : "USER_ID",		Header : "작업자",	Type : "Text",	Width : 100,	EditLen : 80, Edit : false},
		    			{Align : "Center",SaveName : "CHANGE_DATE",		Header : "작업시간",	Type : "Date",	Format:"YmdHms", Width : 150,	EditLen : 110,	Edit : false}
		];
		IBS_InitSheet(mySheet, initsheet,pagingMode);

		//하이퍼링크 설정
// 		setLinkCol(mySheet, "BUYER_NAME");
		
		kepSearch(document.searchCondition ,  mySheet , "/mpds/getViewDbOffPoHistoryList.do" , pagingMode );
	}
	
	
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		switch (str) {
			case "search": //조회
				current_page = -1;
				kepSearch(document.searchCondition ,  mySheet , "/mpds/getViewDbOffPoHistoryList.do" , pagingMode );
				break;
			case "reload":
				kepReload('searchCondition');
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
		kepSearch(document.searchCondition ,  mySheet , "/mpds/getViewDbOffPoHistoryList.do?page="+current_page , pagingMode );
	}

	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		
		grbRow = Row;
		
		if (column == "BUYER_NAME" ){ 
 			kepConfirm();
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
<title>발주변경 현황</title>
</head>

<body onload="initPage(); ">
	<!--조회영역-->
	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag"  name="pageflag" value="1">
			<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
			<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
			<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
			<input type="hidden" id="st_seq"  name="st_seq" value="${param.st_seq}">

	<div id="popWrapper"  style="height:300px;">
    	<div id="popHeader">
        	<h1 class="title">발주변경 현황</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

       	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "195px");
					</script>
			</div>
			<div id="pageindex"></div>

		</div>				
    </div>
	</form>	
</body>
</html>
