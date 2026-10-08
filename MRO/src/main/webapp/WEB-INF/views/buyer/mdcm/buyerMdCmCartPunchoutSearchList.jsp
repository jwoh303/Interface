<%--
**********************************************
* 메뉴 : 장바구니
* 화면 : 장바구니
* 기능 : 장바구니 화면
* 프로그램 ID : PG_02_B_000834_005
* 담당자 : 현명환
* 착수일 : 2014-03-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script> 
</head>
<% 
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String sort_column           = CommonUtil.nvl((String) request.getParameter("st_sort_column"),"ALL"); 
	String sort_flag           = CommonUtil.nvl((String) request.getParameter("st_sort_flag"),"ASC"); 
	
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
	 String SessionUserId         = sessionInfo.getUserId();	 
	 //두산중공업 정비기술 사용자 체크
	 boolean getCodeYn = CommonUtil.getCodeCheckReturn("M141",SessionUserId);
	 //재고수량 표시 사용자
	 boolean getCode142 = CommonUtil.getCodeCheckReturn("M142",SessionUserId);
	 //전사공구 주문가능
	 boolean getCode143 = CommonUtil.getCodeCheckReturn("M143",SessionUserId);
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>장바구니</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회" ><a href="javascript:doAction('search','');">조회</a></span> 
		<span class="btn_reset" title="초기화" ><a href="javascript:doAction('reload','');">초기화</a></span>
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
		<input type="hidden" name="st_sort_column"			value="<%=sort_column%>">
		<input type="hidden" name="st_sort_flag"			value="<%=sort_flag%>">

		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		<input type="hidden" name="st_query" id="st_query" value="">
		<input type="hidden" name="st_query_cart" id="st_query_cart" value="">
		<input type="hidden" name="st_return_url" id="st_return_url" value="">		
		<div id="cont_searchA">	
			<table class="cont_t_list01" style="width:887px;">
				<tr><td>
	        		> 재고가능 품목일 경우 재고 여부에 체크를 하면 재고로, 체크를 하지 않으면 비재고로 구매를 하게 됩니다.
	          	</td></tr>
			</table>    
		</div>
 		<div class="contList">
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option>
				<option value = "200" <%if ("200".equals(onepagerow)) {%>selected<%} %>>200건</option>  
			</select>  
	  </span>   
		&nbsp;<span class="contList_btn">
		<%  if(image_status.equals("IMAGE_HIDDEN")){   %>
		<a href="javascript:imageHideView();"  title="이미지보이기" >이미지보이기</a>
		<%  }else{   %>
		<a href="javascript:imageHideView();"  title="이미지감추기" >이미지감추기</a>
		<%  }   %> </span>
       	</div>
   		<br>
       <span class="fr"> (기준: 원)</span>
       
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<table id="table_list" class="cont_t_list002" style="width:100%">
			<colgroup>
			  <col width="3%" />
			  <col width="7%" />
			  <col width="20%" />
			  <col width="30%" />
			  <col width="15%" />
			  <col width="10%" />
			  <col width="7%" />
			  <col width="8%" />
	        </colgroup>
	        <thead>
			<tr>
               <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%> 
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onClick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
							<%} %>
				</th>
				<th scope="col">&nbsp;</th>
				<th scope="col"> <a class="hyperLink"  href="javascript:setSortingList('C.BUYER_ITEM_NO');">품목코드</a> / 두산 품목코드</th>
                <th scope="col" >
	                <a class="hyperLink" href="javascript:setSortingList('C.DESCRIPTION');">품목명</a> 
	                / <a class="hyperLink" href="javascript:setSortingList('C.SPECIFICATION');">규격</a></th>
                <th scope="col">조달일수 / 최소주문 /단위<br>협력사
                </th>
                <th scope="col">단가<br>구매수량</th>
                <th scope="col">구매액</th>
                <th scope="col">구분<br>재고여부</th>
			</tr>
		</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
			<tr>
				<td colspan="15" align="center" height = "50"> 
				<span>조회된 데이타가 없습니다.</span>
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
						<input type="checkbox"  class="input_noline" name="lnCheck<%=j%>">	                   
					</td>
					
					<td title="이미지">					
					<div class="PDimg"> 			
                    
