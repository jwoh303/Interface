<%--
**********************************************
* 메뉴 : 결재
* 화면 : 결재대상조회
* 기능 : 결재대상조회(다수 사용자 결재 몰아서 보기)
* 프로그램 ID : 
* 담당자 : HSJ  
* 착수일 : 2024-08-21
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="page" uri="/WEB-INF/tld"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<%
@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	String _CRUD =  CommonUtil.nvl((String)request.getAttribute("CRUD")); // 조회된결과	
	String total_cnt = CommonUtil.nvl((String)request.getAttribute("total_cnt"),"0"); // 조회된결과
	
	if (_dataList == null || _dataList.size() == 0) {
		total_cnt = "0";
	}
	
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"10")); // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),"1"); // 조회조건
	String st_gubun = CommonUtil.nvl((String) request.getParameter("st_gubun"),""); // 조회조건
	String st_appr_gbn = CommonUtil.nvl((String) request.getParameter("st_appr_gbn"),""); // 조회조건 결재상신조건
	if(!st_appr_gbn.equals("")){
		st_gubun =st_appr_gbn;
	}
	String st_subject = CommonUtil.nvl((String) request.getParameter("st_subject"),""); // 조회조건
	String st_po_user_id = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); // 조회조건
	String st_po_user_dept = CommonUtil.nvl((String) request.getParameter("st_po_user_dept"),""); // 조회조건
	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),""); // 조회조건
	String endDate = CommonUtil.nvl((String) request.getParameter("endDate"),""); // 조회조건
	String st_appr_yn = CommonUtil.nvl((String) request.getParameter("st_appr_yn"),"Y"); // 조회조건
	String st_buyer_list = CommonUtil.nvl((String) request.getParameter("st_buyer_list"),""); // 조회조건
	
	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	String session_st_gw_no = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gw_no"),""); // 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴
	String mailOpen = CommonUtil.nvl((String) request.getParameter("mailOpen"),""); // 조회조건 메일	 결재바로보기에서 왔을경우에만  결재대상조회 
	String userGwNoFlag = CommonUtil.nvl((String) request.getParameter("userGwNoFlag"),""); // 조회조건 메일	 결재바로보기에서 왔을경우에만  결재대상조회 
	
	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
	} 
	
	Map<String, String> _map = new HashMap<String, String>();
