<%--
**********************************************
* 메뉴 : 
* 화면 : 주문정보 수정-수주접수전(협력사외)
* 기능 : 협력사의 수주접수전 발주정보를 변경하기 위한 팝업. 거래유형,협력사등을 변경할수 있다
* 프로그램 ID : PG_06_M_006_01
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-29
* 사용안함 사용안함 사용안함
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	Map<String,String> rowData = null;
	if (_gridList == null || _gridList.size() == 0){
	}else{ 
		rowData = _gridList.get(0);
	}
	 
	String cardUseCheck = (String) request.getAttribute("cardUseCheck"); // 조회된 결과  getPrCardUseCheck
	 
	
	String SessionComCode = "";
	String SessionUserName = "";
	String SessionUserId = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());  
		SessionUserName = CommonUtil.nvl((String)sessionInfo.getUserNameLoc()); 
		SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	}  
	
	String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");   
	String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");    
	String st_orderFlag = CommonUtil.nvl((String) request.getParameter("st_orderFlag"),"");    
	
	String beforeAfterTitle = "전";
	if ("after".equals(st_orderFlag)){
		beforeAfterTitle ="후";
	}
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var grbCol;
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var gridHeaderCount = 4;		


var db_buyer_adapt_flag		= "";		
var db_buyer_rate			= "";	
var db_buyer_standard_rate	= ""; 
var db_supply_direct_rate	= ""; 
var db_stock_rate			= ""; 
var db_tr_rate				= ""; 
var db_vmi_rate				= ""; 
var db_import_rate			= "";   

var org_process_type = "";
var saveFlag = "";

var header_C001_code = "";
var header_C002_code = "";
var header_C003_code = "";
var header_C004_code = "";
var header_C005_code = "";
var header_C006_code = "";
var header_C007_code = "";
var header_C008_code = "";
var header_C009_code = "";
var header_C0010_code = "";


//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0,ColMove : 1,ColResize : 1};
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 50,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 80,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 200,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 120,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "PO_CREATE_DATE",		Header : "발주일",	Type : "Date",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "RD_DATE",		Header : "납기요청일",	Type : "Date",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "발주수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "DS_DATE",		Header : "납품예정일",	Type : "Date",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "DO_QTY",		Header : "납품예정수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "INVOICE_DATE",		Header : "납품일",	Type : "Date",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "IV_QTY",		Header : "납품수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 60, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",SaveName : "DELIVERY_DATE",		Header : "확정일",	Type : "Date",	Width : 70, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Right",SaveName : "DI_QTY",		Header : "확정수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 60, EditLen : 100,	Edit : false, Hidden : false}, 
	    			{Align : "Center",SaveName : "GR_DATE",		Header : "입고일",	Type : "Date",	Width : 70, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 60, EditLen : 110,	Edit : false, Hidden : false}, 
	    			{Align : "Center",SaveName : "REASON10",		Header : "REASON10",	Type : "Text",	Width : 200,	EditLen : 110,Hidden:true, Edit : false},
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterBeforeListDivisionPop.do" , pagingMode );
	
 
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	// 선택된 항목 유무 체크
	if (str !="search1" && str !="search" && str !="excelDown" && str !="excelUpload"  && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
    var saveTitle = ""; 
    var saveTitleContent = ""; 
	saveFlag = str;
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			st_saveFlag_clear();
			kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterBeforeListDivisionPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			st_saveFlag_clear();
			mySheet.RemoveAll();
			break;
			
		case "save":	// 저장			 
		 
			st_saveFlag_clear(); 
		 
			for ( var i = 0; i <= mySheet.RowCount(); i++ ) {
				
 
					 
					if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) { 
						
 
		                // 저장상태 최종 저장
		                saveFlag_biz(REASON10, i);
		                
		     
		                var REASON10  = mySheet.GetCellValue( i    , "REASON10");  // 저장구분
		                if (REASON10 == "" || REASON10 == "N/N/N/N/N/N/N/N/N/N"){
		                	alert(i + " 번째 저장할 내용이 없습니다.");
		                	return;
		                }   
		            	 
		            	saveTitle = saveTitle +  "수량분할";
		            	saveTitleContent = saveTitleContent +   i + " 번째 " +saveTitle + "\n";
		            	 
					}
						  
			}
		 
			
		    if (confirm(saveTitleContent + "선택된 내역을 저장하시겠습니까?")==false) return; 
			// 사유입력
	        openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=Y' , "500,280,no");
			break;
			
		case "realSave":
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveOrderChangeDivisionCombineLogic.do" , "SELECTED" );
			break;
 
	}

}

