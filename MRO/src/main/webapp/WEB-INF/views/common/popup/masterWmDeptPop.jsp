<%--
**********************************************
* 메뉴 : 
* 화면 : 발주부서 검색
* 기능 : 
* 프로그램 ID : PG_90_C_900_15
* 담당자 :  ( 설계 : 공통 )
* 착수일 : 2014-8-4
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String st_dept_name = CommonUtil.nvl((String) request.getParameter("st_dept_name"),"");  //  (조회조건)
%>

<script type="text/javascript">

function kepSearch()
{  
  if($("#st_dept_name").val() == ""){
	  alert("부서명 입력 바랍니다.");
	  return;
  }
  $('#masterWmDept').attr("action", "/common/commonList.do").submit();    
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
</script> 
<body >
<form name="masterWmDept" id="masterWmDept" method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="masterWmDeptPop"> 	
	 <input type="hidden" id="st_com_code"  name="st_com_code" value="${sessionInfo.comCode}">
	 <input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"") %>" >
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:480px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE881")%><!-- 부서 검색 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA" style="height:100%;">
            	<table class="cont_t_list01" >
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
							<td><%=CommonLang.get("HTITLE323")%><!-- 부서명 --></td>
							<td> 
								<input type=text name="st_dept_name" id="st_dept_name" size=20  value="<%=st_dept_name %>"onkeydown="kepEnter()" class="input_type_text">
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>    
           	<!--grid-->
            <div class="scrollArea" style="height:315px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서 검색 리스트</caption>
                    <colgroup>
                        <col width="15%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE380")%><!-- 부서코드 --></th> 
						<th class="al"><%=CommonLang.get("HTITLE490")%><!-- 요약 부서명 --></th> 
						<th class="al"><%=CommonLang.get("HTITLE491")%><!-- 상세 부서명 --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "230">
                        <span class="font1"><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
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
						<td class="al">
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=_tmp.get("TEXT1")%></a>
					   </td>
						<td class="al">
								<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>')">
							<%=CommonUtil.nvl(_tmp.get("TEXT2"))%></a>
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
