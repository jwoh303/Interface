<%--
**********************************************
* 메뉴 : 
* 화면 : 노마진/역마진 사유 선택
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-09-12
**********************************************
--%>
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
		    			{Align : "Center",SaveName : "CODE",		Header : "코드",	Type : "Text",	Width : 120,	EditLen : 110},
		    			{Align : "Left",SaveName : "TEXT1",		Header : "노(역)마진 사유",	Type : "Text",	Width : 320, EditLen : 110,	Edit : false}
		];
		
		IBS_InitSheet(mySheet, initsheet,pagingMode);

		//하이퍼링크 설정
		setLinkCol(mySheet, "CODE");
		
		kepSearch(document.searchCondition ,  mySheet ,"/mprq/getMarginReSelectPop.do", pagingMode );
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
	}
	
	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		
		grbRow = Row;
		
		if (column == "CODE" ){ 
 			kepConfirm();
		}
		return;
	}
	
	//확인
   function kepConfirm()
   { 
     var value1 = mySheet.GetCellValue(grbRow, "CODE");
     var value2 = mySheet.GetCellValue(grbRow, "TEXT1");
     
     opener.setPopupReturn(value1,value2);
     this.close();
   }
	
</script>
<title>코리아 e 플랫폼</title>
</head>


<body onload="initPage();">

<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag"  name="pageflag" value="1">
		<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
		<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:382x;">
    	<div id="popHeader">
        	<h1 class="title">노마진/역마진 사유 선택</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>

        <!--팝업내용입니다-->
        <div id="popContainer" style="height:362x;">

	       	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "280px");
					</script>
			</div>
        </div>
    </div>
    </form>
</body>
</html>
