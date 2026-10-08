<%--
**********************************************
* 메뉴 : 상품검색>나의상품검색
* 화면 : 나의상품검색
* 기능 : 나의상품으로 등록된 상품을 조회하여 상품목록으로 보여준다.
* 프로그램 ID : PG_02_B_000834_002
* 담당자 : 현명환
* 착수일 : 2014-03-03
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
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");    
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");    
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");
	String st_category_no = CommonUtil.nvl((String) request.getParameter("st_category_no"),"");	
	String sort_column           = CommonUtil.nvl((String) request.getParameter("st_sort_column"),"ALL"); 
	String sort_flag           = CommonUtil.nvl((String) request.getParameter("st_sort_flag"),"ASC"); 
	String st_user_folder = CommonUtil.nvl((String) request.getParameter("st_user_folder"),"");
	// 조회조건 E	
	
	String SessionComCode = "";
	String SessionUserId = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	String img_view_flag   = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
		SessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId());		
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
	}  
	 if(image_status.equals("")){  
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	 
	//SLOGIC-BEGIN(P06-p060000056)
		/*
		* 나의상품검색
		* A: 두산엔진 KRHSDE0003
		*/
		String p060000056 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000056","COL02_DATA"); // 검색조건변경
	 //SLOGIC-END
	 
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
	<h3>나의상품검색</h3>
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
		<input type="hidden" name="st_category_no"			value="<%=st_category_no%>">
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">		
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption>조회</caption>
				<colgroup>
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
				</colgroup>				
				<tbody>
				<tr>
					<th>품목코드</th>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value="<%=st_buyer_item_no%>" onKeyDown="kepEnter()">
					</td>
					<th>품목명</th>
					<td>
						<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:90%;" value="<%=st_description%>"  onKeyDown="kepEnter()">
					</td>
					<th>규격</th>
					<td>
						<input type="text" class="input_type_text" name="st_specification" id="st_specification" style="width:90%;" value="<%=st_specification%>"  onKeyDown="kepEnter()">
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option>
				<option value = "200" <%if ("200".equals(onepagerow)) {%>selected<%} %>>200건</option>  
			</select>
<%
if(p060000056.equals("A")){
%>
			나의카테고리 :
			<select name="st_user_folder" id="st_user_folder"  onChange="javascript:kepSearch(1);"><%= CommonUtil.getFolderInfoComboList(SessionComCode,"SEL",SessionUserId,"FolderInfo1",st_user_folder,"TEXT1") %></select>
<%}else{ %>
			<input type="hidden" name="st_user_folder" id="st_user_folder" value="">	
<%}%>
      	</span>      
       <span class="fr"> (기준: 원)</span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list002" style="width:100%">
			<colgroup>
			  <col width="3%" />
<%
if(p060000056.equals("A")){
%>
			  <col width="4%" />
<%}else{ %>
			  <col width="7%" />
<%} %>
			  <col width="18%" />
			  <col width="*" />
			  <col width="10%" />
			  <col width="10%" />
<%
if(p060000056.equals("A")){
%>
			  <col width="10%" />
<%}else{ %>
			  <col width="7%" />
<%} %>			
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
<%
if(p060000056.equals("A")){
%>
				<th scope="col"> <a class="hyperLink"  href="javascript:setSortingList('C.BUYER_ITEM_NO');">ItemNO</th>
                <th scope="col" >
	                <a class="hyperLink" href="javascript:setSortingList('C.DESCRIPTION');">품목명</a> 
	                / <a class="hyperLink" href="javascript:setSortingList('C.SPECIFICATION');">규격</a></th>
                <th scope="col">원산지 / 제조사</th>
                <th scope="col">협력사</th>
                <th scope="col">카테고리 / 단위</th>
                <th scope="col">현단가</th>
<%
}else{
%>
				<th scope="col"> <a class="hyperLink"  href="javascript:setSortingList('C.BUYER_ITEM_NO');">KeP 품목코드</a> / 두산 품목코드</th>
                <th scope="col" >
	                <a class="hyperLink" href="javascript:setSortingList('C.DESCRIPTION');">품목명</a> 
	                / <a class="hyperLink" href="javascript:setSortingList('C.SPECIFICATION');">규격</a></th>
                <th scope="col">원산지 / 제조사</th>
                <th scope="col">협력사</th>
                <th scope="col">수량 / 현단가</th>
                <th scope="col">단위 / <br>재고여부</th>
<%
}
%>
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
						<input type="checkbox" class="input_noline"  name="lnCheck<%=j%>">	                   
					</td>
					
					<td title="이미지">					
					<div class="PDimg"> 			
		<% 
		    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
		%>
		         	<img src="/resources/images/noimage.gif" width="80" height="80" border="0"> 
		 
		<%     }else{ %> 
		             <a  class="hyperLink"  href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
		             <img src="<%=CommonUtil.realImgS3UploadPath+"/item_image/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
		         
		<%     }
		
		%>		
	
					<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
                   <input type="hidden" name="st_contract_no"   value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq"   value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_agent_code"  value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
                   <input type="hidden" name="st_item_seq" value="<%=CommonUtil.nvl(rowData.get("ITEM_SEQ"))%>">
                   <input type="hidden" name="st_description" value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>">
                   <input type="hidden" name="st_specification" value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
                   <input type="hidden" name="st_unit_price" value="<%=CommonUtil.nvl(rowData.get("UNIT_PRICE"))%>">
                   
                   
                   </div>
					</td>
