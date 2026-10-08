<%--
**********************************************
* 메뉴 : 
* 화면 : 재계약이력팝업
* 기능 : 재계약이력팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2025-12-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [  
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Left",	SaveName:"BUYER_NM",			Header:"고객사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_NO",		Header:"요청번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"RC_SEQ",		Header:"요청순번",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"REVISION",		Header:"차수",				Type:"Text",		Width:40,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",		Header:"품명",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"MAKER_NAME",			Header:"제조사",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"ORIGIN_NM",			Header:"원산지",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"ATOS_DATE",			Header:"요청일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"ATOB_DATE",			Header:"재계약\마감일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"CLOSE_DATE",		Header:"계약종료일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Right",	SaveName:"STOA_LIST_PRICE",		Header:"제출단가\n(VAT별도)",		Type:"Float",		Width:80,	Edit:false ,EditLen:100,	Hidden:false}
						, {Align : "Center",SaveName : "STOA_CLOSE_DATE",		Header : "제출\n계약만료일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : false ,Sort:0,Format:"yyyy-MM-dd"}
						,{ Align:"Left",	SaveName:"A_NOTE",			Header:"운영사비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"S_NOTE",			Header:"협력사비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false, Sort:0}
						,{ Align:"Center",	SaveName:"ADD_DATE",		Header:"등록일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"ADD_USER_NM",		Header:"등록자",				Type:"Text",			Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"CHANGE_DATE",		Header:"수정일",				Type:"Date",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
						,{ Align:"Center",	SaveName:"CHANGE_USER_NM",		Header:"수정자",				Type:"Text",			Width:100,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER",				Header:"고객사코드",				Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
// 	mySheet.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	
	kepSearch(document.searchCondition ,  mySheet , "/mpcl/getSellerMpClCatalogRecharterHistoryPop.do" , pagingMode );
	mySheet.SetFocusAfterProcess(0);
}

var st;
var mt;
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
   	if(mySheet.RowCount() <= 0) return;
	if (msg != "") {
		alert(msg);
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_rc_no"  name="st_rc_no" value="${param.st_rc_no}">	
	<input type="hidden" id="st_rc_seq"  name="st_rc_seq" value="${param.st_rc_seq}">	
	<div class="wrapPopup"  >
  <div class="PopupTit">재계약 이력<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  	<div  style="height:200px; width: 840px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center">
    <button class="ButPrimary_large" onclick="javascript:parent.closePop();">확인</button>
  </div>  
</div><!-- warp 끝-->
</form>
</body>
</html>
