<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 VOC 처리결과
* 기능 : 고객사 VOC 처리결과
* 프로그램 ID :  
* 담당자 : CEJ 
* 착수일 : 2014-09-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %>
</head>
<% 
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_buyer_groups = CommonUtil.nvl((String) request.getParameter("st_buyer_groups"),"");
	String st_pur_user_id = CommonUtil.nvl((String) request.getParameter("st_pur_user_id"),"");
	String st_pur_user_name = CommonUtil.nvl((String) request.getParameter("st_pur_user_name"),"");
	String st_pur_dept_code = CommonUtil.nvl((String) request.getParameter("st_pur_dept_code"),"");
	String st_pur_dept_name = CommonUtil.nvl((String) request.getParameter("st_pur_dept_name"),"");
	String toDate      =  CommonUtil.nvl((String) request.getParameter("toDate"),"");  
	String fromDate    = CommonUtil.nvl((String) request.getParameter("fromDate"),"");  
	toDate = toDate.replaceAll("/","");
	fromDate = fromDate.replaceAll("/","");
	
	if ("".equals(toDate)){
		toDate      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
	}
	if ("".equals(fromDate)){
		fromDate    =  CommonUtil.addDate(new Date(),"M",-1,1);
	}
	 //SLOGIC-END
	 
 	String st_recv_flag = CommonUtil.nvl((String) request.getParameter("st_recv_flag"),"");   
	String st_claim_master = CommonUtil.nvl((String) request.getParameter("st_claim_master"),"");   
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String sessionComCode = "";
	String sessionComName = "";
	String sessionUserId = "";
	
	if (sessionInfo != null){ 
		sessionComName =  CommonUtil.nvl((String)sessionInfo.getComNameLoc());
		sessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId());
		sessionComCode  = CommonUtil.nvl((String)sessionInfo.getComCode());
	}
	
	// 특수로직 관리자 판단(여러명은 ^로 구분), ICOMCOD3.TYPE=VOC 에 관리할 고객사 등록 필요
	String p140000001 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P14-0000001","COL01_DATA");
	
	String from_year1   = fromDate.substring(0,4);
    String from_month1  = fromDate.substring(4,6);
    String from_day1    = fromDate.substring(6,8);
    String v_fromDate   = from_year1+"/"+from_month1+"/"+from_day1;
    String to_year1   = toDate.substring(0,4);
    String to_month1  = toDate.substring(4,6);
    String to_day1    = toDate.substring(6,8);
    String v_toDate   = to_year1+"/"+to_month1+"/"+to_day1; 
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
	<h3><%=CommonLang.get("HTITLE739") %><!-- 고객센터 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회" ><a href="javascript:doAction('search','');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		<span class="btn_reset" title="초기화" ><a href="javascript:doAction('reload','');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_buyer_gubun" id="st_buyer_gubun" value="" /> 
		 
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption>조회</caption>
				<colgroup>
				    <col width="8%" />
				    <col width="42%" />
				    <col width="8%" />
				    <col width="42%" />
				</colgroup>
				
				<tbody>
				<tr>
				<th><%=CommonLang.get("HTITLE650") %><!-- 요청일자 --></th>
				<td>
						<input type="text" class="input_type_text" name="fromDate" id="fromDate" readOnly style="width:15%;text-align:center;" value="<%=v_fromDate%>"> - 
                        <input type="text" class="input_type_text" name="toDate" id="toDate" readOnly style="width:15%;text-align:center;"  value="<%=v_toDate%>"> 
                        <span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>		
						<span class="btn_month"><a href="javascript:setCurMonth('fromDate','toDate')">당월</a></span>	
				</td>
				<th><%=CommonLang.get("HTITLE136") %><!-- 진행상태 --></th>
				<td>
				<select id="st_recv_flag" name="st_recv_flag"  style="width:82%">
											<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("TYPE","VC02"); 
								%>
								<%= CommonUtil.getCodeComboQueryIdList("buyerMain.getSrsysType","ALL",_map,st_recv_flag) %>		 
				</select>
				</td>
				</tr>
				<tr>
					<th><%=CommonLang.get("HTITLE501") %><!-- VOC 유형 --></th>
					<td>
						<select id="st_claim_master" name="st_claim_master"  style="width:82%">
				 											<% 
						 			_map.put("TYPE","VC03"); 
								%>
								<%= CommonUtil.getCodeComboQueryIdList("buyerMain.getSrsysType","ALL",_map,st_claim_master) %>		 
						</select>								
					</td>
					<th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
