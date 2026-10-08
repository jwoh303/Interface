<%--
**********************************************
* 메뉴 : 관리자>예산관리>예산부서
* 화면 : 예산부서
* 기능 : 고객사의 부서가 조회되고, 예산관리부서를 선택하여 저장할 수 있다.
* 프로그램 ID : PG_06_B_050_00
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
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	// 조회조건 E
	
   String SessionComCode        = "${sessionInfo.comCode}";
    String SessionUserId         = "${sessionInfo.userId}";
	String dept_name        = CommonUtil.nvl((String) request.getParameter("st_dept_name"),"");
    String dept_code        = CommonUtil.nvl((String) request.getParameter("st_dept_code"),"");
    String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
    
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
    <h3><%=CommonLang.get("HTITLE419") %><!-- 예산부서 --></h3>
    <div id="searchBtnA">
<%}else{%>
     <div id="searchBtnA" style="position:relative;  text-align:right; width:950px; height:32px; border: solid 0px; margin-top:5px; ">
     <h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px "><%=CommonLang.get("HTITLE419") %><!-- 예산부서 --></h3>
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
		<input type="hidden" name="com_code" id="com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" id="moveToMaster"  name="moveToMaster" value="<%=moveToMaster%>">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<colgroup>
					<col width="10%" />
					<col width="35%" />
					<col width="10%" />
					<col width="35%" />
				</colgroup>
				<tbody>
				 	<tr>
			<%if(!"Y".equals(moveToMaster) ){%>
				      <th><font color="red">*</font><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></th>
				      <td>
						<input type="text" class="input_type_text" name="st_dept_name" id="st_dept_name" style="width:65%;ime-mode:active" value="<%=dept_name%>" READONLY>
						<input type="hidden" name="st_dept_code" id="st_dept_code" value="<%=dept_code%>">
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
				      <th><font color="red">*</font><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></th>
				      <td>
						<input type="text" class="input_type_text" name="st_dept_name" id="st_dept_name" style="width:45%;ime-mode:active" value="<%=dept_name%>" READONLY>
						<input type="hidden" name="st_dept_code" id="st_dept_code" value="<%=dept_code%>">
						<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
			<%} %>    				 	
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
<%-- 		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> --%>
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="7%" />
	            <col width="43%" />
	            <col width="7%" />
	            <col width="43%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col"><%=CommonLang.get("HTITLE178") %><!-- 선택 -->
<!-- 					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">  -->
				</th>
				<th scope="col"><%=CommonLang.get("HTITLE420") %> / <%=CommonLang.get("HTITLE568") %><!-- 예산부서명 / 예산부서코드 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE178") %><!-- 선택 -->
<!-- 				<a href="javascript:checkAll()"><input type="text" name="check_status1" class="inputCheck" size="3" value="선택" READONLY ></a> -->
				</th>
				<th scope="col"><%=CommonLang.get("HTITLE420") %> / <%=CommonLang.get("HTITLE568") %><!-- 예산부서명 / 예산부서코드 --></th>
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
// 			for (int j=0; j<_gridList.size(); j++) {
			for(int j = 0; j < _gridList.size(); j=j+2){
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		%> 
						<tr align="center" bgcolor="<%=tclass%>"> 
							<td title="선택">
								<input type="checkbox" id="checkbox" name="checkbox" value=""  <%=(rowData.get("DEPT_CD_BUD").equals("Y")|| rowData.get("DEPT_CD").equals(dept_code))?"checked":""%>  id="check">
							</td>
							<td title="예산부서명">
								&nbsp;<%=rowData.get("DEPT_NM")%> &nbsp; / &nbsp; <%=rowData.get("DEPT_CD")%>
								<input type="hidden" name="st_bdgt_dept_code" value="<%=rowData.get("DEPT_CD")%>">				
							</td>
				<%
							if(j+1 < _gridList.size()){
								Map<String,String> rowData2 = _gridList.get(j+1);
				%>
								<td title="선택">
									<input type="checkbox" id="checkbox" name="checkbox"  value="" <%=(rowData2.get("DEPT_CD_BUD").equals("Y")|| rowData2.get("DEPT_CD").equals(dept_code))?"checked":""%> >
								</td>
								<td title="예산부서명">
									&nbsp;<%=rowData2.get("DEPT_NM")%> &nbsp; / &nbsp; <%=rowData2.get("DEPT_CD")%>
									<input type="hidden" name="st_bdgt_dept_code" value="<%=rowData2.get("DEPT_CD")%>">				
								</td>
				<%
							}else{
				%>
								<td title="예산부서명">&nbsp;</td>
								<td title="예산부서명">&nbsp;</td>
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
<%-- 			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> --%>
<!-- 		</p>   -->
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" name="db_buyer_code" id="db_buyer_code" value="">
	<input type="hidden" name="db_dept_code" id="db_dept_code" value="">
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

// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer", "${st_buyer}");	//고객사코드
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	initSearchCondition("searchForm", "st_dept_code", "${st_dept_code}");	//부서코드
	initSearchCondition("searchForm", "st_dept_name", "${st_dept_name}");	//부서코드
// 	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위

}

var st;
//기능함수
function doAction(str) {
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


	case "save": // 저장	
		var btnEvent = "save";
		var deptName = $("#st_dept_name").val();
		if(deptName == ''){
			//부서를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG304") %>");return;
		}
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			//선택한 부서를 예산부서로 저장 하시겠습니까?
			if(!confirm("<%=CommonLang.msg("MSG303") %>")){ 
				return;
			}
			$("#db_dept_code").val($("#st_dept_code").val());
			kepAjaxFormCall("/mdam/saveBuyerMdAmBudgetDepartmentList.do","processForm",btnEvent); 	
		}
		break;
	
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmBudgetDepartmentList.do").submit();   
}
  
// 팝업 함수호출
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
		openSearchPopup("/coco/showCommonCoCoBudgetDepartmentCodePop.do", "?open=Y&st_com_code="+comCode, "500,500,no");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(code);
		$("#st_buyer_name").val(text);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
		
	}else if (popupSel = "dept") {
		$("#st_dept_code").val(code);
		$("#st_dept_name").val(text);
		
// 		doAction('search');
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;

 	var chkGridValue = {};
 	var buyerCode = $("#st_buyer").val();
	if(buyerCode != null && buyerCode == ''){
		//고객사를 선택해 주십시오.
		alert("<%=CommonLang.msg("MSG1") %>");
		return;
	}else{
		$("#db_buyer_code").val(buyerCode);	
	}
	var deptCode = $("#st_dept_code").val();
	if(deptCode == ''){
		//부서를 선택해 주십시오.
		alert("<%=CommonLang.msg("MSG304") %>");return;
	}
	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("<%=CommonLang.msg("MSG13") %>");	//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
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
	 alert("<%=CommonLang.msg("MSG14") %>");	//처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요
 } 

</script>
</html>
