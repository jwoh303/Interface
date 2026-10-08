<%--
**********************************************
* 메뉴 : 운영사 > 견적관리 > 견적진행조회
* 화면 : 두중재고코드입력 
* 기능 : 재고코드를 조회, 입력
* 프로그램 ID : PG_04_M_009_01
* 담당자 : 견적개 ( 설계 : 권우재 )
* 착수일 : 2014-07-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
<%
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), "");
%>
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
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "Radio",	Width : 40,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "KEP_CODE",	Type : "Text",	Width : 120,	EditLen : 110,Hidden : false, Edit : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "표준품목명",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "ITEM_NO",		Header : "재고코드",	Type : "Text",	Width : 140, EditLen : 110,	Edit : false, Hidden : false},
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,0);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	// 선택된 항목 유무 체크
	if (str !="search" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqDoosanStockCodeInsPop.do" , pagingMode );
			break;
		case "save":
			
			if(kepIsValueNull($('#st_stock_code').val())){
				alert("재고코드가 입력되지 않았습니다.");
				return;
			}
			if (!confirm("재고품목으로 등록하시겠습니까?"))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/saveDoosanStockCode.do" , "SELECTED" );
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

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationProceStateList.do?page="+current_page , pagingMode );
}

function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	if(code >0){
		doAction('search');
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
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">	

	<!-- 500*350 -->
	<div id="popWrapper" style="height:440px;">
    	<div id="popHeader">
        	<h1 class="title">
        	<!-- SLOGIC-BEGIN(P04-4034-05) -->
        	<% if ("KRDOOD0001".equals(st_buyer)) { %>
             		두산
             <% }else{ %>
                    일진
             <% } %>
        	 재고코드 입력 </h1>
        	 <!-- SLOGIC-END -->
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--조회영역-->
        	<div id="searchBtnA"  >
				<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	               	<label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow" style="width: 70px;" >
						<option value="10" selected>10건</option>
						<option value="20">20건</option>
						<option value="30">30건</option>
						<option value="40">40건</option>
						<option value="50">50건</option>
					</select>
				</span>
	        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
<!-- 			    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span> -->
   			</div>
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>두산 재고코드 입력</caption>
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>						
						<tbody>
						<tr>
							<td>제품(재고)코드</td>
							<td> 
								<input type=text name="st_buyer_item_no"  id="st_buyer_item_no" style="width:60%" value="" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "210px");
				</script>
			</div>
			<p class="paging" id="pageindex"></p>
		</div>
		
		<!--버튼영역-->
        <div class="btnArea mr25">
    		<font class="b">두산 재고자재코드 :</font>
    		<input type=text name="st_stock_code"  id="st_stock_code" style="width:200px" value="" class="input_type_text">
			<span class="btn_02 mr04"><a href="javascript:doAction('save')">확인</a></span>
        </div>
    </div>
					
	</form>
		
</body>
</html>
