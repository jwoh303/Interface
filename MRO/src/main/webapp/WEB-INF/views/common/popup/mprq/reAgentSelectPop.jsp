<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/js/kep_common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	var baseUrl="/mprq/reAgentSelectPop.do";
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		var initsheet = {};
		
		initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
		    			{Align : "Center",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:true},
		    			{Align : "Center",SaveName : "BUYER_NAME",		Header : "고객사명",	Type : "Text",	Width : 300, EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "CNT",		Header : "신규견적의뢰건수",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false}
		];
		
		IBS_InitSheet(mySheet, initsheet,pagingMode);

		//하이퍼링크 설정
		setLinkCol(mySheet, "BUYER_NAME");
		
		kepSearch(document.searchCondition ,  mySheet ,baseUrl, pagingMode );
	}
	
	
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		switch (str) {
			case "search": //조회
				current_page = -1;
				kepSearch(document.searchCondition ,  mySheet , baseUrl , pagingMode );
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
		kepSearch(document.searchCondition ,  mySheet , baseUrl+"?page="+current_page , pagingMode );
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
<title>코리아 e 플랫폼</title>
</head>


<body onload="initPage(); ">

	<!--조회영역-->
	<form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag"  name="pageflag" value="1">
			<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
			<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
		</div>
	</form>

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">신규등록의뢰 고객사</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/c_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>

        <!--팝업내용입니다-->
        <div id="popContainer">

	       	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "300px");
					</script>
			</div>
			<div id="pageindex"></div>

			<!--버튼영역-->
             	 <p class="btnArea">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:kepConfirm()">확인</a></span>
					<!-- <span class="btn_02"><a href="javaScript:window.close();">닫기</a></span> -->
				</span>
			 </p>

        </div>
    </div>

					
		
</body>
</html>
