<%--
**********************************************
* 메뉴 : 장바구니
* 화면 : 주문확인
* 기능 : 큐라티스 그룹웨어로 결재 상신 정보를 전송하고, 팝업을 호출한다.
* 프로그램 ID : 
* 담당자 : 최진수
* 착수일 : 2022-06-13
**********************************************
--%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.AES128_Encode"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<%@ include file="../../common/include/head.jspf"  %>
<%
String empNo = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	empNo	= CommonUtil.nvl((String)sessionInfo.getEmpNo());
}


DecimalFormat decFormat = new DecimalFormat("###,###");

String tot_price = request.getParameter("Extern_TOT_PRICE").replaceAll("\\,","");
System.out.println("tot_price : " + tot_price);

//int Itot_price = Integer.parseInt(tot_price.trim()) * 110/100; // 부가세 포함 총 금액
int tot_amt = Integer.parseInt(tot_price.trim());   // 부가세 별도 총 금액
int tot_vat = Integer.parseInt(tot_price.trim()) * 10/100; // 부가세
int Itot_price = tot_amt + tot_vat;

List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("qura_data");
System.out.println("qura_data : " + _gridList);

String _buyer=request.getParameter("Extern_BUYER");
String _pr_no=request.getParameter("Extern_PR_NO");
String approKey = _buyer + _pr_no;
String formId = "";
String appSubject = "";

int rec_cnt = _gridList.size();
String httlEnc = "";
String key = "1023497555960596";
String strEnc = "";

String bizboxUrl ="";
Map<String, String> p110000004_map = CommonUtil.getSpecialCheckReturnMap(_buyer,"P11-0000004");
if (p110000004_map != null){
	bizboxUrl = CommonUtil.nvl(p110000004_map.get("COL02_DATA"),""); // 관리번호 표기
}

try {
	LocalDateTime now = LocalDateTime.now();
	DateTimeFormatter fm = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
	String nTime = now.format(fm);	
	String str = nTime + "▦" + empNo;	// 현재시간 + ▦ + 사번

	strEnc = AES128_Encode.encode(str, key, "UTF-8");
	httlEnc = URLEncoder.encode(strEnc,"UTF-8");
	
	if ( rec_cnt > 0 ) {
		formId = _gridList.get(0).get("FORM_ID");
		appSubject = _gridList.get(0).get("APP_SUBJECT");
	}
/*	
	System.out.println("Time:" + nTime);
	System.out.println("empNo:" + empNo);
	System.out.println("str:" + str);
	System.out.println("strEnc:" + strEnc);
	System.out.println("httlEnc:" + httlEnc);
*/
} catch (Exception e) {
	System.out.println("qura_Error : " + e.getMessage());
}


%>
<!DOCTYPE html>
<html>
<body>
<!-- start container -->

