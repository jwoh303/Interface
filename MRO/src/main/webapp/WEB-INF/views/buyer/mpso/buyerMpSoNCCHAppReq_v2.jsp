<%--
**********************************************
* 메뉴 : 
* 화면 : 
* 기능 : 엔시켐 결재 팝업 호출
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-04-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%@ page import="org.apache.http.client.methods.HttpPost"%>
<%@ page import="org.apache.http.HttpResponse"%>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@ page import="org.apache.http.entity.StringEntity"%>
<%@ page import="java.net.*"%>
<%@ page import="org.apache.http.Header"%>
<%@ page import="javax.servlet.RequestDispatcher"%>


<%@ include file="../../common/include/head_v2.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script> 

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>엔씨켐 결재상신</title>
</head>

<%
List<Map<String, String>> AppData = (List<Map<String, String>>) request.getAttribute("AppData"); // 조회된 결과
String apFormNo = AppData.get(0).get("AP_FORM_NO");
String pr_no = apFormNo.substring(10, 20);

String SessionComCodeOp = "";
String SessionUserIdOp = "";
//결재유형 상세 출력 요청
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
SessionComCodeOp =  CommonUtil.nvl((String)sessionInfo.getComCode());
SessionUserIdOp =  CommonUtil.nvl((String)sessionInfo.getUserId());

%>


<script type="text/javascript">

function sendUpdate() {
	var frm = document.getElementById("ncchApp");
	var apItem = document.getElementById("AP_ITEM");
	var optionVal = apItem.options[apItem.selectedIndex].text;
	frm.optionApItem.value = optionVal;
	kepAjaxFormCallNoBar("/mpso/buyerApItemType.do", "ncchApp", "apItemType");
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	send();
}

//ajax 공통 호출후 오류시 처리 함수
function kepAjaxError(pMethod , response) {
	
}

function send() {
	var frm = document.getElementById("ncchApp");
	var apItem = document.getElementById("AP_ITEM");
	
	var jsonData	= new Object();

	jsonData.USER_ID =	"<%=AppData.get(0).get("USER_ID")%>";
	jsonData.REF_USER_ID =	"";
	jsonData.ID_TYPE =	"<%=AppData.get(0).get("ID_TYPE")%>";
	jsonData.LOCALE =	"<%=AppData.get(0).get("LOCALE")%>";
	jsonData.AP_ITEM =	apItem.options[apItem.selectedIndex].value;
	jsonData.AP_FORM_NO =	"<%=AppData.get(0).get("AP_FORM_NO")%>";
	jsonData.DOC_TITLE =	"<%=AppData.get(0).get("DOC_TITLE")%>";
	jsonData.DOC_CONTENTS =	"<%=AppData.get(0).get("DOC_CONTENTS")%>";
	jsonData.CALL_OUT_URL1 =	"<%=AppData.get(0).get("CALL_OUT_URL1")%>";
	jsonData.KEEP_YEAR =	"<%=AppData.get(0).get("KEEP_YEAR")%>";
	jsonData.IS_URGENT =	"<%=AppData.get(0).get("IS_URGENT")%>";

	frm.jsonData.value	= JSON.stringify(jsonData);
	frm.method	= "post";
	frm.target	= "_self";
	frm.action	= "http://portal.ncchem.co.kr/rest/login/external/ERP/ApprCommonDoc/page";
	
    self.moveTo(0,0); //창위치
    self.resizeTo(screen.availWidth, screen.availHeight); //창크기

	frm.submit();
}
</script>

<body onload="">

<form id="ncchApp" name="ncchApp" method="post" accept-charset="utf-8">
<div class="wrapPopup"  >
<input type="hidden" id="formNo"  name="formNo" value="<%=pr_no%>">
<input type="hidden"  id="optionApItem" name="optionApItem" value=""> 
  <div class="PopupTit">결재유형 선택 </div>
  <table  class="PopupSearchTableNoline mt10" width="100%">
	<colgroup>
      <col width="135px" />
      <col width="*" />
	</colgroup>
    <tr>        
      <th>결재 유형</th>
      <td>
      	<input type="hidden" name="jsonData">
		<input type="hidden" name="reqDataType" value="json">
		<select id="AP_ITEM" name="AP_ITEM" class="Select40">
			<%
			if(SessionComCodeOp.equals("KRNC-C0002") || SessionComCodeOp.equals("KRNCCH0003") || SessionComCodeOp.equals("KRNCCH0001") || SessionComCodeOp.equals("KRNC-C0001")){ 
			%>
				<option value="MM2">소모품 구매요청서(생산)</option>
				<option value="MM2">소모품 구매요청서(시약)</option>
				<option value="MM2">소모품 구매요청서(장비)</option>
				<option value="MM2">소모품 구매요청서(전산)</option>
				<option value="MM2">소모품 구매요청서(기타)</option>
			<%
			}else{
			%>
				<option value="MM2">소모품 구매요청서</option>
			<%
			}
			%>
			<option value="MM3">사무용품 신청서</option>
		</select>
      </td>
    </tr>
	</table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:sendUpdate();return false;">전송</button> 
  </div> 
</div><!-- wrapPopup 끝-->  
</form>

</body>

</html>
