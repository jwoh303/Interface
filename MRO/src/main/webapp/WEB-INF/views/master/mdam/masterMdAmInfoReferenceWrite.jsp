<%--
**********************************************
* 메뉴 : 관리자>게시판>정보마당.자료실 등록
* 화면 : 정보마당.자료실 등록
* 기능 : 정보마당.자료실 등록
* 프로그램 ID : 
* 담당자 : 홍석규  
* 착수일 : 2014-10-06
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
	
	String sbtype = CommonUtil.nvl((String) request.getParameter("sbtype"),"");  //   (조회조건)
	String sacl = CommonUtil.nvl((String) request.getParameter("sacl"),"");  //   (조회조건) 
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),"");  //   (조회조건) 
%> 
<body onload="kep_onload_view()"> 
<!--내용 시작-->		
<!--내용 시작-->	
<!--내용 시작-->	
<div id="ContArea2">
<h3 style="margin-top:10px;">정보마당·자료실 </h3>
 <form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> 
<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" /> 
<input type="hidden" name="sbtype" id="sbtype" value="<%=sbtype %>" /> 
<input type="hidden" name="sacl" id="sacl" value="<%=sacl %>" />  
<input type="hidden" name="startDate" id="startDate" value="<%=startDate %>" />  
<input type="hidden" name="IMAGE_KEY" id="IMAGE_KEY" value="" />  
<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
<input type="hidden" name=COMPANY id="COMPANY" value="${sessionInfo.comCode}" />
<input type="hidden" name="REG_USER_ID" id="REG_USER_ID" value="${sessionInfo.userId}" />
<input type="hidden" name="REG_USER_NAME" id="REG_USER_NAME" value="${sessionInfo.userNameLoc}" />
<input type="hidden" name="REG_DEP" id="REG_DEP" value="${sessionInfo.department}" />  
<input type="hidden" name="REG_DEP_NAME" id="REG_DEP_NAME" value="${sessionInfo.departmentName}" />    

		<fieldset>
		<table  class="board_write">
			<caption>정보마당·자료실 작성</caption>
			<colgroup>
				<col width="22%" />
				<col width="*" />
			</colgroup>
			<tbody>
    	<tr>
    		<th scope="row"><label for="u_BTYPE">유형</label></th>
    		<td>
    		<select name="BTYPE" id="BTYPE">
    			  <option value = "">선택</option>
                  <option  value = "NT">공지사항</option>
                  <option  value = "EB">e-Biz뉴스</option>
                  <option value = "DI">전시회 행사소식</option>
                  <option value = "PI">구매정보</option>
                  <option value = "EM">e마켓자료실</option>
                  <option value = "SI">상품정보자료실</option>
                  <option value = "WM">물류센터공지사항</option>
              </select>
              </td>
    	</tr>
    	<tr>
    		<th scope="row"><label for="u_SUBJECT">제목</label></th>
    		<td>
    		<input type="text" name="SUBJECT" id="SUBJECT"  class="input_type_text" style="width:500px;"/>
            </td>
    	</tr>    
    	<tr>
    		<th scope="row"><label for="u_REG_USER_ID">작성자</label></th>
    		<td>
    			<c:out value="${sessionInfo.userNameLoc}"/>
            </td>
    	</tr>    	
    	<tr style="display:none;">
    		<th scope="row"><label for="u_REG_DATE">작성일</label></th>
    		<td>
    		<input type="text" name="REG_DATE" id="REG_DATE"  class="input_type_text" style="width:170px;"/>
            </td>
    	</tr>    	    	
    	<tr>
    		<th scope="row"><label for="u_ACL">게  시  범  위</label></th>
    		<td>
    	    <select name="ACL"  id="ACL">
	                  <option   value = "ALL">전체</option>
	                  <option   value = "MEB">회원전체</option>
	                  <option  value = "SEL">판매사</option>
	                  <option  value = "BUY">고객사</option>
	              </select>
            </td>
    	</tr>       
    	<tr>
    		<th scope="row"><label for="u_FROM_DATE">게시기간</label></th>
    		<td> 
    		<input type="text" name="FROM_DATE" id="FROM_DATE"  class="input_type_text" style="width:170px;"/>
    		-<input type="text" name="TO_DATE" id="TO_DATE"  class="input_type_text" style="width:170px;"/>
            </td>
    	</tr>        
    	<tr>
    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
    		<td> 
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
<!--내용 종료-->	                 
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){ 
	kepNoSetCalender("REG_DATE","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("FROM_DATE","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("TO_DATE","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	$("#TO_DATE").val( kepToMonthAdd("1","P"));
	
	var result = "<%=result%>";
	if (result == "S"){
		$("#curPage").val(1);
		alert("저장이 완료되었습니다.");
		kepList();
	}
} 

/**
 * 목록이동
 */
function kepList(){   
	$('#contentForm').attr("action", "/mdam/getMasterMdAmInfoReference.do").submit();   
}

/**
 * 등록처리
 */
function kepWrite(){
	 
	if (kepSelectValid("BTYPE")==true){
		alert("유형 선택하세요.");
		$("#BTYPE").focus();
		return;
	}
	
	if (kepIsEmpty("SUBJECT")==true){
		alert("제목 입력하세요.");
		$("#SUBJECT").focus();
		return;
	} 
	
	if (kepIsEmpty("REG_DATE")==true){
		alert("작성일 입력하세요.");
		$("#REG_DATE").focus();
		return;
	} 		
	
	if (kepSelectValid("ACL")==true){
		alert("게시범위 입력하세요.");
		$("#ACL").focus();
		return;
	} 		
	
	if (kepIsEmpty("FROM_DATE")==true){
		alert("게시기간 입력하세요.");
		$("#FROM_DATE").focus();
		return;
	} 		

	if (kepIsEmpty("TO_DATE")==true){
		alert("게시기간 입력하세요.");
		$("#TO_DATE").focus();
		return;
	} 		
	
	if (kepIsEmpty("CONTEXT")==true){
		alert("내용 입력하세요.");
		$("#CONTEXT").focus();
		return;
	} 		
	
	if (confirm("등록하시겠습니까?")==false) return;
	$('#contentForm').attr("action", "/mdam/insertMasterMdAmInfoReferenceDetail.do").submit();   
}



</script>
</html>
