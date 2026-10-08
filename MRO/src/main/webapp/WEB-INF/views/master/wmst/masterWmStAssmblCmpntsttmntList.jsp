<%--
**********************************************
* 메뉴 : 재고>조립상품관리>조립부품서
* 화면 : 조립부품서
* 기능 : 조립부품서 조회 화면
* 프로그램 ID : PG_08_M_015_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-3
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.HashMap"%> 
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
						,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드", SaveName:"BOM_ID"} /* <input name="st_isCheck" type="checkbox" value="i-1%>">*/
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명", SaveName:"DESCRIPTION_LOC"} /* <a href="javascript:popWmsStckAssemblyBomList(i-1%>);">rowData.get("obj[2]")%></a>*/
						,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격", SaveName:"SPECIFICATION"} /* rowData.get("obj[3]")%>*/
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"Integer", 	Header:"부품수량", SaveName:"SUB_CNT"} /* rowData.get("obj[4]")%>*/
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"Integer", Header:"총재고", SaveName:"TOT_QTY"} /* rowData.get("obj[5]")%> */
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"Integer", Header:"할당재고", SaveName:"ALLOC_QTY"} /* rowData.get("obj[6]")%> */
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"Integer", Header:"가용재고", SaveName:"AVAIL_QTY"} /* rowData.get("obj[7]")%>*/
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"Integer", Header:"재고원가", SaveName:"STC_SELLER_PRICE"} /* rowData.get("obj[8]")%>*/
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"최종실행일", SaveName:"LAST_WORK_DATE"} /* rowData.get("obj[9]")%>*/
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사", SaveName:"MAKER_NAME"} /* rowData.get("obj[9]")%>*/
		];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BOM_ID");	
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "ATOB_REMARK_IMG");
	setLinkCol(mySheet, "ATOS_REMARK_IMG");
	setLinkCol(mySheet, "REJECT_REMARK_IMG");
	setLinkCol(mySheet, "CANCEL_REMARK_IMG");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblCmpntsttmntList.do?page="+current_page , pagingMode );
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");


	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/wmst/getMasterWmStAssmblCmpntsttmntList.do" , pagingMode );
		break;

		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

		case "save": // 저장
			if(selectedGrid.length == 0){
				alert("조립 부품서를 선택 하세요");
				return;
			}
			var BOM_ID_list = "";
			for(var i = 0 ; i <arrRow.length; i++){
				
				BOM_ID_list  += mySheet.GetCellValue(arrRow[i], 'BOM_ID')+"@@";
				
			}	

			openSearchPopup('/wmst/showMasterWmStAssmblDirectionsCreationPop.do','?st_sel_item_no='+BOM_ID_list+'&st_warehouse_code='+document.searchCondition.st_warehouse_code.value,'950,570,no'); 
			popupSel = "masterMdCpCompyDetailViewPop";
		break;

	
	case "save_bom": // 저장
		openSearchPopup('/wmst/showMasterWmStAssmblCmpntsttmntCreationPop.do','?st_warehouse_code='+document.searchCondition.st_warehouse_code.value,'850,600,no'); 
		popupSel = "masterMdCpCompyDetailViewPop";
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


// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BOM_ID') { 
		
		if(mySheet.GetCellValue(Row,'BOM_ID') != ""){
			
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			
	 	 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		
				mySheet.SetCellValue(arrRow[i], 'SELECTED', 0);
				
	 	 	}
	 	 	if(1==mySheet.GetHeaderCheck(0, 'SELECTED')){
	 	 		mySheet.SetHeaderCheck(0, 'SELECTED',0);
	 	 	}
	 	 	mySheet.SetCellValue(Row, 'SELECTED', 1);
	 	 	
	 	 	
	 	 	openSearchPopup('/wmst/showMasterWmStAssmblDirectionsCreationPop.do','?st_sel_item_no='+mySheet.GetCellValue(Row, 'BOM_ID')+'&st_warehouse_code='+document.searchCondition.st_warehouse_code.value,'950,570,no'); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
		
		
	} 
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	
	} 
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>조립부품서</h3>
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
					<caption>조립부품서</caption>
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
						<th>표준코드</th>
						<td ><input type="text" name="st_item_no" style="width:80%" value="" onKeyUp="" onkeydown="kepEnter()"></td>
						<td  >재고유무</td>
						<td style="width:80%">
							<input name="st_qty_flag" type="radio" value="ALL" checked /> 전체 
							<input name="st_qty_flag" type="radio" value="Y"/> 재고유 	
							<input name="st_qty_flag" type="radio" value="N"/> 재고무
						</td>
					</tr>
					
					<tr>
					    <th>품목명</th>
						<td><input type="text" name="st_desc" id="st_desc" style="width:80%" value="" onKeyUp="" onkeydown="kepEnter()"></td>
						<th   >규격</th>
						<td><input type="text" name="st_spec"  id="st_spec" style="width:80%" value="" onKeyUp="" onkeydown="kepEnter()"></td>
						<th   >제조사</th>
						<td><input type="text" name="st_maker_name"  id = "st_maker_name"  style="width:80%" value="" onKeyUp="" onkeydown="kepEnter()"></td>
						<th></th>
						<td></td>
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
  				
  				<span class="fr">
  					<span class="btn_07 mr04"><a href="javascript:doAction('save');">조립지시서생성</a></span>
  					<span class="btn_07 mr04"><a href="javascript:doAction('save_bom');">조립부품서 생성</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
