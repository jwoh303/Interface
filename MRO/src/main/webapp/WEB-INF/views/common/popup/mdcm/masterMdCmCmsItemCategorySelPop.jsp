<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리
* 화면 : (팝업) 상세분류 선택 (카테고리 트리에서 상세분류 선택 + 하단 속성 확인)
* 기능 : 표준 카테고리 트리를 조회해 상세분류를 선택하고, 선택한 상세분류의 속성을 하단에 노출한다.
*        - mprq masterMpRqKepStndrdCategorySelPop 을 master/mdcm 전용으로 풀클론
*        - 기존 '설명' 영역 → '속성' 패널로 교체 (속성 백엔드는 현재 STUB, 실 테이블 확정 시 매퍼 교체)
* 담당자 : 홍준우
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<style type="text/css">
/* 카테고리 트리 선택/사전세팅 하이라이트 (인라인 onClick/onBlur 색토글을 !important로 지배) */
#cateArea2 a.cateSelected { color:#2c96da !important; font-weight:bold; }
</style>
</head>
<%
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = _sessionInfo.getUserId();
// 리스트 그리드 상세분류 클릭으로 진입 시 넘어오는 상세분류코드 (사전세팅용)
String preCategId = CommonUtil.nvl(request.getParameter("st_pre_categ_id"));
%>

<body onload="kep_onload_view(); ">
<form name="masterMdCmCmsItemCategorySelPop" id="masterMdCmCmsItemCategorySelPop" method=post  onsubmit="return false;">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">상세분류 선택 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	 <div class="fl">
				<input type="checkbox" id="st_result" name="st_result" style="margin-top: 5px"/></span>&nbsp;&nbsp;검색결과 고정
        	 </div>
             <div class="fr">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>
				<span class="btn_reset"><a href="javaScript:reload();">초기화</a></span>
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>상세분류 선택 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="40%" />
                            <col width="10%" />
                            <col width="40%" />
						</colgroup>
						<tbody>
						<tr>
							<td>검색어</td>
							<td colspan="3">
								<input type=text name="st_searh_name" id="st_searh_name" size=20 value="" onkeydown="kepEnter()" class="input_type_text">
                            </td>
						</tr>
					</tbody>
				</table>
            </div>
           	<!--grid-->
            <div class="mb05" style="height:305px">

                <div id="cateArea2" style="width: 100%; height: 305px;">
	            	<div id="cateE">
	                	<p class="cateTitle2">대분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu" id="cateMenu1">
	                        </ul>
	                    </div>
	                </div>

	              <div id="cateF">
	                	<p class="cateTitle2">중분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu2">
	                        </ul>
	                  </div>
	                </div>

	                <div id="cateG">
	                	<p class="cateTitle2">소분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu3">
	                        </ul>
	                    </div>
	                </div>

	                <div id="cateH">
	                	<p class="cateTitle2">상세분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu4">
	                        </ul>
	                    </div>
	                </div>
            </div>

        </div>
   		<!-- btnArea -->
   		<div>
   			<font color="#003399">선택한 상세분류</font>&nbsp;
   			<input type="hidden" id="st_sg_id" name="st_sg_id" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_sg_name" name="st_sg_name" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_categ_id" name="st_categ_id" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_categ_name" name="st_categ_name" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_choice_type" name="st_choice_type" style="width:50px;" value="OFFCATE" readonly="readonly" >
   			<input type="text" class="input_type_text" id="st_category_path" name="st_category_path" style="width:460px;" value="" readonly="readonly" >
   			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_02"><a href="javascript:setReturn();">확인</a></span>
   			<br><font color="#FF5E00" class="b">※상세분류만 선택 가능</font>
   		</div>
   		<br/>
   		<!-- 속성 패널 (기존 '설명' 영역 대체). 상세분류(ITM) 클릭 시에만 노출. 속성명을 회색 헤더셀로 가로 배치, 많으면 아래 줄로. -->
   		<div id="attrPanel" style="display:none; margin-top:8px;">   			
   			<div style="max-height:120px; overflow-y:auto;">
   				<table id="attrTable" style="width:100%; table-layout:fixed; border-collapse:collapse;">
   					<caption class="hidden">선택 상세분류 속성정보</caption>
   					<tbody id="attrTableBody">
   					</tbody>
   				</table>
   			</div>
   		</div>
    </div>
