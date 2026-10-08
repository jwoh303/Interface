<%--
**********************************************
* 메뉴 : 상품견적관리
* 화면 : 견적합의대상
* 기능 : 네고요청 시 단가, 회신요청일, 요청사항 입력 후 등록 팝업
* 프로그램 ID : 
* 담당자 : 이민아
* 착수일 : 2026-03-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ include file="../../include/head_v2.jspf"  %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)

String param = CommonUtil.nvl((String) request.getParameter("param"),"");  //  (조회조건)
String[] paramArr = param.split("@@");
%>

<script type="text/javascript">
function kep_onload_view(){
	
	$("input[name=st_btoa_end_date]").val(getWorkingDay());
}

//"확인";
var but1text = "<%=CommonLang.get("HTITLE516")%>";
var but1func = "javascript:closePopText2(); return false;";
var but1width = "120px";

var value1 = "";
var value2 = "";
var value3 = "";
var value4 = "";

function kepConfirm(){ 
	var today = kepGetNowTimeStr('YYYYMMDD','');

	for(var j = 0 ; j < <%=paramArr.length%>; j++){ 
		var st_btoa_end_date = $('#st_btoa_end_date'+j).val().replace(/\//g, '');

		if(kepIsValueNull($('#st_btoa_nego_price'+j).val()) || !kepIsNumChk('st_btoa_nego_price'+j,2)) {
			$('#st_btoa_nego_price'+j).focus();

			//Nego 단가(숫자형식)를 입력하여 주십시요.
			var text = "<%=CommonLang.msg("MSG524")%>"; 	
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if($('#st_btoa_nego_price'+j).val() <= 0) {
			$('#st_btoa_nego_price'+j).focus();
			
			//Nego 단가를 입력하여 주십시요.
			var text = "<%=CommonLang.msg("MSG525")%>"; 	
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(kepIsValueNull($('#st_btoa_end_date'+j).val())) {
			$('#st_btoa_end_date'+j).focus();
			
			var text = "<%=CommonLang.msg("MSG526")%>";	//Nego 회신 요청일을 입력하여 주십시요.
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}

		if (st_btoa_end_date < today){
			var text = "<%=CommonLang.msg("MSG527")%>";	//오늘 이후의 날짜를 선택하세요.
			$('#st_btoa_end_date'+j).focus();
			
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		if(kepIsValueNull($('#st_btoa_end_date'+j).val())) {
			var text = "<%=CommonLang.msg("MSG526")%>";	//Nego 회신 요청일을 입력하여 주십시요.
			$('#st_btoa_end_date'+j).focus();
			
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		var remark = $("#remark"+j).val().trim();
		
		if(kepIsValueNull(remark)){ // 왜 반응을 안할까
			//요청사항을 입력하여 주십시오
			var text =	"<%=CommonLang.msg("MSG775")%>";	
			$("#remark"+j).focus();
			
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		$("#remark"+j).val(remark.replace(/\r?\n/g, '<br>'));
		
		value1 += $("#st_idx"+j).val()+"^^";
		value2 += $("#st_btoa_nego_price"+j).val()+"^^";
		value3 += $("#remark"+j).val()+"^^";
		value4 += st_btoa_end_date+"^^";
	} 

     //"네고요청을 하시겠습니까?"
    var text =	"<%=CommonLang.msg("MSG774")%>";	
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; // 확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; // 취소
	var but1funcC = "javascript:executekepConfirm(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function executekepConfirm(){
	closePopText1();
	opener.tabs["buyerMpRqQuota_tab3"]["setPopupReturn"](value1,value2,value3,value4);
	self.close();
	return;
}
function getWorkingDay() {	
	var date = new Date();	
	if(date.getDay() == 3 || date.getDay() == 4 || date.getDay() == 5) { // 수목금
		date.setDate(date.getDate() + 5);
	}
	else if(date.getDay() == 6) { // 토
		date.setDate(date.getDate() + 4);
	} else { // 일월화
		date.setDate(date.getDate() + 3);
	}
	
	var year = date.getFullYear();
	var month = date.getMonth();
	month += 1;
	if(month <= 9) {
		month = "0" + month;
	}
	
	var day = date.getDate();
	if(day <= 9) {
		day = "0" + day;
	}
	
	var result = year + '/'+ month + '/'+ day;
	return result;
}
// function displayNumbering(){
// 	var btoa_nego_price	= kepFilterNum(kepTrimStr($('#st_btoa_nego_price').val()));			// 수량 - 고정
// 	if(btoa_nego_price!="") {
// 		$('#st_btoa_nego_price').val(kepTrimStr(btoa_nego_price));
// 		$('#st_btoa_nego_price_text').val(kepCommaNum(kepTrimStr(btoa_nego_price)));
		
// 	}
// }
</script> 
<body onload="kep_onload_view();">
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	
<div class="wrapPopup">
	<div class="PopupTit"><%=CommonLang.get("HTITLE1188")%><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div><!-- 네고 요청 -->
    <div class="PopupTitSubTxt"><%=CommonLang.get("HTITLE1187")%><!--     선택한 상품의 Nego단가 등의 정보를 입력해주세요. -->
    <div class="ScrollBox " style="height:270px;">
	    <table class="PopupTableTHrow02" width="100%">
			<colgroup>
		        <col width="13%" />
		        <col width="9%" />
		        <col width="25%" />
		        <col width="12%" />
		        <col width="10%" />
		        <col width="31%" />
			</colgroup>
		    <tr>
				<th rowspan=2><%=CommonLang.get("HTITLE126")%></th><!-- 견적번호 -->
				<th rowspan=2><%=CommonLang.get("HTITLE140")%></th><!-- 순번 -->
				<th rowspan=2><%=CommonLang.get("HTITLE13")%></th><!-- 품목명 -->
				<th rowspan=2><%=CommonLang.get("HTITLE145")%></th><!-- 견적단가 -->
				<th><%=CommonLang.get("HTITLE165")%><!-- Nego단가--><span>*</span></th>
				<th rowspan=2><%=CommonLang.get("HTITLE904")%><!--요청사항--><span>*</span></th>
	    	</tr>
	    	<tr>
	    		<th style=" border-left:1px solid #dedede;"><%=CommonLang.get("HTITLE903")%><!--Nego 회신요청일--><span>*</span></th>
	    	</tr>
<%-- <% if(paramArr.length == 0) {%><tr> <td colspan="4"> 조회된 내용이 없습니다.</td></tr><%} %>			    	 --%>
<% //else {
for(int i = 0 ; i < paramArr.length; i++){
	String[] temp = paramArr[i].split(":::"); // 0 : idx, 1 : 견적번호 , 2 : 견적항번, 3 : 품목코드 , 4 : 품목명, 5: 견적단가
%> 
			<tr>
				<input type="hidden" id="st_idx<%=i%>" value="<%=CommonUtil.nvl(temp[0])%>">
				<input type="hidden" id="st_quotation_no<%=i%>" value="<%=CommonUtil.nvl(temp[1])%>">
				<input type="hidden" id="st_quotation_seq<%=i%>" value="<%=CommonUtil.nvl(temp[2])%>">
				<td rowspan=2 align="center"><%=CommonUtil.nvl(temp[1])%></td>
				<td rowspan=2 align="center"><%=CommonUtil.nvl(temp[2])%></td>
				<td rowspan=2 align="left"><%=CommonUtil.nvl(temp[3])%><br><%=CommonUtil.nvl(temp[4])%></td>
				<td rowspan=2 align="left"><%=CommonUtil.formatNumber(temp[5],true,0,3)%><%=CommonLang.get("HTITLE660")%><!-- 원 --></td>
				<td> <input class="input30" type="text" id="st_btoa_nego_price<%=i%>" name = "st_btoa_nego_price" value="" style="width:110px;">&nbsp;<%=CommonLang.get("HTITLE660")%><!-- 원 --></td>				
				<td rowspan=2>
					<textarea id="remark<%=i%>" name="remark" class="" style="width:100%; height:60px; border:1px solid #DEDEDE; border-radius:4px;" placeholder="" onkeyup="fnCheckInputByte(this, '1000');" onchange="fnCheckInputByte(this,'1000');"></textarea>
				</td>
			</tr>
			<tr>
				<td align="left" style=" border-left:1px solid #dedede;">
		          <div class="datepicker-wrap" style="width:130px">
		            <div class="date-input" style="width:125px" data-datepicker>
		            	<input type="text" placeholder=""  name="st_btoa_end_date" id="st_btoa_end_date<%=i%>" readonly /><span></span>
		            	</div>
		          </div>
		        </td>
			</tr>
<%	//}
}%>
		</table>
	</div>
	<div class="PopupListBtnBox_Center">
		<button class="ButPrimary_large" onclick="javascript:kepConfirm(); return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
	</div>
</div>
</body>
</html>