function st_saveFlag_clear(){
	$("#st_saveFlag").val("N/N/N/N/N/N/N/N/N/N"); // 초기원복
	$("#st_saveFlag_code").val(""); // 초기원복
}
 

function setReason(value){
 
 
    $("#st_reason").val(value); //  사유    
	if (saveFlag == "save"){ // 저장
		doAction('realSave'); 
	}
	
}


function saveFlag_biz(saveflag , row){ 
	 
	var header_C001 = "N"; // 단순항목변경 
	var header_C002 = "N"; // 거래유형변경
	var header_C003 = "N";  // 협력사변경
	var header_C004 = "N";  // 단가변경
	var header_C005 = "N";  // 수량변경	
	var header_C006 = "N";  // 발주삭제
	var header_C007 = "N";  // 발주초기화
	var header_C008 = "N";  // 발주종결
	var header_C009 = "N";  // 종결복원
	var header_C010 = "Y"; // 수량분할 
	

	
	$("#st_saveFlag").val(header_C001+"/"+header_C002+"/"+header_C003+"/"+header_C004+"/"+header_C005+"/"+header_C006+"/"+header_C007+"/"+header_C008+"/"+header_C009+"/"+header_C010);
	$("#st_saveFlag_code").val("C010^");
	mySheet.SetCellValue( row ,  'REASON10', $("#st_saveFlag").val());  
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
	
	for (var i=1; i<=mySheet.RowCount() ; i++){
		
		var DO_QTY =  mySheet.GetCellValue(i, "DO_QTY");
		var IV_QTY =  mySheet.GetCellValue(i, "IV_QTY");
		var DI_QTY =  mySheet.GetCellValue(i, "DI_QTY");
		var GR_QTY =  mySheet.GetCellValue(i, "GR_QTY");
		if (DO_QTY != "" || IV_QTY != "" || DI_QTY != "" || GR_QTY != ""){
			mySheet.SetCellEditable(i, "SELECTED", false);
		}else{
			mySheet.SetCellEditable(i, "ITEM_QTY", true);
		}
	}

	/*
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	*/
	
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
		location.reload();
	}
}


//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterBeforeMainDivisionPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	
	if (Value == "") return;
	
	 
	return;
}


function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

 
}



//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16){
	
 	 if (popupSel == "USER") {	// 사용자
 		$("#st_po_change_user_id").val(value1);
 		$("#st_po_change_user_name").val(value2);
	} 
	
	grbRow="";	//초기화
} 

// 사용자선택
function getUserSelect(buyer){
	popupSel = "USER";
	openSearchPopup('/common/misUserSelectAllPop.do', '?open=Y&com_code='+buyer , "500,500,no");
}
 

function kepUnload(){
	 opener.doAction('search');
}

function go_link(){
	  $('#searchCondition1').attr("action", "/mpso/getMasterMpSoOrderInfoAlterBeforeMainPop.do").submit();     
}

 
</script> 
<body onload="kep_onload_view();" onunload="kepUnload()">
<form name = "searchCondition1" id="searchCondition1" method = "post">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>"> 
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=st_po_no%>"> 
	<input type="hidden" id="st_orderFlag"  name="st_orderFlag" value="<%=st_orderFlag%>"> 