%>  
<body onload="kepOnload()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!--내용 시작-->
<div id="container2">
	<div id="ContArea">
		<!--버튼영역-->
		<h3><%=CommonLang.get("HTITLE295") %><!-- 결재대상조회 --></h3>
		<div id="searchBtnA">
			<span class="btn_search" title="조회"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
			<span class="btn_reset" title="초기화"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
		</div>
		
		<!--조회영역-->
		<form name = "searchForm"  id="searchForm" method = "post">
			<input type="hidden" id="BUYER"  name="BUYER" value="<%=buyer%>">
			<input type="hidden" id="USERID"  name="USERID" value="<%=userid%>">
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
            <input type="hidden" id="st_status"  name="st_status" value="<%=st_status%>">
			<input type="hidden" name="st_appr_yn"  id="st_appr_yn" value="<%=st_appr_yn%>">
            
            <div id="cont_searchA">
				<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />

				<table class="cont_t_list01" >
					<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
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
							<th><%=CommonLang.get("HTITLE298") %><!-- 기안일 --></th>
							<td colspan="5">
								<input type="text" id="startDate"  class="input_type_text" name="startDate" value="<%=startDate%>"  style="width:10%; text-align:center;" >
								-
								<input type="text" id="endDate" class="input_type_text"  name="endDate" value="<%=endDate%>"  style="width:10%; text-align:center;" >
								<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:setCurMonth('startDate','endDate')">당월</a></span>
                            </td>
						</tr>
                      
                      	<tr>
							<th><%=CommonLang.get("HTITLE299") %><!-- 결재구분 --></th>
							<td>
								<select name = "st_gubun" style="width: 90%">
								<%
									_map.put("TEXT5", "B"); // 고객사
                             	%>
                             	<%= CommonUtil.getCodeComboQueryIdList("common.getApprCodeList","ALL",_map,st_gubun) %>
					            </select>
                            </td>
                            <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
                            <td>
                            	<select name = "st_buyer_list" style="width: 90%">
                            	<%
                            		_map.put("CODE2",_sessionInfo.getUserId()); // 로그인 ID로 세팅된 고객사 목록(ICOMCOD3.TYPE=M-APPR)
                            	%>
                            	<%=CommonUtil.getCodeComboQueryIdList("common.getMultiApprComNameList","ALL",_map,st_buyer_list)%>
                            	</select>
                            </td>
                       </tr>
                       
                       <tr>
                       		<th><%=CommonLang.get("HTITLE313") %><!-- 기안제목 --></th>
							<td>
								<input type="text" name="st_subject"  class="input_type_text" style="width:87%;ime-mode:active" value="<%=(st_subject.equals("ALL") ? "" : st_subject)%>"  onKeyDown="kepEnter()">
							</td>
							<th><%=CommonLang.get("HTITLE302") %><!-- 기안자 --></th>
							<td>
								<input type="hidden" name="st_po_user_id"  id="st_po_user_id" value="">
								<input type="text" name="st_drafter"  id="st_drafter" value=""class="input_type_text" style="width:87%;ime-mode:active" onKeyDown="kepEnter()">
							</td>
							<th colspan="2">
								<input type="checkbox"  class="Noborder" name="st_checkbox_appr" id="st_checkbox_appr"  <%=st_appr_yn.equals("Y")?"checked":"" %>>&nbsp;<%=CommonLang.get("HTITLE682") %><!-- 결재대상 조회 -->
							</th>
						</tr>
					</tbody>
				</table>
			</div>

			<div>
				<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
					<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow"  id="onepagerow" onchange="kepSearch(1);">
						<option value="10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
						<option value="20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
						<option value="30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
						<option value="40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
						<option value="50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					</select>
				</span>
    		</div>
		</form>
		
		<br>

		<form name = "contentForm" id="contentForm" method = "post">
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<table id="table_list" class="cont_t_list02">
				<caption><%=CommonLang.get("HTITLE683") %><!-- 리스트 --></caption>
					<colgroup>
						<col width="3%" />
						<col width="7%" />
						<col width="15%" />
						<col width="15%" />
						<col width="7%" />
						<col width="7%" />
						<col width="*" />
						<col width="7%" />
						<col width="7%" />
					</colgroup>
					
					<thead>
						<tr>
							<th scope="col">
<%
if (_dataList == null || _dataList.size() == 0){
} else {
%>
								<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');">
<%
}
%>
							</th>
                            <th scope="col"><%=CommonLang.get("HTITLE299") %><!-- 결재구분 --> </th>
                            <th scope="col"><%=CommonLang.get("HTITLE604") %><!-- 고객사 --> </th>
                            <th scope="col"><%=CommonLang.get("HTITLE307") %><!-- 기안(요청)부서 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE302") %><!-- 기안자 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE303") %><!-- 기안일시 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE304") %><!-- 제목 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE305") %><!-- 현재결재자 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE306") %><!-- 유형 --></th>
						</tr>
                    </thead>
                    
                    <tbody>
