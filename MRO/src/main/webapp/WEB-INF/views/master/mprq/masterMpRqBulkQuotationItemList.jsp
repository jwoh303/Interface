<%--
**********************************************
* 메뉴 : 견적관리>벌크소싱 품목 관리
* 화면 : 벌크소싱 품목 관리
* 기능 : 벌크소싱 품목 관리 화면
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2025-06-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String st_user_dept = _sessionInfo.getDepartment();
	String st_user_id = _sessionInfo.getUserId();
%>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:44,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"|",	SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"프로젝트코드|프로젝트코드",	SaveName:"BURQ_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"프로젝트명|프로젝트명",	SaveName:"PROJECT_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사코드|그룹사코드",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사명|그룹명",	SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"계약서 번호|계약서 번호",	SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"계약서 항번|계약서 항번",	SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 품목코드|고객사 품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG ID|SG ID",	SaveName:"SG_ID"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG명|SG명",	SaveName:"SG_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"SG담당자|SG담당자",	SaveName:"SM_USER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"일괄담당자|일괄담당자",	SaveName:"AGENT_MNG_USER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"키값|키값",	SaveName:"ITEM_KEY_ID"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사명|협력사명",	SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"거래유형|거래유형",	SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"배송유형|배송유형",	SaveName:"PARCEL_YN"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"TR|TR",	SaveName:"WAREHOUSE_CODE"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|품명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|모델명",	SaveName:"MAKER_PART_NO"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|제조사",	SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|최소주문수량",	SaveName:"MIN_ORDER_QTY"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|주문배수수량",	SaveName:"PUR_UNIT_QTY"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사 카탈로그 정보|단위",	SaveName:"UNIT_MEASURE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"추가 정보|발주 횟수",	SaveName:"PO_CNT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"추가 정보|수량",	SaveName:"ITEM_QTY"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"추가 정보|기존단가",	SaveName:"RE_LIST_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Left",	Width:115,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"추가 정보|메인사업장(납품처)",	SaveName:"MAIN_BUYER"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode,5);
	mySheet.SetCountPosition(3);
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
}
	
