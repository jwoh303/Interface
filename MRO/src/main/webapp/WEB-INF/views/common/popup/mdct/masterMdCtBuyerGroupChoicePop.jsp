<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 법인그룹 선택
* 기능 : 
* 프로그램 ID : PG_01_M_016_03
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String st_group_name = CommonUtil.nvl((String) request.getParameter("st_group_name"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kepSearch() {
	$('#masterMdctBuyerCorpGroupPop').attr("action", "/mdct/getMasterMdCtBuyerGroupChoicePop.do").submit();
}

function doAction(str) {
	st = new Date();
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch();
			break;
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}


function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}
//-->
</script> 
<body onload="">
<form name="masterMdctBuyerCorpGroupPop" id="masterMdctBuyerCorpGroupPop" method="post" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
		<div id="popHeader">
			<h1 class="title">고객사그룹선택</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>고객사그룹선택</caption>
						<colgroup>
							<col width="10%" />
							<col width="90%" />
						</colgroup>						
						<tbody>
						<tr>
							<td>검색어</td>
							<td> 
								<input type="text" name="st_group_name" id="st_group_name" size=20  value="<%=st_group_name%>" onkeydown="kepEnter()" class="input_type_text" /> 
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
                    <caption>고객사법인선택</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="30%" />
                        <col width="20%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">그룹코드</th> 
                            <th scope="col">그룹명</th> 
                        </tr>
                    </thead>
                    <tbody>
						<% if (_dataList == null || _dataList.size() == 0) { %>
						<tr bgcolor="#FFFFFF">
							<td colspan="4" align="center" height = "280">
								<span class="font1">조회된 데이타가 없습니다.</span>
							</td> 
						</tr>
						<% } else {
								for (int j=0; j<_dataList.size(); j++) {
									Map<String,String> _tmp = _dataList.get(j);
						%> 
						<tr>
							<td>
								<a href="javascript:setReturn('<%=_tmp.get("GROUP_CODE")%>','<%=_tmp.get("GROUP_NAME")%>')"><%=CommonUtil.nvl(_tmp.get("GROUP_CODE"))%></a>
							</td>
							<td>
								<a href="javascript:setReturn('<%=_tmp.get("GROUP_CODE")%>','<%=_tmp.get("GROUP_NAME")%>')"><%=CommonUtil.nvl(_tmp.get("GROUP_NAME"))%></a>
							</td>
						</tr> 
						<%	} 
							} %>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
