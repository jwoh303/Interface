<%--
**********************************************
* 메뉴 : 출고예정
* 화면 : 출고예정
* 기능 : 
* 담당자 : 최철규
* 착수일 : 2018-04-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Left",	Width:40,		Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",				Header:"상태값",				SaveName:"STATUS",			}
		,{ Align:"Left",	Width:40,		Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",				Header:"고객사코드",				SaveName:"BUYER",			}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"상태",				SaveName:"STATUS_TEXT",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"출고요청번호",				SaveName:"RS_NO",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"출고요청항번",				SaveName:"RS_SEQ",			}
		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",				Header:"출고차수",				SaveName:"RS_REVISION",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"IF발주번호",				SaveName:"LEGACY_PO_NO",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"출고번호",				SaveName:"GI_NO",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"출고항번",				SaveName:"GI_SEQ",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"배송지",				SaveName:"DELY_TO_LOCATION_NAME",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"배송지코드",				SaveName:"DELY_TO_LOCATION",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"품목코드",				SaveName:"BUYER_ITEM_NO",			}
		,{ Align:"Left",	Width:150,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"품명",				SaveName:"DESCRIPTION",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"규격",				SaveName:"SPECIFICATION",			}
		,{ Align:"Left",	Width:50,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"단위",				SaveName:"UNIT_MEASURE",			}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"요청자",				SaveName:"REQ_USER_NAME",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",				Header:"요청자ID",				SaveName:"ADD_USER_ID",			}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"재고수량",				SaveName:"ST_QTY",			}
		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"출고요청수량",				SaveName:"RS_QTY",			}
		,{ Align:"Left",	Width:70,		Edit:false,	EditLen:20,	Hidden:true,	Type:"Text",				Header:"출고수량",				SaveName:"GI_QTY",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"비고",				SaveName:"REMARK",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"기존WBS",				SaveName:"OLD_WBS_NO",			}
		,{ Align:"Left",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"변경WBS",				SaveName:"NEW_WBS_NO",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:true,	Type:"Date",				Header:"요청일자",				SaveName:"RS_DATE",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Date",				Header:"출고일자",				SaveName:"GI_DATE",			}
		,{ Align:"Center",	Width:100,		Edit:false,	EditLen:20,	Hidden:false,	Type:"Date",				Header:"확정일자",				SaveName:"DI_DATE",			}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M") );
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
	
	// 하이퍼링크 설정
	setLinkCol(mySheet, "GI_NO");
	
	kepAjaxCommonQueryIdSearchTwoCombo("st_dely_location","getDataICOMCOD2","${sessionInfo.comCode}","C030","ALL","");
	kepAjaxCommonQueryIdSearchCombo("st_req_user","buyerUserList","${sessionInfo.comCode}","ALL","");
}
	
var st;
var mt;

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str != "search" && str != "reload" && str != "add" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			
			var st_status = document.searchCondition.st_status.value;
			
			var obj1	= document.getElementById("btnChulgo");
			var obj2	= document.getElementById("btnChulgoCancel");
			var obj3	= document.getElementById("btnDecide");
		
			//alert(obj.style.visibility);
			
			if (st_status == "1") {						//출고
				obj1.style.display = "inline-block";
				obj2.style.display = "none";
				obj3.style.display = "none";
			} else if (st_status == "2") {				//출고예정
				obj1.style.display = "none";
				obj2.style.display = "inline-block";
				obj3.style.display = "inline-block";
			} else {									//배송완료
				obj1.style.display = "none";
				obj2.style.display = "none";
				obj3.style.display = "none";
			}
			
			
			if ( !searchValidate() )
				return;
			current_page = -1;
			
			kepSearch(document.searchCondition,  mySheet , "/mpst/getBuyerMpStGiReleaseDirectionsList.do" , pagingMode );
			break;
			
		case "chulgo":
			if ( !confirm('선택한 항목을 출고처리 하시겠습니까?') )
				return;
			var arrRow = selectedGrid.split("|");
			var firstDest = mySheet.GetCellValue(arrRow[0],"DELY_TO_LOCATION");
			
			if( mySheet.GetCellValue(arrRow[0],"DELY_TO_LOCATION_NAME") == "" || mySheet.GetCellValue(arrRow[0],"DELY_TO_LOCATION") == null){
				alert("배송처가 등록되지 않았습니다. 배송처코드 확인이 필요합니다.");
				return;
			}
			
			for (var i=0; i<arrRow.length; i++){
				var STATUS    = mySheet.GetCellValue(arrRow[i],"STATUS");
				var otherDest = mySheet.GetCellValue(arrRow[i],"DELY_TO_LOCATION");
				
				if(firstDest != otherDest){
					alert("배송처가 다른 건은 같이 출고할 수 없습니다.");
					return;
				}
				
				if(STATUS == "2" || STATUS == "3"){
					alert("이미 출고된 품목이 있습니다.");
					return;
				}
			}
			kepSave(document.searchCondition ,  mySheet , "/mpst/updateBuyerMpStGi.do" , "SELECTED" );
			
			break;
		case "chulgoCancel":
			
			if ( !confirm('선택한 항목을 출고취소 하시겠습니까?') )
				return;
			
			var arrRow = selectedGrid.split("|");
			var check_gi_no = mySheet.GetCellValue(arrRow[0],"GI_NO");
			
			for (var i=0; i<arrRow.length; i++){
				var STATUS    = mySheet.GetCellValue(arrRow[i],"STATUS");
				if(STATUS == "1"){
					alert("출고처리 되지않은 품목이 있습니다.");
					return;
				}else if(STATUS == "3") {
					alert("확정 처리 된 품목이 있습니다.");
					return;
				}
				
				var gi_no    = mySheet.GetCellValue(arrRow[i],"GI_NO");
				if(check_gi_no != gi_no){
					alert("하나의 출고번호만 선택하여 주십시오");
					return;
				}
			}
			
			current_page = -1;
			kepSave(document.searchCondition ,  mySheet , "/mpst/updateBuyerMpStGiCancel.do" , "SELECTED" );
			
			break;
			
		case "reload": // 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		
		case "decide":
			if ( !confirm('선택한 항목을 확정 하시겠습니까?') )
				return;
			
			var arrRow = selectedGrid.split("|");
			var check_gi_no = mySheet.GetCellValue(arrRow[0],"GI_NO");
			
			for (var i=0; i<arrRow.length; i++){
				var gi_no    = mySheet.GetCellValue(arrRow[i],"GI_NO");
				
				if(gi_no == "" ){
					alert("출고처리 되지않은 건은 확정할 수 없습니다.");
					return;
				}
				if(check_gi_no != gi_no){
					alert("하나의 출고번호만 선택하여 주십시오");
					return;
				}
			}
			current_page = -1;
			kepSave(document.searchCondition ,  mySheet , "/mpst/updateBuyerMpStGiComplete.do" , "SELECTED" );
			
			break;	
			
		case "decideCancel":
			
			break;
	}
}
	
