<%--
**********************************************
* 메뉴 : 
* 화면 : 계정항목
* 기능 : 계정항목 선택 팝업
* 프로그램 ID : PG_03_M_002_06
* 담당자 :  고영일 ( 설계 : 김지현 )
* 착수일 : 2014-06-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<script type="text/javascript">
<!--
/**
 * 선택 값 리턴
 * @param value1 : 코드
 * @param value2 : 설명
 */
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoAccountItemPop" id="commonCoCoAccountItemPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:244px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">계정항목</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
            <div>
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>계정항목 리스트</caption>
                    <colgroup>
                        <col width="25%" /> 
                        <col width="75%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">코드</th> 
                            <th scope="col">설명</th> 
                        </tr>
                    </thead>
                    <tbody>
						<c:choose>
							<c:when test="${data ne null && fn:length(data) > 0  }">
								<c:forEach var="rowData" items="${data}" varStatus="status">
									<tr>
										<td><a href="javascript:setReturn('${rowData.CODE }','${rowData.TEXT2 }');"><c:out value="${rowData.CODE }" /></a></td>
										<td><a href="javascript:setReturn('${rowData.CODE }','${rowData.TEXT2 }');"><c:out value="${rowData.TEXT2 }" /></a></td>
				                    </tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
						            <tr bgcolor="#FFFFFF">
				                        <td colspan="2" align="center" >
				                        <span class="font1">조회된 데이타가 없습니다.</span>
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
