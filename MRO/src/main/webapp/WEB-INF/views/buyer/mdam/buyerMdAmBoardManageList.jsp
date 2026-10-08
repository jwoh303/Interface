<%--
**********************************************
* 메뉴 : 고객사 > 관리자 > 게시판 관리
* 화면 : 게시판관리
* 기능 : 게시판 관리
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
@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _bbsList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	
	String total_cnt =  CommonUtil.nvlObj((List<Map<String,String>>) _bbsList ,"0");  // 조회된결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");;  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String st_search_choice = CommonUtil.nvl((String) request.getParameter("st_search_choice"),"ALL");  //   (조회조건)
	String st_search_word = CommonUtil.nvl((String) request.getParameter("st_search_word"),"");  //   (조회조건)  
%> 
<body onload="kep_onload_view()">  
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<div id="container2">
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE695") %><!-- 게시판 관리 --></h3>
<!--내용 시작-->	
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<span class="btn_search"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		    <span class="btn_reset"><a href="javascript:kepReload();"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
		</div>
		<!--조회영역-->
       	<form id="searchCondition"  name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_byca_comorg_code" name="st_byca_comorg_code"  value="${sessionInfo.bycaComorgCode}">
			<input type="hidden" id="st_user_type" name="st_user_type"  value="${sessionInfo.userType}">
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">   
			<input type="hidden" name="BID" id="BID" value="" />
			<input type="hidden" name="BTYPE" id="BTYPE" value="" /> 	
			
            	<table  class="cont_t_list01" style="width:100%;">
					<caption><%=CommonLang.get("HTITLE695") %><!-- 게시판 관리 --></caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>
								<select id="st_search_choice" name="st_search_choice">
                                    <option value="ALL" <%=st_search_choice.equals("ALL")?"selected":""%>><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
                                    <option value="SUBJECT" <%=st_search_choice.equals("SUBJECT")?"selected":""%>><%=CommonLang.get("HTITLE304") %><!-- 제목 --></option>
                                    <option value="CONTEXT" <%=st_search_choice.equals("CONTEXT")?"selected":""%>><%=CommonLang.get("HTITLE441") %><!-- 내용 --></option>
                                    <option value="REG_USER_NAME" <%=st_search_choice.equals("REG_USER_NAME")?"selected":""%>><%=CommonLang.get("HTITLE442") %><!-- 등록자 --></option>
                                </select>
							</td>
							<td>
								 <input type="text" class="input_type_text" id="st_search_word"  name="st_search_word"  style="width:80%;" value="<%=st_search_word%>" onKeyDown="kepEnter()">
							</td>
							<th></th>
							<td></td>
							<th></th>
							<td></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow">
					<option value="10" <%=(onepagerow.equals("10") ? "selected" : "")%>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="20" <%=(onepagerow.equals("20") ? "selected" : "")%>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="30" <%=(onepagerow.equals("30") ? "selected" : "")%>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="40" <%=(onepagerow.equals("40") ? "selected" : "")%>>40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value="50" <%=(onepagerow.equals("50") ? "selected" : "")%>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				</select>
			</span>
			<br>
		</form>
		
					<form name = "contentForm"  id="contentForm" method = "post">
					<table class="cont_t_list02" style="width:100%">
			      	<colgroup>
                        <col width="5%" />
                        <col width="10%" />
                        <col width="50%" />
                        <col width="10%" />
                        <col width="10%" />
                        <col width="15%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE44") %><!-- 번호 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE306") %><!-- 유형 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE304") %><!-- 제 목 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE443") %><!-- 조회수 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE442") %><!-- 등록자 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE444") %><!-- 작성일자 --></th>
                        </tr>          
						</thead>
						<tbody>
<%
	if (_bbsList == null || _bbsList.size() == 0){
%>
                   <tr bgcolor="#FFFFFF">
                        <td colspan="6" align="center" height = "50">
                        <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%
     }else{
		for (int j=0; j<_bbsList.size(); j++) {
			Map<String,String> rowData = _bbsList.get(j);
%> 						
						<tr>
		                       <td height=30><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %></td>
		                       <td><%=CommonUtil.nvl( rowData.get("BTYPE_DIS"))%></td>
		                       <td class="left">
		                       <a href="javascript:kepEditForm('<%=CommonUtil.bnvl( rowData.get("BID"))%>','<%=CommonUtil.bnvl( rowData.get("BTYPE"))%>','<%=CommonUtil.nvl(rowData.get("OPEN_FLAG")) %>','<%=CommonUtil.nvl(rowData.get("REG_USER_ID")) %>');">
<%
	if("N".equals(rowData.get("OPEN_FLAG"))){ //비밀글
%>
								<img src="/resources/images/lock01.gif" />&nbsp;
<%
	}

	if(Integer.parseInt(rowData.get("BLEVEL")) > 0){ //답변글
%>
								<img src="/resources/images/re_answer.gif" />&nbsp;
<%} %>
		                       <%=CommonUtil.nvl( rowData.get("SUBJECT"))%>
		                       </a>
		                       </td>
		                       <td><%=CommonUtil.nvl( rowData.get("LCOUNT"))%></td>
		                       <td><%=CommonUtil.nvl( rowData.get("USER_NAME_LOC"))%></td>
		                       <td><%=CommonUtil.formatDate(CommonUtil.nvl( rowData.get("REG_DATE")))%></td>
						</tr> 
		
<%
		}
	}
%>		
			</tbody>
		</table>					
</form>												
<!--페이징-->
<p id="paging" class="paging">
    <%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
    <span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
</p>		

<%if(_sessionInfo.getUserType().equals("A")){ %>
<div class="btnArea" align="right">  
           	<span class="btn_04 mr04"><a href="javaScript:kepWriteForm();"><%=CommonLang.get("HTITLE440") %><!-- 등록 --></a></span>
</div>				                     
<%} %>
</div>
 
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div> 
 
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){
	
}
/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){ 
	document.forms.searchCondition.curPage.value = curPage; 
	$('#searchCondition').attr("action", "/mdam/getBuyerMdAmBoardManage.do").submit(); 
}

/**
 * FORM 을 초기화
 */
function kepReload(){
	$("#st_search_choice").val("ALL");
	$("#st_search_word").val("");
	kepSearch(-1);
} 

/**
 * 엔터 조회를 위해 필요함.
 */
function doAction(){
	kepSearch(1);
}

/**
 * 등록폼이동
 */
function kepWriteForm(){   
	$('#searchCondition').attr("action", "/mdam/showBuyerMdAmBoardManageWrite.do").submit();   
}
/**
 * 수정폼이동
 */
function kepEditForm(bid,btype,openFlag,regUserId){ 
	var userType = $("#st_user_type").val();
	var userId = $("#st_user_id").val();
	
	//비밀글일때는 본인과 관리자만 확인 가능하도록...
	if(openFlag=="N" && !(userType == 'A' || regUserId == userId)){
		alert("<%=CommonLang.msg("MSG394") %>");	//게시물이 비밀글입니다.\n\n확인할 수 없습니다.
        return;
	}
	
	document.forms.searchCondition.BID.value = bid;
	document.forms.searchCondition.BTYPE.value = btype;
	$('#searchCondition').attr("action", "/mdam/getBuyerMdAmBoardManageDetail.do").submit();   
	
}
</script>
</html>
