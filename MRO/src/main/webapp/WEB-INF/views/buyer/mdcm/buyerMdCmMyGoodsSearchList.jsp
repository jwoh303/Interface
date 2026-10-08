<%--
**********************************************
* 메뉴 : 상품검색>나의상품검색
* 화면 : 나의상품검색
* 기능 : 나의상품으로 등록된 상품을 조회하여 상품목록으로 보여준다.
* 프로그램 ID : PG_06_B_004_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<% 
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"10"));  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");    
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");    
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");
	String st_my_groups = CommonUtil.nvl((String) request.getParameter("st_my_groups"),"");
	// 조회조건 E	
	
	String SessionComCode = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	String img_view_flag   = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
	}  
	 if(image_status.equals("")){  
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	 
	//SLOGIC-BEGIN(P06-0000036)
	 String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	 String p060000036 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000036","COL02_DATA", request); // 권한별URL
	 if (p060000036 == null){
	 	p060000036 = defaultUrl;
	 }else if ("".equals(p060000036)){
	 	p060000036 = defaultUrl;
	 }
	 //SLOGIC-END
	 
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	//SLOGIC-END
	
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<div id="container2">
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE24")%></h3> <!-- 나의상품검색 -->
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회" ><a href="javascript:doAction('search','');"><%=CommonLang.get("HTITLE7")%></a></span> <!-- 조회 -->
		<span class="btn_reset" title="초기화" ><a href="javascript:doAction('reload','');"><%=CommonLang.get("HTITLE8")%></a></span><!-- 초기화 -->
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 
		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">  
		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">		
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7")%></caption>	<!-- 조회 -->
				<colgroup>
				    <col width="12%" />
				    <col width="38%" />
				    <col width="12%" />
				    <col width="38%" />
				</colgroup>
				
				<tbody>
				<tr>
					<th><%=CommonLang.get("HTITLE12")%></th>	<!-- 품목코드 -->
					<td>
					<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value="<%=st_buyer_item_no%>" onKeyDown="kepEnter()">
					</td>
					<th><%=CommonLang.get("HTITLE13")%></th>	<!-- 품목명 -->
					<td>
					<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:90%;" value="<%=st_description%>"  onKeyDown="kepEnter()">
					</td>
				</tr>
				<tr>
					<th><%=CommonLang.get("HTITLE14")%></th>	<!-- 규격 -->
					<td>
						<input type="text" class="input_type_text" name="st_specification" id="st_specification" style="width:90%;" value="<%=st_specification%>"  onKeyDown="kepEnter()">
					</td>
					<th><%=CommonLang.get("HTITLE15")%></th>	<!-- 제조사 -->
					<td>
						<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:90%;" value="<%=st_maker_name%>"  onKeyDown="kepEnter()">
					</td>
				</tr>
				<tr>
					<th><%=CommonLang.get("HTITLE28")%></th>	<!-- 분류 -->
					<td>
						<select id="st_my_groups" name="st_my_groups" title="분류" style="width:90%;">
							<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "ITEM",_sessionInfo.getUserId(), "ICOMCOD3", st_my_groups, "") %>
						</select>
					</td>
					<th></th>
					<td>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595")%></option>	<!-- 건 -->
				<option value = "15" <%if ("15".equals(onepagerow)) {%>selected<%} %>>15<%=CommonLang.get("HTITLE595")%></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595")%></option>
				<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25<%=CommonLang.get("HTITLE595")%></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595")%></option> 
				<option value = "100"<%if ("100".equals(onepagerow)) {%>selected<%} %>>100<%=CommonLang.get("HTITLE595")%></option> 
			</select>
      	</span>      
       <span class="fr"><%=CommonLang.get("HTITLE594")%></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" >
			<colgroup>
	            <col width="4%" />
	            <col width="4%" />
	            <col width="*" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="15%" />
	        </colgroup>
	        <thead>
			<tr>
               <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>                
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
							
