<%--
**********************************************
* 메뉴 : 
* 화면 : 분할납품 계획입력
* 기능 : 분할납품 계획을 입력하는 화면
* 프로그램 ID : PG_07_A_001_02
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
<%
	//String cur_date = CommonUtil.getCurrentDay_Time("yyMMdd"); // 현재날짜        
	
	String user_id			= CommonUtil.nvl((String) request.getParameter("user_id"));
	String kep_id			= CommonUtil.nvl((String) request.getParameter("kep_id"));
	
	String popupCheck			= CommonUtil.nvl((String) request.getParameter("popupCheck"));
	
	if(user_id.equals("")){
		user_id = _sessionInfo.getUserId();
	}
			
	String buyer			= CommonUtil.nvl((String) request.getParameter("buyer"));
	String po_no			= CommonUtil.nvl((String) request.getParameter("po_no"));
	String po_seq			= CommonUtil.nvl((String) request.getParameter("po_seq"));
	String po_qty			= CommonUtil.nvl((String) request.getParameter("po_qty"));
	String seller			= CommonUtil.nvl((String) request.getParameter("seller"));
	String ds_flag			= CommonUtil.nvl((String) request.getParameter("ds_flag"));
	String st_date			= CommonUtil.nvl((String) request.getParameter("st_date"));
	String ds_delay_reason	= CommonUtil.nvl((String) request.getParameter("ds_delay_reason"));
	String description		= CommonUtil.nvl((String) request.getParameter("description"));
	String po_create_date	= CommonUtil.nvl((String) request.getParameter("po_create_date"));
			
	Vector vt           = new Vector();
	String query_str	= CommonUtil.nvl((String)request.getParameter("query_text"));
	String check_flag	= CommonUtil.nvl((String)request.getParameter("check_flag"));
	
	String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
	
//	KRCOWA0001@@PO14003786@@000001@@1@@20140619@@1@@Y@@KRKORE0001@@KEPSE02@@@@20140619@@20140301^||^
	
	for(int i=0 ; i < check_str.length; i++){	
		
		String str[] = check_str[i].split("@@",-1);
		
		vt.addElement(str);
	}
	
%>

<script language="javascript">
var x;

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var grb_query = "";
var grb_max_cd_date = "";
var grb_check_flag = "";
var grb_delay_reason = "";

