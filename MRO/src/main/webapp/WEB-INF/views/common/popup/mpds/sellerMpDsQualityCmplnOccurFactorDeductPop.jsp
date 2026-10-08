<%--
**********************************************
* 메뉴 : 
* 화면 : 품질불만 발생요인별 감점
* 기능 : 품질검사 감점기준표 팝업
* 프로그램 ID : PG_07_A_011_02
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
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
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#sellerMpDsQualityCmplnOccurFactorDeductPop').attr("action", "/mpds/getSellerMpDsQualityCmplnOccurFactorDeductPop.do").submit();    
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
<body onload="">
<form name="sellerMpDsQualityCmplnOccurFactorDeductPop" id="sellerMpDsQualityCmplnOccurFactorDeductPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">품질불만 발생요인별 감점</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>품질불만 발생요인별 감점 리스트</caption>
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
							<td>검색어</td>
							<td> 
								<input type=text name=st_req_dept_name id="st_req_dept_name" size=20 value="<%=st_req_dept_name%>" onkeydown="kepEnter()" class="input_type_text"> 
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
                    <caption>품질불만 발생요인별 감점 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">부서코드</th> 
                            <th scope="col">요약 부서명</th> 
                            <th scope="col">상세 부서명</th> 
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
						 	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=_tmp.get("CODE")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=_tmp.get("TEXT1")%></a>
					   </td>
						<td>
								<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
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
