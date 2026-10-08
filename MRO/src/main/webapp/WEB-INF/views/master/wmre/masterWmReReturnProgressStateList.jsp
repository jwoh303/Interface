<%--
**********************************************
* 메뉴 : 반품>반품조회>반품진행현황 조회
* 화면 : 반품진행현황 조회
* 기능 : 협력사 반품진행현황
* 프로그램 ID : PG_08_M_019_12
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-19
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


//조회 조건 
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
String st_BUYER_PERSON_NAME =  CommonUtil.nvl((String) request.getParameter("st_BUYER_PERSON_NAME"),""); 
String st_buyer_name =  CommonUtil.nvl((String) request.getParameter("st_buyer_name"),""); 
String st_buyer_code =  CommonUtil.nvl((String) request.getParameter("st_buyer_code"),""); 
String st_WMRE_NO =  CommonUtil.nvl((String) request.getParameter("st_WMRE_NO"),""); 
String st_PO_NO =  CommonUtil.nvl((String) request.getParameter("st_PO_NO"),""); 
String st_WMRE_TYPE =  CommonUtil.nvl((String) request.getParameter("st_WMRE_TYPE"),""); 
String st_flag =  CommonUtil.nvl((String) request.getParameter("st_flag"),""); 
String st_date_type =  CommonUtil.nvl((String) request.getParameter("st_date_type"),""); 
String st_ADD_USER_NAME =   CommonUtil.nvl((String) request.getParameter("st_ADD_USER_NAME"),""); 
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String buyer = sessionInfo.getComCode();
String userid = sessionInfo.getUserId();
String row_cnt = sessionInfo.getRowCnt();
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수  
String str_businessCond = sessionInfo.getBusinessCond();

%> 





<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>반품진행현황</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
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
			
		<div id="cont_searchA"  width="680">	
        	<!-- 수정전 --><!-- table class="cont_t_list01" style="width:100%;"-->
            <table class="cont_t_list01" ><!-- 마이페이지 닫힐때 width="887"-->
				<caption>조회</caption>
				<colgroup>
					<col width="14%" />
					<col width="30%" />
					<col width="10%" />
					<col width="20%" />
					<col width="8%" />
                    <col width="*" />
				</colgroup>
				
				<tbody>
				<tr>
							<th><select name="st_date_type" class="TitSelect">
									<option value="add_date" <%if ("add_date".equals(st_date_type)) {%>selected<%} %>>요청일자</option>							
									<option value="rd_date"  <%if ("rd_date".equals(st_date_type)) {%>selected<%} %>>접수일자</option>
									<option value="po_create_date" <%if ("po_create_date".equals(st_date_type)) {%>selected<%} %>>발주일자</option>

								</select></th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="<%=st_from_date%>">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;"  value="<%=st_to_date%>">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
					
				</tr>
				<tr>
							<th>고객사</th>
							  <td>
								 <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="<%=st_buyer_name %>" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:60%" value="<%=st_buyer_code%>">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
					<th>요청번호</th>
					<td>
						<input type="text" class="input_type_text" name="st_WMRE_NO" id="st_WMRE_NO" style="width:65%;ime-mode:active"   onKeyUp="kepToUpper('st_WMRE_NO')"  value="<%=st_WMRE_NO%>"  onKeyDown="kepEnter()">
					</td>
					<th>발주번호</th>
					<td>
						<input type="text" class="input_type_text" name="st_PO_NO" id="st_PO_NO" style="width:65%;ime-mode:active"   onKeyUp="kepToUpper('st_PO_NO')"   value="<%=st_PO_NO%>"  onKeyDown="kepEnter()">
					</td>
					
				</tr>
				
				<tr>	
							<th>요청유형</th>
							<td>
								 <select id="st_WMRE_TYPE" name="st_WMRE_TYPE" style="width:85%;height:20px">
								<%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM01","SEL",st_WMRE_TYPE  ) %>
								</select>
							</td>
							<th>진행상태</th>
							<td>								 
							  <select  name="st_flag" id= "st_flag" style="width:80%;height:20px">
							  <%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM07","SEL",st_flag) %>
								</select>
							</td>

					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onChange="javascript:kepSearch(1);">   
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
			</select>
      	</span>        

       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<table class="cont_t_list08" style="width:100%;table-layout:fixed;">
			<colgroup>
	            <col width="8%" />
	            <col width="7%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">요청번호<br/>발주번호</th>
                <th scope="col">출고구분<br>발주순번</th>
                <th scope="col">품목명<br>규격</th>
                <th scope="col">고객사<br>고객사요청</th>
                <th scope="col">발주수량<br/>협력사접수</th>
                <th scope="col">요청수량<br>센터회수</th>
                <th scope="col">단위<br/>센터반출</th>
                <th scope="col">접수자<br>협력사입고</th>
                <th scope="col">진행상태<br>센터교환입고</th>
                <th scope="col">파일첨부<br>센터교환납품</th>
                 <th scope="col">협력사교환납품</th>               
                <th scope="col">종결</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="12" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				String fontColor = "13".equals(rowData.get("FLAG"))?"#FF0000":"#0054FF";
		%> 
			   <tr bgcolor="<%=tclass%>">
			        <td title="요청번호/발주번호" ><%=CommonUtil.nvl(rowData.get("WMRE_NO"))%><br/>
			        <%=CommonUtil.nvl(rowData.get("PO_NO"))%>
			        </td>
			        <td title="출고구분/발주순번" ><%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_NM")) %><br/>
			         <%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>
			        </td>
                    <td title="품목명/규격" class="left" ><%=CommonUtil.textMore(CommonUtil.nvl(rowData.get("DESCRIPTION")),20)%><br/>
                    <%=CommonUtil.textMore(CommonUtil.nvl(rowData.get("SPECIFICATION")),20)%>                  
                    </td>
   					<td title="고객사/고객사요청"  ><a  class="hyperLink" href="javascript:buyerDetail(  '<%=CommonUtil.nvl(rowData.get("BUYER_DEPT_NAME"))%>' , '<%= CommonUtil.nvl(rowData.get("BUYER_PERSON_NAME"))%>' , '<%= CommonUtil.nvl(rowData.get("BUYER_PERSON_TEL"))%>'   );"><%=CommonUtil.nvl(rowData.get("BUYER_NAME")) %></a><br/>
   					<%
   					String end_cancel = "";
   					
   					if( "13".equals(CommonUtil.nvl(rowData.get("FLAG")))  || "19".equals(CommonUtil.nvl(rowData.get("FLAG")))  || "02".equals(CommonUtil.nvl(rowData.get("FLAG")))    ){
   						end_cancel = "Y";
   					}
   					
   					%>
                    <a  class="hyperLink"  href="javascript:manage_update('<%=CommonUtil.nvl(rowData.get("WMRE_NO"))%>'  ,'<%=end_cancel %>'   );" > 
                    <div style="background-color:#FFE08C"><font color="<%=fontColor%>" ><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("B_REQ_DATE")) )%>    </font>&nbsp</div>
                    
                    </a>
                	 
   					</td>
   					<td title="발주수량/협력사접수"  ><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,3)%><br/>
   					 <%if(!"09".equals(CommonUtil.nvl(rowData.get("WMRE_TYPE"))) && !"".equals(CommonUtil.nvl(rowData.get("M_REC_DATE")))  ) {%>
                  <a  class="hyperLink"  href="javascript:manage_refund('<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE")) %>'  ,  '<%=CommonUtil.nvl(rowData.get("WMRE_TYPE")) %>'  , '<%=CommonUtil.nvl(rowData.get("WMRE_NO")) %>' , '<%=CommonUtil.nvl(rowData.get("ITEM_QTY")) %>' ,'<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_NM")) %>' ,'<%=CommonUtil.nvl(rowData.get("WMRE_TYPE_NAME")) %>' ,'<%=CommonUtil.nvl(rowData.get("FLAG")) %>' );" ><div style="background-color:#FFE08C"><font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("S_REC_DATE")))%></font>&nbsp</div></a>
 <%}else{ %>  
                    <font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("S_REC_DATE")))%></font>
