<%--
**********************************************
* 메뉴 : 관리자>게시판>게시판
* 화면 : 게시판
* 기능 : 게시판 관리
* 프로그램 ID : 
* 담당자 : 홍석규  
* 착수일 : 2014-10-07
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _bbsList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	
	String total_cnt =  CommonUtil.nvlObj((List<Map<String,String>>) _bbsList ,"0");  // 조회된결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String sbtype = CommonUtil.nvl((String) request.getParameter("sbtype"),"ALL");  //   (조회조건)
	String sacl = CommonUtil.nvl((String) request.getParameter("sacl"),"ALL");  //   (조회조건) 
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),DateTimeUtil.getFormatString("yyyy/MM/dd"));  //   (조회조건) 
	String st_open_flag = CommonUtil.nvl((String) request.getParameter("st_open_flag"),"ALL");  //   (조회조건)
%> 
<body onload="kep_onload_view()">  

<!--내용 시작-->	
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<h3>게시판</h3>
        	<span class="btn_search"><a href="javascript:kepSearch(1);">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:kepReload();">초기화</a></span>
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
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="BID" id="BID" value="" />
			<input type="hidden" name="BTYPE" id="BTYPE" value="" />		
			<input type="hidden" name="sbtype" id="sbtype" value="<%=sbtype %>" />
			
            	<table  class="cont_t_list01">
					<caption>게시판</caption>
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
							<th>게시범위</th>
							<td>
								<select id="sacl" name="sacl">
                                  <option <%=(sacl.equals("ALL") ? "selected" : "")%> value = "ALL">전체</option>
                                  <option <%=(sacl.equals("MEB") ? "selected" : "")%> value = "MEB">회원전체</option>
                                  <option <%=(sacl.equals("SEL") ? "selected" : "")%> value = "SEL">판매사</option>
                                  <option <%=(sacl.equals("BUY") ? "selected" : "")%> value = "BUY">고객사</option>
                                  <option <%=(sacl.equals("CST") ? "selected" : "")%> value = "CST">회사선택</option>
                                  <option <%=(sacl.equals("UST") ? "selected" : "")%> value = "UST">개인선택</option>
                              </select> 
							</td>	
							<th>기준일</th>
							<td>
								<input type="text" id="startDate"  class="input_type_text" name="startDate" value="<%=startDate %>" style="width:70%">		
							</td>
							<th>승인유무</th>
							<td>
								<select id="st_open_flag" name="st_open_flag">
                                  <option <%=(st_open_flag.equals("ALL") ? "selected" : "")%> value = "ALL">전체</option>
                                  <option <%=(st_open_flag.equals("Y") ? "selected" : "")%> value = "Y">승인</option>
                                  <option <%=(st_open_flag.equals("N") ? "selected" : "")%> value = "N">미승인</option>
								</select> 
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" <%=(onepagerow.equals("10") ? "selected" : "")%>>10건</option>
					<option value="20" <%=(onepagerow.equals("20") ? "selected" : "")%>>20건</option>
					<option value="30" <%=(onepagerow.equals("30") ? "selected" : "")%>>30건</option>
					<option value="40" <%=(onepagerow.equals("40") ? "selected" : "")%>>40건</option>
					<option value="50" <%=(onepagerow.equals("50") ? "selected" : "")%>>50건</option>
				</select>
			</span>
			<br>
		</form>
            <div> 
				<fieldset>
					<legend>게시판 </legend>
					<form name = "contentForm"  id="contentForm" method = "post">
					<table id="table_list" class="cont_t_list03">
					<caption>게시판 </caption>
                    <colgroup>
                        <col width="5%" />
                        <col width="15%" />
                        <col width="10%" />
                        <col width="30%" />
                        <col width="5%" />
                        <col width="10%" />
                        <col width="10%" /> 
                        <col width="10%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">회원사명</th>
                            <th scope="col">게시범위</th>
                            <th scope="col">제 목</th>
                            <th scope="col">승인</th>
                            <th scope="col">작성자</th>
                            <th scope="col">게시일</th>
                            <th scope="col">종료일</th> 
                        </tr>          
						</thead>
						<tbody>
<%
if (_bbsList == null || _bbsList.size() == 0){
%>
                   <tr bgcolor="#FFFFFF">
                        <td colspan="8" align="center" height = "50">
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%
     }else{
for (int j=0; j<_bbsList.size(); j++) {
	Map<String,String> rowData = _bbsList.get(j);
%> 						
						<tr>
		                       <td height=30><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %></td>
		                       <td><%=CommonUtil.nvl( rowData.get("COM_NAME_LOC"))%></td>
		                       <td><%=CommonUtil.nvl( rowData.get("ACL_DIS"))%></td>
		                       <td class="left"><a href="javascript:kepEditForm('<%=CommonUtil.bnvl( rowData.get("BID"))%>','<%=CommonUtil.bnvl( rowData.get("BTYPE"))%>')"><%=CommonUtil.nvl( rowData.get("SUBJECT"))%></a></td>
		                       <td><%=CommonUtil.nvl( rowData.get("OPEN_FLAG"))%></td>
		                       <td><%=CommonUtil.nvl( rowData.get("REG_USER_NAME"))%></td>
		                       <td><%=CommonUtil.formatDate(CommonUtil.nvl( rowData.get("FROM_DATE")))%></td>
		                       <td><%=CommonUtil.formatDate(CommonUtil.nvl( rowData.get("TO_DATE")))%></td>
						</tr> 
		
<%
}
%>
<%
}
%>		
			</tbody>
		</table>					
</form>												
<!--페이징-->
<p id="paging" class="paging">
    <%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
    <span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
</p>		
                                        
<div class="btnArea" align="right">  
           	<span class="btn_04 mr04"><a href="javaScript:kepWriteForm();">등록</a></span>
</div>				                     

	</fieldset>             
        </div>
 
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	 
 
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){
	
	kepNoSetCalender("startDate",""); // 초기 시작하자마 해당 ID에 달력세팅
	
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){ 
	$("#curPage").val(curPage);
	$('#searchCondition').attr("action", "/board/boardList.do").submit();   
}

/**
 * FORM 을 초기화
 */
function kepReload(){
	$("#sbtype").val("ALL");
	$("#sacl").val("ALL");
	$("#st_open_flag").val("ALL");
	kepNoSetCalender("startDate","Y");
// 	kepSearch(-1);
	jspTableClean("table_list","8");
} 

/**
 * 등록폼이동
 */
function kepWriteForm(){   
	$('#searchCondition').attr("action", "/board/boardWriteForm.do").submit();   
}
/**
 * 수정폼이동
 */
function kepEditForm(bid,btype){ 
	
	$("#BID").val(bid);
	$("#BTYPE").val(btype);
	$('#searchCondition').attr("action", "/board/boardDetail.do").submit();    
}
</script>
</html>