</div>
</form>
<form name="categForm" id="categForm" method="post" action ="">
    <input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
    <input type="hidden" name="st_sour_dept_yn" id="st_sour_dept_yn" value="N">
    <input type="hidden" name="st_sg_req_yn" id="st_sg_req_yn" value="N">
    <input type="hidden" name="st_sour_sg_id" id="st_sour_sg_id" value="">
</form>
</body>

<script type="text/javascript">
var nodata = "<li>조회 내용이 없습니다.</li>";

function kep_onload_view(){
	kep_categori_clear();

	// 리스트 그리드 상세분류 클릭 진입 시 해당 상세분류로 사전세팅(트리 드릴다운+하이라이트 포함)
	var preCategId = "<%=preCategId%>";
	if (preCategId != "") {
		kep_presetCategory(preCategId);
	} else {
		// 카테고리 조회 (기본 대분류)
		kep_getCategoriList("1","");
	}
}

/*
 * 넘어온 카테고리ID로 4단 트리 드릴다운 + 각 단계 선택 하이라이트 + 선택 필드(경로/명/SG) + 하단 속성 노출
 */
function kep_presetCategory(categId){
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getMasterMdCmCmsItemCategoryInfo.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_categ_id: categId },
	     async : false,
	     success:function( response ) {
	    	var d = response.data;
	    	if (d != null) {
	    		// 4단 트리 드릴다운(각 depth를 부모 id로 로드) + 해당 항목 하이라이트. kep_getCategoriList는 async:false → 순차 보장.
	    		if (d.DEPTH1_ID) { kep_getCategoriList("1", "");           kep_highlightCate(1, $.trim(d.DEPTH1_ID)); }
	    		if (d.DEPTH2_ID) { kep_getCategoriList("2", d.DEPTH1_ID);  kep_highlightCate(2, $.trim(d.DEPTH2_ID)); }
	    		if (d.DEPTH3_ID) { kep_getCategoriList("3", d.DEPTH2_ID);  kep_highlightCate(3, $.trim(d.DEPTH3_ID)); }
	    		if (d.DEPTH4_ID) { kep_getCategoriList("4", d.DEPTH3_ID);  kep_highlightCate(4, $.trim(d.DEPTH4_ID)); }
	    		$("#st_category_path").val($.trim(d.CATEG_PATH));
	    		$("#st_categ_name").val($.trim(d.CATEG_NAME));
	    		$("#st_sg_id").val($.trim(d.SG_ID));
	    		$("#st_sg_name").val($.trim(d.SG_NAME));
	    	}
	    	$("#st_categ_id").val(categId);
	    	kep_getCategoriAttr(categId); // 하단 속성 노출 (4단 로드 뒤 맨 끝: 각 로드가 속성패널 hide 하므로)
	      },
	     error:function( response ) {
	    	 alert("오류발생하였습니다.");
	      }
    });
}

/*
 * 특정 depth 카테고리 목록에서 선택 대상 항목을 하이라이트 (렌더된 앵커의 href/onclick에서 categ_id 매칭)
 */
function kep_highlightCate(depth, selId){
	if (!selId) return;
	$("#cateMenu"+depth+" a").each(function(){
		var s = ($(this).attr("href") || "") + ($(this).attr("onclick") || "");
		if (s.indexOf("'"+selId+"'") > -1) {
			$(this).addClass("cateSelected");
		}
	});
}

/*
 * 트리 항목 클릭 시 단일 선택 하이라이트: 클릭한 열 + 하위 열의 기존 하이라이트 해제 후 클릭 항목만 활성
 */
$(function(){
	$(document).on("click", "#cateMenu1 a, #cateMenu2 a, #cateMenu3 a, #cateMenu4 a", function(){
		var depth = parseInt(($(this).closest("ul").attr("id") || "cateMenu1").replace("cateMenu",""), 10);
		for (var d = depth; d <= 4; d++) { $("#cateMenu"+d+" a.cateSelected").removeClass("cateSelected"); }
		$(this).addClass("cateSelected");
	});
});

