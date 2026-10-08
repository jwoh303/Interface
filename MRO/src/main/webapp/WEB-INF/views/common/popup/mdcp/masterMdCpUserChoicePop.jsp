<%--
**********************************************
* 메뉴 : 
* 화면 : 사용자 선택 팝업
* 기능 : 사용자 선택
* 프로그램 ID : PG_01_M_004_03
* 담당자 : 고영일 ( 설계 : 권우재 )
* 착수일 : 2014-07-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");  //  (조회조건)
String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),"");  //  (조회조건)

String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수) 

String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "10"); // 정렬갯수  
%>

<script type="text/javascript">
<!--
function kepSearch(curPage){
	$("#curPage").val(curPage);
	$('#masterMdCpUserChoicePop').attr("action", "/mdcp/getMasterMdCpUserChoicePop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(user_id, user_name_loc, phone_number, email ,department, dept_name, address_loc, fax_number)
{ 
  opener.setPopupReturn(user_id, user_name_loc, phone_number, email ,department, dept_name, address_loc, fax_number);
  this.close();
}
 //-->
</script> 
<body onload="">
<form name="masterMdCpUserChoicePop" id="masterMdCpUserChoicePop" method=post >
	<!--HIDDEN-->
	<!-- 공통 -->
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<!-- 화면 내 정의 -->
	<input type="hidden" name="st_buyer" value="<%=st_buyer%>"/>
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사용자 선택 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>사용자 선택  리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
                            <col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>사용자 ID</td>
							<td> 
								<input type=text name="st_user_id" id="st_user_id" size=20 value="<%=st_user_id%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td>사용자 명</td>						 
							<td>
								<input type=text name="st_user_name" id="st_user_name" size=20 value="<%=st_user_name%>" onkeydown="kepEnter()" class="input_type_text"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>
             <span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		      	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" onChange="javascript:kepSearch(1);">   
					<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
					<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
					<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
					<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
					<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				</select>
	      	</span>
			<br>
           	<!--grid-->
            <div class="scrollArea" style="height:308px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>사용자 선택  리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="20%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">사용자ID</th> 
                            <th scope="col">사용자명</th> 
                            <th scope="col">전화번호</th> 
                            <th scope="col">e-Mail</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "260">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("USER_ID")%>','<%=_tmp.get("USER_NAME_LOC")%>','<%=_tmp.get("PHONE_NUMBER")%>','<%=_tmp.get("EMAIL")%>','<%=_tmp.get("DEPARTMENT")%>','<%=_tmp.get("DEPT_NAME")%>','<%=_tmp.get("ADDRESS_LOC")%>','<%=_tmp.get("FAX_NUMBER")%>')">
							<%=CommonUtil.nameMasking(_tmp.get("USER_ID"))%></a>
					   </td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("USER_ID")%>','<%=_tmp.get("USER_NAME_LOC")%>','<%=_tmp.get("PHONE_NUMBER")%>','<%=_tmp.get("EMAIL")%>','<%=_tmp.get("DEPARTMENT")%>','<%=_tmp.get("DEPT_NAME")%>','<%=_tmp.get("ADDRESS_LOC")%>','<%=_tmp.get("FAX_NUMBER")%>')">
							<%=CommonUtil.nameMasking(_tmp.get("USER_NAME_LOC"))%></a>
					   </td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("USER_ID")%>','<%=_tmp.get("USER_NAME_LOC")%>','<%=_tmp.get("PHONE_NUMBER")%>','<%=_tmp.get("EMAIL")%>','<%=_tmp.get("DEPARTMENT")%>','<%=_tmp.get("DEPT_NAME")%>','<%=_tmp.get("ADDRESS_LOC")%>','<%=_tmp.get("FAX_NUMBER")%>')">
							<%=CommonUtil.phoneMasking(CommonUtil.nvl(_tmp.get("PHONE_NUMBER")))%></a>
					   </td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("USER_ID")%>','<%=_tmp.get("USER_NAME_LOC")%>','<%=_tmp.get("PHONE_NUMBER")%>','<%=_tmp.get("EMAIL")%>','<%=_tmp.get("DEPARTMENT")%>','<%=_tmp.get("DEPT_NAME")%>','<%=_tmp.get("ADDRESS_LOC")%>','<%=_tmp.get("FAX_NUMBER")%>')">
							<%=CommonUtil.emailMasking(CommonUtil.nvl(_tmp.get("EMAIL")))%></a>
					   </td>
                    </tr> 
<% } 
}%>                               
                    </tbody>
                </table>
	        </div>
            <!-- 페이징 -->
			<p class="paging">
				<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %>
			</p>
	    </div>        
	</div>
</form> 
</body>
</html>
