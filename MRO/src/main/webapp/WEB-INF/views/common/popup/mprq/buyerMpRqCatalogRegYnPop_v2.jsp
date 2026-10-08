<%--
**********************************************
* 메뉴 : 견적관리 > 신규상품견적의뢰 > 카탈로그 등록여부 
* 화면 : 카탈로그 등록여부 
* 기능 : 고객사 카탈로그 등록여부 조회 팝업
* 프로그램 ID : PG_04_B_003_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-08-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<style>
.Popup_PDReg thead th{padding:6px 0px; text-align:center;font-size:16px; font-weight:500; letter-spacing:-0.8px; color:#5B5C61; border-bottom:1px solid #dedede; border-left:1px solid #dedede;position:sticky;background-color:#f2f7ff;}

</style>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String img_view_flag   = "";
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");
String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");
String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");
String st_categ_name = CommonUtil.nvl((String) request.getParameter("st_categ_name"),"");
String st_image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");
String st_set = CommonUtil.nvl((String) request.getParameter("set"),"N");
if(st_image_status.equals(""))
{ 
    st_image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN";
}

String onepagerow           = CommonUtil.nvl((String)request.getParameter("onepagerow"), "10");
String curPage            = CommonUtil.nvl((String)request.getParameter("curPage"), "1");
String tot_cnt_string   = "";
int tot_cnt = 0;                                    //전체데이타row수
int rec_cnt = 0;
int page_display_cnt = 0;
%>

<script type="text/javascript">
	var but1text = "확인";
	var but1func = "javascript:closePopText2(); return false;";
	var but1funcSearch= "javascript:thisPopClose(); return false;";
	var but1width = "120px";

function kepSearch(curPage){  

	var str  = $("#st_description").val(); 
	var str1 = $("#st_maker_name").val();
	var str2 = $("#st_specification").val();
	var str3 = $("#st_buyer_item_no").val();
	
	if(str.length < 2 && str1.length < 2 && str2.length < 2 && str3.length < 2){
		//최소 2자 이상 입력 후 조회해주세요.
		var text = "<%=CommonLang.msg("MSG769")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	document.forms.buyerMpRqCatalogRegYnPop.curPage.value = curPage; 
	$('#buyerMpRqCatalogRegYnPop').attr("action", "/mprq/getBuyerMpRqCatalogRegYnPop_v2.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch('1');
	}
}
function reload(){
	kepReload("buyerMpRqCatalogRegYnPop");
	document.forms.buyerMpRqCatalogRegYnPop.curPage.value = -1;
	$('#buyerMpRqCatalogRegYnPop').attr("action", "/mprq/getBuyerMpRqCatalogRegYnPop_v2.do").submit();    
}
//이미지 보이기 숨기기
function imageHideView() {
	
    var isChecked = $("#st_image_hide_flag").is(":checked");
    
    var image_status = isChecked ? "IMAGE_HIDDEN" : "IMAGE_VIEW";
    
    $("#st_image_status").val(image_status);

 	// 처리후 재조회
    if ("<%=total_cnt%>" > 0) {
        kepSearch($("#curPage").val());
    }
}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%=CommonUtil.getURL(request)%><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

function catalogSet(index){
	var param = {
		st_buyer_item_no : $("#st_buyer_item_no"+index).val(),
		st_description : $("#st_description"+index).val(),
		st_specification : $("#st_specification"+index).val(),
		st_maker_part_no : $("#st_maker_part_no"+index).val(),
		st_maker_name : $("#st_maker_name"+index).val(),
		st_origin_code : $("#st_origin_code"+index).val(),
		st_origin_name : $("#st_origin_name"+index).val(),
		st_unit_measure : $("#st_unit_measure"+index).val(),
		st_categ_id : $("#st_categ_id"+index).val(),
		st_categ_name : $("#st_categ_name"+index).val()
	}
	opener.setPopupReturn(param);
	self.close();
}
</script> 
<body onload="">
<form name="buyerMpRqCatalogRegYnPop" id="buyerMpRqCatalogRegYnPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type="hidden" name="st_image_status" id="st_image_status" value="<%=st_image_status%>">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage%>" />
<input type="hidden" name="set" id="set" value="<%=st_set%>" />
<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1185") %><!-- 상품등록여부 -->
	<span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span>
  </div>
  <table class="PopupSearchTableNoline mt15" style="width:100%;">
	<colgroup>
      <col width="15%" />
      <col width="35%" />
      <col width="15%" />
      <col width="35%" />
	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
      <td><input class="input40" style="width:80%" name=st_description id="st_description" type="text" value="<%=st_description%>" onkeydown="kepEnter()"/></td>
      <th><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
      <td><input class="input40"  type="text" name=st_buyer_item_no id="st_buyer_item_no" style="width:90%;" value="<%=st_buyer_item_no %>" onkeydown="kepEnter()" /></td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
      <td ><input class="input40" type=text name=st_specification id="st_specification" style="width:80%;" value="<%=st_specification%>" onkeydown="kepEnter()"></td>
      <th><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th>
      <td><input class="input40" type=text name=st_maker_name id="st_maker_name" style="width:90%;" value="<%=st_maker_name %>" onkeydown="kepEnter()"></td>
    </tr>
  </table>
  <div class="PopupListBtnBox_Center borderbottom01_de mt15 pb20">
    <button type="button" class="ButOutline_Medium" style="width:120px" onclick="javascript:reload();">초기화</button> 
    <button type="button" class="ButDarkGray_Medium" style="width:120px" onclick="javascript:kepSearch(1);">조회</button> 
  </div> 
  <div class="ArrayRegPopup mt15">
    <div class="ArrayRegPopupTit pb20"><%=CommonLang.get("HTITLE921")%><!-- 총 --> <%=total_cnt%><%=CommonLang.get("HTITLE595")%><!-- 건 --></div>
    <div class="buttonRight">
      <p class="ImgHiddenRegPopup">
      	<label class="CheckMediumLabel">
      	  <input type="checkbox" id="st_image_hide_flag" onchange="imageHideView();" <%=st_image_status.equals("IMAGE_HIDDEN")?"checked":""%>>
      	  <span class="CheckMediumCustom"></span>
      	</label>
			<%=CommonLang.get("HTITLE1186")%><!-- 이미지 숨김 -->
      </p>
      <select class="SelectEach ml10" name="onepagerow" onchange="javascript:kepSearch('1');">
        <option <%=(onepagerow.equals("10") ? "selected" : "")%> value = "10">10</option>
		<option <%=(onepagerow.equals("20") ? "selected" : "")%> value = "20">20</option>
		<option <%=(onepagerow.equals("30") ? "selected" : "")%> value = "30">30</option>
		<option <%=(onepagerow.equals("40") ? "selected" : "")%> value = "40">40</option>
		<option <%=(onepagerow.equals("50") ? "selected" : "")%> value = "50">50</option>
      </select>
<!--       <button type="button" class="tab-btn ButListArray_on ml05" data-target="listView">목록형</button> -->
<!--       <button type="button" class="tab-btn ButListImg_off" data-target="imgView">이미지형</button>  -->
    </div>
  </div> 
  <div class="ScrollBoxTopLine mt10" style="height:370px">
	<table class="Popup_PDReg" style="width:100%;">
      <colgroup>
      	<% if(!st_image_status.equals("IMAGE_HIDDEN")){ // 이미지 보이기 %>
        <col width="15%" />
        <col width="55%" />
        <col width="10%" />
        <col width="20%" />
        <%} else{%>
        <col width="50%" />
        <col width="15%" />
        <col width="25%" />
        <%} %>
      </colgroup>
      <thead style="position:sticky; top:0;background-color:#f2f7ff;">
      	<% if(!st_image_status.equals("IMAGE_HIDDEN")){ // 이미지 보이기 %>
      	<th><%=CommonLang.get("HTITLE395")%></th><%-- 이미지 --%>
      	<%} %>
      	<th><%=CommonLang.get("HTITLE1104")%></th><!--품목정보 -->
		<th><%=CommonLang.get("HTITLE52")%></th><!--단위-->
		<th><%=CommonLang.get("HTITLE174")%></th><!--단가-->
      </thead>
      <tbody style="overflow-y:auto; ">
      <%
if (_dataList == null || _dataList.size() == 0){
%>
	<tr bgcolor="#FFFFFF">
	       <td colspan=<% if(!st_image_status.equals("IMAGE_HIDDEN")){ %>"4"<%}else{%>"3"<%} %> align="center" height = "150">
	       <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
	    </td> 
	</tr> 
<%}else{
for (int j=0; j < _dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%>       
      	<tr>    	
<% if(!st_image_status.equals("IMAGE_HIDDEN")){ // 이미지 보이기 %>
        	<td class="PDimg" name="PDimg">
        <!-- 상태값 -->
	<%  if(CommonUtil.nvl(_tmp.get("OVER_SHORT_FLAG")).equals("Y")){        %> 
   			<div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div<
   	<%} if(CommonUtil.nvl(_tmp.get("PRODUCT_CLOSE_FLAG")).equals("Y")){     %> 
   			<div class="OpacityBox"><%=CommonLang.get("HTITLE394") %><!-- 단종 --></div>
	<%} if(!CommonUtil.nvl(_tmp.get("BUY_GREEN_ITEM_NM")).equals("") ) { //녹색구매제품   %>
    	<p class="EcoFriendly"><%=CommonUtil.nvl(_tmp.get("BUY_GREEN_ITEM_NM"))%></p>
    <%} %>
    	<!-- 품목사진 -->
<%		if("".equals(CommonUtil.nvl(_tmp.get("IMGFILE_DIR")))){ // 이미지 없음%>
				<img src="/resources/imgs/noimage.gif">
	<%}else{ // 이미지 있음 %> 
				<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(_tmp.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(_tmp.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"  name="image1">
	<%}%>
			</td>
<%} %>
			
			<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%>" />
			<input type="hidden" name="st_description" id="st_description<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("DESCRIPTION"))%>" />
			<input type="hidden" name="st_maker_part_no" id="st_maker_part_no<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("MAKER_PART_NO"))%>" />
			<input type="hidden" name="st_specification" id="st_specification<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%>" />
			<input type="hidden" name="st_maker_name" id="st_maker_name<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("MAKER_NAME"))%>" />
			<input type="hidden" name="st_origin_code" id="st_origin_code<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("ORIGIN_CODE"))%>" />
			<input type="hidden" name="st_origin_name" id="st_origin_name<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("ORIGIN_NAME"))%>" />
			<input type="hidden" name="st_unit_measure" id="st_unit_measure<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("UNIT_MEASURE"))%>" />
			<input type="hidden" name="st_categ_name" id="st_categ_name<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("CATEG_NAME"))%>" />
			<input type="hidden" name="st_categ_id" id="st_categ_id<%=j %>" value="<%=CommonUtil.nvl(_tmp.get("CATEG_ID"))%>" />
			
	        <td align="left" >
	        <%if(st_set.equals("Y")) {%>
	        <a href="javascript:catalogSet('<%=j%>');" >
	        <%} %>
	          <div class="PDTit"><span><%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></span>&nbsp;<%=CommonUtil.nvl(_tmp.get("DESCRIPTION"))%></div>
	          <table class="PDAttribute mt10">
	            <colgroup><col width="50px" /><col width="*" /></colgroup>              
	            <tr><th><%=CommonLang.get("HTITLE14") %></th><td><p class="PDname300"><%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%></p></td></tr>
	            <tr><th><%=CommonLang.get("HTITLE15") %></th><td><%=CommonUtil.nvl(_tmp.get("MAKER_NAME"))%></td></tr>
	          </table>
	        <%if(st_set.equals("Y")) {%>
	        </a>
	        <%} %>
	        </td>
	        
	        <td><%=CommonUtil.nvl(_tmp.get("UNIT_MEASURE"))%></td>
	        <td><p class="PDPrice"><span><%=CommonUtil.formatNumber(_tmp.get("TARGET_PRICE"),true,0,3)%></span>원</p></td>
	      </tr>
      <% } 
}%>   
		</tbody>
	</table>
<!-- 	<table class="Popup_PDReg" id="imgView" style="display: none;"> -->
<!--       <colgroup> -->
<!--         <col width="25%" /> -->
<!--         <col width="25%" /> -->
<!--         <col width="25%" /> -->
<!--         <col width="25%" /> -->
<!--       </colgroup> -->
<%--    if (_dataList == null || _dataList.size() == 0){ %> --%>
<!-- 	<tr bgcolor="#FFFFFF"> -->
<!-- 	       <td colspan="4" align="center" height = "280"> -->
<%-- 	       <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span> --%>
<!-- 	    </td>  -->
<!-- 	</tr>  -->
<%-- <%}else{ 
 for (int j=0; j< _dataList.size(); j++) {
 	Map<String,String> _tmp = _dataList.get(j);
 %>        --%>
<%-- <%if(j % 4 == 0){ %> --%>
<!--       <tr> -->
<%--  <%} %> --%>
<!--        	<td align="left"> -->
<!--        		<div class="PDimg"> -->
<%-- <%if(!(CommonUtil.nvl(_tmp.get("PRODUCT_CLOSE_FLAG")).equals("N"))){ %> --%>
<!-- 				<div class="OpacityBox">품절</div> -->
<%-- <% }%> --%>
<!--         		<p class="EcoFriendly">친환경</p><a href="#" ><img src="/resources/imgs/img05.jpg" /></a> -->
<!--         	</div> -->
<%-- 			<div class="PDTit mt10"><%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></div> --%>
<%-- 			<div class="PDname150 mt05"><%=CommonUtil.nvl(_tmp.get("DESCRIPTION"))%></div> --%>
<!-- 			<table class="PDAttribute mt10"> -->
<!-- 	            <colgroup><col width="40px" /><col width="*" /></colgroup>  -->
<%-- 	            <tr><th>규격</th><td><div class="PDname100"><%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%></div></td></tr> --%>
<%-- 	            <tr><th>제조사</th><td><%=CommonUtil.nvl(_tmp.get("MAKER_NAME"))%></td></tr> --%>
<%-- 	            <tr><th>단위</th><td><%=CommonUtil.nvl(_tmp.get("UNIT_MEASURE"))%></td></tr> --%>
<!--          	</table> -->
<%--           	<div class="PDPrice mt05"><span><%=CommonUtil.formatNumber(_tmp.get("TARGET_PRICE"),true,0,3)%></span>원</div> --%>
<!-- 		</td> -->
<%-- <%if(j % 4 == 3){ %> --%>
<!--       </tr> -->
<%-- <%} %> --%>
<%--       <% }  --%>
<%-- }%>    --%>
<!-- 	</table> -->
</div>
<!-- 페이징 -->
	<div class="h30"></div>
	<p class="PopupPaging">
		<%=CommonUtil.getPageView("kepSearch",total_cnt,curPage,onepagerow) %> 
	</p>
<script>
// 	//모든 버튼과 컨텐츠 영역을 가져옵니다.
// 	const tabs = document.querySelectorAll('.tab-btn');
// 	const contents = document.querySelectorAll('.Popup_PDReg');
	
// 	tabs.forEach(button => {
// 	  button.addEventListener('click', function() {
	    
// 	    // 1. 모든 버튼의 클래스에서 _on을 _off로 변경
// 	    tabs.forEach(btn => {
// 	      btn.className = btn.className.replace('_on', '_off');
// 	    });
	
// 	    // 2. 클릭된 현재 버튼만 _off를 _on으로 변경
// 	    this.className = this.className.replace('_off', '_on');
	
// 	    // 3. 모든 컨텐츠를 숨김
// 	    contents.forEach(div => div.style.display = 'none');
	
// 	    // 4. 클릭된 버튼의 data-target에 해당하는 div만 보여줌
// 	    const targetId = this.getAttribute('data-target');
// 	    const targetTable = document.getElementById(targetId);
//         if (targetTable) {
//             targetTable.style.display = 'table'; 
//         }
// 	  });
// 	});
</script>    
</div><!-- wrapPopup 끝-->  
 
</div>
</form> 
</body>
</html>
