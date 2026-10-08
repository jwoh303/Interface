<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.*"%> 

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>고객의소리</title>
</head>

<%
@SuppressWarnings (value="unchecked")
String row_cnt  = ""; 
List<Map<String,String>> _vocList = (List<Map<String,String>>) request.getAttribute("vocList"); // 조회된 결과
int _listCnt	= (Integer) request.getAttribute("listCnt");
String total_cnt	= Integer.toString(_listCnt);
String curPage = CommonUtil.nvl((String) request.getParameter("page_no"),"1"); // 현재페이지  (필수)
String onepagerow = "10";
String buyer	= CommonUtil.nvl(request.getParameter("st_buyer"),"KRSAMS0123");
String user_name	= CommonUtil.nvl(request.getParameter("st_user_name"),"");
String user_email	= CommonUtil.nvl(request.getParameter("st_user_email"),"");
String user_telno	= CommonUtil.nvl(request.getParameter("st_user_telno"),"");
String legacy_po_no	= CommonUtil.nvl(request.getParameter("st_legacy_po_no"),"");
String buyer_item_no	= CommonUtil.nvl(request.getParameter("st_buyer_item_no"),"");
String st_voc_type = request.getParameter("st_voc_type");
String search_text = CommonUtil.nvl(request.getParameter("st_search_text"),"");;
%>

<link rel="stylesheet" href="/resources/styles/externVoc.css">
<script type="text/javascript">
function initToggle(tabContainer) {
	triggers = tabContainer.getElementsByTagName("a");

	for(i = 0; i < triggers.length; i++) {
		if (triggers.item(i).href.split("#")[1])
			triggers.item(i).targetEl = document.getElementById(triggers.item(i).href.split("#")[1]);

		if (!triggers.item(i).targetEl)
			continue;

		triggers.item(i).targetEl.style.display = "none";
		triggers.item(i).onclick = function () {
			if (tabContainer.current == this) {
				this.targetEl.style.display = "none";
				tabContainer.current = null;
			} else {
				if (tabContainer.current) {
					tabContainer.current.targetEl.style.display = "none";
				}
				this.targetEl.style.display = "block";
				tabContainer.current = this;
			}
			return false;
		}
	}
};
</script>

<script type="text/javascript">
var VocWritePop;

function doAction(str) {
	switch (str) {
	case "reload":	// 초기화
		kepReload("contentForm");
		break;
	}
}
	
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	document.forms.searchForm.st_search_text.value = document.getElementById("search_text").value; 
	document.forms.searchForm.st_voc_type.value = document.getElementById("voc_type").value; 
	$('#searchForm').attr("action", "/extern/getExternVocList.do").submit();
}

function rtnCall() {
	VocWritePop.close();
	kepSearch(1);
} 

function kepAjaxSuccess(pMethod , response){
	alert("kepAjaxSuccess");
}

function kepAjaxError(pMethod , response){
	alert("kepAjaxError : " + response.Message);
}

function popCall() {
	
	VocWritePop	= null;
	VocWritePop	= window.open("about:blank", "VocWritePop","width=800,height=600,scrollbars=no, resize=no");
	
	var form = document.forms.popupForm;
	form.action = "/extern/getExternVocWrite.do";
	form.target = "VocWritePop";
	form.method	= "post";
	form.submit();
	
	VocWritePop.focus();
}
</script>

<body>
<div class="wrap" >
    <div class="vocbanner">
        <div>KeP - Voice Of Customer</div>
        <div> <a href="javascript:popCall();">고객센터 문의하기 +</a></div>
    </div>
    <div class="answer_box" id="voc_list">
         <!-- 검색조건 -->
