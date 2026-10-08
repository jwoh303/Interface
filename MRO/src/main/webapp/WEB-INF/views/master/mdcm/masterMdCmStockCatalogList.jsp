<%--
**********************************************
* 메뉴 : 상품관리>협력사카탈로그 조회
* 화면 : 협력사카탈로그 조회
* 기능 : 협력사카탈로그 조회
* 프로그램 ID : PG_03_M_004_00
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-25
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Left",	Width:150,	Edit:false,	EditLen:300,	Type:"Text",	Header:"협력사",	 SaveName:"AGENT_NAME"}
					 ,{ Align:"Left",	Width:150,	Edit:false,	EditLen:300,	Type:"Text",	Header:"고객사",	 SaveName:"BUYER_NAME"}
					 ,{ Align:"Left",	Width:105,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목코드", SaveName:"BUYER_ITEM_NO"}
					 ,{ Align:"Left",	Width:236,	Edit:false,	EditLen:400,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					 ,{ Align:"Left",	Width:236,	Edit:false,	EditLen:300,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					 ,{ Align:"Left",	Width:57,	Edit:false,	EditLen:300,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					 ,{ Align:"Right",	Width:86,	Edit:false,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매출단가",	SaveName:"UNIT_PRICE"}
					 ,{ Align:"Right",	Width:86,	Edit:false,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매입단가",	SaveName:"LIST_PRICE"}
					 ,{ Align:"Left",	Width:80,	Edit:false,	EditLen:200,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
					 ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:300,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BUYER"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"CONTRACT_NO"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"AGENT_CODE"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "UNIT_PRICE");
	setLinkCol(mySheet, "LIST_PRICE");
}
	

// 기능함수
function doAction(str) {
	
	var agent = TrimCommon($("#st_agent_code").val());

	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		
        if(agent == "")
        {
            alert("협력사를 선택해 주십시요.");
            return;
        }

        var from_date = TrimCommon($("#st_from_date").val());
        var to_date = TrimCommon($("#st_to_date").val());

		if(from_date != "" || to_date != ""){
			if(from_date != "" && to_date == ""){
				$("#st_to_date").val(from_date);
			}

			if(from_date == "" && to_date != ""){
				alert("조회를 원하시는 시작일을 입력하여 주시기 바랍니다.");
				return;
			}
		}
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmStockCatalogList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_agent_code").val("");
		$("#st_from_date").val("");
		$("#st_to_date").val("");
		$("#st_status").val("N");
		$("#st_date").val("RE");
		mySheet.RemoveAll();
		break;

	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	pagingMode = "P";
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmStockCatalogList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "agent_single": // 협력사 M
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'UNIT_PRICE' || column == 'LIST_PRICE') { // 매출,매입단가 선택
		var buyer = mySheet.GetCellValue(Row,"BUYER");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		
		openSearchPopup("/mdcm/showMasterMdCmUnitpriceAlterHistoryPop.do", '?st_buyer='+buyer+'&st_contract_no='+contractNo+'&st_contract_seq='+contractSeq, "840,250,no");
		
	} else if(column == 'BUYER_ITEM_NO'){ // 품목코드 선택
		var catalog_com_code = mySheet.GetCellValue(Row,"BUYER");
		var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		
		openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do", '?st_buyer_code='+catalog_com_code+'&st_catalog_com_code='+catalog_com_code+'&st_buyer_item_no='+buyer_item_no, "988,768,no");
		
	}else if(column == 'AGENT_NAME'){ // 협력사 선택
		var agent = mySheet.GetCellValue(Row,"AGENT_CODE");
		openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", '?com_code='+agent, "800,600,no");
	}else if(column == 'BUYER_NAME'){ // 고객사 선택
		var buyer = mySheet.GetCellValue(Row,"BUYER");
		openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", '?com_code='+buyer, "800,600,no");
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "agent_single") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);

	}
	grbRow="";	//초기화
}


	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사카탈로그 조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>협력사카탈로그 조회</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
                        <col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th><font color="red"><b>*</b></font>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:55%" onclick="doPop('agent_single');" readonly>
								<input type="hidden" name="st_agent_code" id="st_agent_code">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>상태</th>
							<td>
								<select id="st_status" name="st_status">
									<option value = "ALL" >전체</option>
									<option value = "N"  selected>승인</option>
									<option value = "Y">미승인/단종</option>
									<option value = "D">삭제</option>
					            </select>
				            </td>
							<th>
								<select  class="TitSelect"  id="st_date" name="st_date">
									<option value= "RE" selected>등록일</option>
									<option value = "CH">변경일</option>
								</select>
							</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:63px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								~
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:63px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
							</td>
						</tr>
						<tr>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%"  value="" onkeydown="kepEnter()">
							</td>
							<td>품목명</td>
							<td>
								<input type="text" class="input_type_text"  name="st_description" id="st_description" style="width:87%"  value="" onKeyDown="kepEnter()">
							</td>
							<td>규격</td>
							<td>
								<input type="text" class="input_type_text"  name="st_specification" id="st_specification" style="width:87%"  value="" onKeyDown="kepEnter()">
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
			</div>

<!--내용 종료-->	                 

</body>
</html>