<%} %>
				</th> 
                <th scope="col"></th>
                <th scope="col">
                <%=CommonLang.get("HTITLE19")%></th>	<!-- 품목코드 / 품목명 / 규격 -->
                <th scope="col"><a href="javascript:copyMygroup();"><font style="text-decoration:underline;"><%=CommonLang.get("HTITLE28") %></font></a><!-- 분류 --> / <%=CommonLang.get("HTITLE20")%> <!-- 원산지 /제조사 -->
                </th>
                <th scope="col"><%=CommonLang.get("HTITLE31") %></th>	<!-- 협력사/단위  -->
                <th scope="col"><%=CommonLang.get("HTITLE22")%></th>	<!-- 현단가 / 구매수량 --> 
			</tr>
	</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
			<tr>
				<td colspan="15" align="center" height = "50"> 
				<span><%=CommonLang.msg("MSG347")%></span>	<!-- 조회된 데이타가 없습니다. -->
				</td> 
			</tr>
<%
}else{
	Map<String,String> rowData = null;
	for (int j=0; j<_gridList.size(); j++) {
		rowData = _gridList.get(j);
		String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		
%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="font1_black1"  class="center">
						<input type="checkbox" name="lnCheck<%=j%>">	                   
					</td>
					<td title="이미지">
<% if(image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>  
 
<%     }else{ %> 
             <a class="hyperLink"  href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%> 
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>  
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%> 
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>  
 
<%     }else{ %> 
             <a class="hyperLink"  href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>  
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>  
 
<%     }
    }
%>				
					<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
                   <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
                   <input type="hidden" name="st_cart_seq" value="<%=CommonUtil.nvl(rowData.get("CART_SEQ"))%>">
					</td>
                    <td title="품목코드 / 품목명 / 규격" class="left">&nbsp;<a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>&nbsp;/&nbsp;	                    
	                    <%=rowData.get("DESCRIPTION")%><br>
	                    &nbsp;&nbsp;<%=rowData.get("SPECIFICATION")%>
					<% if(rowData.get("PRODUCT_CLOSE_FLAG").equals("Y")) { %>&nbsp;
					<% }else if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>&nbsp;
					 <% } else { %> <br>&nbsp;&nbsp;<font color="green"><%=CommonLang.get("HTITLE597")%><%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font><% } %>	<!-- (재 판매일 : -->
                    </td> 
					<td class="center" title="분류/원산지 /제조사 ">
					<input type="hidden" name="st_my_group" value="<%=CommonUtil.nvl(rowData.get("MY_GROUP"))%>">
					<a class="hyperLink"  href="javascript:getBuyerMyGroupPop('<%=j%>');">
						<input type="text" name="st_my_group_nm"    id="st_my_group_nm" style="width:80%;cursor:pointer;text-align:center; border:0px; font-size:12px; color:blue; background-color:transparent;"  value="<%=rowData.get("MY_GROUP_NM")%>" readonly></a>
						<br><%=rowData.get("ORIGIN_TEXT")%>/<%=rowData.get("MAKER_NAME")%>
					</td>
					 <td class="center"  title="협력사/단위">  
					<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT3")%>');"><%=rowData.get("AGENT_NAME")%></a><br><%=rowData.get("UNIT_MEASURE")%>
					</td>
		          	<td class="right"  title="현단가 / 구매수량">
		          	<%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br>	
		            <input type="text" name="st_order_qty" style="width:70%;text-align:right;" id="line" class = "input_type_text" value = "<%=rowData.get("TARGET_QTY")%>">
		            </td> 
				</tr> 
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598")%> <%=total_cnt %><%=CommonLang.get("HTITLE599")%></span> 		<!-- 총건 -->						<!-- [ 총  건 ] --> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04" title="삭제" >
					<a href="javascript:doAction('remove','');"><%=CommonLang.get("HTITLE25")%></a>	<!-- 삭제 --> 
				</span>	
				<span class="btn_04" title="장바구니담기" >
					<a href="javascript:doAction('cartItem','');"><%=CommonLang.get("HTITLE11") %></a>	<!-- 장바구니담기 -->
				</span>
				</span>	
				<span class="btn_04" title="분류저장" >
					<a href="javascript:doAction('saveCateg','');"><%=CommonLang.get("HTITLE26") %></a>	<!-- 분류저장 -->
				</span>
				<span class="btn_04" title="분류추가" >
					<a href="javascript:doAction('addCateg','');"><%=CommonLang.get("HTITLE27") %></a>	<!-- 분류추가 -->
				</span>					
            </div>
        </div> 
</form>
 


<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" /> 
</form>

<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	 
</form>
 
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<div id="confirmArea"  style="position:absolute; left:  250px; top: 250px; width: 500px; height: 100px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 1px solid blue; padding:20px;">
 <h4  id="confirmMsg"></h4>  
 		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:kep_confrim_search();"><%=CommonLang.get("HTITLE591")%></a>	<!-- 계속검색 -->
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();"><%=CommonLang.get("HTITLE592")%></a>	<!-- 이동 -->
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_cancel();"><%=CommonLang.get("HTITLE229")%></a>	<!-- 취소 -->
				</span>					
            </div>
        </div>
        
</div>
<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
 
}
  