<% if(image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
 
<%     }else{ %> 
             <a  class="hyperLink"  href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
 
<%     }else{ %>
		             <a  class="hyperLink"  href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
		             <img src="<%=CommonUtil.realImgS3UploadPath+"/item_image/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
 
<%     }
    }
%>
					<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
                   <input type="hidden" name="st_contract_no"   value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq"   value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_agent_code"  value="<%=CommonUtil.nvl(rowData.get("AGENT_CODE"))%>">
                   <input type="hidden" name="st_byit_comorg_code"   value="<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>">
                   <input type="hidden" name="st_item_seq" value="<%=CommonUtil.nvl(rowData.get("ITEM_SEQ"))%>">
                   <input type="hidden" name="st_description" value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>">
                   <input type="hidden" name="st_specification" value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
                   <input type="hidden" name="st_unit_price" value="<%=CommonUtil.nvl(rowData.get("UNIT_PRICE"))%>">
                   <input type="hidden" name="st_doosan_item_no" value="<%=CommonUtil.nvl(rowData.get("ITEM_NO"))%>">
                   <input type="hidden" name="st_origin_doosan_item_no" value="<%=CommonUtil.nvl(rowData.get("ITEM_NO"))%>">
                   <input type="hidden" name="st_unit_measure" value="<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>">
                   <input type="hidden" name="st_cur" value="<%=CommonUtil.nvl(rowData.get("CUR"))%>">
                   <input type="hidden" name="st_category_no" value="<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>">
                   <input type="hidden" name="st_green_flag" value="<%=CommonUtil.nvl(rowData.get("GREEN_FLAG"))%>">
                   <input type="hidden" name="st_p_return_url" value="<%=CommonUtil.nvl(rowData.get("RETURN_URL"))%>">
                   <input type="hidden" name="st_min_order_qty" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"))%>">
                   <input type="hidden" name="st_gubun" value="<%=CommonUtil.nvl(rowData.get("GUBUN"))%>">
                   
                   </div>
					</td>                    
                    <%if(rowData.get("GREEN_FLAG").equals("Y")){ %>
	                    <td title="KeP 품목코드/ 두산 품목코드" class="left" >&nbsp;
	                    	<a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
	                    	<img src="/resources/images/greenmark.jpg" width="20" height="20" border="0"><%=rowData.get("BUYER_ITEM_NO")%></a><br>
                    <%}else{ %>
	                    <td title="KeP 품목코드/ 두산 품목코드" class="left">&nbsp;
	                    	<a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
	                    	<%=rowData.get("BUYER_ITEM_NO")%></a><br>
                    <%} %>                    
                    <%if(getCodeYn== true){ %>
                    	<%if(rowData.get("GUBUN").equals("재고가능")){ %>
                    		<%if(!rowData.get("DEPT_CNT").equals("0")){ %>
                    			<span class="contList_btn"><a class="hyperLink"  href="javascript:getDeptPOInfo('<%=SessionComCode %>','<%=rowData.get("BUYER_ITEM_NO")%>');">정비</a></span>	                    
	                    	<%}else{ %>
	                    		&nbsp;&nbsp;<%=rowData.get("TEMP_BUYER_ITEM_NO")%>
	                    	<%} %>
	                    <%} %>
                    <%}else{ %>
                    	<%if(rowData.get("GUBUN").equals("재고가능")){ %>
                    		&nbsp;&nbsp;<%=rowData.get("TEMP_BUYER_ITEM_NO")%>
	                    <%} %>
                    <%}%>
                    </td>
                    <td title="품목명 / 규격" class="left">&nbsp;<%=rowData.get("DESCRIPTION_LOC")%>&nbsp;/&nbsp;
                    	<br><%=rowData.get("SPECIFICATION")%>
                    </td> 
					<td class="center" title="조달일수 / 최소주문 /단위/ 협력사">
						<%=CommonUtil.formatNumber(rowData.get("DELIVERY_LT"),true,0,3)%>일&nbsp;/&nbsp;<%=CommonUtil.formatNumber(rowData.get("MIN_ORDER_QTY"),true,0,3)%>&nbsp;/&nbsp;<%=rowData.get("UNIT_MEASURE")%>
						<br><a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT")%></a>
					</td>
					 <td class="right"  title="단가 / 구매수량"> 
		          		<span class="Price"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span><br>
		          		<input type="text" name="st_order_qty" style="width:70%;text-align:right;" id="line" class = "input_type_text"  onBlur="javascript:updatePrice(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','<%=rowData.get("CART_QTY")%>');" value = "<%=rowData.get("CART_QTY").equals("")?"1":rowData.get("CART_QTY")%>" >
					</td>
		          	<td class="right"  title="구매액">		          		
		          		<input type="text" class="Price" name="st_sum_price"  style="width:65%;border:0;text-align:right;background-color:<%=tclass%> " value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
		            </td> 
		          	<td class="center"  title="구분 / 재고여부">
		          		<%=rowData.get("GUBUN")%>
		          		<br><input type="checkbox" class="input_noline"  name="StockCheck<%=j%>"  <%=( rowData.get("GUBUN").equals("재고가능") )?"checked":""%>  onClick="javascript:setStockCheck(<%=j%>);">
		          		<%if(getCode142==true){		          			
		          				if(!rowData.get("STOCK_FLAG").equals("")){		          		%>
		          					&nbsp;/&nbsp;<%=CommonUtil.formatNumber(rowData.get("STOCK_FLAG"),true,0,3)%>
		          		<%	
		          				}
		          			} %>
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
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">			
				<span class="btn_04" title="다운로드" >
					<a href="javascript:doAction('excelDown','');">다운로드</a> 
				</span>	
				<span class="btn_04" title="나의상품등록" >
					<a href="javascript:doAction('myItem','');">나의상품등록</a>
				</span>					
				<span class="btn_04" title="삭제" >
					<a href="javascript:doAction('remove','');">삭제</a> 
				</span>
				<span class="btn_04" title="상품검색" >
					<a href="javascript:doAction('searchPD','');">상품검색</a> 
				</span>
				<span class="btn_04" title="주문하기" >
					<a href="javascript:doAction('order','');">주문하기</a> 
				</span>
            </div>
        </div> 