<%} %>  
                    <td title="요청수량/센터회수" ><%=CommonUtil.formatNumber(String.valueOf(rowData.get("WMRE_QTY")),true,0,3)%><br/>
                    <font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("W_GR_DATE")))%></font>                      
                    </td> 
					<td title="단위/센터반출" ><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE")) %><br/>
					<font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("W_RIV_DATE")))%></font>
					</td>    			       
 					<td title="접수자/협력사입고" ><a  class="hyperLink"  href="javascript:recDetail(  '<%=CommonUtil.nvl(rowData.get("ADD_USER_NAME"))%>' , '<%=CommonUtil.nvl(rowData.get("WMRE_TYPE2_NAME"))%>' ,  '<%=CommonUtil.nvl(rowData.get("WMRE_TYPE3_NAME"))%>' ,'<%=CommonUtil.nvl(rowData.get("WMRE_TYPE_DETAIL"))%>'  )"><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME")) %></a> <br/>
   <%if(!"09".equals(CommonUtil.nvl(rowData.get("WMRE_TYPE")))&& !"".equals(CommonUtil.nvl(rowData.get("S_REC_DATE")))  ) {%>               	
                	<a  class="hyperLink"  href="javascript:manage_refund('<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE")) %>'  ,  '<%=CommonUtil.nvl(rowData.get("WMRE_TYPE")) %>'  , '<%=CommonUtil.nvl(rowData.get("WMRE_NO")) %>' , '<%=CommonUtil.nvl(rowData.get("ITEM_QTY")) %>' ,'<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_NM")) %>' ,'<%=CommonUtil.nvl(rowData.get("WMRE_TYPE_NAME")) %>' ,'<%=CommonUtil.nvl(rowData.get("FLAG")) %>' );" ><div style="background-color:#FFE08C"><font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("S_GR_DATE")))%></font>&nbsp </div></a>    


 <%}else{ %> 
 					<font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("S_GR_DATE")))%>&nbsp</font>
 <%} %>	  
 					</td>  		
 					<td title="진행상태/센터교환입고" >
 					<%=CommonUtil.nvl(rowData.get("FLAG_NAME"))%><br/>
 					<font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("W_CHGR_DATE")) )%></font>				
 					</td>
                    <td title="파일첨부/센터교환납품" >
                 <%if("".equals(CommonUtil.nvl(rowData.get("WMRE_FILE")))) {%>        
                    <img src="/resources/images/disk_off.gif"    border="0"> 
                 <% }else { %>   
                     <img src="/resources/images/disk_on.gif"  border="0"> 
                 <%} %>   
					<br/>
					<font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("W_CHDELI_DATE")))%></font>               
                    </td>   										                             			        
					<td title="협력사교환납품"  >
					&nbsp<br/>
					<%if("0".equals(CommonUtil.nvl(rowData.get("PROCESS_TYPE")))  &&"02".equals(CommonUtil.nvl(rowData.get("WMRE_TYPE"))) && !"".equals(CommonUtil.nvl(rowData.get("S_REC_DATE"))) ) {%>   
                    <a  class="hyperLink"  href="javascript:manage_refund('<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE")) %>'  ,  '<%=CommonUtil.nvl(rowData.get("WMRE_TYPE")) %>'  , '<%=CommonUtil.nvl(rowData.get("WMRE_NO")) %>' , '<%=CommonUtil.nvl(rowData.get("ITEM_QTY")) %>' ,'<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_NM")) %>' ,'<%=CommonUtil.nvl(rowData.get("WMRE_TYPE_NAME")) %>' ,'<%=CommonUtil.nvl(rowData.get("FLAG")) %>' );" ><div style="background-color:#FFE08C"><font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("S_CHDELI_DATE")) )%></font>&nbsp</div></a>                 
                    <%}else{ %>
                     <font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("S_CHDELI_DATE")) )%></font>
                      <%} %>
					</td>    
                    <td title="종결" >                       
                    &nbsp<br/>
					<font color="<%=fontColor%>"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("END_DATE")))%> 
                    </td>				
				</tr>
			
            <%}
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
		<div class="btnArea">
    
  			<span class="fr">
  				<span class="btn_02 mr04"><a href="javascript:doPop('save_refund');">등록</a></span>
  			</span>
         </div>