<%
if (_dataList == null){
%>
		                <tr bgcolor="#FFFFFF">
				            <td colspan="9" align="center" height = "50">
				            <span><%=CommonLang.msg("MSG558") %><!-- 조회 조건을 확인 후 조회 버튼을 클릭하여 주시기 바랍니다. --></span>
				            </td>
		           		</tr>
<%
}else if (_dataList.size() == 0){
%>
						<tr bgcolor="#FFFFFF">
				            <td colspan="9" align="center" height = "50">
				            <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
				            </td>
		           		</tr>
<%
}else{
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> rowData = _dataList.get(j);
%>
                    	<tr>
							<td>
								<input type="checkbox" name="lnCheck<%=j%>" value="<%=CommonUtil.nvl( rowData.get("COMPANY")) %>@@<%= CommonUtil.nvl( rowData.get("DOCU_NO"))%>">
							</td>
                    		<td title="결재구분">
                    			<%=CommonUtil.nvl( rowData.get("EXTIF_TP_TEXT"))%>
                    		</td>
                    		<td title="고객사">
                    			<%=CommonUtil.nvl( rowData.get("COMPANY_NAME"))%>
                    		</td>
                    		<td title="요청부서">
                    			<%=CommonUtil.nvl( rowData.get("ORDER_DEPT"))%>
                    		</td>
                    		<td title="기안자">
                    			<%=CommonUtil.nvl( rowData.get("ADD_USER_ID"))%>
                    		</td>
                    		<td title="기안일시">
                    			<%=CommonUtil.nvl( rowData.get("START_DATE"))%>
                    		</td>
                    		<td title="제목" class="left">
	                    		<a class="hyperLink"  href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%= CommonUtil.nvl( rowData.get("COMPANY"))%>&DOCU_NO=<%=CommonUtil.nvl( rowData.get("DOCU_NO")) %>&PASS_TP=<%=CommonUtil.nvl( rowData.get("PASS_TP")) %>&FLAG=RECV' ,'1200,700,no')">
									<%=CommonUtil.nvl( rowData.get("DOCU_TITLE"))%>
	                       		</a>
                       		</td>
	                    	<td title="현재결재자">
	                    		<%=CommonUtil.nvl( rowData.get("NEXT_USER_NM"))%>
	                    		<input type="hidden" name="st_next_user_id" id="st_next_user_id"  value="<%=CommonUtil.nvl( rowData.get("NEXT_USER_ID"))%>"/>
	                    		<input type="hidden" name="st_next_user_name" id="st_next_user_name"  value="<%=CommonUtil.nvl( rowData.get("NEXT_USER_NM"))%>"/>
	                    	</td>
	                    	<td title="유형">
	                    		<a class="hyperLink"  href="javascript:openSearchPopup('/common/popup/approval/buyerCommonPassStatusPop.do','?COMPANY=<%= CommonUtil.nvl( rowData.get("COMPANY"))%>&DOCU_NO=<%=CommonUtil.nvl( rowData.get("DOCU_NO")) %>' ,'800,400,no')">
	                    			<%=CommonUtil.nvl( rowData.get("GUBUN"))%>
	                    		</a>
	                    	</td>
                    	</tr>
<%
	}
}
%>
             		</tbody>
				</table>
<% if (_dataList != null && _dataList.size() > 0){ %>
		<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<% } %>
		</form>
		
		<form name="processForm" id="processForm">
			<input type=hidden name="PASS_KN" id="PASS_KN">
			<input type=hidden name="PASS_ADD" id="PASS_ADD">
			<input type=hidden name="DOCU_CONT" id="DOCU_CONT">
			<input type=hidden name="APPROVAL_TEXT" id="APPROVAL_TEXT">
		</form>

		<!--페이징-->
		<p id="paging" class="paging">
		<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %>
			<span class="cl">
				<%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] -->
			</span>
		</p>

		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_02 mr04" title="일괄결재" ><a href="javascript:doAction('allprocess1');"><%=CommonLang.get("HTITLE296") %><!-- 일괄결재 --></a></span>
				<span class="btn_02 mr04" title="일괄반려" ><a href="javascript:doAction('allprocess3');"><%=CommonLang.get("HTITLE297") %><!-- 일괄반려 --></a></span>
			</div>
		</div>
	</div>
	
	<div class="fl">
		※ <%=CommonLang.get("HTITLE684") %><!-- 제목 클릭시 결재 화면으로 이동                       ※ 유형 클릭시 결재현황 팝업 조회 -->
		<br>
		※ <%=CommonLang.get("HTITLE685") %><!-- 현재결재자(결재요망): 본인 결재 순서             ※ 결재구분(구매요청/구매발주) 경우만 일괄결재 가능 -->
	</div>
</div>

<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
  
</div>
</div>
</body> 
<script type="text/javascript">
var PASS_KN = "";
var st;

//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;

	case "allprocess1":	 //일괄결재
		allprocess(1);
		break;

	case "allprocess3":	 //일괄반려
		allprocess(3);
		break;
	}
}

function allprocess(value){
    var tot_cnt  = $("#display_item_cnt").val();
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//목록에 표시된 대상이 없습니다.
        alert(" <%=CommonLang.msg("MSG16") %> ");
        return;
    }

    var chk_cnt = getCheckedRowCount(tot_cnt);
    if(chk_cnt == "0"){
    	//하나 이상의 대상이 선택되어야 합니다.
        alert(" <%=CommonLang.msg("MSG17") %>  ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" );
            if(box.checked == true){
            	var st_next_user_name =document.forms.contentForm.st_next_user_name.value;
            	if(st_next_user_name != "결재요망"){
            		//선택하신 결재건은 현재 결재자가 아니므로 처리 불가능합니다
            		alert("<%=CommonLang.msg("MSG387") %>");
            		return;
            	}
            }
        }else{
        	for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                if(box.checked == true){
                	var st_next_user_name =document.forms.contentForm.st_next_user_name[i].value;
                	if(st_next_user_name != "결재요망"){
                		//번째 결재건은 현재 결재자가 아니므로 처리 불가능합니다
                		alert(i+1+"<%=CommonLang.msg("MSG388") %>");
                		return;
                	}
                }
            }
        }
    }
    
    $("#PASS_KN").val(value);  
	// 사유입력
    openSearchPopup('/mppo/showBuyerMpPoApprovalReasonPop.do','?openYn=Y&st_pass_kn='+value , '500,280,no');		 
}