</form>
 


<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/> 
	<input type="hidden" name="st_user_id_session" id="st_user_id_session" value="${sessionInfo.userId}">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
</form>

<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="${sessionInfo.comCode}">
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
					<a href="javascript:kep_confrim_search();">계속검색</a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();">이동</a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_cancel();">취소</a>
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

		jspTableClean("table_list");
		break; 
		
	case "excelDown": // 엑셀다운로드

		document.forms.searchForm.action = "/mdcm/excelBuyerMdCmCartPunchOutList.do";
		document.forms.searchForm.submit();
		break;
		
	case "remove": // 장바구니 삭제
		saveProcess("D");
		break;  
	
	case "myItem": // 나의상품 담기 
		saveProcess("R");
		break;  

	case "order": // 주문 
		sendCartList();
		break;  
  
	}
}

// 정렬
function setSortingList(sort_column) {
	document.forms.searchForm.st_sort_column.value = sort_column;
	
	var sort_flag = document.forms.searchForm.st_sort_flag.value;
	if(sort_flag=="ASC") {
		document.forms.searchForm.st_sort_flag.value = "DESC";
	}else {
		document.forms.searchForm.st_sort_flag.value = "ASC";
	} 
	kepSearch(1);
}

// 조회
function kepSearch(curPage){	
	document.forms.searchForm.target = "_self"; 
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmCartPunchOutList.do").submit();   
}

