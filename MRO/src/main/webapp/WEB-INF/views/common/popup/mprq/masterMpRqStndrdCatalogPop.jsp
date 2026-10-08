<%--
**********************************************
* 메뉴 : 
* 화면 : 표준카탈로그 조회 
* 기능 : 
* 프로그램 ID : PG_04_M_005_09
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-05-20
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
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "품목명",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "규격",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "제조사",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "단위",	Type : "Text",	Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "CNT",		Header : "카탈로그 수",	Type : "Int",	Width : 80,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "자재구분",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "최종발주일",	Type : "Date",	Width : 90, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "최저거래단가",	Type : "Float",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "최저거래사이트",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "최저거래고객사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_NAME", Header : "최저거래협력사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqStndrdCatalogPop.do" , pagingMode );
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
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqStndrdCatalogPop.do?page="+current_page , pagingMode );
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
   
//팝업함수호출
  function doPop(str, value1, value2, value3, value4) {
  	switch (str) {
  	
  	case "agent": // 협력사
  		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
  		break;
  	case "catalogDetailPop": // 품목코드
  		openSearchPopup('/common/catalogDetailPop.do','?BUYER='+value1+'&BUYER_ITEM_NO='+value2+'&CONTRACT_NO='+value3+'&CONTRACT_SEQ='+value4,"800,290,no");
  		break;
  	}
  }
  
  //콜백함수(파일명은 모두 동일)
  function setPopupReturn(value1, value2, value3, value4){
  		
  	//팝업 조회후 해당 항목에 값을 셋팅
  	if (popupSel == "buyer_newsourcing") {	// 고객사
  		$("#st_buyer_code").val(value1);
  		$("#st_buyer_name").val(value2);

  	} else if (popupSel == "buyerMulti") {	// 다중 고객사
  		$("#st_buyer_code").val(value1);
  		$("#st_buyer_name").val(kepMultiName(value2,"@"));
  	}
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
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	

	<!-- 500*350 -->
	<div id="popWrapper" style="height:390px;">
    	<div id="popHeader">
        	<h1 class="title">표준카탈로그 조회 </h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
	        <div id="searchBtnA02">
	        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
	        	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	        </div>
        		<!-- 조회조건 -->
            	<table class="cont_t_list06" style="width:100%">
					<caption>표준카탈로그조회</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="11%" />
						<col width="21%" />
                          <col width="14%" />
                          <col width="20%" />
					</colgroup>						
					<tbody>
						<tr>
			                <th scope="row">표준카테고리</th>
			                <td colspan="3">
			                	<input type="text" name="m_prod01" id="m_prod01" class="input_type_text" title="" style="width:90%;" value="" /> 
			                	<a href="#"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
			                	</td>
			                <th scope="row">카탈로그번호</th>
             					<td>
             						<input type="text" name="m_prod04" id="m_prod04" class="input_type_text" title="" style="width:90%;" value="" />
         						</td>
			            </tr>
						<tr>
			                <th scope="row">품목명</th>
             					<td>
             						<input type="text" name="m_prod04" id="m_prod04" class="input_type_text" title="" style="width:90%;" value="" />
         						</td>
			                <th scope="row">규격</th>
             					<td>
             						<input type="text" name="m_prod04" id="m_prod04" class="input_type_text" title="" style="width:90%;" value="" />
         						</td>
			                <th scope="row">제조사</th>
             					<td>
             						<input type="text" name="m_prod04" id="m_prod04" class="input_type_text" title="" style="width:90%;" value="" />
         						</td>
						</tr>
					</tbody>
			</table>
       	<!--grid-->
			<div style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "", "230px");
			</script>
		</div>
		<div id="pageindex"></div>
	</div>
    </div>
					
	</form>
		
</body>
</html>
