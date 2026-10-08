<%--
**********************************************
* 메뉴 : 게시판
* 화면 : 게시판
* 기능 : 게시판
* 프로그램 ID : 
* 담당자 : CEJ  
* 착수일 : 2014-XX-XX
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%> 
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<% 
	String result =  CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String sbtype = CommonUtil.nvl((String) request.getParameter("sbtype"),"NT");  //   (조회조건)
	String sacl = CommonUtil.nvl((String) request.getParameter("sacl"),"");  //   (조회조건) 
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),DateTimeUtil.getFormatString("yyyy/MM/dd"));  //   (조회조건)
	String st_open_flag = CommonUtil.nvl((String) request.getParameter("st_open_flag"),"");  //   (조회조건)
%> 
<body onload="kep_onload_view()"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<!--내용 시작-->	
<div id="ContArea2">
<h3 style="margin-top:10px;">게시판 </h3>
 <form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> 
<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" /> 
<input type="hidden" name="sbtype" id="sbtype" value="<%=sbtype %>" /> 
<input type="hidden" name="sacl" id="sacl" value="<%=sacl %>" />  
<input type="hidden" name="startDate" id="startDate" value="<%=startDate %>" />  
<input type="hidden" name="st_open_flag" id="st_open_flag" value="<%=st_open_flag %>" />
<input type="hidden" name="IMAGE_KEY" id="IMAGE_KEY" value="" />  
<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
<input type="hidden" name="REG_USER_ID" id="REG_USER_ID"  value="${sessionInfo.userId}"  />
<input type="hidden" name="REG_USER_NAME" id="REG_USER_NAME"  value="${sessionInfo.userNameLoc}"  />
<input type="hidden" name="REG_DEP" id="REG_DEP"  value="${sessionInfo.department}"  />
<input type="hidden" name="REG_DEP_NAME" id="REG_DEP_NAME"  value="${sessionInfo.departmentName}"  />
<input type="hidden" name="COMPANY" id="COMPANY"  value="${sessionInfo.comCode}"  />
<input type="hidden" name="BTYPE" id="BTYPE" value="NT"  />
		<fieldset>
		<legend>게시판 글 작성</legend>
		<table  class="board_write" summary="글작성에 대한 정보입력">
			<caption>게시글 작성</caption>
			<colgroup>
				<col width="22%" />
				<col width="*" />
			</colgroup>
			<tbody>
    	<tr>
    		<th scope="row"><label for="u_SUBJECT">제목</label></th>
    		<td>
    		<input type="text" name="SUBJECT" id="SUBJECT"  onkeyup="fnCheckInputByte(this, 250);" onchange="fnCheckInputByte(this, 250);" class="input_type_text" style="width:500px;"/>
            </td>
    	</tr>    
    	<tr>
    		<th scope="row"><label for="u_REG_USER_ID">작성자</label></th>
    		<td>
    			<c:out value="${sessionInfo.userNameLoc}"/>
            </td>
    	</tr>    	
    	<tr>
    		<th scope="row"><label for="u_REG_DATE">작성일</label></th>
    		<td>
    			<%=startDate %>
            </td>
    	</tr>    	    	
    	<tr>
    		<th scope="row"><label for="u_ACL">게  시  범  위</label></th>
    		<td>
    	    <select name="ACL"  id="ACL" onChange = "setAclChange();">
	                  <option   value = "ALL">전체</option>
	                  <option   value = "MEB">회원전체</option>
	                  <option  value = "SEL">판매사</option>
	                  <option  value = "BUY">고객사</option>
	                  <option  value = "CST" >회사선택</option>
	                  <option  value = "UST" >개인선택</option>
	              </select>
            </td>
    	</tr>
    	<tr>
    		<th scope="row"><label for="u_COMPANY">게시회사</label></th>
    		<td> 
    			<input type="text" name="st_open_company" id="st_open_company" value="" style="width:100%;" READONLY>
				<input type = "hidden" name="st_open_company_code" id="st_open_company_code"  value = "">
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
    	<tr>
    		<th scope="row"><label for="u_FILE">첨부파일</label></th>
    		<td> 
    		<a href="javascript:attach_popup();"> <img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
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
<!--내용 종료-->	                 
 
</body>
<script type="text/javascript">
var popupSel;
 
function kep_onload_view(){ 
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
	
	$('#contentForm').attr("action", "/board/boardList.do").submit();   
}

/**
 * 등록처리
 */
function kepWrite(){
	 
	if (kepIsEmpty("SUBJECT")==true){
		alert("제목 입력하세요.");
		$("#SUBJECT").focus();
		return;
	}

	if (!fnCheckInputByteStr($("#SUBJECT").val(), 250)) {
		alert("제목은 영문 250자, 한글 125자 까지 입력할수 있습니다.");
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
	
	if(!confirm("게시판을 등록 하시겠습니까?")) return;
	$('#contentForm').attr("action", "/board/boardWrite.do").submit();   
}


function  attach_popup(){
	
	var type = "BO";
	var viewType = "C";
	var img_key = $("#IMAGE_KEY").val(); 	   	 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2){ 	 
   	$("#IMAGE_KEY").val(value1); 	   	
   	$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif");
  	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMulti") {	// 고객사
		$("#st_open_company_code").val(value1);
		$("#st_open_company").val(value2.replace(/@/gi,","));
	}
}   

function setAclChange(){
	var acl = $("#ACL").val();
	if(acl == "CST"){
		doPop("buyerMulti");
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerMulti": // 고객사 M
			openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no')
			popupSel = "buyerMulti";
			break;
	}
}

</script>
</html>