//두산중공업 재고여부 수정
function setStockCheck(row){



	var tot_cnt  = $("#display_item_cnt").val();

	if(eval(tot_cnt) < 2){

		var box = eval("document.contentForm.StockCheck" + 1);

		var st_item_no						= document.contentForm.st_item_no.value;
		var st_doosan_item_no				= document.contentForm.st_doosan_item_no.value;
		var st_origin_doosan_item_no		= document.contentForm.st_origin_doosan_item_no.value;

		if(isEmpty(st_origin_doosan_item_no)){
			alert( " 선택하신 품목은 비재고 품목입니다. \n\n 재고여부 수정이 불가능 합니다.  ");
			box.checked = false;
			return;
		}

		if(box.checked == false){
			document.contentForm.st_doosan_item_no.value = " ";
		}else{
			document.contentForm.st_doosan_item_no.value = st_origin_doosan_item_no;
		}

	}else{
	
			var box = eval("document.contentForm.StockCheck" + row);
	
			var st_item_no					= document.contentForm.st_item_no[row].value;
			var st_doosan_item_no			= document.contentForm.st_doosan_item_no[row].value;
			var st_origin_doosan_item_no	= document.contentForm.st_origin_doosan_item_no[row].value;
	
			if(isEmpty(st_origin_doosan_item_no)){
				alert( " 선택하신 품목은 비재고 품목입니다. \n\n 재고여부 수정이 불가능 합니다.  ");
				box.checked = false;
				return;
			}
	
			if(box.checked == false){
				document.contentForm.st_doosan_item_no[row].value = " ";
			}else{
				document.contentForm.st_doosan_item_no[row].value = st_origin_doosan_item_no;
			}
	
	}
	return;
}
/*
 * 주문하기 
  */