</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<% if(str_businessCond.equals("S")){ %>
	<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>  
<% }else{ %>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>  
<% }%>
</div>
</body>
<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
<%}%>
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		$("#st_buyer_code").val("");
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
		kepSearch(-1); 
		break;
	
		
	
	}
}

  
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/wmre/getMasterWmReReturnProgressStateList.do").submit();   
}

function buyerDetail(dept,name,tel){
	
	openSearchPopup('/wmre/showMasterWmBuyerPop.do', '?st_dept='+dept+'&st_name='+name+'&st_tel='+tel,'400,280,no');
	
}

function recDetail(user,type2,type3,detail){
	
	openSearchPopup('/wmre/showMasterWmAddUserPop.do', '?st_user='+user+'&st_type2='+type2+'&st_type3='+type3+'&st_detail='+detail  ,'400,400,no');
	
}

function manage_refund(PROCESS_TYPE, WMRE_TYPE,WMRE_NO, ITEM_QTY, PROCESS_TYPE_NM, WMRE_TYPE_NAME,FLAG ){
	
	openSearchPopup('/wmre/showMasterWmReReturnWmNoSellerPop.do','?st_PROCESS_TYPE='+PROCESS_TYPE+'&st_WMRE_TYPE='+WMRE_TYPE +'&st_WMRE_NO='+WMRE_NO+'&st_item_qty='+ITEM_QTY +'&st_PROCESS_TYPE_NM='+PROCESS_TYPE_NM+'&st_WMRE_TYPE_NAME='+WMRE_TYPE_NAME+'&st_flag='+FLAG,'850,610,no'); 
	
}

function manage_update(wmre_no,end_cancel ){
	
	openSearchPopup('/wmre/showMasterWmReReturnEntryPopForUpdateSeller.do', '?st_WMRE_NO='+wmre_no+'&st_warehouse_code='+'&st_end_cancel='+end_cancel ,'1000,590,no');
	
}

//팝업함수호출
function doPop(str,reason) {
	
	switch (str) {
	case "save_refund": 
		openSearchPopup('/wmre/showMasterWmReReturnEntrySellerPop.do', '?st_warehouse_code='+'&st_insert_yn=Y','1000,590,no');
        popupSel = "save_refund";
        break;
	case "buyer_single": // 고객사 M
		openSearchPopup('/wmdl/showMasterDlCommpyPop.do', '?BUSINESS_COND=B&MULTI=N&st_warehouse_code=','500,466,no');
        popupSel = "buyer_single";
        break;   
        

	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);
	
	}
	grbRow="";	//초기화
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

</script>

</html>
