<%--
**********************************************
* 메뉴 : 재고관리>출고진행조회
* 화면 : 출고진행조회화면
* 기능 : 출고진행 조회
* 프로그램 ID : 
* 담당자 : CCK
* 착수일 : 2020-12-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"출고번호",	SaveName:"IV_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"출고일",	SaveName:"IV_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Center",	Width:55,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Right",	Width:55,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"출고수량",	SaveName:"IV_QTY"}
					,{ Align:"Right",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차량번호",	SaveName:"CAR_NO"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"출고자ID",	SaveName:"ADD_USER_ID"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"출고자",	SaveName:"ADD_USER_NAME"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"카탈로그관리코드",	SaveName:"BYIT_COMORG_CODE"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약항번",	SaveName:"CONTRACT_SEQ"}
	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	//출고자list
	var com_code = $("#st_buyer").val();
	kepAjaxCommonQueryIdSearchCombo('st_add_user_id','buyer.mpst.selectBuyerMpStWarehouseGiUserList',com_code,'SEL','');
		
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		$("#re_current_page").val(1);
			current_page = -1;

			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>93){
				alert("3개월이내 조회만 가능합니다.");
				return;
			}
			
			
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mpst/getBuyerMpStWarehouseGiList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
	
		$("#re_current_page").val(1);
		$( '#searchCondition' )[0].reset();
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.RemoveAll();		
		
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"출고진행조회.xlsx",DownCols:"IV_NO|IV_DATE|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_CODE|UNIT_MEASURE|IV_QTY|CAR_NO|ADD_USER_NAME"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelBuyerMpStWarehouseGiList.do", param);
		$("#pageflag").val('1');
		break;
		
	case "del": //삭제
		if (!confirm('선택한 항목을 출고 삭제하시겠습니까?')){
			return;
		}

		kepSave(document.searchCondition, mySheet, "/mpst/delBuyerMpStWarehouseGiList.do", "SELECTED");
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
   	
	if (msg != "") {
		alert(msg);
	}
	
	var totRow = mySheet.RowCount();
 
	if(current_page==-1){
		$("#re_current_page").val(1);
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		$("#re_current_page").val(current_page);
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    pagingMode = "P";
	current_page = param.page;
	$("#re_current_page").val(current_page);
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getBuyerMpStWarehouseGiList.do?page="+current_page , pagingMode );
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == "BUYER_ITEM_NO") { // 품목코드
		
		var buyer = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		getBuyerCatalogDisplayPop(buyer,buyerItemNo,contractNo,contractSeq);

	}
	return;
}
// 팝업함수호출
function doPop(str) {
	
	switch (str) {
		case "upload": //출고업로드
			openSearchPopup("/mpst/showBuyerMpStGiExcelUpload.do", "", "500,550,no");
			break;
	}
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
		<h3>출고진행 조회</h3>
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_buyer" name="st_buyer"  value="${sessionInfo.comCode}">
			<input type="hidden" id="re_current_page" name="re_current_page"  value="">

		  <table  class="cont_t_list01">
		    <caption></caption>
		    <colgroup>
		    <col width="8%" />
		    <col width="25%" />
		    <col width="8%" />
		    <col width="25%" />
		    <col width="8%" />
		    <col width="25%" />
		    </colgroup>
		    <tbody>
		      <tr>
					<th>출고일</th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" value=""> - 
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" value="">
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>	  
					</td>
					<th>차량번호</th>
						<td><input type="text" class="input_type_text" id="st_car_no" name="st_car_no" style="width:87%;" value="" onkeydown="kepEnter()"></td>
		      </tr>
		      <tr>
					<th>품명</th>
						<td><input type="text" class="input_type_text" id="st_description" name="st_description" style="width:87%;" value="" onkeydown="kepEnter()"></td>
					<th>규격</th>
						<td><input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:87%;" value="" onkeydown="kepEnter()"></td>
					<th>출고자</th>
						<td>
							<select id="st_add_user_id" name="st_add_user_id" ></select>
						</td>
		      </tr>
		    </tbody>
		  </table>
            </div>
            
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
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
               <span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doPop('upload');">출고업로드</a></span>
  				</span>
  				
  	          	<span class="fr">
  	          		<span class="btn_05 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
</html>
