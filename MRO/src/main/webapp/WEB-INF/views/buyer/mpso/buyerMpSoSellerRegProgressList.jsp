<%--
**********************************************
* 메뉴 : 주문관리>판매인등록증신청
* 화면 :판매인등록증신청
* 기능 : 주문한 판매인등록증신청
* 담당자 : 현명환
* 착수일 :2016-03-21
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf" %>
<script src="/resources/js/kep_buyer.js"></script>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지 (필수) 
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");	
	String budget_flag		  = sessionInfo.getBudgetFlag();
	String comType = (String)_sessionInfo.getBusinessCond();
	String fromDate = "";
	String toDate	= "";
	String sortType = CommonUtil.nvl(request.getParameter("st_sortType"),"DESC");
	if (sortType == null || "".equals(sortType)){
		sortType = "DESC";
	}
	fromDate		= CommonUtil.nvl((String) request.getParameter("fromDate"),"");
	if( fromDate.equals("")){
		toDate	 =  CommonUtil.formatDateNoDateGubun(new Date(),1);
		fromDate	= CommonUtil.addDate(new Date(),"M",-1,1);
	}else{
		toDate	= CommonUtil.nvl((String) request.getParameter("toDate"),"");
	}	
	fromDate = fromDate.replace("/", "");
	toDate = toDate.replace("/", "");  
	String from_year  = fromDate.substring(0,4);
	String from_month = fromDate.substring(4,6);
	String from_day	= fromDate.substring(6,8);
	String v_fromDate  = from_year+"/"+from_month+"/"+from_day;
	String to_year  = toDate.substring(0,4);
	String to_month = toDate.substring(4,6);
	String to_day	= toDate.substring(6,8);
	String v_toDate  = to_year+"/"+to_month+"/"+to_day;
	String SessionComCode		= sessionInfo.getComCode();
	String SessionUserId		 = sessionInfo.getUserId();
	String row_cnt = sessionInfo.getRowCnt();
	String userType         = CommonUtil.nvl((String)sessionInfo.getUserType());
	String img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
	String pr_no		 = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"ALL"); 
	String legacy_po_no = CommonUtil.nvl((String) request.getParameter("st_legacy_po_no"),"ALL");
	String ref_no		= CommonUtil.nvl((String) request.getParameter("st_ref_no"),"ALL"); 
	String search_type  = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");
	String st_use_status  = CommonUtil.nvl((String) request.getParameter("st_use_status"),"");
	
	String search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),"");
	if(search_no.equals(""))
	{
	  search_type = "BC";
	  search_no = "ALL";
	}
	// 진행상태
	String status		= CommonUtil.nvl((String) request.getParameter("st_status"),"ALL");
 //파트유닛
	String unitPart		= CommonUtil.nvl((String) request.getParameter("st_unit_part"),"ALL");
	// HTML 리스트 조회시 공통사용
	String pg_row			 = CommonUtil.nvl((String) request.getParameter("st_pg_row"),""); 
	String st_check		  = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH"); 
 
	String tot_cnt_string = "";
	int tot_cnt = 0;									//전체데이타row수
	int rec_cnt = 0;
 
	// HTML 리스트 조회시 공통사용
	//1개월
	String fromDate1 = "";
	String toDate1	= "";
	toDate1	 =  CommonUtil.formatDateNoDateGubun(new Date(),1);
	fromDate1	=	CommonUtil.addDate(new Date(),"M",-1,1);
	String from_year1  = fromDate1.substring(0,4);
	String from_month1 = fromDate1.substring(4,6);
	String from_day1	= fromDate1.substring(6,8);
	String v_fromDate1  = from_year1+"/"+from_month1+"/"+from_day1;
	String to_year1  = toDate1.substring(0,4);
	String to_month1 = toDate1.substring(4,6);
	String to_day1	= toDate1.substring(6,8);
	String v_toDate1  = to_year1+"/"+to_month1+"/"+to_day1; 
	
	String buyer = sessionInfo.getComCode();
	String userid = sessionInfo.getUserId();	
	 if ("".equals(curPage)){ 
		 v_fromDate = v_fromDate1;
		 v_toDate = v_toDate1;

	 } 
	
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수 
	//화면타이틀
	String menuTitle = "";
	Map<String, String>menuTitleInfo = CommonUtil.getIcomCode2ReturnMap(SessionComCode,"M018","C001"); 
    if (menuTitleInfo != null){
    	menuTitle= CommonUtil.nvl(menuTitleInfo.get("TEXT3"),"");
    }     
	
%> 
<body onLoad="kep_onload_view()">
	<div id="wrapper"> 
	<!-- 메뉴 S --> 
