<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사선택 
* 기능 : 추가라운드요청을 하기 위해서 협력사를 재지정 한다
* 프로그램 ID : PG_04_M_007_04
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-27
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
String st_gubun = CommonUtil.nvl((String) request.getParameter("st_gubun"),"");  //  (조회조건)
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					    ,{ Align:"Center",	Width:40,	Edit : true,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
						,{ Align:"Left",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
						,{ Align:"Left",	Width:160,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
						,{ Align:"Right",	Width:95,	Edit:false,	Hidden:false,	Type:"Float", Format:"${priceFormat}",	Header:"매출단가",	SaveName:"ATOB_UNIT_PRICE"}
						,{ Align:"Right",	Width:95,	Edit:false,	Hidden:false,	Type:"Float", Format:"${priceFormat}",  Header:"매입단가",	SaveName:"STOA_LIST_PRICE"}
						,{ Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사비고",	SaveName:"STOA_REMARK"}
						,{ Align:"Left",	Width:130,	Edit:false,	Hidden:false,	Type:"Text",	Header:"지역",	SaveName:"AREA"}
						,{ Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"대표거래 고객사",	SaveName:"MAJOR_COM"}
						,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Int",	Header:"거래횟수",	SaveName:"TCNT"}
						,{ Align:"Right",	Width:100,	Edit:false,	Hidden:false,	Type:"Float", Format:"${priceFormat}",  Header:"거래금액",	SaveName:"TAMT"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"신용등급평가",	SaveName:"DSS_YN"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"신용등급메시지",	SaveName:"DSS_MSG"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"DSS_CHOICE",	SaveName:"DSS_CHOICE"}
						,{ Align:"Right",	Width:100,	Edit:false,	Hidden:true,	Type:"Float", Format:"${priceFormat}",  Header:"거래금액",	SaveName:"MIN_PRICE"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	
	HdQuery();
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqSellerChoicePop.do" , pagingMode );
}

function HdQuery(){
	$.ajax({
		type: "POST",
		dataType:"json",
		url: "/mprq/getMasterMpRqSellerChoiceRemarkPop.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { st_buyer: $("#st_buyer_code").val(),st_quotation_no: $("#st_quotation_no").val(),st_quotation_seq: $("#st_quotation_seq").val(),st_revision: $("#st_revision").val() },
		async : false,
		success:function( response ) {
			if (response.data.length > 0){
				$("#st_atos_remark").text($.trim(eval("response.data[0].ATOS_REMARK")));
				$("#st_atos_remark").val($.trim(eval("response.data[0].ATOS_REMARK")));
				$("#st_nego_item_md_complete").val($.trim(eval("response.data[0].NEGO_ITEM_MD_COMPLETE")));
				$("#st_image_key").val($.trim(eval("response.data[0].IMAGE_KEY")));
				$("#st_seller_image_key").val($.trim(eval("response.data[0].SELLER_IMAGE_KEY")));
				
				if ($.trim(eval("response.data[0].IMAGE_KEY")) == ""){
	    			$("img[id=st_image_1]").attr("src",diskOff);
	    		} else {
	    			$("img[id=st_image_1]").attr("src",diskOn);
	    		}
				
				if ($.trim(eval("response.data[0].SELLER_IMAGE_KEY")) == ""){
	    			$("img[id=st_image_2]").attr("src",diskOff);
	    		} else {
	    			$("img[id=st_image_2]").attr("src",diskOn);
	    		}
				
				if ($.trim(eval("response.data[0].IMAGE_PASS_FLAG")) == "Y"){
	    			 $('#ck_image_key_pass_flag').attr("checked", true);
	    		} else {
	    			 $('#ck_image_key_pass_flag').attr("checked", false);
	    		}
			}
		},
		error:function( response ) {
			alert("오류발생하였습니다.");
		}
	}); 
}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "round":
			var image_pass_alert = "N";
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("협력사를 지정하여 주십시요.");
				return;
			}
			
			var arrRow     = selectedGrid.split("|");
			
			for (var i=0; i<arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[i],"AGENT") == "") {
					alert("협력사를 지정하여 주십시요.");
					return;
				}				
			}
			
			var nego_item_md_complete = $('#st_nego_item_md_complete').val();
			if(nego_item_md_complete != "Y") {
				alert("네고정비 요청 후 미제출건은 진행할 수 없습니다.");
				return;
			}
			
			if(kepIsValueNull($('#st_atos_end_date').val()) && kepIsValueNull($('#st_atos_end_time').val())){
				alert("견적 마감일을 입력하여 주십시요.");
				return;
			}
			
			if($("#ck_image_key_pass_flag").is(':checked') == false){
				$('#st_image_key_pass_flag').val("N");
			}else {
				$('#st_image_key_pass_flag').val("Y");
				image_pass_alert = "Y";
			}
			
			var seller_image_key = $('#st_seller_image_key').val();
			
			if(seller_image_key != "" && image_pass_alert == "Y"){
				if(!confirm("첨부(ATOS)가 아닌 첨부(B)를 그대로 협력사에 전달합니다.\n선택된 협력사로 추가라운드 요청을 하시겠습니까?"))
					return;
			}else{
				if(!confirm("선택된 협력사로 추가라운드 요청을 하시겠습니까?"))
					return;
			}
			
			kepSave(document.searchCondition, mySheet, "/mprq/saveAgentRoundReq.do", "SELECTED");
			
			break;
		case "setAgent":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("협력사를 지정하여 주십시요.");
				return;
			}
			var arrRow     = selectedGrid.split("|");
			var agent_list = "";
			for (var i=0; i<arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[i],"AGENT") == "") {
					alert("협력사를 지정하여 주십시요.");
					return;
				}
				agent_list += mySheet.GetCellValue(arrRow[i],"AGENT") + "__N@@";
			}
		    opener.setPopupReturn(agent_list,arrRow.length);
		    this.close();
			 
			break;
	}
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
		if ("${param.st_gubun}" != "nego" && "${param.st_agent_list}" != ""){
			opener.doAction('search');
		} else {
			opener.doAction('kepConfirm');
		}
		self.close();
	}
}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
// 		if ("${param.st_gubun}" == "nego"){
// 			mySheet.SetCellValue(i,"SELECTED",1);
// 		} else {
			var dss_yn = mySheet.GetCellValue(i, 'DSS_YN');
			var dss_msg = mySheet.GetCellValue(i, 'DSS_MSG');
			
			if(dss_yn == "N"){		
				mySheet.SetCellEditable(i, "SELECTED", 0);
				mySheet.SetToolTipText(i, "SELECTED", dss_msg);
			} else {
				mySheet.SetCellValue(i,"SELECTED",1);
				if (mySheet.GetCellValue(i, "STOA_LIST_PRICE")== mySheet.GetCellValue(i, "MIN_PRICE") && i == "1" && mySheet.GetCellValue(i, "STOA_LIST_PRICE") != "0"){
					mySheet.SetCellEditable(i, "SELECTED", 0);
				}
			}
