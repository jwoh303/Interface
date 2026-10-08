<%--
**********************************************
* 메뉴 : 관리자 > 게시판 > 게시판 상세
* 화면 : 게시판 상세
* 기능 : 게시판 상세 내용을 관리한다.
* 프로그램 ID : 
* 담당자 : 홍석규  
* 착수일 : 2014-10-08
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
	String st_open_flag = CommonUtil.nvl((String) request.getParameter("st_open_flag"),"");  //   (조회조건)
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
	
	
	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
	} 
	
	if (REG_USER_ID.equals(userid)){
		regflag = true; // 로그인자와 등록자가 동일하다.
	}

%>   
<body onload="kep_onload_view()"> 
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
<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
<%	
  if (_detail == null){	
}else{
%>	
<input type="hidden" name="BTYPE" id="BTYPE" value="<%=BTYPE %>"  />
<input type="hidden" name="BID" id="BID" value="<%=String.valueOf(_detail.get("BID")) %>"  />       
<input type="hidden" name="IMAGE_KEY" id="IMAGE_KEY" value="<%=CommonUtil.nvl(_detail.get("IMAGE_KEY") )%>" />  
<input type="hidden" name="st_open_flag" id="st_open_flag" value="<%=CommonUtil.nvl(_detail.get("OPEN_FLAG") )%>">
<input type="hidden" name="st_open_type" id="st_open_type" value="">
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
    		<th scope="row"><label for="u_REG_DATE">작성일</label></th>
    		<td>
    		<%=_detail.get("REG_DATE") %>
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
                  <option  value = "CST" <% if ("CST".equals(ACL)) { %> selected <%} %>>회사선택</option>
                  <option  value = "UST" <% if ("UST".equals(ACL)) { %> selected <%} %>>개인선택</option>
              </select>
              <%
              if ("CST".equals(ACL)) {
              %>
	              &nbsp;&nbsp;
	              <a href="javascript:setSelectCompanyPop();">특정회사</a>
              <%
              }
              %>
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
    		<th scope="row"><label for="u_COMPANY">게시회사</label></th>
    		<td> 
            </td>
    	</tr>      
    	<tr>
    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
    		<td> 
    		<textarea name="CONTEXT" id="CONTEXT"  rows="20" cols="200"><%=_detail.get("CONTEXT").replaceAll("<br>","\n") %></textarea> 
            </td>
    	</tr>      		
    	<tr>
    		<th scope="row"><label for="u_FILE">첨부파일</label></th>
    		<td> 
    		<% if ("".equals(CommonUtil.nvl(_detail.get("IMAGE_KEY") ))) { %>
    			<a href="javascript:attach_popup('<%=_detail.get("IMAGE_KEY") %>');"> <img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
    		<%}else{ %>
    		    		<a href="javascript:attach_popup('<%=_detail.get("IMAGE_KEY") %>');"> <img id="diskimg" src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
    		    		<%} %>
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
		           	<span class="btn_04 mr04"><a href="javascript:Confirm('YES')">승인</a></span>
		           	<span class="btn_04 mr04"><a href="javascript:Confirm('NO')">승인취소</a></span>
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
	$('#contentForm').attr("action", "/board/boardList.do").submit();   
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
	
	 if(!confirm("게시물을 수정하시겠습니까?")) return;
	$('#contentForm').attr("action", "/board/boardUpdate.do").submit();    
}

/**
 * 삭제처리
 */
function kepDelete(){
	
	if (confirm("삭제하시겠습니까?")==false) return;
	$('#contentForm').attr("action", "/board/boardDelete.do").submit();     
}


function  attach_popup(IMAGE_KEY){	
	
	var type = "BO";
	<% if (regflag == true) { %>
	var viewType = "C";
	<%}else{%>
	var viewType = "R";
	<%}%> 
	var img_key = $("#IMAGE_KEY").val(); 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

function setPopupReturn(value1,value2){ 	 
   	$("#IMAGE_KEY").val(value1); 	   	 
   	$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif"); 
}   

function Confirm(open_type)
{
	  var open_flag = $("#st_open_flag").val();
	  if(open_type == "YES" && open_flag == "Y")
	  {
	    alert("이미 승인된 게시물입니다.");
	    return;
	  }
	  if(open_type == "NO" && open_flag == "N")
	  {
	    alert("아직 승인되지 않은 게시물입니다.");
	    return;
	  }
	
	  if(open_type == "YES")
	  {
	    if(!confirm("승인 하시겠습니까?")) return;
	  }
	  if(open_type == "NO")
	  {
	    if(!confirm("승인취소 하시겠습니까?")) return;
	  }
	  
	  $("#st_open_type").val(open_type);
	  kepAjaxFormCall("/board/boardConfirm.do","contentForm","boardConfirm");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (msg != ""){
		alert(msg);
	}
	kepList();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var st_open_type = $("#st_open_type").val();
	
	if(st_open_type == "NO"){
		alert("오류로 인하여 승인취소 되지 않았습니다");
	}else{
		alert("오류로 인하여 승인 되지 않았습니다");
	}
	kepList();
} 

//선택 회원사 팝업
function setSelectCompanyPop(){
	var bid = $("#BID").val();
	var btype = $("#BTYPE").val();
	openSearchPopup("/mdam/getMasterMdAmSelectCompanyPop.do","?BID="+bid+"&BTYPE="+btype , "840,400,no");
}

</script>
</html>
