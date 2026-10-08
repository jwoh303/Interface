<%--
**********************************************
* 메뉴 : 고객사 > 관리자 > 공지사항 관리 > 등록
* 화면 : 공지사항 등록
* 기능 : 공지사항 등록
* 프로그램 ID : 
* 담당자 : 홍석규
* 착수일 : 2014-09-18
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%> 
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<% 
	String result =  CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

%> 
<body onload="kep_onload_view()"> 
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
 
<!--내용 시작-->	
<div id="ContArea">
<h3>고객 공지사항 등록하기 </h3>
 <form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> 
<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" /> 
<input type="hidden" name="BTYPE" id="BTYPE" value="NTC" /> 
<input type="hidden" name=COM_CODE id="COM_CODE" value="${sessionInfo.comCode}" />
<input type="hidden" name=BYCA_COMORG_CODE id="BYCA_COMORG_CODE" value="${sessionInfo.bycaComorgCode}" />  
<input type="hidden" name="REG_USER_ID" id="REG_USER_ID" value="${sessionInfo.userId}" />
<input type="hidden" name="REG_DEP" id="REG_DEP" value="${sessionInfo.department}" />  
<input type="hidden" name="REG_DEP_NAME" id="REG_DEP_NAME" value="${sessionInfo.departmentName}" />    
<input type="hidden" name="IMAGE_KEY" id="IMAGE_KEY" value="" />  
<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
<input type="hidden" id="st_byca_comorg_code" name="st_byca_comorg_code"  value="${sessionInfo.bycaComorgCode}">
		<fieldset>
		<table  class="board_write">
			<caption>고객 공지사항 등록하기</caption>
			<colgroup>
				<col width="120px" />
				<col width="32%" />
				<col width="120px" />
				<col width="32%" />
			</colgroup>
			<tbody>
		<tr>
    		<th scope="row"><label for="u_SUBJECT">제목</label></th>
    		<td colspan="3">
    		<input type="text" name="SUBJECT" id="SUBJECT"   class="input_type_text"  style="width:98%;"  />
            </td>
    	</tr>	
    	<tr>
    		<th scope="row"><label for="u_REG_USER_ID">등록자</label></th>
    		<td>
    		[<c:out value="${sessionInfo.comNameLoc}"/>]&nbsp;<c:out value="${sessionInfo.userNameLoc}"/>
            </td>
            <th scope="row"><label for="u_FILE">첨부파일</label></th>
    		<td> 
    			<a href="javascript:attach_popup('');"> <img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
            </td>
    	</tr>
    	<tr>
    		<th scope="row"><label for="u_FROM_DATE">기간</label></th>
    		<td colspan="3"> 
    		<input type="text" name="FROM_DATE" id="FROM_DATE"  class="input_type_text" />
    		-<input type="text" name="TO_DATE" id="TO_DATE"  class="input_type_text" />
            </td>
    	</tr>
		<tr>
    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
    		<td colspan="3"> 
    		<textarea name="CONTEXT" id="CONTEXT"  rows="20" cols="200"></textarea> 
            </td>
    	</tr>
    	</tbody>
    </table>           
   </fieldset>   
</form>
<div class="btnArea ac mt20">
<span class="btn_04 mr04"><a href="javascript:kepWrite()">등록</a></span> 
<span class="btn_04 mr04"><a href="javascript:kepList()">목록</a></span>
</div>  
    </div>
</div>
<!--내용 종료-->	                 
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>  
</div>
 <!--내용 종료-->	                  
<!--내용 종료-->	                 
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){ 
	kepNoSetCalender("FROM_DATE","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("TO_DATE","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	$("#TO_DATE").val( kepToMonthAdd("1","P"));
	
	var result = "<%=result%>";
	if (result == "S"){
		$("#curPage").val(1);
		alert("정상적으로 등록 되었습니다.");
		kepList();
	}
} 

/**
 * 목록이동
 */
function kepList(){   
	
	$('#contentForm').attr("action", "/mdam/getBuyerMdAmNoticeManage.do").submit();  
}

/**
 * 등록처리
 */
function kepWrite(){
	 
	if (kepIsEmpty("SUBJECT")==true){
		alert("제목을 입력하여 주십시요.");
		$("#SUBJECT").focus();
		return;
	} 
	
	if (kepIsEmpty("FROM_DATE")==true){
		alert("기간을 입력하여 주십시요.");
		$("#FROM_DATE").focus();
		return;
	} 		

	if (kepIsEmpty("TO_DATE")==true){
		alert("기간을 입력하여 주십시요.");
		$("#TO_DATE").focus();
		return;
	} 		

	
	if (kepIsEmpty("CONTEXT")==true){
		alert("내용을 입력하여 주십시요.");
		$("#CONTEXT").focus();
		return;
	}
	
	if (confirm("게시물을 등록 하시겠습니까?")==false) return;
	$('#contentForm').attr("action", "/mdam/insertBuyerMdAmNoticeManageDetail.do").submit();   
}


function  attach_popup(){	
	
	var type = "BOARD";
	var viewType = "C";
	var img_key = $("#IMAGE_KEY").val(); 	   	 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

function setPopupReturn(value1,value2){ 	 
   	$("#IMAGE_KEY").val(value1); 	   	
   	
   	$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif"); 
}   


</script>
</html>