function kepSearch()
{
	searchAll1(1);
	searchAll2(2);
	searchAll3(3);
	searchAll4(4);

}

function searchAll1(depth) {
	var strTmp = "";
	var p_depth = eval(depth)+1;
	var st_searh_name = $("#st_searh_name").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();

	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {

    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){

 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID"));
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME"));
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH"));
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE"));
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT"));
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID"));
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));

 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			} else {
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }
    		  }else{
    			  strTmp = nodata;
    		  }
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {
	    	 alert("오류발생하였습니다.");
		      }
    });
}
function searchAll2(depth) {
	var strTmp = "";
	var p_depth = eval(depth)+1;
	var st_searh_name = $("#st_searh_name").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();

	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {

    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){

 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID"));
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME"));
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH"));
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE"));
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT"));
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID"));
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));

 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			} else {
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }
    		  }else{
    			  strTmp = nodata;
    		  }
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {
	    	 alert("오류발생하였습니다.");
		      }
    });
}
function searchAll3(depth) {

	var strTmp = "";
	var p_depth = eval(depth)+1;
	var st_searh_name = $("#st_searh_name").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();

	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {

    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){

 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID"));
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME"));
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH"));
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE"));
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT"));
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID"));
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));

 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			} else {
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }
    		  }else{
    			  strTmp = nodata;
    		  }
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {
	    	 alert("오류발생하였습니다.");
		      }
    });
}
function searchAll4(depth) {
	var strTmp = "";
	var p_depth = eval(depth)+1;
	var st_searh_name = $("#st_searh_name").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();

	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {

    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){

 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID"));
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME"));
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH"));
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE"));
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT"));
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID"));
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));

 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}
	    			}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			} else {
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }
    		  }else{
    			  strTmp = nodata;
    		  }
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {
	    	 alert("오류발생하였습니다.");
		      }
    });
}

function reload(){
	kepReload('masterMdCmCmsItemCategorySelPop');
	kep_categori_clear();
	kep_getCategoriList("1","");
	document.getElementById("st_result").checked = false;
}


function kepEnter() {
	if (event.keyCode == 13) {
		kepSearch();
	}
}

function setReturn()
{
	if ($("#st_sg_id").val() == ""){
		alert("상세분류만 선택 가능합니다");
		return;
	}
	opener.setPopupReturn($("#st_sg_id").val()
			  						,$("#st_sg_name").val()
			  						,$("#st_categ_id").val()
			  						,$("#st_category_path").val()
			  						,$("#st_categ_name").val()
			  						,$("#st_choice_type").val()
			  						);
	this.close();
}

/*
 * 카테고리 목록조회
 */
function kep_sel_getCategoriList(depth,std_categ_id,categ_name,categ_path) {

	kep_topmenunnavi(depth,std_categ_id,categ_path);
	kep_getCategoriList(depth,std_categ_id); // 분류 depth,카테고리아이디
}

/*
 * 상세분류 선택 → 반환값 세팅 + 하단 속성 조회
 */
function kep_sel_getItmeList(std_categ_id,categ_name,std_categ_path,std_sg_id,std_sg_name){
	$("#st_categ_id").val(std_categ_id);  // 상세분류코드
	$("#st_category_path").val(std_categ_path);  // 상세분류경로
	$("#st_sg_id").val(std_sg_id);  // SG_ID
	$("#st_sg_name").val(std_sg_name);  // SG_NAME
	$("#st_categ_name").val(categ_name);  // 상세분류명
	kep_getCategoriAttr(std_categ_id);  // 하단 속성 조회

}
/*
 * 카테고리 보인후 선택된 대상 출력
 */
function kep_topmenunnavi(depth,categ_id,categ_path){

	    $("#st_sg_id").val("");  // SG_ID
		$("#st_sg_name").val("");  // SG_NAME
	if (depth == 2){
	    $("#st_categ_id").val("");  // 카테고리번호
		$("#st_category_path").val("");  // 카테고리경로
		$("#cateMenu3").html(nodata);
		$("#cateMenu4").html(nodata);
	} else {
	    $("#st_categ_id").val(categ_id);  // 카테고리번호
		$("#st_category_path").val(categ_path);  // 카테고리경로
	}
}

