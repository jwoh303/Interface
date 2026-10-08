<%--
**********************************************
* 메뉴 : 고객사 > 관리자 > 게시판 관리 > 상세
* 화면 : 게시판 상세
* 기능 : 게시판 상세
* 프로그램 ID : 
* 담당자 : 홍석규
* 착수일 : 2014-09-19
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

	String REG_USER_ID = "";
	boolean regflag =false;
	
	if (_detail == null){
		
	}else{
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
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
 
<div id="ContArea">
<h3>게시판 상세보기 </h3>
 <form name = "contentForm" id="contentForm" method = "post">
 <input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> 
<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" /> 
<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
<input type="hidden" id="st_byca_comorg_code" name="st_byca_comorg_code"  value="${sessionInfo.bycaComorgCode}">
<input type="hidden" id="st_re_flag" name="st_re_flag"  value="">
<%	
  if (_detail == null){	
}else{
%>	
<input type="hidden" name="BID" id="BID" value="<%=String.valueOf(_detail.get("BID")) %>"  />
<input type="hidden" name="IMAGE_KEY" id="IMAGE_KEY" value="<%=CommonUtil.nvl(_detail.get("IMAGE_KEY") )%>" />
<input type="hidden" name="BTYPE" id="BTYPE" value="<%=String.valueOf(_detail.get("BTYPE")) %>"  />  
<input type="hidden" name="PID" id="PID" value="<%=String.valueOf(_detail.get("PID")) %>"  />
<input type="hidden" name="BLEVEL" id="BLEVEL" value="<%=String.valueOf(_detail.get("BLEVEL")) %>"  />
<input type="hidden" name="VID" id="VID" value="<%=String.valueOf(_detail.get("VID")) %>"  />
<fieldset>
	<table  class="board_write" >
		<caption>게시판 상세보기</caption>
		<colgroup>
			<col width="120px" />
			<col width="32%" />
			<col width="120px" />
			<col width="32%" />
		</colgroup>
		<tbody>
    	<tr>
    		<th scope="row"><label for="u_REG_DATE">작성일자</label></th>
    		<td>
    		<%=CommonUtil.formatDate(_detail.get("REG_DATE")+_detail.get("REG_TIME"), 3)%>
            </td>
            <th scope="row"><label for="u_LCOUNT">조회수</label></th>
    		<td>
    		<%=_detail.get("LCOUNT") %>
            </td>
    	</tr>
    	<tr>
    		<th scope="row"><label for="u_REG_USER_ID">등록자</label></th>
    		<td>
    		[<%=_detail.get("COM_NAME") %>]&nbsp;<%=_detail.get("REG_USER_NAME") %>
            </td>
            <th scope="row"><label for="u_FILE">첨부파일</label></th>
    		<td> 
	    		<% if ("".equals(CommonUtil.nvl(_detail.get("IMAGE_KEY") ))) { %>
	    			<a href="javascript:attach_popup('<%=_detail.get("IMAGE_KEY") %>');"> <img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
	    		<%}else{ %>
					<a href="javascript:attach_popup('<%=_detail.get("IMAGE_KEY") %>');"> <img id="diskimg" src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
				<%} %>
            </td>
    	</tr>    	
    	<tr>
    		<th scope="row"><label for="u_BTYPE_DIS">유형</label></th>
    		<td colspan="3">
    		<%=_detail.get("BTYPE_DIS") %>
            </td>
    	</tr> 
		<tr>
    		<th scope="row"><label for="u_SUBJECT">제목</label></th>
    		<td colspan="3">
    		<input type="text" name="SUBJECT" id="SUBJECT"   value="<%=_detail.get("SUBJECT") %>" class="input_type_text"  style="width:98%;"  />
            </td>
    	</tr>  	    	
    	<tr>
    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
    		<td colspan="3"> 
    		<textarea name="CONTEXT" id="CONTEXT"  rows="20" cols="200"><%=_detail.get("CONTEXT").replaceAll("<br>","\n") %></textarea> 
            </td>
    	</tr>      		
    </table>           
        </fieldset>   
<div class="btnArea" align="right"> 
<%  if (regflag == true) { %>
	<%  if ("NOR".equals(_detail.get("BTYPE"))) { %>
					<input type="checkbox" name="st_open_flag"  id="st_open_flag" value="N" <%=_detail.get("OPEN_FLAG").equals("N")?"checked":"" %> style="vertical-align:middle;">
					<b><font color="#666666">비공개 등록</font></b>&nbsp;&nbsp;
	<%} %>					
		           	<span class="btn_04 mr04"><a href="javascript:kepUpdate()">수정</a></span><!--  등록자와 로그인한사람이 동일일만 수정가능 -->
		           	<span class="btn_04 mr04"><a href="javascript:kepDelete()">삭제</a></span> <!--  등록자와 로그인한사람이 동일일만 삭제가능 -->
<%} %>		       
<%  if ("NOR".equals(_detail.get("BTYPE"))) { %>
					<span class="btn_04 mr04"><a href="javascript:kepReWriteForm()">답변</a></span>    	
		           	<span class="btn_04 mr04"><a href="javascript:kepEditForm('<%=CommonUtil.nvl( _detail.get("P_BID"))%>','<%=CommonUtil.nvl( _detail.get("P_BTYPE"))%>')">이전글</a></span>
		           	<span class="btn_04 mr04"><a href="javascript:kepEditForm('<%=CommonUtil.nvl( _detail.get("N_BID"))%>','<%=CommonUtil.nvl( _detail.get("N_BTYPE"))%>')">다음글</a></span>
<%} %>		           	
		           	<span class="btn_04 mr04"><a href="javascript:kepList()">목록</a></span>
		</div> 
<%} %>
</form>
	</div>
</div>        
<!--내용 종료-->	                 
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>               
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){ 
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
	$('#contentForm').attr("action", "/mdam/getBuyerMdAmBoardManage.do").submit();  
}

