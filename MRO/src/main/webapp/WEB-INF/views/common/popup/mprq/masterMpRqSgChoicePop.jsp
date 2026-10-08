<%--
**********************************************
* 메뉴 : 
* 화면 : SG조회
* 기능 : SG조회
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
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
String st_sg_id = CommonUtil.nvl((String) request.getParameter("st_sg_id"),"");  //  (조회조건)
String st_sg_nm = CommonUtil.nvl((String) request.getParameter("st_sg_nm"),"");  //  (조회조건)

String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수) 

String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "10"); // 정렬갯수  
%>

<script type="text/javascript">
<!--
function kepSearch(curPage){
	$("#curPage").val(curPage);
	$('#masterMdCpUserChoicePop').attr("action", "/mprq/getMasterMpRqSgChoicePop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(sg_id, sg_nm)
{ 
  opener.setPopupReturn(sg_id, sg_nm);
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
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">SG정보조회</h1>
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
						<caption>SG리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
                            <col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>SG ID</td>
							<td> 
								<input type=text name="st_sg_id" id="st_sg_id" size=20 value="<%=st_sg_id%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td>SG 명</td>						 
							<td>
								<input type=text name="st_sg_nm" id="st_sg_nm" size=20 value="<%=st_sg_nm%>" onkeydown="kepEnter()" class="input_type_text"> 
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
                    <caption>SG리스트</caption>
                    <colgroup>
                        <col width="40%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">SG ID</th> 
                            <th scope="col">SG 명</th> 
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
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("SG_ID")%>','<%=_tmp.get("SG_NAME")%>')">
							<%=_tmp.get("SG_ID")%></a>
					   </td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("SG_ID")%>','<%=_tmp.get("SG_NAME")%>')">
							<%=_tmp.get("SG_NAME")%></a>
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
