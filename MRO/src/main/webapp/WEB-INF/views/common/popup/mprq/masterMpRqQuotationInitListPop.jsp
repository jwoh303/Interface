<%--
**********************************************
* 메뉴 : 운영사 > 견적관리
* 화면 : 견적의뢰 접수
* 기능 : 견적초기화이력
* 프로그램 ID : PG_01_M_007_11
* 담당자 : 김영미 ( 설계 : 권우재 )
* 생성일 : 2014-07-15
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
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif"; 
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		
		var initsheet = {};
		
		initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 50,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 50,	EditLen : 50, Edit : true, Hidden : true}, 
		    			{Align : "Center",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "QUOTATION_NO",		Header : "견적번호",	Type : "Text",	Width : 100,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "QUOTATION_SEQ",		Header : "견적항번",	Type : "Text",	Width : 60,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "REVISION",		Header : "차수",	Type : "Text",	Width : 40,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 100,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "AGENT",		Header : "협력사",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:true, Edit : false},
		    			{Align : "Center",SaveName : "AGENT_REVISION",		Header : "협력사차수",	Type : "Text",	Width : 70,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "REVISION_R",		Header : "초기화차수",	Type : "Text",	Width : 70,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "STATUS",		Header : "상태",	Type : "Text",	Width : 50,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 150,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200,	EditLen : 200,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 50,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 70,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 70,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "LEAD_TIME",		Header : "조달일수",	Type : "Int",	Format:"${qtyFormat}", Width : 60,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ATOS_DATE",		Header : "견적요청일",	Type : "Date",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ATOS_END_DATE",		Header : "견적마감일",	Type : "Date",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ATOS_END_TIME",		Header : "견적마감시간",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "SEL_USER_ID",		Header : "협력사담당자ID",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "SEL_USER_NAME",		Header : "협력사담당자",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "SEL_USER_TEL",		Header : "협력사담당자전화번호",	Type : "Text",	Width : 100,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Right",SaveName : "STOA_LIST_PRICE",		Header : "견적단가",	Type : "Float",	 Format:"${priceFormat}", 	Width : 80,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "STOA_DATE",		Header : "견적등록일",	Type : "Date",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "STOA_TIME",		Header : "견적등록시간",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Right",SaveName : "ATOB_UNIT_PRICE",		Header : "제시단가",	Type : "Float",	 Format:"${priceFormat}", 	Width : 80,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Right",SaveName : "ATOS_TRGET_PRICE",		Header : "목표단가",	Type : "Float",	 Format:"${priceFormat}", 	Width : 80,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "요구수량",	Type : "Float",	Format:"${qtyFormat}", Width : 90,	EditLen : 70,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "STOA_REMARK",		Header : "협력사비고	",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "IMAGE_KEY_IMG",		Header : "첨부파일",	Type : "Image",	Width : 70,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "IMAGE_KEY",		Header : "첨부파일",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:true, Edit : false},
		    			{Align : "Center",SaveName : "BID_SUCCESS_FLAG",		Header : "낙찰여부",	Type : "Text",	Width : 70,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "SELLER_IMAGE_KEY_IMG",		Header : "협력사첨부파일",	Type : "Image",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "SELLER_IMAGE_KEY",		Header : "협력사첨부파일",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:true, Edit : false},
		    			{Align : "Center",SaveName : "BID_SUCCESS_CODE",		Header : "낙찰사유",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "DSS_FLAG",		Header : "DSS선정여부",	Type : "Text",	Width : 80,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "DSS_CHOICE",		Header : "DSS선정내역",	Type : "Text",	Width : 80,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ADMIN_CLOSE_FLAG",		Header : "운영자견적종결여부",	Type : "Text",	Width : 100,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ATOB_SEND_FLAG",		Header : "고객사제출여부",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ATOB_DATE",		Header : "고객사제출일자",	Type : "Date",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "ATOB_TIME",		Header : "고객사제출시간",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Right",SaveName : "BTOA_NEGO_PRICE",		Header : "고객사네고단가",	Type : "Float",	 Format:"${priceFormat}", 		Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		    			{Align : "Left",SaveName : "BID_SUCCESS_REASON",		Header : "협력사선정사유",	Type : "Text",	Width : 90,	EditLen : 100,Hidden:false, Edit : false},
		];
		
		IBS_InitSheet2(mySheet, initsheet,pagingMode,0);
		mySheet.SetCountPosition(4);
		
		//파일첨부이미지설정
		mySheet.SetImageList(0, diskOff);
		mySheet.SetImageList(1, diskOn);
		
		//하이퍼링크 설정
		setLinkCol(mySheet, "IMAGE_KEY_IMG");
		setLinkCol(mySheet, "SELLER_IMAGE_KEY_IMG");
		kepSearch(document.searchCondition ,  mySheet , "/mprq/getQuotationInitList.do" , pagingMode );
	}
	
	
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		switch (str) {
			case "search": //조회
				current_page = -1;
				kepSearch(document.searchCondition ,  mySheet , "/mprq/getQuotationInitList.do" , pagingMode );
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

		
	}
	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		
		grbRow = Row;
		
		if (column == "IMAGE_KEY_IMG" ){ 
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="R";
			var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		} else if(column == "SELLER_IMAGE_KEY_IMG"){
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="R";
			var image_key=mySheet.GetCellValue(Row, "SELLER_IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		}
		return;
	}
	
	
	//확인
   function kepConfirm()
   { 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		
		if (selectedGrid.length == 0){
			alert("고객사를 선택하여 주십시오.");
			return;
		}
		var arrRow     = selectedGrid.split("|");

		var tmptmp1 = "";
		var tmptmp2 = "";
		
		//선택된 항목 유무 체크
		if (arrRow.length == 1){
			tmptmp1 = mySheet.GetCellValue(arrRow[0],"BUYER");
			tmptmp2 = mySheet.GetCellValue(arrRow[0],"BUYER_NAME");
		} else if (arrRow.length >=2) {
			for (var i=0; i<arrRow.length; i++){
				tmptmp1 = tmptmp1 + mySheet.GetCellValue(arrRow[i],"BUYER") + "@";
				tmptmp2 = tmptmp2 + mySheet.GetCellValue(arrRow[i],"BUYER_NAME") + "@";
			}
		}
		opener.setPopupReturn(tmptmp1,tmptmp2);
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
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">	
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="${param.st_quotation_no}">	
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="${param.st_quotation_seq}">	


	<div id="popWrapper" style="height:390px;">
    	<div id="popHeader">
        	<h1 class="title">견적초기화 이력</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "318px");
				</script>
			</div>
		</div>
    </div>
					
	</form>
		
</body>
</html>