function sendCartList(){	

    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var returnUrl;
    var getCode143 = <%=getCode143%>;

    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
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
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
            	
                var st_item_no = document.forms.contentForm.st_item_no.value;
				var st_description = document.forms.contentForm.st_description.value;
				var st_specification = document.forms.contentForm.st_specification.value;
				var st_unit_price = document.forms.contentForm.st_unit_price.value;
				var st_order_qty = document.forms.contentForm.st_order_qty.value;
				var st_unit_measure = document.forms.contentForm.st_unit_measure.value;
				var st_doosan_item_no = document.forms.contentForm.st_doosan_item_no.value;
				var st_cur = document.forms.contentForm.st_cur.value;
				var st_category_no = document.forms.contentForm.st_category_no.value;
				var st_origin_doosan_item_no = document.forms.contentForm.st_origin_doosan_item_no.value;
				var st_green_flag = document.forms.contentForm.st_green_flag.value;
				var returnUrl = document.forms.contentForm.st_p_return_url.value;
				var st_min_order_qty = document.forms.contentForm.st_min_order_qty.value;			
				
				var item_no_check = st_item_no.substring(0,3);
				if(getCode143 != true){
					if((item_no_check=="08N")||(item_no_check=="08O")||(item_no_check=="08P")||(item_no_check=="08Q")||(item_no_check=="08R")||(item_no_check=="08S")||(item_no_check=="08T")||(item_no_check=="08U")||(item_no_check=="08V")||(item_no_check=="08W")||(item_no_check=="08X")||(item_no_check=="08Y")||(item_no_check=="08Z")){			 
						 alert(" 선택하신 " +st_item_no+" 품목군은 전사관리공구품목으로 주관부서를 제외한 부서에서는 구매하실 수가 없습니다. \n\n 직접구매는 내부통제 및 감사지적사항이므로 자세한 사항은 한홍규기술수석차장이나 김성현대리에게 문의하시기 바랍니다.  ");
						 box.checked = false;      
						 return;      
					}					
				}
				
				if(st_order_qty == "" ||  st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" ) {
					alert(" 첫번째 항목에 수량이 입력되지 않았습니다.   ");
					return;
				}
				if(eval(st_min_order_qty) > eval(st_order_qty)){
					alert(" 최소주문수량은 " +st_min_order_qty +" "+ st_unit_measure+" 이상이어야 합니다.  ");
					return;
				}
				
				if(st_item_no == "" || st_item_no == "null" || st_item_no == null ) st_item_no			= " ";
				if(st_unit_measure == "" || st_unit_measure == "null" || st_unit_measure == null) st_unit_measure			= " ";
				if(st_unit_price == "" || st_unit_price == "null" || st_unit_price == null) st_unit_price			= " ";
				if(st_description == "" || st_description == "null" || st_description == null) st_description			= " ";
				if(st_specification == "" || st_specification == "null" || st_specification == null) st_specification			= " ";
				if(st_doosan_item_no == "" || st_doosan_item_no == "null" || st_doosan_item_no == null ) st_doosan_item_no			= " ";
				if(st_cur == "" ||  st_cur == "null" || st_cur == null ) st_cur			= " ";
				if(st_category_no == "" ||  st_category_no == "null" || st_category_no == null ) st_category_no			= " ";
				if(st_origin_doosan_item_no == "" ||  st_origin_doosan_item_no == "null" || st_origin_doosan_item_no == null ) st_origin_doosan_item_no			= " ";
				
				query = st_item_no +"@@"+st_order_qty+"@@"+st_unit_measure+"@@"+st_unit_price+"@@"+st_description+"@@"+st_specification+"@@"
					+st_doosan_item_no+"@@"+ st_cur+"@@"+st_category_no+"@@"+st_origin_doosan_item_no+"@@"+st_green_flag+"^||^";

            }
        }else{
    		var item_check_cnt = 0;
    		var item_gubun_cnt_E = 0;
    		var item_gubun_cnt_I = 0;
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                var Stockbox = eval("document.forms.contentForm.StockCheck" + i);
                if(box.checked == true){
                	var st_gubun = document.forms.contentForm.st_gubun[i].value;
                	item_check_cnt++;
                	if(st_gubun == "재고가능"){
    	            	if(Stockbox.checked == true){
   	            	     item_gubun_cnt_E++;
	   	            	}else{
	   	            	     item_gubun_cnt_I++;
	   	                }
                		
                	}
    	            if(st_gubun == "비재고"){
    	            	item_gubun_cnt_I++;
    	            }	                	
                }
        		if((item_gubun_cnt_E) > 0 && (item_gubun_cnt_I > 0)){
       			 alert( "  재고자재와 비재고자재가 동시에 주문이 되었습니다.  \n\n  재고/비재고 자재를 구분하여 한가지 자재로만 주문하시기 바랍니다.   ");
       		     return;
	       		}
            }
    		
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);

	                if(box.checked == true){
	                    var st_item_no = document.forms.contentForm.st_item_no[i].value;
	    				var st_description = document.forms.contentForm.st_description[i].value;
	    				var st_specification = document.forms.contentForm.st_specification[i].value;
	    				var st_unit_price = document.forms.contentForm.st_unit_price[i].value;
	    				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;
	    				var st_unit_measure = document.forms.contentForm.st_unit_measure[i].value;
	    				var st_doosan_item_no = document.forms.contentForm.st_doosan_item_no[i].value;
	    				var st_cur = document.forms.contentForm.st_cur[i].value;
	    				var st_category_no = document.forms.contentForm.st_category_no[i].value;
	    				var st_origin_doosan_item_no = document.forms.contentForm.st_origin_doosan_item_no[i].value;
	    				var st_green_flag = document.forms.contentForm.st_green_flag[i].value;
	    				var returnUrl = document.forms.contentForm.st_p_return_url[i].value;
	    				var st_min_order_qty = document.forms.contentForm.st_min_order_qty[i].value;
	    				
	    				var item_no_check = st_item_no.substring(0,3);
	    				if(getCode143 != true){
	    					if((item_no_check=="08N")||(item_no_check=="08O")||(item_no_check=="08P")||(item_no_check=="08Q")||(item_no_check=="08R")||(item_no_check=="08S")||(item_no_check=="08T")||(item_no_check=="08U")||(item_no_check=="08V")||(item_no_check=="08W")||(item_no_check=="08X")||(item_no_check=="08Y")||(item_no_check=="08Z")){			 
	    						 alert(" 선택하신 " +st_item_no+" 품목군은 전사관리공구품목으로 주관부서를 제외한 부서에서는 구매하실 수가 없습니다. \n\n 직접구매는 내부통제 및 감사지적사항이므로 자세한 사항은 한홍규기술수석차장이나 김성현대리에게 문의하시기 바랍니다.  ");
	    						 box.checked = false;      
	    						 return;      
	    					}					
	    				}
	    				
	    				if(st_order_qty == "" ||  st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" ) {
	    					alert(i+1+"번째 항목에 수량이 입력되지 않았습니다.   ");
	    					return;
	    				}
	    				if(eval(st_min_order_qty) > eval(st_order_qty)){
	    					alert(i+1+" 번째  최소주문수량은 " +st_min_order_qty +" "+ st_unit_measure+" 이상이어야 합니다.  ");
	    					return;
	    				}
	    				
	    				if(st_item_no == "" || st_item_no == "null" || st_item_no == null ) st_item_no			= " ";
	    				if(st_unit_measure == "" || st_unit_measure == "null" || st_unit_measure == null) st_unit_measure			= " ";
	    				if(st_unit_price == "" || st_unit_price == "null" || st_unit_price == null) st_unit_price			= " ";
	    				if(st_description == "" || st_description == "null" || st_description == null) st_description			= " ";
	    				if(st_specification == "" || st_specification == "null" || st_specification == null) st_specification			= " ";
	    				if(st_doosan_item_no == "" || st_doosan_item_no == "null" || st_doosan_item_no == null ) st_doosan_item_no			= " ";
	    				if(st_cur == "" ||  st_cur == "null" || st_cur == null ) st_cur			= " ";
	    				if(st_category_no == "" ||  st_category_no == "null" || st_category_no == null ) st_category_no			= " ";
	    				if(st_origin_doosan_item_no == "" ||  st_origin_doosan_item_no == "null" || st_origin_doosan_item_no == null ) st_origin_doosan_item_no			= " ";
	    				
	
	    				query += st_item_no +"@@"+st_order_qty+"@@"+st_unit_measure+"@@"+st_unit_price+"@@"+st_description+"@@"+st_specification+"@@"
						+st_doosan_item_no+"@@"+ st_cur+"@@"+st_category_no+"@@"+st_origin_doosan_item_no+"@@"+st_green_flag+"^||^";
	                }
               }
          }
    }
    setCartDeleted();
	document.forms.searchForm.st_return_url.value = returnUrl;	
	document.forms.searchForm.st_query_cart.value = query;	
	document.forms.searchForm.target = "_blank"; 


	$('#searchForm').attr("action", "/mdcm/sendBuyerMdCmCartPunchoutOrderList.do").submit();

	loader_obj("N");

	kepSearch(1);
	top.opener = self;
	top. window.close();

}	 
//두산중공업 IProcurement 로 장바구니 전송 후 품목 삭제위한 query 설정
function setCartDeleted(){
	 var tot_cnt  = $("#display_item_cnt").val();
	 var query   = "";
     if(eval(tot_cnt) < 2){    	
         var box = eval("document.forms.contentForm.lnCheck0" ); 
         if(box.checked == true){         	
	        var st_item_no = document.forms.contentForm.st_item_no.value;
	        var st_order_qty = document.forms.contentForm.st_order_qty.value;
			var st_contract_no     = document.forms.contentForm.st_contract_no.value;
			var st_contract_seq  = document.forms.contentForm.st_contract_seq.value;
			var st_agent_code = document.forms.contentForm.st_agent_code.value;
			var st_item_seq = document.forms.contentForm.st_item_seq.value;
			var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
			
			query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@"  + "C" +  "@@"  + st_item_seq + "&&";
         }
      }else{
          for(var i = 0; i <tot_cnt; i++){
	          var box = eval("document.forms.contentForm.lnCheck" + i);
	          if(box.checked == true){
		           var st_item_no = document.forms.contentForm.st_item_no[i].value;
		           var st_order_qty = document.forms.contentForm.st_order_qty[i].value; 			
					var st_contract_no     = document.forms.contentForm.st_contract_no[i].value;
					var st_contract_seq  = document.forms.contentForm.st_contract_seq[i].value;
					var st_agent_code = document.forms.contentForm.st_agent_code[i].value;
					var st_item_seq = document.forms.contentForm.st_item_seq[i].value;
					var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
					
					query +=  st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@"  + "C" +  "@@"  + st_item_seq + "&&";
	          }
	      }
      }
     document.forms.searchForm.st_query.value =query;
}

