<%--
**********************************************
* 메뉴 : 통계>기타통계>회원사 통계
* 화면 : 회원사 통계
* 기능 : 그룹별 고객사 수를 집계하여 보여주는 화면
* 프로그램 ID : PG_90_C_600_09
* 담당자 : 홍석규   - CEJ ( 설계 : 공통 )
* 착수일 : 2014-08-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%

//고객사현황 조회
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridListG = (List<Map<String,String>>) request.getAttribute("dataG"); // 조회된 결과 그룹
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridListT = (List<Map<String,String>>) request.getAttribute("dataT"); // 조회된 결과 팀
@SuppressWarnings (value="unchecked")
Map<String,String> _dataM = (Map<String,String>) request.getAttribute("dataM"); // 조회된 결과

@SuppressWarnings (value="unchecked")
Map<String,String> _dataGSUM = (Map<String,String>) request.getAttribute("dataGSUM"); // 조회된 결과 (그룹합계)
@SuppressWarnings (value="unchecked")
Map<String,String> _dataTSUM = (Map<String,String>) request.getAttribute("dataTSUM"); // 조회된 결과 (팀합계)


//협력사현황 조회
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridListS = (List<Map<String,String>>) request.getAttribute("dataS"); // 조회된 결과 신용등급
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridListL = (List<Map<String,String>>) request.getAttribute("dataL"); // 조회된 결과 유통레벨
@SuppressWarnings (value="unchecked")
Map<String,String> _dataBIZ = (Map<String,String>) request.getAttribute("dataBIZ"); // 조회된 결과

@SuppressWarnings (value="unchecked")
Map<String,String> _dataLSUM = (Map<String,String>) request.getAttribute("dataLSUM"); // 조회된 결과 (유통레벨합계)
@SuppressWarnings (value="unchecked")
Map<String,String> _dataSSUM = (Map<String,String>) request.getAttribute("dataSSUM"); // 조회된 결과 (신용등급합계)







String openYn = CommonUtil.nvl((String) request.getParameter("openYn"),"");    

