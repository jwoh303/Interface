<%--
**********************************************
* 메뉴 : 관리자>게시판>정보마당.자료실
* 화면 : 정보마당.자료실
* 기능 : 정보마당.자료실 관리
* 프로그램 ID : 
* 담당자 : 홍석규  
* 착수일 : 2014-10-06
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
	@SuppressWarnings (value="unchecked")
	Map<String, String> _detail = (Map<String, String>) request.getAttribute("detail"); // 

	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String sbtype = CommonUtil.nvl((String) request.getParameter("sbtype"),"");  //   (조회조건)
	String sacl = CommonUtil.nvl((String) request.getParameter("sacl"),"");  //   (조회조건) 
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),"");  //   (조회조건) 
	String BTYPE = "";
	String ACL = "";
	String REG_USER_ID = "";
	boolean regflag =false;
	
	if (_detail == null){
		
	}else{
		BTYPE = CommonUtil.nvl(_detail.get("BTYPE"));
		ACL = CommonUtil.nvl(_detail.get("ACL"));
		REG_USER_ID = CommonUtil.nvl(_detail.get("REG_USER_ID"));
	}
	
	
	String userid = "";
	if (_sessionInfo != null){
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
	} 
	
	if (REG_USER_ID.equals(userid)){
		regflag = true; // 로그인자와 등록자가 동일하다.
	}

%>   
<body onload="kep_onload_view()"> 

<!--내용 시작-->	
<div id="ContArea2">
<h3 style="margin-top:10px;">정보마당·자료실 </h3>
 <form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> 
<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" /> 
<input type="hidden" name="sbtype" id="sbtype" value="<%=sbtype %>" /> 
<input type="hidden" name="sacl" id="sacl" value="<%=sacl %>" />  
<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
<%	
  if (_detail == null){	
}else{
%>	
<input type="hidden" name="BID" id="BID" value="<%=String.valueOf(_detail.get("BID")) %>"  />       
<input type="hidden" name="BTYPE" id="BTYPE" value="<%=BTYPE %>"  />
<input type="hidden" name="IMAGE_KEY" id="IMAGE_KEY" value="" />  
<fieldset>
	<table  class="board_write">
		<caption>정보마당·자료실</caption>
		<colgroup>
			<col width="22%" />
			<col width="*" />
		</colgroup>
		<tbody>
    	<tr>
    		<th scope="row"><label for="u_BTYPE">유형</label></th>
    		<td>
    		<select name="BTYPEBTYPE"  id="BTYPEBTYPE">
                  <option  value = "NT" <% if ("NT".equals(BTYPE)) { %> selected <%} %>>공지사항</option>
                  <option  value = "EB" <% if ("EB".equals(BTYPE)) { %> selected <%} %>>e-Biz뉴스</option>
                  <option value = "DI" <% if ("DI".equals(BTYPE)) { %> selected <%} %>>전시회 행사소식</option>
                  <option value = "PI" <% if ("PI".equals(BTYPE)) { %> selected <%} %>>구매정보</option>
                  <option value = "EM" <% if ("EM".equals(BTYPE)) { %> selected <%} %>>e마켓자료실</option>
                  <option value = "SI" <% if ("SI".equals(BTYPE)) { %> selected <%} %>>상품정보자료실</option>
                  <option value = "WM" <% if ("WM".equals(BTYPE)) { %> selected <%} %>>물류센터공지사항</option>
              </select>
              </td>
    	</tr>
    	<tr>
    		<th scope="row"><label for="u_SUBJECT">제목</label></th>
    		<td>
    		<input type="text" name="SUBJECT" id="SUBJECT"  value="<%=_detail.get("SUBJECT") %>" class="input_type_text" style="width:500px;" />
            </td>
    	</tr>    
    	<tr>
    	<th scope="row"><label for="u_REG_USER_ID">작성자</label></th>
    		<td>
    		<%=_detail.get("REG_USER_NAME") %>
            </td>
    	</tr>    	
    	<tr>
    		<th scope="row"><label for="u_ACL">게  시  범  위</label></th>
    		<td>
    	    <select name="ACL" id="ACL">
	                  <option   value = "ALL" <% if ("ALL".equals(ACL)) { %> selected <%} %>>전체</option>
	                  <option   value = "MEB" <% if ("MEB".equals(ACL)) { %> selected <%} %>>회원전체</option>
	                  <option  value = "SEL" <% if ("SEL".equals(ACL)) { %> selected <%} %>>판매사</option>
	                  <option  value = "BUY" <% if ("BUY".equals(ACL)) { %> selected <%} %>>고객사</option>
	              </select>
            </td>
    	</tr>       
    	<tr>
    		<th scope="row"><label for="u_FROM_DATE">게시기간</label></th>
    		<td> 
    		<input type="text" name="FROM_DATE" id="FROM_DATE"  value="<%=_detail.get("FROM_DATE") %>" class="input_type_text" style="width:170px;"  />
    		-<input type="text" name="TO_DATE" id="TO_DATE"  value="<%=_detail.get("TO_DATE") %>" class="input_type_text" style="width:170px;"  />
            </td>
    	</tr>        
    	<tr>
    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
    		<td> 
    		<textarea name="CONTEXT" id="CONTEXT"  rows="20" cols="200"><%=_detail.get("CONTEXT").replaceAll("<br>","\n") %></textarea> 
            </td>
    	</tr>      		
    </table>           
        </fieldset>   
</form>
<div class="btnArea ac mt20"> 
<%  if (regflag == true) { %>
		           	<span class="btn_04 mr04"><a href="javascript:kepUpdate()">수정</a></span><!--  등록자와 로그인한사람이 동일일만 되게 개발필 -->
		           	<span class="btn_04 mr04"><a href="javascript:kepDelete()">삭제</a></span> <!--  등록자와 로그인한사람이 동일일만 되게 개발필 -->
<%} %>		           	
		           	<span class="btn_04 mr04"><a href="javascript:kepList()">목록</a></span>
		</div> 
    </div>
<%} %>        
<!--내용 종료-->
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){ 
	kepSetCalender("FROM_DATE"); // 초기 시작하자마 해당 ID에 달력세팅
	kepSetCalender("TO_DATE"); // 초기 시작하자마 해당 ID에 달력세팅
	
	var result = "<%=result%>";
	if (result == "U"){
		alert("수정이 완료되었습니다.");
		kepList();
	}else 	if (result == "D"){
		alert("삭제가 완료되었습니다.");
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
 * 수정처리
 */
function kepUpdate(){

	if (kepIsEmpty("SUBJECT")==true){
		alert("제목 입력하세요.");
		$("#SUBJECT").focus();
		return;
	} 
	
	if (kepSelectValid("ACL")==true){
		alert("게시범위 입력하세요.");
		$("#ACL").focus();
		return;
	} 		
	
	if (kepIsEmpty("CONTEXT")==true){
		alert("내용 입력하세요.");
		$("#CONTEXT").focus();
		return;
	}
	
	if (confirm("게시물을 수정 하시겠습니까?")==false) return;
	$('#contentForm').attr("action", "/mdam/updateMasterMdAmInfoReferenceDetail.do").submit();    
}

/**
 * 삭제처리
 */
function kepDelete(){
	
	if (confirm("삭제하시겠습니까?")==false) return;
	$('#contentForm').attr("action", "/mdam/deleteMasterMdAmInfoReferenceDetail.do").submit();     
}

</script>
</html>
