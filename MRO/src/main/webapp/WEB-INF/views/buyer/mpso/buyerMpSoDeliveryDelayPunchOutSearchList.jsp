<%--
**********************************************
* 메뉴 : 주문진행관리>납기지현품목
* 화면 : 납기지현품목
* 기능 : 고객사 전용 또는 인기상품 검색.
* 프로그램 ID : PG_02_B_000834_010
* 담당자 : 현명환
* 착수일 : 2015-03-11
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
	String st_legacy_po_no = CommonUtil.nvl((String) request.getParameter("st_legacy_po_no"),"");    

	// 조회조건 E
	
	String SessionComCode = "";
	String img_view_flag   = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 

	}  

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
	<h3>납기지연품목현황</h3>
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
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<!-- 화면 내 정의 -->	
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
					<th>발주번호</th>
					<td>
						<input type="text" class="input_type_text" name="st_legacy_po_no" id="st_legacy_po_no" style="width:80%" value="<%=st_legacy_po_no%>" onKeyDown="kepEnter()"> 
					</td>
					<th>품목코드</th>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%" value="<%=st_buyer_item_no%>"  onKeyDown="kepEnter()">
					<th>조회기준</th>
					<td>
						발주 후 납기요청일이 지났는데도 아직 납품되지 않은 품목
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
			  <col width="15%" />
			  <col width="45%" />
			  <col width="7%" />
			  <col width="10%" />
			  <col width="8%" />
			  <col width="15%" />
			  </colgroup>
	        <thead>
			<tr>
				<th scope="col">발주번호 / 요청번호</th>
                <th scope="col" >
	                품목코드 / 품목명 / 규격 
                <th scope="col"> 
                	발주수량 <br>지연일수
                </th>
                <th scope="col"> 
                	납기요청일 <br>발주일
                </th>
                <th scope="col"> 
                	발주단가 <br>발주금액
                </th>
                <th scope="col"> 
                	협력사
                </th>                                 
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
					<td class="center"  title="발주번호 / 요청번호" >
						<%=rowData.get("LEGACY_PO_NO")%>-<%=rowData.get("LEGACY_PO_SEQ")%><br>
						<%=rowData.get("REF_PR_NO")%>
					</td>
                    <td title="품목코드 / 품목명 / 규격"  class="left">
                    	&nbsp;<a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>&nbsp;/&nbsp;<%=rowData.get("DESCRIPTION")%> 
	                    <br>&nbsp;&nbsp;<%=rowData.get("SPECIFICATION")%> 
                    </td> 
		          	<td class="right"   title="발주수량 / 지연일수" >
		          		<span class="Price"><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></span>
		          		<br><span class="Price"><%=CommonUtil.formatNumber(rowData.get("DELAY_DAY"),true,0,3)%></span>
		            </td>
			          <td class="center"  title="납기요청일/발주일"  >
			          	<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
            		</td>
			          <td class="right"  title="발주단가/발주금액"  >
		          		<span class="Price"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>
		          		<br><span class="Price"><%=CommonUtil.formatNumber(rowData.get("PO_SUM"),true,0,3)%></span>
            		</td>
					<td class="center"  title="협력사 / 발주자" >
						<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_TEXT")%></a>
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
	
		// 정렬순서 조정
		if (gubun != ""){			
			$("#st_sort_gubun").val(gubun); 
		    if($("#st_sort_change").val() == '0'){
		    	$("#st_sort_change").val("1");
		    }else {
		    	$("#st_sort_change").val("0");
		    }
		} else {
			$("#st_sort_gubun").val(""); 
			$("#st_sort_change").val("");
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
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoDeliveryDelayPunchOutList.do";
		document.forms.searchForm.submit();
		break; 
  
	}
}
 
// 조회
function kepSearch(curPage){
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoDeliveryDelayPunchOutList.do").submit();   
} 



</script>
</html>
