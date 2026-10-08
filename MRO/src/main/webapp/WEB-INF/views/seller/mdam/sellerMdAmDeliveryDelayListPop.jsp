<%--
**********************************************
* 메뉴 : 
* 화면 : 납품지연 고객사 선택
* 기능 : 
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-09-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
String search_flag = CommonUtil.nvl((String) request.getParameter("search_flag"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kep_onload_view(){
	<% if (!"Y".equals(search_flag)){ %>
		kepSearch();
	<% } %>
}

function kepSearch()
{  
  $('#sellerMdAmDeliveryDelayListPop').attr("action", "/mdam/getSellerMdAmDeliveryDelayListPop.do").submit();    
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
 //-->
</script> 
<body onload="kep_onload_view()">
<form name="sellerMdAmDeliveryDelayListPop" id="sellerMdAmDeliveryDelayListPop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=st_com_code%>">
<input type="hidden" name="search_flag" id="search_flag"  value="Y">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:404px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">납품지연 고객사 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:318px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>납품지연 고객사 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" /> 
                        <col width="20%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">고객사코드</th> 
                            <th scope="col">고객사명</th> 
                            <th scope="col">품목수</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("BUYER_CODE")%>','<%=_tmp.get("BUYER_NAME")%>','')">
							<%=_tmp.get("BUYER_CODE")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("BUYER_CODE")%>','<%=_tmp.get("BUYER_NAME")%>','')">
							<%=_tmp.get("BUYER_NAME")%></a>
					   </td>
						<td>
							<a href="javascript:setReturn('<%=_tmp.get("BUYER_CODE")%>','<%=_tmp.get("BUYER_NAME")%>','')">
							<%=CommonUtil.bnvl(_tmp.get("DEADLINE_CNT"))%></a>
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