/*
 * 카테고리 보인후 화면 출력
 */
function kep_getCategoriList(depth,std_categ_id) {
		kep_getCategoriAttr("");
		if(document.getElementById("st_result").checked == true){
			return;
		}
		var strTmp = "";
		var p_depth = eval(depth)+1;
		var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
		var st_user_id  = $("#st_user_id").val();
		var st_sour_sg_id  = $("#st_sour_sg_id").val();

		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getMasterMdCmCmsItemCategorySelPop.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param2: depth,param3: std_categ_id, st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
		     async : false,
		     success:function( response ) {

	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){

	 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID"));
	 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME"));
	 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH"));
	 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE"));
	 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT"));
	 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID"));
	 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));
	 		    		if (D_CNT == "0"){
	 		    			if (D_CATEG_TYPE == "ITM"){
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
	 		    			}else{

		 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
	 		    			}
 		    			}else{
	 		    			if (D_CATEG_TYPE == "ITM"){
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
	 		    			} else {
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
	 		    			}
	 		    		}
		 		      }
	    		  }else{
	    			  strTmp = nodata;
	    		  }

					$("#cateMenu"+depth).html(strTmp);

			      },
			 error:function( response ) {
		    	 alert("오류발생하였습니다.");
			      }
	    });
}

var ATTR_COLS_PER_ROW = 5;  // 한 줄에 표시할 속성 개수 (초과 시 아래 줄로 이어서 추가)
var ATTR_TH_STYLE = "border:1px solid #cdcdcd; background:#f4f4f4; color:#333333; font-weight:600; font-size:12px; text-align:center; padding:6px 4px; word-break:break-all;";
var ATTR_TH_EMPTY = "border:1px solid #cdcdcd; background:#f4f4f4; color:#333333; font-weight:600; font-size:12px; text-align:center; padding:6px 4px;";

/*
 * 선택 상세분류 하단 속성 조회 (상세분류 클릭 시에만 노출, 속성명 = 회색 헤더셀)
 */
function kep_getCategoriAttr(categ_id){
	if(categ_id == null || categ_id == ""){
		$("#attrTableBody").html("");
		$("#attrPanel").hide();
		return;
	}
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getMasterMdCmCmsItemCategoryAttrList.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_categ_id: categ_id },
	     async : false,
	     success:function( response ) {
	    	var cnt = response.data.length;
	    	var strTmp = "";
	    	if (cnt > 0){
	    		var cols = (cnt < ATTR_COLS_PER_ROW) ? cnt : ATTR_COLS_PER_ROW;
	    		for (var i=0; i<cnt; i++){
	    			if (i % cols == 0) strTmp += "<tr>";
	    			strTmp += "<th style='"+ATTR_TH_STYLE+"'>"+$.trim(response.data[i].ATTR_NM)+"</th>";
	    			if (i % cols == cols-1) strTmp += "</tr>";
	    		}
	    		var rem = cnt % cols;  // 마지막 줄 빈 셀로 패딩(열 정렬 유지)
	    		if (rem != 0){
	    			for (var j=rem; j<cols; j++) strTmp += "<th style='"+ATTR_TH_EMPTY+"'>-</th>";
	    			strTmp += "</tr>";
	    		}
	    	}else{
	    		strTmp = '<tr><td style="border:1px solid #cdcdcd; padding:6px; text-align:center; color:#888;">속성 정보가 없습니다.</td></tr>';
	    	}
	    	$("#attrTableBody").html(strTmp);
	    	$("#attrPanel").show();
	      },
	     error:function( response ) {
	    	 alert("오류발생하였습니다.");
	      }
    });
}

/*
 * 카테고리 선택된 대상 초기화
 */
function kep_categori_clear(){
		$("#cateMenu1").html(nodata);
		$("#cateMenu2").html(nodata);
		$("#cateMenu3").html(nodata);
		$("#cateMenu4").html(nodata);
}
</script>
</html>
