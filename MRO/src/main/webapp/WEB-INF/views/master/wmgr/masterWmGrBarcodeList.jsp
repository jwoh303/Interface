<%--
**********************************************
* 메뉴 : 입고>입고등록>바코드입출고리스트
* 화면 : 바코드입출고리스트
* 기능 : 바코드입출고리스트
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
	String whAdmin = _sessionInfo.getWhAdmin();
%> 
<script src="/resources/js/common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var CarOn = "/resources/images/btn_search03.gif";
var LocationOn = "/resources/images/btn_search03.gif";

var unit = KepSheetComboQueryIdData("getUnitMeasureInfo","");
var grbRow = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){
	var initsheet = {};
	initsheet.Cols = [ 
		                 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO",	SaveName:"LEGACY_PO_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호",	SaveName:"INV_NO"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"납품요청일",	SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"바코드처리일",	SaveName:"CREATE_DATE"}
							,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"바코드구분",	SaveName:"GBN"}
							,{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : false,	Type:"Text", Header:"상태",	SaveName:"STATUS"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"에러메세지",	SaveName:"ERROR_MSG"}
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int", Format:"Integer", 	Header:"총 품목건수",	SaveName:"PO_CNT"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"Integer",  Header:"총 금액", 	SaveName:"ITEM_AMT"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"ADD_USER_NAME"}
							,{ Align:"Left",	Width:600,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"도착지정보",	SaveName:"DELY_TO_LOCATION"}
							

	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);


	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("in_ivk_date");
	
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#in_ivk_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
}
	

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();

	switch (str) {
	case "search":	 // 조회
		current_page = -1;

		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return ;
		}		
		kepSearch(document.searchCondition,  mySheet , "/wmgr/getMasterWmGrBarcodeList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#in_ivk_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		
		
		break;

	
	case "excelDown": // 엑셀다운로드
		$("#pageflag").val("0");
		var param = {FileName:"바코드입출고리스트.xlsx",
			DownCols:"BUYER_NAME|AGENT_NAME|PO_NO|LEGACY_PO_NO|INV_NO|PO_CREATE_DATE|RD_DATE|CREATE_DATE|BUYER|GBN|STATUS|ERROR_MSG|PO_CNT|ADD_USER_NAME"};
	    kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelMasterWmGrBarcodeList.do", param);
	    $("#pageflag").val('1');
		break;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

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
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}

}
	



// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrBarcodeList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_multi": // 고객사 M
	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_from_date = document.searchCondition.st_from_date.value;
	    var st_to_date = document.searchCondition.st_to_date.value;
	    openSearchPopup('/wmco/showMasterWmCoMbrcmpyCountPop.do','?ware_house_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "500,500,no"); 
        popupSel = "buyer_multi";
        break;
		
		case "buyer_multi_b": // 고객사 M
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no');
	        popupSel = "buyer_multi_b";
		break;
		case "agent_multi": // 협력사 M
			openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
			popupSel = "agent_multi";
			break;	
	
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
			
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅

	 if (popupSel == "buyer_multi") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}else if(popupSel == "buyer_multi_b") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	}else if(popupSel == "agent_multi"){
		
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}
	grbRow="";	//초기화
}



function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>바코드 입출고조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<input type="hidden" name="st_ivk_list" id="st_ivk_list">
			<input type="hidden" name="st_ivk_date" id="st_ivk_date">
			<input type="hidden" name="st_ivk_yn" id="st_ivk_yn">
			<input type="hidden" name="st_sys_type"		id="st_sys_type"	 value ="WMS_GR_IK">
			<input type="hidden" id="pageflag" name="pageflag" value="1">			
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
            	<table  class="cont_t_list01" >
					<caption>바코드 입출고조회</caption>
					<colgroup>
							<col width="8%" />
							<col width="25%" />
							<col width="8%" />
							<col width="25%" />
							<col width="11%" />
							<col width="22%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>바코드처리일</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>							
							<th>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:80%;height:20px" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,st_warehouse_code) %>
								</select>
							</td>
							</tr>
							<tr>
							<th>고객사</th>
							<td>
							    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:70%;" value=""  readonly onclick="javascript:doPop('buyer_multi_b');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
 
							<th>발주번호</th>
							<td>
								<input type="text" class="al" name="st_po_no" id="st_po_no" style="width:78%" value=""  onchange="fnCheckInputByte(this, 20);" onKeyUp="kepToUpper('st_po_no')" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
								
							</td>
							<th>바코드구분</th>
							<td>
								<select id="st_doc_type" name="st_doc_type" style="width:80%;height:20px">
									<option value="">전체</option>
              						<option value="I">입고</option>
             	 					<option value="C">출고</option>
             	 					<option value="X">입출고</option>
              					</select>
							</td>
							</tr>	
																			
						<tr> 
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" id="st_agent_name" name="st_buyer_item_no" readonly style="width:70%;" value="" onclick="javascript:doPop('agent_multi');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value=""  style="width:80%" value="">
								<a href="javascript:doPop('agent_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>

							<th>처리상태</th>
							<td>
								<select id="st_status_check" name="st_status_check" style="width:80%;height:20px">
									 <option value="">전 체</option>
              						 <option value="Y">처리</option>
              						<option  value="E">오류</option>
								</select>
							</td>
							<th>입고번호</th>
							<td>
								<input type="text" class="al" name="st_inv_no" id="st_inv_no" style="width:78%" value=""  onchange="fnCheckInputByte(this, 20);" onKeyUp="kepToUpper('st_inv_no')" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
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
					<option value="200">200건</option>
				</select>
			</span>			           
			<br>
		</form>
	            			
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			<p class="paging" id="pageindex"></p>
  			</div>
  			
  			<!--버튼영역-->
  			<br/>
               <div class="btnArea">
  	          	<span class="fl">
  	          	<!-- 
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				 -->
  				</span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