// 		}
	}
	
	if (msg != "") {
		alert(msg);
	}
}
//마우스 이동시 이벤트
function mySheet_OnMouseMove(Button, Shift, X, Y) {
	//마우스 위치를 행과 컬럼과 값 가져오기
	var Row = mySheet.MouseRow();
// 	var Col = mySheet2.MouseCol();
	var dss_yn = mySheet.GetCellValue(Row, 'DSS_YN');
	if(dss_yn == "N"){		
		mySheet.SetToolTipText(Row, "SELECTED", "신용등급 미평가로 거래불가");
	}
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "AGENT_NAME" ){ 
		var agent = mySheet.GetCellValue(Row,"AGENT");
		if(agent == ""){
			var st_buyer = $('#st_buyer_code').val();
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N&st_buyer='+st_buyer, "500,466,no");
			popupSel = "agent_single";
		}else{
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,"800,550,no");	
		}
	}
	return;
}
//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'SELECTED', "1");
	mySheet.SetCellValue(rows, 'DSS_CHOICE', "N");
}
function doPop(str) {
	switch (str){
	case "calendarHour": // 견적마감일 선택
		popupSel = "calendarHour";
		openSearchPopup("/common/calendarAndHourPop.do",'',"300,300,no");
		break;
		
	case "file":
		popupSel = "roundFileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=$('#st_image_key').val();
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
		
	case "sellerFile":
		popupSel = "roundSellerFileUpload";
		var type="RFQ";
		var viewType="VI";
		var image_key=$('#st_seller_image_key').val();
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7){
	if(popupSel == "calendarHour"){ // 견적마감일
		$('#st_atos_end_date').val(value1);
		$('#st_atos_end_date_text').val(value1.substr(0,4) + "/" + value1.substr(4,2) + "/" + value1.substr(6,2));
		$('#st_atos_end_time').val(value2);
		$('#st_atos_end_time_text').val(value2.substr(0,2) + ":" + value2.substr(2,2) + ":" + value2.substr(4,2));
	}else if (popupSel == "agent_single"){ // 협력사 팝업
		var dss_yn = value6;
		var dss_msg = value7;
		mySheet.SetCellValue(grbRow,"AGENT",value1);
		mySheet.SetCellValue(grbRow,"AGENT_NAME",value2);
		if(dss_yn == "N"){
			mySheet.SetCellValue(grbRow, 'SELECTED', "0");
			mySheet.SetCellEditable(grbRow, "SELECTED", 0);
			mySheet.SetToolTipText(grbRow, "SELECTED", dss_msg);
		}
	}else if(popupSel == "roundFileUpload") {	//파일 첨부
		$('#st_image_key').val(value1);
		if (value1 == ""){
			$("img[id=st_image_1]").attr("src",diskOff);
		} else {
			$("img[id=st_image_1]").attr("src",diskOn);
		}
	}else if(popupSel == "roundSellerFileUpload") {	//파일 첨부
		$('#st_seller_image_key').val(value1);
		if (value1 == ""){
			$("img[id=st_image_2]").attr("src",diskOff);
		} else {
			$("img[id=st_image_2]").attr("src",diskOn);
		}
	}
	grbRow="";	//초기화
}
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="${param.st_buyer_code}">
	<input type="hidden" name="st_quotation_no" id="st_quotation_no"  value="${param.st_quotation_no}">
	<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="${param.st_quotation_seq}">
	<input type="hidden" name="st_revision" id="st_revision" value="${param.st_revision}">
	<input type="hidden" name="st_agent_revision" id="st_agent_revision" value="${param.st_agent_revision}">
	<input type="hidden" name="st_agent_list" id="st_agent_list" value="${param.st_agent_list}">
	<input type="hidden" id="st_nego_item_md_complete" name="st_nego_item_md_complete" />
	
	<!-- 500*350 -->
	<div id="popWrapper" style="height:402px;">
    	<div id="popHeader">
        	<h1 class="title">협력사선택 </h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:323px;">
	        <!--버튼영역-->
	        <div class="ml20 mt05"  style="position:relative;width:830px;height:25px;"> 
				<div style="width:690px;position:absolute; left:0;">
	        	<%if (st_gubun.equals(""))  { %>
					견적마감일 : 
					<input type="hidden" name="st_atos_end_date" id="st_atos_end_date" value="">
					<input type="hidden" name="st_atos_end_time" id="st_atos_end_time" value="">
					<input type="text" name="st_atos_end_date_text" id="st_atos_end_date_text" class="input_type_text" style="width:80px;" value="" onclick="javascript:doPop('calendarHour');" readonly>
					<input type="text" name="st_atos_end_time_text" id="st_atos_end_time_text" class="input_type_text" style="width:60px;" value=""onclick="javascript:doPop('calendarHour');" readonly>
					<a href="javascript:doPop('calendarHour');"><img src="/resources/images/btn_calendar.gif"></a>
					&nbsp;첨부(B) :
		      		<a href="javascript:doPop('file');"><img src="/resources/images/disk_off.gif" id="st_image_1" name="st_image_1" alt="첨부파일(B)" /></a>
		      		<input type="hidden" name="st_image_key" id="st_image_key" value="">
		      		&nbsp; / &nbsp;첨부(B)로 협력사 전달&nbsp;
		      		<input type="checkbox" class="input_type_text"  id="ck_image_key_pass_flag" name="ck_image_key_pass_flag" />
		      		<input type="hidden" name="st_image_key_pass_flag" id="st_image_key_pass_flag" value="">
		      		&nbsp; / &nbsp;첨부(ATOS) :
		      		<a href="javascript:doPop('sellerFile');"><img src="/resources/images/disk_off.gif" id="st_image_2" name="st_image_2" alt="첨부파일(ATOS)" /></a>
		      		<input type="hidden" name="st_seller_image_key" id="st_seller_image_key" value="">
	      		<% } %>
	      		</div>
	      		
				<div style="width:140px;position:absolute; right:0;">
					<span class="text11">거래현황(최근3개월기준)</span>
				</div>
				<br>
				
  			</div>
  			
  			<%if (st_gubun.equals(""))  { %>
	  			협력사비고 :
	  			<br>
	  			<textarea id="st_atos_remark" name="st_atos_remark" rows="4" style="width:100%;" value=""></textarea>
	  			<br><br>
			<%}else{%>
				<textarea id="st_atos_remark" name="st_atos_remark" rows="4" style="width:100%; display: none;" value="" readOnly></textarea>
			<%}%>
        	
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "180px");
				</script>
			</div>
			<div id="pageindex"></div>
		
			<!--버튼영역-->
	        <div class="btnArea mr25 mt10">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
				<%if (st_gubun.equals("nego"))  { %>
					<span class="btn_02"><a href="javascript:doAction('setAgent')">확인</a></span>
				<%} else { %>
					<span class="btn_05"><a href="javascript:doAction('round')">추가라운드요청</a></span>
				<%}  %>
				</span>
	        </div>
		</div>
    </div>
					
	</form>
		
</body>
</html>
