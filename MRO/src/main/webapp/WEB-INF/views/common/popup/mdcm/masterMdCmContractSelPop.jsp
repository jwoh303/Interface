<%--
**********************************************
* 메뉴 : 
* 화면 : 계약서 선택
* 기능 : 계약서 선택 팝업
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 권우재 )
* 착수일 : 2014-06-20
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
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String buyer     = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String nu_i     = CommonUtil.nvl((String) request.getParameter("nu_i"),"");
%>

<script type="text/javascript">
<!--
function setReturn(value1,value2,value3,value4,value5)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="masterMdCmContractSelPop" id="masterMdCmContractSelPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:244px;">
    	<div id="popHeader">
        	<h1 class="title">계약서 선택 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:168px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>계약서 선택  리스트</caption>
                    <colgroup>
                        <col width="15%" /> 
                        <col width="27%" /> 
                        <col width="13%" /> 
                        <col width="13%" /> 
                        <col width="10%" /> 
                        <col width="12%" /> 
                        <col width="10%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">계약서번호</th> 
                            <th scope="col">계약서명</th> 
                            <th scope="col">계약일</th> 
                            <th scope="col">계약종료일</th> 
                            <th scope="col">품목갯수</th> 
                            <th scope="col">등록자ID</th> 
                            <th scope="col">등록자명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="7" align="center" height = "110">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
					<tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("ADD_USER_ID")%>','<%=_tmp.get("ADD_USER_NAME")%>','<%=nu_i%>')">
							<%=_tmp.get("CONTRACT_NO")%></a>
						</td>
						<td class="left">
						 	<a href="javascript:setReturn('<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("ADD_USER_ID")%>','<%=_tmp.get("ADD_USER_NAME")%>','<%=nu_i%>')">
							<%=_tmp.get("CONTRACT_SUBJECT")%></a>
						</td>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("ADD_USER_ID")%>','<%=_tmp.get("ADD_USER_NAME")%>','<%=nu_i%>')">
							<%=CommonUtil.formatDate(_tmp.get("CONTRACT_DATE"), CommonUtil.YYYYMMDD)%></a>
						</td>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("ADD_USER_ID")%>','<%=_tmp.get("ADD_USER_NAME")%>','<%=nu_i%>')">
							<%=CommonUtil.formatDate(_tmp.get("CONTRACT_TO_DATE"), CommonUtil.YYYYMMDD)%></a>
						</td>
						<td class="right" style="padding-right: 10px;">
						 	<a href="javascript:setReturn('<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("ADD_USER_ID")%>','<%=_tmp.get("ADD_USER_NAME")%>','<%=nu_i%>')">
							<%=CommonUtil.formatNumber(_tmp.get("CONTRACT_SEQ"),true, 0, 0)%></a>
						</td>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("ADD_USER_ID")%>','<%=_tmp.get("ADD_USER_NAME")%>','<%=nu_i%>')">
							<%=_tmp.get("ADD_USER_ID")%></a>
						</td>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CONTRACT_NO")%>','<%=_tmp.get("CONTRACT_SEQ")%>','<%=_tmp.get("ADD_USER_ID")%>','<%=_tmp.get("ADD_USER_NAME")%>','<%=nu_i%>')">
							<%=_tmp.get("ADD_USER_NAME")%></a>
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