// 조회조건 체크
function searchValidate() {
	var rtn = true;
	
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
		//조회기간을 3개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG95")%>");
		rtn = false;
	}
	return rtn;
}
	
// 조회 후처리
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

function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
//    if(column=='GI_QTY'){
//    	var dupIdx = mySheet.ColValueDup("CODE");
//    	if(dupIdx > -1){
//        	alert("입력하신 코드는 이미 존재합니다.");
//        	mySheet.SetCellValue(dupIdx,"GI_QTY",'');return;
//    	}
//    }
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getBuyerMpStGiReleaseDirectionsList.do?page="+current_page , pagingMode );
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	var colVal = mySheet.GetCellValue(Row, Col);
	
	if(isEmpty(colVal)){
		return;				
	}
	
	if(column == "GI_NO"){
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_gi_no = mySheet.GetCellValue(Row, "GI_NO");
		var st_gi_seq = mySheet.GetCellValue(Row, "GI_SEQ");
		
		var param = "["+st_buyer+"]["+st_gi_no+"]";
		
		reportOpen("RD_06_S_001_136",param);
	}
	
	return;
}

// 팝업함수호출
function doPop(str) {

}
	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {

}

</script>
</head>
<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerLeft"/>
	<c:param name="part" value="${param.upperId}"/>
</c:import>
<div id="container2">
<!-- 메뉴 E -->

<!--내용 시작-->
	<div id="ContArea" style="width: 97%;">


		<h3>출고예정</h3>
    	<div id="searchBtnA">
 
			<!--버튼영역-->
	        <span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
			<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	   	</div>        	
    
	    <!--조회영역-->
		<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
					
				<table  class="cont_t_list01" style="width:100%;">
					<caption>도착지코드관리</caption>

					<colgroup>
						<col width="5%" />
						<col width="20%" />
						<col width="5%" />
						<col width="10%" />
						<col width="5%" />
						<col width="20%" />
						<col width="*" />
					</colgroup>
								
					<tbody>
						<tr> 
							<td>
							   등록일
							</td>
							<td>
								<input type="text" name="st_from_date" style="width: 20%; text-align: center;" id="st_from_date" class="input_type_text"  value="" readonly>
					          	&nbsp;~&nbsp;
								<input type="text" name="st_to_date" style="width: 20%; text-align: center;" id="st_to_date" class="input_type_text"  value="" readonly>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>					
							</td>
							<td>요청자</td>
							<td>
								<select id="st_req_user" name="st_req_user" style="width:60%;" ></select>
							</td> 
						</tr>
						<tr> 
							<td>출고요청번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_rs_no" name="st_rs_no" style="width:50%;" value="" onkeydown="kepEnter()">
							</td>
							<td>직납처</td>
							<td>
								<select id="st_dely_location" name="st_dely_location" style="width:60%;" ></select>
							</td>
							<td>상태</td>
							<td>
								<select id="st_status" name="st_status" style="width: 100px;" >
									<option value="1" selected>출고예정</option>
									<option value="2">출고</option>
									<option value="3">배송완료</option>
								</select>
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
			</span>
	  				
			<span class="fr">
				<span class="btn_02" id="btnChulgo" name="btnChulgo" style="display:none";><a href="javascript:doAction('chulgo');">출고</a></span>
				<span class="btn_02" id="btnChulgoCancel" name="btnChulgoCancel" style="display:none";><a href="javascript:doAction('chulgoCancel');">출고취소</a></span>
				<span class="btn_02" id="btnDecide" name="btnDecide" style="display:none";><a href="javascript:doAction('decide');">확정</a></span>
			</span>
		</div>
<!--내용 종료-->
	                 
	</div>
</div>


<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>

</body>
</html>
