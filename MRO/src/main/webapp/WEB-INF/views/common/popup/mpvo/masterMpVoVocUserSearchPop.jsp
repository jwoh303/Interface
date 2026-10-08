<%--
**********************************************
* 메뉴 : 
* 화면 : 담당자 선택 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_800_12
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-15
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
String com_type	= CommonUtil.nvl((String) request.getParameter("com_type"),"");
String buyer		= CommonUtil.nvl((String) request.getParameter("buyer"),"");
String st_sys_type	= CommonUtil.nvl((String) request.getParameter("st_sys_type"),"");
String user_name	= CommonUtil.nvl((String) request.getParameter("user_name"),"");
%>

<script type="text/javascript">
// <!--
function kepSearch()
{  
  $('#masterMpVoVocUserSearchPop').attr("action", "/mpvo/getMasterMpVoVocUserSearchPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(user_id, user_name,com_code,user_phone, user_dept){ 
	var st_sys_type= $("#st_sys_type").val();
	var db_user_id  = "";
	opener.setPopupReturn(db_user_id, user_id, user_name, user_phone, user_dept, st_sys_type, com_code);
	this.close();
}
 //-->
</script> 
<body onload="">
<form name="masterMpVoVocUserSearchPop" id="masterMpVoVocUserSearchPop" method=post >
<input type="hidden" name="com_type" id="com_type"  value="<%=com_type%>">
<input type=hidden name="buyer" id="buyer"  value="<%=buyer%>">
<input type=hidden name="st_sys_type" id="st_sys_type"  value="<%=st_sys_type%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">담당자 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>담당자 선택 리스트</caption>
						<colgroup>
							<col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>담당자</td>
							<td> 
								<input type="text" name="user_name" id="user_name" size="20" maxlength="50" value="<%=user_name%>" onkeydown="kepEnter()" class="input_type_text">
								<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" /> 
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>담당자 선택 리스트</caption>
                    <colgroup>
                        <col width="40%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">담당자 ID</th> 
                            <th scope="col">담당자명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("USER_ID")%>','<%=_tmp.get("USER_NAME_LOC")%>','<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("PHONE_NUMBER")%>','<%=_tmp.get("DEPARTMENT")%>')">
							<%=_tmp.get("USER_ID")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("USER_ID")%>','<%=_tmp.get("USER_NAME_LOC")%>','<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("PHONE_NUMBER")%>','<%=_tmp.get("DEPARTMENT")%>')">
							<%=_tmp.get("USER_NAME_LOC")%></a>
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