function setReason(value){
	$("#PASS_ADD").val(value); //  사유 

    allbizprocess();
}

function allbizprocess(){
    var tot_cnt  = $("#display_item_cnt").val();
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//목록에 표시된 상품이 없습니다.
        alert(" <%=CommonLang.msg("MSG16") %>     ");
        return;
    }

    var chk_cnt = getCheckedRowCount(tot_cnt);
    var query = "";
    if(chk_cnt == "0"){
    	//하나 이상의 상품이 선택되어야 합니다.
        alert(" <%=CommonLang.msg("MSG17") %>   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" );
            if(box.checked == true){
            	var key          = box.value;
            	query += key + "&&";
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                if(box.checked == true){
                	var key          = box.value;
                	query += key + "&&";
                }
            }
        }
    }	 
    
    $("#APPROVAL_TEXT").val(query); //  사유
	
	kepAjaxFormCall("/common/approval/AllCommonApproval.do","processForm","ALLSAVE");
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

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){	
	var text = "";
    if ($("#PASS_KN").val() == 1 ){
    	text = "<%=CommonLang.get("HTITLE310") %>";		//결재
    }else{
    	text = "<%=CommonLang.get("HTITLE238") %>";		//반려
    }
    alert("<%=CommonLang.msg("MSG260") %> "+text+" <%=CommonLang.msg("MSG391") %>");	//정상적으로 처리되었습니다. 
   	 // 처리후 재조회
   	 kepSearch($("#curPage").val()); 
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
	 alert("<%=CommonLang.msg("MSG163") %>  ");  
}

function kepOnload() {
	<% if ("".equals(_CRUD)){%>
		kepNoSetCalender("startDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
		kepNoSetCalender("endDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
		$("#startDate").val(kepToMonthAdd('1','M'));
	<%}else{%>	
		kepNoSetCalender("startDate",""); // 초기 시작하자마 해당 ID에 달력세팅
		kepNoSetCalender("endDate",""); // 초기 시작하자마 해당 ID에 달력세팅
	<%}%>

	if(document.forms.searchForm.st_checkbox_appr.checked == true){
		$("#st_appr_yn").val("Y");
	}else{
		$("#st_appr_yn").val("N");
	}
	
	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	<% if ("Y".equals(mailOpen) && !"".equals(session_st_gw_no) && "Y".equals(userGwNoFlag)){%>	
		openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%=buyer%>&DOCU_NO=<%=session_st_gw_no%>&PASS_TP=1&FLAG=RECV' ,'1200,700,no');
		kepSearch(1);
	<%}%> 
	var st_appr_gbn = "<%=st_appr_gbn%>";//메인 구매요청, 구매발주 타입일 경우 자동 조회
	if(st_appr_gbn=="PR"||st_appr_gbn=="PX"){
		kepSearch(1);
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#startDate").val(),$("#endDate").val()) == false) return;

	if (kepGetDateDiff('startDate','endDate','D') > 184 ){
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//document.forms.searchForm.st_check.value = ser;
	if (curPage == ""){		
	}else{
	document.forms.searchForm.curPage.value = curPage;
	}
	
	if(document.forms.searchForm.st_checkbox_appr.checked == true){
		$("#st_appr_yn").val("Y");
	}else{
		$("#st_appr_yn").val("N");
	}
	$('#searchForm').attr("action", "/buyerNewPassRecvList.do").submit();
}

/**
 * FORM 을 초기화
 */
function reload(){
	kepReload("searchForm");
	
	kepNoSetCalender("startDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("endDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	$("#startDate").val(kepToMonthAdd('1','M'));
	
// 	kepSearch(-1);
	jspTableClean("table_list","8");
}
</script>