/*
 * 수량변경
  */
function updatePrice(cart_qty, i, buy_price, orgin_cart_qty){


    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
        return;
    }
    

    if(eval(tot_cnt) < 2){
         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
         }else{
             var box = eval("document.forms.contentForm.lnCheck0");
             var sum_price = kepGetRound((cart_qty * buy_price),3);
             document.contentForm.st_order_qty.value = cart_qty;
             document.contentForm.st_sum_price.value = kepCommaNum(sum_price);
             box.checked = true;
         }
    }else{
         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
         }else{
             var box =  eval("document.forms.contentForm.lnCheck" + i);
             var sum_price = kepGetRound((cart_qty * buy_price),3);
             document.contentForm.st_order_qty[i].value = cart_qty;
             document.contentForm.st_sum_price[i].value = kepCommaNum(sum_price);
             box.checked = true;
         }
    }
    
    if(eval(tot_cnt) < 2){    	
	        var st_item_no = document.forms.contentForm.st_item_no.value;
	        var st_order_qty = document.forms.contentForm.st_order_qty.value;
			var st_contract_no     = document.forms.contentForm.st_contract_no.value;
			var st_contract_seq  = document.forms.contentForm.st_contract_seq.value;
			var st_agent_code = document.forms.contentForm.st_agent_code.value;
			var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
			var st_item_seq = document.forms.contentForm.st_item_seq.value;	              
			query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + st_item_seq + "@@"  + st_order_qty + "&&";
      }else{
            var st_item_no = document.forms.contentForm.st_item_no[i].value;
            var st_order_qty = document.forms.contentForm.st_order_qty[i].value; 			
 			var st_contract_no     = document.forms.contentForm.st_contract_no[i].value;
 			var st_contract_seq  = document.forms.contentForm.st_contract_seq[i].value;
 			var st_agent_code = document.forms.contentForm.st_agent_code[i].value;
 			var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
 			var st_item_seq = document.forms.contentForm.st_item_seq[i].value; 			
 			query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + st_item_seq + "@@"  + st_order_qty + "&&";
        }
    //장바구니
    document.forms.processForm.st_use_flag.value = "C"; 
    document.forms.processForm.st_query2.value = query;
	var gubun = "updatePrice";
    kepAjaxFormCall("/mdcm/saveBuyerMdCmCartQtyPunchOut.do","processForm",gubun);
}
 
