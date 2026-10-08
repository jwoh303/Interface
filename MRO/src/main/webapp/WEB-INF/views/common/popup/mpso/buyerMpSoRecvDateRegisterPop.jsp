<%--
**********************************************
* 메뉴 : 
* 화면 : 수령희망일 입력
* 기능 : 수령희망일 입력
* 프로그램 ID : 
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-08
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
 
%>

<script type="text/javascript">
<!--
 
function kep_onload_view(){
	
	kep_listkepSetCalender2("fromDate" , <%=_dataList.size()%> ); 
	
}

function calenderChange(){
	
}

function setOk(){
	
	var str = "";
	var str1 = "";
	var limit = "<%=_dataList.size()%>";
	
	for (var i=0; i<eval(limit); i++){ 
		str = str + $("#query"+i).val() + "|" +  $("#fromDate"+i).val().replace(/[/]/gi,"") + "@@";
		str1 = str1 + $("#BUYER_ITEM_NO"+i).val() + "|" +  $("#fromDate"+i).val().replace(/[/]/gi,".") + "@@";
	}
	//alert(str);
	
	opener.setRecvDateRegister(str , str1);
	self.close();
}
 //-->
</script> 
<body onload="kep_onload_view();">
<form name="buyerMpSoRecvDateRegisterPop" id="buyerMpSoRecvDateRegisterPop" method=post > 	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:450px;">
    	<div id="popHeader">
        	<h1 class="title">수령희망일 입력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

           	<!--grid-->
            <div class="scrollArea" style="height:260px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>수령희망일 리스트</caption>
                    <colgroup>
                        <col width="15%" />
                        <col width="60%" />    
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">품목코드</th> 
                            <th scope="col">품목명</th>
                            <th scope="col">수령희망일</th>    
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
						<td class="center">
						<input type="hidden" name="query" id="query<%=j%>" value="<%=_tmp.get("QUERY") %>" />
						<input type="hidden" name="query" id="BUYER_ITEM_NO<%=j%>" value="<%=_tmp.get("BUYER_ITEM_NO") %>" />
						&nbsp;<%=_tmp.get("BUYER_ITEM_NO")%>
						</td>
						<td class="left">
						&nbsp;<%=_tmp.get("DESCRIPTION_LOC")%>
						</td>
						<td class="center">
						<input type="text" class="input_type_text" name="fromDate" id="fromDate<%=j%>" size="10" readOnly  value="<%=CommonUtil.formatStrinigDate(_tmp.get("RD_DATE"))%>">
						</td>						
                        </tr> 
<% }
%> 
<%
}%>                               
                    </tbody>
                </table>                  
        </div>
        
                <div class="btnArea">
		<div class="fr">
			<span class="btn_03 mr04"><a href="javascript:setOk();">확인</a>
			</span>
		</div>
	</div>    
    </div>    
    

</div>
</form> 
</body>
</html>
