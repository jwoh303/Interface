<%--
**********************************************
* 메뉴 : 판촉물전용마켓
* 화면 : 판촉물전용마켓 Header
* 기능 : 
* 프로그램 ID : 
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="/resources/styles/koreab2b_base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/promote.css" type="text/css">
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<c:if test="${jqueryGbn ne 'Y' }">
	<script src="/resources/libs/jquery/js/jquery-3.6.0.min.js"></script>
</c:if>
<%
	//검색 조회조건
	String key_src = CommonUtil.nvl((String) request.getParameter("st_key_src"),"");
	String key_type = CommonUtil.nvl((String) request.getParameter("st_key_type"),"description");
	
	//상세검색 조회조건
	String st_detail_item_no = CommonUtil.nvl((String) request.getParameter("st_detail_item_no"),"");
	String st_detail_maker_name = CommonUtil.nvl((String) request.getParameter("st_detail_maker_name"),"");
	String st_detail_description = CommonUtil.nvl((String) request.getParameter("st_detail_description"),"");
	String st_detail_specification = CommonUtil.nvl((String) request.getParameter("st_detail_specification"),"");
	String st_detail_min_user_price = CommonUtil.nvl((String) request.getParameter("st_detail_min_user_price"),"");
	String st_detail_max_user_price = CommonUtil.nvl((String) request.getParameter("st_detail_max_user_price"),"");
	
	//카테고리 조회조건
	String st_std_categ_id = CommonUtil.nvl((String) request.getParameter("st_std_categ_id"),"");
	String st_pid = CommonUtil.nvl((String) request.getParameter("st_pid"),"");
	
	
%>
<!-- (Header) -->
<form id="headerForm" name="headerForm" method="post">
<input type="hidden" id="onepagerow" name="onepagerow" value="20" /> 
<input type="hidden" id="curPage" name="curPage" value="1" /> 
<input type="hidden" id="st_detail_item_no" name="st_detail_item_no" value="<%=st_detail_item_no %>" />
<input type="hidden" id="st_detail_maker_name" name="st_detail_maker_name" value="<%=st_detail_maker_name %>" />
<input type="hidden" id="st_detail_description" name="st_detail_description" value="<%=st_detail_description %>" />
<input type="hidden" id="st_detail_specification" name="st_detail_specification" value="<%=st_detail_specification %>" />
<input type="hidden" id="st_detail_min_user_price" name="st_detail_min_user_price" value="<%=st_detail_min_user_price %>" />
<input type="hidden" id="st_detail_max_user_price" name="st_detail_max_user_price" value="<%=st_detail_max_user_price %>" />
<input type="hidden" id="st_std_categ_id" name="st_std_categ_id" value="<%=st_std_categ_id %>" />
<input type="hidden" id="st_pid" name="st_pid" value="<%=st_pid %>" />

	<div id="headerWrap">
        <!--검색-->
        <div class="headerSearch">
            <h1><a href="/promote_index.html"><img src="/resources/images/promote/logo_mall.jpg" alt="kep 판촉물 전용마켓" /></a></h1>
            <div class="headerSearchArea">
            	<select id="st_key_type" name="st_key_type" class="site">
                        <option value="description" <%if ("description".equals(key_type)) {%>selected<%} %>>상품명</option>
                        <option value="item_no" <%if ("item_no".equals(key_type)) {%>selected<%} %>>상품코드</option>
                        <option value="specification" <%if ("specification".equals(key_type)) {%>selected<%} %>>상품규격</option>
                        <option value="maker_name" <%if ("maker_name".equals(key_type)) {%>selected<%} %>>제조사</option>
                        <option value="category_no" <%if ("category_no".equals(key_type)) {%>selected<%} %>>카테고리</option>
                    </select>
                    <input id="st_key_src" name="st_key_src" type="text" value="<%=(key_src.equals("") ? "검색어를 입력하십시요." : key_src)%>" onBlur="checkField(this)" onFocus="clearField(this)" onKeyDown="if(event.keyCode==13){  doSearch(); };" />
                    <a href="javascript:doSearch();"><img src="/resources/images/promote/b_btn_search.jpg" alt="검색하기" class="searchBtn" /></a> 
            </div>
            <div><a href="javascript:getSearchDetail();"><span class="searchBtnDetail">상세검색</span></a></div>
        </div><!--검색끝-->
        <!--메뉴부분-->
        <div class="Gnb" >
            <div class="GnbTop">
                <ul> 
                    <li><a href="#">Kyocera</a></li>
                   <li><a href="#">BenQ</a></li>
                    <!-- li><a href="#">일반사무용품</a></li>
                    <li><a href="#">주방용품</a></li>
                    <li><a href="#">레저/건강용품</a></li>
                    <li><a href="#">차량용품</a></li>
                    <li><a href="#">생활잡화</a></li>
                    <li><a href="#">기타상품</a></li -->
                    <li class="ContactUs"><a href="javascript:contactPop();" >CONTACT US</a></li>
                </ul>
            </div>
            <div class="GnbSub">
                <ul style="left:0px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('2','4');">Kyocera</a></li> 
                    
                </ul>
                <ul style="left:100px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('3','5');">BenQ</a></li>
                </ul>
                <!-- ul style="left:200px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('14','15');">파일</a> │</li>
                    <li><a href="javascript:setKeyCategory('14','16');">만년필</a> │</li>
                    <li><a href="javascript:setKeyCategory('14','17');">볼펜</a> │</li>
                    <li><a href="javascript:setKeyCategory('14','18');">샤프/연필</a> │</li>
                    <li><a href="javascript:setKeyCategory('14','41');">필기구Set</a> │</li>
                    <li><a href="javascript:setKeyCategory('14','42');">계산기</a> │</li>
                    <li><a href="javascript:setKeyCategory('14','43');">메모지/수첩/다이어리등 지류</a></li>
                </ul>
                <ul style="left:300px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('20','21');">용기</a> │</li>
                    <li><a href="javascript:setKeyCategory('20','22');">냄비</a> │</li>
                    <li><a href="javascript:setKeyCategory('20','23');">컵/찻잔</a> │</li>
                    <li><a href="javascript:setKeyCategory('20','24');">기타</a></li>
                </ul>
                <ul style="left:400px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('25','26');">스포츠관련용품</a> │</li>
                    <li><a href="javascript:setKeyCategory('25','27');">여행관련용품</a> │</li>
                    <li><a href="javascript:setKeyCategory('25','28');">건강관리용품</a> │</li>
                    <li><a href="javascript:setKeyCategory('25','29');">기타</a></li>
                </ul>
                <ul style="left:500px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('30','31');">차량악세서리</a> │</li>
                    <li><a href="javascript:setKeyCategory('30','32');">안전용품</a> │</li>
                    <li><a href="javascript:setKeyCategory('30','33');">기타</a></li>
                </ul>
                <ul style="left:600px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('34','35');">우산</a> │</li>
                    <li><a href="javascript:setKeyCategory('34','36');">타올</a> │</li>
                    <li><a href="javascript:setKeyCategory('34','37');">시계</a> │</li>
                    <li><a href="javascript:setKeyCategory('34','38');">기타</a></li>
                </ul>
                <ul style="left:700px;display:none;"> 
                    <li><a href="javascript:setKeyCategory('39','44');">미용관련용품</a> │</li>
                    <li><a href="javascript:setKeyCategory('39','45');">위생용품</a> │</li>
                    <li><a href="javascript:setKeyCategory('39','40');">기타</a></li>
                </ul -->
            </div>
        </div><!--메뉴부분끝-->
    </div><!--headerWrap끝-->
