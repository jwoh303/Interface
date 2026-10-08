<%--
**********************************************
* 메뉴 : 
* 화면 : 부서상세보기
* 기능 : 
* 프로그램 ID : PG_90_C_900_18
* 담당자 :  고영일 ( 설계 : 김지현 )
* 착수일 : 2014-06-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<body onload="">
<form name="commonCoCoDepartmentDetailViewPop" id="commonCoCoDepartmentDetailViewPop" method=post >

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE868") %><!-- 부서상세보기 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div>
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서상세보기 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
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
						<c:choose>
							<c:when test="${data ne null && fn:length(data) > 0  }">
								<c:forEach var="rowData" items="${data}" varStatus="status">
									<tr>
										<td><c:out value="${rowData.CODE }" /></td>
										<td class="left"><c:out value="${rowData.TEXT1 }" /></td>
										<td class="left"><c:out value="${rowData.TEXT2 }" /></td>
				                    </tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
						            <tr bgcolor="#FFFFFF">
				                        <td colspan="3" align="center" >
				                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
				                        </td> 
				                    </tr>
							</c:otherwise>
						</c:choose>
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