<%if(comType.equals("S")){%>
	<c:import charEncoding="utf-8" url="/menu/menu.do" >
	<c:param name="page" value="sellerHeader"/>
	<c:param name="part" value="header"/>
	</c:import>
	
	<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="sellerLeft"/>
	<c:param name="part" value="${param.upperId}"/>
	</c:import>
<%}else{ %>
	<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>  
	
	<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerLeft"/>
	<c:param name="part" value="${param.upperId}"/>
	</c:import>
	<!-- 메뉴 E -->
<%}%>
	<!--내용 시작-->
	<div id="container2">
	<div id="ContArea">
		<h3><%=menuTitle %>내역</h3>
		<!--버튼영역-->
		 <div id="searchBtnA">
		 	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
			<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
		 </div>
		<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">		
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<!-- 화면 내 정의 -->
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	
			<input type="hidden" name="st_buyer"	value ="<%=buyer%>"> 
			<input type="hidden" name="st_userid"	value ="<%=userid%>"> 
			<input type="hidden" name="st_check"	value ="<%=st_check%>"> 
			<input type="hidden" name="page_type"  value ="">
			<input type="hidden" name="st_fromDate" value="<%=fromDate%>">
			<input type="hidden" name="st_toDate"  value="<%=toDate%>">
			<input type="hidden" name="SessionComCode"  value="<%=SessionComCode%>">
			<input type="hidden" name="SessionUserId"  value="<%=SessionUserId%>">
			<input type="hidden" name="st_sortType"	 value="<%=sortType%>">
			<input type="hidden" name="st_user_type"	 value="<%=userType%>">
			
			<input type="hidden" name="st_ref_no" />
			<input type="hidden" name="st_status" value="ALL"/>

			<input type="hidden" name="currentDate" size="10" maxlength="10" value="<%= toDate %>">
			<input type="hidden" name="ToDateTemp" size="10" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>">
			<input type="hidden" name="userID" value="<%=SessionUserId%>">
			<input type="hidden" name="userDept" value="${sessionInfo.department }">
			<input type="hidden" name="st_add_user_tel" value="${sessionInfo.tel }">
			<input type="hidden" name="st_sum_price" value="" />
			
			<div id="cont_searchA" >
				<table class="cont_t_list01">
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
						<th>요청일</th>
						<td colspan="3">
							<input type="text" class="input_type_text" name="fromDate" id="fromDate" readOnly style="width:15%;text-align:center;" value="<%=v_fromDate%>"> - 
							<input type="text" class="input_type_text" name="toDate" id="toDate" readOnly style="width:15%;text-align:center;" value="<%=v_toDate%>"> 
							<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','1')">1개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','3')">3개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','6')">6개월</a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('fromDate','toDate')">당월</a></span>	
						</td>
					</tr>
					<tr>
						<th>
							<select name = "st_search_type" class="TitSelect">
								<option <%=(search_type.equals("BC")? "selected" : "")%> value = "BC">품목코드</option>
								<option <%=(search_type.equals("DE")? "selected" : "")%> value = "DE">품목명</option>
								<option <%=(search_type.equals("SP")? "selected" : "")%> value = "SP">규격</option>
							</select>
						</th>
						<td>
							<input type="text" class="input_type_text" name="st_search_no" style="width:87%" value = "<%=(search_no.equals("ALL") ? "" : search_no)%>" onKeyDown="kepEnter()" />
							<input type="hidden" name="st_unit_part" value ="ALL">
