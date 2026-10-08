<%--
**********************************************
* 메뉴 : 관리자>예산관리>부서별계정
* 화면 : 부서별계정
* 기능 : 부서별로 사용 예산계정을 관리 할 수 있다.
* 프로그램 ID : PG_06_B_051_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
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
// 	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_dept_code = CommonUtil.nvl((String) request.getParameter("st_dept_code"),"");  // 요청부서코드
	String st_dept_name = CommonUtil.nvl((String) request.getParameter("st_dept_name"),"");  // 요청부서명
	// 조회조건 E
	String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
	
	int page_display_cnt = 0;
%> 

<body onload="kep_onload_view()">
<%if(!"Y".equals(moveToMaster) ){%>
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<%} %>

<%if(!"Y".equals(moveToMaster) ){%>
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<%} %>

<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<%if(!"Y".equals(moveToMaster) ){%>
	<div id="ContArea">
<%}else{%>
    <div id="ContArea2">
<%} %>    

<%if(!"Y".equals(moveToMaster) ){%>
    <h3><%=CommonLang.get("HTITLE421") %><!-- 예산부서별 계정 --></h3>
    <div id="searchBtnA">
<%}else{%>
     <div id="searchBtnA" style="position:relative;  text-align:right; width:950px; height:32px; border: solid 0px; margin-top:5px; ">
     <h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px "><%=CommonLang.get("HTITLE421") %><!-- 예산부서별 계정 --></h3>
<%} %>

	<!--버튼영역-->
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
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
		<input type="hidden" id="moveToMaster"  name="moveToMaster" value="<%=moveToMaster%>">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<colgroup>
					<col width="10%" />
					<col width="40%" />
					<col width="10%" />
					<col width="40%" />
				</colgroup>
				
				<tbody>
				<tr>
			<%if(!"Y".equals(moveToMaster) ){%>
					<th><font color="red">*</font><%=CommonLang.get("HTITLE420") %><!-- 예산부서명 --></th>
					<td>
						<input type="text" name="st_dept_name" id="st_dept_name" style="width:65%;ime-mode:active" value="" READONLY>
						<input type="hidden" name="st_dept_code" id="st_dept_code" value="<%=st_dept_code%>">
						<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
					<td></td>
					<td></td>					
			<%}else{%>
					<th><font color="red">*</font><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
					<td>
						<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:45%" value="" readonly onclick="javascript:doPop('icomcmpyPop');">
						<input type="hidden" name="st_buyer" id="st_buyer" style="width:80%" value="">
						<a href="javascript:doPop('icomcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
						<a href="javascript:kepEraser('st_buyer','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
					</td>
					<th><font color="red">*</font><%=CommonLang.get("HTITLE420") %><!-- 예산부서명 --></th>
					<td>
						<input type="text" name="st_dept_name" id="st_dept_name" style="width:65%;ime-mode:active" value="" READONLY>
						<input type="hidden" name="st_dept_code" id="st_dept_code" value="<%=st_dept_code%>">
						<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
			<%} %>  
							
					<td></td>
					<td></td>
					</tr>
				</tbody>
			</table>
		</div>
 		
<!--  		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/> -->
<!-- 	      	<label for="b_no02" class="hidden">정렬개수선택</label> -->
<!-- 			<select name="onepagerow"> -->
<%-- 				<option value = "5" <%if ("5".equals(onepagerow)) {%>selected<%} %>>5건</option> --%>
<%-- 				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option> --%>
<%-- 				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option> --%>
<%-- 				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>  --%>
<!-- 			</select> -->
<!--       	</span>       -->
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="7%" />
	            <col width="36%" />
	            <col width="7%" />
	            <col width="7%" />
	            <col width="36%" />
	            <col width="7%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
					<a href="javascript:checkAll1();" id="check_status1"   style="cursor: pointer; text-decoration: underline;"  ><%=CommonLang.get("HTITLE29") %></a><!-- 전체 -->
<!-- 					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')"> -->
				</th>
                <th scope="col"><%=CommonLang.get("HTITLE267") %><!-- 계정명 --> / <%=CommonLang.get("HTITLE386") %><!-- 계정코드 --></th>
                <th scope="col"  class="btnGubun"  style="cursor: pointer; text-decoration: underline;"  ><%=CommonLang.get("HTITLE314") %><!-- 구분 --></th>
				<th scope="col">
					<a href="javascript:checkAll2();" id="check_status2"  style="cursor: pointer; text-decoration: underline;" ><%=CommonLang.get("HTITLE29") %></a><!-- 전체 -->
