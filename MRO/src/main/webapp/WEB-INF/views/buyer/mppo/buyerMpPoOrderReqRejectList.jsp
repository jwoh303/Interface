<%--
**********************************************
* 메뉴 : 발주관리>구매요청반려조회
* 화면 : 구매요청반려조회
* 기능 : 구매요청 반려한 구매요청건을 조회할 수 있다.
* 프로그램 ID : PG_06_B_017_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<% 
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수) 
	  
      
    String curDate   = CommonUtil.formatDateNoDateGubun(new Date(),1);
    String st_from_date  = "";
    String st_to_date    = "";
    st_from_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
    if( st_from_date.equals("")){    	
    	st_from_date    = CommonUtil.addDate(new Date(),"M",-1,1);
    	st_from_date = CommonUtil.formatStrinigDate(st_from_date);
    }else{
    	st_from_date    = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");    	
    }
    
    
    st_to_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
    if( st_to_date.equals("")){    	
    	st_to_date    = CommonUtil.formatDateNoDateGubun(new Date(),1);
    	st_to_date = CommonUtil.formatStrinigDate(st_to_date);
    }else{
    	st_to_date    = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");    	
    } 
    
    
    String req_dept_name        = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),""); 
    String req_dept_code        = CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),""); 
    String pr_no        = CommonUtil.nvl((String) request.getParameter("st_pr_no"),""); 
    String ref_no        = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");
    String st_po_user_id        = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),"");
    
	String buyer             = "";
	String SessionComCode             = "";
	String SessionUserDept          = "";
	String SessionUserId            = "";
	String row_cnt = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		buyer             = sessionInfo.getComCode();      
		SessionComCode             = sessionInfo.getComCode();      
		SessionUserId            = sessionInfo.getUserId();
		SessionUserDept          = sessionInfo.getDepartment();
		row_cnt = sessionInfo.getRowCnt(); //20070704 추가 페이지 기본 개수
	}
	
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수  
	//SLOGIC-BEGIN(P06-0000065)
	//요청자 검색조건 조건
	String p060000065 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000065","COL01_DATA");
 	//고객사 그룹통합여부 여부
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, buyer);
	String group_mng_flag = "N";
	String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_com_code2"),"");  // 계열사정보
	if(getCodeTGCM == true){
		group_mng_flag = "Y"; 
	}
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE248") %><!-- 구매요청반려조회 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		<span class="btn_reset" title="초기화"><a href="javascript:doAction('kep_reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
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
		<input type = "hidden" name = "st_buyer"    value="<%=SessionComCode%>"> 
		<input type = "hidden" name = "st_UserDept"    value="<%=SessionUserDept%>"> 
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<div id="cont_searchA">	
			<table class="cont_t_list01"  >
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
				<%
					if(p060000065.equals("Y")){
				%>
					<th><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></th>
					<td>
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:10%; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>-
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:10%; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>  
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>			
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>	
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>				
					</td>
					<th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
					<td>
							<select name = "st_po_user_id" id="st_po_user_id" style="width:90%;height:20px;"></select>
					</td>
					<%if(group_mng_flag.equals("Y")){%>
					     <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
					      <td >
					        <select name="st_com_code2" id="st_com_code2" style="width:90%;height:20px;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
					        </select>
					      </td>
					<%}else{%>
					      <th></th>
					      <td ><input type="hidden" name="st_com_code2" id="st_com_code2" value="${sessionInfo.comCode}"></td>
					 <%}%>
				<%
					}else{
				%>
					<th><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></th>
					<td colspan="3">
						<input type="hidden" name="st_po_user_id" id="st_po_user_id" value="">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>-
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>  
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>			
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>					
					</td>	
					<%if(group_mng_flag.equals("Y")){%>
					     <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
					      <td >
					        <select name="st_com_code2" id="st_com_code2" style="width:90%;height:20px;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
					        </select>
					      </td>
					<%}else{%>
					      <th></th>
					      <td ><input type="hidden" name="st_com_code2" id="st_com_code2" value="${sessionInfo.comCode}"></td>
					 <%}%>
				<%
					}
				%>                       
				</tr>
				<tr>
					<th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
					<td >
						<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="<%=req_dept_name%>" READONLY>
						<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="<%=req_dept_code%>">
						<a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
                       	<th><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_pr_no" id="st_pr_no" style="width:87%;" value="<%=pr_no%>" onkeyup="kepToUpper('st_pr_no')" onKeyDown="kepEnter()">
						</td>   
						<th><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_ref_no" id="st_ref_no" style="width:87%;" value="<%=ref_no%>" onkeyup="kepToUpper('st_ref_no')" onKeyDown="kepEnter()">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option <%=(onepagerow.equals("10") ? "selected" : "")%> value = "10">10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("20") ? "selected" : "")%> value = "20">20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("30") ? "selected" : "")%> value = "30">30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("40") ? "selected" : "")%> value = "40">40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("50") ? "selected" : "")%> value = "50">50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
			</select>
      	</span>       
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" >
			<colgroup>
			<%if(group_mng_flag.equals("Y")){%>
				<col width="8%" />
			<%}%>
	            <col width="12%" />
	            <col width="12%" />
	            <col width="*" />
	            <col width="5%" />
	            <col width="5%" />
	            <col width="12%" />
	            <col width="12%" />
	        </colgroup>
	        <thead>
				<tr>
				<%if(group_mng_flag.equals("Y")){%>
						<th scope="col"><%=CommonLang.get("HTITLE290") %><!-- 고객사코드 --><br><%=CommonLang.get("HTITLE291") %><!-- 고객사명 --></th>
				<%}%>
				<%
					if(p060000065.equals("Y")){
				%>
				  <th scope="col" ><%=CommonLang.get("HTITLE249") %><!-- 요청부서/요청자 --><br><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></th>
				<%
					}else{
				%>
				  <th scope="col" ><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --><br><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></th>
				<%
					}
				%>
				  <th scope="col" ><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --><br><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE52") %><!-- 단위 --><br><%=CommonLang.get("HTITLE45") %><!-- 수량 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE243") %><!-- 납기요청일 --><br><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --><br><%=CommonLang.get("HTITLE250") %><!-- 결재유무/사유 --></th>
				</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="8" align="center" height = "50"> 
                        <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
       <tr align="center" bgcolor="<%=tclass%>">
			<%if(group_mng_flag.equals("Y")){%>
				<td title="고객사코드/고객사명">
					<%=rowData.get("BUYER")%><br><%=rowData.get("BUYER_NAME_LOC")%>
				</td>
			<%}%>
			<%
				if(p060000065.equals("Y")){
			%>
			    <td title="요청부서/요청자/요청번호">
            	<a class="hyperLink" href="javascript:getNewDepartmentDisplayPop('<%=SessionComCode%>','<%=rowData.get("CHANGE_USER_DEPT")%>');"><%=rowData.get("REQ_DEPT")%></a>/<%=rowData.get("REQ_USER_NM")%><br>
			<%
				}else{
			%>
				<td title="요청부서/요청번호">
				<a class="hyperLink" href="javascript:getNewDepartmentDisplayPop('<%=SessionComCode%>','<%=rowData.get("CHANGE_USER_DEPT")%>');"><%=rowData.get("REQ_DEPT")%></a><br>
			<%
				}
			%>
            <a class="hyperLink" href="javascript:getPrDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("RECV_FLAG")%>');"><%=rowData.get("PR_NO")%></a>
          </td>
          <td title="품목코드/요청일">
            <a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
            <br><%=CommonUtil.formatStrinigDate(rowData.get("CHANGE_DATE"))%>
          </td>
          <td title="품목명/규격" class="left">
            <%=rowData.get("DESCRIPTION")%><br><%=rowData.get("SPECIFICATION")%>
         </td>
         <td title="단위/수량" class="right">
            <%=rowData.get("UNIT_MEASURE")%><br>
                    <%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>
          </td>
          <td  title="단가/금액" class="right">
                    <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br>
                    <%=CommonUtil.formatNumber(rowData.get("AMT"),true,0,3)%>
          </td>
          <td title="납기요청일/협력사">
           			<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br>
           			<a class="hyperLink" href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT_NAME")%></a>
          </td>
          <td title="관리번호/결재유무">

            <%=rowData.get("REF_PR_NO")%><br>