<!-- 							<input type="hidden" name="st_unit_part" value ="ST_USER_ID"> -->
						</td>
						<th>진행상태</th>
						<td>
							<select name="st_use_status" id="st_use_status"  style="width: 90%; height: 20px;">
											<option value="" <%if ("".equals(st_use_status)) {%> selected <%} %>>전체</option>
											<option value="O" <%if ("O".equals(st_use_status)) {%> selected <%} %>>요청</option>
											<option value="R" <%if ("R".equals(st_use_status)) {%> selected <%} %>>접수</option>
							</select>
						</td>
					</tbody>
				</table>
			</div>
			<span class="fl">
				<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" onChange="javascript:kepSearch(1);">
					<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
					<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
					<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
					<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
					<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
				</select>
			</span>
			<span class="fr">(기준 : 원) </span>
			<br>
		</form> 
		<form name = "contentForm" id="contentForm" method = "post">
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" name="st_po_create_date" size="10" value="<%=toDate%>">
			<input type="hidden" name="st_update" id="st_update" value=""/>
			<table id="table_list" class="cont_t_list02" style="width:100%">
				<colgroup>
					<col width="3%" />
					<col width="5%" />
					<col width="8%" />
					<col width="8%" />
					<col width="10%" />
					<col width="20%" />
					<col width="*" />
					<col width="10%" />
					<col width="5%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" >선택</th>
						<th scope="col" >상태</th>
						<th scope="col">요청일</th>
						<th scope="col">접수일</th>						
						<th scope="col">품목코드</th>
						<th scope="col" >품목명</th>
						<th scope="col" >규격</th>
						<th scope="col" >대상자</th>
						<th scope="col" >첨부파일</th>
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
		for (int j=0; j<_gridList.size(); j++) {
		Map<String,String> rowData = _gridList.get(j);
		String tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		
	%> 
	 
					<tr align="center" bgcolor="<%=tclass%>">
	                    <td>
							<input type="checkbox" class="input_noline" name="lnCheck<%=j%>" >	 
						</td>
						<td class="center" title="상태">
							<input type="hidden" id="st_buyer_item_no" name="st_buyer_item_no"  value="<%=rowData.get("BUYER_ITEM_NO")%>"/>
							<input type="hidden" id="st_buyer" name="st_buyer"  value="<%=rowData.get("BUYER")%>"/>
							<input type="hidden" id="st_contract_no" name="st_contract_no"  value="<%=rowData.get("CONTRACT_NO")%>"/>
							<input type="hidden" id="st_contract_seq" name="st_contract_seq"  value="<%=rowData.get("CONTRACT_SEQ")%>"/>
							<input type="hidden" id="st_byit_comorg_code" name="st_byit_comorg_code"  value="<%=rowData.get("BELOW_COMORG_CODE")%>"/>
							<input type="hidden" id="st_use_flag" name="st_use_flag"  value="<%=rowData.get("USE_FLAG")%>"/>
							<input type="hidden" id="st_seq" name="st_seq"  value="<%=rowData.get("SEQ")%>"/>
							<input type="hidden" id="st_coway_cart_id" name="st_coway_cart_id"  value="<%=rowData.get("USER_ID")%>"/>
							<input type="hidden" id="st_mg_note" name="st_mg_note"  value="<%=rowData.get("MG_NOTE")%>"/>
							
							<%=rowData.get("USE_FLAG")%>
						</td>
						<td class="center" title="요청일">
							<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%>
						</td>
						<td class="center" title="접수일">
							<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%>
						</td>
						<td title="품목코드" class="left">
							<%=rowData.get("BUYER_ITEM_NO")%>
						</td>
						<td title="품목명" class="left">
							<%=rowData.get("DESCRIPTION")%>
						</td>
						<td title="규격" class="left">
							<%=rowData.get("SPECIFICATION")%>
						</td>
						<td title="요청자" class="center">
							<input type='text' name='req_user_name' id='req_user_name' size="13" value="<%=rowData.get("REQ_USER_NM")%>" style="text-align:left" readOnly/>&nbsp;
									<a href="javascript:doPop('reqUserInfo', '<%=CommonUtil.nvl(rowData.get("MG_NOTE"))%>')">
								<img src="/resources/images/but_query.gif" width="19" height="19">
							</a>
						</td>
						<td title="첨부파일">
								<%
                                     if(!rowData.get("IMAGE_KEY").equals("")) {
                                 %> <a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')"><img
							name="st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a> <%
                                     }else {
                                 %> <img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0"> <%
                                     }
                                 %>
						</td>
					</tr>
	<%
		}//end for
	}//end if
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
			<div class="btnArea ac" style="margin-bottom:0px; margin-top: 5px;">
<%if(comType.equals("S")){%>
				<span class="fr btn_02">
					<a href="javascript:doAction('rcpt');">접수</a>
				</span>
<%}else{%>				
				<span class="fr btn_02">
					<a href="javascript:doAction('del');">취소</a>
				</span>
<%}%>
			</div>
		</form>
		<form name="processForm" id="processForm" method="post">
			<input type="hidden" name="st_update" id="st_update" value=""/>
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		</form>
	</div>
	</div>
