<%--
**********************************************
* 메뉴 : 
* 화면 : 발주부서 검색
* 기능 : 
* 프로그램 ID : PG_90_C_900_15
* 담당자 :  ( 설계 : 공통 )
* 착수일 : 2014-
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String req_dept_name = CommonUtil.nvl((String) request.getParameter("req_dept_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
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
  $('#commonCoCoOrderDepartmentSearchPop').attr("action", "/coco/getCommonCoCoOrderDepartmentSearchPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
 //-->
</script> 
<body onload="kep_onload()">
<form name="commonCoCoOrderDepartmentSearchPop" id="commonCoCoOrderDepartmentSearchPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --> <%=CommonLang.get("HTITLE511") %><!-- 검색 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>발주부서 검색 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="18%" />
							<col width="9%" />
							<col width="15%" />
							<col width="10%" />
                            <col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></td>
							<td> 
								<input type=text name=req_dept_name id="req_dept_name" size=20 value="<%=req_dept_name%>" onkeydown="kepEnter()" class="input_type_text">
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
            <div class="scrollArea" style="height:288px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>발주부서 검색 리스트</caption>
                    <colgroup>
                        <col width="15%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE380") %><!-- 부서코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE490") %><!-- 요약 부서명 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE491") %><!-- 상세 부서명 --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "230">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=_tmp.get("CODE")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=_tmp.get("TEXT1")%></a>
					   </td>
						<td class="left">
								<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=CommonUtil.nvl(_tmp.get("TEXT2"))%></a>
						</td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
        <div style="margin-top: 15px;"><%=CommonLang.get("HTITLE492") %><!-- ※ 발주부서가 없는 경우 관리자에게 문의하여 등록 바랍니다. --></div>
    </div>        
</div>
</form> 
</body>
</html>