<%
	if(p140000001.indexOf(sessionUserId) > -1) {
%>
					<td>
					 	<select id="st_buyer_groups" name="st_buyer_groups" title="고객사" style="width:82%;" onChange="setChangeComcode(this.value)">
					 		<!-- 대상 고객사들 ICOMCOD3, TYPE = 'VOC' 에 추가 필요 -->
							<%= CommonUtil.getCode3ComboList(sessionComCode, "ALL", "VOC", sessionUserId, "ICOMCOD3", st_buyer_groups, "") %>
						</select>
					</td>
					<tr>
						<th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_pur_user_name" id="st_pur_user_name" style="width:66%;ime-mode:active" value="<%=st_pur_user_name%>" READONLY>
							<input type="hidden" name="st_pur_user_id" id="st_pur_user_id" value="<%=st_pur_user_id%>">
							<a href="javascript:getUserSelect();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_pur_user_id','st_pur_user_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
						<th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_pur_dept_name" id="st_pur_dept_name" style="width:66%;ime-mode:active" value="<%=st_pur_dept_name%>" READONLY>
							<input type="hidden" name="st_pur_dept_code" id="st_pur_dept_code" value="<%=st_pur_dept_code%>">
							<a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_pur_dept_code','st_pur_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
					</tr>
<%
	}
	else{
%>
					<td>
					 	<%=sessionComName %>
					</td>
<%
	}
%>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "15" <%if ("15".equals(onepagerow)) {%>selected<%} %>>15<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
			</select>
      	</span>       
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_query" id="st_query" value="" />
	  	
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="5%" />
	            <col width="10%" />
	            <col width="10%" /> 
	            <col width="10%" /> 
	            <col width="10%" /> 
	            <col width="10%" /> 
	            <col width="10%" /> 
	            <col width="10%" /> 
	            <col width="10%" /> 
	            <col width="*" /> 
	        </colgroup>
	        <thead>
			<tr>
               <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>                
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
							
