<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/page.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script type="text/javaScript">
<!--
function fnCheckAll() {
    var checkField = document.listForm.checkField;
    if(document.listForm.checkAll.checked) {
        if(checkField) {
            if(checkField.length > 1) {
                for(var i=0; i < checkField.length; i++) {
                    checkField[i].checked = true;
                }
            } else {
                checkField.checked = true;
            }
        }
    } else {
        if(checkField) {
            if(checkField.length > 1) {
                for(var j=0; j < checkField.length; j++) {
                    checkField[j].checked = false;
                }
            } else {
                checkField.checked = false;
            }
        }
    }
}

function fnDelete() {
	$form = $("<form action='/auth/deleteAuth.do' method='get'></form>");
	
	var checkField = document.listForm.checkField;
	
   	if(checkField.length > 1) {
            for(var i=0; i < checkField.length; i++) {
	           	 if(checkField[i].checked) {
	           		$form.append("<input type='hidden' name='checkedId' value='"+document.listForm.checkId[i].value+"' />");
	           	 }
            }
        } else {
	       	 if(checkField.checked) {
	       		$form.append("<input type='hidden' name='checkedId' value='"+document.listForm.checkId.value+"' />");
	       	 }
        }
	 
	$('#hiddenForm').append($form);
	$form.submit();
}
//-->
</script>
</head>
<body>
	<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="masterHeader"/>
<c:param name="part" value="header"/>
</c:import>
		<div id="container2">
				<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="masterLeft"/>
				<c:param name="part" value="${param.upperId}"/>
				</c:import>
			<div id="rightCont">
			<!----------------------------------------------------------------------------------------------work-------------------------------------------------------------------------------------------------------------->
				<div>
					<form name="listForm">			
                        <div>
                            <a href="<c:url value='/auth/getAuths.do'/>" >조회 </a> 
                            <a href="<c:url value='/auth/getAuthForm.do'/>" >등록 </a> 
                            <a href="#LINK" onclick="JavaScript:fnDelete(); return false;">삭제 </a> 
                        </div>                              
						<div>
			                  <table border="1" >
			                   <caption>권한목록</caption>
			                   <colgroup>
			                   <col width="5%" >
			                   <col width="5%" >
			                   <col width="15%" >
			                   <col width="15%" >
			                   <col width="15%" >
			                   <col width="15%" >
			                   </colgroup>
			                   <thead>
			                   <tr>
			                       <th scope="col" nowrap="nowrap"><strong>No.</strong></th>
			                       <th scope="col" nowrap="nowrap"><input name="checkAll" type="checkbox" title="Check All" onclick="javascript:fnCheckAll();"/></th>
			                       <th scope="col" nowrap="nowrap">권한 아이디</th>
			                       <th scope="col" nowrap="nowrap">권한 명</th>
			                       <th scope="col" nowrap="nowrap">권한 설명</th>
			                       <th scope="col" nowrap="nowrap">생성일시</th>
			                   </tr>
			                   </thead>
			                   <tbody>                 
			
			                   <c:forEach var="result" items="${auths}" varStatus="status">
			                   <!-- loop 시작 -->                                
			                     <tr>
			                    <td nowrap="nowrap"><strong><c:out value="${status.count}"/></strong></td>
			                    <td nowrap="nowrap">
			                        <input name="checkField" title="Check <c:out value="${status.count}"/>" type="checkbox"/>
			                        <input name="checkId" type="hidden" value="<c:out value='${result.authId}'/>"/>
			                    </td>
			                    <td nowrap style="cursor:pointer;cursor:hand" >
			                        <span class="link"><a href="<c:url value='/auth/getAuth.do'/>?authId=<c:out value="${result.authId}"/>" ><c:out value="${result.authId}"/></a></span>
			                    </td>
			                    <td nowrap="nowrap"><c:out value="${result.name}"/></td>
			                    <td nowrap="nowrap"><c:out value="${result.authDc}"/></td>
			                    <td nowrap="nowrap"><c:out value="${result.createDt}"/></td>
			                     </tr>
			                    </c:forEach>     
			                   </tbody>
			                   </table>
			               </div>
		        	</form>
	        	</div>
	        	<div id=hiddenForm></div>
	        	<!----------------------------------------------------------------------------------------------work-------------------------------------------------------------------------------------------------------------->
			</div>
		</div>
	<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>  
	</div>
</body>
</html>