<!-- 					<input type="checkbox" name="check_status2" id="check_status2" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status2,'document.forms.contentForm.checkbox2')"> -->
				</th>
                <th scope="col"><%=CommonLang.get("HTITLE267") %><!-- 계정명 --> / <%=CommonLang.get("HTITLE386") %><!-- 계정코드 --></th>
                <th scope="col"   class="btnGubun" style="cursor: pointer; text-decoration: underline;"><%=CommonLang.get("HTITLE314") %><!-- 구분 --></th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
                        <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
        	for(int j = 0; j < _gridList.size(); j=j+2){
        		++page_display_cnt;
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
						<td height="25" title="선택"> 
							<input type="checkbox" id="checkbox<%=j %>" name="checkbox"  value="" <%=("Y".equals(rowData.get("CHECK_YN")))?"checked":"" %> id="check">
						</td>
						<td title="계정명">
							&nbsp;<%=rowData.get("ACCOUNT_NAME")%> &nbsp; / &nbsp; <%=rowData.get("ACCOUNT_CODE")%>
							<input type="hidden" name="st_bdgt_account_code" value="<%=rowData.get("ACCOUNT_CODE")%>">				
						</td>
						<td  title="구분">
							<select name="st_flag" value="">
								<option value="Y" <% if(rowData.get("GUBUN").equals("Y")) out.println("selected"); %>><%=CommonLang.get("HTITLE692") %><!-- 전용 --></option>
								<option value="N" <% if(rowData.get("GUBUN").equals("N")) out.println("selected"); %>><%=CommonLang.get("HTITLE693") %><!-- 공통 --></option>
							</select>								
						</td>
			<%
				if(j+1 < _gridList.size()){
					++page_display_cnt;
					Map<String,String> rowData2 = _gridList.get(j+1);
			%>
							<td   title="선택">
								<input type="checkbox" id="checkbox<%=j+1 %>" name="checkbox"  value="" <%=("Y".equals(rowData2.get("CHECK_YN")))?"checked":"" %>>
							</td>
							<td title="계정명">
								&nbsp;<%=rowData2.get("ACCOUNT_NAME")%> &nbsp; / &nbsp; <%=rowData2.get("ACCOUNT_CODE")%>
								<input type="hidden" name="st_bdgt_account_code" value="<%=rowData2.get("ACCOUNT_CODE")%>">				
							</td>
							<td  title="구분">
								<select name="st_flag" value="">
									<option value="Y" <% if(rowData2.get("GUBUN").equals("Y")) out.println("selected"); %>><%=CommonLang.get("HTITLE692") %><!-- 전용 --></option>
									<option value="N" <% if(rowData2.get("GUBUN").equals("N")) out.println("selected"); %>><%=CommonLang.get("HTITLE693") %><!-- 공통 --></option>
								</select>								
							</td>
			<%
						}else{
			%>
							<td title="선택">&nbsp;</td>
							<td title="계정명">&nbsp;</td>
							<td title="구분"></td>
			<%
						}
			%>
					</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
<!-- 		<p id="paging" class="paging"> -->
<%-- 			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %>  --%>
<!-- 		</p>   -->
 		<input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=page_display_cnt%>">
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_02">
					<a href="javascript:doAction('BudgetAccountSave');"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" name="db_buyer_code" id="db_buyer_code" value="">
	<input type="hidden" name="db_dept_code" id="db_dept_code" value="">
	
<%-- 	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/> --%>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%if(!"Y".equals(moveToMaster) ){%>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
<%} %>
</body>

<script type="text/javascript">
var popupSel = "";
var btnEvent = "";

// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer", "${st_buyer}");	//고객사코드
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	initSearchCondition("searchForm", "st_dept_code", "${st_dept_code}");	//부서코드
	initSearchCondition("searchForm", "st_dept_name", "${st_dept_name}");	//부서명
	
// 	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
// 	initSearchCondition("searchForm", "curPage", "${curPage}");	//현재 페이지		
	
}

