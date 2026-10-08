<%--
**********************************************
* 메뉴 : 출고>TR 출고실적
* 화면 : TR 출고실적
* 기능 : TR 출고실적 및  출고실적리스트 출력
* 프로그램 ID : PG_08_M_017_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.HashMap"%> 
<%@ page import="java.util.Map"%>
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
					 { Align:"Left",	Width:210,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",		SaveName:"BUYER_NAME"}
					,{ Align:"Left",	Width:210,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",		SaveName:"AGENT_NAME"}
					,{ Align:"Right",	Width:210,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int", 	Header:"총 품목수",		SaveName:"CNT"}
					,{ Align:"Right",	Width:210,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int", 	Header:"총 금액",		SaveName:"AMT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드", 	SaveName:"BUYER"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"물류센터코드",	SaveName:"WAREHOUSE_CODE"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");	
	setLinkCol(mySheet, "AGENT_NAME");	
	
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
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");



	switch (str) {
	case "search":	 // 조회
						if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
							return;
						}
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
			return ;
		} 
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmgi/getMasterWmGiTrReleaseRecordList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.RemoveAll();
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

	case "save": // 저장
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmgi/saveMasterWmGiTrReleaseRecordList.do" , "SELECTED" );
		break;
		
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"TR출고실적.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmgi/excelMasterWmGiTrReleaseRecordList.do", param);
		$("#pageflag").val('1');
		break;
		
	case "print":
		
		var url ="/coco/showReportViewer.do";
		var temp ="WHERE WIDT.DELIVERY_DATE BETWEEN '";
		var from_dt = $("#st_from_date").val().replace(/[/]/gi,"");
	    var to_dt =   $("#st_to_date").val().replace(/[/]/gi,"");
	    
		temp = temp+from_dt+"'AND   '"+to_dt+"'  AND WIDT.WAREHOUSE_CODE ='"+document.searchCondition.st_warehouse_code.value+"'";
		var st_buyer_spl = $("#st_buyer_code").val().split("@@");

		var buyer_arr = "";
		for(var i = 0 ; i<st_buyer_spl.length ; i++ ){
			
			if(i==0){
				buyer_arr = buyer_arr+" '"+ st_buyer_spl[i]+"' ";
			}else{
				buyer_arr = buyer_arr+", '"+ st_buyer_spl[i]+"' ";
			}
			
		}
		if($("#st_buyer_code").val()  !="" ){
			
			temp = temp+"AND WIDT.BUYER IN ( "+ buyer_arr+ " )";
		}
		
		temp = temp+"AND WIDT.STATUS <> 'D' " + "GROUP BY WIDT.WAREHOUSE_CODE,WIDT.BUYER,WIDT.AGENT  ";
		if(document.searchCondition.st_order_by.value == "1"){
			temp = temp+"  ORDER BY 7,1,2";
		}
		else if(document.searchCondition.st_order_by.value == "2"){
			temp = temp+"  ORDER BY 7,2,1 ";
		}
		var st_enc_param = "?fileName=RD_08_M_004_00&param=["+from_dt+"]["+to_dt+"]["+temp+"]";
		st_enc_param = encodeURI(st_enc_param);
		window.open(url +""+st_enc_param, "setWmsTrStList", "width=770,height=800,resizable=YES,top=0,left=0");		
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
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiTrReleaseRecordList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyer_single": // 고객사 M
	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_from_date = document.searchCondition.st_from_date.value;
	    var st_to_date = document.searchCondition.st_to_date.value;
	    var st_date_flag = "RD";
	    openSearchPopup('/wmco/showMasterWmCoMbrcmpyPop.do','?st_warehouse_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date+'&st_date_flag='+st_date_flag, "500,500,no"); 
        popupSel = "buyer_single";
        break;	
	case "buyer_s": // 고객사 M
		//var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>";	
		//openSearchPopup("/wmdl/showMasterDlCommpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
		
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
        popupSel = "buyer_s";
        break;	       
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == 'BUYER_NAME')
	{
		if(mySheet.GetCellValue(Row,'BUYER_NAME')!=""){
		//	alert( mySheet.GetCellValue(Row,'BUYER'));
			 var com_code = mySheet.GetCellValue(Row,'BUYER');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else  if(column=="AGENT_NAME" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	if (popupSel == "buyer_s") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>TR 출고실적</h3>
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
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			
            	<table  class="cont_t_list01" style="width:940px;">
					<caption>TR 출고실적</caption>
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
							<th>배송확정일</th>
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
							<td > 
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
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyer_s');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
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
           	<span class="fr">      
           	<select name="st_order_by">
        <option value = "1">고객사순</option>
        <option value = "2">협력사순</option>
      </select>
			</span>			
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c;height:320px;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "320px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
               <span class="fl">
               <!-- 
                 					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
                -->
               </span>
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('print');">출력</a></span>

  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
