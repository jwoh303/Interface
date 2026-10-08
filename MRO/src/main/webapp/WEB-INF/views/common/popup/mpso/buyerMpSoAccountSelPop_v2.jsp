<%--
**********************************************
* 메뉴 : 
* 화면 : 계정선택
* 기능 : 예산을 사용하는 고객사의 경우 장바구니에 입력될 계정코드를 선택하기 위한 팝업
* 프로그램 ID :  
* 담당자 : 최찬규
* 착수일 : 2026-05-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@include file="../../include/head_v2.jspf" %>
</head>
<style>
	.TableTHTDBottom1px th{
		line-height:0.5;
	}
	.TableTHTDBottom1px td{
		line-height:1.2;
		white-space: normal;
		word-break:break-word;
		font-size: 15px;
	}
</style>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과     

SessionInfo _sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"),CommonUtil.nvl((String) request.getParameter("st_com_code")));
 
String dept_code = CommonUtil.nvl((String) request.getParameter("dept_code"),"");  //  (조회조건)
String cart_sum_price = CommonUtil.nvl((String) request.getParameter("st_cart_sum_price"),"0");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
  
String SessionUserDept      = _sessionInfoPop.getDepartment();
String SessionUserDeptName  = _sessionInfoPop.getDepartmentName();
String SessionUserId  = _sessionInfoPop.getUserId();

String st_budget_dept = CommonUtil.nvl((String) request.getParameter("st_budget_dept"),"");  //  (조회조건)
String st_account = CommonUtil.nvl((String) request.getParameter("st_account"),"");  //  (조회조건)

String st_categ = CommonUtil.nvl((String) request.getParameter("st_categ"),"");  //  (조회조건)
String st_categ_acnt_set = CommonUtil.nvl((String) request.getParameter("st_categ_acnt_set"),"N");  //  (조회조건)
String st_search_set = CommonUtil.nvl((String) request.getParameter("st_search_set"),"N");  //  (조회조건)
String st_account_flg = CommonUtil.nvl((String) request.getParameter("st_account_flg"), null);  //  (조회조건)

int rec_cnt = 0;

%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view(){
// 예산부서, 예산계정 셀렉트박스 선택 형식
	<% if("N".equals(st_search_set)){%>
	$("#st_budget_dept").change(function(){
		kepSearch();
	});
	
	$("#st_account").change(function(){
		kepSearch();
	});
	<%}%>
// 자동조회
<% if ("Y".equals(open)){%>
	kepSearch();
<%}%>
}

