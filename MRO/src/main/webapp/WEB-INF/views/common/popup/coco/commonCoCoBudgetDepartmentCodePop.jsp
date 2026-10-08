<%--
**********************************************
* 메뉴 : 
* 화면 : 예산부서 코드
* 기능 : 
* 프로그램 ID : PG_90_C_900_27
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-04
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
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
String st_bdgt_dept_name = CommonUtil.nvl((String) request.getParameter("st_bdgt_dept_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String st_dept_type = CommonUtil.nvl((String) request.getParameter("dept_type"), "D");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kep_onload()
{  
	<% if ("Y".equals(open)){%>
	kepSearch(); 
  <%}%>
}

function kepSearch()
{  
  $('#commonCoCoBudgetDepartmentCodePop').attr("action", "/coco/getCommonCoCoBudgetDepartmentCodePop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3);
  this.close();
}
 //-->
</script> 
<body onload="kep_onload();">
<form name="commonCoCoBudgetDepartmentCodePop" id="commonCoCoBudgetDepartmentCodePop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=st_com_code%>">
<input type=hidden name="st_dept_type" id="st_dept_type" value="<%=st_dept_type%>">
<input type=hidden name="dept_type" id="dept_type" value="<%=st_dept_type%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">예산부서 코드</h1>
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
					<caption>예산부서 코드 리스트</caption>
					<colgroup>
						<col width="30%" />
                           <col width="*" />
					</colgroup>						
					<tbody>
						<tr>
							<td>부서명</td>
							<td> 
								<input type=text name=st_bdgt_dept_name id="st_bdgt_dept_name" size=40 value="<%=st_bdgt_dept_name%>" onkeydown="kepEnter()" class="input_type_text">
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
                    <caption>예산부서 코드 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" /> 
                        <col width="20%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">부서코드</th> 
                            <th scope="col">부서명</th> 
                            <th scope="col">건수</th> 
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
						 	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','<%=String.valueOf(_tmp.get("CNT"))%>')">
							<%=_tmp.get("CODE")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','<%=String.valueOf(_tmp.get("CNT"))%>')">
							<%=_tmp.get("TEXT1")%></a>
					   </td>
						<td class="left">
							<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','<%=String.valueOf(_tmp.get("CNT"))%>)">
							<%=String.valueOf(_tmp.get("CNT"))%></a>
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
