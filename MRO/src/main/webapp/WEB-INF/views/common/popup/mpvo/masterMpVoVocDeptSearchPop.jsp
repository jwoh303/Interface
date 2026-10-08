<%--
**********************************************
* 메뉴 : 
* 화면 : 건설사현장 팝업
* 기능 : 건설사현장 팝업
* 프로그램 ID : PG_90_C_800_13
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

String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String st_req_dept_name=  CommonUtil.nvl((String) request.getParameter("st_req_dept_name"), "");
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#masterMpVoVocDeptSearchPop').attr("action", "/mpvo/getMasterMpVoVocDeptSearchPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2,value3,value4)
{ 
  opener.setPopupReturn(value1,value2,value3,value4);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="masterMpVoVocDeptSearchPop" id="masterMpVoVocDeptSearchPop" method=post >
<input type="hidden" name="com_code" value="<%=com_code%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">건설사현장</h1>
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
						<caption>건설사현장 리스트</caption>
						<colgroup>
							<col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>현장명</td>
							<td> 
								<input type="text" name="st_req_dept_name" id="st_req_dept_name" size=20 value="<%=st_req_dept_name%>" onkeydown="kepEnter()" class="input_type_text">
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
                    <caption>건설사현장 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="20%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">회원사명</th> 
                            <th scope="col">현장부서코드</th> 
                            <th scope="col">현장부서명</th> 
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
						<td class="left">
						 	<a href="javascript:setReturn('<%=_tmp.get("COMPANY_CODE")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=_tmp.get("COM_NAME_LOC")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("COMPANY_CODE")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=_tmp.get("CODE")%></a>
					   </td>
						<td class="left">
							<a href="javascript:setReturn('<%=_tmp.get("COMPANY_CODE")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=CommonUtil.nvl(_tmp.get("TEXT1"))%></a>
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