var st;
//기능함수
function doAction(str) {
	btnEvent = str;
	switch (str) {
	case "search":	 //조회
	 	var buyerName = $("#st_buyer_name").val();
		if(buyerName != null && buyerName == ''){
			//고객사를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG1") %>");return;
		}
	
		var deptName = $("#st_dept_name").val();
		if(deptName == ''){
			//부서를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG304") %>");return;
		}
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		$("#st_buyer").val("none");
		$("#st_buyer_name").val("");
		$("#st_dept_code").val("none");
		$("#st_dept_name").val("");
		
// 		kepSearch(-1);
		jspTableClean("table_list");
		
		break;

	case "BudgetAccountSave": // 저장	
		
		var deptName = $("#st_dept_name").val();
		if(deptName == ''){
			//부서를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG304") %>");return;
		}

		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			//선택한 계정을 저장 하시겠습니까?
			if(!confirm("<%=CommonLang.msg("MSG305") %>")){ 
				return;
			}
			$("#db_dept_code").val($("#st_dept_code").val());
			kepAjaxFormCall("/mdam/saveBuyerMdAmDepartmentAccountList.do","processForm",btnEvent); 	
		}
		break;
	}
}

// 구분 클릭시 체크박스에 따라 일괄 적용
$('.btnGubun').click(function() {
	var $rows = $("#table_list tbody tr");
	if($rows.length <= 1){
		alert("조회된 데이터가 없습니다.");
		return;
	}
	
	var $checkBox;
	var idx = $(this).index();
	if(idx === 2){
  		$checkBox = $("input[type=checkbox]:even");
  		idx = 0;
	}else{
		$checkBox = $("input[type=checkbox]:odd");
		idx = 1;
	}
	
	console.log('idx : '+idx);
	$checkBox.each(function() {
		var checked = $(this).prop("checked");
		if(checked){
			var $targetSelect =  $rows.eq(0).find('select').eq(idx);
			$(this).parent().parent().find('select').eq(idx).val( $targetSelect.val());
		}
	})
})

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmDepartmentAccountList.do").submit();   
}
  

//팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	popupSel = str;
	
	switch (str) {
	case "icomcmpyPop":
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
		break;
	case "dept": // 요청부서
		popupSel = "dept";
		var buyerCode = $("#st_buyer").val();
		var sessionCode = $("#st_com_code").val();
		var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
		openSearchPopup("/coco/showCommonCoCoBudgetDepartmentCodeDiffPop.do", "?open=Y&dept_type=B&st_com_code="+comCode, "500,500,no");
		break;
	}
}


// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
		
	}else if (popupSel = "dept") {
		$("#st_dept_code").val(value1);
		$("#st_dept_name").val(value2);
	}
// 	doAction('search');
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;

	var chkGridValue = {};
 	var buyerCode = $("#st_buyer").val();
	if(buyerCode != null && buyerCode == ''){
		//고객사를 선택해 주십시오.
		alert("<%=CommonLang.msg("MSG1") %>");return;
	}else{
		$("#db_buyer_code").val(buyerCode);	
	}

	if($("#st_dept_code").val() == ''){
		//부서를 선택하여 주십시오.
		alert("<%=CommonLang.msg("MSG304") %>");
		return;
	}
	
	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
// 	alert(formArr[0]);
// 	alert(formArr[1]);
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
		alert("<%=CommonLang.msg("MSG13") %>");
		returnValue = false;
	}

	return returnValue;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}


/**
 * ajax 공통 호출후 에러시 처리 함수
 */
 function  kepAjaxError(pMethod , response) {
	//처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요 
	alert("<%=CommonLang.msg("MSG14") %>");
 }

//전체선택/해제
function checkAll1(){
	var tot_cnt =$("#display_item_cnt").val(); 
	var check_status1 = $("#check_status1").html();
	
	if(check_status1 == "전체"){
		for(var j=0; j < tot_cnt; j+=2){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status1 = "해제";
			
			if(box.checked == false){
				box.checked = true;
			}
			
			$("#check_status1").html(check_status1);
		}
	}else{
		for(var j = 0; j < tot_cnt; j+=2){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status1 = "전체";
			
			if(box.checked == true){
				box.checked = false;
			}
			
			$("#check_status1").html(check_status1);
		}
	}
}

//전체선택/해제
function checkAll2(){
	var tot_cnt =$("#display_item_cnt").val(); 
	var check_status2 = $("#check_status2").html();

	if(check_status2 == "전체"){
		for(var j = 1; j < tot_cnt; j+=2){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status2 = "해제";

			if(box.checked == false){
				box.checked = true;
			}
			
			$("#check_status2").html(check_status2);
		}
	}else{
		for(var j = 1; j < tot_cnt; j+=2){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status2 = "전체";

			if(box.checked == true){
				box.checked = false;
			}
			
			$("#check_status2").html(check_status2);
		}
	}
}
</script>
</html>