/**
 * 수정처리
 */
function kepUpdate(){

	if (kepIsEmpty("SUBJECT")==true){
		alert("제목을 입력하여 주십시요.");
		$("#SUBJECT").focus();
		return;
	} 
	
	if (kepIsEmpty("CONTEXT")==true){
		alert("내용을 입력하여 주십시요.");
		$("#CONTEXT").focus();
		return;
	} 		
	
	if (confirm("게시물을 수정 하시겠습니까?")==false) return;
	$('#contentForm').attr("action", "/mdam/updateBuyerMdAmBoardManageDetail.do").submit();    
}

/**
 * 삭제처리
 */
function kepDelete(){
	
	if (confirm("삭제하시겠습니까?")==false) return;
	$('#contentForm').attr("action", "/mdam/deleteBuyerMdAmBoardManageDetail.do").submit();     
}


function  attach_popup(IMAGE_KEY){	
	
	var type = "BOARD";
	<% if (regflag == true) { %>
	var viewType = "C";
	<%}else{%>
	var viewType = "R";
	<%}%> 
	var img_key = IMAGE_KEY; 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

function setPopupReturn(value1,value2){ 	 
   	$("#IMAGE_KEY").val(value1); 	   	
   	
   	$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif"); 
}   

function kepEditForm(bid,btype){ 
	var oriBid = $("#BID").val();
	if(oriBid == bid){
		alert("마지막 자료 입니다.");
		return;
	}
	$("#BID").val(bid);
	$("#BTYPE").val(btype);
	$('#contentForm').attr("action", "/mdam/getBuyerMdAmBoardManageDetail.do").submit();    
}

function kepReWriteForm(){ 
	$("#st_re_flag").val("QA_RE");
	$('#contentForm').attr("action", "/mdam/showBuyerMdAmBoardManageWrite.do").submit();    
}


</script>
</html>