// 기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			var project = $("#st_burq_no").val();
			if(isEmpty(project)){
				alert("프로젝트를 선택하시기 바랍니다.");
				return;
			}	
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBulkQuotationItemList.do", pagingMode);
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_burq_no").val('');
			$("#st_c_sg_id").val('');
			mySheet.RemoveAll();
			break;

		case "excelDown": // 엑셀다운로드
			var project = $("#st_burq_no").val();
			if(isEmpty(project)){
				alert("프로젝트를 선택하시기 바랍니다.");
				return;
			}
		    $("#pageflag").val('0');
		    var param = {FileName:"벌크소싱품목관리_"+project+".xlsx",Merge:1,SheetDesign:1,DownCols:""};
			kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqBulkQuotationItemList.do", param);
			$("#pageflag").val('1');
			break;
		case "delBurqItem": // 선택 삭제
			var st_query = "";
			if (mySheet.RowCount() == 0){
				alert("조회된 데이터가 없습니다.");
				return;
			}
		
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var checkRows     = selectedGrid.split("|");
			
			if (checkRows.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			for(var i = 0 ; i < checkRows.length; i++){
				var checkItemKeyId = mySheet.GetCellValue(checkRows[i],"ITEM_KEY_ID");
				st_query+= checkItemKeyId+"@@";
			}
			
			$("#st_query").val(st_query);
			kepAjaxFormCall("/mprq/delMasterMpRqBulkQuotationItemList.do","searchCondition","delBurqItem");
			break;
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){  
	if (pMethod == "delBurqItem"){
		var msg = response.Msg;
		if (msg != "") {
			alert(msg);
		}else{
			alert("선택된 품목이 삭제되었습니다.");
			doAction('search');
		}
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response) { 
	var msg = response.Message;

	if (!isEmpty(msg)){	
		alert(msg);
	}
	return;
}

var mt;
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var totRow = mySheet.RowCount();
	if( totRow <= 0) return;
	for(var i=2; i < totRow+2;i++){
		if (isEmpty(mySheet.GetCellValue(i, "AGENT_MNG_USER_NAME"))){
			mySheet.SetCellBackColor(i,"AGENT_MNG_USER_NAME","#FFD966");
		}
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	if (msg != "") {
		alert(msg);
	}

}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqBulkQuotationItemList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str, value1) {
	popupSel=str;
	var burq_no = $("#st_burq_no").val();
	var project_name = $("#st_project_name").val();
	switch (str) {
		case "selProject":
			openSearchPopup('/mprq/showMasterMpRqBulkQuotationSelProjectPop.do','','630,450,no');
			break;
		case "selBuyer":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N&AUTH=ALL", "500,466,no");
			break;
		case "selSg":
			openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "550,530,no");
			break;	
		case "changeSg":
			openSearchPopup("/mprq/showMasterMpRqBulkQuotationSgChangePop.do","?st_burq_no="+burq_no+"&st_project_name="+project_name,"1190,795,no");
			break;
		case "regMng":
			openSearchPopup("/mprq/showMasterMpRqBulkQuotationMngRegPop.do","?st_burq_no="+burq_no+"&st_project_name="+project_name,"708,795,no");
			break;
		case "regItem":
			openSearchPopup("/mprq/showMasterMpRqBulkQuotationItemRegPop.do","?st_burq_no="+burq_no+"&st_project_name="+project_name+"&st_project_unit="+$("#st_project_unit").val(),"1390,785,no");
			break;
		case "selMaker":
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			break;
		case "selUser":
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=KRKORE0001", "500,500,no");
			break;
		case "changeProcess":  // 거래유형 변경
			openSearchPopup("/mprq/showMasterMpRqBulkQuotationProcessChangePop.do","?st_burq_no="+burq_no+"&st_project_name="+project_name,"1100,795,no");
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel=="selProject"){
		mySheet.RemoveAll();
		$("#st_burq_no").val(value1);
		$("#st_project_name").val(value2);
		$("#st_project_unit").val(value3);
<%-- 		console.log(value4+"::" +"<%=st_user_id%>" ); --%>
		if(value4 == "<%=st_user_id%>"){
			document.getElementById("sm_btn").style.display = "block"; // 보이게
// 			document.getElementsByName("sm_btn")[1].style.display = "block"; // 보이게
		}else{
// 			console.log(value4);
			document.getElementById("sm_btn").style.display = "none"; // 숨기기
// 			document.getElementsByName("sm_btn")[1].style.display = "none"; // 숨기기
		}
	} else if (popupSel == "selBuyer") {
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} else if(popupSel=="selSg"){
		$("#st_c_sg_id").val(value1);
		$("#st_c_sg_nm").val(value2);
	} else if (popupSel == "regItem"){
		$("#st_burq_no").val(value1);
		$("#st_project_name").val(value2);
		current_page=-1;
		kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBulkQuotationItemList.do", pagingMode);
	} else if (popupSel == "selMaker"){ // 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
	}  else if (popupSel == "selUser") {
		$("#st_agent_mng_user_id").val(value1);
		$("#st_agent_mng_user_name").val(value2);
		$("#input").prop("checked",true);
	} else if(popupSel == "regMng" || popupSel == "changeSg"){
		if(value1 == '1'){
			doAction('search');
		}
	}
}