<%
if(p060000056.equals("A")){
%>
                    <td title="ItemNO" class="left">&nbsp;<a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>&nbsp;&nbsp;	                    
	                    <br><%=rowData.get("DOOSAN_BUYER_ITEM_NO")%>
	                    <input type="hidden" name="st_order_qty"  value = "<%=rowData.get("TARGET_QTY")%>">	                    
                    </td> 
                    <td title="품목명 / 규격" class="left">&nbsp;<%=rowData.get("DESCRIPTION")%>
                    	<br><%=rowData.get("SPECIFICATION")%>
                    </td> 
					<td class="center" title="원산지 /제조사 ">
						<%=rowData.get("ORIGIN_TEXT")%><br><%=rowData.get("MAKER_NAME")%>
					</td>
					 <td class="center"  title="협력사">  
						<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_NAME")%></a>
					</td>
		          	<td class="right"  title="카테고리 / 단위">
			          	<%=rowData.get("ITEM_SEQ_NAME")%>
		          		<br><%=rowData.get("UNIT_MEASURE")%>		          		
		            </td> 
		          	<td class="center"  title="현단가">
		          		<span class="Price"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>
		            </td> 
<%}else{ %>
                    <td title="KeP 품목코드/ 두산 품목코드" class="left">&nbsp;<a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>&nbsp;&nbsp;	                    
	                    <br><%=rowData.get("DOOSAN_BUYER_ITEM_NO")%>	                    
                    </td> 
                    <td title="품목명 / 규격" class="left">&nbsp;<%=rowData.get("DESCRIPTION")%>
                    	<br><%=rowData.get("SPECIFICATION")%>
                    </td> 
					<td class="center" title="원산지 /제조사 ">
						<%=rowData.get("ORIGIN_TEXT")%><br><%=rowData.get("MAKER_NAME")%>
					</td>
					 <td class="center"  title="협력사">  
						<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_NAME")%></a>
					</td>
		          	<td class="right"  title="수량 / 단위">
		          		<input type="text" name="st_order_qty" style="width:70%;text-align:right;" id="line" class = "input_type_text" value = "<%=rowData.get("TARGET_QTY")%>">
		          		<br><span class="Price"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>
		            </td> 
		          	<td class="center"  title="현대가 / 재고여부">
		          		<%=rowData.get("UNIT_MEASURE")%>
		          		<br><%=rowData.get("GUBUN")%>
		            </td>
<%} %>
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
			<div class="fl">
<%
if(p060000056.equals("A")){
%>
			<select name="st_folder_1" onchange="javascript:changeButton();">
				<option value="/kr/new/common/image/button/but_regist2.gif" selected >카테고리로 등록 :</option>
		        <option value="/kr/new/common/image/button/but_change.gif" >카테고리명 변경 :</option>		        
			</select>
			<select name="st_folder_2" id="st_folder_2"><%= CommonUtil.getFolderInfoComboList(SessionComCode,"NO",SessionUserId,"FolderInfo2","","TEXT1") %></select>
			 <span id="layer1"></span>
			<span class="btn_04" title="등록하기" >
				<a href="javascript:doAction('link',document.forms.contentForm.st_folder_1.selectedIndex);">등록하기</a> 
			</span>
<%}else{ %>
				<span class="btn_08" title="카테고리별항목보기"><a href="javascript:getBuyerCategoryPunchOutDisplayPop();">카테고리별항목보기</a></span>
<%} %>
			</div>
			<div class="fr">				
				<span class="btn_04" title="삭제" >
					<a href="javascript:doAction('remove','');">삭제</a> 
				</span>
				<span class="btn_04" title="다운로드" >
					<a href="javascript:doAction('excelDown','');">다운로드</a> 
				</span>	
				<span class="btn_04" title="장바구니담기" >
					<a href="javascript:doAction('cartItem','');">장바구니담기</a>
				</span>					
            </div>
        </div> 
</form>
 


<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_folder_code" id="st_folder_code"  value=""/> 
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
		document.forms.searchForm.st_buyer_item_no.value = "";
		document.forms.searchForm.st_description.value = "";
		document.forms.searchForm.st_specification.value = "";
		document.forms.searchForm.st_maker_name.value = "";
		
		jspTableClean("table_list");
		break; 
		
	case "excelDown": // 엑셀다운로드

		document.forms.searchForm.action = "/mdcm/excelBuyerMdCmMyPunchOutList.do";
		document.forms.searchForm.submit();
		break;
		
	case "remove": // 나의상품 담기한결과 삭제
		saveProcess("D");
		break;  
	
	case "cartItem": // 장바구니 담기
		saveProcess("C");
		break;
	case "link": // 장바구니 담기
		saveLink(gubun);
		break;  		
  
	}
}
/*
 * 카테고리 등록 및 변경
  */