/*
 * 장바구니삭제 D
 * 나의상품담기 R
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
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
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
            	
                var st_item_no = document.forms.contentForm.st_item_no.value;
				var st_agent_code = document.forms.contentForm.st_agent_code.value;
				var st_contract_no     = document.forms.contentForm.st_contract_no.value;
				var st_contract_seq  = document.forms.contentForm.st_contract_seq.value;
				var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
				var st_description = document.forms.contentForm.st_description.value;
				var st_specification = document.forms.contentForm.st_specification.value;
				var st_unit_price = document.forms.contentForm.st_unit_price.value;
				var st_order_qty = document.forms.contentForm.st_order_qty.value;  
                
				query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + st_description + "@@"  + st_specification +  "@@"  + st_unit_price + "@@" + st_order_qty + "&&";

            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);

	                if(box.checked == true){
	                    var st_item_no = document.forms.contentForm.st_item_no[i].value;
	    				var st_agent_code = document.forms.contentForm.st_agent_code[i].value;
	    				var st_contract_no     = document.forms.contentForm.st_contract_no[i].value;
	    				var st_contract_seq  = document.forms.contentForm.st_contract_seq[i].value;
	    				var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
	    				var st_description = document.forms.contentForm.st_description[i].value;
	    				var st_specification = document.forms.contentForm.st_specification[i].value;
	    				var st_unit_price = document.forms.contentForm.st_unit_price[i].value;
	    				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;  
	
	 
						 query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + st_description + "@@"  + st_specification +  "@@"  + st_unit_price + "@@" + st_order_qty;
						 query += "&&";
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
	
    if (runFlag == "RsaveProcess"){
		$("#confirmMsg").text(msg+"으로 저장하시고\n"+msg+"보기 화면으로 이동하시겠습니까?");
		$("#confirmArea").show(); 
    }else{
        if(!confirm("선택하신 품목을 장바구니에서 삭제하시겠습니까?")){
            return;
        }else{
        	runProcess(runFlag,query,flag);
        }
    }
	 //runProcess(runFlag,query,flag);
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

	if (gubun == "RsaveProcess"){ // 장바구니 
		document.forms.processForm.st_use_flag.value = "R"; // 나의상품담기
		document.forms.processForm.st_query2.value = query;		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmPopularGoods.do","processForm",gubun);
	}else if (gubun == "DsaveProcess"){ // 나의상품삭제 
		document.forms.processForm.st_use_flag.value = "C"; // 장바구니삭제
		document.forms.processForm.st_query2.value = query;
		kepAjaxFormCall("/mdcm/removeBuyerMdCmMyPunchOutLisList.do","processForm",gubun); 
	}  		 	

}
  

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){

	var sMsg = response.msg.MSG;  
	var confirm4 = $("#confirm4").val();
	
    if(sMsg == "CREATE_OK"){
    	
        if(pMethod == "RsaveProcess")
        {
        	alert("나의상품으로 등록 되었습니다.   ");
           
           if (confirm4 == "search"){ 
         	  // 계속검색클릭 
            	 // 처리후 재조회
            	 kepSearch($("#curPage").val());           	   
           }else{     
        	   
        	   $('#locationForm').attr("action", "/mdcm/getBuyerMdCmMyPunchOutList.do").submit();    
        	 
           }
        	
       }else if(pMethod=="updatePrice"){
       
       }else {       
          alert("장바구니 정상적으로 삭제되었습니다.  ");
      	 // 처리후 재조회
      	 kepSearch($("#curPage").val());
       } 
        
      }else{
    	  
         if(pMethod == "RsaveProcess")
          {
            alert("품목코드 (" + sMsg + ") 은 이미 나의 상품에 저장된 항목입니다.  ");
          } 
         
     	 // 처리후 재조회
     	 kepSearch($("#curPage").val());
         
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "RsaveProcess"){ 
		 alert("나의상품 담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "DsaveProcess"){ 
		 alert("장바구니 삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}  
	 
	
} 
 
//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}


</script>
</html>