function kepSearch(){
	<% if("Y".equals(st_search_set)){%>
		var budget_search = document.forms.buyerMpSoAccountSelPop.st_budget_dept.value;
		var account_search = document.forms.buyerMpSoAccountSelPop.st_account.value;

	    if(budget_search == "" && account_search == ""){
	        //조회조건을 선택해주세요.
	        var text = "<%=CommonLang.msg("MSG884")%>";
	    	openLayerPopText2(text,but1text,but1func,but1width);
	      	return;
	        return;
	    }
	    else{
			$('#buyerMpSoAccountSelPop').attr("action", "/mpso/getBuyerMpSoAccountSelPop.do").submit();
	    }
    <%}else{%>
		$('#buyerMpSoAccountSelPop').attr("action", "/mpso/getBuyerMpSoAccountSelPop.do").submit();
	<%}%>
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

function overBdgt(value1,value2){ 
	//해당 계정의 사용가능금액이 부족합니다.\n다른 가능한 계정을 선택하시기 바랍니다
	var text = "<%=CommonLang.msg("MSG883")%>";
	openLayerPopText2(text,but1text,but1func,but1width);
  	return;
}
</script> 
<body onload="kep_onload_view()">
<form name="buyerMpSoAccountSelPop" id="buyerMpSoAccountSelPop" method=post >
	<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="st_com_code"		value="<%=com_code%>">
	<input type="hidden" name="st_dept_code"		value="<%=SessionUserDept%>">
	<input type="hidden" name="st_cart_sum_price"		value="<%=cart_sum_price%>">
	<input type="hidden" name="st_categ_acnt_set"		value="<%=st_categ_acnt_set%>">
	<input type="hidden" name="st_categ"		value="<%=st_categ%>">
	<input type="hidden" name="st_search_set"		value="<%=st_search_set%>">
	<input type="hidden" name="st_account_flg"		value="<%=st_account_flg%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE907")%><!-- 계정선택 --><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Popup_GrayBox mt05 font17px font600" > <span class="ChipsDark_Black mr10"><%=CommonLang.get("HTITLE323")%><!-- 부서명 --> : </span><%=SessionUserDeptName%></div> 
  <table class="PopTableThLTdL mt10" width="100%">
    <colgroup>
      <col width="13%" />
      <col width="37%" />
      <col width="13%" />
      <col width="37%" />
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></th>
      <% if("Y".equals(st_search_set)){%>
      	<td><select id="st_budget_dept" name="st_budget_dept" class="Select40" style="width:233px;">
          <%
			Map<String, String> _map = new HashMap<String, String>();
				_map.put("BUYER", com_code);
				_map.put("TYPE", "DTOD");
				_map.put("CODE1", SessionUserDept);
			%>
			<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetDept","SEL",_map,st_budget_dept) %>
        	</select>
	      </td>
	      <th><%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
	      <td><select id="st_account" name="st_account" class="Select40" style="width:240px;">
	          <%
				Map<String, String> _map2 = new HashMap<String, String>();
					_map2.put("BUYER", com_code);
					_map2.put("TYPE", "DTOA");
					_map2.put("CODE1", SessionUserDept);
				%>
				<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetAccount","SEL",_map2,st_account) %>
	        </select>
	      </td>
      <%}else{ %>
      	<td><select id="st_budget_dept" name="st_budget_dept" class="Select40" style="width:233px;">
          <%
			Map<String, String> _map = new HashMap<String, String>();
				_map.put("BUYER", com_code);
				_map.put("TYPE", "DTOD");
				_map.put("CODE1", SessionUserDept);
			%>
			<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetDept","ALL",_map,st_budget_dept) %>
        	</select>
	      </td>
	      <th><%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
	      <td><select id="st_account" name="st_account" class="Select40" style="width:240px;">
	          <%
				Map<String, String> _map2 = new HashMap<String, String>();
					_map2.put("BUYER", com_code);
					_map2.put("TYPE", "DTOA");
					_map2.put("CODE1", SessionUserDept);
				%>
				<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetAccount","ALL",_map2,st_account) %>
	        </select>
	      </td>
      <%} %>
      
    </tr>
  </table>
  <div class="PopupListBtnBox_Center mt15">
  	<% if("Y".equals(st_search_set)){%>
		<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:kepSearch(); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  	<%} %>
  </div> 
  <div class="ScrollBox borderTop01 mt10 borderbottom01_de" style="height:340px;">
    <table class="TableTHTDBottom1px" style="width:100%">
      <colgroup>
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="12%" /> 
        <col width="14%" /> 
        <col width="14%" /> 
      </colgroup> 
      <thead> 
      <tr style="cursor: default;">
        <th rowspan="2"><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></th>
      	<th rowspan="2"><%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
      	<th rowspan="2"><%=CommonLang.get("HTITLE916")%><!-- 관리부서 --></th>
      	<th rowspan="2"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
		<th><%=CommonLang.get("HTITLE430")%><!-- 예산금액 --></th>
		<th><%=CommonLang.get("HTITLE908")%><!-- 사용가능금액 --></th>
      </tr>
      <tr style="cursor: default;">
		<th><%=CommonLang.get("HTITLE909")%><!-- 사용금액 --></th>
		<th><%=CommonLang.get("HTITLE910")%><!-- 장바구니 금액 --></th>
      </tr>
      </thead>
      <tbody>
      <%if (_dataList == null){%>
	  	<tr style="cursor: default;">
        	<td colspan="6" align="center" height="256px;">
        		<span class="font1"><%=CommonLang.msg("MSG558") %><!-- 조회 조건을 확인 후 조회 버튼을 클릭하여 주시기 바랍니다. --></span>
			</td>
      	</tr>
	  <%}else if(_dataList.size() == 0) {%>
	  	<tr style="cursor: default;">
        	<td colspan="6" align="center" height="256px;">
        		<span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
			</td>
      	</tr>
	  <%}else{ %>
       	<input type="hidden" id="tot_cnt" name="tot_cnt" value="<%=_dataList.size()%>">
	  	<%for(int j = 0 ; j<_dataList.size(); j++) {%>
	  		<%Map<String,String> rowData = _dataList.get(j);%>
	  		<tr style="cursor: default;">
	  			<td rowspan="2" style="text-align: left">
	  			<input type="hidden" name="st_dept_code" id="st_dept_code<%=j %>"		value="<%=rowData.get("DEPT_CODE")%>">
				<input type="hidden" name="st_account_type"	id="st_account_type<%=j %>"	value="<%=rowData.get("ACCOUNT_TYPE")%>">
				<input type="hidden" name="st_plan_amt_flag" id="st_plan_amt_flag<%=j %>"	value="<%=rowData.get("PLAN_AMT_FLAG")%>">
        		<%  // 예산적용 계정인데 비적용처럼 보이게 하는 경우
				 if(rowData.get("VIEW_FLAG").equals("N")) {
				%>
					<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','0', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>','<%=rowData.get("MGMT_NO_REQ_YN")%>');self.close();"><%=rowData.get("DEPT_CODE")%> / <%=rowData.get("DEPT_NAME")%></a>
				<%	// 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
				} else	if( rowData.get("BDGT_FLAG2").equals("N") ||  (rowData.get("BDGT_FLAG2").equals("Y") && Double.parseDouble(rowData.get("AVAIL_AMT")) >= Double.parseDouble((cart_sum_price)))  ){
				%>
					<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>','<%=rowData.get("MGMT_NO_REQ_YN")%>');self.close();"><%=rowData.get("DEPT_CODE")%> / <%=rowData.get("DEPT_NAME")%></a>	
				<%
				} else {	// 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정	
				%>
					<a href="javascript:overBdgt();"><%=rowData.get("DEPT_CODE")%> / <%=rowData.get("DEPT_NAME")%></a>
				<%
				}
				%>
        		</td>
        		<td rowspan="2" style="text-align: left">
        		<%  // 예산적용 계정인데 비적용처럼 보이게 하는 경우
				 if(rowData.get("VIEW_FLAG").equals("N")) {
				%>
					<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','0', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>','<%=rowData.get("MGMT_NO_REQ_YN")%>');self.close();"><%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_NAME")%></a>
				<%	// 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
				} else if( rowData.get("BDGT_FLAG2").equals("N") ||  (rowData.get("BDGT_FLAG2").equals("Y") && Double.parseDouble(rowData.get("AVAIL_AMT")) >= Double.parseDouble((cart_sum_price)))  ){
				%>
					<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>','<%=rowData.get("MGMT_NO_REQ_YN")%>');self.close();"><%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_NAME")%></a>	
				<%
				} else {	// 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정	
				%>
					<a href="javascript:overBdgt();"><%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_NAME")%></a>
				<%
				}
				%>
        		</td>
        		<td rowspan="2" style="text-align: left">
        		<% // 예산적용 계정인데 비적용처럼 보이게 하는 경우
				 if(rowData.get("VIEW_FLAG").equals("N")) {
				%>	
					<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','0', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>','<%=rowData.get("MGMT_NO_REQ_YN")%>');self.close();"><%=rowData.get("MNG_DEPT_CD")%> / <%=rowData.get("MNG_DEPT_NM")%></a>
				<%	// 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
				} else if( rowData.get("BDGT_FLAG2").equals("N") ||  (rowData.get("BDGT_FLAG2").equals("Y") && Double.parseDouble(rowData.get("AVAIL_AMT")) >= Double.parseDouble((cart_sum_price)))  ){
				%>
					<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>','<%=rowData.get("MGMT_NO_REQ_YN")%>');self.close();"><%=rowData.get("MNG_DEPT_CD")%> / <%=rowData.get("MNG_DEPT_NM")%></a>	
				<%
				} else {	// 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정	
				%>
					<a href="javascript:overBdgt();"><%=rowData.get("MNG_DEPT_CD")%> / <%=rowData.get("MNG_DEPT_NM")%></a>
				<%
				}
				%>
				</td>
				<td rowspan="2" style="text-align: left">
					<%=rowData.get("REMARK")%>
				</td>
				<td style="text-align: right">
					<% if(rowData.get("VIEW_FLAG").equals("N")){ %>
						0 
					<% } else { %>
						<%=CommonUtil.formatNumber(rowData.get("PLAN_AMT"),true,0,3)%>
					<% } %>
				</td>
				<td style="text-align: right">
				<%=(rowData.get("BDGT_FLAG2").equals("N") || rowData.get("VIEW_FLAG").equals("N"))?"<span class='font500 font15px F6495F pt05'>*</span>":""%>
				
				<% if(rowData.get("VIEW_FLAG").equals("N")){ %>
					 0 
				<% } else { %>
					<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),true,0,3)%>
				<% } %>
				</td>
			</tr>
			<tr style="cursor: default;">
				<td style="text-align: right">
					<% if(rowData.get("VIEW_FLAG").equals("N")){ %>
						0 
					<% } else { %>
						<%=CommonUtil.formatNumber(rowData.get("RESULT_TEMP_AMT"),true,0,3)%>
					<% } %>
				</td>
				<td style="text-align: right">
					<%=CommonUtil.formatNumber(cart_sum_price,true,0,3)%>
				</td>
			</tr>
        <%} %>
	  <%} %>         
      </tbody>
    </table>
  </div>
  <div class="PopupListBtnBox mt20">
    <div class="fl left font16px font600">※ <%=CommonLang.msg("MSG531")%><!-- 사용가능금액이 --> <font color="red">*</font> <%=CommonLang.msg("MSG532")%><!-- 0 인 계정은 선택시 예산 미적용 계정으로 처리됩니다. --></span></div>
  </div>  
</div><!-- wrapPopup 끝-->
</form> 
</body>
</html>