</form>
<script type="text/javascript">
<!--
var tabMenu = $(".GnbTop ul>li>a");
var tabSubMenu = $(".GnbSub>ul");
var popupSel = "";

//탭메뉴 를 클릭했을때
tabMenu.on("click", function(e){    
	// 클릭한 메뉴가 몇번째 메뉴인지 가져옴    
	var idx = tabMenu.index($(this));     
	// 모든 서브메뉴 안보이게
	tabSubMenu.hide();    
	// 서브메뉴중에서 클릭한 메뉴에 해당하는 서브메뉴만 보이게   
	tabSubMenu.eq(idx).show();     
});

function contactPop(){
	openSearchPopup("/resources/html/promote/contactus_popup.htm", "", "400,225,no");
}

function getSearchDetail(){
	popupSel = "searchDetail";
	openSearchPopup("/promote/search_detail.do", "", "480,280,no");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "searchDetail": //상세검색
			//다른 조회param 초기화
			resetCategory();	
			$("#st_key_src").val("");
			
			$("#st_detail_item_no").val(value1);
			$("#st_detail_maker_name").val(value2);
			$("#st_detail_description").val(value3);
			$("#st_detail_specification").val(value4);
			$("#st_detail_min_user_price").val(value5);
			$("#st_detail_max_user_price").val(value6);
			
			doSubmit("/promote/promote_PDSearch.do");
			break;
	}
}

function clearField(field){
	if (field.value == field.defaultValue) { field.value = ""; } 
}

function checkField(field){
	if (field.value == "") { field.value = field.defaultValue; } 
}

//상품 검색
function doSearch() {
	var key_word	= "검색어를 입력하십시요.";
	var key_src		= $("#st_key_src").val();

	if(key_src==key_word) {
		alert("검색어를 입력하십시요.");
		$("#st_key_src").focus();
		return;
	}

	if(isEmpty(key_src)) {
		alert("검색어를 입력하십시요.");
		$("#st_key_src").focus();
		return;
	}
	
	//다른 조회param 초기화
	resetCategory();
	resetDetail();
    doSubmit("/promote/promote_PDSearch.do");
    
    return;
}

function setKeyVword(key_word){
	$("#st_key_type").val("description");
	$("#st_key_src").val(key_word);
	
	//다른 조회param 초기화
	resetCategory();
	resetDetail();
	doSubmit("/promote/promote_PDSearch.do");
}

function setKeyCategory(pid, std_categ_id){
	$("#st_pid").val(pid);
	$("#st_std_categ_id").val(std_categ_id);
	
	//다른 조회param 초기화
	resetDetail();
	$("#st_key_src").val("");
	
	doSubmit("/promote/promote_PDCategory.do");
}

//상세검색조건은 초기화
function resetDetail(){
	$("#st_detail_item_no").val("");
	$("#st_detail_maker_name").val("");
	$("#st_detail_description").val("");
	$("#st_detail_specification").val("");
	$("#st_detail_min_user_price").val("");
	$("#st_detail_max_user_price").val("");
}

//카테고리 검색조건 초기화
function resetCategory(){
	$("#st_std_categ_id").val("");
	$("#st_pid").val("");
}

function doSubmit(action){
	$('#headerForm').attr("action", action);
    $('#headerForm').submit();
}

//상품상세조회.
function setKeyDetail(pid, item_no){
	$("#st_pid").val(pid);
	$("#st_detail_item_no").val(item_no);

	doSubmit("/promote/promote_PDDetail.do");
}
	
//-->	
</script>
