<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 팝업 목록
* 기능 : 
* 프로그램 ID : 
* 담당자 : 2229033
* 착수일 : 2025-02-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
	//공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String search_flag = CommonUtil.nvl((String) request.getParameter("search_flag"),"");
		
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),_sessionInfo.getComCode());  // 협력사 코드
	String st_user_id = _sessionInfo.getUserId();
%>

<script type="text/javascript">

function buildOption(pOptions){	
	var _options  = pOptions.split(",");
	var _leftPosition = (screen.width) ? (screen.width - parseInt(_options[0])) / 2 : 0; 
	var _topPosition = (screen.height) ? (screen.height - parseInt(_options[1])) / 2 : 0;
	
	var _builtOption = "";
	// 오늘 하루 이 창을 열지 않기가 보이지 않도록 처리
	_options[1] = parseInt(_options[1])-parseInt(50);
	_builtOption += "width="+_options[0]+ ", height="+ _options[1]+", top="+_topPosition+", left="+_leftPosition+", scrollbars="+_options[2]+" ,status=0, location=0, titlebar=0,menubar=0";
	
	return _builtOption;
}

function setCookie(name,value,expiredays) {
	var todayDate = new Date();
	todayDate.setDate(todayDate.getDate() + expiredays);
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

function closeWin() {
	if(document.sellerNoNePopupListPop.popup.checked == true) {
		setCookie("ncookpopup", "donepopup" ,1);
	}
	self.close();
}

function kep_onload_view(){
	<% if (!"Y".equals(search_flag)){ %>
		kepSearch("1");
	<% } %>
}

//조회
function kepSearch(curPage){
	document.forms.sellerNoNePopupListPop.curPage.value = curPage; 
	$('#sellerNoNePopupListPop').attr("action", "/none/getSellerNoNePopupListPop.do").submit();   
}

function setPopup_List_Display_Sel(pid, popt){
	popupWindow = window.open("/resources/html/main/notice/"+pid+".htm",pid,buildOption(popt));
	popupWindow.opener = self;
	
	var data = { st_popup_id : pid, st_com_code : '<%=st_com_code%>', st_user_id :'<%=st_user_id%>'};
	kepAjaxCallNoBar('/none/saveSellerNoNePopupRead.do',data,'seller_popup_read');
}

function kepAjaxSuccess(pMethod , response){
	if(pMethod == 'seller_popup_read'){
		kepSearch($('#curPage').val());
	}
}

function kepAjaxError(pMethod , response){
	alert("조회에 실패하였습니다.\n\n관리자에 문의하여 주십시오."); 
}
</script> 
<body onload="kep_onload_view()">
<form name="sellerNoNePopupListPop" id="sellerNoNePopupListPop" method=post >
	<!--HIDDEN-->	
	<!-- 공통 -->
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage%>" />
	<input type="hidden" name="onepagerow" id="onepagerow" value="10">
	<!-- 화면 내 정의 -->
	<input type="hidden" name="search_flag" id="search_flag" value="Y">
	<input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_com_code%>">
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
<div id="popup_board" style="height:40px; line-height:70px; font-size:21px;font-family:맑은 고딕; font-weight:bold;  color:#000; letter-spacing:-1.5px; text-align:center;  background-color:#FFF ">팝업 공지사항</div>
    <div style="padding:20px; height:330px">
        <table class="cont_t_list02"  style="width:100%">
            <caption>팝업 공지사항</caption>
            <colgroup>
					<col width="10%" />
					<col width="7%" />  
					<col width="*" /> 
					<col width="7%" /> 
				</colgroup>
				<thead>
					<tr>
				    	<th scope="col">순번</th>
				    	<th scope="col" colspan="3">제목 </th> 
					</tr>
				</thead>
				<tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
					<tr bgcolor="#FFFFFF">
						<td colspan="3" align="center" height = "280px">
							<span class="font1">조회된 팝업이 없습니다.</span>
						</td> 
					</tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
					<tr align="center" bgcolor=<%if(j % 2 != 0){%>"#FFFFFF"<%}else{ %> "#FAFAFA"<%} %>>
						<td><%=j+1%></td>
						<td><b>
							<%if(_tmp.get("GUBUN").equals("ALL")){%>
							<font face=Verdana color = red>전사</font>
							<%}else{%>
							<font face=Verdana color = blue>고객사</font>
							<%}%>
						</b></td>
						<td class="left">
							<a class="hyperLink" href="javascript:setPopup_List_Display_Sel('<%=_tmp.get("POPUP_ID")%>','<%=_tmp.get("POPUP_OPTION")%>')">&nbsp;<%=CommonUtil.nvl(_tmp.get("POPUP_TITLE"))%></a>
						</td>
						<td><%if(_tmp.get("READ_YN").equals("2")){%>읽음<%}%></td>
					</tr> 
<% } 
}%>                   
				</div>            
				</tbody>
			</table>
            <!-- 페이징 -->
			<p class="paging">
				<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage, onepagerow) %> 
			</p>
    </div>
	<div style="width:100%; height:50px; line-height:50px; text-align:center;  font-size:13px; color:#FFF; background-color:#696564; clear:both;">
		<input type="checkbox" name="popup" checked="checked" style=" vertical-align:middle; border:0" />
		<a href="#" onclick="closeWin()" style="color:#FFF">오늘하루 이 창을 열지 않기&nbsp;&nbsp;<span style="border:1px solid #817c7c; padding:9px 150px">닫기</span></a>
	</div>
</div>
<!--팝업div창 끝-->
</form> 
</body>
</html>