function setAgentMng(){
	$("input[name='st_agent_mng_user']:input[value='INPUT']").prop('checked',true);
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>벌크소싱 품목 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
		<!--조회영역-->
       	<form name = "searchCondition" id = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<input type="hidden" id="st_query" name="st_query" value="">
	           	<table class="cont_t_list01" >
					<caption>벌크소싱 품목 관리</caption>
					<colgroup>
						<col width="12%" />
						<col width="24%" />
						<col width="8%" />
						<col width="21%" />
						<col width="8%" />
						<col width="27%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<th class="center"><font color="red">*</font> 프로젝트</th>
							<td>
								<input type="text" class="input_type_text" name="st_project_name" id="st_project_name" style="width:61%" readOnly value="" onclick="javascript:doPop('selProject');">
								<input type="hidden" name="st_burq_no" id="st_burq_no" value="">
								<input type="hidden" name="st_project_unit" id="st_project_unit" value="">
								<a href="javascript:doPop('selProject');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_burq_no','st_project_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th class="center">고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:87%" value="" onkeydown="kepEnter()">
							</td>
							<th class="center">SG</th>
							<td>
								<input type="text" class="input_type_text" id="st_c_sg_nm" name="st_c_sg_nm" style="width:55%;" readOnly value="" onclick="javascript:doPop('selSg');">
								<input type="hidden" name="st_c_sg_id" id="st_c_sg_id" style="width:80%" value="">
								<a href="javascript:doPop('selSg');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_c_sg_id','st_c_sg_nm');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr> 
							<th class="center">고객사 품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:82%;" onkeydown="kepEnter()" >
							</td>
							<th class="center">제조사</th>
							<td>
								<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:87%" value="">
								<input type="hidden" name="st_maker_code" id="st_maker_code" style="width:55%" value="">
							</td>
							<th class="center">일괄담당자</th>
							<td>
								<input type="hidden" name="st_agent_mng_type" id="st_agent_mng_type" value="">
								<input type="radio" name="st_agent_mng_user" id="all" value="ALL" checked="checked"/><label for="all">&nbsp;전체</label>
								&nbsp;
								<input type="radio" name="st_agent_mng_user" id="target" value="TARGET"/><label for="target">&nbsp;등록대상</label>
                    			&nbsp;
                    			<input type="radio" name="st_agent_mng_user" id="input" value="INPUT"/>&nbsp;
								<input type="text" id="st_agent_mng_user_name" name="st_agent_mng_user_name" class="input_type_text" style="width:17%" value="" onkeydown="kepEnter()" onInput="javascript:setAgentMng()" />
							</td>
						</tr>
						<tr>
							<th class="center">그룹사 카탈로그 코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_byit_comorg_code" name="st_byit_comorg_code" style="width:82%;" value="" onkeydown="kepEnter()">
							</td>
							<th class="center">키 값</th>
							<td colspan="3">
								<input type="text" class="input_type_text" id="st_item_key_id" name="st_item_key_id" style="width:87%;" value="" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
				</table>
            </div>
	        <div class="btnArea">
				<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	               	<label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow" style="width: 70px;" >
						<option value="10">10건</option>
						<option value="20">20건</option>
						<option value="30">30건</option>
						<option value="50">50건</option>
						<option value="100">100건</option>
						<option value="500" selected>500건</option>
					</select>
				</span>
			</div>
		</form>
  							
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px")
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
            <div class="btnArea" >
            	<span class="fl" id="sm_btn" style="display:none;">
					<span class="btn_10 mr04"><a href="javascript:doAction('excelDown');">조회결과 다운로드</a></span>
            		<span class="btn_04 mr04"><a href="javascript:doPop('changeSg');">SG 수정</a></span>
            		<span class="btn_06 mr04"><a href="javascript:doPop('regMng');">일괄 담당자 등록</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('delBurqItem');">선택  삭제</a></span>
            		<span class="btn_04 mr04"><a href="javascript:doPop('regItem');">품목 등록</a></span>
           		</span>
<!--             	<span class="fr" style="display:none;"> -->
<%-- <%--             	    <% if (st_user_dept.equals("138") || st_user_dept.equals("141") || st_user_dept.equals("095") ) { // 구매기획팀(138) 소속만 확인 가능, 141/095은 테스트 대비 %> --%> --%>
<%-- <%--             		<%} %>  -- 본인이 등록한 프로젝트에 대해서 가능하도록 수정 26.03.06--%> --%>
<!-- 				</span> -->
  			 </div>

<!--내용 종료-->	                 

</body>
</html>