</form>
<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME" value="">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>"> 
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=st_po_no%>"> 
	<input type="hidden" id="st_orderFlag"  name="st_orderFlag" value="<%=st_orderFlag%>"> 
	<input type="hidden" id="st_masterFlag"  name="st_masterFlag" value=""> 
	<input type="hidden" id="st_reason"  name="st_reason" value=""> 
	<input type="hidden" id="st_saveFlag"  name="st_saveFlag" value="N/N/N/N/N/N/N/N/N/N"> 
	<input type="hidden" id="st_saveFlag_code"  name="st_saveFlag_code" value=""> 
 
	
	<div id="popWrapper" style="height:790px;">
    	<div id="popHeader">
        	<h1 class="title">주문정보 수정-수주접수<%=beforeAfterTitle %> 수량분할</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"> 
        
    <table  class="board_write"  style="width:100%">
      <colgroup>
      <col width="13%" />
      <col width="20%" />
      <col width="13%" />
      <col width="20%" />
      <col width="13%" />
      <col width="*" />      
      </colgroup>
      <tr>
        <th scope="row">구매회원사</th> 
		<td><%=rowData.get("BUYER_NAME")%></td>
        <th scope="row">자재코드</th>
        <td><%=rowData.get("PO_DEPT_NAME")%></td>
        <th scope="row">요청부서</th>
        <td><%=rowData.get("REQ_DEPT_NAME")%></td>        
      </tr>
      <tr>
        <th scope="row">발주번호</th> 
		<td><font color="#5B5B5B"><%=rowData.get("PO_NO")%></font><font color="red">&nbsp;<%=rowData.get("DOC_TEXT")%></font><%=rowData.get("PROCESS_TEXT")%></td>
        <th scope="row">발주자</th>
        <td><%=rowData.get("PO_USER_NAME")%></td>
        <th scope="row">요청자</th>
        <td><%=rowData.get("REQ_USER_NAME")%></td>        
      </tr>      
      <tr>
        <th scope="row">발주일</th> 
		<td><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
        <th scope="row">매입금액</th>
        <td><input type="text"   name="agent_po_ttl_amt_text" id="agent_po_ttl_amt_text" size="14" class = "input_type_text" style="background-color:#FFFFFF;height=16;font-size:9pt;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(rowData.get("AGENT_AMT"),true,0,3)%>"    READONLY > 
          <input type="hidden" name="agent_po_ttl_amt" id="agent_po_ttl_amt" value ="<%=rowData.get("AGENT_AMT")%>">
       	</td>
        <th scope="row">매출금액</th>
        <td><input type="text"   name="po_ttl_amt_text" id="po_ttl_amt_text" size="14" class = "input_type_text" style="background-color:#FFFFFF;height=16;font-size:9pt;border:#FFFFFF 1px solid;" value="<%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%>"    READONLY >
        <input type="hidden" name="po_ttl_amt"  id="po_ttl_amt" value ="<%=rowData.get("PO_AMT")%>"></td>        
      </tr>       
      <tr>
        <th scope="row">도착지</th> 
		<td colspan="3"><%=rowData.get("DELY")%></td>
        <th scope="row">발주수정자</th>
        <td><input type="text"   name="st_po_change_user_name" id="st_po_change_user_name" size="12" id="line" class="input_type_text" value="<%=SessionUserName%>" READONLY >
<%
        if(SessionUserId.equals("KEP01")|| SessionUserId.equals("KEP2179004") ){
%>
                  <span class="btn_gray_03" title="변경"> <a href="javascript:getUserSelect('KRKORE0001');">변경</a></span> 
<%
        }
%>  

                  <input type="hidden" name="st_po_change_user_id"  id="st_po_change_user_id" value="<%=SessionUserId%>"></td>        
      </tr>  
       <tr>
        <th scope="row">비고</th>  
        <td colspan="5"><%=rowData.get("REMARK")%></td>        
      </tr>                     
      </table>
         
     <div style=" top:10px; text-align:right;">  
         	<span class="btn_search" title="정보수정"><a href="javascript:go_link();">정보수정</a></span> 
         </div>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "450px");
				</script>
			</div>
			<div id="pageindex"></div>
		<br>
        <!--버튼영역-->
        <div class="btnArea mr25">  
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">수량분할</a></span> 
			</span>
       </div>
        		</div>	
    </div>
</form> 
</body>
</html>