var st;
//기능함수
function doAction(str , gubun) {
		
	switch (str) {
	case "search":	 //조회 
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		document.forms.searchForm.st_buyer_item_no.value = "";
		document.forms.searchForm.st_description.value = "";
		document.forms.searchForm.st_specification.value = "";
		document.forms.searchForm.st_maker_name.value = "";

		jspTableClean("table_list");
		break; 
		
	case "remove": // 나의상품 담기한결과 삭제
		saveProcess("D");
		break;  
	
	case "cartItem": // 장바구니 담기
		saveProcess("C");
		break;  		
	case "addCateg": // 분류추가
		// 분류추가.
		openSearchPopup("/common/addMyCatalogPop.do","","600,450,no");
		break;
	case "saveCateg": // 분류저장
		saveProcess("S");
		break;
	}
}


//이미지 보이기 숨기기
function imageHideView(){ 
	
    var image_status   = $("#st_image_status").val();
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    $("#st_image_status").val(image_status);
    
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}

 
// 조회
function kepSearch(curPage){	
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit();   
} 





/*
 * 나의상품삭제 D
 * 장바구니담기 C
 * 나의분류저장 S
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        //  목록에 표시된 상품이 없습니다.
    	alert("<%=CommonLang.msg("MSG16")%>");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.contentForm.lnCheck" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17")%>");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
            	var order_qty     = document.forms.contentForm.st_order_qty.value;
                var st_agent_flag = document.forms.contentForm.st_agent_flag.value;
		        var st_item_no   = document.forms.contentForm.st_item_no.value;
				var st_order_qty = document.forms.contentForm.st_order_qty.value;
				var st_agent     = document.forms.contentForm.st_agent_code.value;
				var contract_no  = document.forms.contentForm.st_contract_no.value;
				var contract_seq = document.forms.contentForm.st_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
				var st_my_group     = document.forms.contentForm.st_my_group.value;
				var st_cart_seq     = document.forms.contentForm.st_cart_seq.value;

                var key_flag      = st_agent_flag.substr(0,2); 
                if(st_agent_flag == "MULTI_AGENT"){
                    var st_key_flag = "Y";
                }else{
                    var st_key_flag = "N";
                }
                if (flag == "C"){ // 장바구니
	                if(!kepChkDecimal(order_qty,3)){
	                	//  첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    
	                    alert( "<%=CommonLang.msg("MSG18")%>");
	                    document.forms.contentForm.st_order_qty.focus();
	                    return;
	                }
	                else if(st_key_flag == "Y"){
	                    // 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     
	                	alert( "<%=CommonLang.msg("MSG19")%>");
	                    box.checked = false;
	                    return;
	                }else{
						query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+"&&";
					}
                }else if (flag == "S"){ // 나의분류저장
                	query = st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                }else{ // 나의상품삭제
                	query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                }
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                var order_qty     = document.forms.contentForm.st_order_qty[i].value;
                var st_agent_flag = document.forms.contentForm.st_agent_flag[i].value;
				var st_item_no   = document.forms.contentForm.st_item_no[i].value;
				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;
				var st_agent     = document.forms.contentForm.st_agent_code[i].value;
				var contract_no  = document.forms.contentForm.st_contract_no[i].value;
				var contract_seq = document.forms.contentForm.st_contract_seq[i].value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
				var st_my_group     = document.forms.contentForm.st_my_group[i].value;
				var st_cart_seq     = document.forms.contentForm.st_cart_seq[i].value;

                if(box.checked == true){
                    
                    var key_flag      = st_agent_flag.substr(0,2); 
                    if(st_agent_flag == "MULTI_AGENT"){
                        var st_key_flag = "Y";
                    }else{
                        var st_key_flag = "N";
                    }
                    
                    if (flag == "C"){ // 장바구니
	                    if(!kepChkDecimal(order_qty,3)){
	                    	//  번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.    
	                        alert( i+"<%=CommonLang.msg("MSG20")%>");
	                        document.forms.contentForm.st_order_qty[i].focus();
	                        return;
	                    }
	                    else if(st_key_flag == "Y"){
	                    	// 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     
	                        alert( "<%=CommonLang.msg("MSG19")%>");
	                        box.checked = false;
	                        return;
	                    }else {
						  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
						  query += "&&";
						}
                    }else if (flag == "S"){ // 나의분류저장
                    	query += st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                    	query += "&&";
                    }else{ // 나의상품삭제
                    	query += st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                    	query += "&&";
                    }
                }
            }
        }
    }	 
     
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	kep_showConfirm(); 
}
 


function kep_showConfirm(){
	
	
	var runFlag = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	
    var msg = "";
    if (runFlag == "CsaveProcess"){
    	msg = "장바구니";
    }else{
    	msg = "나의상품";
    }

    $('body,html').animate({
		scrollTop: 0
	}, 100);
	
    if (runFlag == "CsaveProcess"){
    	// 으로 저장하시고 보기 화면으로 이동하시겠습니까?
		$("#confirmMsg").text(msg+"<%=CommonLang.msg("MSG348")%>"+"\n"+msg+"<%=CommonLang.msg("MSG349")%>");
		$("#confirmArea").show(); 
    }else if(runFlag == "DsaveProcess"){
    	// 선택하신 품목을 나의상품에서 삭제하시겠습니까?
        if(!confirm("<%=CommonLang.msg("MSG350")%>")){
            return;
        }else{
        	runProcess(runFlag,query,flag);
        }
    }else if(runFlag == "SsaveProcess"){
    	// 선택하신 품목 분류 저장 하시겠습니까?
        if(!confirm("<%=CommonLang.msg("MSG351")%>")){
            return;
        }else{
        	runProcess(runFlag,query,flag);
        }    	
    }
}

// 계속검색
function kep_confrim_search(){ 
	$("#confirm4").val("search");
	$("#confirmArea").hide(); 
	runProcess();
}

// 이동
function kep_confirm_location(){ 
	$("#confirm4").val("location");
	$("#confirmArea").hide(); 
	runProcess();
}

// 취소
function kep_confirm_cancel(){ 
	$("#confirm4").val("");
	$("#confirmArea").hide(); 
}



/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 
 */
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	
	if (gubun == "CsaveProcess"){ // 장바구니 
		document.forms.processForm.st_use_flag.value = "C"; // 장바구니
		document.forms.processForm.st_query2.value = query;		
		document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm",gubun); 
	}else if (gubun == "DsaveProcess"){ // 나의상품삭제 
		document.forms.processForm.st_use_flag.value = "R"; // 나의상품삭제
		document.forms.processForm.st_query2.value = query;		
		kepAjaxFormCall("/mdcm/removeBuyerMdCmMyGoodsLisList.do","processForm",gubun); 
	}else if (gubun == "SsaveProcess"){ //분류저장
		document.forms.processForm.st_use_flag.value = "R"; // 나의상품삭제
		document.forms.processForm.st_query2.value = query;		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmMyGroupLisList.do","processForm",gubun); 
	}  		 	

}
  

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	var confirm4 = $("#confirm4").val();
	
    if(sMsg == "CREATE_OK"){
    	
        if(pMethod == "CsaveProcess")
        {
        	// 장바구니에 저장되었습니다.   
           alert("<%=CommonLang.msg("MSG22")%>");
           
           if (confirm4 == "search"){ 
         	  // 계속검색클릭 
            	 // 처리후 재조회
            	 kepSearch($("#curPage").val());           	   
           }else{     
        	   
        	   $('#locationForm').attr("action", "<%=p060000036%>").submit();    
        	 
           }
       }else if(pMethod == "SsaveProcess"){
    	   //저장 되었습니다.  
           alert("<%=CommonLang.msg("MSG31")%>");
        	 // 처리후 재조회
        	 kepSearch($("#curPage").val());    	   
       }else {
    	   //나의상품 정상적으로 삭제되었습니다.  
          alert("<%=CommonLang.msg("MSG32")%>");
      	 // 처리후 재조회
      	 kepSearch($("#curPage").val());
       } 
        
      }else{
         if(pMethod == "CsaveProcess"){
        	 //품목코드 ( ) 은 이미 장바구니에 저장된 항목입니다.  
            alert("<%=CommonLang.msg("MSG352")%>" + sMsg + "<%=CommonLang.msg("MSG353")%>");	
          }else if(pMethod == "CsaveProcess"){
        	  
          }
     	 // 처리후 재조회
     	 kepSearch($("#curPage").val());
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "CsaveProcess"){ 
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 alert("<%=CommonLang.msg("MSG26")%>"); 
	}else if (pMethod == "DsaveProcess"){ 
		//나의상품삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 alert("<%=CommonLang.msg("MSG27")%>"); 
	}  
} 
//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
//분류 선택 ROW
var g_row = "";
//분류선택
function getBuyerMyGroupPop(row){
	// 분류추가.
	g_row = row;
	openSearchPopup("/common/addMyCatalogPop.do?st_mygroup_yn=Y","","600,450,no");
}
function setPopupReturn(type,value1,value2){
    var tot_cnt  =  $("#display_item_cnt").val();
    if(type == "addMyCatalogPop"){
	    if(eval(tot_cnt) < 2){    	
	    	document.forms.contentForm.st_my_group_nm.value = value1;
	    	document.forms.contentForm.st_my_group.value = value2;
	    }else{
	    	document.forms.contentForm.st_my_group_nm[g_row].value = value1;
	    	document.forms.contentForm.st_my_group[g_row].value = value2;
	    }
    }
}
//분류 복사기능
function copyMygroup() {

	var tot_cnt  =  $("#display_item_cnt").val();
	var checked_count       = 0;
	var st_my_group = "";
	var st_my_group_nm = "";
    if(tot_cnt==1) {
        var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true){
            checked_count = 1;
            st_my_group  =  document.forms.contentForm.st_my_group.value;
            st_my_group_nm   =  document.forms.contentForm.st_my_group_nm.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            var box = eval("document.forms.contentForm.lnCheck" + j);
            if(box.checked == true){
                checked_count++;
                st_my_group  =  document.forms.contentForm.st_my_group[j].value;
                st_my_group_nm   =  document.forms.contentForm.st_my_group_nm[j].value;
                break;
            }
        }
    }
    if(checked_count==0) {
    	// 분류를 복사할 품목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG33")%>");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            var box = eval("document.forms.contentForm.lnCheck" + j);
            if(box.checked == true){
                document.forms.contentForm.st_my_group[j].value         = st_my_group;
                document.forms.contentForm.st_my_group_nm[j].value    = st_my_group_nm;
            }
        }
    }else {
    	// 분류지정 품목이 2개 이상일 경우 복사할수 있습니다.
        alert("<%=CommonLang.msg("MSG34")%>");
        return;
    }
}

</script>
</html>