<%} %>
				</th> 
                <th scope="col"><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE801") %><!-- 접수번호 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE501") %><!-- VOC 유형 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE133") %><!-- 요청자 --><br><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE136") %><!-- 진행상태 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE650") %><!-- 요청일자 --><br><%=CommonLang.get("HTITLE647") %><!-- 접수일자 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE802") %><!-- 처리일자 --><br><%=CommonLang.get("HTITLE803") %><!-- 담당자 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --><br><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE804") %><!-- 처리만족도 --></th>
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
	Map<String,String> rowData = null;
	for (int j=0; j<_gridList.size(); j++) {
		rowData = _gridList.get(j);
		String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		
%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td   class="center">
		            <input type="checkbox" name="lnCheck<%=j%>">
		            <input type="hidden" name="st_vc_no" value="<%=rowData.get("VC_NO")%>">
		            <input type="hidden" name="st_buyer" value="<%=rowData.get("BUYER")%>">
		            <input type="hidden" name="st_req_user_id" value="<%=rowData.get("REQ_USER_ID")%>">            
            
	            </td>
	            <td><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></td>	            
	            <td><a class="hyperLink" href="javascript:goBuyerDetailDisplay('<%=rowData.get("VC_NO")%>', '<%=rowData.get("BUYER")%>', '<%=rowData.get("REQ_USER_ID")%>', '<%=rowData.get("REQ_DEPT_CODE")%>');" ><%=rowData.get("VC_NO")%></a></td>
	        <% if("".equals(CommonUtil.nvl(rowData.get("CLAIM_TYPE_TEXT")))){ %> 
	            <td align="left"><%=CommonUtil.nvl(rowData.get("CLAIM_TEXT"))%></td> 
	        <%  }else{  %>  
	            <td align="left"><%=CommonUtil.nvl(rowData.get("CLAIM_TEXT"))%>(<%=CommonUtil.nvl(rowData.get("CLAIM_TYPE_TEXT"))%>)</td>  	
	        <%  }  %>
	        	<td>
	        		<%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%>
	        		<br>
	        		<%=CommonUtil.nvl(rowData.get("REQ_USER_DEPT"))%>
	        	</td>
	            <td><%=CommonUtil.nvl(rowData.get("RECV_FLAG_TEXT"))%></td>
	            <td>
	            	<%=CommonUtil.formatStrinigDate(rowData.get("REQ_DATE"))%>
	            	<br>
	            	<%=CommonUtil.formatStrinigDate(rowData.get("CD_DATE"))%>
	            </td>
	            <td>
	            	<%=CommonUtil.formatStrinigDate(rowData.get("DF_DATE"))%>
	            	<br>
	            	<%=CommonUtil.nvl(rowData.get("DS_USER_NAME"))%>
	            </td>
	            <td>
					<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
					<%=((!"".equals(rowData.get("PO_NO"))) && (!"".equals(rowData.get("BUYER_ITEM_NO"))) ? "<br>" : "")%>
					<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
				</td>
	            <td >
	        <% if(!"FB".equals(rowData.get("RECV_FLAG"))){ %> 
	        	  <input type="hidden" name="st_rub_type" value="">
	        	  <input type="hidden" name="st_rub_flag" value="Y">
	        <%  }else if("A".equals(rowData.get("RUB_TYPE")) || "B".equals(rowData.get("RUB_TYPE")) ||  "C".equals(rowData.get("RUB_TYPE")) || "D".equals(rowData.get("RUB_TYPE")) || "F".equals(rowData.get("RUB_TYPE"))) {  %>
	              <%=CommonUtil.nvl(rowData.get("RUB_TEXT"))%>
	              <input type="hidden" name="st_rub_type" value="">
	              <input type="hidden" name="st_rub_flag" value="Y">
	        <%  }else{  %>
	        	<select name="st_rub_type" class="form_select">
	        	    <option value="" selected ><%=CommonLang.get("HTITLE805") %><!-- 만족도 평가 --></option>
		            <option value="A"><%=CommonLang.get("HTITLE806") %><!-- 매우만족 --></option>
					<option value="B"><%=CommonLang.get("HTITLE807") %><!-- 만족 --></option>
					<option value="C"><%=CommonLang.get("HTITLE808") %><!-- 보통 --></option>
					<option value="D"><%=CommonLang.get("HTITLE809") %><!-- 불만 --></option>
					<option value="F"><%=CommonLang.get("HTITLE810") %><!-- 매우불만 --></option>				
	           </select>   
	           <input type="hidden" name="st_rub_flag" value="N">     	
	        <%  }  %>	
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
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04" title="저장" >
					<a href="javascript:doAction('runProcess','');"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a> 
				</span>	 				
            </div>
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
var changeComCode = "<%=st_buyer_groups%>";
var admin_yn = "N";

// 최초 화면 함수 
function kep_onload_view(){
	kepSetCalender("fromDate");
	kepSetCalender("toDate");
	
	// 관리자 권한이면 세팅(구분자 ^ 로 존재함)
	if("<%=p140000001%>".indexOf("<%=sessionUserId%>") >= 0){
		admin_yn = "Y";
		$("#st_buyer_gubun").val("admin");
	}
}

var st;
//기능함수
function doAction(str , gubun) {
	
	switch (str) {
	case "search":	 //조회 
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		kepReload('searchForm');
/*		
		searchForm.reset();
	
		if(admin_yn == "Y"){
			document.forms.searchForm.st_buyer_groups.value = "";
			document.forms.searchForm.st_pur_user_id.value = "";
			document.forms.searchForm.st_pur_user_name.value = "";
			document.forms.searchForm.st_pur_dept_code.value = "";	
			document.forms.searchForm.st_pur_dept_name.value = "";
		}
		
		document.forms.searchForm.st_claim_master.value = "";
		document.forms.searchForm.st_recv_flag.value = "";	
*/
		kepSearch(-1);
		break; 
		
	case "runProcess": // 저장
		runProcess();
		break;   
  
	}
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

function runProcess() {  	  

    var tot_cnt       = $("#display_item_cnt").val();
    var checked_count = getCheckedRowCount(tot_cnt);
    var query   = "";
    
    if(checked_count == 0){
    	//선택된 항목이 없습니다.  \n\n 항목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG336") %>");
        return;
    }

    if(eval(tot_cnt) < 2) {
        var box         = eval("document.forms.contentForm.lnCheck"+0);
        var rub_type    = document.forms.contentForm.st_rub_type.value;
        var buyer       = document.forms.contentForm.st_buyer.value;
        var req_user_id = document.forms.contentForm.st_req_user_id.value;
        var vc_no       = document.forms.contentForm.st_vc_no.value;
        var rub_flag    = document.forms.contentForm.st_rub_flag.value;
          
        if(box.checked == true) {
			if(req_user_id != "<%=sessionUserId%>"){
				//해당 건의 요청자만 저장할 수 있습니다.
 	        	alert("<%=CommonLang.msg("MSG337") %>");
 	        	return;
 	        }
            if(rub_type == "ALL" || rub_type == ""){
            	//서비스 만족도를 평가해 주시기 바랍니다.
	             alert("<%=CommonLang.msg("MSG338") %>");
	             document.forms.contentForm.st_rub_type.focus();
	             return;
	        } 
	        if(rub_flag == "Y"){
	        	//등록대상 건이 아닙니다.  \n\n  만족도평가 대상만 선택해 주시기 바랍니다.
	             alert("<%=CommonLang.msg("MSG339") %>");
	            box.checked = false;
	            return;
	        }
            query = buyer + "@@" + vc_no + "@@" + req_user_id + "@@" + rub_type;
			query += "^||^";
        }
    }else {
        for(var k = 0; k < tot_cnt; k++) {

            var box         = eval("document.forms.contentForm.lnCheck"+k);
            var rub_type    = document.forms.contentForm.st_rub_type[k].value;			
            var vc_no       = document.forms.contentForm.st_vc_no[k].value;
            var buyer       = document.forms.contentForm.st_buyer[k].value;
            var req_user_id = document.forms.contentForm.st_req_user_id[k].value;
            var rub_flag    = document.forms.contentForm.st_rub_flag[k].value;
                       
            if(box.checked == true){
            	if(req_user_id != "<%=sessionUserId%>"){
            		//해당 건의 요청자만 저장할 수 있습니다.
     	        	alert("<%=CommonLang.msg("MSG337") %>");
     	        	return;
     	        }
                if(rub_type == "ALL"  || rub_type == ""){
                	//서비스 만족도를 평가해 주시기 바랍니다.
		             alert("<%=CommonLang.msg("MSG338") %>");
		             document.forms.contentForm.st_rub_type[k].focus();
		            return;
		        } 
		        if(rub_flag == "Y"){
		        	//등록대상 건이 아닙니다.  \n\n  만족도평가 대상만 선택해 주시기 바랍니다.
		             alert("<%=CommonLang.msg("MSG339") %>");
		             box.checked = false;
		            return;
		        }  
		        query += buyer + "@@" + vc_no + "@@" + req_user_id + "@@" + rub_type;
				query += "^||^";
				 
             }
         }
    }
    
    document.forms.contentForm.st_query.value = query; 
    
    //alert(  document.forms.contentForm.st_query.value);
    //선택하신 서비스만족도 평가로 등록하시겠습니까?
    if(confirm("<%=CommonLang.msg("MSG335") %>")){
		kepAjaxFormCall("/main/setCustomerRubUpdate.do","contentForm","SAVE");  
    }
}

function goBuyerDetailDisplay(vc_no, buyer, userid, dept){
	if(admin_yn == "Y"){
		openSearchPopup('/main/getCustomerCenterPop.do','?admin_yn=Y&vc_no='+vc_no+'&buyer='+buyer+'&userid='+userid+'&req_user_dept='+dept,'800,480,no');	
	}else{
		openSearchPopup('/main/getCustomerCenterPop.do','?admin_yn=N&vc_no='+vc_no,'800,480,no');
	}
	
}

//조회
function kepSearch(curPage){ 
	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return;  
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/main/getCustomerCenterList.do").submit();   
}
  
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	//만족도 평가가 완료되었습니다.  \n\n 더욱 향상된 서비스를 위해 노력하겠습니다.
	 alert("<%=CommonLang.msg("MSG340") %>");
 	// 처리후 재조회
 	kepSearch($("#curPage").val());
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//만족도 평가가 실패하였습니다. 다시 시도 부탁드립니다.
	 alert("<%=CommonLang.msg("MSG341") %>"); 
} 

function setPopupReturn(code, text1, text2, gubun){
	if(gubun == "dept"){
		document.forms.searchForm.st_pur_dept_code.value = code;
		document.forms.searchForm.st_pur_dept_name.value = text1;
	}else{
		document.forms.searchForm.st_pur_user_id.value = code;
		document.forms.searchForm.st_pur_user_name.value = text1;
	}
}

function setChangeComcode(comCode){
	document.forms.searchForm.st_pur_dept_code.value = "";
	document.forms.searchForm.st_pur_dept_name.value = "";
	
	document.forms.searchForm.st_pur_user_id.value = "";
	document.forms.searchForm.st_pur_user_name.value = "";
	
	changeComCode = comCode;
}

function getUserSelect(){
	if($('#st_buyer_groups').val() == ""){
		//고객사를 선택하여 주시기 바랍니다.
		alert("<%=CommonLang.msg("MSG342") %>");
		return;
	}
	openSearchPopup("/common/vocUserSelectPop.do", "?open=Y&com_code="+changeComCode, "550,500,no");
}

function getDepartmentCode(){
	if($('#st_buyer_groups').val() == ""){
		//고객사를 선택하여 주시기 바랍니다.
		alert("<%=CommonLang.msg("MSG342") %>");
		return;
	}
	openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+changeComCode, "500,500,no"); 
}

</script>
</html>
