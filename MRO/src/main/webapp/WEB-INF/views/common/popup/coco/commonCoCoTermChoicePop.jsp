<%--
**********************************************
* 메뉴 : 
* 화면 : 기간선택
* 기능 : 
* 프로그램 ID : PG_90_C_900_12
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-04
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
String ROW = request.getParameter("st_row");
String st_gubun_code = CommonUtil.nvl((String) request.getParameter("st_gubun_code"),"");  //  (조회조건)

List<Map<String, String>> _dataList = new ArrayList<Map<String,String>>();
Map<String, String> rowMap = null;

if("year".equals(st_gubun_code)){				// 년
	int toYear = DateTimeUtil.getYear() - 9;
	for(int inx = 0 ; inx < 11 ; inx ++){
		rowMap = new HashMap<String, String>();
		rowMap.put("TERM", String.valueOf(toYear+inx));
		rowMap.put("FROMDATE", String.valueOf(toYear+inx) + "0101");
		rowMap.put("TODATE", String.valueOf(toYear+inx) + "1231");
		rowMap.put("TERM_TEXT", String.valueOf(toYear+inx) + "년도");
		_dataList.add(rowMap);
	}
}else if("half".equals(st_gubun_code)){			// 반기
	int toYear = DateTimeUtil.getYear();
	for(int inx = 0 ; inx < 2 ; inx ++){
		rowMap = new HashMap<String, String>();
		rowMap.put("TERM", String.valueOf(toYear)+"H"+String.valueOf(inx+1));
		if(inx == 0){
			rowMap.put("FROMDATE", String.valueOf(toYear) + "0101");
			rowMap.put("TODATE", String.valueOf(toYear) + "0630");
			rowMap.put("TERM_TEXT", String.valueOf(toYear) + "년도 상반기");
		}else{
			rowMap.put("FROMDATE", String.valueOf(toYear) + "0701");
			rowMap.put("TODATE", String.valueOf(toYear) + "1231");
			rowMap.put("TERM_TEXT", String.valueOf(toYear) + "년도 후반기");
		}
		_dataList.add(rowMap);
	}
}else if("quarter".equals(st_gubun_code)){		// 분기
	int toYear = DateTimeUtil.getYear();
	for(int inx = 0 ; inx < 4 ; inx ++){
		rowMap = new HashMap<String, String>();
		rowMap.put("TERM", String.valueOf(toYear)+"Q"+String.valueOf(inx+1));
		if(inx == 0){
			rowMap.put("FROMDATE", String.valueOf(toYear) + "0101");
			rowMap.put("TODATE", String.valueOf(toYear) + "0331");
			rowMap.put("TERM_TEXT", String.valueOf(toYear) + "년도 1/4분기");
		}else if(inx == 1){
			rowMap.put("FROMDATE", String.valueOf(toYear) + "0401");
			rowMap.put("TODATE", String.valueOf(toYear) + "0630");
			rowMap.put("TERM_TEXT", String.valueOf(toYear) + "년도 2/4분기");
		}else if(inx == 2){
			rowMap.put("FROMDATE", String.valueOf(toYear) + "0701");
			rowMap.put("TODATE", String.valueOf(toYear) + "0930");
			rowMap.put("TERM_TEXT", String.valueOf(toYear) + "년도 3/4분기");
		}else{
			rowMap.put("FROMDATE", String.valueOf(toYear) + "1001");
			rowMap.put("TODATE", String.valueOf(toYear) + "1231");
			rowMap.put("TERM_TEXT", String.valueOf(toYear) + "년도 4/4분기");
		}
		_dataList.add(rowMap);
	}
}else {													// 월
	int toYear = DateTimeUtil.getYear();
	
	rowMap = new HashMap<String, String>();
	rowMap.put("TERM", String.valueOf(toYear-1)+CommonUtil.lpad("12", 2, '0'));
	rowMap.put("FROMDATE", String.valueOf(toYear-1) + "1201");
	rowMap.put("TODATE", String.valueOf(toYear-1) + "1231");
	rowMap.put("TERM_TEXT", String.valueOf(toYear-1) + "년도 12월");
	_dataList.add(rowMap);
	
	
	for(int inx = 0 ; inx < 12 ; inx ++){
		// 실질적 마지막 날 추출용
		Calendar cal = Calendar.getInstance();
		cal.set(toYear, inx, 1); // 해당 연도, 해당 달-1, 아무 날짜로  설정(마지막 날을 구하고 싶은거라, 달은 0~11로 되어 있음)

		rowMap = new HashMap<String, String>();
		rowMap.put("TERM", String.valueOf(toYear)+CommonUtil.lpad(String.valueOf(inx+1), 2, '0'));
		rowMap.put("FROMDATE", String.valueOf(toYear) + CommonUtil.lpad(String.valueOf(inx+1), 2, '0') +"01");
		rowMap.put("TODATE", String.valueOf(toYear) + CommonUtil.lpad(String.valueOf(inx+1), 2, '0') + String.valueOf(cal.getActualMaximum(Calendar.DAY_OF_MONTH)));
		rowMap.put("TERM_TEXT", String.valueOf(toYear) + "년도 " + String.valueOf(inx+1) + "월");
		_dataList.add(rowMap);
	}
	rowMap = new HashMap<String, String>();
	rowMap.put("TERM", String.valueOf(toYear+1)+CommonUtil.lpad("1", 2, '0'));
	rowMap.put("FROMDATE", String.valueOf(toYear+1) + "0101");
	rowMap.put("TODATE", String.valueOf(toYear+1) + "0131");
	rowMap.put("TERM_TEXT", String.valueOf(toYear+1) + "년도 1월");
	_dataList.add(rowMap);
}



%>

<script type="text/javascript">
<!--
function setReturn(term,fromdate,todate,row,term_text)
{ 
  opener.setPopupReturn(term,fromdate,todate,row,term_text);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoTermChoicePop" id="commonCoCoTermChoicePop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:294px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE720") %><!-- 기간선택 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:218px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>기간선택 리스트</caption>
                    <colgroup>
                        <col width="40%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE533") %><!-- 구분명 --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList != null && _dataList.size() > 0){
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td>
							 	<a href="javascript:setReturn('<%=_tmp.get("TERM")%>','<%=_tmp.get("FROMDATE")%>','<%=_tmp.get("TODATE")%>','<%=ROW%>','<%=_tmp.get("TERM_TEXT")%>');">
								<%=_tmp.get("TERM")%></a>
							</td>
							<td>
							  	<a href="javascript:setReturn('<%=_tmp.get("TERM")%>','<%=_tmp.get("FROMDATE")%>','<%=_tmp.get("TODATE")%>','<%=ROW%>','<%=_tmp.get("TERM_TEXT")%>');">
								<%=_tmp.get("TERM_TEXT")%></a>
						   </td>
						</tr> 
<% } 
}%>
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
