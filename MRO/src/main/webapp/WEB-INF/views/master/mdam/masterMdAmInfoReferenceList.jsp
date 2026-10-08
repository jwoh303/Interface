<%--
**********************************************
* 메뉴 : 관리자 > 정보마당 자료실
* 화면 : 정보마당 자료실
* 기능 : 정보마당 자료실 관리
* 프로그램 ID : 
* 담당자 :홍석규 
* 착수일 : 2014-09-30
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
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String sbtype = CommonUtil.nvl((String) request.getParameter("sbtype"),"");  //   (조회조건)
	String sacl = CommonUtil.nvl((String) request.getParameter("sacl"),"");  //   (조회조건) 
%> 
<body onload="kep_onload_view()">  

<!--내용 시작-->	
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<h3>정보마당·자료실</h3>
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
			
            	<table  class="cont_t_list01">
					<caption>정보마당·자료실</caption>
					<colgroup>
						<col width="18%" />
						<col width="32%" />
						<col width="18%" />
						<col width="31%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>유형</th>
							<td>
								 <select id="sbtype" name="sbtype">
                                  <option <%=(sbtype.equals("ALL") ? "selected" : "")%> value = "ALL">전체</option>
                                  <option <%=(sbtype.equals("NT") ? "selected" : "")%> value = "NT">공지사항</option>
                                  <option <%=(sbtype.equals("EB") ? "selected" : "")%> value = "EB">e-Biz뉴스</option>
                                  <option <%=(sbtype.equals("DI") ? "selected" : "")%> value = "DI">전시회 행사소식</option>
                                  <option <%=(sbtype.equals("PI") ? "selected" : "")%> value = "PI">구매정보</option>
                                  <option <%=(sbtype.equals("EM") ? "selected" : "")%> value = "EM">e마켓자료실</option>
                                  <option <%=(sbtype.equals("SI") ? "selected" : "")%> value = "SI">상품정보자료실</option>
                                  <option <%=(sbtype.equals("WM") ? "selected" : "")%> value = "WM">물류센터공지사항</option>
                              </select> 
							</td>
							<th>게시범위</th>
							<td>
								<select id="sacl" name="sacl">
                                  <option <%=(sacl.equals("ALL") ? "selected" : "")%> value = "ALL">전체</option>
                                  <option <%=(sacl.equals("MEB") ? "selected" : "")%> value = "MEB">회원전체</option>
                                  <option <%=(sacl.equals("SEL") ? "selected" : "")%> value = "SEL">판매사</option>
                                  <option <%=(sacl.equals("BUY") ? "selected" : "")%> value = "BUY">고객사</option>
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

				<form name = "contentForm"  id="contentForm" method = "post">
					<table id="table_list" class="cont_t_list03" >
					<colgroup>
                        <col width="5%" />
                        <col width="10%" />
                        <col width="10%" />
                        <col width="30%" />
                        <col width="10%" />
                        <col width="10%" /> 
                        <col width="10%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">유 형</th>
                            <th scope="col">게시범위</th>
                            <th scope="col">제 목</th>
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
                        <td colspan="7" align="center" height = "50">
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
		                       <td><%=CommonUtil.nvl( rowData.get("BTYPE_DIS"))%></td>
		                       <td><%=CommonUtil.nvl( rowData.get("ACL_DIS"))%></td>
		                       <td class="left"><a href="javascript:kepEditForm('<%=CommonUtil.bnvl( rowData.get("BID"))%>','<%=CommonUtil.bnvl( rowData.get("BTYPE"))%>')"><%=CommonUtil.nvl( rowData.get("SUBJECT"))%></a></td>
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

</div>
 
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	 
 
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){
	
}
/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){ 
	$("#curPage").val(curPage);
	$('#searchCondition').attr("action", "/mdam/getMasterMdAmInfoReference.do").submit();   
}


/**
 * FORM 을 초기화
 */
function kepReload(){
	$("#sbtype").val("ALL");
	$("#sacl").val("ALL");
// 	kepSearch(-1);
	jspTableClean("table_list","7");
} 

/**
 * 등록폼이동
 */
function kepWriteForm(){   
	$('#searchCondition').attr("action", "/mdam/showMasterMdAmInfoReferenceWrite.do").submit();   
}
/**
 * 수정폼이동
 */
function kepEditForm(bid,btype){ 
	
	$("#BID").val(bid);
	$("#BTYPE").val(btype);
	$('#searchCondition').attr("action", "/mdam/getMasterMdAmInfoReferenceDetail.do").submit();
}
</script>
</html>
