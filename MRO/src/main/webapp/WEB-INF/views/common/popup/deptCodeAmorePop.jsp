<%--
**********************************************
* 메뉴 : 
* 화면 : 아모레 가입 시 부서코드 조회 (부서 검색)
* 기능 : 예산부서로 부서코드 조회 팝업
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2025-06-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과 
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String st_budget_dept_name = CommonUtil.nvl((String) request.getParameter("st_budget_dept_name"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kep_onload()
{  }

function setQuery()
{
	if(isEmpty($("#st_req_dept_name").val()) && isEmpty($("#st_req_dept_code").val()) && isEmpty($("#st_budget_dept_code").val()) && isEmpty($("#st_budget_dept_name").val())){
		//부서코드 또는 부서명을 한자 이상 입력 하세요.
		alert("<%=CommonLang.msg("MSG410") %>");
		$("#st_req_dept_name").focus();
		return;
	}
  $('#deptCodeAmorePop').attr("action", "/common/commonList.do").submit();
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3,"dept");
  this.close();
}
 //-->
</script> 
<body onload="kep_onload();">
	 <form name=deptCodeAmorePop id=deptCodeAmorePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAmorePop">
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE712") %><!-- 부서검색 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>부서검색 리스트</caption>
						<colgroup>
							<col width="9%" />
							<col width="13%" />
							<col width="8%" />
							<col width="20%" />
							<col width="9%" />
							<col width="13%" />
							<col width="8%" />
							<col width="20%" />
						</colgroup>						
						<tbody>
						<tr>
							<td class="center"><%=CommonLang.get("HTITLE568") %><!-- 예산부서코드 --></td>
							<td> 
								<input type=text name=st_budget_dept_code id="st_budget_dept_code" style="width:90%" value="" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td  class="center"><%=CommonLang.get("HTITLE420") %><!-- 예산부서명 --></td>	
							<td> 
								<input type=text name=st_budget_dept_name id="st_budget_dept_name" style="width:90%" value="<%=st_budget_dept_name%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                            <td class="center">펀드센터코드</td>
							<td> 
								<input type=text name=st_req_dept_code id="st_req_dept_code" style="width:90%" value="" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td class="center">펀드센터명</td>	
							<td> 
								<input type=text name=st_req_dept_name id="st_req_dept_name" style="width:90%" value="<%=st_req_dept_name%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:348px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서검색 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="30%" /> 
                        <col width="20%" /> 
                        <col width="30%" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE568") %><!-- 예산부서코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE420") %><!-- 예산부서명 --></th> 
                            <th scope="col">펀드센터코드</th>
                            <th scope="col">펀드센터명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "280">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=rowData.get("FUND_CENTER_CODE")%>','<%=rowData.get("FUND_CENTER_NAME")%>')">
							<%=rowData.get("BUDGET_DEPT_CODE")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=rowData.get("FUND_CENTER_CODE")%>','<%=rowData.get("FUND_CENTER_NAME")%>')">
							<%=rowData.get("BUDGET_DEPT_NAME")%></a>
					   </td>
						<td class="left">
								<a href="javascript:setReturn('<%=rowData.get("FUND_CENTER_CODE")%>','<%=rowData.get("FUND_CENTER_NAME")%>')">
							<%=CommonUtil.nvl(rowData.get("FUND_CENTER_CODE"))%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=rowData.get("FUND_CENTER_CODE")%>','<%=rowData.get("FUND_CENTER_NAME")%>')">
							<%=rowData.get("FUND_CENTER_NAME")%></a>
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
