<%--
**********************************************
* 메뉴 : 
* 화면 : 하위조직코드 
* 기능 : 하위조직코드 선택 팝업
* 프로그램 ID : PG_03_M_002_04
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-06-19
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 

String buyer          		= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String buyer_item_no  	= CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String gubun  	= CommonUtil.nvl((String) request.getParameter("st_gubun"),"N");
String nu_i           		= CommonUtil.nvl((String) request.getParameter("st_nu_i"),"");
%>

<script type="text/javascript">

function setReturn(value1,value2,value3)
{ 
// 	if(value1 == "ALL"){
// 		value1 = "ABOVE";
// 	}
	opener.setPopupReturn(value1,value2,value3);
	this.close();
}

</script> 
<body onload="">
<form name="commonCoCoBottomOrgCodePop" id="commonCoCoBottomOrgCodePop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:244px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">하위조직코드 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:168px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>하위조직코드  리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">조직코드</th> 
                            <th scope="col">조직명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "110">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT")%>','<%=nu_i%>')">
							<%=_tmp.get("CODE")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT")%>','<%=nu_i%>')">
							<%=_tmp.get("TEXT")%></a>
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
