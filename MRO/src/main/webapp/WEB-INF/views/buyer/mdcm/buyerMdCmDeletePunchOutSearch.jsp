<%--
**********************************************
* 메뉴 : 인기상품검색>삭제단종검색
* 화면 : 삭제단종검색
* 기능 : 삭제단종검색
* 프로그램 ID : PG_02_B_000834_003
* 담당자 : 현명환
* 착수일 : 2015-03-03
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
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"50");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.    
	// 조회조건 S
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");    
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");    
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");    	
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

	//SLOGIC-BEGIN(P06-0000036)
	 String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	 String p060000036 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000036","COL02_DATA", request); // 권한별URL
	 if (p060000036 == null){
	 	p060000036 = defaultUrl;
	 }else if ("".equals(p060000036)){
	 	p060000036 = defaultUrl;
	 }
	 //SLOGIC-END
	 
%> 

<body onLoad="kep_onload_view()">
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
	<h3>삭제단종품검색</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회"><a href="javascript:doAction('search','');">조회</a></span> 
		<span class="btn_reset" title="초기화"><a href="javascript:doAction('reload','');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
 		
		<input type="hidden" name="st_sort_column"			value="<%=sort_column%>">
		<input type="hidden" name="st_sort_flag"			value="<%=sort_flag%>">
		<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">				
		<div id="cont_searchA">	
			<!-- 수정전 --><!-- table class="cont_t_list01" style="width:100%;"-->
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
						<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%" value="<%=st_buyer_item_no%>" onKeyDown="kepEnter()"> 
					</td>
					<th>품목명</th>
					<td>
						<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:80%" value="<%=st_description%>"  onKeyDown="kepEnter()">
					<th>규격</th>
					<td>
						<input type="text" class="input_type_text" name="st_specification" id="st_specification" style="width:80%" value="<%=st_specification%>"  onKeyDown="kepEnter()">
					</td>
				</tr>
				</tbody>
			</table>
		</div> 
		<div class="contList"> <span class="fl"> <img src="/resources/images/txt_no.gif" alt="정렬개수" />
		  <label for="b_no02" class="hidden">정렬개수선택</label>
		  <select name="onepagerow" onChange="javascript:kepSearch(1);">
		    <option  selected value = "10">10건</option>
		    <option  value = "30">30건</option>
		    <option  value = "50">50건</option>
		    <option  value = "100">100건</option>
		    <option  value = "200">200건</option>
		  </select>
		  </span>
	</div>
		<div class="alltxt"> (기준: 원)</div>
		
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list002" style="width:100%">
			  <colgroup>
			  <col width="7%" />
			  <col width="20%" />
			  <col width="31%" />
			  <col width="13%" />
			  <col width="13%" />
			  <col width="9%" />
			  <col width="7%" />
			  </colgroup>
	        <thead>
			<tr>
				<th scope="col">&nbsp;</th>
				<th scope="col" >
					<a class="hyperLink"  href="javascript:setSortingList('Q.BUYER_ITEM_NO');">KeP품목코드</a> / 두산 품목코드
                <th scope="col" >	                 
	                <a class="hyperLink"  href="javascript:setSortingList('Q.DESCRIPTION');">품목명</a> / <a class="hyperLink"  href="javascript:setSortingList('Q.SPECIFICATION');">규격</a></th>
                <th scope="col">원산지 / 
                	제조사
                </th>
                <th scope="col">협력사</th>
                <th scope="col">단가</th>
                <th scope="col">상태</th>
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
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_byit_comorg_code"   value="<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>">
                   <input type="hidden" name="st_item_seq"  value="000001">
                   <input type="hidden" name="st_description_loc"   value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>">
                   <input type="hidden" name="st_specification_loc"   value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
                   <input type="hidden" name="st_order_qty"   value="1">
                   <input type="hidden" name="st_unit_price"   value="<%=CommonUtil.nvl(rowData.get("UNIT_PRICE"))%>">
                   </div>
					</td>
                    <td title="KeP 품목코드/ 두산 품목코드" class="left">&nbsp;<a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>&nbsp;/&nbsp;	                    
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
		          	<td class="right"   title="단가" >
		          		<span class="Price"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>
		            </td>
			          <td class="center"  title="상태"  >
			          <%=rowData.get("PRODUCT_CLOSE_FLAG")%>
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
				<span class="btn_04" title="삭제단종" >
					<a href="javascript:doAction('excelDown','');">다운로드</a> 
				</span>				
            </div>
        </div>
</form>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id_session" id="st_user_id_session" value="${sessionInfo.userId}">
</form>
<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 	
	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="">
	<input type="hidden" name="st_description" id="st_description" value="">
	<input type="hidden" name="st_specification" id="st_specification" value="">
	<input type="hidden" name="st_maker_name" id="st_maker_name" value="">		
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
		var st_buyer_item_no = document.forms.searchForm.st_buyer_item_no.value;
		if(st_buyer_item_no ==""){
	  		  alert(" 검색대상 품목코드 및 재고코드를 입력하셔야 합니다.  ");
	  		  return;
		}
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		document.forms.searchForm.st_buyer_item_no.value = "";
		document.forms.searchForm.st_description.value = "";
		document.forms.searchForm.st_specification.value = "";
		document.forms.searchForm.st_maker_name.value = "";

		jspTableClean("table_list");
		break;
	case "excelDown":	//엑셀다운
		var st_buyer_item_no = document.forms.searchForm.st_buyer_item_no.value;
		if(st_buyer_item_no ==""){
	  		  alert(" 검색대상 품목코드 및 재고코드를 입력하셔야 합니다.  ");
	  		  return;
		}	
		document.forms.searchForm.action = "/mdcm/excelBuyerMdCmDeletePunchOutSearchList.do";
		document.forms.searchForm.submit();
		break; 
  
	}
}

//정렬
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
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmDeletePunchOutSearchList.do").submit();   
} 





</script>
</html>
