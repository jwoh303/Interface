<%--
**********************************************
* 메뉴 : S/R > 홈
* 화면 : S/R 홈
* 기능 : 
* 프로그램 ID : PG_90_C_700_01
* 담당자 :  홍석규( 설계 : 공통 )
* 착수일 : 2014-08-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<!doctype html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %>
<%
String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
String year             = check_date.substring(0,4);
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}
%>
</head>

<body>
<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="masterHeader"/>
<c:param name="part" value="masterHeader"/>
<c:param name="upperId" value="${param.upperId}"/>
</c:import>
	<!--컨텐츠-->
    <div id="admin_home">
        <div id="main_table_div">
                <div ><img src="/resources/images/SR_bg.gif" alt="sr이미지" /></div>
                <div class="main_table_summ">
                  <p class="B3BTit">S/R 현황 [<%=year%>년<%=(check_date.substring(4,5).equals("0") ? check_date.substring(5,6) : check_date.substring(4,6))%>월<%=(check_date.substring(6,7).equals("0") ? check_date.substring(7,8) : check_date.substring(6,8))%>일 <font id="asd"  style="font-size:16px;"><!--시간--></font> 기준]<span>※ (&nbsp;)는 CMS건 입니다. </span></p>
                  <script>
	                    var clientms=new Date();
	                    var runTime = new Date();
	                    function runClock(){
	                     var clientnow=new Date();
	                     runTime.setTime(runTime.getTime()+(clientnow.getTime()-clientms.getTime()));
	                     clientms.setTime(clientnow.getTime());
	                     if (!document.layers && !document.all) return;
	                     var hours = runTime.getHours();
	                     var minutes = runTime.getMinutes();
	                     var seconds = runTime.getSeconds();
	                     if (minutes <= 9){
	                        minutes = "0" + minutes;
	                     }
	                     if (seconds <= 9){
	                        seconds = "0" + seconds;
	                     }
	                     // 타이머에 보여질 내용들
	                     movingtime = hours + ":" + minutes + ":" + seconds;
	                     // 레이어에 타이머를 써넣습니다
	                     if (document.layers) {
	                        document.layers.asd.document.write(movingtime);
	                        document.layers.asd.document.close();
	                     }
	                     else if (document.all) {
	                        asd.innerHTML = movingtime;
	                     }
	                     setTimeout("runClock()", 999);
	                    }
	                    runClock();
				</script>
                </div>
                <div class="wrap_tbl" >
                    <table class="t_masterMain07" summary="사업목표" >
                    	<colgroup>
                        	<col width="116px">
                            <col width="160px"><!--전체 S/R-->
                            <col width="85px"><!--결재대상-->
                            <col width="85px"><!--요청 S/R-->
                            <col width="85px"><!--접수 S/R-->
                            <col width="85px"><!--결재중 S/R-->
                            <col width="85px"><!--처리중 S/R-->
                            <col width="85px"><!--보류 S/R-->
                            <col width="130px"><!--완료 S/R-->
                            <col width="130px"><!--처리 S/R-->
                            <col width="100px"><!--취소 S/R-->
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="BGblue">S/R</th>
                                <th class="BGgreen">전체 S/R</th>
                                <th class="BGred">결재대상</th>
                                <th class="BGblue">요청 S/R</th>
                                <th class="BGblue">접수 S/R</th>
                                <th class="BGblue">결재중 S/R</th>
                                <th class="BGblue">처리중 S/R</th>
                                <th class="BGblue">보류 S/R</th>
                                <th class="BGblue">완료 S/R</th>
                                <th class="BGblue">처리 S/R</th>
                                <th class="BGblue">취소 S/R</th>
                            </tr>
                            
                        <thead>
                        <tbody>
                        	<tr>
                            	<th class="row" scope="row">전체 S/R현황</th>
                            	<td ><%=CommonUtil.formatNumber(rowData.get("ALL_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("ALL_SR_CMS"),true,0,3)%>)건</td>
                            	<td></td>
                            	<td><%=CommonUtil.formatNumber(rowData.get("GA_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("GA_SR_CMS"),true,0,3)%>)건</td>
                            	<td><%=CommonUtil.formatNumber(rowData.get("DS_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("DS_SR_CMS"),true,0,3)%>)건</td>
                            	<td><%=CommonUtil.formatNumber(rowData.get("GP_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("GP_SR_CMS"),true,0,3)%>)건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("PS_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("PS_SR_CMS"),true,0,3)%>)건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("PB_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("PB_SR_CMS"),true,0,3)%>)건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("GG_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("GG_SR_CMS"),true,0,3)%>)건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("PA_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("PA_SR_CMS"),true,0,3)%>)건</td>
                                <td class="last"><%=CommonUtil.formatNumber(rowData.get("GS_SR"),true,0,3)%> (<%=CommonUtil.formatNumber(rowData.get("GS_SR_CMS"),true,0,3)%>)건</td>
                           	</tr>
                            <tr>
                            	<th class="row" scope="row">개인 S/R현황</th>
                            	<td ><%=CommonUtil.formatNumber(rowData.get("PERSONAL_ALL_SR"),true,0,3)%>건</td>
                            	<td><%=CommonUtil.formatNumber(rowData.get("APPROVAL_TARGET"),true,0,3)%>건</td>
                            	<td><%=CommonUtil.formatNumber(rowData.get("PERSONAL_GA_SR"),true,0,3)%>건</td>
                            	<td><%=CommonUtil.formatNumber(rowData.get("PERSONAL_DS_SR"),true,0,3)%>건</td>
                            	<td><%=CommonUtil.formatNumber(rowData.get("PERSONAL_GP_SR"),true,0,3)%>건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("PERSONAL_PS_SR"),true,0,3)%>건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("PERSONAL_PB_SR"),true,0,3)%>건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("PERSONAL_GG_SR"),true,0,3)%>건</td>
                                <td><%=CommonUtil.formatNumber(rowData.get("PERSONAL_PA_SR"),true,0,3)%>건</td>
                                <td class="last"><%=CommonUtil.formatNumber(rowData.get("PERSONAL_GS_SR"),true,0,3)%>건</td>
                           	</tr>
                        </tbody>
                    </table>
				</div>
        	</div>      
    </div>
<!--내용 종료-->	       
<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>    
</div>
	
</body>
</html>			