// 분할납품변경계획 저장
function setDeliverySchedule(){
	getLastDate(); 

    var buyer           = "<%=buyer%>";
    var po_no           = "<%=po_no%>";
    var po_seq          = "<%=po_seq%>";
    var po_qty          = "<%=po_qty%>";
    var seller          = "<%=seller%>";
    var user_id         = "<%=user_id%>";
    var max_cd_date     = $("#st_max_cd_date").val();
    var st_date         = "<%=st_date%>";
    var buyer_need_deli = "N";
    
    var kep_id = "<%=kep_id%>";
    
	var trCnt = $("#tblData tr").length;
	
	var check_flag = eval("document.sellerMpIvDivsnDeliveryPlanEntryPop.st_buyer_need_deli.checked");
	
	if(check_flag == true){
		buyer_need_deli = "Y";
		if(trCnt > 1){
// 			alert("고객사 요청시 분할 납품 건은 1줄로만 입력 가능합니다.");
			var text = "고객사 요청시 분할 납품 건은 1줄로만 입력 가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}else{
		// 지연사유 입력체크
	    if(!getReason(max_cd_date)){
	    	return;
	    }
	}
    
    var delay_reason    = $("#st_delay_reason").val();
    
    var query       = "";
    var sumcd_qty       = 0;
	
    for(i = 0 ; i < trCnt ; i++){
    	var cd_date = $("input[name='st_cd_date']").eq(i).val();
    	var cd_qty  = $("input[name='cd_qty']").eq(i).val();
    	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
    	
    	if(cd_date < cur_date){
//     		alert("납품예정일을 금일 이후 날짜로 입력해주세요");
    		var text = "납품예정일을 금일 이후 날짜로 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
    		$("#input[name='st_cd_date_text']").eq(i).focus();
    		return;
    	}
		if(isEmpty(cd_date)){
// 		    alert( "납품예정일을 입력해주세요");
		    var text = "납품예정일을 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
		    $("#input[name='st_cd_date_text']").eq(i).focus();
		    return;
		}
		
		if(isEmpty(cd_qty)){
// 		    alert( "납품수량을 입력해주세요");
		    var text = "납품수량을 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
		    $("input[name='cd_qty']").eq(i).focus();
		    return;
		}
		
		if(st_date > cd_date){
			delay_reason = "";
		}else{
			delay_reason    = $("#st_delay_reason").val();
		}
		
		query +=  buyer         + "@@";
		query +=  po_no         + "@@";
		query +=  po_seq        + "@@";
		query +=  po_qty        + "@@";
		query +=  cd_date       + "@@";
		query +=  cd_qty        + "@@";
		query +=  "Y"           + "@@"; // DS_FLAG
		query +=  seller        + "@@";
		query +=  user_id       + "@@";
		query +=  delay_reason  + "@@";
		query +=  max_cd_date   + "@@";// ICOMPODT.DS_DATE 에 들어가는 값   , 분할접수일 경우 마지날 납품예정일
		query +=  st_date		+ "@@";
		query +=  ""			+ "@@"; // reject_reason 자리
		query +=  buyer_need_deli + "@@"; // 고객사 요청분할
		query +=  st_date;
		
		if(!isEmpty(kep_id)){
			query +=  "@@" + kep_id;	
		}
		query +=  "^||^";
		
		sumcd_qty = eval(sumcd_qty) + eval(cd_qty);
    }
    
    // 납품예정일 중복체크
	if(!checkSamedate(trCnt)) return;
	
    if(po_qty == sumcd_qty){

    	if(check_flag == true){
			check_flag = "Y";
		}else{
			check_flag = "N";
		}
    	
    	grb_query = query;
    	grb_max_cd_date = max_cd_date;
    	grb_check_flag = check_flag;
    	grb_delay_reason = delay_reason;
    	
// 		if(!confirm("분할납품계획을 입력하시겠습니까?")) return; 
		
		var text = "분할납품계획을 입력하시겠습니까?";
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:setDSQueryFunc(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "100px";
		var but2widthC = "100px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

    }else{
//         alert("납품예정수량("+sumcd_qty+")과 발주수량("+po_qty+")이 일치하지 않습니다.\n\n확인 후 다시 입력하여 주십시요.");
        var text = "납품예정수량("+sumcd_qty+")과 발주수량("+po_qty+")이 일치하지 않습니다.</br>확인 후 다시 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
    }            
}

function setDSQueryFunc(){
	closePopText1();
	parent.setDSQuery(grb_query,grb_max_cd_date,grb_check_flag,grb_delay_reason);	
	var popupCheck = '<%=popupCheck%>';
	if(popupCheck == "Y"){
		parent.closePop2();
	}else{
		parent.closePop();
	}
}
//지연사유 값 얻기
function getReason(max_cd_date){

	var reason_cd = $("input[name=delay_reason]:checked").val();
	if(reason_cd == undefined){ //선택 안되었으면
		reason_cd = "";
	}
	var reason_etc = $.trim($("#delay_reason_text").val());

	var reason_txt = "";
	
	// 지연사유 값 세팅
	if(reason_cd == "기타"){
		$("#st_delay_reason").val(reason_etc);	
	} else {
		$("#st_delay_reason").val(reason_cd);
	}	
	
	reason_txt = $("#st_delay_reason").val();
	
	var st_date		= "<%=st_date%>";
	
	// 납기요청일과 납품예정일 마지막날짜를 비교하여 지연사유 입력여부 체크
	if(max_cd_date > st_date && reason_txt==""){
// 		alert("납품지연 사유를 입력하여 주시길 바랍니다.");
		var text = "납품지연 사유를 입력하여 주시길 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
        return false;
    }
	
	return true;
}

// 중복되는 납품예정일이 있는지 확인 
function checkSamedate(insert_cnt) {
    var i;    
    for(i=0;i<insert_cnt;i++){
        for(j=0;j<i;j++){
            if((document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date[i].value != "") && (document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date[i].value == document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date[j].value)){
//                 alert("납품예정일이 중복 되었습니다.\n\n확인 후 다시 입력하여 주십시요.");
                var text = "납품예정일이 중복 되었습니다.</br>확인 후 다시 입력해주세요.";
        		openLayerPopText2(text,but1text,but1func,but1width);
        		
                document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date_text[i].focus();
                document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date_text[i].select();
                return;
            }
            
            if((document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date[i].value != "") && (document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date[i].value < document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date[j].value)){
//             	alert("납품예정일 순서를 확인해주시기 바랍니다.");
            	 var text = "납품예정일 순서를 확인해주시기 바랍니다.";
         		openLayerPopText2(text,but1text,but1func,but1width);
            	document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date_text[j].focus();
                document.forms["sellerMpIvDivsnDeliveryPlanEntryPop"].st_cd_date_text[j].select();
                return;
            }
        }
    }//end for
    return true;
}

// 마지막 날짜 검색...
function getLastDate() {
    var cd_date     = "";
    var max_cd_date = "";
	var st_date     = "<%=st_date%>";
	var trCnt = $("#tblData tr").length;
	var form = document.sellerMpIvDivsnDeliveryPlanEntryPop;
	
    for(var i = 0 ; i < trCnt ; i++){
    	
    	$("#input[name='st_cd_date_text']").eq(i).focus();

       	if($("input[name='st_cd_date']").eq(i).val().length > 0 && $("input[name='cd_qty']").eq(i).val().length > 0){

            cd_date = $("input[name='st_cd_date']").eq(i).val();
            
            // 납품예정일 마지막날짜
            if(max_cd_date=="") max_cd_date = cd_date;
            if( eval(cd_date) > eval(max_cd_date)){
                max_cd_date = cd_date;
            }
        }
    }

	if(st_date >= max_cd_date){// 납품예정일이 변경되어 납기요청일 >= 납품예정일 경우 지연사유 입력값을 변경한다.
		form.st_delay_reason.value = "";		
	}
	
    $("#st_max_cd_date").val(max_cd_date);
}

// 납품수량 체크
function checkCdQty(num){
    var cd_qty = $("#cd_qty"+num).val();
    
    if( !isEmpty(cd_qty) && (!kepIsNumber("cd_qty"+num) || cd_qty == "0")){
//     	alert("납품수량에 1 이상의 숫자를 입력해 주십시요");
    	var text = "납품수량에 1 이상의 숫자를 입력해주세요.";
 		openLayerPopText2(text,but1text,but1func,but1width);
    	$("#cd_qty"+num).val("");
    	$("#cd_qty"+num).focus();
    	
    	return;
    }
}

// OPENER창의 지연사유 값 얻기
function init(){
	
	var reason = '<%=ds_delay_reason%>';
    
    if(reason != "" && reason != "재고부족" && reason != "수입지연" && reason != "제작지연" &&  reason != "발주확인지연"){
    	$('input[name="delay_reason"][value="기타"]').prop("checked",true);
		$("#delay_reason_text").val(reason);
		$("#delay_reason_text").prop('readonly',false);
	} else {
		$('input[name="delay_reason"][value="'+reason+'"]').prop("checked",true);
	}
    
    // 최초 분할 시 발주수량 표기
    var ds_flag = "<%=ds_flag%>";
    
    if(ds_flag == "N"){
    	$("#cd_qty0").val("<%=po_qty%>");
    	$("#cd_qty0").val("<%=po_qty%>");
    }
    
    if("<%=check_flag%>" == "Y"){
    	document.sellerMpIvDivsnDeliveryPlanEntryPop.st_buyer_need_deli.checked = true;	
    	//달력 및 행추가 버튼 비활성화
    	$(".date-input").css("pointer-events","none");
		$(".calendar-btn").css("pointer-events","none");
		$(".date-input").css("background-color","gray");
		$(".date-input input[type=text]").css("background-color","gray");
		$(".date-input span").css("background-color","gray");
		
		$(".ButOutline_Small").css("pointer-events","none");
		$(".ButOutline_Small").css("background-color","gray");
    }
    
}    

var selObj;


// 행추가
function addRow(){
	var trCnt = $("#tblData tr").length;
	var seq = trCnt+1;
	var x = seq-1;
	
	var rowData	 = "<tr> ";
	rowData		+= "	<td>"+seq+"</td>";
	rowData		+= "	<td>";
	rowData		+= "		<input type='text'   name='cd_qty' id='cd_qty"+x+"' onChange = 'javascript:checkCdQty("+x+")' value='' class='input30'  style='width:90%;  text-align:right'/>";
	rowData 	+= "	</td>";
	rowData		+= "	<td><div class='datepicker-wrap' style=' width:220px'>";
	rowData		+= "	<div class='date-input' data-datepicker style=' width:220px'>"	;
	rowData		+= "	<input type='text'   name='st_cd_date_text' id='st_cd_date_text"+x+"' style='width:160px;'  value='' readonly><span id='calendar-btn'> </span>";
	rowData 	+= "		<input type='hidden' name='st_cd_date'      id='st_cd_date"+x+"' value='' >";
	rowData		+= "	</div>";
	rowData		+= "	</div>";
	rowData		+= "	</td>";
	rowData		+= "	<td align='center'><button class='WasteBasket_Outline' onclick='javascript:delRow(this);return false;'>  </button></td>"
	rowData 	+= "</tr>";
	
	$("#tblData").append(rowData);
	
	
// 	$("#x").val(x);
	
// 	setTimeout(function(){
// 		// Action after append
// 		kepSetCalender('st_cd_date_text'+x, '1', 'Y', x);
// 	},100);
}

// 행삭제
function delRow(btn){
	
	$(btn).closest("tr").remove();
	
	$("#tblData tr").each(function(i){
		$(this).find("td:eq(0)").text(i+1);
	});
}
//달력 콜백함수
// function calendarCallback(dateStr){
<%-- 	var st_date		= "<%=st_date%>"; --%>
	
// 	var delay_reason = $("input[name=delay_reason]:checked").val();
// 	if(delay_reason == undefined){ //선택 안되었으면
// 		delay_reason = "";
// 	}
	
// 	if(delay_reason == "기타"){ //기타면 입력사유
// 		delay_reason = $("#delay_reason_text").val();
// 	}
	
// 	if(dateStr > st_date && delay_reason == ""){
// 		alert("표준납품일 보다 이후날짜입니다. 지연사유을 입력하시기 바랍니다. ");
// 	}
// }
// 납품예정일 calender callback event

function needClickEvent(){
	
	var trCnt = $("#tblData tr").length;
	var form = document.sellerMpIvDivsnDeliveryPlanEntryPop;
	
	var checked = eval("document.sellerMpIvDivsnDeliveryPlanEntryPop.st_buyer_need_deli.checked");
	
	if(checked == true){
		// 납품수량 = 전량, 납품예정일 = 내년 마지막 일자, 지연사유/상세사유 = null
		var cur_date = kepGetNowTimeStr("YYYYMMDD","/"); // 오늘 날짜
		var nextYear_date = kepToMonthAdd("12","P"); // 내년 날짜
		var nextYear_last_date = nextYear_date.substring(0,4) + "/12/31"; // 내년 마지막 날짜
		var replace_nextYear_last_date = nextYear_last_date.replace(/[/]/gi,"");
		
		for(var i=0; i<trCnt; i++){
			$("input[name='cd_qty']").eq(i).val("<%=po_qty%>");
			$("input[name='st_cd_date']").eq(i).val(replace_nextYear_last_date);
			$("input[name='st_cd_date_text']").eq(i).val(nextYear_last_date);
	    }
		
		$("input[name='delay_reason']").prop('checked',false);
		$("#delay_reason_text").val("");
		
		//달력,행추가 비활성화
		$(".date-input").css("pointer-events","none");
		$(".calendar-btn").css("pointer-events","none");
		$(".date-input").css("background-color","gray");
		$(".date-input input[type=text]").css("background-color","gray");
		$(".date-input span").css("background-color","gray");
		
		$(".ButOutline_Small").css("pointer-events","none");
		$(".ButOutline_Small").css("background-color","gray");
	}else{
		for(var i=0; i<trCnt; i++){
			$("input[name='cd_qty']").eq(i).val("");
			$("input[name='st_cd_date']").eq(i).val("");
			$("input[name='st_cd_date_text']").eq(i).val("");
	    }
		
		$("input[name='delay_reason']").prop('checked',false);
		$("#delay_reason_text").val("");
		
		//달력,행추가 활성화
		$(".date-input").css("pointer-events","auto");
		$(".calendar-btn").css("pointer-events","auto");
		$(".date-input").css("background-color","");
		$(".date-input input[type=text]").css("background-color","");
		$(".date-input span").css("background-color","");
		
		$(".ButOutline_Small").css("pointer-events","auto");
		$(".ButOutline_Small").css("background-color","");
	}
	
}
function delayReasonClick(){
	var reason = $("input[name='delay_reason']:checked").val();
	if(reason == "기타"){
		$("#delay_reason_text").prop('readonly',false);
	}else{
		$("#delay_reason_text").val("");
		$("#delay_reason_text").prop('readonly',true);
	}
}
function checkCdDate(index){
	var cd_date = $("input[name='st_cd_date']").eq(index).val();
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	
	if(cd_date < cur_date){
// 		alert("납품예정일을 금일 이후 날짜로 입력해주세요");
		var text = "납품예정일을 금일 이후 날짜로 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_cd_date_text"+index).val("");
		$("#st_cd_date_text"+index).focus();
		return;
	}
}
</script>
</head>

<body onload="javascript:init();">
<form name="sellerMpIvDivsnDeliveryPlanEntryPop" id="sellerMpIvDivsnDeliveryPlanEntryPop" method="post" >
<!-- HIDDEN -->
<input type="hidden" name="st_query"         value="">
<input type="hidden" id="st_max_cd_date" name="st_max_cd_date"   value="">
<input type="hidden" id="st_delay_reason" name="st_delay_reason"  value="">

<input type="hidden" id="x"  value="">

<!-- HIDDEN -->
<div class="wrapPopup">
  <div class="PopupTit">분할납품계획 <span>
  <%if(popupCheck.equals("Y")){ %>
  <a href="javascript:parent.closePop2();">
  <%}else{ %>
  <a href="javascript:parent.closePop();">
  <%} %>
  <img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
   <table class="PopupTableTxt" width="600px">
    <colgroup>
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
   	</colgroup>
    <tr>
      <th>발주번호</th>
      <td><%=po_no%></td>
      <th>발주일</th>
      <td><%=CommonUtil.formatDate(po_create_date) %></td>
    </tr>
    <tr>      
      <th>발주수량</th>
      <td align="right"><%=CommonUtil.formatNumber(po_qty,true,0,3)%></td>
      <th>표준납품일</th>
      <td><%=CommonUtil.formatDate(st_date)%></td>
    </tr>
    <tr>
      <th>품목명</th>
      <td colspan="3"><%=description%></td>
    </tr>       
  </table>  
  <div class="PopupTitSubState" style=" position:relative; width:600px;  ">납품계획
    <label class="CheckMediumLabel" style="line-height:20px; top:5px;vertical-align: middle   "><input type="checkbox" name="st_buyer_need_deli" id="st_buyer_need_deli" onChange ="javascript:needClickEvent();"><span class="CheckMediumCustom"></span>고객사 요청 시 분할 납품 건</label>
    <button class="ButOutline_Small"  style=" position:absolute; right:0px; top:15px;margin-left:7px" onclick="javascript:addRow(); return false;">행추가</button>
  </div>
  <table class="PopupTableTH"  width="600px">
    <colgroup>
      <col width="50px" />
      <col width="230px" />
      <col width="230px" />
      <col width="90px" />
  	</colgroup>
  	<thead>
    <tr>
      <th>번호</th>
      <th>납품수량</th>
      <th>납품예정일</th>
      <th>삭제</th>
    </tr>
    </thead>
    <tbody id="tblData">
  	<%
	/*									

	str[0]==>KRKEPB0004			==> 구매사코드
	str[1]==>PO04000206			==> 발주번호
	str[2]==>000001				==> 발주항번
	str[3]==>2					==> 발주수량
	str[4]==>20041118			==> 납품예정일
	str[5]==>1					==> 납품수량
	str[6]==>Y					==> DS_FLAG
	str[7]==>KRKORE0001			==> SELLER
	str[8]==>KEPSE03			==> 수주접수자
	str[9]==>					==> 지연사유
	str[10]==>20041118			==> 납기요청일
	str[11]==>20041118			==> 납품예정일 중 가장 마지막날짜

	*/
	
	int size = vt.size();
	String [] rtobj_d = null;
	
	if(size <= 0){
		size = 1;
	}
	
	for( int i=0; i<size; i++){
		
		rtobj_d = new String[12];

		if( i < vt.size()){
			rtobj_d = (String[])vt.get(i);
		}

	%>
    <tr>
      <td><%=i+1%></td>
      <td><input type="text" name="cd_qty" id="cd_qty<%=i%>" onChange ="javascript:checkCdQty(<%=i%>);" value="<%=CommonUtil.nvl(rtobj_d[5])%>" class="input30" style="width:90%;  text-align:right"/></td>
      <td>
      	<div class="datepicker-wrap" style=" width:220px">
          <div class="date-input" data-datepicker style=" width:220px">
          <input type="text" placeholder="" id="st_cd_date_text<%=i%>" name="st_cd_date_text" readonly style=" width:160px"/ onchange="javascript:checkCdDate(<%=i%>);"><span id="calendar-btn"> </span>
          <input type="hidden" name="st_cd_date"      id="st_cd_date<%=i%>" value='<%=CommonUtil.nvl(rtobj_d[4])%>' >
          </div>
        </div>
        </td>
      <td align="center"><button class="WasteBasket_Outline" onclick="javascript:delRow(this); return false;">  </button></td>
    </tr>
    <%} %>
    </tbody>
  </table>  
  <div class="PopupTitSub">지연사유</div>  
  <div class="Popup_BlueBox" style="width:580px">
    <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="재고부족" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>재고부족</label> 
    <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="수입지연" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>수입지연</label>
    <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="제작지연" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>제작지연</label>
    <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="발주확인지연" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>발주확인지연</label>
    <label class="RadioLargeLabel"><input type="radio" name="delay_reason" value="기타" onchange="javascript:delayReasonClick();"><span class="RadioLargeTxt"></span>기타</label><br/>
    <input class="input30" style="width:90%; margin-left:10px; margin-top:5px" name="delay_reason_text" id="delay_reason_text" type="text" placeholder="사유를 입력해주세요." readonly="readonly"/>
  </div>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:580px">
  <%if(popupCheck.equals("Y")){ %>
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop2();">취소</button>
   <%}else{ %>
   <button class="ButQuaternary_large" onclick="javascript:parent.closePop();">취소</button>
   <%} %>
    <button class="ButPrimary_large" onclick="javascript:setDeliverySchedule(); return false;">저장</button>
  </div>  
</div><!-- warp 끝-->
</form>
</body>
</html>
<script>
	$(document).ready(function() {
<% 
		for (int i=0; i<size; i++) {
			rtobj_d = new String[12];
			
			if( i < vt.size()){
				rtobj_d = (String[])vt.get(i);
			}
			if(rtobj_d[4] != null){
				String cd_date_text = rtobj_d[4].substring(0,4)+"/"+rtobj_d[4].substring(4,6)+"/"+rtobj_d[4].substring(6,8);
				String cd_date = rtobj_d[4];
%>
			$("#st_cd_date_text"+<%=i%>).val('<%=CommonUtil.nvl(cd_date_text)%>');
			$("#st_cd_date"+<%=i%>).val('<%=CommonUtil.nvl(cd_date)%>');
<%  
			}
		}
%>
	});
</script> 