<% if(rowData.get("RETURN_REASON").equals("ALL")) { %>
                <%=rowData.get("GUYLJAE_FLAG")%>&nbsp;/&nbsp;<img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0">
<% }else { %>
                <%=rowData.get("GUYLJAE_FLAG")%>&nbsp;/&nbsp;<a href="javascript:setReturnReason('<%=rowData.get("RETURN_REASON")%>');"><img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"></a>
<% } %>
          </td>

        </tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
		</p>  
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
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

var selectedRow = "";

//최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date"); 
	setUserList("load" , "");
}

var st;
//기능함수
function doAction(str) {
		
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break; 
		 
	case "kep_reload":	 //초기화
		kep_reload();
		break; 
		 
		
	}
}

// 조회
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 184 ){
		//MSG494
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code2.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.curPage.value = curPage; 
	<%if(p060000065.equals("Y")){%>
		document.forms.searchForm.st_UserDept.value ="";
	<%}%>
	$('#searchForm').attr("action", "/mppo/getBuyerMpPoOrderReqRejectList.do").submit();   
}

function getDepartmentCode(){ 
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code=<%=SessionComCode%>", "500,500,no"); 
} 

function setPopupReturn(code, text) { 
		document.forms.searchForm.st_req_dept_code.value = code;
		document.forms.searchForm.st_req_dept_name.value = text; 
}

function kep_reload(){
	 
	document.forms.searchForm.st_req_dept_code.value = ""; 
	document.forms.searchForm.st_req_dept_name.value = "";
	document.forms.searchForm.st_pr_no.value = "";
	document.forms.searchForm.st_ref_no.value = "";
	
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
	
// 	kepSearch(-1);
	jspTableClean("table_list","7");
	
}


function getPrDisplayPop(BUYER,PR_NO,RECV_FLAG){  	
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&st_flag=&enter_flag=&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
	
} 
function getNewDepartmentDisplayPop(st_com_code,st_dept){ 
	openSearchPopup('/coco/getCommonCoCoDepartmentDetailViewPop.do','?openYn=Y&st_com_code='+st_com_code+'&st_dept='+st_dept , "400,143,no"); 
}  
function setReturnReason(return_reason)
{

  if(return_reason == "ALL")
  {
     return;
  }else {
	  
	  openSearchPopup('/common/reasonPop.do','?openYn=Y&reason='+return_reason , "500,180,no"); 
        //var loc = "/kr/customer/proxybuy/pr_recv_reject_reason_view.jsp?st_return_reason="+return_reason; 
        return;     
  }
}
//요청자셋팅.
function setUserList(type , user_type){
	var po_user_id = "";
	<% if(st_po_user_id == null){%>
    	po_user_id = "<%=SessionUserId%>";
    <%}else{%>
		po_user_id = "<%=st_po_user_id%>";
    <%}%>
    var buyer = "<%=SessionComCode%>"; 
    kepAjaxCommonQueryIdSearchCombo("st_po_user_id","buyer.mppo.getUserList2",buyer,"ALL",po_user_id);
}
</script>
</html>