%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() { 
	
	<% if ("".equals(openYn)){ %>
	doAction('search1');
	<%}%>
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) { 
	case "search1":	 // 조회
		 
		$('#searchCondition').attr("action", "/mpst/getMasterMpStCmpyStatsList.do").submit();   
		break;
		 
	
	case "excelDown":	 // 조회
	
	
		document.forms.searchCondition.action = "/mpst/searchExcelMasterMpStCmpyStatsList.do";
		document.forms.searchCondition.submit();
		 
		break;
		
	}
	 

}
	 
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" id="openYn" name="openYn" value="N">
			<!-- 화면 내 정의 -->
		</form>

       	<div id="searchBtnA"  >
			<h3>고객사 현황</h3>
   		</div>         	
   		
   		<div class="scrollArea" style="width:100%;height:270px">
   		<table  class="cont_t_list02"  style="width:1000px">
   		
   		<%
   		Map<String, String> _dateMapG = null;
   		int i = 0;
   		int j=0;
   		String CODE = "";
   		if (_gridListG != null) {
   		for (i=0; i<=_gridListG.size(); i++) { 
   			if (i==0){
   		%>
   		<tr>
   			<th width="150px">구분</th>
   		<%
   			}else{
   			_dateMapG = _gridListG.get(i-1); %>
   			<td width="150px"><%=_dateMapG.get("GROUP_NAME")%></td> 
 		   		<% 		   	
   			}
			   		Map<String, String> _dateMapT = null;
			   		for (j=0; j<_gridListT.size(); j++) { 
			   			_dateMapT = _gridListT.get(j); 
			   			if (i==0){
			   			%>
			   			<th width="100px"><%=_dateMapT.get("TEXT1")%></th> 			   		
	 				<%} else { 
	 					CODE = _dateMapT.get("CODE");
	 				%>
	 						<td width="100px" class="right"><%=CommonUtil.formatNumber(CommonUtil.nvl( _dataM.get(_dateMapG.get("GROUP_CODE")+"_"+CODE),"0"),true,0,3)%></td>
	 				<%} %> 			
	 			
	 				<%} %>
	 				
	 					<% if (i==0){ %>
	 					<th width="150px">합계</th>
	 				<%}else{ %>
	 					<td width="150px" class="right"><font color="black"><b><%=CommonUtil.formatNumber(CommonUtil.nvl( _dataGSUM.get("GROUPSUM_"+_dateMapG.get("GROUP_CODE")),"0"),true,0,3)%></b></font></td>
	 				
 					<%} %>
   				</tr>
   		<%} %> 
 		<%} %> 
 		</table>
 		</div>
 		<% if (_gridListT != null) { %>
 		<table  style="width:1000px">
 		   		<tr>
   			<td width="150px" align="center"><font color="black"><b>합계</b></font></td>
   		<%
   		Map<String, String> _dateMapT2 = null;
	   		for (j=0; j<_gridListT.size(); j++) { 
	   			_dateMapT2 = _gridListT.get(j); 
   		%>
   				<td width="100px" align="right">	<font color="black"><b><%=CommonUtil.formatNumber(CommonUtil.nvl( _dataTSUM.get("TEAMSUM_"+_dateMapT2.get("CODE")),"0"),true,0,3)%></b></font>&nbsp;&nbsp;&nbsp;</td> 
   		<%
	   		}
   		%>
   		<td width="150px" align="right">	<font color="black"><b><%=CommonUtil.formatNumber(CommonUtil.nvl( _dataTSUM.get("GROUPSUM_TOTSUM"),"0"),true,0,3)%></b></font>&nbsp;&nbsp;</td> 
   		</tr>
 		</table>
 		<%} %>
		<br>
		<div id="searchBtnA"  >
			<h3>협력사 현황</h3>
   		</div>         	
      	<!--grid-->
   		<div class="scrollArea" style="width:100%;height:270px">
   		<table  class="cont_t_list02"  style="width:1000px">
   		<%
   		Map<String, String> _dateMapBizL = null;
   		int i2 = 0;
   		int j2 = 0;
   		String BIZCODE = "";
   		if (_gridListL != null) {
   		for (i2=0; i2<=_gridListL.size(); i2++) { 
   			if (i2==0){
   		%>
   		<tr>
   			<th width="150px">구분</th>
   		<%
   			}else{
   				_dateMapBizL = _gridListL.get(i2-1); %>
   			<td width="150px"><%=_dateMapBizL.get("TEXT1")%></td> 
 		   		<% 		   	
   			}
			   		Map<String, String> _dateMapS = null;
			   		for (j2=0; j2<_gridListS.size(); j2++) { 
			   			_dateMapS = _gridListS.get(j2); 
			   			if (i2==0){
			   			%>
			   			<th width="100px"><%=_dateMapS.get("CREDIT_STATUS")%></th> 			   		
	 				<%} else { 
	 					CODE = _dateMapS.get("CREDIT_STATUS_CODE");
	 				%>
	 						<td width="100px" class="right">	<%=CommonUtil.formatNumber(CommonUtil.nvl( _dataBIZ.get(CODE+"_"+_dateMapBizL.get("CODE")),"0"),true,0,3)%></td>
	 				<%} %> 			
	 			
	 				<%} %>
	 				
	 					<% if (i2==0){ %>
	 					<th width="150px">합계</th>
	 				<%}else{ %>
	 					<td width="150px" class="right"><font color="black"><b><%=CommonUtil.formatNumber(CommonUtil.nvl( _dataLSUM.get("BIZ_TYPE_"+_dateMapBizL.get("CODE")),"0"),true,0,3)%></b></font></td>
	 				
 					<%} %>
   				</tr>
   		<%} %>
   		<tr>
   			<td><font color="black"><b>합계</b></font></td>
   		<%
   		
   		System.out.println("_gridListS.size() "+_gridListS.size());
   		Map<String, String> _dateMapS2 = null;
	   		for (j2=0; j2<_gridListS.size(); j2++) { 
	   			_dateMapS2 = _gridListS.get(j2);  
   		%>
   				<td width="100px" class="right">	<font color="black"><b><%=CommonUtil.formatNumber(CommonUtil.nvl( _dataSSUM.get("CREDIT_STATUS_"+_dateMapS2.get("CREDIT_STATUS_CODE")),"0"),true,0,3)%></b></font></td> 
   		<%
	   		}
   		%>
   		<td width="100px" class="right">	<font color="black"><b><%=CommonUtil.formatNumber(CommonUtil.nvl( _dataSSUM.get("CREDIT_STATUS_TOTSUM"),"0"),true,0,3)%></b></font></td> 
   		</tr>
   		
 		<%} %> 
 		</table>
 
		</div>
  			  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  			 </div>
<!--내용 종료-->	                 

</body>
</html>