<%if(comType.equals("S")){%>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
<%}else{ %>
	<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
<%}%>
	</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
 
	kepSetCalender("fromDate");
	kepSetCalender("toDate"); 
}
/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	
	var chk_cnt = 0;
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
	return chk_cnt;
}
var st;
//기능함수
function doAction(str, row) {
	switch (str) {
	case "search":	 //조회
		document.forms.searchForm.curPage.value = 1; 

		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		// 조회일 초기 셋팅
		kepSetCalender("fromDate");
		kepSetCalender("toDate");
		$("#fromDate").val( kepToMonthAdd("1","M"));
		$("#toDate").val( kepGetNowTimeStr('YYYYMMDD','/'));

		document.forms.searchForm.st_pr_no.value = "";
		document.forms.searchForm.st_ref_no.value = "";
		document.forms.searchForm.st_search_type.value = "BC";
		document.forms.searchForm.st_search_no.value = "";
		
		jspTableClean("table_list");
		break;
	case "del": // 취소
		var tot_cnt = $("#display_item_cnt").val();		
		var query	= "";
		var chk_cnt = 0;
		chk_cnt = getCheckedRowCount(tot_cnt);
	    if(chk_cnt == "0"){
	        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
	        return;
	    }else{
			if(eval(tot_cnt) < 2){
	            var box = eval("document.forms.contentForm.lnCheck0" ); 
	            if(box.checked == true){
					var st_coway_cart_id	= document.forms.contentForm.st_coway_cart_id.value;
					var st_contract_no = document.forms.contentForm.st_contract_no.value;
					var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
					var st_seq = document.contentForm.st_seq.value;
					var st_mg_note = document.contentForm.st_mg_note.value;
					query = st_coway_cart_id + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_seq+ "@@" +"D"+"@@"+st_mg_note + "&&";
	            }
			} else {
	            for(var i = 0; i <tot_cnt; i++){
	            	var box = eval("document.forms.contentForm.lnCheck" + i);
	            	if(box.checked == true){	
						var st_coway_cart_id	= document.forms.contentForm.st_coway_cart_id[i].value;
						var st_contract_no = document.forms.contentForm.st_contract_no[i].value;
						var st_contract_seq = document.forms.contentForm.st_contract_seq[i].value;
						var st_seq = document.contentForm.st_seq[i].value;			
						var st_mg_note = document.contentForm.st_mg_note[i].value;
						query += st_coway_cart_id + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_seq+ "@@" +"D" +"@@"+st_mg_note + "&&";
	            	}
	            }
			}
	    }
		if(!confirm("삭제 하시겠습니까?")){ 
			return;
		} 
		document.forms.processForm.st_update.value = query; 
		kepAjaxFormCall("/mpso/saveBuyerMpSoSellerRegProgressList.do","processForm","regOrder");
		break;
	case "rcpt": //접수
		var tot_cnt = $("#display_item_cnt").val(); 
		var query	= "";
		var chk_cnt = 0;
		chk_cnt = getCheckedRowCount(tot_cnt);
	    if(chk_cnt == "0"){
	        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
	        return;
	    }else{
			if(eval(tot_cnt) < 2){
	            var box = eval("document.forms.contentForm.lnCheck0" ); 
	            if(box.checked == true){
					var st_coway_cart_id	= document.forms.contentForm.st_coway_cart_id.value;
					var st_contract_no = document.forms.contentForm.st_contract_no.value;
					var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
					var st_seq = document.contentForm.st_seq.value;
					var st_mg_note = document.contentForm.st_mg_note.value;
					var st_use_flag = document.contentForm.st_use_flag.value;
					if(st_use_flag == "접수"){
						alert("접수처리가 된건은 처리가 불가능합니다.");
						return;
					}
					query = st_coway_cart_id + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_seq+ "@@" +"R"+"@@"+st_mg_note + "&&";
	            }
			} else {
	            for(var i = 0; i <tot_cnt; i++){
	            	var box = eval("document.forms.contentForm.lnCheck" + i);
	            	if(box.checked == true){	
						var st_coway_cart_id	= document.forms.contentForm.st_coway_cart_id[i].value;
						var st_contract_no = document.forms.contentForm.st_contract_no[i].value;
						var st_contract_seq = document.forms.contentForm.st_contract_seq[i].value;
						var st_seq = document.contentForm.st_seq[i].value;
						var st_mg_note = document.contentForm.st_mg_note[i].value;
						var st_use_flag = document.contentForm.st_use_flag[i].value;
						if(st_use_flag == "접수"){
							alert("접수처리가 된건은 처리가 불가능합니다.");
							return;
						}						
						query += st_coway_cart_id + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_seq+ "@@" +"R" +"@@"+st_mg_note + "&&";
	            	}
	            }
			}
	    }
		if(!confirm("접수 하시겠습니까?")){ 
			return;
		} 
		document.forms.processForm.st_update.value = query; 
		kepAjaxFormCall("/mpso/saveBuyerMpSoSellerRegProgressList.do","processForm","rcptOrder");
		break;
	}
}

// 조회
function kepSearch(curPage){

	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return;
	if (kepGetDateDiff('fromDate','toDate','D') > 184 ){
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoSellerRegProgressList.do").submit();
}

function kepAjaxSuccess(pMethod , response){
		alert("처리가 되었습니다.");
 		kepSearch($("#curPage").val());
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("시스템 오류입니다. 관리자에게 문의하시기 바랍니다.");
} 
//팝업함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	
	switch (str) {
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	case "reqUserInfo"://대상자정보
		popupSel = "reqUserInfo";
		openSearchPopup('/mpso/getBuyerMpSoSellerInfoPop.do','?st_req_user_id='+value1,'500,430,yes');// 파일첨부 
		break;
	}
}
</script>
</html>