<form name = "searchForm" id="searchForm" method = "post">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer%>"/>
	<input type="hidden" name="st_user_name" id="st_user_name" value="<%=user_name%>"/>
	<input type="hidden" name="st_user_email" id="st_user_email" value="<%=user_email%>"/>
	<input type="hidden" name="st_user_telno" id="st_user_telno" value="<%=user_telno%>"/>
	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=buyer_item_no%>"/>
	<input type="hidden" name="st_legacy_po_no" id="st_legacy_po_no" value="<%=legacy_po_no%>"/>
	<input type="hidden" name="st_search_text" id="st_search_text" value="<%=search_text%>"/>
	<input type="hidden" name="st_voc_type" id="st_voc_type"/>             	
        <div class="vocboard_search">
            <div>내용&nbsp;:&nbsp; 
            	<input type="text" name="search_text" id="search_text" value="<%=search_text%>">
        	</div>
            <div>VOC유형&nbsp;:&nbsp;
	            <select name="voc_type" id="voc_type">
                    <option value="">선택</option>
                    <option value="ZO" <% if("ZO".equals(st_voc_type)) { out.println("selected"); } %>>주문</option>
                    <option value="ZA" <% if("ZA".equals(st_voc_type)) { out.println("selected"); } %>>품목</option>
                    <option value="ZP" <% if("ZP".equals(st_voc_type)) { out.println("selected"); } %>>가격</option>
                    <option value="ZE" <% if("ZE".equals(st_voc_type)) { out.println("selected"); } %>>기타의견</option>
	            </select>
	        </div>
            <div class="search_btn">
                <a href="javascript:kepSearch(1);"><p class="search_btn01"> 검색</p></a>
            </div>
        </div>
        <!-- 테이블 시작 --> 
        <div class="voctable_tit"><p>요청번호</p><p>진행상태</p><p>VOC유형</p><p>내용</p><p>요청일</p></div>
        <%
        if ( _vocList == null || _vocList.size() == 0 ) {
        %>	
        	<div class="voctable_list">
	            <div>&nbsp;</div>
	            <div>&nbsp;</div>
	            <div>&nbsp;</div>
	            <div>등록된 요청사항이 없습니다.</div>
	            <div>&nbsp;</div>
        	</div>
        <%
        } else {
        	int idx	= 0;
        	for (Map<String, String> iMap : _vocList) {
        		idx++;
		%>
            <div class="voctable_list">
                <div><%=CommonUtil.bnvl(iMap.get("VC_NO"))%></div>
                <div class="<% if("FB".equals(CommonUtil.bnvl(iMap.get("RECV_FLAG")))) {out.println("Answer_completed");} else {out.println("Review");} %>"><%=CommonUtil.bnvl(iMap.get("RECV_FLAG_TEXT"))%></div>
                <div><%=CommonUtil.bnvl(iMap.get("CLAIM_MASTER"))%>&nbsp;</div>
                <div><a href="#answer<%=idx%>"><%=CommonUtil.bnvl(iMap.get("SUBJECT"))%></a></div>
                <div><%=CommonUtil.bnvl(iMap.get("REQ_DATE"))%></div>
            </div>
	        <div class="voctable_answer" id="answer<%=idx%>" >
	            <div class="answer_Q">
	            	<div> * 발주번호 : <%=CommonUtil.bnvl(iMap.get("PO_NO"))%></div>
	            	<div> * 품목코드 : <%=CommonUtil.bnvl(iMap.get("BUYER_ITEM_NO"))%></div>
	            	<div> * 요청사항 : <%=CommonUtil.bnvl(iMap.get("REQ_REMARK"))%></div>
	            </div>
				<% if("FB".equals(CommonUtil.bnvl(iMap.get("RECV_FLAG")))) {%>
	            <div class="answer_A"><%=CommonUtil.bnvl(iMap.get("DF_REMARK"))%></div>
	            <div class="answer_data">판매자의 답변 등록일 : <%=CommonUtil.bnvl(iMap.get("DF_DATE")) %></div>
	            <%}%>
	        </div>
		<%
        	}
        }
        %>
    </div>
</form>

<form name = "popupForm" id="popupForm" method = "post">
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer%>"/>
	<input type="hidden" name="st_user_email" id="st_user_email" value="<%=user_email%>"/>
</form>
    <script type="text/javascript">initToggle(document.getElementById("voc_list"));</script> 
    <div class="paginate_simple">
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl">총 <%=total_cnt %> 건</span> 
		</p>
    </div>
</div>
</body>
</html>