function saveLink(gubun){    
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
    	if(gubun == 0){//카테고리 등록
            if(!confirm("선택된 품목을 카테고리로 등록하시겠습니까?")){
                return;
            }
	        if(eval(tot_cnt) < 2){
	            var box = eval("document.forms.contentForm.lnCheck0" ); 
	            if(box.checked == true){
	            	
	                var st_item_no = document.forms.contentForm.st_item_no.value;
					var st_agent_code = document.forms.contentForm.st_agent_code.value;
					var st_contract_no     = document.forms.contentForm.st_contract_no.value;
					var st_contract_seq  = document.forms.contentForm.st_contract_seq.value;
					var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
					var st_item_seq = document.forms.contentForm.st_item_seq.value;
	                
					query = st_item_no + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_agent_code + "@@" + st_byit_comorg_code + "@@"  + st_item_seq + "@@"  +"R"+ "&&";
	
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
		    				var st_item_seq = document.forms.contentForm.st_item_seq[i].value;
		 
		    				query += st_item_no + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_agent_code + "@@" + st_byit_comorg_code+ "@@"  + st_item_seq  + "@@"  +"R";
							 query += "&&";
		                }
	               }
	          }
			document.forms.processForm.st_query2.value = query;
			document.forms.processForm.st_folder_code.value = document.forms.contentForm.st_folder_2.value;
			kepAjaxFormCall("/mdcm/saveBuyerMdCmFolderCode.do","processForm",gubun);
    	}else{
   		   var folder_name_old = document.forms.contentForm.st_folder_2.value;
   		   var folder_name_new = document.forms.contentForm.st_folder_3.value;
   		   if(folder_name_new == ""){
   		        alert("  변경할 카테고리명이 입력되지 않았습니다.  ");
   		        document.forms.contentForm.st_folder_3.focus();
   		        return;
   		   }
              if(!confirm(folder_name_new+"(으)로 카테고리명을 변경하시겠습니까?")){
                  return;
              }
   		   query = folder_name_old+ "@@" + folder_name_new+ "&&";
   		   
   		   document.forms.processForm.st_query2.value = query;
   		   kepAjaxFormCall("/mdcm/saveBuyerMdCmFolderName.do","processForm",gubun);
    		   
    	}
    }	 

}
//카테고리 선택
function changeButton(){
	
	var len = document.contentForm.st_folder_1.options[document.contentForm.st_folder_1.selectedIndex].value; 
	txtbox = " "; 
	
	if(len == "/kr/new/common/image/button/but_change.gif"){
	   txtbox = "<b>=></b><input type=text name=st_folder_3 size=20 value='10자이내 입력.!!' onFocus=this.value=''  class=input_type_text  style='font-family:돋움; font-size:12;'>"; 
	   layer1.innerHTML = txtbox; 
	}else{
	   layer1.innerHTML = ""; 
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
//카테고리 조회
function setQueryCateg(catege){	
	
	document.forms.searchForm.st_category_no.value = catege; 

	document.forms.searchForm.curPage.value = 1; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmMyPunchOutList.do").submit();
}
// 조회
function kepSearch(curPage){	
	document.forms.searchForm.st_category_no.value = ""; 
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmMyPunchOutList.do").submit();   
}
/*
 * 나의상품삭제 D
 * 장바구니담기 C
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
	
    if (runFlag == "CsaveProcess"){
		$("#confirmMsg").text(msg+"으로 저장하시고\n"+msg+"보기 화면으로 이동하시겠습니까?");
		$("#confirmArea").show(); 
    }else{
        if(!confirm("선택하신 품목을 나의상품에서 삭제하시겠습니까?")){
            return;
        }else{
        	runProcess(runFlag,query,flag);
        }
    }
	 //runProcess(runFlag,query,flag);
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
		kepAjaxFormCall("/mdcm/saveBuyerMdCmPopularGoods.do","processForm",gubun);
	}else if (gubun == "DsaveProcess"){ // 나의상품삭제 
		document.forms.processForm.st_use_flag.value = "R"; // 나의상품삭제
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
    	
	        if(pMethod == "CsaveProcess")
	        {
	           alert("장바구니에 저장되었습니다.   ");
	           
	           if (confirm4 == "search"){ 
	         	  // 계속검색클릭 
	            	 // 처리후 재조회
	            	 kepSearch($("#curPage").val());           	   
	           }else{     
	        	   
	        	   $('#locationForm').attr("action", "/mdcm/getBuyerMdCmCartPunchOutList.do").submit();    
	        	 
	           }
	        	
	       }else if(pMethod == "DsaveProcess"){
	          alert("나의상품 정상적으로 삭제되었습니다.  ");
	      	 // 처리후 재조회
	      	 kepSearch($("#curPage").val());
	       }else{
	    	 kepSearch($("#curPage").val());  
	       } 
      }else{
    	  
         if(pMethod == "CsaveProcess")
          {
            alert("품목코드 (" + sMsg + ") 은 이미 장바구니에 저장된 항목입니다.  ");
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
		 alert("장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "DsaveProcess"){ 
		 alert("나의상품삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}  
	 
	
} 
 
//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}


</script>
</html>
