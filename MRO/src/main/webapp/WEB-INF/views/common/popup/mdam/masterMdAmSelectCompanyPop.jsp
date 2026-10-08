<%--
**********************************************
* 메뉴 : 
* 화면 : 선택 회원사
* 기능 : 선택회원사 조회 팝업
* 프로그램 ID : 
* 담당자 : 홍석규 
* 착수일 : 2014-10-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
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
function popupOnload(){
}

 //-->
</script> 
<body onload="popupOnload()">
<form name="masterMdAmSelectCompanyPop" id="masterMdAmSelectCompanyPop" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:244px;">
    	<div id="popHeader">
        	<h1 class="title">선택 회원사</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
           	<!--grid-->
            <div class="scrollArea" style="height:330px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>선택 회원사 리스트</caption>
                    <colgroup>
                        <col width="5%" />
                        <col width="15%" />
						<col width="25%" />
						<col width="40%" />
						<col width="15%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">순번</th>
                            <th scope="col">회원사코드</th> 
                            <th scope="col">회원사명</th> 
                            <th scope="col">주소</th> 
                            <th scope="col">사업자코드</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "133">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td>
								<%=(j+1)%>
							</td>
							<td>
								<%=CommonUtil.nvl(_tmp.get("COM_CODE"))%>
							</td>
							<td class="left" >
								<%=CommonUtil.nvl(_tmp.get("COM_NAME_LOC"))%>
							</td>
							<td class="left" >
								<%=CommonUtil.nvl(_tmp.get("ADDRESS_LOC"))%>
						   </td>
						   <td class="left" >
								<%=CommonUtil.nvl(_tmp.get("IRS_NO"))%>
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
