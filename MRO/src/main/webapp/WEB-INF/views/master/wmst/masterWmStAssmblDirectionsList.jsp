<%--
**********************************************
* 메뉴 : 재고>조립상품관리>조립지시서
* 화면 : 조립지시서
* 기능 : 조립지시서를 조회함.
* 프로그램 ID : PG_08_M_016_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-4
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.HashMap"%> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%

	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); // 조회조건
	String whAdmin = _sessionInfo.getWhAdmin();
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"조립서번호", SaveName:"AS_NO"} /* <a href="javascript:popWmsStckAssemblyWorkList('rowData.get("obj[2]")%>');">rowData.get("obj[2]")%></a>*/
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태", SaveName:"STATUS"} /* rowData.get("obj[10]")%>*/
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"작업구분", SaveName:"작업구분"} /* rowData.get("obj[11]")%>*/
					
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드", SaveName:"BOM_ID"} /* rowData.get("obj[3]")%>*/
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명", SaveName:"DESCRIPTION_LOC"} /* rowData.get("obj[4]")%>*/
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격", SaveName:"SPECIFICATION"} /* rowData.get("obj[12]")%>*/
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위", SaveName:"UNIT_MEASURE"} /* rowData.get("obj[5]")%>*/
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사", SaveName:"MAKER_NAME"} /* rowData.get("obj[13]")%>*/
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",	Header:"총수량", SaveName:"TOT_QTY"} /* WisehubString.WiseNumberType(rowData.get("obj[6]"),true,0,3)%> */
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",Header:"조립수량", SaveName:"BOM_QTY"} /* WisehubString.WiseNumberType(rowData.get("obj[14]"),true,0,3)%> */
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",	Header:"할당수량", SaveName:"ALLOC_QTY"} /* WisehubString.WiseNumberType(rowData.get("obj[7]"),true,0,3)%> */
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",Header:"가용수량", SaveName:"AVAIL_QTY"} /* WisehubString.WiseNumberType(rowData.get("obj[15]"),true,0,3)%> */
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"조립지시자", SaveName:"USER_NAME_LOC"} /* rowData.get("obj[8]")%>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",  Format:"Ymd",Header:"조립지시일자", SaveName:"ADD_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("obj[9]"))%>*/






					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"조립자", SaveName:"ASSEMB_USER_NAME"} /* rowData.get("obj[16]")%>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",  Format:"Ymd",	Header:"조립일자", SaveName:"ASSEMB_DATE"} /* CommonUtil.formatStrinigDate(rowData.get("obj[17]"))%>*/
				
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "AS_NO"); 
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {


	switch (str) {
	case "search":	 // 조회
		kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val());
		if(kepGetDateDiff("st_to_date" ,"st_from_date" ,'D' ) > 93 ){
			alert('조회는 3개월 이내만 가능 합니다.');
			return ;
		} 
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmst/getMasterWmStAssmblDirectionsList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		kepReload('searchCondition');
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	
// 트랜젝션(저장,삽입등) 후처리
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblDirectionsList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": 
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'AS_NO') { // 요청자
		var st_as_no = mySheet.GetCellValue(Row,"AS_NO");
		openSearchPopup('/wmst/showMasterWmStAssmblNoPop.do','?st_as_no='+st_as_no,'820,450,no');
		
	} 
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅

	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>조립지시서</h3>
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
					<caption>조립지시서</caption>
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
							<th>조립지시일자</th>
							<td  colspan="3">
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
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:95%;height:20px" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
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
					</tbody>
				</table>
				
									
            	<table  class="cont_t_list01" style="width:940px">
					<caption>조립지시서</caption>
					<colgroup>
							<col width="8%" />
							<col width="17%" />
                            <col width="12%" />
							<col width="17%" />
                            <col width="6%" />
							<col width="17%" />
                            <col width="6%" />
							<col width="17%" />
					</colgroup>
						
					<tbody>
						<tr>					
							<th  >표준코드</th>
							<td  align="center"><input type="text" name="st_item_no"  id="st_item_no" value="" style="width:86%"></td>
							<th>조립지시서번호</th>
							<td><input type="text" name="st_as_no"  id= "st_as_no" value="" style="width:86%"></td>
							<th>품목명</th>
							<td><input type="text" name="st_desc"  id="st_desc"  value="" style="width:86%"></td>
							<th>규격</th>
							<td><input type="text" name="st_spec"  id="st_spec" value="" style="width:86%"></td>
						</tr>
					</tbody>
				</table>
            </div>
            

			<span class="fl">
			<label for="b_no02" >작업구분</label>&nbsp;<select name="st_work_type">
				<option value="">전체</option>
				<option value="ASS">조립</option>
				<option value="DEA">분해</option>
			</select>
			&nbsp;
			<label for="b_no02" >상태</label>&nbsp;
			<select name="st_assemb_flag">
				<option value="">전체</option>
				<option value="N">조립지시</option>
				<option value="Y">조립완료</option>
			</select>&nbsp;		
			</span>
			<span class="fr">	
           	<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
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

<!--내용 종료-->	                 

</body>
</html>
