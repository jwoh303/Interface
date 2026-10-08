<%--
**********************************************
* 메뉴 : 국가코드
* 화면 : 국가코드 검색 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_900_11
* 담당자 :  고영일 ( 설계 : 김지현 )
* 착수일 : 2014-06-18
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
<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#commonCoCoNationCodePop').attr("action", "/coco/getCommonCoCoNationCodePop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

/**
 * 선택 값 리턴
 * @param value1 : 국가코드
 * @param value2 : 한글국가명
 * @param value3 : 영문국가명
 */
function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoNationCodePop" id="commonCoCoNationCodePop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE731") %><!-- 국가코드 --></h1>
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
						<caption>국가코드 리스트</caption>
						<colgroup>
							<col width="15%" />
                            <col width="35%" />
							<col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE494") %><!-- 국가명 --></td>
							<td> 
								<input type=text name=country_search id="country_search" size="20" value="<c:out value="${country_search }"/>" onkeydown="kepEnter()" class="input_type_text">
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
                    <caption>국가코드 리스트</caption>
                    <colgroup>
                        <col width="15%" />
						<col width="40%" />
						<col width="40%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE495") %><!-- 국가명(영문) --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE496") %><!-- 국가명(국문) --></th> 
                        </tr>
                    </thead>
                    <tbody>
						<c:choose>
							<c:when test="${data ne null && fn:length(data) > 0  }">
								<c:forEach var="rowData" items="${data}" varStatus="status">
									<tr>
										<td><a href="javascript:setReturn('${rowData.CODE }','${rowData.TEXT1 }','${rowData.TEXT2 }');"><c:out value="${rowData.CODE }" /></a></td>
										<td class="left"><a href="javascript:setReturn('${rowData.CODE }','${rowData.TEXT2 }','${rowData.TEXT1 }');"><c:out value="${rowData.TEXT1 }" /></a></td>
										<td class="left"><a href="javascript:setReturn('${rowData.CODE }','${rowData.TEXT2 }','${rowData.TEXT1 }');"><c:out value="${rowData.TEXT2 }" /></a></td>
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