<div class="container" style="visibility:hidden;">
    <!-- 테스트 오피스 설정 -->
    <!-- http://211.46.82.222/gw/uat/uia/egovLoginUsr.do -->
    <!-- http://211.46.82.222/gw/outProcessEncLogOn.do -->
    <!-- http://211.46.82.222/gw/userMain.do -->
    <form
            action="<%=bizboxUrl %>"
            method="post"
            target="_self"
            name = "contentForm" 
            id="contentForm"
    >
    	<input type="hidden" name="subjectStr" id="subjectStr" value="<%=appSubject%>">
    	<input type="hidden" name="compSeq" id="compSeq" value="1000">
    	<input type="hidden" name="approKey" id="approKey" value="<%=approKey%>">	<!-- buyer+pr -->
    	<input type="hidden" name="outProcessCode" id="outProcessCode" value="KEP">	<!-- KEP -->
    	<input type="hidden" name="formId" id="formId" value="<%=formId%>">
    	<input type="hidden" name="loginId" id="loginId" value="<%=strEnc%>">
    	<input type="hidden" name="empSeq" id="empSeq" value="">
    	<input type="hidden" name="erpSeq" id="erpSeq" value="">
    	<input type="hidden" name="aesKey" id="aesKey" value="<%=key%>">
    	<input type="hidden" name="fileKey" id="fileKey" value="">	<!-- 필드 지정 여부 확인. KEP에서 필요없음. -->
    	<input type="hidden" name="mod" id="mod" value="W">
    	<input type="hidden" name="contentsEnc" id="contentsEnc" value="">
    	<input type="hidden" name="contentsType" id="contentsType" value="outer">
    	<input type="hidden" name="appLineList" id="appLineList" value="">	<!-- 필드 지정 여부 확인. KEP에서 필요없음. -->
    	<input type="hidden" name="receiveList" id="receiveList" value="">	<!-- 필드 지정 여부 확인. KEP에서 필요없음. -->
    	<input type="hidden" name="itemList" id="itemList" value="">	<!-- 필드 지정 여부 확인. KEP에서 필요없음. -->
                <input
                        type="text"
                        class="form-control"
                        id="contentsStr"
                        name="contentsStr"
                        value="<div id='hw_dext_default_style'><div style='margin: 0px; padding: 0px; font-family: 맑은 고딕; font-size: 10px; line-height: 1.8;'>
            <h1 style='text-align: left padding: 30px 0px; font-size: 13px; font-family: 맑은 고딕; line-height: 1.8;'> <%=_pr_no%> 관련하여 아래와 같이 품의 드리오니 재가하여 주시기 바랍니다. </h1>
        
            <h2 style='text-align: center; padding: 30px 0px; font-size: 13px; font-family: 맑은 고딕; line-height: 1.8;'> - 아  래 - </h2>
            
            <p style='font-family: 맑은 고딕; font-size: 12px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;' align=left>1. 총 금액 : <%= decFormat.format(Itot_price) %> 원 (V.A.T 포함)</p>
            <br>
            
            <p style='font-family: 맑은 고딕; font-size: 12px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;' align=left>2. 상세내역</p>
            
            <table style='border:1px rgb(0, 0, 0);width:100%;font-size:16px;border-collapse:collapse;margin:0px;' border='1' cellspacing='0' cellpadding='0' class='' mapping_key=''>
            
             <tr>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 40px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>No.</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 90px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>품목코드</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 140px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>품목명</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 90px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>단가</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 40px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>단위</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 40px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>수량</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 100px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>발주금액<br>(V.A.T 별도)</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 120px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>계정명</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 140px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>규격</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 100px;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'>제조사</p>
	              </td>
              </tr>
              <% 
              Map<String,String> rowData = null;
              
              for (int j=0; j<rec_cnt; j++) { 
            	  rowData = _gridList.get(j);
              %>
              <tr>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 40px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= j+1 %></p>
	              </td>
	              <td style='padding: 10px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 90px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("BUYER_ITEM_NO") %></p>
	              </td>
	              <td style='padding: 10px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 140px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("DESCRIPTION") %></p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 90px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("TARGET_PRICE") %> 원</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 40px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("UNIT_MEASURE") %></p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 40px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("TARGET_QTY") %></p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 100px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("TOTAL_AMT") %> 원</p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center;  width: 120px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("REF_PR_NO") %></p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 140px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("SPECIFICATION") %></p>
	              </td>
	              <td style='padding: 10px 0px; border: 1px solid rgb(0, 0, 0); text-align: center; width: 100px;'>
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><%= rowData.get("MAKER_NAME") %></p>
	              </td>
              </tr>
              <% } %>
              <tr>
              	<td colspan='10' style='padding: 10px 0px; padding-left: 50px; border: 1px solid rgb(0, 0, 0); text-align: right;' >
	               <p style='font-family: 맑은 고딕; font-size: 10px; line-height: 1.8; margin-top: 0px; margin-bottom: 0px;'><strong><%=decFormat.format(tot_amt)%>원 (총 공급가액) + <%=decFormat.format(tot_vat)%>원 (부가세) = <%= decFormat.format(Itot_price) %> 원 (총 금액)</strong>&nbsp;&nbsp;&nbsp;</p>
	            </td>
              </tr>
            </table>
            <br>
          </div></div>"/>

        <div class="form-group row">
            <div class="col-sm-10">
                <button type="submit" class="btn btn-primary btn-sm">기안</button>
            </div>
        </div>
    </form>
</div>
<!-- end container -->
<script
        src="https://code.jquery.com/jquery-3.3.1.min.js"

></script>
<script>

this.document.getElementById("contentForm").submit();

</script>
</body>
</html>